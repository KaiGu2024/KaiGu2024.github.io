---
name: text-as-data
description: Use when turning unstructured text into quantitative measures for social-science research — surface inspection, frequency analysis, embeddings, GPT-as-measurement-tool with validation against human labels, then scaling. Pipeline: Inspect → Frequency → Embed → Measure (GPT) → Validate → Scale.
allowed-tools: Read, Edit, Write, Bash
invocation: auto
---

## Workflow

```
Inspect → Frequency → Embed → Measure (GPT) → Validate → Scale
```

---

## Step 1 — Surface Inspection

```python
import polars as pl
import polars.selectors as cs
import re
from collections import Counter

df = df.with_columns([
    pl.col("text").str.len_chars().alias("char_len"),
    pl.col("text").str.split(" ").list.len().alias("word_count"),
])
print(df.select(["char_len", "word_count"]).describe())

# Top word frequency
all_words = " ".join(df["text"].drop_nulls().to_list()).lower()
freq = Counter(re.findall(r'\b\w+\b', all_words)).most_common(30)
```

---

## Step 2 — Embeddings

Embed text to explore semantic structure before labeling.

```python
from sentence_transformers import SentenceTransformer
import numpy as np

model = SentenceTransformer("all-MiniLM-L6-v2")
embeddings = model.encode(df["text"].to_list(), show_progress_bar=True)
# embeddings: (N, 384)
```

**Dimensionality reduction for visualization:**

```python
import umap
import matplotlib.pyplot as plt

reducer = umap.UMAP(n_components=2, random_state=42)
xy = reducer.fit_transform(embeddings)

fig, ax = plt.subplots(figsize=(8, 6))
ax.scatter(xy[:, 0], xy[:, 1], alpha=0.3, s=5)
fig.savefig("text_umap.png", dpi=150)
```

Color by a categorical variable to check whether semantic clusters align with known groups.

---

## Step 3 — GPT Measurement

Treat GPT as a measurement instrument. Five primitives (Asirvatham et al., 2026):

| Method | Output | Use for |
|---|---|---|
| **Rating** | 0–100 score | Continuous attributes: toxicity, sentiment intensity, formality, populism |
| **Classification** | Category label | Discrete types: topic, stance, genre, domain |
| **Extraction** | Structured field | Named entities, dates, claims, numbers |
| **Ranking** | Pairwise ELO | Relative ordering when an absolute scale is ambiguous |
| **Discovery** | Discriminating features | Hypothesis generation — what textual features differ between two groups? |

**Rating example (Pydantic structured output):**

```python
from openai import OpenAI
from pydantic import BaseModel, Field

client = OpenAI()

class TextRating(BaseModel):
    score: float = Field(ge=0, le=100)
    rationale: str

def rate(text: str, attribute: str) -> TextRating:
    resp = client.beta.chat.completions.parse(
        model="gpt-4o-mini",
        messages=[{"role": "user", "content":
            f"Rate the following text on {attribute} from 0 (none) to 100 (extreme). "
            f"Cite specific phrases in your rationale.\n\n{text}"}],
        response_format=TextRating,
        temperature=0,
    )
    return resp.choices[0].message.parsed
```

**Classification example:**

```python
from enum import Enum

class Stance(str, Enum):
    pro = "pro"
    anti = "anti"
    neutral = "neutral"

class StanceLabel(BaseModel):
    stance: Stance
    confidence: float = Field(ge=0.0, le=1.0)
    rationale: str
```

---

## Step 4 — Validate Before Scaling

Always validate on a sample of 50–100 items before scaling to the full corpus.

**Test-retest reliability** (same prompt, two runs — target κ ≥ 0.90):

```python
import pandas as pd
from sklearn.metrics import cohen_kappa_score

# Bin continuous scores into 3 ordinal levels for kappa
bins = [0, 33, 66, 100]
k = cohen_kappa_score(
    pd.cut(scores_run1, bins=bins, labels=False),
    pd.cut(scores_run2, bins=bins, labels=False),
)
print(f"Test-retest kappa: {k:.3f}")   # target ≥ 0.90
```

**Human agreement** (target median κ ≥ 0.60; Asirvatham et al. report 0.65 across tasks):

```python
kappa_human = cohen_kappa_score(human_labels, llm_labels)
print(f"Human–GPT kappa: {kappa_human:.3f}")
```

**Prompt robustness**: run two or three phrasings of the same construct; classification results should not depend on exact wording (Asirvatham et al. finding: prompt robustness holds across phrasings).

---

## Step 5 — Scale

Only scale after validation passes. Use batch APIs for ~50% cost reduction:

```python
# Anthropic Batch API
# https://docs.anthropic.com/en/api/creating-message-batches

# OpenAI Batch API
# https://platform.openai.com/docs/guides/batch
```

For large corpora, see also [LLM Annotation](llm-annotation.md) for batch pipeline patterns, tip on randomizing label order, and per-dimension call strategy.

---

## Report

See [Report format](report.md).

**Definition (measure):** N texts; attribute(s) measured; scale or category set; model and temperature.  
**Analyses:** Surface stats (length, word count); embedding visualization (UMAP); GPT measurement method used (Rating / Classification / Extraction / Ranking / Discovery); test-retest κ; human–GPT κ on validation sample.  
**Takeaway:** Whether the measurement is reliable enough to use (κ thresholds met); any attribute-level failures or ambiguous edge cases flagged for prompt revision.
