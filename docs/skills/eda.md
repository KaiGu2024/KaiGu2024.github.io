# Agent Skill: Exploratory Data Analysis

Systematic investigation of a new dataset: cleaning as premise, then distribution, correlation, and pattern analysis before any modeling.

Reference: [Python for Data Analysis — Wes McKinney](https://wesmckinney.com/book/)

---

## Workflow

```
Load → Inspect → Clean → Univariate → Bivariate → Temporal/Group → Document
```

Run EDA before feature engineering or model fitting. Its purpose is to surface problems, surprises, and structure — not to confirm hypotheses.

---

## Step 1 — Load & Inspect (Premise)

```python
import pandas as pd

df = pd.read_csv("data.csv")           # or read_parquet, read_excel, etc.

# Shape, types, nulls
print(df.shape)
print(df.dtypes)
print(df.isnull().sum())
print(df.isnull().mean().sort_values(ascending=False).head(10))

# Duplicates
print(df.duplicated().sum())

# Quick look
print(df.head())
print(df.describe(include="all"))      # include="all" covers categoricals too
```

---

## Step 2 — Data Cleaning (Premise)

Fix problems found in Step 1 before analysis.

```python
# Dates
df["date"] = pd.to_datetime(df["date"], format="%Y-%m-%d", errors="coerce")

# Numerics with dirty strings
df["price"] = pd.to_numeric(df["price"].str.replace(r"[$,]", "", regex=True), errors="coerce")

# Ordered categoricals
df["size"] = pd.Categorical(df["size"], categories=["S","M","L","XL"], ordered=True)

# Deduplication: keep most recent record per entity
df = df.sort_values("updated_at", ascending=False).drop_duplicates("entity_id").reset_index(drop=True)

# Drop rows missing key outcome variable; impute elsewhere
df = df.dropna(subset=["outcome"])
df["income"] = df.groupby("region")["income"].transform(lambda x: x.fillna(x.median()))
```

### Reshaping

```python
# Wide → Long
df_long = df.melt(id_vars=["id","year"], var_name="variable", value_name="value")

# Long → Wide
df_wide = df_long.pivot_table(index=["id","year"], columns="variable", values="value").reset_index()
```

---

## Step 3 — Univariate Analysis

```python
import matplotlib.pyplot as plt
import seaborn as sns

# Numeric: distribution
for col in df.select_dtypes("number"):
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(9, 3))
    df[col].hist(bins=40, ax=ax1)
    ax1.set_title(f"{col} — histogram")
    df.boxplot(column=col, ax=ax2)
    ax2.set_title(f"{col} — boxplot")
    plt.tight_layout()
    plt.savefig(f"eda_{col}.png", dpi=150)
    plt.close()

# Categorical: frequency
for col in df.select_dtypes("object"):
    vc = df[col].value_counts()
    print(f"\n{col}  (nunique={vc.shape[0]})")
    print(vc.head(10))
```

---

## Step 4 — Bivariate & Correlation Analysis

```python
# Correlation matrix (numeric)
corr = df.select_dtypes("number").corr()

fig, ax = plt.subplots(figsize=(10, 8))
sns.heatmap(corr, annot=True, fmt=".2f", cmap="RdBu_r", center=0,
            square=True, linewidths=0.4, ax=ax)
ax.set_title("Pearson correlation")
fig.tight_layout()
fig.savefig("eda_corr.png", dpi=150)
plt.close()

# Key outcome vs. predictors
outcome = "y"
for col in df.select_dtypes("number").columns:
    if col == outcome:
        continue
    fig, ax = plt.subplots(figsize=(5, 4))
    ax.scatter(df[col], df[outcome], alpha=0.3, s=8)
    ax.set_xlabel(col)
    ax.set_ylabel(outcome)
    fig.tight_layout()
    fig.savefig(f"eda_{col}_vs_{outcome}.png", dpi=150)
    plt.close()

# Categorical vs. continuous (group means ± CI)
cat_col = "group"
import scipy.stats as stats
groups = df.groupby(cat_col)[outcome]
means = groups.mean().sort_values()
sems  = groups.sem()
fig, ax = plt.subplots(figsize=(6, 4))
ax.barh(means.index, means.values, xerr=1.96 * sems[means.index].values,
        color="steelblue", alpha=0.8, capsize=3)
ax.set_xlabel(f"Mean {outcome} ± 95% CI")
fig.tight_layout()
fig.savefig("eda_group_means.png", dpi=150)
plt.close()
```

---

## Step 5 — Outlier Detection

```python
from scipy import stats as sp_stats

# Z-score method (flag |z| > 3)
z = sp_stats.zscore(df.select_dtypes("number"), nan_policy="omit")
outlier_mask = (abs(z) > 3).any(axis=1)
print(f"Outliers (z>3): {outlier_mask.sum()} rows ({outlier_mask.mean():.1%})")

# IQR method
def iqr_outliers(series):
    q1, q3 = series.quantile([0.25, 0.75])
    iqr = q3 - q1
    return (series < q1 - 1.5*iqr) | (series > q3 + 1.5*iqr)

for col in df.select_dtypes("number"):
    n = iqr_outliers(df[col]).sum()
    if n > 0:
        print(f"  {col}: {n} IQR outliers")
```

---

## Step 6 — Temporal & Group Patterns

```python
# Time series: aggregate by period
df["month"] = df["date"].dt.to_period("M")
ts = df.groupby("month")[outcome].mean()

fig, ax = plt.subplots(figsize=(9, 3))
ts.plot(ax=ax)
ax.set_ylabel(f"Mean {outcome}")
ax.set_xlabel("")
fig.tight_layout()
fig.savefig("eda_timeseries.png", dpi=150)
plt.close()

# Group-level panel: mean per group over time
pivot = df.groupby(["month", "group"])[outcome].mean().unstack("group")
pivot.plot(figsize=(9, 4), title=f"{outcome} by group over time")
plt.tight_layout()
plt.savefig("eda_group_timeseries.png", dpi=150)
plt.close()
```

---

## Step 7 — Profiling Report (automated)

```python
# ydata-profiling: one-command HTML report
from ydata_profiling import ProfileReport
report = ProfileReport(df, title="EDA Report", explorative=True)
report.to_file("eda_report.html")
```

Install: `pip install ydata-profiling`

---

## Report

After completing EDA, output a brief report:

**Dataset:** File name, shape (N rows × K cols), and time period if applicable.  
**Cleaning actions:** List each issue found and how it was resolved (e.g., "47 duplicate rows removed", "price coerced from string; 12 failures set to NaN").  
**Key patterns:** 2–4 notable findings from univariate/bivariate analysis (e.g., heavy right-skew in income; strong positive correlation between X and Y, r=0.72).  
**Outliers:** Count and nature of flagged rows; whether they were dropped or kept.  
**Concerns:** Any data quality issues that require domain knowledge or human review before proceeding to modeling.
