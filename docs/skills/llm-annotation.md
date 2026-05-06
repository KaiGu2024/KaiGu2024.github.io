---
name: llm-annotation
description: Use when generating, assessing, or integrating data labels via LLMs for research workflows — structured Pydantic outputs, batch processing, validation against a human gold-set, agreement metrics (Cohen's κ, F1), and uncertainty quantification. For when ground-truth labels are slow or expensive to obtain from human annotators.
allowed-tools: Read, Edit, Write, Bash
---

## When to Use

- Ground-truth labels are expensive or slow to obtain from human annotators
- Task is well-defined enough to specify in a prompt (sentiment, topic, entity, stance, etc.)
- You need to annotate thousands to millions of items at low cost
- You want to augment or validate a smaller set of human labels

---

## Building a Codebook from Raw Text (Qualitative Pre-Step)

Before you can use an LLM to annotate text, you need a codebook — the set of labels with definitions, inclusion criteria, exclusion criteria, and example quotes. If a codebook already exists (prior qualitative work, theoretical framework, pilot study), skip this section and go to **Label Generation**. If you're starting from raw transcripts, focus-group notes, or open-ended responses, build a draft first.

This step produces a **draft** codebook, not a final one. Real qualitative coding requires human judgment, inter-coder reliability checks, and theoretical framing the model cannot provide. The output is a starting point for human refinement.

### Non-negotiable rules

1. Every code must have: a **name**, a **one-sentence definition**, **inclusion criteria** (what counts), **exclusion criteria** (what does not), and **at least 2 example quotes** (with source `file:offset`).
2. **Never invent a quote.** Every example must be a literal substring of an actual transcript.
3. **Never claim the codebook is comprehensive.** Always end with "this is a starting point for human refinement" and list what was *not* coded for.
4. **Refuse if the corpus is too thin** to support inductive coding (fewer than 5 documents, or under 500 words total).

### Workflow

```
Inventory corpus → Open coding (read all) → Cluster to 8–15 candidate codes → Write each formally → Emit with provenance
```

**Step 1 — Inventory the corpus.**

```bash
fd -e txt -e md -e docx -e pdf <path>

# Word count per file
for f in *.txt; do echo "$f $(wc -w < "$f")"; done
```

If files are PDFs or DOCX, ask the user to convert to plain text first. Do not silently OCR.

**Step 2 — Open coding (first read).** Read each file. Note any phrase or passage that stands out as expressing a recurring theme, attitude, behavior, or concern. Maintain a running list: theme phrase + source `file:offset` + the literal quote. Aim for breadth — 30+ tentative themes is fine. Do not collapse them yet.

**Step 3 — Cluster into candidate codes.** Group tentative themes into 8–15 candidate codes. Each cluster must be:

- **Coherent** — members share a clear concept, not just surface-level wording
- **Distinct** — two codes must not require the coder to flip a coin between them
- **Evidenced** — backed by at least 3 instances across at least 2 files

Drop clusters that fail any of the three.

**Step 4 — Write each code formally.**

```markdown
### Code: <NAME_IN_CAPS>

**Definition:** <one sentence>

**Inclusion criteria:**
- <bullet>
- <bullet>

**Exclusion criteria:**
- <bullet>
- <bullet>

**Examples:**
1. "<literal quote>" — `interview_03.txt:412`
2. "<literal quote>" — `interview_07.txt:88`
3. "<literal quote>" — `interview_12.txt:201`

**Frequency in corpus:** <N occurrences across M files>
```

**Step 5 — Emit the codebook with provenance.**

```markdown
# Draft Codebook — <project name>

**Corpus:** N files, M words total. Coding date: YYYY-MM-DD. Coder: claude-code (model version X).

This is a **first-pass draft**. Before using it for substantive analysis:

1. Review every code with at least one human coder.
2. Pilot the codebook on a held-out subset and compute inter-coder agreement (Krippendorff's alpha or Cohen's kappa).
3. Revise codes that score below 0.70 agreement.
4. Document every revision in a coding memo.

## Codes
[the formal blocks from Step 4]

## What was not coded
- [obvious themes the model deliberately did not include — e.g., "demographic descriptors are metadata, not coded"]
```

The codebook produced here feeds directly into **Prompt Codebook** below — inclusion/exclusion criteria become the LLM annotation rubric; example quotes become few-shot examples in the prompt.

### Subagent pattern (`context: fork`)

Reading 5–50 transcripts fills the main conversation context fast and the raw transcripts are irrelevant to the parent conversation. Run this step as a subagent — the subagent reads the files, develops the codebook, and returns the codebook only.

### Notes for extending

- **Deductive overlay.** If the user has an existing theoretical framework (e.g., self-determination theory), accept it as input and cluster around its constructs rather than purely inductively.
- **Inter-coder pre-check.** Add a Step 4.5 that double-codes a held-out 10% of the corpus and reports preliminary agreement.

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
