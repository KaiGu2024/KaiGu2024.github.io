---
name: did-adjustment
description: Diagnose and improve difference-in-differences and event-study designs when pretrends differ, estimates are unstable, or comparison groups are questionable. Assess measurement, sample selection, weighting, outcome scales, estimator choice, and sensitivity while preserving the estimand and a complete trial record. Covers panel and repeated cross-sectional studies, with optional IV-DiD guidance. Use for substantive design or analysis revisions, not merely cosmetic figure edits.
---

# DiD adjustment: diagnose before changing the design

Build a credible comparison and explain what the evidence supports. A preferred sign, significant effect, or visually flat preperiod is not the success criterion. Useful outcomes include corrected measurement, a clearer target population, an informative null, sensitivity bounds, or a documented identification limit.

Adapt the work to the study's assignment process, data structure, and substantive question. There is no default population, outcome, threshold, covariate set, calendar window, software package, or treatment direction.

Read supporting material only as needed:

- [Literature guide](references/literature.md): sources L1–L18 for methodological choices and limits.
- [IV-DiD module](references/iv-did.md): only when a distinct encouragement or eligibility instrument is proposed.
- [Transformations and tail handling](references/transformations-and-tail-handling.md): baseline demeaning, standardization, and unit-day/week/month winsorization or trimming; read before changing outcome scales or tail rules.
- [Trial-record template](assets/trial-record.md): when implementing or comparing specifications; omit inapplicable fields.
- [Optional AI-search case study](references/case-study-ai-search.md): examples and historical trials; no case-specific rule is a default for another study.

## 1. Establish the design and target quantity

Use existing context and artifacts before asking for missing information. Record the population, observation and assignment units, treatment/exposure history, outcome units, horizon, comparison rule, identifying assumptions, and inference level. Distinguish a treatment ATT from an assignment effect, an effect for switchers, or an IV local response.

Choose the appropriate data branch before selecting an estimator:

| Data or treatment structure | Consequence for the analysis |
|---|---|
| Unit panel, balanced or unbalanced | Audit entry, exit, attrition, and observation rules. A balanced-panel restriction can select on treatment; do not impose it automatically. |
| Repeated cross-sections | People need not recur. Use a compatible estimator and defend sampling/composition stability or a justified correction; do not invent individual histories or require person fixed effects. Respect survey weights, strata, and sampling clusters where relevant. [L3] |
| Aggregate units or cluster-assigned treatment | Distinguish population weights from equal-unit effects. Precision depends on independent assignment/shock variation, not just the number of lower-level observations. |
| Binary absorbing adoption | Cohort-time ATT methods may apply under their comparison, anticipation, and trend assumptions. [L1–L2] |
| Reversible, repeated, or varying-dose treatment | Define the relevant treatment path and carryover. Do not recode first exposure as permanent treatment without justification; select a method that supports the actual history. [L17] |
| Encouragement with endogenous uptake | Separate assignment from uptake and read the IV module. An ordinary adoption-timed event study is not automatically IV. |

For existing analyses, reproduce a coefficient, standard error, sample counts, and a reported average before revising them. Use the **full covariance** for averages, not averaged standard errors. For a proposed study without estimates, mark reproduction as inapplicable.

For a two-group contrast relative to reference period \(b\),

\[
\widehat\delta_k=(\bar Y_{T,k}-\bar Y_{C,k})-(\bar Y_{T,b}-\bar Y_{C,b}).
\]

A low reference gap can create positive leads throughout. Rebasing shifts contrasts; it does not remove the discrepancy. For staggered treatment, examine valid cohort-time comparisons and their aggregation rather than applying this illustration mechanically to pooled means.

## 2. Diagnose the discrepancy before choosing a repair

- **Measurement:** check source coverage, coding changes, duplicates, aggregation, exposure denominators, zero versus missing, and whether treatment changes the ability to observe the outcome. Resolve construct validity before interpreting coefficients.
- **Both groups:** examine levels and changes, distribution tails, zeros, component outcomes, coefficient and variance influence, and weight concentration. Different levels alone do not violate parallel trends. Large values are not automatically errors; deletions chosen for their favorable effect are diagnostics, not justified exclusions.
- **Calendar and assignment:** map discrepancies to seasonality, earlier interventions, anticipation, concurrent policies, recording changes, and spillovers. Calendar effects remove common shocks, not every group-specific seasonal response. Do not assume a holiday caused a dip merely because the dates overlap.
- **Support:** tabulate eligible treated and comparison units by cohort and event time. Late cohorts can have long prehistories but short follow-up; not-yet-treated controls eventually disappear. Separate unsupported estimates from estimated zeros.
- **Selection and composition:** examine attrition, migration, changing survey coverage, baseline left-censoring, and restrictions based on future behavior. Distinguish a real population change from a data error. Restricting to eventual adopters changes the population and can condition on treatment-induced behavior.

