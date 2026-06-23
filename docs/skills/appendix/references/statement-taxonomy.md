# Statement Taxonomy — decomposing an appendix into checkable claims

An appendix paragraph rarely makes one claim. A single sentence —

> *"Following Callaway and Sant'Anna (2021), we estimate group-time average treatment
> effects on the 4,213-firm panel, defining a firm as treated in the first year it
> reports any R&D expenditure; standard errors are clustered at the firm level."*

bundles a citation, a method, a sample count, a definition, and an inference choice.
Each needs a *different kind of evidence*, so the first move is always to **split the
prose into atomic statements**, tag each with exactly one type, then route each type to
where its support lives. This mirrors how `literature-review` splits a claim into
factual vs. argumentative before searching — here the split is finer because the
evidence is in the project directory, not only the literature.

The **same six types classify main-text claims too.** In SKILL.md Step 1 you decompose
the *main text* to derive the required-support set — there, the type tells you what kind
of appendix backing the claim demands (a definitional claim demands a definition/codebook
entry, a methodological claim demands an estimation detail + citation, a factual claim
demands a reconstructable number). Below, the same types classify *appendix* statements
and tell you where their evidence lives. One taxonomy, both ends of the chain.

## The six types

| Type | What it asserts | Where its evidence lives | Verdict hinges on |
|---|---|---|---|
| **Definitional** | the meaning/scope of a construct, variable, or sample boundary | codebook / data dictionary, variable-construction code, sample-filter code | prose definition == operationalization in code |
| **Factual-quantitative** | a specific number, count, range, share, or descriptive fact | the dataset itself, summary-stat output, the script that computes it | recomputed value == stated value (within rounding) |
| **Methodological** | an estimator, identification strategy, specification, or procedure | estimation code + a canonical method citation (`methodology-standards.md`) | code implements the named method; assumptions stated |
| **Citational** | attribution of a fact/claim to a source | Crossref via `verify-citations` | source exists and says what's claimed |
| **Result-robustness** | an empirical finding or its stability under a variation | the table/figure/log the script produces | the artifact actually shows the claimed pattern |
| **Procedural-reproducibility** | software, versions, seeds, run order, data access | environment files, README, scripts, lockfiles | the stated setup matches what's in the repo |

A sentence often decomposes into several rows. Tag at the level of the smallest thing
that could independently be true or false. "We winsorize at the 1% level and results are
unchanged" is two statements: a **procedural/definitional** one (winsorization at 1%,
checkable in code) and a **result-robustness** one (results unchanged, checkable in the
robustness table).

## Detecting each type (cue patterns)

These are heuristics, not a grammar — read for intent.

- **Definitional** — "we define / we classify / is defined as / refers to / a [unit] is
  considered [label] if …", variable-definition tables, "Variable" + "Description"
  columns.
- **Factual-quantitative** — any numeral that describes the data rather than a result:
  counts ("N = …", "the sample contains"), ranges ("spanning 2008–2019"), shares
  ("38% of observations"), moments ("mean / median / SD of …").
- **Methodological** — named estimators ("two-way fixed effects", "Callaway–Sant'Anna",
  "double ML", "BERT embeddings"), specification language ("we regress … on …", "we
  control for", "clustered / bootstrapped / weighted"), procedure descriptions
  ("we fine-tune", "we prompt the model with", "we match on propensity score").
- **Citational** — any "(Author, Year)" or "Author (Year)" attaching a claim to a paper.
- **Result-robustness** — "results are robust / unchanged / qualitatively similar /
  hold when", "Table A_ reports", "the coefficient remains significant", "Appendix
  Figure shows".
- **Procedural-reproducibility** — software names + versions, "seed", "we set the random
  seed", "code available at", "data obtained from", "run in the following order".

## Evidence and verdicts

Borrow the discipline of `verify-citations` and `analysis-cleanup`: **classify, don't
silently fix**, and **never change a number to make it match**. Three verdicts:

- **SUPPORTED** — concrete evidence in the directory (or, for citational/methodological,
  in the literature) confirms the statement. Record the evidence path/line or DOI.
- **UNSUPPORTED** — no evidence found. The claim may still be true; it is simply not
  anchored to anything in the project. Record what you looked for and where.
- **MISMATCH** — evidence exists and *contradicts* the statement (the recomputed N is
  4,198 not 4,213; the code clusters at the industry level, not the firm level; the
  cited paper says something else). Record exactly what the evidence says. Do **not**
  edit the appendix to the evidence value without flagging it — the discrepancy might
  mean the prose is stale *or* the wrong script was found, and only the author knows
  which.

### What counts as evidence, per type

- **Definitional** → the line of construction code (e.g. `treated = rd_exp > 0`) or the
  codebook row. SUPPORTED when prose and code describe the *same* rule; MISMATCH when the
  threshold, direction, or population differs.
- **Factual-quantitative** → re-derive when cheap. If a `.csv`/`.dta`/`.parquet` is
  present, load it and count/compute. If only an output log/table is present, read the
  number from there and note it's second-hand. A figure caption number with no
  reproducible source is UNSUPPORTED, not SUPPORTED.
- **Methodological** → two layers. (1) *Implementation*: does code that runs the named
  method exist (the right command/library/estimator)? (2) *Literature*: is the method
  cited to an appropriate, current standard? Use `methodology-standards.md`. A method
  correctly implemented but uncited is "SUPPORTED (implementation), gap (citation)".
- **Citational** → route to `verify-citations` (Crossref). VERIFIED/MISMATCH/FABRICATED
  map onto SUPPORTED/MISMATCH/UNSUPPORTED.
- **Result-robustness** → open the referenced artifact (table `.tex`, `.csv`, figure,
  log). SUPPORTED when it shows the claimed pattern (sign, significance, magnitude
  direction); MISMATCH when it doesn't; UNSUPPORTED when the artifact isn't found.
- **Procedural-reproducibility** → check the environment file / README / lockfile.
  "R 4.3, seed 42" is SUPPORTED only if a script actually sets that seed and the
  environment file names that version.

## Worked decomposition

Input sentence (from the top of this file) → atomic statements:

| # | Atomic statement | Type | Evidence to find |
|---|---|---|---|
| 1 | "Following Callaway and Sant'Anna (2021)" | citational | Crossref: DOI 10.1016/j.jeconom.2020.12.001 |
| 2 | estimator = Callaway–Sant'Anna group-time ATT | methodological | code calls `csdid`/`did` package; cite present (✓ via #1) |
| 3 | panel has 4,213 firms | factual-quantitative | `n_distinct(firm_id)` in the analysis data |
| 4 | treated ≡ first year with any R&D expenditure | definitional | construction code: `treat_year = min(year | rd>0)` |
| 5 | SE clustered at firm level | methodological | clustering option in the estimation call |

Five rows, five searches, five verdicts — attached back to the one sentence so the
author sees precisely which part (if any) failed.
