---
name: big-data-processing
description: Use when working with datasets too large for Pandas — Polars by default for in-memory work, DuckDB once raw size hits tens of GB or RAM becomes the bottleneck. Covers lazy query planning, Arrow zero-copy interop between the two tools, caching strategies for expensive computations, and the tradeoffs at different scales.
allowed-tools: Read, Edit, Write, Bash
invocation: auto
---

## Polars by default; DuckDB at scale

**Always prefer Polars over Pandas.** Polars wins on every axis that matters for research workflows — multi-threaded execution, lazy query planning, strict null handling, consistent dtypes, and faster group-bys / joins at every size from 100 MB up. Pandas is the legacy default; treat it as interop only (see [Pandas Interop](#pandas-interop)).

**Switch from Polars to DuckDB when the dataset stops fitting in RAM after filtering.** Concretely:

- Raw size is tens of GB and you need persistent, queryable storage
- Multiple coauthors need to run queries without re-loading the dataset
- The pipeline assembles many CSV/Parquet sources into one panel
- You need SQL semantics (window functions, complex joins) at scale

DuckDB reads only the columns a query touches and runs out-of-core. A 70 GB CSV corpus compresses to ~6 GB Parquet (≈15× shrink) and becomes interactive on a laptop.

The two tools compose. Both speak Arrow, so handing a DuckDB result to Polars for downstream pipeline work is zero-copy:

```python
import duckdb, polars as pl

df = duckdb.sql("""
    SELECT year, msa, AVG(rate) AS mean_rate
    FROM read_parquet('data/raw/hmda_*.parquet')
    GROUP BY year, msa
""").pl()                               # Arrow → Polars, zero-copy

out = df.with_columns(pl.col("mean_rate").rolling_mean(3).over("msa"))
```

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

## Multiprocessing

Polars parallelizes internally — do not wrap Polars operations in `ProcessPoolExecutor`. For multiple files, use Polars' native glob scan:

```python
# Polars reads and processes all matching files in parallel natively
df = pl.scan_parquet("data/*.parquet").filter(pl.col("year") >= 2015).collect()
```

Use `ProcessPoolExecutor` only for **pure Python CPU-bound functions** that Polars cannot vectorize:

```python
from concurrent.futures import ProcessPoolExecutor
import multiprocessing as mp

def heavy_fn(item):
    # custom Python logic — not a Polars operation
    ...

items = [...]
with ProcessPoolExecutor(max_workers=mp.cpu_count()) as pool:
    results = list(pool.map(heavy_fn, items))
```

**Caution:** workers communicate via pickle — pass simple values (strings, ints, small dicts), not DataFrames or open file handles. For I/O-bound work (API calls, file reads), use `ThreadPoolExecutor` instead — the GIL is released on I/O so threads already achieve true parallelism at lower overhead.

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

## Convert-once, query-many architecture

For tens-of-GB administrative datasets, decouple ingestion from analysis. Convert raw CSV to Parquet **once**; query the Parquet (or a `.duckdb` file built from it) **many** times.

The final artifact is a single `.duckdb` file containing the harmonized data, a `metadata` table, and any pre-built aggregates. One file, one open, one query path — for you, your coauthors, and any future session.

```python
import duckdb

# CSV → Parquet (one-time, per source year). Columnar + compressed.
duckdb.sql("""
    COPY (SELECT * FROM read_csv_auto('data/raw/hmda_2024.csv'))
    TO   'data/parquet/hmda_2024.parquet' (FORMAT PARQUET, COMPRESSION ZSTD)
""")

# Build the queryable artifact from many Parquet files.
con = duckdb.connect("research.duckdb")
con.sql("""
    CREATE TABLE hmda AS
    SELECT * FROM read_parquet('data/parquet/hmda_*.parquet')
""")
```

DuckDB's persistent format means a coauthor can `duckdb research.duckdb` and run the same SQL the next morning, without re-ingesting anything.

---

## CSV → Parquet → DuckDB pipeline

Recommended file layout for any administrative-data build:

```
config.py        # URLs, column mappings, schema definitions
download.py      # download with resume capability
convert.py       # CSV → parquet (one file per source year)
harmonize.py     # schema crosswalk between eras
build_db.py      # DuckDB assembly + metadata
run_pipeline.py  # orchestrate all steps
prompts.md       # versioned record of prompts used to build the pipeline
```

`prompts.md` is a record of the prompts used. The build is reproducible only if the prompts are versioned alongside the code.

**Long-running conversions.** Treat them like batch jobs, not interactive coding:

1. Test on a 2-year subset first to catch delimiter / encoding / column issues cheaply.
2. Verify column names in one file from each era before launching the full run.
3. Launch the remaining conversions as background jobs.
4. Use `sleep 60` (or the agent's background-job tooling) to check progress — don't sit idle, don't spam-poll.

---

## Schema crosswalks across eras

Administrative datasets change column names, codes, and identifiers across releases. Put the crosswalk in a file (`harmonize.py`), not in a chat exchange — so it is reviewable, versionable, and re-runnable.

A crosswalk has two parts:

- **Column mapping** — old name → new name per era.
- **Value-set transformation** — map drifted codes (e.g. a year that used `loan_purpose` codes 31/32 instead of 2/3) to the canonical set.

```python
# harmonize.py — minimal sketch
COLUMN_MAP_PRE2018 = {
    "as_of_year":          "year",
    "respondent_id":       "lender_id",
    "applicant_race-1":    "applicant_race_1",
    # ...
}
LOAN_PURPOSE_MAP_PRE2018 = {31: 2, 32: 3}     # legacy → canonical

def harmonize(con, era):
    cols = COLUMN_MAP_PRE2018 if era == "pre2018" else COLUMN_MAP_POST2018
    select = ", ".join(f'"{src}" AS {dst}' for src, dst in cols.items())
    con.sql(f"CREATE OR REPLACE TABLE hmda_{era} AS SELECT {select} FROM raw_{era}")
```

**Rule:** when value sets drift, the agent should *flag and ask*, not silently re-code millions of rows. State this explicitly in the brief: *"if value codes differ across years, surface the discrepancy and request guidance before applying any transformation."*

**Recurring DuckDB gotchas worth checking:**

- `normalize_names` strips hyphens entirely (`applicant_race-1` becomes `applicant_race1`, not `applicant_race_1`). Update the column mapping if you want underscores.
- API-documented delimiters can be wrong. Have the agent test the first header row before committing read options (`read_csv_auto` will sniff but is not always right).
- Geographic FIPS codes can be fragmented for some counties in some years (HMDA: LA County post-2018). Derive state FIPS independently rather than parsing the county field.

---

## Metadata table (context engineering for data)

Store the data dictionary *inside* the database, in a `metadata` table.

| column         | description                                  |
|----------------|----------------------------------------------|
| `column_name`  | name in the harmonized table                 |
| `description`  | one-line plain English                       |
| `data_type`    | DuckDB type                                  |
| `valid_values` | e.g. `"1=originated, 2=approved, 3=denied"`  |
| `years`        | which source years this column appears in    |

```python
con.sql("""
    CREATE TABLE metadata (
        column_name  VARCHAR,
        description  VARCHAR,
        data_type    VARCHAR,
        valid_values VARCHAR,
        years        VARCHAR
    );
    INSERT INTO metadata VALUES
      ('action_taken',
       'Outcome of the application',
       'INTEGER',
       '1=originated, 2=approved not accepted, 3=denied, 4=withdrawn, ...',
       '2007-2024');
""")

# Any future session — yours or a coauthor's — opens the .duckdb file and runs:
#   SELECT * FROM metadata;
# No re-uploading data dictionaries, no re-explaining the build.
```

> *"The metadata survives compaction, session restarts, and coauthor handoffs. It's context engineering applied to datasets."* — Goldsmith-Pinkham, Markus' Academy 162-4

---

## Aggregate tables alongside raw rows

Don't ship coauthors hundreds of millions of raw rows. Build derived tables alongside the raw table — one SQL query against the harmonized data, DuckDB handles the aggregation:

```python
con.sql("""
    CREATE TABLE county_year AS
    SELECT
        year,
        county_fips,
        COUNT(*)                                AS n_originations,
        SUM(loan_amount)                        AS dollar_value,
        COUNT(DISTINCT lender_id)               AS n_lenders,
        SUM(POWER(lender_share, 2))             AS hhi,
        AVG(CASE WHEN action_taken = 3 THEN 1.0 ELSE 0 END) AS denial_rate,
        MEDIAN(loan_amount)                     AS median_loan_amount
    FROM hmda
    WHERE action_taken IN (1, 3)
    GROUP BY year, county_fips
""")
```

**Sanity checks before shipping the panel:**

- Top counties by volume look right (Los Angeles, Maricopa, Cook, Harris).
- Time series tracks known events: 2007 mortgage peak, post-crisis collapse, 2020–2021 COVID refi boom, falloff with rate rises.
- Flag artifacts (e.g. a 2018 dip from the LEI identifier transition is *not* a real market shift — note for footnotes).

---

## Report

Output uses the Quick Template — three labeled lines, **Definition** / **Description** / **Takeaway**. (For multi-section writeups, see [report.md](report.md).)

**Definition (measure):** Input and output shape (N rows × K cols) and format; wall-clock time; cache hit/miss rate if repeated runs.  
**Analyses:** Major transformations applied (filter, join, group-by, etc.) with row counts at each step; whether lazy evaluation was used; which results were cached and where.  
**Takeaway:** Performance gain vs. naive approach; any data quality issues surfaced during processing.
