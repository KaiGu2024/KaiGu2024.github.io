# Agent Skill: Big-Data Processing

High-performance DataFrames with Polars and caching strategies for expensive computations.

Reference: [Polars Documentation](https://docs.pola.rs/)

---

## When to Use Polars over Pandas

- Dataset > 1 GB or computation is slow in pandas
- Need lazy evaluation (build query plan, execute once)
- Parallel CPU execution out of the box
- Strict null handling and consistent dtypes

---

## Polars Essentials

```python
import polars as pl

# Read
df = pl.read_csv("data.csv")
df = pl.read_parquet("data.parquet")  # preferred for large files

# Lazy API (recommended — defers execution)
q = (
    pl.scan_parquet("data.parquet")
    .filter(pl.col("year") >= 2015)
    .group_by("country")
    .agg(pl.col("value").mean().alias("mean_value"))
    .sort("mean_value", descending=True)
)
df = q.collect()
```

---

## Common Operations

```python
# Select + rename
df.select(["id", pl.col("price").alias("cost")])

# Filter (multiple conditions)
df.filter((pl.col("age") > 18) & (pl.col("status") == "active"))

# Group by + aggregate
df.group_by("region").agg([
    pl.col("sales").sum().alias("total_sales"),
    pl.col("sales").mean().alias("avg_sales"),
    pl.len().alias("n"),
])

# Join
df.join(other, on="id", how="left")

# String ops
df.with_columns(pl.col("name").str.to_lowercase())

# Apply custom function (use sparingly — breaks parallelism)
df.with_columns(pl.col("text").map_elements(my_fn, return_dtype=pl.Utf8))
```

---

## Pandas Interop

```python
# Polars → Pandas
df_pd = df.to_pandas()

# Pandas → Polars
df_pl = pl.from_pandas(df_pd)
```

---

## Caching Expensive Computations

**joblib** — disk cache for functions (numpy/sklearn friendly):
```python
from joblib import Memory

memory = Memory("cache/", verbose=0)

@memory.cache
def expensive_fn(param):
    ...  # result is saved to disk on first call
    return result

# Clear cache for one function
expensive_fn.clear()
```

**DiskCache** — general key-value store:
```python
from diskcache import Cache

cache = Cache("cache/")

key = f"embeddings_{model}_{hash(text)}"
if key not in cache:
    cache[key] = embed(text)
result = cache[key]
```

**functools.lru_cache** — in-memory, for pure functions called repeatedly in one session:
```python
from functools import lru_cache

@lru_cache(maxsize=512)
def lookup(entity_id: int) -> str:
    return db.query(entity_id)
```

---

## Saving / Loading Efficiently

```python
# Parquet (columnar, compressed — best for DataFrames)
df.write_parquet("data.parquet", compression="zstd")
df = pl.read_parquet("data.parquet")

# Arrow IPC (fastest read/write, no compression)
df.write_ipc("data.arrow")
df = pl.read_ipc("data.arrow")
```

---

## Report

After completing a data processing task, output a brief report:

**Input:** Source file(s), format, and shape (N rows × K cols) before processing.  
**Output:** Destination file, format, and shape after processing.  
**Operations:** List major transformations applied (filter, join, group-by, etc.) and row counts at each step.  
**Performance:** Wall-clock time; peak memory if notable; whether lazy evaluation was used.  
**Cache:** Which results were cached and where; cache hit/miss rate if repeated runs.
