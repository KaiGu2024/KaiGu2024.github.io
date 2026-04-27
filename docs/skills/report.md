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
