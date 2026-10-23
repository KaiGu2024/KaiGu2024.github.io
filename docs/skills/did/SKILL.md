---
name: did
description: Design, diagnose, and improve difference-in-differences and event-study analyses, including null average effects with conditional or opposing subgroup effects, differing pretrends, unstable estimates, and questionable comparisons. Assess measurement, selection, weighting, outcome scales, estimators, heterogeneity, and sensitivity with explicit estimands and a complete trial record. Covers panels, repeated cross-sections, and optional IV-DiD. Use for substantive design, analysis, or interpretation, not merely cosmetic figure edits.
---

# DiD: design, diagnosis, and heterogeneous effects

Build a credible comparison and explain the result: an average effect, an informative null, conditional responses, or a limit on what the design identifies.

Choose the population, outcome, covariates, timing, and estimator from the study's assignment process, data structure, and substantive question.

Read supporting material only as needed:

- [Literature guide](references/literature.md): sources L1–L20 for methodological choices and limits.
- [Null averages and subgroup effects](guidance/null-and-heterogeneous-effects.md): when an overall effect is near zero or imprecise but may differ across conditions; includes subgroup identification and figure-optional reporting.
- [IV-DiD module](references/iv-did.md): only when a distinct encouragement or eligibility instrument is proposed.
- [Transformations and tail handling](references/transformations-and-tail-handling.md): levels, logs, weighted logs, PPML, standardization, and tail rules; read before comparing outcome scales or mean models.
- [Trial-record template](assets/trial-record.md): when implementing or comparing specifications; omit inapplicable fields.
- [Optional AI-search case study](references/case-study-ai-search.md): project-specific examples and historical trials.

## 1. Establish the design and target quantity

Use existing context and artifacts before asking for missing information. Record the population, observation and assignment units, treatment/exposure history, outcome units, horizon, comparison rule, identifying assumptions, and inference level. Distinguish a treatment ATT from an assignment effect, an effect for switchers, or an IV local response.

Choose the appropriate data branch before selecting an estimator:

| Data or treatment structure | Consequence for the analysis |
|---|---|
| Unit panel, balanced or unbalanced | Audit entry, exit, attrition, and observation rules, including treatment-induced selection from a balanced-panel restriction. |
| Repeated cross-sections | Use the repeated-cross-section estimator with observed group histories and stable sampling/composition or a justified correction. Respect survey weights, strata, and sampling clusters. [L3] |
| Aggregate units or cluster-assigned treatment | Define population-weighted or equal-unit effects; assess independent assignment/shock variation for inference (§5). |
| Binary absorbing adoption | Cohort-time ATT methods may apply under their comparison, anticipation, and trend assumptions. [L1–L2] |
| Reversible, repeated, or varying-dose treatment | Define the actual treatment path and carryover; select a method that supports reversals, repeated exposure, or dose variation. [L17] |
| Encouragement with endogenous uptake | Separate assignment from uptake and follow the IV module's comparisons based on instrument assignment. |

For existing analyses, reproduce a coefficient, standard error, sample counts, and a reported average before revising them. Compute uncertainty for averages from the **full covariance**.

For a two-group contrast relative to reference period \(b\),

\[
\widehat\delta_k=(\bar Y_{T,k}-\bar Y_{C,k})-(\bar Y_{T,b}-\bar Y_{C,b}).
\]

A low reference gap can create positive leads throughout; rebasing shifts contrasts while preserving the underlying discrepancy. For staggered treatment, examine eligible cohort-time comparisons and their aggregation.

## 2. Diagnose the discrepancy before choosing a repair

- **Measurement:** check source coverage, coding changes, duplicates, aggregation, exposure denominators, zero versus missing, and whether treatment changes the ability to observe the outcome. Resolve construct validity before interpreting coefficients.
- **Both groups:** examine levels and changes, distribution tails, zeros, component outcomes, coefficient and variance influence, and weight concentration. Separate level differences from trend differences and verify whether extreme observations reflect valid activity or measurement errors.
- **Calendar and assignment:** map discrepancies to seasonality, earlier interventions, anticipation, concurrent policies, recording changes, and spillovers. Calendar effects absorb common shocks; investigate group-specific seasonal responses with evidence beyond date coincidence.
- **Support:** tabulate eligible treated and comparison units by cohort and event time. Late cohorts can have long prehistories but short follow-up; not-yet-treated controls eventually disappear. Separate unsupported estimates from estimated zeros.
- **Selection and composition:** examine attrition, migration, changing survey coverage, baseline left-censoring, and restrictions based on future behavior. Distinguish a real population change from a data error. Restricting to eventual adopters changes the population and can condition on treatment-induced behavior.

