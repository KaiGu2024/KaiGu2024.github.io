# Literature supporting the adjustment workflow

Primary sources checked October 5, 2026. This is targeted methods research, not a systematic review. Operational guidance applies these methods subject to their assumptions; no cited paper validates an application's assignment, measurement, or exclusion restrictions by itself. Publication years are distinguished from working-paper versions.

## L1. Cohort-time effects and eligible comparisons

Callaway, Brantly, and Pedro H. C. Sant'Anna (2021), **Difference-in-Differences with multiple time periods**, *Journal of Econometrics* 225(2), 200–230. [Author preprint](https://arxiv.org/abs/1803.09015), [published DOI](https://doi.org/10.1016/j.jeconom.2020.12.001).

Use explicit cohort-time effects, eligible untreated comparisons, conditional parallel trends, and stated aggregation weights. Changing the control rule or supported cohorts can change the estimand. The framework supports covariate adjustment and simultaneous inference; it does not instrument self-selected adoption merely by being staggered.

## L2. Event-study contamination under heterogeneous effects

Sun, Liyang, and Sarah Abraham (2021), **Estimating dynamic treatment effects in event studies with heterogeneous treatment effects**, *Journal of Econometrics*. [Author preprint](https://arxiv.org/abs/1804.05785), [published article](https://www.sciencedirect.com/science/article/pii/S030440762030378X).

Conventional staggered TWFE lead/lag coefficients can mix effects from other relative periods. Check the estimator before treating every lead as a clean pre-treatment test. A heterogeneity-robust estimator addresses this weighting problem; it does not establish parallel trends for endogenous adoption.

## L3. Doubly robust conditional DiD

Sant'Anna, Pedro H. C., and Jun Zhao (2020), **Doubly robust difference-in-differences estimators**, *Journal of Econometrics* 219(1), 101–122. [Author manuscript](https://psantanna.com/files/SantAnna_Zhao_DRDID.pdf), [repository version](https://arxiv.org/abs/1812.01723).

Under the identifying assumptions, consistency can hold if either the propensity or outcome-change model is correct. This robustness concerns nuisance models, not arbitrary violations of conditional parallel trends. Use the method's valid inference rather than attach an ordinary standard error to a custom adjustment. The paper provides separate panel and repeated-cross-section estimators; repeated cross-sections require the relevant sampling/composition assumptions, not fabricated individual trajectories.

## L4. Synthetic difference-in-differences

Arkhangelsky, Dmitry, Susan Athey, David A. Hirshberg, Guido W. Imbens, and Stefan Wager (2021), **Synthetic Difference-in-Differences**, *American Economic Review* 111(12), 4088–4118. [Author preprint](https://arxiv.org/abs/1812.09970), [published article](https://www.aeaweb.org/articles?id=10.1257/aer.20190159).

The estimator combines unit and time weighting under stated panel/factor conditions. Nonnegative donor weighting plus a reference difference is not automatically this estimator. Good prefit alone does not establish that donors reproduce the untreated postperiod.

## L5. Counterfactual estimators and fect

Liu, Licheng, Ye Wang, and Yiqing Xu (2024), **A Practical Guide to Counterfactual Estimators for Causal Inference with Time-Series Cross-Sectional Data**, *American Journal of Political Science*. [Published article](https://doi.org/10.1111/ajps.12723), [author preprint](https://arxiv.org/abs/2107.00856), [official fect documentation](https://yiqingxu.org/packages/fect/).

FE, interactive fixed effects, and matrix completion impute untreated outcomes under different structural restrictions. Use withheld periods, tuning, and convergence checks; in-sample residuals are not independent validation. The documentation warns that these methods still require restrictions on untreated outcomes and treatment feedback. Record the actual software version and settings used; current documentation may describe a different implementation from an older analysis.

## L6. Entropy balancing

Hainmueller, Jens (2012), **Entropy Balancing for Causal Effects: A Multivariate Reweighting Method to Produce Balanced Samples in Observational Studies**, *Political Analysis* 20(1), 25–46. [Author-hosted published paper](https://www.mit.edu/~jhainm/Paper/eb.pdf).

Calibrate weights to specified covariate moments. Report which moments, balance, weight concentration, and support. Moment balance does not demonstrate DiD parallel trends. A regularized approximation must not be reported as exact entropy balance when its constraints are not exact.

## L7. Matching can introduce regression-to-the-mean bias

Daw, Jamie R., and Laura A. Hatfield (2018), **Matching and Regression to the Mean in Difference-in-Differences Analysis**, *Health Services Research* 53(6), 4138–4156. [Published article](https://onlinelibrary.wiley.com/doi/10.1111/1475-6773.12993).

Matching on noisy baseline outcomes can introduce bias, including in settings where unmatched DiD was unbiased. Multiple early baseline observations and later validation are useful diagnostics, not a theorem that the bias disappears. Matching an observed holiday dip particularly risks selecting transitory shocks.

## L8. Pretest selection and power

Roth, Jonathan (2022), **Pretest with Caution: Event-Study Estimates after Testing for Parallel Trends**, *American Economic Review: Insights* 4(3), 305–322. [Published article](https://www.aeaweb.org/articles?id=10.1257/aeri.20210236), [published PDF](https://www.jonathandroth.com/assets/files/roth_pretrends_testing.pdf).

Nonsignificant leads can coexist with meaningful violations; selecting estimates conditional on passing a pretest can worsen bias and coverage. Report magnitudes, uncertainty, and power against substantively important deviations. Power assessment does not itself correct model selection.

## L9. Functional form changes the identifying assumption

Roth, Jonathan, and Pedro H. C. Sant'Anna (2023), **When Is Parallel Trends Sensitive to Functional Form?**, *Econometrica* 91(2), 737–747. [Published PDF](https://psantanna.com/files/ECTA19402.pdf), [publisher](https://onlinelibrary.wiley.com/doi/full/10.3982/ECTA19402).

Parallel trends generally depends on scale; validity in levels does not establish validity in logs. Invariance across increasing transformations requires a stronger distributional condition. A cap, which is not strictly increasing, also defines a different outcome requiring its own identifying argument; do not present winsorization as covered by that invariance result automatically.

## L10. Logs and asinh with zeros

Chen, Jiafeng, and Jonathan Roth (2024), **Logs with Zeros? Some Problems and Solutions**, *Quarterly Journal of Economics* 139(2), 891–936. [Author paper](https://www.jonathandroth.com/assets/files/LogUniqueHOD0_Draft.pdf), [published DOI](https://doi.org/10.1093/qje/qjad054).

Log(1+Y)/asinh effects depend on measurement units when treatment affects the zero/nonzero margin. They are not automatic percentage effects. Retain raw outcomes and explicit units; consider separately defined participation and intensity questions or a proportional-mean model under its own assumptions.

## L11. Sensitivity to violations of parallel trends

Rambachan, Ashesh, and Jonathan Roth (2023), **A More Credible Approach to Parallel Trends**, *Review of Economic Studies* 90(5), 2555–2591. [Published PDF](https://www.jonathandroth.com/assets/files/HonestParallelTrends_Main.pdf), [DOI](https://doi.org/10.1093/restud/rdad018).

Replace exact parallel trends with transparent restrictions on counterfactual deviations. Relative-magnitude and smoothness restrictions encode different assumptions. Save joint covariance, assess a justified sensitivity range, and report breakdown and numerical boundaries. This bounds conclusions; it does not flatten data or validate instruments. An IV ratio needs a justified joint procedure, not separately divided ordinary intervals.

## L12. Time cutoffs do not automatically give conventional RD

Hausman, Catherine, and David S. Rapson (2018), **Regression Discontinuity in Time: Considerations for Empirical Applications**, *Annual Review of Resource Economics* 10, 533–552. [Published article](https://www.annualreviews.org/content/journals/10.1146/annurev-resource-121517-033306).

Serial dependence, concurrent changes, bandwidth, and short- versus long-run effects complicate calendar-cutoff designs. Conventional sorting tests may be irrelevant. Explain the time-series counterfactual rather than treating a national announcement as randomized assignment.

## L13. Name the IV-DiD framework before calling a ratio LATE

de Chaisemartin, Clément, and Xavier D'Haultfœuille (2018), **Fuzzy Differences-in-Differences**, *Review of Economic Studies* 85(2), 999–1028. [Published article](https://academic.oup.com/restud/article/85/2/999/4096388), [accepted manuscript](https://faculty.crest.fr/xdhaultfoeuille/wp-content/uploads/sites/9/2019/09/fuzzy_did.pdf).

Under this framework, the familiar Wald-DiD ratio needs additional treatment-effect restrictions for a switcher-LATE interpretation; changing treatment in controls matters. Alternative estimands/bounds use stated additional conditions. Do not transfer these restrictions indiscriminately to every IV-DiD framework.

Miyaji, Sho (2024; revised February 11, 2026), **Instrumented Difference-in-Differences with Heterogeneous Treatment Effects**, working paper, arXiv:2405.12083v6. [Revision record](https://arxiv.org/abs/2405.12083), [version read](https://arxiv.org/html/2405.12083v6).

DID-IV uses parallel trends in treatment and outcomes absent instrument exposure, with exclusion, relevance, monotonicity, no anticipation, and stated dynamic restrictions. Staggering concerns instrument exposure; later self-adopters are not automatically not-yet-exposed controls. Cohort/horizon Wald comparisons and aggregation must be coherent. Ordered-treatment responses differ from binary complier effects. Fitted probabilities converted to adoption dates are not the procedure established here.

## L14. Auxiliary outcomes require their own identifying restrictions

Freyaldenhoven, Simon, Christian Hansen, and Jesse M. Shapiro (2019), **Pre-event Trends in the Panel Event-Study Design**, *American Economic Review* 109(9), 3307–3338. [Published article](https://www.aeaweb.org/articles?id=10.1257/aer.20180609), [author-hosted published PDF](https://shapiro.scholars.harvard.edu/sites/g/files/omnuum7731/files/shapiro/files/pretrends.pdf).

The approach uses information about confounding under explicit proxy/exclusion and relevance restrictions. An auxiliary outcome cannot be assumed unaffected merely because it differs from the main outcome. Generic residualization does not establish this complete design.

## L15. Dependence and few policy changes

Bertrand, Marianne, Esther Duflo, and Sendhil Mullainathan (2004), **How Much Should We Trust Differences-in-Differences Estimates?**, *Quarterly Journal of Economics* 119(1), 249–275. [Published article](https://doi.org/10.1162/003355304772839588), [NBER record](https://www.nber.org/papers/w8841).

Ignoring serial dependence can severely understate uncertainty. Resampling unit-periods independently disregards within-unit serial dependence. Inference must also address shared assignment-group shocks where relevant; lower-level observations do not multiply independent policy changes. No single clustering or resampling remedy works for every design.

## L16. Weak-IV inference with dependent data

Andrews, Isaiah, James H. Stock, and Liyang Sun (2019), **Weak Instruments in Instrumental Variables Regression: Theory and Practice**, *Annual Review of Economics* 11, 727–753. [Published article](https://www.annualreviews.org/content/journals/10.1146/annurev-economics-080218-025643), [author manuscript](https://scholar.harvard.edu/files/stock/files/andrews_stock_sun_wirev_011119.pdf).

Weak instruments undermine conventional IV inference; diagnostics and confidence procedures must respect heteroskedasticity, serial correlation, or clustering. Report appropriate strength diagnostics and weak-IV-robust sets, rather than treating a conventional F threshold as universally sufficient. Ratio confidence sets may be unbounded; that is statistical information, not a plotting failure.

Search/access limitations: some publisher/NBER pages returned access errors; primary author PDFs, repository versions, and published metadata were used where available. No secondary tutorial was treated as the basis for a methodological claim.


## L17. Non-absorbing treatment and dynamic dose effects

de Chaisemartin, Clément, and Xavier D'Haultfœuille, **Difference-in-Differences Estimators of Intertemporal Treatment Effects**, working-paper record first posted 2020; version 14 revised May 12, 2026. [Author repository record](https://arxiv.org/abs/2007.04267), [version record](https://arxiv.org/abs/2007.04267v14). Record and abstract checked October 5, 2026; this addition supports method routing, not an implementation audit.

The framework allows nonbinary, non-absorbing treatments and lagged effects under stated parallel-trends conditions. Its path and normalized dynamic effects are not automatically an ATT for permanent first adoption. Inspect the full method's eligible comparisons, support, and assumptions before implementing it. The general skill routes such designs to an appropriate specialist estimator rather than recoding treatment reversals away.

Implementation sources checked October 5, 2026: [authors' DIDmultiplegtDYN repository](https://github.com/Credible-Answers/did_multiplegt_dyn) and the CRAN 2.1.2 source archive retained for the Figure 3 trial. Non-normalized effects compare a switcher's change since its last untreated period with eligible unchanged controls. Audit the native placebo sign: version 2.1.2 exports placebo l in the lead-minus-reference direction, corresponding to event week -1-l in this trial. No additional sign reversal is needed. In a balanced, single-date binary design these effects reproduce the corresponding weighted DiD contrasts; normalization by cumulative exposure would change the target.

## L18. Stacked DiD needs an explicit target and weights

Wing, Coady, Seth M. Freedman, and Alex Hollingsworth (2024), **Stacked Difference-in-Differences**, NBER Working Paper 32054. [Paper record](https://www.nber.org/papers/w32054), [authors' implementation](https://github.com/hollina/stacked-did-weights).

Construct cohort-specific subexperiments with eligible controls and common event support; state the aggregate target. Naive stacking can weight treated and control trends differently. Corrected weights and trimming address the intended supported aggregate, rather than making arbitrary stacked regressions robust. Cluster repeated appearances of a household by its original ID. With one treated cohort there is only one stack, no control duplication across stacks, and cohort balancing weights are constant; a saturated weighted event study has the same point estimates as the original common-date DiD.

### Software and normalization notes for L2 and L5

[Official fixest sunab documentation](https://lrberge.github.io/fixest/reference/sunab.html) defines cohort-by-relative-period interactions and their aggregation. In the Figure 3 trial, fixest 0.11.1's internal sunab function is used with reference -1 and never-assigned controls; household cluster corrections are disabled to compare its CR0 covariance with the existing influence covariance.

[Official fect imputation manual](https://yiqingxu.org/packages/fect/02-fect.html) and [IFE/MC manual](https://yiqingxu.org/packages/fect/04-ife-mc.html) describe untreated-outcome fitting and current weighting options. Do not transfer current-version weight support to fect 1.0.0. The Figure 3 additive FEct trial uses weighted untreated-cell least squares, independently verified by closed-form contrasts. Its IFE/MC trials retain the previously validated 1.0.0 unweighted fitting objective with ACS-weighted target aggregation, clearly labeled as a remaining specification difference.
