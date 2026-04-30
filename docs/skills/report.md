# Agent Skill: Report Format

Standard output format for all skill reports.

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
