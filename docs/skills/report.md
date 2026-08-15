---
name: report
description: Use when writing up the result of an analysis, modeling run, or data exploration into a structured deliverable — triggers on "summarize the findings", "write this up", "give me the executive summary", "draft the writeup", "report what we found", as well as explicit "report" requests. Quick Template (Definition / Description / Takeaway) for single-step outputs; Writing Pipeline (Abstract / Data & Sample / Definitions / Findings / Heterogeneity / Benchmark / Limitations) for multi-section reports. Includes the pre-report validity check (analysis review) that should run before §3 Findings is drafted.
allowed-tools: Read, Edit, Write
invocation: auto
---

## Quick Template

```
**Definition (measure):** The primary output and how it is quantified.
**Description:** What the figure or table shows — observable pattern, numbers, direction.
**Takeaway:** What we conclude — practical significance, flag concerns.
```

Use the Quick Template for single-step skill outputs (a scraping run, an annotation batch, an EDA). Use the Writing Pipeline below for multi-section analysis reports.

---

## Writing Pipeline

### Title

`Report — {Name}`

### Abstract

Write last, place first.

**Abstract funnel:** Organize the abstract in this order:

1. **Motivation:** Open with the real-world phenomenon and its central tension (economic when relevant).
2. **Research object:** In one short sentence, state what the report studies, where, and in relation to its core explanatory dimensions. Prefer *“This report studies X on Y in relation to A, B, and C”* over a list of every subquestion; let the findings reveal the detailed structure.
3. **Data scope:** State the data source, observation period, population or unit, and essential dataset counts. Counts that define the sample belong here, not among the findings.
4. **Findings:** When there are several, write *“We find N things:”* and number them **(1)** through **(N)**. Each finding should answer a substantive question, stand on its own, and include a headline magnitude when available. Use one brief sentence per substantive section; a report with N core questions should normally have N corresponding findings. Do not present a data limitation as an extra finding.
5. **Significance:** Close with what this report or module adds to the whole paper’s argument.

**Abstract clarity test:** Use technical terms selectively. Keep a specialized term when it names a necessary empirical construct, but define it in plain language on first use. Avoid unexplained compound labels such as “zero-inclusive frame,” “risk set,” or “left-censored stock”: replace them with the underlying population, time limitation, or measurement rule, or immediately gloss the term. Remove internal shorthand when it adds no precision.

Keep it brief and use plain language. Cap at 250 words total. Put operational caveats in a data footnote when they qualify a measure without changing the report’s headline. Reserve the abstract for limitations that change the headline interpretation; do not end with a long non-identification disclaimer.

### §1 Data & Sample

Present the sample as a sequence:

1. **Full universe:** State the substantive population and inclusion rule directly. Do not use an internal label such as “U2 frame” or “risk set” without immediately explaining who or what it includes.
2. **Observation rule:** State the data source, collection period, pull date, unit of observation, matching rule, and N-funnel (N at each filtering step).
3. **Observed subsets:** Move from the full universe to each observed subset and final sample. State which analyses use each subset and why.

**Analysis-layer map:** When a report has multiple analytical layers with different samples or units, add one compact table after the sample sequence:

| Analysis layer | Actual unit and sample | Relevant count | Time window, if needed |
|---|---|---:|---|
| [Subquestion or analysis] | [Unit and inclusion rule] | [Count appropriate to that unit] | [Period] |

Use the table to show which evidence supports each analysis, not to inventory all available data coverage. Retain units with zero observed records when they belong to the analysis population. Label layers that are not language- or repository-level by their actual unit, and report the count appropriate to that unit rather than forcing an inapplicable language or repository count.

**Observed zeros:** Define what a zero means under the collection rule. Distinguish *“no matched record was found”* from the stronger claim that the platform offers no support.

**Data objects and measures:** Name conceptually different objects separately rather than grouping them under a broad label. For example, a Hugging Face dataset listing is a tagged repository, whereas OPUS parallel text is an external count of aligned translated text; they are not interchangeable measures of “training data.” Define nonstandard terms in plain language at first use (for example, *dedicated translation model*, *OPUS parallel text*, *repository-language edge*, or *listed dataset*), with the full metric definition in §2.

**Takeaway:** State the sample's coverage, selection concerns, and whether it can support a claim of representativeness. Keep collection limitations only when they materially change what a zero, count, or estimate means; put qualifying operational details in a data footnote.

Keep this section descriptive. Put regression functional forms, controls, and estimation choices in the relevant analysis section immediately before the result they qualify.

**Suite note:** if this report is one of several sharing the same sample and definitions (e.g., a fact-sheet suite), replace §1/§2 with a one-line pointer — *"Sample and definitions: see [Suite Reference]"* — and omit the full restatement.

