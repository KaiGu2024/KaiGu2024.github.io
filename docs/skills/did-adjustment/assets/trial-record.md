# Trial record

Keep one CSV/JSON row per specification, linked to a readable batch note. Adapt fields to the design; this is not a demand to fit every combination. Mark inapplicable fields rather than inventing data or instruments.

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
| IV result (only if applicable) | Instruments, first stage, reduced form, matched contrast, strength, ratio, confidence-set type/bounds |
| Inference | Assignment/dependence, clustering/resampling, survey design if applicable, few-cluster limits, nuisance/tuning uncertainty, multiplicity |
| Validation | Convergence/tolerance, independent checks, unsupported points and failures |
| Presentation | Main/supporting reason, full/display paths, outcome-informed selection/cropping |
| Conclusion | What changed, remaining threat, evidence needed next |

Keep unit-level membership/influence private. Do not overwrite failed trials under the same ID. Use explicit reasons for unavailable estimates: zero is not a missing-data code.

Reader-facing columns: `specification | population/scale change | N and ESS | lead discrepancy | post effect [CI] | interpretation`. For an IV design, add first-stage, strength, and IV confidence-set columns.
