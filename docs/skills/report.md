# Agent Skill: Report Format

Standard output format for all skill reports.

---

## Quick Template

```
**Definition (measure):** The primary output and how it is quantified.
**Analyses:** What was done — methods, sources, diagnostics. Distinguish planned from exploratory.
**Takeaway:** Key result with practical significance. Flag concerns.
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

### §1 Data & Sample

**Analysis:** data source, time period, unit of observation, N-funnel (N at each filtering step), final sample size.
**Takeaway:** whether the sample is representative; any selection concerns.
**Note:** if different analyses in the report use different subsamples, state the differences here explicitly rather than in each analysis section.

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

**Analysis:** method applied, sample used (note if it differs from §1), main result with point estimate and 95% CI or SE, effect size.
**Takeaway:** practical significance; whether the result clears a meaningful threshold; main caveat.

Back-reference §2 for any self-defined or uncommon metric on every appearance. Flag any deviation from planned analysis as exploratory.

### §N Heterogeneity *(if applicable)*

**Analysis:** subgroup breakdown by the most theoretically motivated dimensions (platform, user type, time window, geography).
**Takeaway:** where the effect is largest, smallest, or absent; whether heterogeneity is consistent with the proposed mechanism.

### §N Benchmark (if applicable)

**Analysis:** comparison table against 3–5 academic papers and 1–2 industry reports on the same measure. See the [Benchmark reference](#benchmark-reference) section below for sources by measure type.

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

- **Scope** — state what is *not* covered: *"organic CTR only; paid and direct excluded."*
- **Abstract integrity** — every abstract claim maps to a section; every section has at least one number.
- **Scale consistency** — flag when effect sizes across analyses are on different scales (pp vs. log-odds vs. standardized).
- **Data provenance** — record when data was pulled and which script cleaned it; *"recent data"* is not recoverable.
- **Concrete over vague** — "N = 14,203; 47 duplicates removed" beats "the dataset was cleaned." — *McCloskey*
- **Pair estimates with uncertainty** — always SE or 95% CI alongside a point estimate. — *Gelman*
- **Practical significance** — report effect sizes; state whether the result clears a meaningful threshold. — *APA JARS*
- **Confirmatory vs. exploratory** — label post-hoc findings explicitly; the same data cannot generate and test a hypothesis. — *TOP Guidelines*
- **Flag threats** — name the main concern in every Takeaway; an unaddressed threat is not a clean result.

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
