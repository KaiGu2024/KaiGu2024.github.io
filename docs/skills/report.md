---
name: report
description: Standard output format for skill reports and multi-section analysis writeups — Quick Template (Definition / Description / Takeaway) for single-step outputs, Writing Pipeline (Abstract / Data & Sample / Definitions / Analysis / Heterogeneity / Benchmark / Limitations) for multi-section reports. Includes the pre-report validity check (analysis review) that should run before any §3+ Analysis Section is drafted.
allowed-tools: Read, Edit, Write
---

## Quick Template

```
**Definition (measure):** The primary output and how it is quantified.
**Description:** What the figure or table shows — observable pattern, numbers, direction.
**Takeaway:** What we conclude — practical significance, flag concerns.
```

Use the Quick Template for single-step skill outputs (a scraping run, an annotation batch, an EDA). Use the Writing Pipeline below for multi-section analysis reports.

---

## Writing Pipeline

### Title

`Report — {Name}`

### Abstract

Write last, place first.

- Sentence 1: overall purpose and scope — what questions this report addresses and why
- One sentence per section: what each section contains or finds (include at least one number where the section has a main result)
- Cap at ~150 words total; merge thin sections into one abstract sentence if needed.

### §1 Data & Sample

**Analysis:** data source, time period, unit of observation, N-funnel (N at each filtering step), final sample size.
**Takeaway:** whether the sample is representative; any selection concerns.
**Note:** if different analyses in the report use different subsamples, state the differences here explicitly rather than in each analysis section.
**Suite note:** if this report is one of several sharing the same sample and definitions (e.g., a fact-sheet suite), replace §1/§2 with a one-line pointer — *"Sample and definitions: see [Suite Reference]"* — and omit the full restatement.

### §2 Definitions

For each concept or metric that appears in the report:

```
Name: [metric name]
Formula: [precise definition — numerator / denominator, or construction steps]
Unit: [%, count, log-odds, standardized, etc.]
Range: [e.g., 0–100%, unbounded, −1 to 1]
Notes: [edge cases, exclusions, or competing definitions in the literature]
```

