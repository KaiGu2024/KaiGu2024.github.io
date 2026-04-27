# Agent Skill: Literature Review

Two paths to a verified bibliography for a research question.

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

Cross-check title, authors, and year against the OpenAlex record. Flag mismatches.

---

## Path B — Web Search → Draft → Post-hoc Verification

```
Web search for topic → draft bibliography → verify each entry
```

Use when the topic is niche enough that OpenAlex coverage is sparse, or when you need grey literature (working papers, reports).

**Verification checklist (apply to every entry):**

1. DOI resolves to the claimed paper
2. Title matches exactly (not approximately)
3. Author list matches (check first author + year)
4. Journal/venue matches
5. Year is correct

Flag any entry that fails one or more checks as **unverified** — do not include in the final bibliography without human review.

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
| Business / marketing field tops | Marketing Science, JMR, JM, JCR, JCP, Management Science, MISQ, ISR |
| UTD 24 | Full UTD journal list (covers accounting, finance, IS, management, marketing, OB, operations) |
| Multidisciplinary science | PNAS, Science, Nature and Nature-family journals (Nature Human Behaviour, Nature Communications, etc.) |
| CS / ML conferences | NeurIPS, ICML, ICLR, ACL, EMNLP, NAACL, CVPR, ICCV, KDD, WWW, SIGIR, SIGMOD, VLDB |
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
        "american economic review", "quarterly journal of economics",
        "journal of political economy", "review of economic studies", "econometrica",
        "marketing science", "journal of marketing research", "journal of marketing",
        "journal of consumer research", "management science",
        "proceedings of the national academy of sciences",
        "science", "nature",
        # add others as needed
    }
    return [r for r in results
            if any(v.lower() in whitelist
                   for v in (r.get("primary_location") or {}).get("source", {}).get("display_name", "").lower().split()
                   )]
```

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
