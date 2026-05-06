---
name: literature-review
description: Use when the user asks for a literature review, citation search, or annotated bibliography — Path A (OpenAlex search → Crossref DOI verification) for indexed work, Path B (web search → post-hoc DOI/title/author/year/venue checklist) for grey literature. Drops unverified entries rather than "fixing" them; never returns citations from model memory.
allowed-tools: Read, Bash, WebFetch
---

## When to Use

- Starting a new project and need a scoped set of relevant papers
- Checking whether a finding has prior literature
- Producing a bibliography for a draft or proposal

---

## Path A — API-Grounded (higher precision)

```
OpenAlex search → relevance triage → Crossref for full metadata + DOI
```

**Step 1 — Search OpenAlex**

```python
import requests

def search_openalex(query, n=50):
    url = "https://api.openalex.org/works"
    params = {
        "search": query,
        "per-page": n,
        "sort": "relevance_score:desc",
        "mailto": "you@example.com",   # polite pool — faster responses
    }
    return requests.get(url, params=params).json()["results"]
```

Key fields returned: `title`, `doi`, `publication_year`, `authorships`, `cited_by_count`, `open_access.oa_url`.

**Step 2 — Triage by relevance**

Score each result against the research question. Keep papers where title + abstract clearly match. Discard tangential hits.

**Step 3 — Verify via Crossref**

```python
def crossref_lookup(doi):
    r = requests.get(f"https://api.crossref.org/works/{doi}",
                     headers={"User-Agent": "ResearchBot/1.0 (mailto:you@example.com)"})
    if r.status_code != 200:
        return None
    w = r.json()["message"]
    return {
        "title":   w.get("title", [""])[0],
        "authors": [a["family"] for a in w.get("author", [])],
        "year":    w.get("published", {}).get("date-parts", [[None]])[0][0],
        "journal": w.get("container-title", [""])[0],
        "doi":     w.get("DOI"),
    }
```

Cross-check title, authors, year, and venue against the OpenAlex record. Flag mismatches.

---

## Path B — Verify an Existing Bibliography

```
Parse input → Crossref DOI lookup → title-search fallback → classify → report
```

Use when a list of citations already exists and needs to be audited before it can be trusted:

- Web search produced a draft bibliography → verify before using
- A paper's reference section needs spot-checking
- Another LLM was asked for sources and the output is suspicious
- An old bibliography needs re-checking for broken DOIs
- Topic is niche enough that OpenAlex coverage is sparse and grey literature (working papers, reports) is in the mix

### Non-negotiable rules

1. Every entry is classified into exactly one of: **VERIFIED**, **MISMATCH**, **FABRICATED**.
2. **Never "fix" a FABRICATED entry by substituting a similar-looking real paper.** Flag it and stop. The job is to report, not to repair — the user decides what to do.
3. Never downgrade a MISMATCH to VERIFIED because "it is close enough". Record exactly what was wrong.

### Step 1 — Parse the input

Accept any common format: APA, BibTeX, Chicago, plain text, or a markdown list. For each entry, extract:

- First author surname
- Year
- Title
- Venue (journal / conference name)
- DOI (if present)

If a field is missing, record it as `null` and proceed — missing fields are informative.

### Step 2 — Resolve DOIs at Crossref

For entries that have a DOI:

```bash
curl -s "https://api.crossref.org/works/$DOI" > crossref.json
```

Parse the JSON and check:

- **First author surname:** exact match (case-insensitive) against Crossref's `author[0].family`.
- **Year:** exact match against `issued.date-parts[0][0]`.
- **Title:** ≥ 80% fuzzy match against `title[0]` (use `difflib.SequenceMatcher` from Python stdlib).

Record which fields passed and which failed.

### Step 3 — Title-search fallback for entries with no DOI

For entries with no DOI (or where the DOI returned HTTP 404), search Crossref by title:

```bash
ENCODED_TITLE=$(python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))" "$TITLE")
curl -s "https://api.crossref.org/works?query.title=$ENCODED_TITLE&rows=3" > fallback.json
```

For each of the top 3 hits, compare first author and year against the claimed citation. If any hit matches both, record its DOI as evidence.

### Step 4 — Classify every entry

Apply these rules in order:

| Verdict | Condition |
|---|---|
| **VERIFIED** | DOI resolved at Crossref AND first author, year, and title (≥ 80%) all match. Or title-search found a hit where author + year match. |
| **MISMATCH** | The paper exists (DOI resolved or title search found a confident match) BUT at least one claimed field is wrong. Record exactly which fields differ and what Crossref says. |
| **FABRICATED** | No DOI resolution AND no title-search match. The paper cannot be located in Crossref. |

A **MISMATCH is not a fabrication.** The paper is real — the citation just has errors (typos, misremembered years). The user may want to fix them.

### Step 5 — Report

Produce a markdown file with a summary header and a verdict table:

