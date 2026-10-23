# Trial record

Keep one CSV/JSON row per specification, linked to a readable batch note. Use fields relevant to the design and mark the rest inapplicable.

| Field | Content |
|---|---|
| Identity/status | Stable ID/family, date, code/input/config hashes, versions; proposed/estimated/failed/retired/superseded/unavailable and reason |
| Motivation | Diagnosed problem, rationale, prior results inspected, exploratory/confirmatory status |
| Estimand | Population, scale/units, treatment/encouragement, horizon/aggregation, assumptions |
| Sample | Panel/repeated cross-section/aggregate frame, observation and assignment units, eligibility/dates, N by group/period, exclusions, attrition/composition, overlap |
| Measurement | Construct/source, coverage/coding changes, aggregation/denominator, zero/missing rules, transformation/cap and cutoff source |
| Transformation/tail rule (if applicable) | Center/SD definition and baseline dates; pooled versus unit-specific SD, zero/small-SD handling; unit-day/week/month resolution; winsorization versus observation trimming versus whole-unit exclusion; cutoff population/weights/zeros, operation order, affected mass and sample shares; common-sample benchmark |
| Timing | Calendar resolution and boundaries, treatment/instrument clock, anticipation/reference, reversals/carryover, concurrent interventions |
| Windows | Screening, training, tuning, validation, estimation, summary, display; reuse for selection |
| Comparison | Rule by cohort/time, donor attrition, fixed/changing cohort support |
| Adjustment | Representation versus balance weights, features/dates, tuning, estimated components |
| Diagnostics | Group paths, influence, balance, ESS, maximum weights, support, lead RMS/joint test/equivalence |
| Outcome result | Estimate/SE/CI/level, units, covariance path, stated benchmark |
| Heterogeneity (if applicable) | Modifier and baseline definition, hypothesis/cutoff timing, subgroup targets/support/shares, estimates and direct contrasts with joint covariance, aggregation reconciliation, subgroup/contrast trend evidence, sensitivity and search family |
| IV result (only if applicable) | Instruments, first stage, reduced form, matched contrast, strength, ratio, confidence-set type/bounds |
| Inference | Assignment/dependence, clustering/resampling, survey design if applicable, few-cluster limits, nuisance/tuning uncertainty, multiplicity |
| Validation | Convergence/tolerance, independent checks, unsupported points and failures |
| Presentation | Main/supporting reason, full/display paths, outcome-informed selection/cropping |
| Conclusion | What changed, remaining threat, evidence needed next |

Keep unit-level membership/influence private. Preserve failed trials under their original IDs and record reasons for unavailable estimates separately from estimated zeros.

Reader-facing columns: `specification | population/scale change | N and ESS | lead discrepancy | post effect [CI] | interpretation`. For an IV design, add first-stage, strength, and IV confidence-set columns.
