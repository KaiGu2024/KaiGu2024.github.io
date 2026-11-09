# R packages and estimation observations

Use R libraries for the chosen estimator, its aggregation, and inference. Suitable routes include `fixest::feols()` for canonical panel DiD, `did::att_gt()` and `did::aggte()` for Callaway–Sant'Anna, and `fect::fect()` for supported counterfactual estimators. For Chen, Sant'Anna, and Xie (2025; L21), the third-party `edid` implementation is a candidate within its documented limits below. GMM is an estimation framework, not a single DiD implementation: identify the paper and supported design before selecting software. Do not choose a different estimator merely because its package exports a convenient sample count.

Record `packageVersion()` and relevant options with the fitted object. Preparation and result-extraction code may call package functions and format their outputs; it must not reimplement estimation, aggregation, inference, or the package's sample-selection logic. If software does not support a requested design, document that limitation.

## What Observations means

**Standalone GMM reporting:** use `Units` for distinct retained estimation units and omit `Observations` by default, including for Chen–Sant'Anna–Xie efficient DiD. This is the user's presentation preference, not a claim that GMM observation counts are intrinsically meaningless. The panel-observation definitions below still apply when that count is needed for a comparison table or sample audit. Never place units under an `Observations` label.

The [tables skill](../../tables/SKILL.md#estimation-observations-and-specification-rows) uses the label `Observations`, without a unit-period suffix, for estimation observations. For panel data, report distinct observed unit-period records in the package-retained estimation sample after preprocessing and exclusions. This overall sample count is separate from the support of an individual group-time comparison or aggregate effect; do not require reconstructing the exact union of contributing records for routine CSDiD reporting. Define the observation unit in the publication notes when needed. Keep unique units, clusters, weighted effective sample size, moment conditions, and bootstrap repetitions separate.

**Estimation observations need not equal units × weeks.** Missing records, excluded units/cohorts, balancing, and estimator-specific windows can change the counted sample. Equality holds when that sample is the complete retained unit-by-week panel. Staggered timing by itself does not break the equality.

## Extract counts from the fitted package result

Prefer a documented accessor or directly reported count whose meaning matches the intended table field. There is no universal `nobs()` contract that makes all DiD packages return panel rows. Verify the installed version's documentation or source before exporting.

| Case | Package route | Meaning and limitation |
|---|---|---|
| Canonical panel DiD | `stats::nobs(fit)` for a `fixest` fit; `fixest::obs(fit)` for retained row indices | Returns estimation rows after the regression's exclusions. Use the saved fit, not a new regression to obtain the count. |
| Staggered DiD | Selected estimator's accessor, saved sample data, or inclusion indicators | Verify whether the returned quantity counts units, panel rows, untreated fitting records, or treated records entering the ATT. It may not expose the full estimation-observation count as one scalar. |

Concrete package distinctions, checked against upstream documentation/source on 2026-11-09; recheck the installed release:

- **`did`:** for panel `MP` results from `att_gt()`, use `nrow(res$DIDparams$data)` for `Observations`: the saved data contain the retained panel records after package preprocessing and sample exclusions. Use `res$n` for unique units. The current upstream `nobs.MP()` returns that unit count, and `glance.MP()` labels it `nobs`; neither is the panel-row count. Extract the overall sample count from the originating `att_gt()` object when reporting `aggte()` results, and describe any additional aggregation restrictions separately.
- **`fect`:** use the saved logical `sample` mask when available, as detailed below. It distinguishes the retained analysis sample from missing cells and removed units. The current upstream namespace does not register a `nobs.fect()` method. Untreated outcome-model fitting observations and treated effect observations are separate subsets of the overall sample.
- **Chen–Sant'Anna–Xie efficient DiD:** `edid` requires retaining its `prep_data()` output to report the overall sample. Its default results are effect rows, not observation rows; see the package-specific workflow below.
- **Other staggered estimators:** inspect the selected package's returned object and documentation. A generic extractor or a field named `N` does not establish what was counted.

### Callaway–Sant'Anna: `did`

For a panel `did::att_gt()` result:

```r
sample_counts <- c(
  Observations = nrow(res$DIDparams$data),
  Units = res$n
)
```

This is extraction from the fitted package object, not a reconstruction of sample eligibility. The default `panel = TRUE, allow_unbalanced_panel = FALSE` drops incomplete units to form a balanced retained panel, so its observation count equals retained units times retained periods. With `allow_unbalanced_panel = TRUE`, that equality need not hold. Use the saved data, not `nrow(df)` or raw units times weeks. Record the installed package version and confirm that the saved field is present and contains the processed long data; do not substitute another count if it is absent.

### Counterfactual estimators: `fect`

Estimate with `fect::fect()` and record the chosen method (`"fe"`, `"ife"`, or `"mc"`), fixed effects, tuning, and inference settings. In the checked 2.4.5 source, the returned `sample` is a logical time-by-unit matrix: `TRUE` identifies retained observed cells. Count the mask, not its dimensions:

```r
stopifnot(is.matrix(fit$sample), is.logical(fit$sample), !anyNA(fit$sample))
sample_counts <- c(
  Observations = sum(fit$sample),
  Units = sum(colSums(fit$sample) > 0)
)
```

The source constructs this mask from `obs.missing` codes 1 (treated), 2 (control), and 5 (placebo/carryover test cells); it excludes missing cells, removed units, and removed carryover cells. For the main-results table, extract it from the main fitted object. A diagnostic refit or a balanced-event-window estimand has its own sample/support definition; do not silently replace the main count with diagnostic or horizon-specific counts. Do not use `fit$N`, `length(fit$Y.dat)`, or treated-only calendar counts as total observations.

If an installed release lacks `sample`, inspect its documented `I.dat` observation indicators and `obs.missing` coding before defining an equivalent retained-cell count. For ordinary main fits where `I.dat == 1` is verified to mark retained observed cells, `sum(fit$I.dat == 1)` is the corresponding extraction. Do not assume that fallback covers special carryover exclusions or other diagnostic options. Store the package version and, for GitHub installations, the commit SHA with the count.

### Chen–Sant'Anna–Xie (2025): `edid`

The publicly located R implementation is David Loeb's [`edid`](https://github.com/david-loeb/edid), version 0.1 at the checked commit `f55a4a4aba14f0826f59ad7aa4af3bafaeba529b`. It is a third-party implementation, not software released by the paper's authors. No author-maintained R package was identified in the checked author pages. Do not substitute `staggeredGMM` (Arora–Bijani), `staggered` (Roth–Sant'Anna), or a generic `gmm` call for this estimator.

The documented implementation supports **no covariates**, requires a **balanced panel**, and uses the **same number of pre-treatment periods across treatment cohorts**. Check these limits against the intended specification before choosing it; do not discard required covariates or change the target just to use the package. Follow the [efficiency guidance](estimation-efficiency.md) for the paper's identification assumptions. For unsupported specifications, report the software gap and look for a suitable author implementation; do not hand-code a substitute.

`edid::edid()` normally returns a data frame of estimates. Neither its row count nor the number of elements returned by `get_full_mod = TRUE` is a sample size. The checked namespace has no `nobs()` method. Use the package's exported modular workflow when saving sample metadata: retain the output of `edid::prep_data()` and pass that same object through `get_ytilde()`, `get_influence_func()`, `estimate_model()`, and the package's result/aggregation functions. These functions perform estimation and inference; the reporting code only summarizes their prepared sample.

```r
prepared <- edid::prep_data(
  df, y = "y", treat_time = "first_treat", id = "id", time = "year",
  num_t_pre = 3
)
# Use this same prepared object in the exported estimation workflow.
outcomes <- dplyr::select(prepared, dplyr::starts_with("y"))
stopifnot(ncol(outcomes) > 0L, !anyNA(outcomes))
sample_counts <- c(
  Observations = sum(!is.na(as.matrix(outcomes))),
  Units = nrow(prepared)
)
```

Here `num_t_pre = 3` is illustrative; use the chosen specification's actual setting and pass its anticipation and clustering options consistently. `prep_data()` selects the analysis time window, removes missing/nonfinite outcomes, balances the panel, and returns one row per retained unit with one `y<time>` column per retained period. Thus the observed outcome-cell count equals retained units times retained periods in this supported balanced-panel case. Confirm the prepared column schema and save this object alongside the estimates and package commit. The count describes the overall prepared analysis sample, not every individual comparison's support.

For a standalone GMM table, export only `Units = nrow(prepared)` as the sample-size row; the observation count above is available for sample audits or comparisons and need not appear in that table.

### Generic GMM fits: `gmm::gmm()`

For an existing fit or a verified method implementation using `gmm::gmm()`, extract the moment-row count with:

```r
stopifnot(!is.null(fit$gt))
n_moment_rows <- NROW(fit$gt)
```

The package uses this row count as its sample size for GMM calculations. Its meaning comes from the supplied moment function: one row per retained unit-period counts panel observations; one row per unit combining several periods counts units; one row per cluster counts clusters. The columns represent moment conditions. For standalone GMM reporting, export `Units = n_moment_rows` only after verifying exactly one row per distinct retained unit, without duplication or padding. Otherwise extract the unique-unit count from the package's saved estimation sample or inclusion metadata; do not relabel period or cluster counts as units. Omit `Observations` by default. For example, 500 unit-level moment vectors from a complete 10-period panel should be reported as `Units: 500` in a standalone GMM table.

Calling `gmm::gmm()` uses library-based GMM estimation, but the supplied `moment_function` still defines the estimator-specific moments. A call alone does not establish that it implements Chen–Sant'Anna–Xie: verify the moments, nuisance estimation, weighting, aggregation, and inference against the intended method. Use an existing verified package or author implementation that supplies these components; the generic interface does not authorize hand-coding a substitute under this skill's R-library rule. Record the moment-row unit, moment-function source, package version, and verified retained-unit count with the results. A standalone GMM table does not require constructing an additional panel-observation count.

### Other packages and reporting handoff

For packages without a matching scalar, use a minimal extraction step with standard R functions on the package's saved, verified sample records or inclusion indicators. This summarizes the package's decisions; it must not rebuild cohort risk sets, eligibility, or estimation from scratch. Verify the metadata's sample definition and stage coverage, count reused records once, and save the definition with the count. If the package does not expose enough information, mark the count unavailable for export rather than manufacture it from raw dimensions or sum comparison-specific counts.

An overall sample count need not describe support for every event-time effect. Retain package-provided cohort/horizon support separately. Pass the verified sample count and definition to the tables skill (`Units` for standalone GMM, otherwise `Observations` where available); formatting must not perform this extraction itself.

## Package references

- [`fixest::nobs()`](https://lrberge.github.io/fixest/reference/nobs.fixest.html) and [`fixest::obs()`](https://lrberge.github.io/fixest/reference/obs.html): count and identify estimation rows.
- [`did` MP object](https://bcallaway11.github.io/did/reference/MP.html) and [extractor implementation](https://github.com/bcallaway11/did/blob/master/R/tidy.R): unit-count semantics of `n`, `nobs()`, and `glance()`.
- [`did::att_gt()`](https://bcallaway11.github.io/did/reference/att_gt.html), [standard preprocessing](https://github.com/bcallaway11/did/blob/master/R/pre_process_did.R), and [fast preprocessing](https://github.com/bcallaway11/did/blob/master/R/pre_process_did2.R): sample exclusions, balancing defaults, and retained data stored in `DIDparams$data`.
- [`fect` imputation manual](https://yiqingxu.org/packages/fect/02-fect), [returned-object implementation](https://github.com/xuyiqing/fect/blob/master/R/default.R), and [namespace](https://github.com/xuyiqing/fect/blob/master/NAMESPACE): fitting versus effect construction and available methods.
- [`fect` 2.4.5 CRAN source mirror](https://github.com/cran/fect/blob/master/R/default.R): construction and return of `sample`, `I.dat`, and `obs.missing`.
- [`edid` package overview](https://github.com/david-loeb/edid), [pinned preprocessing source](https://github.com/david-loeb/edid/blob/f55a4a4aba14f0826f59ad7aa4af3bafaeba529b/R/prep_data.R), and [pinned wrapper](https://github.com/david-loeb/edid/blob/f55a4a4aba14f0826f59ad7aa4af3bafaeba529b/R/edid.R): supported design, retained wide data, and returned results. [Sant'Anna's research page](https://psantanna.com/research/) identifies the paper separately from his other software.
- [`gmm::gmm()` documentation](https://search.r-project.org/CRAN/refmans/gmm/html/gmm.html) and [result finalization source](https://github.com/cran/gmm/blob/master/R/FinRes.R): the supplied moment function returns an n-by-q matrix, and the package uses its row count as n; this does not determine whether a row is a panel observation, unit, or cluster.
