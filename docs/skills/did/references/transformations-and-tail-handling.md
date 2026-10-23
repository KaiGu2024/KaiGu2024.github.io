# Outcome transformations and tail handling

Use these options to address a diagnosed scale, volatility, or influence problem. Keep the raw-outcome benchmark and define the target quantity and trend assumption for each alternative.

## Levels, logs, and PPML

Choose the specification to match the economic question and untreated-trend restriction.

| Specification | Target and identifying scale |
|---|---|
| Levels OLS | Absolute mean effect in outcome units; additive parallel trends. |
| Log-OLS | Mean log effect; log-scale parallel trends. Equal-unit log changes in a simple balanced design are not an aggregate percentage effect. |
| Baseline-weighted log-OLS | Predetermined importance-weighted log effects; still targets mean logs, not the arithmetic mean. |
| PPML with log link | Multiplicative conditional mean of untransformed Y; requires a credible untreated mean model and compatible treatment timing. |

Mean logs and log mean levels differ. With heavy tails, investigate concentration, baseline-size heterogeneity, dispersion changes, and weighting before interpreting disagreement. Separate these from sample changes using common-sample comparisons where feasible. See [Winkler et al. (2026), Sections 3.2-3.4 and Appendix C](https://doi.org/10.1007/s11129-026-09312-2).

Poisson and PPML use the same objective when specification, sample, and weights coincide; they are not independent robustness checks. PPML permits zeros and nonnegative continuous outcomes without a Poisson distribution or equidispersion assumption. Use appropriate robust/clustered inference and check separation, dropped observations, and convergence. Under a correctly specified common multiplicative effect, 100*(exp(beta)-1) is the conditional-mean percentage effect; with heterogeneity, explicitly aggregate predicted treated and untreated means for the target population. See [Santos Silva and Tenreyro](https://personal.lse.ac.uk/tenreyro/LGW.html).

Record scale/link, weights, zero handling, trend restriction, and aggregation in each trial. Log(Y) excludes zeros; log(1+Y)/asinh effects depend on outcome units and require interpretation on their transformed scale.

## Baseline demeaning

For unit i, define a fixed mean m_i from a stated untreated baseline B_i and set Y*_it = Y_it - m_i. Specify the calendar or cohort-relative window, coverage requirements, and averaging weights; avoid post-treatment observations in calibration.

For a within-unit contrast, (Y_it - m_i) - (Y_ib - m_i) = Y_it - Y_ib. Thus fixed unit demeaning leaves change-based DiD estimates unchanged when the sample, weights, comparisons, and nuisance specification are unchanged. In a linear regression with unit fixed effects, the subtracted constant is absorbed by those effects. Corresponding estimates and standard errors should match numerically. This equivalence need not hold for changing-composition group means, nonlinear models, or a pipeline that refits weights or changes eligibility after transformation.

Demeaning presents deviations from baseline while preserving within-unit changes, including dips and differential trends. Rebasing an event study, subtracting a fitted trend, and subtracting time-varying group means are distinct operations. For repeated cross-sections, use observed group histories.

## Standardization

Separate two choices:

| Scale | Definition and interpretation | Main consequence |
|---|---|---|
| One pooled baseline SD s | (Y_it - m_i) / s; effects in common baseline-SD units | With identical estimation and fixed positive s, coefficients and standard errors rescale together; t statistics and joint Wald tests are unchanged. |
| Unit-specific baseline SD s_i | (Y_it - m_i) / s_i; effects in each unit's own baseline-SD units | Rescales units differently, changing their influence on the aggregate effect and potentially the parallel-trends assumption. |

Use a fixed pre-treatment denominator, not a rolling or full-sample SD that can respond to treatment. State whether SD is computed before or after clipping, the sample-SD convention, minimum observations, and any baseline weights. A short or unstable baseline makes unit SDs noisy. A common scalar preserves test statistics conditional on that calibration; if uncertainty about an estimated population scale is part of the target, propagate it explicitly.

For zero or very small unit SDs, choose a positive-SD restriction, a justified floor, or another scale; report the resulting population/scaling change, exclusions, and SD distribution. Compare standardized and unstandardized estimates on the same retained sample. Small SDs can amplify tiny raw changes. Unit-standardized effects generally cannot be converted back by multiplying by the average SD.

For IV-DiD, state which outcomes are transformed. A standardized reduced form divided by a first stage in original exposure units has SD-per-exposure units. Unit-specific rescaling of both variables does not generally cancel from a ratio of aggregate effects. Preserve matched samples and contrasts and use their joint covariance; consult the IV module for identification and confidence sets.

## Winsorization and trimming at different resolutions

Choose the unit and resolution from how extreme observations arise and what the outcome should measure.

| Resolution of the rule | Possible operation | Interpretation and implementation concern |
|---|---|---|
| Unit-day | Cap each daily outcome, then aggregate; alternatively trim flagged daily observations or screen units using baseline daily behavior | Limits short bursts. Preserve missing/trimmed days as unavailable and identify incomplete weekly totals. |
| Unit-week | Aggregate valid days, then cap or trim weekly outcomes; alternatively use baseline weekly behavior for eligibility | Limits weekly totals, including persistent moderate activity. Define week boundaries and partial weeks. |
| Unit-month | Aggregate to calendar months or a specified fixed-length window, then cap or trim; alternatively screen units on baseline monthly behavior | Addresses sustained high volume but may mix pre- and post-treatment days, blur timing, and reduce event-time resolution. Account for unequal month lengths and incomplete months. |

Keep three operations distinct:

- **Winsorization:** retain observations but replace values beyond fixed bounds with the bounds. For nonnegative volumes, an upper cap may be appropriate; signed outcomes may require justified lower and upper rules. The estimand concerns the capped outcome.
- **Observation trimming:** remove flagged unit-period observations. This changes coverage and potentially composition. Trimming on realized post-treatment outcomes can select on treatment responses even when the cutoff was fixed beforehand.
- **Whole-unit exclusion:** remove an entire unit using a stated eligibility rule, preferably based on predetermined data. This targets a restricted population. Noisy baseline screening can still create regression to the mean. Excluding a unit because it ever exceeds a cutoff after treatment additionally selects on post-treatment behavior.

For example, summing min(Y_id, c_day) over a week is generally different from min(sum(Y_id), c_week). A weekly cutoff is not seven times a daily quantile by definition. Applying both caps is a separate specification. A monthly cap also does not define a unique weekly outcome: either estimate at monthly resolution or justify an explicit allocation rule and its timing consequences. Do not use a month's post-treatment total to retrospectively modify pre-treatment weeks without recognizing the contamination.

## Calibration, comparison, and reporting

1. Inspect distributions and source records to distinguish valid high intensity, duplication, automation, coverage errors, and exposure duration.
2. State the calibration population and untreated window, resolution, inclusion of genuine zeros, exclusion of missing observations, quantile convention, and whether calibration uses survey weights. Pooled and unit-specific thresholds answer different questions. In staggered designs, avoid using treated observations to calibrate supposedly untreated cutoffs; define a common untreated window or justify cohort-specific calibration and comparability.
3. Prefer fixed, comparable rules across treatment groups and evaluation periods. Recomputing separate treated/control or post-treatment quantiles can mechanically change the contrast; assess outcome-dependent trimming as described above even with a fixed cutoff.
4. Record operation order: source cleaning and coverage, baseline eligibility, daily tail rule, aggregation, weekly/monthly tail rule, baseline centering/scaling, estimation. Only apply the steps the design requires. Centering or standardizing before clipping generally defines a different outcome from clipping first.
5. Compare exclusions, caps, and scaling on common samples and weights where possible. Follow [§3's planning rules](../SKILL.md#3-plan-a-limited-set-of-justified-adjustments) and retain the trial record specified in §6.
6. Report group-specific units and observations affected, excluded shares, capped outcome mass, coverage by event time, retained N and effective sample size, and the resulting units of the estimate. Include raw and adjusted estimates with uncertainty, plus preperiod magnitudes and diagnostics. State whether inference conditions on calibration or accounts for estimated thresholds and scaling.