Keep sensitive unit-level records private. Use cached aggregates when sufficient; inspect raw records when needed to validate measurement.

## 3. Plan a limited set of justified adjustments

Explain what diagnosed problem each change addresses and whether it changes the population, outcome, assignment contrast, identifying assumption, estimator, or presentation. State which results already informed the choices. Planning the next batch does not make earlier exploratory work preregistered.

Start with one dimension at a time and common-sample comparisons when useful. Do not require an exhaustive factorial search.

| Direction | Appropriate use | Limitation to record |
|---|---|---|
| Measurement and outcomes | Correct verified errors; compare validated outcome definitions, components, participation, intensity, or rates | A new scale or denominator changes the question; measurement repair does not repair assignment |
| Transformations and tail handling | Baseline demeaning, pooled or unit-specific standardization, log(1+Y), asinh(Y), proportional means; winsorization or trimming at unit-day/week/month resolution | Fixed unit demeaning cancels in within-unit differences/linear unit FE with unchanged sample and weights. Unit-specific scaling and tail handling can change the estimand and trend assumption; logs/asinh with zeros are not automatic percentages [L9–L10]. See the transformation reference. |
| Baseline restrictions and heterogeneity | Common support, stable coverage, substantively relevant subgroups using predetermined information | Changes the target population; noisy screening creates regression-to-the-mean concerns [L7] |
| Treatment and timing definitions | Validate start dates, persistence, dose, and anticipation | Sustained-use definitions can use future observations relative to onset; document that selection |
| Comparison groups | Never-treated, not-yet-treated, alternative eligible groups, or synthetic donors | Assess anticipation, earlier treatment, spillovers, follow-up, and actual eligibility |
| Matching and weighting | Predetermined demographics, institutional features, outcome histories, volatility, or other justified covariates | Balance does not establish counterfactual trends; noisy matching and concentrated weights can worsen bias [L6–L7] |
| Conditional seasonality | Baseline characteristics interacted with time, control-based outcome models, or proportional means | Requires overlap and transportable untreated responses; unrestricted treated-post terms absorb the effect |
| Estimator changes | Cohort-time/DR DiD, synthetic weighting, SDID, factor or imputation methods | Different assumptions and supported estimands; a better fitted preperiod is not identification |
| Alternative designs | Triple differences, negative controls, discontinuities, or encouragement IV | Need genuinely new identifying restrictions; an additional outcome or date is not sufficient |
| Windows and references | Substantive horizons, common cohort support, anticipation buffers, reference sensitivity | Cropping or selecting significant lags does not repair identification |

Keep distinct operations explicit: winsorization changes \(Y\), an eligibility ceiling excludes units, and a subgroup threshold changes the target population. Justify thresholds from the construct and a stated distribution or external rule, not their favorable results. For a volume question, raw levels retain the total-volume interpretation; a capped measure can answer a separate question. Report affected outcome mass and sample shares. Avoid treatment-dependent caps.

Choose the tail-handling resolution separately from the estimation resolution: capping unit-days before weekly aggregation differs from capping unit-weeks or unit-months. Trimming observations is also different from excluding whole units using a predetermined screen. Record cutoff calibration, operation order, coverage, and selection consequences. Treat these as justified possibilities to assess, not an automatic grid to search for significance. For standardization, distinguish one pooled baseline SD from each unit's own SD; handle zero/small SD explicitly and compare identical samples. Demeaning alone is not a pretrend repair.

Distinguish sampling/representation weights from causal-comparison weights. ATT-style control weighting retains the treated target; overlap weighting generally changes it. If weights are combined, define the resulting target and variance procedure rather than multiplying weights without explanation.

Report overlap, unmatched units, covariate balance, weight extrema/concentration, and effective sample size \((\sum w)^2/\sum w^2\). Fit with information predetermined relative to the relevant treatment date. Where time support permits, separate training/tuning from later preperiod validation; disclose if validation also selected the specification. Multiple baseline observations reduce reliance on one noisy period but do not eliminate regression to the mean.

Tune using a stated preperiod prediction/balance criterion and support constraints, not the desired post-treatment sign. Include uncertainty from fitted weights and nuisance models using a procedure appropriate to the estimator; ordinary bootstrap is not valid for every matching method. Contemporaneous covariates, denominators, or offsets may be affected by treatment and need separate justification.

## 4. Match the estimator to the design

