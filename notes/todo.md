---
name: lit-review-api
description: Use when the user asks for a literature review, citation search, or annotated bibliography on a mainstream research topic well-covered by OpenAlex. Performs grounded retrieval via the OpenAlex API, verifies every DOI at Crossref, and drops unverified references rather than "fixing" them. Never returns citations from model memory.
allowed-tools: Bash
---

# Literature Review Skill (API-grounded, Path A)

## When to use

The user has asked for papers on a research question and wants a verified, citable bibliography --- not a conversational summary. Typical phrasings: "do a lit review on X", "find me recent papers on X", "build an annotated bibliography for my dissertation topic".

If the user instead hands you a draft bibliography and asks you to check it, use the companion skill `verify-citations` instead.

## Non-negotiable rules

1. Every returned citation must come from an OpenAlex API response, never from model memory.
2. Every returned citation must pass the Crossref DOI verification gate in Step 4.
3. If no results survive verification, report that honestly and stop. Never "fill in" with plausible-looking papers.

## Workflow

### Step 1. Clarify the query (at most one question)

If the user's question is vague (e.g., "papers on retail"), ask ONE clarifying question about scope: time window, discipline, or methodology. Then proceed. If the question is already specific, skip this step.

### Step 2. Query OpenAlex

URL-encode the search string and hit OpenAlex. OpenAlex is free, keyless, and covers ~250M scholarly works including the social sciences. Add a `mailto` parameter to stay in the polite pool.

```bash
QUERY="scarcity messaging online retail"
ENCODED=$(python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))" "$QUERY")
curl -s "https://api.openalex.org/works?search=$ENCODED&per_page=25&mailto=student@example.com" > results.json
```

Parse `results.json` with Python (stdlib only). For each result, extract:

- `id` (OpenAlex work ID)
- `doi`
- `title`
- `authorships[].author.display_name` (first author surname for the verification gate)
- `publication_year`
- `primary_location.source.display_name` (journal/venue)
- `cited_by_count`
- `abstract_inverted_index` (decode to plain text for the TL;DR)

### Step 3. Triage

Score each result 0--3 on relevance to the user's question. Keep entries with score ≥ 2. Drop the rest. Report how many were retrieved and how many survived triage.

### Step 4. Verify DOIs at Crossref (the verification gate)

For every entry that passed triage, fetch the full Crossref record and check metadata:

```bash
curl -s "https://api.crossref.org/works/$DOI" > crossref_verify.json
```

```python
import json, difflib

with open("crossref_verify.json") as f:
    data = json.load(f)

if "message" not in data:
    verdict = "DROP"  # DOI did not resolve
else:
    w = data["message"]
    cr_title  = w.get("title", [""])[0].lower()
    cr_author = (w.get("author") or [{}])[0].get("family", "").lower()
    cr_year   = (w.get("published", {}).get("date-parts") or [[None]])[0][0]
    cr_venue  = w.get("container-title", [""])[0].lower()

    title_ok  = difflib.SequenceMatcher(None, openalex_title.lower(), cr_title).ratio() >= 0.8
    author_ok = openalex_first_author.lower() == cr_author
    year_ok   = openalex_year == cr_year
    venue_ok  = openalex_venue.lower() in cr_venue or cr_venue in openalex_venue.lower()

    verdict = "KEEP" if all([title_ok, author_ok, year_ok, venue_ok]) else "DROP"
```

- All four fields match → keep.
- Any mismatch or non-200 → **drop the entry entirely.** Do not substitute or "fix".

Track how many entries were dropped at this gate.

### Step 5. Write the annotated bibliography

Produce a markdown file with this structure:

```
# Literature Review: <query>

**Retrieved:** N  |  **Kept after triage:** M  |  **Verified at Crossref:** K

## Verified references

1. Author, A., & Author, B. (2023). Title of the paper.
   *Journal Name*, 12(3), 45--67. [https://doi.org/<doi>](https://doi.org/<doi>)
   TL;DR: one-sentence summary from the abstract.

2. ...

## Disclosure

- Search date: YYYY-MM-DD
- Retrieval source: OpenAlex API (https://api.openalex.org)
- Verification source: Crossref API (https://api.crossref.org)
- Model: <model name>
- Retrieved: N  |  Kept after triage: M  |  Dropped at verification: N - K
```

### Step 6. Never invent

If zero entries survive verification, the output is:

> No verified references found for this query. This does not mean no papers exist --- it means the OpenAlex search did not surface any whose DOI resolves at Crossref. Try: broadening the query, widening the year window, or searching a different database.

Never, under any circumstance, list papers from model memory. The entire value of this skill is that every reference is traceable to a live API response.

## Notes for extending