```markdown
# Citation Verification Report

**Input:** <source file or description>  |  **Entries audited:** N
**Verified:** V  |  **Mismatch:** M  |  **Fabricated:** F

| # | Original citation | Verdict | Evidence |
|---|---|---|---|
| 1 | Author, A. (2023). Title. *Venue*. | VERIFIED | https://doi.org/... |
| 2 | Author, B. (2022). Title. *Venue*. | MISMATCH | year should be 2021; https://doi.org/... |
| 3 | Author, C. (2024). Fake Title. *Venue*. | FABRICATED | no Crossref match for title or author+year |

## Recommended actions

- **Verified (V):** safe to use as-is.
- **Mismatch (M):** real papers, but fix the flagged fields before citing.
- **Fabricated (F):** drop from the bibliography. Do not cite.
```

For FABRICATED entries, the output is "FABRICATED — not found in Crossref". Do not suggest "a similar paper" or "did you mean…". The user decides.

---

## Hallucination Taxonomy

| Error type | Description | Detection |
|---|---|---|
| Fabricated DOI | DOI string looks valid but resolves to 404 or wrong paper | Crossref lookup |
| Phantom paper | Title + authors plausible but paper does not exist | OpenAlex + Google Scholar search |
| Wrong authors | Real paper, wrong author attribution | Crossref author list |
| Wrong year | Real paper, wrong publication year | Crossref `published` field |
| Title drift | Real paper, title paraphrased not exact | String match against Crossref title |

---

## Scope Defaults

Unless the user specifies otherwise, apply these filters:

**Publication year:** last 5 years (current year − 4 through current year). Extend to 10 years only if fewer than 10 relevant papers are found within 5.

**Journal and venue whitelist:**

| Category | Outlets |
|---|---|
| Econ top 5 | AER, QJE, JPE, REStud, Econometrica |
| Econ field | AEJ (Applied, Policy, Macro, Micro), EJ, RAND Journal of Economics, Review of Economics and Statistics |
| Marketing / IS | Marketing Science, JMR, JM, Management Science, MISQ, ISR, QME |
| Multidisciplinary science | PNAS, Science, Nature; Nature-family: Nature Communications, Science Advances, Nature Human Behaviour |
| CS / ML conferences | NeurIPS, ICML, ICLR, ACL, EMNLP |
| CS / IR & Web conferences | SIGIR, WWW (The Web Conference), RecSys, KDD |
| Working papers | NBER, SSRN, arXiv (cs.*, econ.*, stat.*) — include only if no published version exists |

Apply the whitelist during **triage** (Step 2), not during search. Cast a wide net in Step 1, then filter to whitelisted venues before verification.

**OpenAlex venue filter** (API-grounded path):

```python
def search_openalex_scoped(query, n=100, year_from=None):
    import datetime
    if year_from is None:
        year_from = datetime.date.today().year - 4
    params = {
        "search": query,
        "per-page": n,
        "sort": "relevance_score:desc",
        "filter": f"publication_year:>{year_from - 1}",
        "mailto": "you@example.com",
    }
    results = requests.get("https://api.openalex.org/works", params=params).json()["results"]
    # Triage: keep whitelisted venues only
    whitelist = {
        # Econ top 5
        "american economic review", "quarterly journal of economics",
        "journal of political economy", "review of economic studies", "econometrica",
        # Econ field
        "american economic journal: applied economics", "american economic journal: economic policy",
        "american economic journal: macroeconomics", "american economic journal: microeconomics",
        "the economic journal", "rand journal of economics", "review of economics and statistics",
        # Marketing / IS
        "marketing science", "journal of marketing research", "journal of marketing",
        "management science", "mis quarterly", "information systems research",
        "quantitative marketing and economics",
        # Multidisciplinary science
        "proceedings of the national academy of sciences", "science", "nature",
        "nature communications", "science advances", "nature human behaviour",
        # CS / ML
        "neurips", "icml", "iclr", "acl", "emnlp",
        # CS / IR & Web
        "sigir", "the web conference", "recsys", "knowledge discovery and data mining",
    }
    return [r for r in results
            if any(w in (r.get("primary_location") or {}).get("source", {}).get("display_name", "").lower()
                   for w in whitelist)]
```

---

## Stopping Criterion

If zero papers survive triage or verification, **stop and report that honestly.**

Do not fabricate entries to fill the bibliography. Return a short note such as:

> No papers matching the research question were found in whitelisted venues within the target date range. Consider broadening the date window, relaxing the venue filter, or switching to Path B for grey literature.

This applies at every filtering stage: after venue triage, after relevance triage, and after verification.

---

## Trade-offs

| | Path A (API) | Path B (Web search) |
|---|---|---|
| Precision | High — indexed papers only | Lower — hallucination risk |
| Recall | Moderate — depends on OpenAlex coverage | Higher — finds working papers, reports |
| Speed | Fast for indexed literature | Fast to draft, slow to verify |
| Best for | Published empirical literature | Emerging topics, grey literature |

---

## Report

See [Report format](report.md).

**Definition (measure):** N papers found; N retained after triage; N verified clean; hallucination rate (unverified / total).  
**Analyses:** Path used (API / web-search); databases searched (OpenAlex, Crossref, Google Scholar); verification method applied.  
**Takeaway:** Coverage verdict for the research question; any fabricated or low-confidence entries flagged for human review.
