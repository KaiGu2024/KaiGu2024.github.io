# Agent Skill: LLM Annotation

Using large language models to generate, assess, and integrate data labels for research workflows.

References: [LLM4Annotation Survey — Tan et al., EMNLP 2024](https://arxiv.org/abs/2402.13446); Törnberg, P. (2024). Best practices for text annotation with large language models.

---

## When to Use

- Ground-truth labels are expensive or slow to obtain from human annotators
- Task is well-defined enough to specify in a prompt (sentiment, topic, entity, stance, etc.)
- You need to annotate thousands to millions of items at low cost
- You want to augment or validate a smaller set of human labels

---

## Label Generation

**Structured output** (recommended for downstream use):
```python
from pydantic import BaseModel, Field

class Label(BaseModel):
    category: str
    confidence: float = Field(ge=0.0, le=1.0)  # float beats categorical: 3× better calibration (Yang et al., 2024)
    rationale: str

resp = openai.beta.chat.completions.parse(
    model="gpt-4o",
    messages=[{"role": "user", "content": f"Classify: {text}"}],
    response_format=Label
)
label = resp.choices[0].message.parsed
# Flag items below 0.7 for human review; accept ≥ 0.7 directly
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

## Parameters

Specify all four explicitly — defaults vary across providers and versions:

| Parameter | Recommended | Notes |
|---|---|---|
| **Temperature** | 0 | Deterministic output; required for reproducibility |
| **Top-P** | 0.2–0.4 | Nucleus sampling; only active when temperature > 0 |
| **Top-K** | provider default | Limits candidates to top-k tokens; rarely needed with temp=0 |
| **Max tokens** | task-specific | Set a cap; avoid unbounded output for classification |

---

## Quality Assessment

**Calibration loop** — run human and LLM on the same small sample; inspect disagreements and revise the prompt before touching the held-out validation set:
```python
def calibration_loop(sample_texts, human_labels, categories, n_rounds=3):
    for round_i in range(n_rounds):
        llm_labels = [annotate(t, categories) for t in sample_texts]
        mismatches = [
            (t, h, l) for t, h, l in zip(sample_texts, human_labels, llm_labels) if h != l
        ]
        print(f"Round {round_i+1}: {len(mismatches)}/{len(sample_texts)} disagreements")
        if not mismatches:
            break
        # Inspect mismatches → revise prompt → repeat
    # Finalize prompt here; only then run held-out validation
    return llm_labels
```

**Inter-rater agreement** between LLM and human labels:
```python
from sklearn.metrics import cohen_kappa_score, classification_report

kappa = cohen_kappa_score(human_labels, llm_labels)
print(f"Cohen's kappa: {kappa:.3f}")
print(classification_report(human_labels, llm_labels))
```

**Subset validation** — for multilingual or multi-context corpora, aggregate kappa can mask subset failures:
```python
for subset_name, subset_df in df.groupby("language"):
    kappa = cohen_kappa_score(subset_df["human"], subset_df["llm"])
    print(f"{subset_name}: κ = {kappa:.3f}")
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

**Prompt stability analysis** — paraphrase the prompt in several ways and measure agreement across variants; tests whether results are robust to researcher phrasing choices (Törnberg 2024):
```python
import krippendorff

def prompt_stability(texts, prompt_variants, categories):
    cat_map = {c: i for i, c in enumerate(categories)}
    data = []
    for prompt_fn in prompt_variants:
        labels = [annotate_with_prompt(t, prompt_fn, categories) for t in texts]
        data.append([cat_map[l] for l in labels])
    alpha = krippendorff.alpha(reliability_data=data, level_of_measurement="nominal")
    print(f"Krippendorff's alpha across {len(prompt_variants)} prompt variants: {alpha:.3f}")
    return alpha
```

**Contamination check:** If your corpus spans the model's training cutoff, validate pre- and post-cutoff subsets separately — annotation quality may differ systematically. Do not use publicly available labeled benchmarks as validation data; the model may reproduce memorized labels.

---

## Prompt Design Tips

1. **Define categories explicitly** — list all options and their boundaries
2. **Provide 2–3 examples** (few-shot) for ambiguous categories
3. **Ask for rationale** before the label to improve accuracy (chain-of-thought)
4. **Use lists for complex instructions** — bulleted lists outperform dense prose when the prompt has multiple constraints or decision rules
5. **Balance brevity and specificity** — include all constraints the task requires, no more; verbose prompts dilute attention
6. **System role for instructions, user role for input** — put task instructions and category definitions in the system message; pass the text to annotate in the user message
7. **Set temperature=0** for reproducibility
8. **Test on 50–100 human-labeled examples** before full deployment
9. **Positional bias** — first-listed options get 8–15% more assignments (Zheng et al., ICLR 2024). Two mitigations in tension: *randomize* order across calls (reduces bias, hurts reproducibility); *alphabetize* options (consistent highest-probability token, fully reproducible — Törnberg 2024). **Decision required:** choose one strategy before running annotation and record it in the prompt codebook.
10. **Add an uncertainty option** ("I don't know" / "unclear") — reduces forced stochastic choices on ambiguous items
11. **One call per dimension** for multi-attribute tasks — accuracy degrades for the 2nd and 3rd labels in a joint call (Ma et al., EMNLP 2025); costs Nx but recovers accuracy
12. **Web search for entity tasks** — pass a `web_search` tool when classifying entities the model may not know (obscure domains, recent events); not needed when the text itself is the context
13. **Use XML tags** for structured input — wrap instructions, categories, and content in `<instructions>`, `<categories>`, `<text>` tags; Claude was trained on XML and allocates attention to tagged regions more reliably

---

## Prompt Codebook

The prompt codebook is the reproducibility artifact for LLM annotation. Archive it with your dataset and cite it in the methods section.

| Component | Content |
|---|---|
| Category definitions | What each label means; decision rules for boundary cases |
| Human coder instructions | The equivalent human annotation guide |
| Full prompt text | Exact system + user messages, including few-shot examples |
| Parameters | Model ID, temperature, top-p, top-k, max tokens |
| Iteration log | Prompt version used at each calibration round |

---

## Report

See [Report format](report.md).

**Definition (measure):** N items annotated; Cohen's κ against human labels (if available); subset-level κ for multilingual/multi-context corpora; prompt stability α (if run); self-consistency rate (if run); model and temperature used.  
**Analyses:** Annotation task and categories; prompt strategy (zero-shot / few-shot / chain-of-thought); batch size and API used.  
**Takeaway:** Quality verdict — whether κ meets the bar for the downstream task; categories with low confidence or high inconsistency; recommended human-review sample size.
