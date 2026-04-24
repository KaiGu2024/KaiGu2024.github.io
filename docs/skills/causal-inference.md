# Agent Skill: Causal Inference

Methods for credible identification of causal effects in observational data.

Reference: [Causal Inference: The Mixtape — Scott Cunningham](https://mixtape.scunning.com/)

---

## Method Selection Guide

| Setting | Method |
|---|---|
| Treatment assigned by cutoff | Regression Discontinuity (RDD) |
| Panel data, staggered rollout | Difference-in-Differences (DiD) |
| Instrument available | Instrumental Variables (IV) |
| No panel, rich covariates | Matching / IPW |
| Comparative case study | Synthetic Control |
| Sharp event, panel data | Event Study |

---

## Difference-in-Differences

```python
import statsmodels.formula.api as smf

# Two-way FE DiD
result = smf.ols(
    "outcome ~ treated * post + C(unit) + C(time)",
    data=df
).fit(cov_type="cluster", cov_kwds={"groups": df["unit"]})
print(result.summary())
```

**Parallel trends test**: plot pre-period means by treatment status; run placebo DiD on pre-period only.

**Staggered DiD**: use `did` (R) or `csdid` / `pyfixest` (Python) for Callaway–Sant'Anna estimator.

```python
# pyfixest: TWFE with clustered SE
import pyfixest as pf
fit = pf.feols("outcome ~ i(time, treated, ref=-1) | unit + time", df)
pf.iplot(fit)  # event study plot
```

---

## Instrumental Variables

```python
from linearmodels.iv import IV2SLS

# First stage: instrument → treatment
# Second stage: instrumented treatment → outcome
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
# rdrobust (R-style interface via rpy2, or use rdrobust Python port)
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

## Event Study / Parallel Trends Plot

```python
import matplotlib.pyplot as plt

coefs = result.params.filter(like="time:")
cis   = result.conf_int().filter(like="time:", axis=0)

plt.figure(figsize=(8, 4))
plt.axhline(0, color="black", lw=0.8)
plt.axvline(-0.5, color="red", ls="--", lw=0.8, label="Event")
plt.errorbar(range(len(coefs)), coefs, 
             yerr=(coefs - cis[0], cis[1] - coefs),
             fmt="o", capsize=3)
plt.xlabel("Periods relative to treatment"); plt.ylabel("Estimate")
plt.tight_layout(); plt.savefig("event_study.pdf")
```

---

## Standard Errors

- **Cluster** at the unit of treatment assignment (never smaller)
- **HC3 robust** for cross-sectional with heteroskedasticity
- **Wild cluster bootstrap** when few clusters (< 30): use `wildboottest` (Python)