### §2 Definitions

Define only nonstandard concepts and measures needed to interpret the findings. Group them by analytical role and present them in the order used later.

- **Numerical measure:** State its construction or formula, unit and denominator, time reference, and the meaning of zero or missing values.
- **Classification:** State its inclusion rule, relevant threshold, whether classes are mutually exclusive, and important exclusions.
- **Proxy:** State what it is intended to approximate, how it is constructed, and the likely direction of measurement error.
- **External data object:** Distinguish what it directly measures from the economic concept it may proxy.

Use compact prose. Formula, unit, and range are required only when meaningful. Cite the canonical source for a standard metric only when needed, and define it here only if the report's operationalization differs.

Do not place sample counts, empirical findings, regression specifications, or inventories of unavailable variables in Definitions. Put them in Data and Sample, the relevant Analysis section, or Limitations, respectively.

### §3 Findings

Organize Findings by subquestion:

```text
3. Findings
   3.1 {Subquestion 1}
   3.2 {Subquestion 2}
   3.3 {Subquestion 3}
```

The subsection title states the subquestion; do not restate it in the prose. Within each subsection, use this sequence:

1. **Empirical setup:** In one compact paragraph, state the method and only the choices needed to read the result: the analysis-specific sample if it differs from §1, unit of observation, outcome and explanatory variables, specification, controls or fixed effects, and uncertainty method. Explain why a different subset is used.
2. **Exhibit lead:** Introduce each figure or table with the finding it establishes; do not leave readers to infer why it appears.
3. **Figure or table:** Show the main empirical object. If several objects answer the same subquestion, introduce each one and follow it immediately with its description.
4. **Description:** State what the object shows: direction, headline magnitude, uncertainty, and effect size where relevant. Lead with the result and calibrate the language to descriptive, associational, or causal evidence. Do not add mandatory Question, Interpretation, Takeaway, or Qualification blocks.

Back-reference §2 for any self-defined or uncommon metric on every appearance. Flag deviations from the planned analysis as exploratory.

#### Exhibit discipline

- Write the subsection's logical claims before selecting exhibits. Assign each principal claim one primary figure or table; add another only when it supplies distinct evidence. Every exhibit must answer the subsection question and support a substantive takeaway. Remove exhibits that add only peripheral description.
- Disclose units in three complementary layers: use the axis label or table heading for the metric and aggregation; the LaTeX caption or panel subtitle for the population or analytical object; and the note for what one observation represents, the universe, denominator, sample size or missing-data coverage, and exclusions. For example: axis **Median parameters per foundation model**; panel subtitle **Foundations adopted for low-market languages**; note **Unit: one registry-recognized foundation model; 25 of 27 adopted foundations have measured parameter counts.** Do not repeat the same text across all three layers.
- For comparable panels, generate each panel independently and combine them under one figure number only when they jointly establish one argument and use compatible units, populations, denominators, and scales. Otherwise use separate figure floats.
- Before accepting an exhibit, verify that the code's aggregation level, axis or column heading, LaTeX caption or panel subtitle, prose, and note all describe the same unit. Never alternate casually among units such as languages, repositories, models, and foundation models.
- After compiling the report under **TeX Build and Cleanup**, inspect each figure in the compiled document; labels that work in a standalone file may be clipped or unreadable after scaling.
- When dropping an analysis, remove its prose, definitions used only by that analysis, code that generates it, generated output files, and cross-references—not merely its LaTeX input.

#### Figure and table notes

Use notes below figures and tables to make each object understandable on its own. Put compact methodology in the note when it applies only to that object; keep shared methods, identification logic, assumptions, and substantive argument in the main text.

Write notes in this order, omitting items that do not apply:

1. What the figure or table shows, including the population, time period, and what one observation represents.
2. How to read panels, axes, lines, rows, or columns; define displayed variables, transformations, units, denominators, and reference categories.
3. The local empirical setup: estimand or specification, treatment and comparison groups, controls, fixed effects, weights, and sample restrictions.
4. How uncertainty is computed and displayed: SE or confidence interval, clustering level, and significance markers if used.
5. Sample size, missing-data coverage, or exclusions that materially affect interpretation.
6. **Source:** data or external source, placed last.

Use lowercase superscript letters for notes tied to specific table entries. Follow the target journal's convention for significance markers. A note may point to §1, §2, or an appendix for full details, but it must still define what the reader sees.

```text
Notes: This figure/table shows [outcome] for [population and period]; one observation is [unit]. [Explain panels or columns and define displayed measures, units, and denominators.] Estimates use [specification, controls/fixed effects, weights, and sample restriction]. [State N, coverage, or exclusions when material.] [SE/CI] are [method and clustering level]. Source: [data or citation].
```