Keep sensitive unit-level records private. Use cached aggregates when sufficient; inspect raw records when needed to validate measurement.

## 3. Plan a limited set of justified adjustments

Explain what diagnosed problem each change addresses and whether it changes the population, outcome, assignment contrast, assumption, estimator, or presentation. Choose specifications and thresholds for construct validity, comparison credibility, and support, rather than the desired sign, significance, or pretest result. Record prior results that informed each choice, exploratory versus confirmatory status, and any reuse of validation data for selection.

Plan a limited set of changes, starting with one dimension at a time and common-sample comparisons where useful.

| Direction | Appropriate use | Specify or check |
|---|---|---|
| Measurement and outcomes | Correct errors; compare validated definitions, components, participation, intensity, or rates | Outcome units, denominator, construct validity, and assignment process |
| Transformations and tail handling | Demeaning, standardization, logs/asinh, proportional means, winsorization, or trimming | Target quantity, identifying scale, calibration, operation order, and affected mass/sample; follow the [transformation module](references/transformations-and-tail-handling.md) [L9–L10] |
| Baseline restrictions | Common support, stable coverage, eligibility using predetermined information | Changes the target population; noisy screening creates regression-to-the-mean concerns [L7] |
| Conditional and opposing effects | Explain a null average through substantively motivated baseline subgroups or continuous modifiers; retain the overall benchmark | Compare effects directly, reconcile aggregation, and assess identification for the claimed subgroup effect or contrast. Follow the [heterogeneity workflow](guidance/null-and-heterogeneous-effects.md). |
| Treatment and timing definitions | Validate start dates, persistence, dose, and anticipation | Sustained-use definitions can use future observations relative to onset; document that selection |
| Comparison groups | Never-treated, not-yet-treated, alternative eligible groups, or synthetic donors | Assess anticipation, earlier treatment, spillovers, follow-up, and actual eligibility |
| Matching and weighting | Predetermined demographics, institutional features, outcome histories, volatility, or other justified covariates | Overlap, weight concentration, regression to the mean, and preperiod validation [L6–L7] |
| Conditional seasonality | Baseline characteristics interacted with time, control-based outcome models, or proportional means | Requires overlap and transportable untreated responses; unrestricted treated-post terms absorb the effect |
| Estimator changes | Levels/log-OLS, baseline-weighted log-OLS, PPML, cohort-time/DR DiD, synthetic weighting, SDID, factor or imputation methods | Estimand and identifying restrictions (§4); preperiod fit and independent validation |
| Alternative designs | Triple differences, negative controls, discontinuities, or encouragement IV | The additional identifying restriction and evidence supporting it |
| Windows and references | Substantive horizons, common cohort support, anticipation buffers, reference sensitivity | Separate estimation, summary, and display windows (§6) |

For transformations, distinguish changing outcome values, trimming observations, and excluding units. The linked module owns scale, cutoff, resolution, and calibration rules; retain the raw-outcome benchmark and compare common samples to separate these changes.

Distinguish sampling/representation weights from causal-comparison weights. ATT-style control weighting retains the treated target; overlap weighting generally changes it. For combined weights, define the resulting target and variance procedure.

Report overlap, unmatched units, covariate balance, weight extrema/concentration, and effective sample size \((\sum w)^2/\sum w^2\). Fit using predetermined information, multiple baseline observations where available, and a stated preperiod prediction/balance criterion. Separate training/tuning from later preperiod validation when time support permits.

Use inference appropriate to the estimator for fitted weights and nuisance models, including its resampling method. Check whether contemporaneous covariates, denominators, or offsets respond to treatment before including them.

## 4. Match the estimator to the design

Match the method's identifying restrictions and data requirements to §1. Retain those assumptions when interpreting changes in fit or precision.

