# Agent Skill: Causal Inference

Methods for credible identification of causal effects in observational data.

## Core packages

| Package | Language | Scope |
|---|---|---|
| [StatsPAI](https://github.com/brycewang-stanford/StatsPAI) | Python | 800+ functions: DiD, IV, RD, synthetic control, causal forests, DML — unified `CausalResult` API |
| [diff-diff](https://github.com/igerber/diff-diff) | Python | DiD specialists: staggered estimators, honest DiD, synthetic DiD, triple diff |
| [fect](https://github.com/xuyiqing/fect) | R | Panel counterfactual estimators: IFE, matrix completion, generalized synthetic control |

Reading reference: [Causal Inference: The Mixtape — Scott Cunningham](https://mixtape.scunning.com/)

---

## Method Selection Guide

| Setting | Tool |
|---|---|
| Treatment assigned by cutoff | `sp.rdrobust()` (StatsPAI) |
| Panel data, staggered rollout | `diff-diff` staggered estimators or `sp.callaway_santanna()` |
| Instrument available | `sp.ivreg()` (StatsPAI) |
| No panel, rich covariates | `sp.matching()` / `sp.ipw()` (StatsPAI) |
| Comparative case study | `sp.synth()` (StatsPAI) |
| Panel with interactive FE / switching treatment | `fect` (R) |

---

## StatsPAI — Unified API

Every estimator returns a `CausalResult` with the same interface:

```python
import statspai as sp

result.summary()           # formatted output with inference
result.tidy()              # DataFrame of coefficients
result.plot()              # appropriate visualization
result.to_latex()          # LaTeX table
result.to_docx()           # Word document
result.to_agent_summary()  # JSON-ready structured output
result.cite()              # BibTeX citation

# Discovery
sp.list_functions()
sp.function_schema("callaway_santanna")
```

---

## Difference-in-Differences

### Staggered DiD — StatsPAI (Callaway–Sant'Anna)

```python
import statspai as sp

df = sp.datasets.mpdta()
cs = sp.callaway_santanna(data=df, y='lemp', t='year',
                          i='countyreal', g='first_treat')
result = sp.aggte(cs, type='simple')   # or 'dynamic', 'group', 'calendar'
result.summary()
result.plot()
```

### Staggered DiD — diff-diff

```python
from diffdiff import CallwaySantanna, SunAbraham, Borusyak

# Callaway–Sant'Anna
cs = CallwaySantanna().fit(
    data=df, outcome='y', treatment='treated',
    time='t', unit='id', first_treat='g',
    covariates=['x1', 'x2'], cluster='id'
)

# Imputation estimator (Borusyak–Jaravel–Spiess)
bjs = Borusyak().fit(data=df, outcome='y', treatment='treated',
                     time='t', unit='id')

# Honest DiD bounds (Rambachan–Roth)
from diffdiff import HonestDiD
HonestDiD().fit(cs, M=0.5)
```

**Diagnostics**: parallel trends test, Goodman-Bacon decomposition, placebo tests — all available in diff-diff.

### Panel counterfactual / switching treatment — fect (R)

Use when treatment switches on and off, or you want IFE / matrix completion imputation:

```r
library(fect)
out <- fect(Y ~ D + X1 + X2, data = df,
            index = c("unit", "time"),
            method = "mc",        # "fe", "ife", "mc", "polynomial"
            CV = TRUE, r = c(0, 5),
            se = TRUE, nboots = 200)
print(out)
plot(out)                   # ATT with confidence band
plot(out, type = "gap")     # gap plot
```

Key options: `method` selects estimator; `r` = factor number range for CV; `force = "two-way"` for TWFE; `placebo.period` for placebo tests. [User manual](https://yiqingxu.org/packages/fect/).

---

## Instrumental Variables

```python
import statspai as sp

df = sp.datasets.card_1995()
iv = sp.ivreg('lwage ~ (educ ~ nearc4) + exper + expersq', data=df)
iv.summary()
# First-stage F-stat in iv.tidy() diagnostics
```

---

## Regression Discontinuity

```python
import statspai as sp

df = sp.datasets.lee_2008_senate()
rd = sp.rdrobust(data=df, y='voteshare_next', x='margin', c=0)
rd.summary()
rd.plot()   # RD plot with confidence intervals
```

McCrary density test for manipulation at cutoff — call `sp.rddensity()`.

---

## Synthetic Control

```python
import statspai as sp

df = sp.datasets.california_prop99()
sc = sp.synth(data=df, outcome='cigsale', unit='state',
              time='year', treated_unit='California',
              treatment_time=1989)
sc.summary()
sc.plot()
```

---

## Standard Errors

- **Cluster** at the unit of treatment assignment (never smaller)
- **HC3 robust** for cross-sectional with heteroskedasticity
- **Wild cluster bootstrap** when few clusters (< 30): `sp.wildboottest()` or `wildboottest` (Python)

---

## Report

After completing a causal analysis, output a brief report:

**Strategy:** Identification method and source of variation exploited.  
**Sample:** N observations; unit of observation; time period; sample restrictions.  
**Main estimate:** Point estimate with units, SE, and CI; cluster level used.  
**Key assumption:** Identifying assumption and whether diagnostics passed (pre-trend F-stat, KP F-stat, McCrary p-value).  
**Concerns:** Threats to identification not fully addressed; data quality issues; external validity limitations.
