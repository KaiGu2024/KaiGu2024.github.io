# Agent Skill: Exploratory Data Analysis

Systematic investigation of a new dataset: cleaning as premise, then distribution, correlation, and pattern analysis before any modeling.

References: [Python for Data Analysis — Wes McKinney](https://wesmckinney.com/book/) · [Polars User Guide](https://docs.pola.rs/)

For datasets > 1 GB or when lazy evaluation / caching is needed, see [Big-Data Processing](big-data-processing.md).

---

## Workflow

```
Load → Inspect → Clean → Univariate → Bivariate → Temporal/Group → Document
```

Run EDA before feature engineering or model fitting. Its purpose is to surface problems, surprises, and structure — not to confirm hypotheses.

---

## Step 1 — Load & Inspect (Premise)

```python
import polars as pl
import polars.selectors as cs

df = pl.read_csv("data.csv")       # or read_parquet (preferred for large files)

# Shape and schema
print(df.shape)
print(df.schema)

# Null counts and fractions
print(df.null_count())
print(df.null_count() / len(df))

# Duplicates
print(df.is_duplicated().sum())

# Quick look
print(df.head())
print(df.describe())
```

---

## Step 2 — Data Cleaning (Premise)

Fix problems found in Step 1 before analysis. Tidy data principles: each variable is a column, each observation is a row, each observational unit is a table.

### Type coercion

```python
# Dates
df = df.with_columns(pl.col("date").str.to_date("%Y-%m-%d", strict=False))

# Numerics with dirty strings
df = df.with_columns(
    pl.col("price").str.replace_all(r"[$,]", "").cast(pl.Float64, strict=False)
)

# Categoricals
df = df.with_columns(pl.col("size").cast(pl.Categorical))
```

### Reshaping

```python
# Wide → Long
df_long = df.unpivot(index=["id", "year"], variable_name="variable", value_name="value")

# Long → Wide
df_wide = df_long.pivot(index=["id", "year"], on="variable", values="value")

# Multi-stub wide → long: use pandas wide_to_long, then convert back
import pandas as pd
df_long = pl.from_pandas(
    pd.wide_to_long(df.to_pandas(), stubnames=["sales", "cost"], i="id", j="year", sep="_")
    .reset_index()
)
```

### Deduplication

```python
# Drop exact duplicates
df = df.unique()

# Keep most recent record per entity
df = df.sort("updated_at", descending=True).unique(subset=["entity_id"], keep="first")

# Fuzzy deduplication (names, addresses)
from rapidfuzz import fuzz, process
names = df["name"].to_list()
matches = process.cdist(names, names, scorer=fuzz.token_sort_ratio)
```

### Missing values

```python
# Drop rows missing key outcome variable
df = df.drop_nulls(subset=["outcome"])

# Fill with group median
df = df.with_columns(
    pl.col("income").fill_null(pl.col("income").median().over("region"))
)

# Imputation for ML pipelines (via sklearn)
import numpy as np
from sklearn.impute import SimpleImputer
numeric_cols = df.select(cs.numeric()).columns
arr = SimpleImputer(strategy="median").fit_transform(df.select(numeric_cols).to_numpy())
df = df.with_columns([pl.Series(col, arr[:, i]) for i, col in enumerate(numeric_cols)])
```

### Validation & Assertions

```python
import pandera.polars as pa

schema = pa.DataFrameSchema({
    "id":     pa.Column(pl.Int64, pa.Check.gt(0)),
    "amount": pa.Column(pl.Float64, nullable=True),
})
schema.validate(df)
```

---

## Step 3 — Univariate Analysis

```python
import matplotlib.pyplot as plt

# Numeric: distribution
for col in df.select(cs.numeric()).columns:
    data = df[col].drop_nulls().to_numpy()
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(9, 3))
    ax1.hist(data, bins=40)
    ax1.set_title(f"{col} — histogram")
    ax2.boxplot(data)
    ax2.set_title(f"{col} — boxplot")
    plt.tight_layout()
    plt.savefig(f"eda_{col}.png", dpi=150)
    plt.close()

# Categorical: frequency
for col in df.select(cs.string()).columns:
    vc = df[col].value_counts(sort=True)
    print(f"\n{col}  (nunique={df[col].n_unique()})")
    print(vc.head(10))
```

---

## Step 4 — Bivariate & Correlation Analysis

```python
import seaborn as sns

# Correlation matrix (convert to pandas for seaborn heatmap)
corr = df.select(cs.numeric()).to_pandas().corr()
fig, ax = plt.subplots(figsize=(10, 8))
sns.heatmap(corr, annot=True, fmt=".2f", cmap="RdBu_r", center=0,
            square=True, linewidths=0.4, ax=ax)
ax.set_title("Pearson correlation")
fig.tight_layout()
fig.savefig("eda_corr.png", dpi=150)
plt.close()

# Key outcome vs. predictors
outcome = "y"
y = df[outcome].to_numpy()
for col in df.select(cs.numeric()).columns:
    if col == outcome:
        continue
    fig, ax = plt.subplots(figsize=(5, 4))
    ax.scatter(df[col].to_numpy(), y, alpha=0.3, s=8)
    ax.set_xlabel(col)
    ax.set_ylabel(outcome)
    fig.tight_layout()
    fig.savefig(f"eda_{col}_vs_{outcome}.png", dpi=150)
    plt.close()

# Categorical vs. continuous (group means ± CI)
cat_col = "group"
stats = (
    df.group_by(cat_col)
    .agg([
        pl.col(outcome).mean().alias("mean"),
        pl.col(outcome).std().alias("std"),
        pl.col(outcome).count().alias("n"),
    ])
    .with_columns((1.96 * pl.col("std") / pl.col("n").sqrt()).alias("ci"))
    .sort("mean")
)
fig, ax = plt.subplots(figsize=(6, 4))
ax.barh(stats[cat_col].to_list(), stats["mean"].to_numpy(),
        xerr=stats["ci"].to_numpy(), color="steelblue", alpha=0.8, capsize=3)
ax.set_xlabel(f"Mean {outcome} ± 95% CI")
fig.tight_layout()
fig.savefig("eda_group_means.png", dpi=150)
plt.close()
```

---

## Step 5 — Outlier Detection

```python
import numpy as np
from scipy import stats as sp_stats

numeric_arr = df.select(cs.numeric()).to_numpy()
z = sp_stats.zscore(numeric_arr, nan_policy="omit")
outlier_mask = (abs(z) > 3).any(axis=1)
print(f"Outliers (z>3): {outlier_mask.sum()} rows ({outlier_mask.mean():.1%})")

# IQR method
for col in df.select(cs.numeric()).columns:
    vals = df[col].drop_nulls().to_numpy()
    q1, q3 = np.percentile(vals, [25, 75])
    iqr = q3 - q1
    n = ((vals < q1 - 1.5 * iqr) | (vals > q3 + 1.5 * iqr)).sum()
    if n > 0:
        print(f"  {col}: {n} IQR outliers")
```

---

## Step 6 — Temporal & Group Patterns

```python
# Time series: aggregate by month
df = df.with_columns(pl.col("date").dt.truncate("1mo").alias("month"))
ts = df.group_by("month").agg(pl.col(outcome).mean()).sort("month")

fig, ax = plt.subplots(figsize=(9, 3))
ax.plot(ts["month"].to_list(), ts[outcome].to_numpy())
ax.set_ylabel(f"Mean {outcome}")
fig.tight_layout()
fig.savefig("eda_timeseries.png", dpi=150)
plt.close()

# Group-level panel: mean per group over time
pivot = (
    df.group_by(["month", "group"])
    .agg(pl.col(outcome).mean())
    .pivot(index="month", on="group", values=outcome)
    .sort("month")
)
pivot.to_pandas().set_index("month").plot(figsize=(9, 4))
plt.tight_layout()
plt.savefig("eda_group_timeseries.png", dpi=150)
plt.close()
```

---

## Step 7 — Profiling Report (automated)

```python
# ydata-profiling: one-command HTML report (supports Polars directly)
from ydata_profiling import ProfileReport
report = ProfileReport(df, title="EDA Report", explorative=True)
report.to_file("eda_report.html")
```

Install: `pip install ydata-profiling`

---

## Report

See [Report format](report.md).

**Definition (measure):** Dataset shape (N rows × K cols); time period if applicable; key quality metrics (% missing, duplicate count) before and after cleaning.  
**Analyses:** Cleaning actions taken (list each issue and resolution); univariate and bivariate patterns found; outlier counts and handling.  
**Takeaway:** 2–4 notable findings (e.g., heavy right-skew in income; r=0.72 between X and Y); any data quality concerns requiring domain review before modeling.