### §N Heterogeneity *(if applicable)*

**Analysis:** subgroup breakdown by the most theoretically motivated dimensions (platform, user type, time window, geography).
**Takeaway:** where the effect is largest, smallest, or absent; whether heterogeneity is consistent with the proposed mechanism.

### §N Benchmark (if applicable)

**Analysis:** comparison table against prior work on the same measure — 1 highly relevant source is enough; add more only if they materially differ in sample or method. See the [Benchmark reference](#benchmark-reference) section below for sources by measure type.

| Source         | Measure | Value | Time period | Sample |
| -------------- | ------- | ----- | ----------- | ------ |
| *This study* | …      | …    | …          | …     |
| [Prior work]   | …      | …    | …          | …     |

Flag **data differences** (time period, sample size, selection mechanism, geography, platform) and **measure differences** (numerator/denominator, aggregation level, behavioral vs. self-reported) for each comparator.
**Takeaway:** alignment or divergence explained in 2–4 sentences. Name the most plausible explanation if estimates diverge.

### §N Limitations *(if applicable)*

**Analysis:** enumerate threats to validity — identification assumptions violated, sample selection, measurement error, generalizability.
**Takeaway:** which limitation would most change the conclusion if addressed; suggested next steps.

---

## Paper-section Templates

The Writing Pipeline above structures an *internal report*. These templates structure *paper sections* for a journal submission — a different audience and stage. Pair with [`paper-writing`](paper-writing/references/main-text.md) §Movement 7 when strict claim traceability is required (the canonical case is Methods, where one invented detail sinks credibility).

| Section | Slots |
|---|---|
| **Methods** | Design, sample, measures, analysis plan, ethics |
| **Results** | Descriptive stats, main findings, robustness — use §3 Findings above for slot-level structure |
| **Discussion** | Summary, theoretical contribution, practical implications, limitations, future research |

Slots without source material become explicit `[TODO]` placeholders, never silent omissions. The discipline that enforces this — `[CITE: handle]` for references, `[TODO: number]` for absent values, `file:line` provenance for every empirical claim — is in [`paper-writing`](paper-writing/references/main-text.md) §Movement 7.

---

## TeX Build and Cleanup

- After every edit to a `.tex` file, immediately compile the affected document before making further writing edits or reporting completion.
- Use the document's documented build command. For context reports, run `pdflatex -interaction=nonstopmode -halt-on-error <file>.tex` twice from that report directory.
- If a TeX compiler is unavailable or the build fails, report the source/PDF mismatch explicitly and do not present the PDF as current.
- After a successful build, remove only that document's generated intermediates: `.aux`, `.bbl`, `.bcf`, `.blg`, `.fdb_latexmk`, `.fls`, `.lof`, `.log`, `.lot`, `.out`, `.run.xml`, `.synctex.gz`, and `.toc`. Keep the `.tex` source and final `.pdf`. Retain the affected `.log` only while diagnosing a failed build.

---

## Pre-report Validity Check (analysis review)

Before §3 Findings is drafted, the underlying script needs a **research-validity audit** — not a style review. A report that documents an invalid pipeline is worse than no report. This step catches the failures that linters cannot: silent N drops, leakage between train and test, type coercion that produces NAs, mismatches between the stated design and what the code actually does.

### When to run

- Before first internal circulation of the report
- Before any submission (working paper, journal, replication package)
- After any non-trivial change to the data pipeline (new merge, new filter, new sample restriction)

### Severity levels

Every flagged issue must point to a specific `file:line` and carry one of three severities. Vague comments ("the cleaning could be cleaner") are not allowed.

| Severity | Meaning |
|---|---|
| **CRITICAL** | Changes the substantive result. Must be fixed before the report is circulated. |
| **WARNING** | Likely a mistake but does not change the headline result. Fix or justify in §N Limitations. |
| **NOTE** | Worth knowing; usually a documentation or hygiene item. |

### Mandatory checks

| Check | What to look for |
|---|---|
| **Silent N drops** | `drop_na()` / `na.omit()` / `dropna()` without an explicit `count_before == count_after` log |
| **Train/test leakage** | Feature engineering on the full dataset before the split |
| **Coerced types** | `as.numeric(x)` on character columns producing NAs without warning |
| **Filter logic** | `&` vs `&&`, `==` vs `<-` typos, off-by-one date filters |
| **Outlier rules** | Any `x > threshold` filter that depends on the **outcome** variable |
| **Replication seed** | `set.seed(...)` before any sampling / random split / bootstrap |
| **Cluster SE** | Standard errors clustered at the level the design implies |
| **Multiple comparisons** | If many tests are run, are corrections applied (or pre-registered as exploratory)? |
| **Path hard-coding** | Paths that only work on the author's machine |

### Cross-check against stated design

If a study description, design memo, or pre-registration exists, compare it line-by-line against the code:

- Sample inclusion criteria match?
- Outcome variable matches the pre-registered one?
- Covariates listed in the design are all in the model?
- The pre-registered analysis (e.g. DID with two-way fixed effects) is the one actually run?

Any mismatch → CRITICAL.

### Report-the-review format

```
# Analysis Review — <project>

**Files audited:** N  |  **CRITICAL:** A  |  **WARNING:** B  |  **NOTE:** C

## CRITICAL
- `analysis.R:184` — Train/test leakage: scaling fit on full data before split. Result: out-of-sample fit overstated.

## WARNING
- `data_clean.R:42` — 1,247 rows silently dropped at `drop_na(income)`. If income is MAR not MCAR, this biases the sample.

## NOTE
- `model.R:16` — `set.seed(42)` is set at file top but `bootstrap()` re-seeds each call; consider standardizing.

## Checks performed
[every check from the table with status: PASS / FAIL / SKIPPED-with-reason]
```

Never say "looks fine" without listing what was checked. **Absence of evidence is not evidence of absence** — if a check could not be performed (e.g. data is gitignored), say so explicitly rather than skip silently.

### Notes for extending

- **Language-specific checkers.** Add R-specific checks (factor level handling, `data.table` reference semantics) in `checks/r.md`; Python in `checks/py.md`. Loaded only when the relevant language appears.
- **Pre-registration parsing.** Auto-extract cross-check items from an OSF preregistration JSON so the design-vs-code comparison runs without manual transcription.
- **Subagent pattern (`context: fork`).** This is the canonical case for forking a subagent. Reading a full pipeline spans 10–30 files of code that is irrelevant to the conversation that called the skill — the verbose file-reading would otherwise blow the main context. The subagent reads the files, runs the checks, returns the compact report above; the main conversation never sees the raw code.

---

## Conventions

Write brief and to the point — remove word, sentence, or section that adds length without adding new information.

- **Scope** — state what is *not* covered: *"organic CTR only; paid and direct excluded."*
- **Abstract integrity** — every abstract claim maps to a section.
- **Technical terms** — do not remove a term solely because it is specialized. Keep it when it names a necessary empirical construct, but define it in the same sentence in ordinary language. Remove internal shorthand with no common use when it adds no precision. After one reading, a reader outside the field should be able to state what is counted, who is included, and why the distinction matters.
- **Scale consistency** — flag when effect sizes across analyses are on different scales (pp vs. log-odds vs. standardized).
- **Data provenance** — record when data was pulled and which script cleaned it; *"recent data"* is not recoverable.
- **Concrete over vague** — "N = 14,203; 47 duplicates removed" beats "the dataset was cleaned."
- **Pair estimates with uncertainty** — always SE or 95% CI alongside a point estimate. — *Gelman*
- **Practical significance** — report effect sizes; state whether the result clears a meaningful threshold.
- **Confirmatory vs. exploratory** — label post-hoc findings explicitly; the same data cannot generate and test a hypothesis.
- **Flag threats** — name the main concern.
- **List structure** — organize analysis as a bulleted or numbered list; avoid prose paragraphs where a list suffices. Use prose when a list would fragment the argument.
- **Highlight keywords** — write in normal phrases and sentences, but bold key terms, numbers, and conclusions: "**Video** posts average **8.3%** engagement vs. **2.2%** for text — a **3.8× gap**."
- **Arrow for logic** — use → to show reasoning chains: "high churn → low LTV → unprofitable segment."

---

## Benchmark Reference

Industry sources by measure type:

| Measure type                 | Sources                                                                               |
| ---------------------------- | ------------------------------------------------------------------------------------- |
| Web traffic, CTR, engagement | SimilarWeb, SEMrush, Comscore, Adobe Analytics Benchmarks                             |
| Search behavior              | Google Search Console industry benchmarks, SparkToro                                  |
| News / media consumption     | Reuters Institute Digital News Report, Pew Research Center, Nielsen                   |
| E-commerce, conversion       | Salesforce State of Commerce, Adobe Commerce Report, eMarketer / Insider Intelligence |
| Social media                 | Sprout Social Benchmarks, Hootsuite Digital Report, DataReportal                      |
| Email marketing              | Mailchimp Industry Benchmarks, HubSpot Marketing Report                               |
| App / mobile                 | App Annie (data.ai), Sensor Tower, Apptopia                                           |
| Advertising                  | IAB Internet Advertising Revenue Report, Statista, WARC                               |
| General aggregator           | Statista, Gartner, Forrester, McKinsey Global Institute                               |