- **Year filter:** append `&filter=from_publication_date:2020-01-01` to the OpenAlex URL.
- **Snowballing one hop:** for the top 3 verified papers, fetch `https://api.openalex.org/works/<id>` and pull `referenced_works` for backward citations.
- **Marketing journal filter:** append `&filter=host_venue.issn:XXXX-XXXX` for a specific journal ISSN.

---
name: verify-citations
description: Use when the user has a draft bibliography or list of citations from any source (web search, another LLM, a paper's reference section, a prior conversation, a file) and wants each entry verified against Crossref. Classifies every entry as VERIFIED, MISMATCH, or FABRICATED. Does NOT fix or substitute fabrications --- it flags them and leaves the decision to the user.
allowed-tools: Bash, Read
---

# Citation Verification Skill (Path B companion)

## When to use

A list of citations already exists and needs to be audited before it can be trusted. Typical scenarios:

- Claude Code just used web search to answer a lit-review question and produced a draft bibliography.
- The user pasted a reference list from a paper and asked "are these real?".
- Another LLM was asked for sources and the user is suspicious.
- An old bibliography needs to be re-checked for broken DOIs.

If the user has not yet retrieved any citations and wants a fresh lit review, use the companion skill `lit-review-api` instead.

## Non-negotiable rules

1. Every entry must be classified into exactly one of: VERIFIED, MISMATCH, FABRICATED.
2. Never "fix" a FABRICATED entry by substituting a similar-looking real paper. Flag it and stop.
3. Never downgrade a MISMATCH to VERIFIED because "it is close enough". Record what was wrong.

## Workflow

### Step 1. Parse the input

Accept any common format: APA, BibTeX, Chicago, plain text, or a markdown list. For each entry, extract:

- First author surname
- Year
- Title
- Venue (journal/conference name)
- DOI (if present)

If a field is missing, record it as `null` and proceed --- missing fields are informative.

### Step 2. Resolve DOIs at Crossref

For entries that have a DOI:

```bash
curl -s "https://api.crossref.org/works/$DOI" > crossref.json
```

Parse the JSON and check:

- First author surname: exact match (case-insensitive) against Crossref's `author[0].family`.
- Year: exact match against `issued.date-parts[0][0]`.
- Title: ≥ 80% fuzzy match against `title[0]` (use `difflib.SequenceMatcher` from Python stdlib).

Record which fields passed and which failed.

### Step 3. Fall back to title search for entries without a DOI

For entries with no DOI (or where the DOI returned HTTP 404), search Crossref by title:

```bash
ENCODED_TITLE=$(python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))" "$TITLE")
curl -s "https://api.crossref.org/works?query.title=$ENCODED_TITLE&rows=3" > fallback.json
```

For each of the top 3 hits, compare first author and year against the claimed citation. If any hit matches both, record its DOI as evidence.

### Step 4. Classify every entry

Apply these rules in order:

- **VERIFIED** --- DOI resolved at Crossref AND first author, year, title (≥80%), and venue all match. Or title-search found a hit where author + year + venue match.
- **MISMATCH** --- The paper exists (DOI resolved or title search found a confident match) BUT at least one claimed field is wrong (author, year, title, or venue). Record exactly which fields differ and what Crossref says.
- **FABRICATED** --- No DOI resolution AND no title-search match. The paper cannot be located in Crossref.

A MISMATCH is not a fabrication. The paper is real --- the citation just has errors. These are often typos or misremembered years, and the user may want to fix them.

### Step 5. Report

Produce a markdown file with a summary header and a table:

```
# Citation Verification Report

**Input:** <source file or description>  |  **Entries audited:** N
**Verified:** V  |  **Mismatch:** M  |  **Fabricated:** F

| # | Original citation | Verdict | Evidence |
|---|---|---|---|
| 1 | Author, A. (2023). Title. *Venue*. | VERIFIED | https://doi.org/... |
| 2 | Author, B. (2022). Title. *Venue*. | MISMATCH | year should be 2021; https://doi.org/... |
| 3 | Author, C. (2024). Fake Title. *Venue*. | FABRICATED | no Crossref match for title or author+year |
| ... |

## Recommended actions

- **Verified (V):** safe to use as-is.
- **Mismatch (M):** real papers, but fix the flagged fields before citing.
- **Fabricated (F):** drop from the bibliography. Do not cite.
```

### Step 6. Never substitute

If an entry is FABRICATED, the output is "FABRICATED --- not found in Crossref". Do not suggest "a similar paper" or "did you mean...". The user decides what to do. The job of this skill is to report, not to repair.

## Notes for extending

- **Semantic Scholar fallback:** for papers that Crossref cannot find but might be on arXiv or pre-print servers, add a secondary lookup at `https://api.semanticscholar.org/graph/v1/paper/search?query=<title>`.
- **Author-list verification:** strengthen the check by comparing all authors, not just the first surname.
- **Export:** after verification, emit a cleaned BibTeX file containing only VERIFIED entries (with any MISMATCH corrections merged in, if the user chooses).