# Agent Skill: Causal Inference

Methods for credible identification of causal effects in observational data.

## Core packages

| Package | Language | Scope |
|---|---|---|
| [diff-diff](https://github.com/igerber/diff-diff) | Python | DiD specialists: staggered estimators, honest DiD, synthetic DiD, triple diff |
| [fect](https://github.com/xuyiqing/fect) | R | Panel counterfactual estimators: IFE, matrix completion, generalized synthetic control |

Reading reference: [Causal Inference: The Mixtape — Scott Cunningham](https://mixtape.scunning.com/)

---

## Method Selection Guide

| Setting | Tool |
|---|---|
| Treatment assigned by cutoff | Regression Discontinuity (RDD) |
| Panel data, staggered rollout | `diff-diff` staggered estimators |
| Instrument available | Instrumental Variables (IV) |
| No panel, rich covariates | Matching / IPW |
| Comparative case study | Synthetic Control |
| Panel with interactive FE / switching treatment | `fect` (R) |

---

## Difference-in-Differences

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
from linearmodels.iv import IV2SLS

result = IV2SLS(
    dependent=df["outcome"],
    exog=df[["const", "controls"]],
    endog=df[["treatment"]],
    instruments=df[["instrument"]]
).fit(cov_type="robust")

print(result.summary)
print("First-stage F:", result.first_stage.diagnostics["f.stat"].values)
```

---

## Regression Discontinuity

```python
import rpy2.robjects as ro
ro.r('''
library(rdrobust)
result <- rdrobust(y=df$outcome, x=df$running, c=cutoff)
summary(result)
rdplot(y=df$outcome, x=df$running, c=cutoff)
''')
```

McCrary density test to check for manipulation at cutoff:
```r
library(rddensity)
rddensity(X = df$running, c = cutoff)
```

---

## Standard Errors

- **Cluster** at the unit of treatment assignment (never smaller)
- **HC3 robust** for cross-sectional with heteroskedasticity
- **Wild cluster bootstrap** when few clusters (< 30): use `wildboottest` (Python)

---

## Report

After completing a causal analysis, output a brief report:

**Strategy:** Identification method and source of variation exploited.  
**Sample:** N observations; unit of observation; time period; sample restrictions.  
**Main estimate:** Point estimate with units, SE, and CI; cluster level used.  
**Key assumption:** Identifying assumption and whether diagnostics passed (pre-trend F-stat, KP F-stat, McCrary p-value).  
**Concerns:** Threats to identification not fully addressed; data quality issues; external validity limitations.
