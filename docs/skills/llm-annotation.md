# Agent Skill: LLM Annotation

Using large language models to generate, assess, and integrate data labels for research workflows.

Reference: [LLM4Annotation Survey — Tan et al., EMNLP 2024](https://arxiv.org/abs/2402.13446)

---

## When to Use

- Ground-truth labels are expensive or slow to obtain from human annotators
- Task is well-defined enough to specify in a prompt (sentiment, topic, entity, stance, etc.)
- You need to annotate thousands to millions of items at low cost
- You want to augment or validate a smaller set of human labels

---

## Label Generation

**Zero-shot classification** (simplest):
```python
import openai

def annotate(text, categories):
    prompt = f"""Classify the following text into exactly one category: {', '.join(categories)}.
Reply with only the category name.

Text: {text}"""
    resp = openai.chat.completions.create(
        model="gpt-4o-mini",
        messages=[{"role": "user", "content": prompt}],
        temperature=0
    )
    return resp.choices[0].message.content.strip()
```

**Structured output** (recommended for downstream use):
```python
from pydantic import BaseModel

class Label(BaseModel):
    category: str
    confidence: str  # "high" | "medium" | "low"
    rationale: str

resp = openai.beta.chat.completions.parse(
    model="gpt-4o",
    messages=[{"role": "user", "content": f"Classify: {text}"}],
    response_format=Label
)
label = resp.choices[0].message.parsed
```

---

## Batch Annotation Pipeline

```python
import pandas as pd
from tqdm import tqdm

def batch_annotate(df, text_col, categories, model="gpt-4o-mini", batch_size=50):
    results = []
    for i in tqdm(range(0, len(df), batch_size)):
        batch = df[text_col].iloc[i:i+batch_size]
        labels = [annotate(t, categories) for t in batch]
        results.extend(labels)
    df["label"] = results
    return df
```

For large corpora, use the [Anthropic Batch API](https://docs.anthropic.com/en/api/creating-message-batches)
or [OpenAI Batch API](https://platform.openai.com/docs/guides/batch) for ~50% cost reduction.

---

## Quality Assessment

**Inter-rater agreement** between LLM and human labels:
```python
from sklearn.metrics import cohen_kappa_score, classification_report

kappa = cohen_kappa_score(human_labels, llm_labels)
print(f"Cohen's kappa: {kappa:.3f}")
print(classification_report(human_labels, llm_labels))
```

**Self-consistency check** (run same prompt 3× and flag disagreements):
```python
def consistent_label(text, categories, n=3):
    labels = [annotate(text, categories) for _ in range(n)]
    if len(set(labels)) == 1:
        return labels[0], True   # consistent
    from collections import Counter
    return Counter(labels).most_common(1)[0][0], False  # majority vote
```

---

## Prompt Design Tips

1. **Define categories explicitly** — list all options and their boundaries
2. **Provide 2–3 examples** (few-shot) for ambiguous categories
3. **Ask for rationale** before the label to improve accuracy (chain-of-thought)
4. **Set temperature=0** for reproducibility
5. **Test on 50–100 human-labeled examples** before full deployment

---

## Integration with Supervised Learning

```python
# Use LLM labels as weak supervision to train a cheaper classifier
from sklearn.linear_model import LogisticRegression
from sentence_transformers import SentenceTransformer

encoder = SentenceTransformer("all-MiniLM-L6-v2")
X = encoder.encode(texts)
y = llm_labels  # labels from LLM

clf = LogisticRegression().fit(X, y)
# Now run clf on millions of records at zero marginal cost
```

---

## Report

See [Report format](report.md).

**Definition (measure):** N items annotated; Cohen's κ against human labels (if available); self-consistency rate (if run); model and temperature used.  
**Analyses:** Annotation task and categories; prompt strategy (zero-shot / few-shot / chain-of-thought); batch size and API used.  
**Takeaway:** Quality verdict — whether κ meets the bar for the downstream task; categories with low confidence or high inconsistency; recommended human-review sample size.
