# Agent Skill: Report Format

Standard output format for all skill reports.

---

## Template

```
**Definition (measure):** The primary output and how it is quantified.
**Analyses:** What was done — methods, sources, diagnostics. Distinguish planned from exploratory.
**Takeaway:** Key result with practical significance. Flag concerns.
```

---

## Benchmark (when reporting a standard measure)

When the output is a common measure — CTR, ATT, conversion rate, effect size, kappa — contextualize it against external comparators before drawing conclusions. Use [Literature Review](literature-review.md) to find 3–5 academic papers and 1–2 industry reports on the same measure.

**Industry sources to check by measure type:**

| Measure type | Sources |
|---|---|
| Web traffic, CTR, engagement | SimilarWeb, SEMrush, Comscore, Adobe Analytics Benchmarks |
| Search behavior | Google Search Console industry benchmarks, SparkToro |
| News / media consumption | Reuters Institute Digital News Report, Pew Research Center, Nielsen |
| E-commerce, conversion | Salesforce State of Commerce, Adobe Commerce Report, eMarketer / Insider Intelligence |
| Social media | Sprout Social Benchmarks, Hootsuite Digital Report, DataReportal |
| Email marketing | Mailchimp Industry Benchmarks, HubSpot Marketing Report |
| App / mobile | App Annie (data.ai), Sensor Tower, Apptopia |
| Advertising | IAB Internet Advertising Revenue Report, Statista, WARC |
| General aggregator | Statista, Gartner, Forrester, McKinsey Global Institute |

**Comparison table** — one row per source:

| Source | Measure | Value | Time period | Sample |
|---|---|---|---|---|
| *This study* | CTR (AI summary present) | 8.2% | Mar 2025 | 900 U.S. adults, Google Search |
| Pew Research 2025 | CTR (AI summary present) | 8% | Mar 2025 | 900 U.S. adults (same dataset) |
| Reuters Inst. 2025 | "Consistently click through" AI answers | ~33% | 2025 | Multi-country opt-in survey |

**Flag data differences** for each comparator that diverges from your study:
- *Time period* — pre/post a product change, different year
- *Sample* — size, selection mechanism (opt-in vs. representative), geography, platform, B2B vs. consumer

**Flag measure differences** when the operationalization differs:
- Numerator/denominator definition
- Aggregation level (per-query vs. per-session vs. per-user)
- Behavioral (observed clicks) vs. self-reported ("do you click?")

**Rationale paragraph** — 2–4 sentences after the table. Does your estimate align with the literature? If it diverges, name the most plausible explanation: sample selection, time period shift, measure definition mismatch, or platform difference.

---

## Principles

**Be concrete, not vague.**
"N = 14,203 rows; 47 duplicates removed; price coerced from string (12 NaN)" beats "the dataset was cleaned."
Numbers anchor the reader. Name files, functions, and thresholds. — *McCloskey, Economical Writing*

**Always pair estimates with uncertainty.**
Report point estimates with SE or 95% CI. Never present a coefficient alone as fact.
"β = 0.12 (SE = 0.03, 95% CI [0.06, 0.18])" not "β = 0.12."
A wide interval is informative — it tells you the evidence is weak. — *Gelman, Ethics in Statistical Practice*

**State practical significance, not just statistical.**
Report effect sizes alongside p-values. Tell the reader whether the effect is large enough to matter, not only whether it clears a threshold.
"Cohen's d = 0.08 — detectable but smaller than the minimum meaningful effect of 0.20" is a complete takeaway. — *APA Journal Article Reporting Standards*

**Distinguish confirmatory from exploratory.**
Label each analysis: was it planned before seeing the data, or discovered after?
The same data cannot generate and test a hypothesis without qualification.
Exploratory findings belong in Takeaway only if labeled as such. — *Transparency and Openness Promotion (TOP) Guidelines*

**Flag threats, not just results.**
Takeaway must name the main concern: a violated assumption, a coverage gap, a data quality issue.
A result with an unaddressed threat is not a clean result. — *Gelman; standard referee norms*

**Report what happened, not what you tried.**
Analyses lists methods applied and decisions made, not intentions.
"Lazy evaluation used; cache hit rate 94% on re-run" not "we attempted to use caching."
