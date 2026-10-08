# Outcome transformations and tail handling

Use these options to address a diagnosed scale, volatility, or influence problem. They do not by themselves restore identification. Keep the raw-outcome benchmark and explain which quantity each alternative estimates. These are general design notes, not a record of implemented trials or recommended numerical thresholds.

## Baseline demeaning

For unit i, define a fixed mean m_i from a stated untreated baseline B_i and set Y*_it = Y_it - m_i. Specify the calendar or cohort-relative window, coverage requirements, and averaging weights; avoid post-treatment observations in calibration.

For a within-unit contrast, (Y_it - m_i) - (Y_ib - m_i) = Y_it - Y_ib. Thus fixed unit demeaning leaves change-based DiD estimates unchanged when the sample, weights, comparisons, and nuisance specification are unchanged. In a linear regression with unit fixed effects, the subtracted constant is absorbed by those effects. Corresponding estimates and standard errors should match numerically. This equivalence need not hold for changing-composition group means, nonlinear models, or a pipeline that refits weights or changes eligibility after transformation.

Demeaning can help present deviations from baseline, but it cannot remove a temporary dip or differential trend from an otherwise unchanged DiD. It differs from rebasing an event study, subtracting a fitted time trend, and subtracting a time-varying group mean. Repeated cross-sections do not supply individual baseline histories automatically.

## Standardization

Separate two choices:

| Scale | Definition and interpretation | Main consequence |
|---|---|---|
| One pooled baseline SD s | (Y_it - m_i) / s; effects in common baseline-SD units | With identical estimation and fixed positive s, coefficients and standard errors rescale together; t statistics and joint Wald tests are unchanged. This is not a trend repair. |
| Unit-specific baseline SD s_i | (Y_it - m_i) / s_i; effects in each unit's own baseline-SD units | Rescales units differently, changing their influence on the aggregate effect and potentially the parallel-trends assumption. It is no longer an effect in original outcome units. |

Use a fixed pre-treatment denominator, not a rolling or full-sample SD that can respond to treatment. State whether SD is computed before or after clipping, the sample-SD convention, minimum observations, and any baseline weights. A short or unstable baseline makes unit SDs noisy. A common scalar preserves test statistics conditional on that calibration; if uncertainty about an estimated population scale is part of the target, propagate it explicitly.

Handle zero and very small unit SDs explicitly. Options include restricting to positive SD, a substantively justified floor, or another scale definition. Each changes the population or scaling; none is a universal default. Report exclusions and the SD distribution. Compare standardized estimates with unstandardized estimates on the same retained sample to separate sample selection from scaling. Small SDs can give tiny raw changes disproportionate influence. Unit-standardized effects generally cannot be converted back by multiplying by the average SD.

For IV-DiD, state which outcomes are transformed. A standardized reduced form divided by a first stage in original exposure units has SD-per-exposure units. Unit-specific rescaling of both variables does not generally cancel from a ratio of aggregate effects. Preserve matched samples and contrasts and use their joint covariance; consult the IV module for identification and confidence sets.

## Winsorization and trimming at different resolutions

Choose the resolution based on how extreme observations arise and what the outcome should measure. The unit can be a person, household, firm, facility, or region; no specific resolution is preferred universally.

| Resolution of the rule | Possible operation | Interpretation and implementation concern |
|---|---|---|
| Unit-day | Cap each daily outcome, then aggregate; alternatively trim flagged daily observations or screen units using baseline daily behavior | Limits short bursts. Missing or trimmed days must not silently become zeros; an incomplete weekly sum is not a complete week's total. |
| Unit-week | Aggregate valid days, then cap or trim weekly outcomes; alternatively use baseline weekly behavior for eligibility | Limits weekly totals, including persistent moderate activity. It does not implement a daily cap. Define week boundaries and partial weeks. |
| Unit-month | Aggregate to calendar months or a specified fixed-length window, then cap or trim; alternatively screen units on baseline monthly behavior | Addresses sustained high volume but may mix pre- and post-treatment days, blur timing, and reduce event-time resolution. Account for unequal month lengths and incomplete months. |

Keep three operations distinct:

- **Winsorization:** retain observations but replace values beyond fixed bounds with the bounds. For nonnegative volumes, an upper cap may be appropriate; signed outcomes may require justified lower and upper rules. The estimand concerns the capped outcome.
- **Observation trimming:** remove flagged unit-period observations. This changes coverage and potentially composition. Trimming on realized post-treatment outcomes can select on treatment responses even when the cutoff was fixed beforehand. Do not code removed values as zeros or silently aggregate partial periods.
- **Whole-unit exclusion:** remove an entire unit using a stated eligibility rule, preferably based on predetermined data. This targets a restricted population. Noisy baseline screening can still create regression to the mean. Excluding a unit because it ever exceeds a cutoff after treatment additionally selects on post-treatment behavior.

For example, summing min(Y_id, c_day) over a week is generally different from min(sum(Y_id), c_week). A weekly cutoff is not seven times a daily quantile by definition. Applying both caps is a separate specification. A monthly cap also does not define a unique weekly outcome: either estimate at monthly resolution or justify an explicit allocation rule and its timing consequences. Do not use a month's post-treatment total to retrospectively modify pre-treatment weeks without recognizing the contamination.

## Calibration, comparison, and reporting

1. Inspect distributions and source records first. Distinguish valid high intensity, duplication, automation, coverage errors, and exposure duration. A large value alone is not evidence of an error.
2. State the calibration population and untreated window, resolution, inclusion of genuine zeros, exclusion of missing observations, quantile convention, and whether calibration uses survey weights. Pooled and unit-specific thresholds answer different questions. In staggered designs, avoid using treated observations to calibrate supposedly untreated cutoffs; define a common untreated window or justify cohort-specific calibration and comparability.
3. Prefer fixed, comparable rules across treatment groups and evaluation periods. Recomputing separate treated/control or post-treatment quantiles can mechanically change the contrast. A predetermined cutoff avoids that moving-boundary problem but does not make outcome-dependent trimming innocuous.
4. Record operation order: source cleaning and coverage, baseline eligibility, daily tail rule, aggregation, weekly/monthly tail rule, baseline centering/scaling, estimation. Only apply the steps the design requires. Centering or standardizing before clipping generally defines a different outcome from clipping first.
5. Compare a limited, substantively motivated set with common samples and weights where possible. Separate the effect of exclusions, caps, and scaling. Preserve all tried specifications and explain outcome-informed choices; do not choose a quantile or resolution because it produces the preferred effect or passes a lead test.
6. Report group-specific units and observations affected, excluded shares, capped outcome mass, coverage by event time, retained N and effective sample size, and the resulting units of the estimate. Include raw and adjusted estimates with uncertainty, plus preperiod magnitudes and diagnostics. State whether inference conditions on calibration or accounts for estimated thresholds and scaling.

These operations address different features of the outcome distribution. None guarantees comparable holiday responses, valid counterfactual trends, or an exogenous treatment/instrument.
