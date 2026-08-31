# Empirical Validity Audit

Use this optional module for an empirical report backed by analysis code. Run it before drafting §3 Findings, before circulation or submission, and after a non-trivial pipeline change. Skip it for reports that summarize material without an auditable analysis pipeline.

Audit research validity rather than code style. Flag each issue at a specific `file:line` as:

| Severity | Meaning |
|---|---|
| **CRITICAL** | Changes the substantive result; fix before circulation. |
| **WARNING** | Likely a mistake that does not change the headline result; fix or justify in Limitations. |
| **NOTE** | Documentation or hygiene worth recording. |

Check for:

- silent observation drops, especially missing-value removal without before/after counts;
- train/test leakage and full-sample preprocessing before a split;
- type coercion that creates missing values;
- incorrect filters or date boundaries;
- outcome-dependent outlier rules;
- missing seeds for sampling, splits, or bootstrap procedures;
- standard errors clustered at the level implied by the design;
- unaddressed multiple comparisons;
- machine-specific hard-coded paths; and
- mismatches between code and a study description, design memo, or preregistration in sample, outcome, covariates, or specification.

Treat a design–code mismatch as **CRITICAL**. Report the audit compactly:

```text
# Analysis Review — <project>

Files audited: N | CRITICAL: A | WARNING: B | NOTE: C

## CRITICAL
- `analysis.R:184` — [issue and consequence]

## WARNING
- `data_clean.R:42` — [issue and consequence]

## NOTE
- `model.R:16` — [issue and consequence]

## Checks performed
[Each check: PASS / FAIL / SKIPPED-with-reason]
```

Never say an analysis “looks fine” without listing what was checked. State when a check could not be performed rather than skipping it silently.
