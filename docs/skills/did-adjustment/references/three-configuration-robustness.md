# Three-configuration robustness comparison

## Scope and decisions

The author requested inclusion of baseline-35 uncapped results in the report and appendix and updated robustness across three configurations. Interpreted as: (1) existing Figure 3 baseline-25/weekly-cap-55 sample; (2) existing Figure 4 broader uncapped sample; (3) baseline-35 uncapped sample. No cleaning thresholds or assignment rules were retuned. All three retain the February 5 common assignment date, fixed ACS weights, weeks -18 through 24, and post averages over 0 through 24.

The active robustness methods are Sun-Abraham, de Chaisemartin-D'Haultfoeuille dynamic switcher DiD, one-stack DiD, and additive FEct. Earlier IFE/MC trials were not rerun or generalized to unestimated configurations. Their complete historical results, including adverse diagnostics, remain in the appendix and earlier estimator-comparison report.

This extends earlier exploratory analysis; it is not a preregistration or a new untouched validation exercise. Two-group weights, balanced observation support, outcome definition, and the comparison roster are fixed within each configuration. The broader roster has 29,811 controls; the two screened designs begin with the updated 29,809-control classifier. Counts are never silently equalized.

## Evidence and results

`three_configuration_robustness.py prepare` reconstructs the three panels, reproduces all original coefficients and full covariance, and computes paired benchmark and additive FEct estimates. Figure 3 native package results are reused. `figure3_estimators.R broader_uncapped` and `figure3_estimators.R baseline35_uncapped` extend the same package calls to the other panels.

All three common-date estimators reproduce every configuration's benchmark search and session coefficients. Sun-Abraham/stacked full covariance matches the original household scores. dCDH dynamic points use the exact fixed-weight, balanced, group-time sufficient-statistic reduction, with 25 post contrasts and 17 lead-minus-reference placebos. Two-group uncertainty is discarded. A native household-level two-period average-effect run also verifies the point and SE, with the documented n/(n-1) finite-sample difference. This is not claimed to be a full native household-level dynamic covariance run. Published intervals retain original cross-week/cross-outcome household-score covariance.

| Configuration | Targets / controls | Reference-week search contrast | Additive FEct search contrast | FEct withheld p |
|---|---:|---:|---:|---:|
| Baseline 25 + weekly cap 55 | 567 / 25,193 | -1.31 [-2.61, -0.01] | -0.34 [-1.00, 0.32] | .0158 |
| Broader uncapped | 946 / 29,811 | -5.13 [-7.94, -2.33] | -2.92 [-4.59, -1.24] | 7.99e-7 |
| Baseline 35, uncapped | 684 / 27,092 | -2.27 [-3.96, -0.58] | -0.62 [-1.74, 0.49] | .00308 |

Intervals are nominal 95%; units are search loads per household-week, capped only in the first configuration. FEct is ACS-weighted untreated-cell additive household/time fixed-effects imputation, checked against direct fixest WLS predictions. It uses all 18 preweeks; the benchmark uses week -1. Rebasing FEct to -1 exactly reproduces benchmark coefficients and full covariance. The withheld exercise trains on -18..-9 and predicts -8..-1. It is not in-sample fitted residual validation.

Full and displayed search pretests reject in all three configurations; all FEct withheld tests also reject. Sessions have zero recorded preperiod values, so all-pre and week-1 baselines yield identical first stages. The negative session-adjusted ratio remains assumption-dependent. Estimator agreement with one assignment cohort is an implementation check, not independent identification evidence.

## Reproduction

From the package root:

```powershell
python code/three_configuration_robustness.py prepare
Rscript code/figure3_estimators.R broader_uncapped
Rscript code/figure3_estimators.R baseline35_uncapped
python code/three_configuration_robustness.py verify
Rscript code/twfe_covariance.R
python code/verify_twfe_covariance.py
python code/build.py --plots --verify
```

Reconstruct the already-saved Figure 3 native checks if needed using `python code/figure3_estimators.py prepare` then `Rscript code/figure3_estimators.R`. The default build uses saved outputs rather than refitting models.

Saved inputs and joint covariance: `data/analysis/three_configuration_robustness/`. Native outputs and version records: `data/results/three_configuration_robustness/{broader_uncapped,baseline35_uncapped}/`; Figure 3 native records remain in `data/results/figure3_estimators/`. Full analytical paths, summaries, comparison, and 60-check verification: the top level of `data/results/three_configuration_robustness/`. Temporary long panels and native execution logs are under `build/three_configuration_robustness/`. PDF-only figures are directly under `figures/robustness/` with configuration prefixes.

Documentation: [Sun-Abraham](https://lrberge.github.io/fixest/reference/sunab.html), [dynamic switcher DiD](https://github.com/Credible-Answers/did_multiplegt_dyn), [counterfactual imputation](https://yiqingxu.org/packages/fect/02-fect.html). Installed versions and native outputs, rather than current documentation defaults, determine the implemented checks.


The static TWFE extension and three covariance choices are documented in [the separate trial record](twfe-covariance.md). They hold each sample and outcome fixed and add 60 independent numerical checks. The static estimate equals the additive FEct average on these panels; the two-way intervals widen.
