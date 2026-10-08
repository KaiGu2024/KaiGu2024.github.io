# Figure 3: matched estimator comparison

Exploratory batch planned October 5, 2026, before computing this batch. Earlier outcomes and specifications have already been inspected.

## Fixed design

Use exactly the selected Figure 3 roster: 567 prior-anonymous targets and 25,193 prior-nonuser controls. All targets share February 5, 2025 access timing; controls remain unassigned for this access contrast even if they later use ChatGPT. Preserve original ACS household weights, missing count cells as zeros, Wednesday-Tuesday weeks -18 through 24, and summary weeks 0-24. The household eligibility screen is maximum daily loads <=25 during October 2-November 26. Search is capped once at 55 per household-week; this is the winsorization, not an additional transformation. Sessions are uncapped. No new restrictions or post-outcome selection.

## Estimators and comparisons

1. Reproduce Figure 3's reference-week -1 weighted DiD, covariance, and IV ratio.
2. Estimate Sun-Abraham cohort-by-event interactions and a correctly specified single-stack event-study regression. With one treated cohort they should reproduce the benchmark; keep household clustering.
3. Run de Chaisemartin-D'Haultfoeuille dynamic switcher contrasts using the actual common-date binary exposure. Preserve non-normalized effects (normalized dose-history effects target a different quantity). Check package event numbering and preperiod placebo signs.
4. Estimate ACS-weighted additive FE counterfactuals (FEct). Its natural imputation uses all 18 preweeks, unlike Figure 3's single reference week. Verify this difference explicitly and provide a reference-aligned comparison without relabeling it as a new estimator.
5. Re-estimate IFE and matrix completion on the same screened/capped data and complete horizon. Hold the previous factor candidate grid (0/1/2) and penalty fractions (.05/.2/1); choose using rolling preperiod predictions, not post effects. Clearly record how ACS weights enter fitting versus aggregation. Preserve all tuning candidates and failures.

## Inference and diagnostics

Use household influence covariance for linear contrasts; household resampling with 199 fixed-seed stratified draws for selected factor models, keeping the chosen tuning fixed and recording all nonconvergence. Keep full preperiod diagnostics and a separate first-ten-weeks fit predicting -8 through -1. These diagnostics overlap the prior tuning folds and are exploratory. Compare FEct's multiweek baseline with the -1 reference explicitly. Report the paired session/search stages and Fieller ratio only for coherent matched estimators; do not label a search-factor/additive-session hybrid a full factor-IV estimator.

## Skill audit before this batch

The general `skills.md` routes heterogeneity-robust event studies, FE/IFE/MC, and non-absorbing dynamic DiD. `references/literature.md` cites Sun-Abraham (L2), fect (L5), and de Chaisemartin-D'Haultfoeuille (L17). The trial inventory records prior FE candidates and selected IFE/MC fits. It does not document an executed same-Figure-3 comparison for these methods or a dedicated stacked-DiD method entry. This batch fills that gap.

## Completed results

All requested estimator families were evaluated. The baseline point path and full covariance reproduce Figure 3 from the copied daily records. Sun-Abraham and one-stack regressions reproduce both stages and their full household CR0 covariance. Dynamic-switcher effects reproduce the same point contrasts to the package's five-decimal output precision. The package's placebo sign already matches lead-minus-reference; no sign reversal is applied.

| Estimator | Search loads per household-week, weeks 0-24 | Nominal 95% interval |
|---|---:|---:|
| Figure 3 / Sun-Abraham / dynamic switcher / one stack | -1.31 | [-2.61, -0.01] |
| ACS-weighted additive FEct | -0.34 | [-1.00, 0.32] |
| Interactive FE, rank 2 | 2.28 | [0.16, 4.40] |
| Matrix completion, fraction 0.2 | -0.39 | [-1.06, 0.28] |

FEct is fitted with ACS weights on untreated cells. Its change comes from using all 18 preweeks, not week -1. The reference-aligned point path and covariance recover Figure 3 exactly. Its first stage is +0.1367, SE 0.02237, and the Fieller ratio is -2.46 [-8.26, 2.33]. Recorded sessions are zero in both groups throughout the preperiod, so the linear session estimates agree under either baseline.

IFE/MC retain the previously validated fect 1.0.0 **unweighted fitting loss**, with ACS-weighted target aggregation. Thus sample, cap, time support, and target aggregation match Figure 3, but fit weighting differs. No factor-IV ratio is asserted. Preperiod tuning selects rank 2 and penalty fraction 0.2; all six candidate fits, CV scores, 199 bootstrap refits, and numerical diagnostics are saved. All default-tolerance bootstrap fits converge. At tolerance 1e-5, IFE reaches an iterate of +4.52 without converging at 501 iterations (both full and withheld fits fail); MC converges to -0.42. Do not promote the failed IFE iterate to an estimate.

Withheld weeks -8 through -1 reject zero search-prediction errors jointly for FEct (p=.01584), IFE (p=.02485), and MC (p=.04359). These are exploratory, partially reused validation data. None establishes a repaired trend assumption.

## Dynamic-switcher implementation and inference audit

The unmodified DIDmultiplegtDYN 2.1.2 million-row call was stopped after more than 25 CPU minutes without returning estimates. Under this fixed-weight balanced single-cohort design, group-time weighted means are exact sufficient statistics for the dynamic point contrasts. Running the native package on those means confirms all 25 post effects and 17 placebos for both outcomes. **The resulting two-group standard errors are discarded**, and published CSVs retain only point estimates and event times.

Separately, the native package estimates the post-window average on all 25,760 households, using week -1 and each household's mean over weeks 0-24. This retains serial dependence in the average. Native search and session SEs are .66311 and .02239 versus the common CR0 values .662528 and .022374. Their difference is reproduced by the native treated/control group finite-sample factors n/(n-1), within native rounding. The comparison table and event bands use the original full household influence covariance. This exact common-date reduction is not a general substitute for dynamic-package estimation under staggered, reversible, unbalanced, or time-varying-weight designs.

## Saved evidence and reproduction

- `data/analysis/figure3_estimators/`: screened/capped inputs, paired-stage points/covariance, all factor points, selected-model bootstrap draws.
- `data/results/figure3_estimators/`: exact design, stage/IV summaries, native coefficients/covariance, CV/candidates, warnings/version record, numerical verification and plot rows.
- `figures/robustness/`: active common-date and FEct panels, PDF only. IFE/MC panels remain under `archive/counterfactual-trials/figures/robustness/`.
- `report/figure3-estimator-comparison.pdf`: readable comparison; Appendix A.6 and its table summarize the results.
- Scripts: `code/figure3_estimators.py prepare`, `code/figure3_estimators.R`, `archive/counterfactual-trials/code/figure3_estimators.py factors`, `code/collect_figure3_estimators.py`, and the plotting wrappers split between active `code/figures/` and `archive/counterfactual-trials/code/figures/`.

`skills.md` now distinguishes single-cohort equivalence, additive versus interactive imputation, baseline changes, fit versus aggregation weights, and stacked-design support/weighting. Literature guide L18 adds stacked DiD; L2/L5/L17 software notes and the case trial inventory link this completed batch. These lessons do not impose this case's thresholds or target population on other designs.


## Folder curation

IFE and matrix-completion model scripts and eight corresponding PDFs were subsequently moved into `archive/counterfactual-trials/`. The active common-date PDF was renamed `sun-abraham-dcdh-stacked-did.pdf`. This relocation does not change any estimates, diagnostics, confidence intervals, or the complete evidence summary above.