- **Standard metrics** (CTR, Cohen's κ, ATT): cite the canonical source; define only if your operationalization deviates.
- **Custom or uncommon metrics**: define in full here. All subsequent sections reference back: e.g., "adjusted engagement rate (§2)." Standard metrics need not be back-referenced after first mention.

### §3+ Analysis Sections *(one per research question)*

Each section follows the same structure:

**Description:** What the figure or table shows — observable pattern, numbers, direction. For regression output: method, sample (note deviations from §1), point estimate with 95% CI or SE, effect size. For figures/tables: the trend, distribution, or comparison visible in the output.
**Takeaway:** What we conclude — practical significance; whether the result clears a meaningful threshold; main caveat.

> **Example — Yelp ratings by category**
> *Description:* Health averages **4.1 stars** with a **31.7%** five-star rate, but only **483** total reviews — the lowest review volume across categories.
> *Takeaway:* High satisfaction paired with low review volume signals **underengagement** → Yelp should prioritize Health category promotion to drive platform activity. Saying "Health has high stars" is data; pairing the satisfaction signal with the volume gap and naming the action is analysis.

Back-reference §2 for any self-defined or uncommon metric on every appearance. Flag any deviation from planned analysis as exploratory.

### §N Heterogeneity *(if applicable)*

**Analysis:** subgroup breakdown by the most theoretically motivated dimensions (platform, user type, time window, geography).
**Takeaway:** where the effect is largest, smallest, or absent; whether heterogeneity is consistent with the proposed mechanism.

### §N Benchmark (if applicable)

**Analysis:** comparison table against prior work on the same measure — 1 highly relevant source is enough; add more only if they materially differ in sample or method. See the [Benchmark reference](#benchmark-reference) section below for sources by measure type.

| Source         | Measure | Value | Time period | Sample |
| -------------- | ------- | ----- | ----------- | ------ |
| *This study* | …      | …    | …          | …     |
| [Prior work]   | …      | …    | …          | …     |

Flag **data differences** (time period, sample size, selection mechanism, geography, platform) and **measure differences** (numerator/denominator, aggregation level, behavioral vs. self-reported) for each comparator.
**Takeaway:** alignment or divergence explained in 2–4 sentences. Name the most plausible explanation if estimates diverge.

### §N Limitations *(if applicable)*

**Analysis:** enumerate threats to validity — identification assumptions violated, sample selection, measurement error, generalizability.
**Takeaway:** which limitation would most change the conclusion if addressed; suggested next steps.

---

## Pre-report Validity Check (analysis review)

Before any §3+ Analysis Section is drafted, the underlying script needs a **research-validity audit** — not a style review. A report that documents an invalid pipeline is worse than no report. This step catches the failures that linters cannot: silent N drops, leakage between train and test, type coercion that produces NAs, mismatches between the stated design and what the code actually does.

### When to run

- Before first internal circulation of the report
- Before any submission (working paper, journal, replication package)
- After any non-trivial change to the data pipeline (new merge, new filter, new sample restriction)

### Severity levels

Every flagged issue must point to a specific `file:line` and carry one of three severities. Vague comments ("the cleaning could be cleaner") are not allowed.

| Severity | Meaning |
|---|---|
| **CRITICAL** | Changes the substantive result. Must be fixed before the report is circulated. |
| **WARNING** | Likely a mistake but does not change the headline result. Fix or justify in §N Limitations. |
| **NOTE** | Worth knowing; usually a documentation or hygiene item. |

### Mandatory checks

| Check | What to look for |
|---|---|
| **Silent N drops** | `drop_na()` / `na.omit()` / `dropna()` without an explicit `count_before == count_after` log |
| **Train/test leakage** | Feature engineering on the full dataset before the split |
| **Coerced types** | `as.numeric(x)` on character columns producing NAs without warning |
| **Filter logic** | `&` vs `&&`, `==` vs `<-` typos, off-by-one date filters |
| **Outlier rules** | Any `x > threshold` filter that depends on the **outcome** variable |
| **Replication seed** | `set.seed(...)` before any sampling / random split / bootstrap |
| **Cluster SE** | Standard errors clustered at the level the design implies |
| **Multiple comparisons** | If many tests are run, are corrections applied (or pre-registered as exploratory)? |
| **Path hard-coding** | Paths that only work on the author's machine |

### Cross-check against stated design

If a study description, design memo, or pre-registration exists, compare it line-by-line against the code:

- Sample inclusion criteria match?
- Outcome variable matches the pre-registered one?
- Covariates listed in the design are all in the model?
- The pre-registered analysis (e.g. DID with two-way fixed effects) is the one actually run?

Any mismatch → CRITICAL.

### Report-the-review format

```
# Analysis Review — <project>

**Files audited:** N  |  **CRITICAL:** A  |  **WARNING:** B  |  **NOTE:** C

## CRITICAL
- `analysis.R:184` — Train/test leakage: scaling fit on full data before split. Result: out-of-sample fit overstated.

## WARNING
- `data_clean.R:42` — 1,247 rows silently dropped at `drop_na(income)`. If income is MAR not MCAR, this biases the sample.

## NOTE
- `model.R:16` — `set.seed(42)` is set at file top but `bootstrap()` re-seeds each call; consider standardizing.

## Checks performed
[every check from the table with status: PASS / FAIL / SKIPPED-with-reason]
```

Never say "looks fine" without listing what was checked. **Absence of evidence is not evidence of absence** — if a check could not be performed (e.g. data is gitignored), say so explicitly rather than skip silently.

### Notes for extending

- **Language-specific checkers.** Add R-specific checks (factor level handling, `data.table` reference semantics) in `checks/r.md`; Python in `checks/py.md`. Loaded only when the relevant language appears.
- **Pre-registration parsing.** Auto-extract cross-check items from an OSF preregistration JSON so the design-vs-code comparison runs without manual transcription.
- **Subagent pattern (`context: fork`).** This is the canonical case for forking a subagent. Reading a full pipeline spans 10–30 files of code that is irrelevant to the conversation that called the skill — the verbose file-reading would otherwise blow the main context. The subagent reads the files, runs the checks, returns the compact report above; the main conversation never sees the raw code.

---

## Conventions

Write brief and to the point — remove word, sentence, or section that adds length without adding new information.

- **Scope** — state what is *not* covered: *"organic CTR only; paid and direct excluded."*
- **Abstract integrity** — every abstract claim maps to a section.
- **Scale consistency** — flag when effect sizes across analyses are on different scales (pp vs. log-odds vs. standardized).
- **Data provenance** — record when data was pulled and which script cleaned it; *"recent data"* is not recoverable.
- **Concrete over vague** — "N = 14,203; 47 duplicates removed" beats "the dataset was cleaned."
- **Pair estimates with uncertainty** — always SE or 95% CI alongside a point estimate. — *Gelman*
- **Practical significance** — report effect sizes; state whether the result clears a meaningful threshold.
- **Confirmatory vs. exploratory** — label post-hoc findings explicitly; the same data cannot generate and test a hypothesis.
- **Flag threats** — name the main concern.
- **List structure** — organize analysis as a bulleted or numbered list; avoid prose paragraphs where a list suffices. Use prose when a list would fragment the argument.
- **Highlight keywords** — write in normal phrases and sentences, but bold key terms, numbers, and conclusions: "**Video** posts average **8.3%** engagement vs. **2.2%** for text — a **3.8× gap**."
- **Arrow for logic** — use → to show reasoning chains: "high churn → low LTV → unprofitable segment."

---

## Benchmark Reference

Industry sources by measure type:

| Measure type                 | Sources                                                                               |
| ---------------------------- | ------------------------------------------------------------------------------------- |
| Web traffic, CTR, engagement | SimilarWeb, SEMrush, Comscore, Adobe Analytics Benchmarks                             |
| Search behavior              | Google Search Console industry benchmarks, SparkToro                                  |
| News / media consumption     | Reuters Institute Digital News Report, Pew Research Center, Nielsen                   |
| E-commerce, conversion       | Salesforce State of Commerce, Adobe Commerce Report, eMarketer / Insider Intelligence |
| Social media                 | Sprout Social Benchmarks, Hootsuite Digital Report, DataReportal                      |
| Email marketing              | Mailchimp Industry Benchmarks, HubSpot Marketing Report                               |
| App / mobile                 | App Annie (data.ai), Sensor Tower, Apptopia                                           |
| Advertising                  | IAB Internet Advertising Revenue Report, Statista, WARC                               |
| General aggregator           | Statista, Gartner, Forrester, McKinsey Global Institute                               |
