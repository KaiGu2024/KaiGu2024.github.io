# Wide confidence intervals and estimation efficiency

Use this workflow when a DiD estimate is too imprecise to distinguish substantively different conclusions.

The method menu covers **2024–2026**, checked November 1, 2026. [Literature entries L21–L27](../references/literature.md#l21-efficient-use-of-preperiods-and-comparison-groups) distinguish publication years from working-paper revisions. L3 supplies the doubly robust foundation.

## 1. Diagnose why the interval is wide

Reproduce the benchmark, then record:

- **Target and scale:** population, ATT or other contrast, outcome units, cohort weights, horizons, anticipation window, and comparison eligibility. Specify the smallest substantively important effect independently of the observed estimate.
- **Independent information:** treated and control assignment clusters, their size imbalance, eligible cohort-time cells, and supported follow-up.
- **Variance contribution:** residual outcome-change variability, influential units/clusters, serial correlation, propensity-score overlap, weight concentration and ESS, missingness, and how many valid preperiods and comparisons are actually used.
- **Interval construction:** confidence level, pointwise CI versus simultaneous band, critical value/degrees of freedom, cluster/survey correction, fitted-nuisance uncertainty, and whether the interval incorporates sensitivity to violations of parallel trends.

For a symmetric Wald interval, separate its half-width into critical value times SE. Simultaneous bands also reflect the tested family; sensitivity intervals also reflect identification uncertainty.

For a fixed weighted average of estimated effects, use

\[
\widehat\theta=a'\widehat\tau,\qquad
\widehat{\operatorname{Var}}(\widehat\theta)=a'\widehat\Sigma a.
\]

Retain off-diagonal covariance and account for estimated aggregation weights through the method's influence function or resampling procedure. When an average is the target, estimate it directly and retain the dynamic estimates for interpretation.

## 2. Classify each proposed change before fitting it

| Type of change | What to establish |
|---|---|
| Same target and identifying model, better estimator | Identify the additional information used and the model and estimator class in which efficiency is established. |
| Same target, stronger restrictions | Name the new restrictions on trends, covariance, conditional means, composition, or effect homogeneity. Assess their substantive credibility before examining the new CI. |
| Different target | Label trimming, overlap weighting, changed cohort/horizon weights, outcome transformations, and pooling across substantively different effects as new questions. |
| More or better data | Consider additional independent assignments, credible controls, reliable outcome measurement, or recoverable incomplete observations; assess selection and comparability. |

**Separate estimation weights from target weights.** Combining estimates of the same parameter can improve precision. Inverse-variance weighting heterogeneous cohort or horizon effects generally changes the target average.

## 3. Choose a method that addresses the diagnosed bottleneck

Choose among these methods using the data structure, identifying assumptions, and error covariance. Check software support for the chosen design.

| Situation | Candidate and efficiency mechanism | Conditions |
|---|---|---|
| Short panel with several credible preperiods and untreated comparisons | **Chen, Sant'Anna, and Xie (2025)**: asymptotically efficient influence-function estimation combines baselines and comparison groups using covariance-aware, generally nonuniform weights. [L21] | Overlap, no anticipation, and the specified sampling and trend assumptions. Extra moments across groups and periods use **PT-All**, a stronger restriction than **PT-Post**. |
| Staggered adoption with a credible untreated-outcome model | **Borusyak, Jaravel, and Spiess (2024)**: fit the counterfactual on untreated observations, impute treated-cell effects, and aggregate to the specified target. [L22] | The OLS efficiency benchmark assumes spherical errors; unbiasedness holds under their outcome model more generally. Use dependence-robust inference and check support for predicted cells. |
| Strongly persistent errors | **Harmon (December 2024 revision)**: consider stepwise DiD for later effects under staggered adoption. [L23] | Under the strong-persistence benchmark, conventional modern DiD can already be efficient with common timing and a balanced panel. Assess persistence when choosing the estimator. |
| Repeated cross-sections with possible composition changes | **Sant'Anna and Xu (2026)**: efficient, rate-doubly-robust estimation accommodates changing composition. [L24] | Conditional trends, overlap, appropriate covariate timing, and a defined target population. Ruling out composition changes can improve efficiency if correct and cause bias if incorrect. |
| Repeated cross-sections with credible regression restrictions | **Deb, Norton, Wooldridge, and Zabel (2024; April 2026 revision)**: FLEX uses group-time effects and flexible covariate interactions, with an imputation interpretation. [L25] | Efficiency depends on its regression model and homoskedasticity assumptions. |
| Incomplete pre- or post-treatment outcomes | **Testa, Kennedy, and Reimherr (2025; January 2026 revision)**: efficient, multiply robust estimation under specified missing-at-random conditions. [L26] | Two groups and two periods, response positivity, and the specified missingness and identification conditions. |

For L21, read §§2.2–4 and Corollary 3.1 to select additional moments. Check covariance conditioning and weight concentration, and document regularization.

For implementation of L21, consult the [R package and sample-count guidance](r-packages-and-sample-counts.md). The located `edid` R package is a third-party implementation limited to no covariates, balanced panels, and a common number of pre-treatment periods across cohorts. Confirm that scope before using it; a generic GMM package or another efficient staggered-adoption estimator is not an implementation of L21.

### Covariate adjustment and nuisance estimation

Use predetermined predictors of **untreated outcome changes** within a conditional-DiD model. Doubly robust estimation supports consistency when either nuisance model is correct; efficiency requires both models and the relevant regularity conditions. [L3] Assess predictive value, overlap, and overfitting when choosing covariates. State the conditional parallel-trends assumption and apply the main skill's regression-to-the-mean checks when using outcome histories.

For procedures supporting machine learning, use the DiD orthogonal score and cross-fitting that keeps dependent observations together. Record folds, seeds, nuisance performance, propensity tails, and sensitivity to tuning.

### Inference and other design choices

Hansen (2025) provides jackknife inference for DiD regressions. [L27] Use it to assess interval calibration in the applicable regression setting.

Assess the contribution and eligibility of additional periods or controls. Adding postperiods can change the horizon target; adding controls can change the identifying comparison. Correct measurement errors and recover valid observations where possible.

## 4. Compare methods and report the result

1. Preserve the original specification and choose alternatives that address the diagnosed bottleneck. State tuning and validation rules and record prior outcome inspection.
2. Hold the target population, outcome scale, aggregation weights, event support, confidence level, and dependence treatment fixed wherever possible. Show common-sample comparisons and label any new assumptions or target changes separately.
3. Check nuisance fits, covariance conditioning, overlap, influence, convergence, and estimator-specific inference. If finite-sample behavior is uncertain, assess bias and coverage in simulations reflecting the study's dependence and heterogeneity.
4. Report `method | target/sample/assumption changes | clusters and ESS | estimate | SE | CI and type | diagnostics`. For comparable targets, summarize estimated precision with `SE(candidate)^2 / SE(benchmark)^2`. Retain results and failures in the [trial record](../assets/trial-record.md).
5. Select a method based on its identifying assumptions, numerical stability, and inference. Label outcome-informed selection as exploratory and account for selection in confirmatory inference.

If precision remains limited by independent assignments, overlap, or outcome information, identify what additional data would help. For planning, assess minimum detectable effects or power under substantively specified alternatives and the study's assignment and dependence structure.
