# Optional case study: AI-search adoption and access expansions

This illustration records lessons from one household browsing study through October 5, 2026. Read it only for worked examples or that project's history. Its variables, thresholds, time windows, and preferred scales are **not defaults** of the general skill. The skill can be used without this file or the underlying research repository.

## What was specific to this study

The canonical panel contained 45,386 households observed from October 2024 through July 2025. Analyses considered self-adoption and differential exposure to three national access expansions. Search outcomes counted recorded result-page loads rather than verified unique queries; treatment intensity used recorded conversation sessions. Endpoint-based login/anonymous classifications were imperfect exposure proxies, not verified eligibility.

Normalized root/search paths, hosted search, and search verticals were alternative measurement scopes. Generic search/maps paths did not recover query wording, so unavailable text could not support population-wide question/navigation/length classifications. Changing endpoint observability could create an apparent first stage without an equivalent change in behavior.

## How examples map to general decisions

| Project example | Transferable lesson |
|---|---|
| Demographic calibration to ACS versus weighting on early outcome histories | Population representation and causal comparison balance serve different purposes. Another study needs its own target and covariates. |
| Early maximum of 25 result-page loads per day | This is a sample eligibility restriction, not a general outlier standard or a cap on later outcomes. |
| Common weekly cap of 55, the pooled early p95 | This winsorizes the outcome while retaining units. It changes the quantity measured. |
| High-activity eligibility above a baseline p90 of 58.8125 loads/week | A cap of 55 compresses the very outcome of interest. Raw counts were primary for this total-volume question; the numeric cutoff does not transfer. |
| Apparent holiday differences correlated with baseline activity | Examine differential seasonal responses, reference periods, measurement, and both groups; a date coincidence does not establish the cause. |
| National expansions interacted with frozen exposure proxies | Common post indicators supply no independent variation after calendar effects; proxy status and exclusion still need justification. |
| Zero recorded pre-expansion sessions in one group | Mechanical zeros provide little evidence about untreated behavioral trends or measurement continuity. |
| Only two observed days in the final event week | Partial coverage cannot be treated as a complete zero-filled week. Other data need their own support audit. |

The [29-direction trial inventory](trial-inventory.md) preserves implemented, unavailable, and retired designs, plus four numerical anchors. It shows that stronger balance often weakened the apparent decline. It does not establish which adjustment works generally, or certify a negative causal effect in this study.

## Evidence and reproduction boundary

The inventory is self-contained as a record of lessons and reported results. Original project paths appear there as provenance text, not required links or runnable dependencies. Reproducing its empirical numbers requires the original data/code and authorization to use them; the general skill requires neither. Historical figure numbers, software versions, and shorter follow-up windows should not be transplanted into another analysis.
