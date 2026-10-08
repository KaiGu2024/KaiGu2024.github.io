# Static TWFE and covariance sensitivity

This exploratory extension adds a static treatment-group-by-post coefficient to each of the three existing February access configurations. No roster, ACS weight, observation window, zero-fill rule, activity screen, or outcome cap changes. Outcomes are search loads and conversation sessions per household-week. The existing saturated event study already includes household and week fixed effects; the new static regression has one post coefficient.

## Model and estimand

Weighted least squares estimates `Y_it = household_FE + week_FE + beta * target_i * post_t + error_it`, with post weeks 0–24 and preweeks −18 through −1. Each household has 43 observations and a fixed positive ACS weight. In this balanced common-date design, beta equals the difference between the average post group gap and the average of all 18 preperiod gaps. It therefore equals additive FEct's average effect and its unadjusted household covariance. This is verified against independent weighted within-transformation calculations, not assigned from the FEct result. The reference-week event-study summary uses week −1 and is a different baseline contrast.

## Inference choices

The same three calculations apply to both outcomes and every configuration. Estimates are fixed while covariance and critical values vary. Native implementation: fixest 0.11.1; its older `ssc` argument names are saved in `data/results/twfe_covariance/software_options.txt`.

1. Household CR0, no finite-sample multipliers, normal critical values, matching the earlier reporting convention.
2. Household CR1: multiply CR0 by `N/(N−1) * (n−1)/(n−44)`, with `n=43*N`; use a t distribution with `N−1` degrees of freedom. Under the installed package's nested-FE convention, household effects are nested and week effects contribute to K=44.
3. Two-way household/week CR1: unadjusted variance is household component + week component − household-week cell component. Multiply by `43/42 * (n−1)/(n−2)` and use t with 42 degrees of freedom. Both fixed effects are nested under two-way clustering; the package uses K=2. These settings are explicit, including `cluster.df='min'` and `fixef.K='nested'`.

The saved covariance components include the full joint 2×2 covariance of sessions and search. All six native scalar variances are positive; no covariance-repair warning occurred. The independent verifier reconstructs every coefficient, variance, parameter correction, and confidence interval, and compares the household joint covariance with saved additive FEct results: 60 checks pass.

Two-way clustering admits same-week cross-household dependence and serial dependence within households. It does not allow arbitrary dependence across different households in different weeks, such as persistent treatment-group shocks. The dataset contains one access expansion, not thousands of independent treatment assignments. These comparisons address conditional precision, not the rejecting pretrends or treatment identification. We do not select an inference method according to significance. Existing event-study and Fieller intervals retain their original covariance.

## Results

Search effects and nominal 95% intervals:

| Configuration | Estimate | Household CR0 | Household CR1 | Household + week CR1 |
|---|---:|---:|---:|---:|
| 25/day household screen, weekly cap 55 | −0.34 | [−1.00, 0.32] | [−1.00, 0.32] | [−1.16, 0.49] |
| Broader uncapped | −2.92 | [−4.59, −1.24] | [−4.59, −1.24] | [−5.27, −0.57] |
| 35/day household screen, uncapped | −0.62 | [−1.74, 0.49] | [−1.74, 0.49] | [−1.91, 0.67] |

Conversation-session estimates are 0.137, 0.140, and 0.130. Their two-way intervals are [0.084, 0.189], [0.096, 0.185], and [0.084, 0.175]. All recorded session preperiods are zero; these results do not independently validate latent session trends. Full precision, standard errors, p-values, and counts are retained in `estimates.csv`.

## Reproduction

From the package root, prepare the exact long panels if they are absent:

```powershell
python code/figure3_estimators.py prepare
python code/three_configuration_robustness.py prepare
Rscript code/twfe_covariance.R
python code/verify_twfe_covariance.py
python code/build.py --verify
```

The build formats saved results; it does not refit. Main report Table 5 and appendix Table A2 add a static TWFE row. Appendix Table A4 and the companion robustness report contain the new covariance table, including both outcomes. The earlier duplicate estimator table is not restored. Current report/appendix prose omits archived factor-model discussion; the historical files and audit trail remain separate.

Primary reference: [fixest standard-error conventions](https://lrberge.github.io/fixest/articles/standard_errors.html). Installed options and native output, rather than current documentation defaults, determine the implemented calculations. On inference with few policy changes, see [Conley and Taber](https://www.nber.org/papers/t0312); this application does not implement their estimator.
