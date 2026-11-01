# Wide confidence intervals and estimation efficiency

Use this workflow when a DiD estimate is too imprecise to distinguish substantively different conclusions. Improving precision means learning more about a stated effect while retaining valid uncertainty. It does not mean forcing an interval to exclude zero.

The recent-method menu covers calendar years **2024–2026**, checked November 1, 2026. Publication years and working-paper revisions are distinguished in [literature entries L21–L27](../references/literature.md#l21-efficient-use-of-preperiods-and-comparison-groups). This is a targeted search, not an exhaustive review. L3 supplies the older doubly robust foundation.

## 1. Diagnose why the interval is wide

Reproduce the benchmark, then record:

- **Target and scale:** population, ATT or other contrast, outcome units, cohort weights, horizons, anticipation window, and comparison eligibility. Specify the smallest substantively important effect independently of the observed estimate.
- **Independent information:** treated and control assignment clusters, their size imbalance, eligible cohort-time cells, and supported follow-up. Thousands of observations within a few treated clusters do not supply thousands of independent assignments.
- **Variance contribution:** residual outcome-change variability, influential units/clusters, serial correlation, propensity-score overlap, weight concentration and ESS, missingness, and how many valid preperiods and comparisons are actually used.
- **Interval construction:** confidence level, pointwise CI versus simultaneous band, critical value/degrees of freedom, cluster/survey correction, fitted-nuisance uncertainty, and whether the interval incorporates sensitivity to violations of parallel trends.

For a symmetric Wald interval, separate its half-width into critical value times SE. A simultaneous band can widen with the tested family even if the estimator's variance is unchanged; a sensitivity interval also reflects identification uncertainty. Neither is automatically an estimation failure. Keep these distinctions when comparing widths.

For a fixed weighted average of estimated effects, use

\[
\widehat\theta=a'\widehat\tau,\qquad
\widehat{\operatorname{Var}}(\widehat\theta)=a'\widehat\Sigma a.
\]

Retain off-diagonal covariance. If aggregation weights are estimated, account for their uncertainty using the method's influence function or valid resampling procedure. An average can be estimated more precisely than individual horizons, but it answers an average-effect question; keep the dynamic estimates available.

## 2. Classify each proposed change before fitting it

| Type of change | What to establish |
|---|---|
| Same target and identifying model, better estimator | Explain which valid information the benchmark fails to use and why the alternative can use it. Efficiency is relative to a specified model and estimator class. |
| Same target, stronger restrictions | Name the new restrictions on trends, covariance, conditional means, composition, or effect homogeneity. Assess their substantive credibility before examining the new CI. |
| Different target | Label trimming, overlap weighting, changed cohort/horizon weights, outcome transformations, and pooling across substantively different effects as new questions. |
| More or better data | Consider additional independent assignments, credible controls, reliable outcome measurement, or recoverable incomplete observations; assess selection and comparability. |

**Separate estimation weights from target weights.** Combining several valid estimates of the same parameter can improve precision. Inverse-variance weighting heterogeneous cohort or horizon effects generally changes their substantive average. Do not replace population weights with precision weights and continue calling the result the original ATT.

## 3. Choose a method that addresses the diagnosed bottleneck

The conditions below are routing criteria. Read the cited method and verify software support for the actual design before implementation; the list does not establish a universal ranking.

| Situation | Candidate and efficiency mechanism | Conditions and practical limits |
|---|---|---|
| Short panel with several credible preperiods and untreated comparisons | **Chen, Sant'Anna, and Xie (2025)**: efficient influence-function estimation combines information across baselines and comparison groups with covariance-aware, generally nonuniform weights. [L21] | Requires the applicable overlap, no-anticipation, sampling, and trend assumptions. Their **PT-All** supports extra moments across groups and periods; **PT-Post** alone does not justify them. Efficiency is asymptotic, not a promise of a narrower CI in every sample. |
| Staggered adoption with a credible untreated-outcome model | **Borusyak, Jaravel, and Spiess (2024)**: fit the counterfactual on untreated observations, impute treated-cell effects, and aggregate to the specified target. [L22] | Their OLS efficiency benchmark assumes spherical errors; unbiasedness under their outcome model does not require spherical errors. Use dependence-robust inference and verify identification of each predicted cell. |
| Strongly persistent errors | **Harmon (December 2024 revision)**: consider stepwise DiD for later effects under staggered adoption. [L23] | Under the paper's strong-persistence benchmark, conventional modern DiD can already be efficient with common timing and a balanced panel. Diagnose persistence; do not assume an imputation estimator dominates every covariance structure. |
| Repeated cross-sections with possible composition changes | **Sant'Anna and Xu (2026)**: efficient, rate-doubly-robust estimation accommodates changing composition. [L24] | Check conditional trends, overlap, covariate timing, and the target population. Ruling out composition changes can improve efficiency if correct and cause bias if incorrect. Nonrejection of a composition test does not establish stationarity. |
| Repeated cross-sections with credible regression restrictions | **Deb, Norton, Wooldridge, and Zabel (2024; April 2026 revision)**: FLEX uses group-time effects and flexible covariate interactions, with an imputation interpretation. [L25] | Efficiency depends on its model and homoskedasticity assumptions. This is a structured regression alternative, not a generic recommendation to use a single pooled TWFE coefficient. |
| Incomplete pre- or post-treatment outcomes | **Testa, Kennedy, and Reimherr (2025; January 2026 revision)**: efficient, multiply robust estimation under specified missing-at-random conditions. [L26] | The developed setting is two groups and two periods. Check response positivity and the applicable missingness/identification conditions; do not transfer the result automatically to a staggered panel or missing-not-at-random attrition. |

For L21, read §§2.2–4 and Corollary 3.1 before selecting additional moments. If only last-preperiod comparisons were justified, earlier baselines require stronger restrictions; passing pretrend tests does not establish them. Check covariance conditioning and weight concentration, and document regularization. Verify the published procedure rather than substituting a generic baseline average or trusting a command named `efficient`.

### Covariate adjustment and nuisance estimation

Use predetermined predictors of **untreated outcome changes** within a justified conditional-DiD model. Doubly robust estimation can protect consistency against one misspecified nuisance model; its efficiency result requires the relevant models and regularity conditions, not merely the label “DR.” [L3] Extra covariates are not guaranteed to reduce variance: weak overlap, overfitting, and weak predictors can erase gains. Conditioning can also change the parallel-trends assumption; an outcome history is not automatically a valid adjustment variable. Follow the matching and regression-to-the-mean checks in the main skill.

When the chosen procedure supports machine learning, use its orthogonal score and appropriate cross-fitting, keeping dependent observations together and respecting assignment clusters. Record folds, seeds, nuisance performance, propensity tails, and sensitivity to tuning. Do not substitute generic outcome residualization for a DiD score, adjust for treatment-induced covariates, or assert that cross-fitting repairs weak overlap or few-cluster inference.

### Inference and other design choices

Hansen (2025) studies jackknife inference for DiD regressions. [L27] Treat this as an inference-quality check in the applicable regression setting, not a guaranteed precision gain or a plug-in solution for every estimator. Better-calibrated intervals can be wider.

If credible added periods or controls are available, assess their contribution and eligibility rather than maximizing the row count. Adding postperiods can change the horizon target; adding controls can change the identifying comparison. Correct measurement errors and recover valid observations when possible. Do not remove real extreme outcomes, weaken clustering, suppress nuisance estimation uncertainty, or treat duplicated stack observations as new assignments to obtain a smaller SE.

## 4. Run a bounded comparison and decide what to report

1. Preserve the original specification and choose a small set of alternatives with written rationales. Set tuning and validation rules before comparing treatment significance; record prior outcome inspection.
2. Hold the target population, outcome scale, aggregation weights, event support, confidence level, and dependence treatment fixed wherever possible. Show common-sample comparisons and label any new assumptions or target changes separately.
3. Validate nuisance fits, covariance conditioning, overlap, influence, convergence, and estimator-specific inference. Use documented software and check a simple special case against a transparent calculation. Finite-sample simulations can assess bias and coverage if needed, but must reflect plausible dependence and heterogeneity rather than be tuned to favor one estimator.
4. Report `method | target/sample/assumption changes | clusters and ESS | estimate | SE | CI and type | diagnostics`. For comparable targets, a variance ratio such as `SE(candidate)^2 / SE(benchmark)^2` describes estimated precision; it is not proof of efficiency or coverage. Retain failures and unstable candidates in the [trial record](../assets/trial-record.md).
5. Keep a candidate only when its identifying argument, numerical behavior, and inference are defensible. Do not rank methods by whether they cross a significance threshold. If selection used the same outcomes, label it exploratory and account for selection or seek independent confirmation where feasible.

Stop when the limiting factor is a lack of independent treated assignments, credible overlap, or reliable outcome information. Report the substantively relevant effects still inside the interval. For planning, assess minimum detectable effects or power under specified alternatives and the actual assignment/dependence structure; avoid “observed power” computed from the fitted effect. A wide CI can be the correct conclusion.