| Method | What it requires or changes | Check before interpreting |
|---|---|---|
| Cohort-time / CSDiD | ATT(g,t), eligible untreated comparisons, conditional parallel trends and no anticipation [L1] | Risk sets, covariate timing, base-period convention, aggregation and cohort support |
| Heterogeneity-robust event study | Avoids inappropriate already-treated comparisons [L2] | Check conventional TWFE leads for contamination from heterogeneous treatment effects |
| Stacked event study | Cohort-specific eligible comparison sets, event windows, and stack-specific unit/time effects [L18] | Reused controls and unequal cohort support change implicit weights; define aggregation and cluster on original units |
| Doubly robust DiD | Conditional parallel trends; consistency if either specified propensity or outcome model is correct [L3] | Use the panel or repeated-cross-section version appropriate to the data |
| Synthetic control / weighting | Donor representability and stable untreated outcome structure | Training versus validation fit, donor support/concentration, unaffected donors and inference |
| Synthetic DiD | Published estimator combines unit and time weights [L4] | Implement its weighting procedure; label custom synthetic contrasts separately |
| FE / interactive FE / matrix completion | Untreated-outcome imputation under additive/factor/low-rank restrictions [L5] | Holdouts, tuning, convergence, treatment feedback, and software version |
| Non-absorbing or varying-dose DiD | Appropriate treatment histories and dynamic estimands [L17] | Carryover, eligible unchanged paths, and supported contrasts |
| Time discontinuity | Smooth counterfactual evolution and no competing discontinuity [L12] | Seasonality, bandwidth, serial dependence, and placebo dates |
| Proxy / negative control | Explicit proxy exclusion and relevance restrictions [L14] | Evidence that the auxiliary variable meets the proposed exclusion restriction |

Label custom approximations and verify their numerical implementation against a trusted method where feasible. Record changes to normalization, model, or reference as distinct specifications.

For one common treatment date, check whether Sun–Abraham interactions, binary switcher contrasts, and a single-stack event study reduce to the same weighted DiD. Agreement then verifies implementation rather than providing independent evidence against confounding. Genuine staggered timing requires cohort-specific comparisons and aggregation.

For counterfactual imputation, record the additive/factor/low-rank model, untreated periods used to fit unit effects, fitting weights versus aggregation weights, and software support. Preserve numerical-tolerance checks and validate predictions on withheld periods rather than fitted residuals.

## 5. Separate identification, magnitude, and precision

Parallel trends concerns untreated changes between groups; their raw outcome paths need not be flat. Assess pre-treatment contrasts through magnitudes, uncertainty, joint tests, and power or substantive equivalence tolerances. A nonrejection does not establish parallel trends; an isolated significant lead warrants investigation. Distinguish pointwise from simultaneous intervals and account for pretest-based selection, which can distort inference. [L8]

For material trend discrepancies, assess a defensible comparison or conditional-trend model, sensitivity bounds, or an exploratory interpretation. State a trend model's extrapolation assumption. Use sensitivity analysis such as HonestDiD with compatible estimates/covariance and justified restrictions, ranges, breakdown values, and numerical limits. Distinguish bounds on changes in untreated gaps from bounds on accumulated bias. [L11]

Distinguish a near-zero estimate with a narrow interval from an imprecise result that permits large effects. Claim negligible effects relative to a justified substantive equivalence range. Assess sign, precision, and causal interpretation separately.

Preserve serial dependence and reflect assignment, common shocks, and survey sampling in inference. Base precision on independent assignments; choose a procedure that accommodates the available clusters or treated units, including few-cluster settings. [L15] Define the tested family across explored outcomes and specifications; use suitable multiplicity adjustment or independent confirmation for confirmatory claims after a broad search.

## 6. Present the supported conclusion and preserve the audit trail

Retain the full trial record, including nulls, positive and negative effects, overlap failures, nonconvergence, and undefined estimates.

Choose figures for the question. Event-study figures are optional, including for subgroup analyses; tables or coefficient plots can communicate average effects. Report material diagnostic findings and their implications in the text, with detailed estimates and uncertainty in a table or appendix.

When showing event studies, separate estimation, summary, and display windows. Keep the full path, including leads and late reversals, available alongside any display subset. Label the event clock, outcome units, aggregation, reference, and interval type; distinguish normalized references from estimated zeros and break paths across unsupported points. Use the visualization skill for figure production.

Write the question and target quantity, data and groups, method, effect with units and uncertainty, and interpretation. Following [paper-writing's scope guidance](../paper-writing/references/main-text.md#state-the-answer-directly), explain a consequential assumption or limitation where it affects the claim; carry that context forward rather than appending the same caution to each result.

For implementation, retain a diagnosis, justified batch plan, trial record, reusable estimates/covariance and reproduction commands, and a comparison table explaining population/scale changes. Save appropriate input/configuration hashes and software versions. Validate membership, observation rules, timing, support, coefficients, covariance, and figure/table agreement. Figure-only revisions should reuse saved estimates. For advice alone, provide a plan and mark estimation as not run.

Stop specification search when progress depends on new assignment variation, measurements, or comparisons, or when instability persists across justified specifications. State the supported conclusion and what additional evidence would resolve the remaining issue.
