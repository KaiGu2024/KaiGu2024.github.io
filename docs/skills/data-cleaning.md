# Agent Skill: Data Cleaning

Tidy data principles and practical patterns for preparing structured datasets for analysis.

Reference: [Tidy Data — Hadley Wickham (JSS 2014)](https://vita.had.co.nz/papers/tidy-data.pdf)

---

## Tidy Data Principles

1. Each variable forms a column
2. Each observation forms a row
3. Each observational unit forms a table

Violations to fix: wide format (multiple value columns), column headers are values, multiple variables in one column, multiple types in one table.

---

## Inspection Checklist

```python
import pandas as pd

df = pd.read_csv("data.csv")

# Shape and types
print(df.shape, df.dtypes)

# Missing values
print(df.isnull().sum())
print(df.isnull().mean().sort_values(ascending=False))

# Duplicates
print(df.duplicated().sum())

# Cardinality of categoricals
for col in df.select_dtypes("object"):
    print(col, df[col].nunique(), df[col].value_counts().head(3).to_dict())

# Numeric distributions
print(df.describe())
```

---

## Reshaping

```python
# Wide → Long
df_long = df.melt(id_vars=["id", "year"], var_name="variable", value_name="value")

# Long → Wide
df_wide = df_long.pivot_table(index=["id", "year"], columns="variable", values="value").reset_index()

# Multiple value columns in wide format
df_long = pd.wide_to_long(df, stubnames=["sales", "cost"], i="id", j="year", sep="_")
```

---

## Type Coercion

```python
# Dates
df["date"] = pd.to_datetime(df["date"], format="%Y-%m-%d", errors="coerce")

# Numerics with dirty strings
df["price"] = pd.to_numeric(df["price"].str.replace("[$,]", "", regex=True), errors="coerce")

# Ordered categoricals
df["size"] = pd.Categorical(df["size"], categories=["S", "M", "L", "XL"], ordered=True)
```

---

## Deduplication

```python
# Drop exact duplicates
df = df.drop_duplicates()

# Drop duplicates on key, keep most recent
df = df.sort_values("updated_at", ascending=False).drop_duplicates("entity_id").reset_index(drop=True)

# Fuzzy deduplication (names, addresses)
from rapidfuzz import fuzz, process
matches = process.cdist(df["name"], df["name"], scorer=fuzz.token_sort_ratio)
```

---

## Missing Values

```python
# Drop rows missing key variable
df = df.dropna(subset=["outcome"])

# Fill with group median
df["income"] = df.groupby("region")["income"].transform(lambda x: x.fillna(x.median()))

# Imputation (for ML pipelines)
from sklearn.impute import SimpleImputer
imp = SimpleImputer(strategy="median")
df[numeric_cols] = imp.fit_transform(df[numeric_cols])
```

---

## Validation & Assertions

```python
import great_expectations as ge

df_ge = ge.from_pandas(df)
df_ge.expect_column_values_to_not_be_null("id")
df_ge.expect_column_values_to_be_between("age", 0, 120)
df_ge.expect_column_values_to_be_unique("id")
df_ge.expect_column_values_to_be_in_set("status", ["active", "inactive"])
```

Or lightweight pandera:
```python
import pandera as pa
schema = pa.DataFrameSchema({
    "id":     pa.Column(int, pa.Check.gt(0)),
    "email":  pa.Column(str, pa.Check.str_matches(r".+@.+")),
    "amount": pa.Column(float, nullable=True),
})
schema.validate(df)
```