| Method | What it requires or changes | Check before interpreting |
|---|---|---|
| Cohort-time / CSDiD | ATT(g,t), eligible untreated comparisons, conditional parallel trends and no anticipation [L1] | Risk sets, covariate timing, base-period convention, aggregation and cohort support |
| Heterogeneity-robust event study | Avoids inappropriate already-treated comparisons [L2] | Conventional TWFE leads can be contaminated; do not read them as clean placebos automatically |
| Stacked event study | Cohort-specific eligible comparison sets, event windows, and stack-specific unit/time effects [L18] | Reused controls and unequal cohort support change implicit weights; define aggregation and cluster on original units |
| Doubly robust DiD | Under identifying assumptions, consistency if either specified propensity or outcome model is correct [L3] | Use the panel or repeated-cross-section version as appropriate; DR does not cure false parallel trends |
| Synthetic control / weighting | Donor representability and stable untreated outcome structure | Training versus validation fit, donor support/concentration, unaffected donors and inference |
| Synthetic DiD | Published estimator combines unit and time weights [L4] | Arbitrary synthetic donor weights plus a difference are not automatically canonical SDID |
| FE / interactive FE / matrix completion | Untreated-outcome imputation under additive/factor/low-rank restrictions [L5] | Holdouts, tuning, convergence, treatment feedback, and software version; fitted residuals are not independent placebo evidence |
| Non-absorbing or varying-dose DiD | Appropriate treatment histories and dynamic estimands [L17] | Carryover, eligible unchanged paths, supported contrasts; not a routine absorbing-adoption specification |
| Time discontinuity | Smooth counterfactual evolution and no competing discontinuity [L12] | Seasonality, bandwidth, serial dependence, placebo dates; calendar time is not randomized assignment |
| Proxy / negative control | Explicit proxy exclusion and relevance restrictions [L14] | An auxiliary variable is not automatically unaffected by treatment |

Name custom approximations honestly and check their numerical implementation against a trusted method when feasible. Do not demean paths or fitted residuals merely to remove a discrepancy. A changed normalization, model, or reference is a new specification requiring explanation.

For one common treatment date, first check whether Sun–Abraham interactions, binary switcher contrasts, and a single-stack event study reduce to the same weighted DiD. Matching estimates then verify implementation; they are not independent evidence against confounding. Creating additional stacks from arbitrary dates would change the design. With genuine staggered timing, this equivalence generally does not hold.

For counterfactual imputation, distinguish additive FEct from interactive FE and matrix completion. Record which untreated periods determine unit effects: an all-preperiod baseline differs from a single-reference-week contrast. Distinguish weights in the fitting objective from weights used only to average estimated effects, and check support in the installed software version. Preserve numerical-tolerance checks and withheld-period predictions; do not count fitted preperiod residuals as out-of-sample validation.

## 5. Separate identification, magnitude, and precision

Nonrejection of pretrends is not proof of parallel trends. One significant lead is a reason to investigate, not an automatic diagnosis; joint tests can reject when individual intervals include zero. Report magnitudes, uncertainty, power or substantive equivalence tolerances where useful, and whether intervals are pointwise or simultaneous. Selecting specifications to pass pretests can distort inference. [L8]

Where the estimand and available covariance permit, use sensitivity analysis such as HonestDiD with justified restrictions, ranges, breakdown values, and numerical limits. It measures dependence on trend assumptions; it does not flatten data. A bound on changes in untreated gaps is not a bound on accumulated bias. [L11]

Preserve serial dependence and reflect assignment and common shocks in inference. Thousands of observations within a few policy jurisdictions do not create thousands of independent assignments. With few clusters or treated units, select and justify an appropriate inferential approach; neither ordinary cluster-robust errors nor a generic bootstrap is an automatic remedy. Account for survey sampling where applicable. [L15]

Disclose outcome-informed selection. Adjustment for one grid does not cover an entire adaptive search. More trials can reveal fragility without strengthening identification; a reused validation period is not untouched confirmation. Compare subgroup effects directly rather than comparing their significance labels.

## 6. Present the supported conclusion and preserve the audit trail

Choose the main specification for construct validity, comparison credibility, support, and transparent estimation; disclose selection after seeing results. Retain nulls, positive and negative effects, overlap failures, nonconvergence, and undefined estimates.

Separate estimation, summary, and display windows. A readable subset needs the full curve and relevant diagnostics available. Do not hide rejecting leads or late reversals. Label the event clock, outcome units, aggregation, reference, and interval type; distinguish normalized reference values from estimated zeros and do not connect unsupported points. Use an available visualization skill if helpful; the workflow does not depend on one.

Write in this order: question and target quantity; data and groups; method and most threatened assumption; effect with units and uncertainty; interpretation and limitation. A negative estimate, an interval excluding zero, and credible causal evidence are different statements. An insignificant estimate is not proof of no effect.

For implementation, retain a diagnosis, justified batch plan, trial record, reusable estimates/covariance and reproduction commands, and a comparison table explaining population/scale changes. Save appropriate input/configuration hashes and software versions. Validate membership, observation rules, timing, support, coefficients, covariance, and figure/table agreement. Figure-only revisions should reuse saved estimates. For advice alone, provide a plan and mark estimation as not run.

Stop specification search when unsupported assignment, missing measurements, absent comparisons, or irreducible instability is the binding obstacle. State what new evidence would change the conclusion. Completing the task can mean documenting that the requested causal claim remains unsupported.
