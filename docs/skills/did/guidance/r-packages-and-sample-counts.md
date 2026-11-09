# R packages and estimation observations

Use established R libraries for the chosen estimator, its aggregation, and inference. Suitable routes include `fixest::feols()` for canonical panel DiD, `did::att_gt()` and `did::aggte()` for Callaway–Sant'Anna, and `fect::fect()` for supported counterfactual estimators. GMM is an estimation framework, not a single DiD implementation: select the R package or authors' R implementation that supports the intended moments and design. Do not choose a different estimand merely because its package exports a convenient sample count.

Record `packageVersion()` and relevant options with the fitted object. Preparation and result-extraction code may call package functions and format their outputs; it must not reimplement estimation, aggregation, inference, or the package's sample-selection logic. If software does not support a requested design, document that limitation.

## What Observations means

The [tables skill](../../tables/SKILL.md#estimation-observations-and-specification-rows) uses the label `Observations`, without a unit-period suffix, for estimation observations. For panel data, these are distinct observed unit-period records contributing to fitting or constructing the reported effects. Define the observation unit in the publication notes when needed. Keep unique units, clusters, weighted effective sample size, moment conditions, and bootstrap repetitions separate.

**Estimation observations need not equal units × weeks.** Missing records, excluded units/cohorts, balancing, and estimator-specific windows can change the counted sample. Equality holds when that sample is the complete retained unit-by-week panel. Staggered timing by itself does not break the equality.

## Extract counts from the fitted package result

Prefer a documented accessor or directly reported count whose meaning matches the intended table field. There is no universal `nobs()` contract that makes all DiD packages return panel rows. Verify the installed version's documentation or source before exporting.

| Case | Package route | Meaning and limitation |
|---|---|---|
| Canonical panel DiD | `stats::nobs(fit)` for a `fixest` fit; `fixest::obs(fit)` for retained row indices | Returns estimation rows after the regression's exclusions. Use the saved fit, not a new regression to obtain the count. |
| Staggered DiD | Selected estimator's accessor, saved sample data, or inclusion indicators | Verify whether the returned quantity counts units, panel rows, untreated fitting records, or treated records entering the ATT. It may not expose the full estimation-observation count as one scalar. |

Concrete package distinctions, checked against upstream documentation/source on 2026-11-09; recheck the installed release:

- **`did`:** for panel `MP` results, `fit$n` represents unique cross-sectional units. The current upstream `nobs.MP()` returns that field, and `glance.MP()` labels the same field `nobs`. Do not pass it through to `Observations` as though it counted unit-period rows. Aggregated results also need their count definition checked. A table exporter cannot resolve this semantic difference by renaming the field.
- **`fect`:** distinguishes untreated observations used to fit counterfactuals from treated observations used to form effects. Its observation indicators and sample metadata are the basis for checking retained cells; matrix dimensions alone include unavailable cells in an unbalanced panel. The current upstream namespace does not register a `nobs.fect()` method. Do not invent one or treat the untreated fitting count as the full count.
- **Other staggered estimators, including GMM implementations:** inspect the selected package's returned object and documentation. A generic extractor or a field named `N` does not establish what was counted.

If no matching scalar is available, use a minimal extraction step with standard R functions on the package's saved, verified sample records or inclusion indicators. This summarizes the package's decisions; it must not rebuild cohort risk sets, eligibility, or estimation from scratch. Verify that the metadata cover the relevant stages and reported target, count reused records once, and save the definition with the count. If the package does not expose enough information, mark the count unavailable for export rather than manufacture it from raw dimensions or sum comparison-specific counts.

An overall sample count need not describe support for every event-time effect. Retain package-provided cohort/horizon support separately. Pass the verified observation count and definition to the tables skill; formatting must not perform this extraction itself.

## Package references

- [`fixest::nobs()`](https://lrberge.github.io/fixest/reference/nobs.fixest.html) and [`fixest::obs()`](https://lrberge.github.io/fixest/reference/obs.html): count and identify estimation rows.
- [`did` MP object](https://bcallaway11.github.io/did/reference/MP.html) and [extractor implementation](https://github.com/bcallaway11/did/blob/master/R/tidy.R): unit-count semantics of `n`, `nobs()`, and `glance()`.
- [`fect` imputation manual](https://yiqingxu.org/packages/fect/02-fect), [returned-object implementation](https://github.com/xuyiqing/fect/blob/master/R/default.R), and [namespace](https://github.com/xuyiqing/fect/blob/master/NAMESPACE): fitting versus effect construction and available methods.
