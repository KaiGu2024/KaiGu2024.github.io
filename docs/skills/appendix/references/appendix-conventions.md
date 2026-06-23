# Appendix Conventions — what belongs there, by field

The appendix (or *online appendix* / *supplementary materials*) is where everything that
supports the paper but would break the main-text narrative goes. The audit and the
authoring both improve when you know what a given field's reviewers *expect* to find
there — a missing expected section is itself a finding.

## The division-of-labor rule

Main text carries the argument and the headline results a reader needs to follow it.
The appendix carries **everything a skeptic would demand before believing the main
text**: full definitions, construction details, every robustness check, secondary
specifications, and the machinery of reproducibility. A good test for "appendix vs.
main": *if removing it would not change a reader's understanding of the contribution but
would change a referee's confidence in it, it belongs in the appendix.*

## Sections reviewers expect, by layer

### Economics (AER / QJE / REStud / Econometrica / AEJ)
- **Data appendix** — source, access, sample construction, every filter with the
  resulting N at each step (the "sample-selection waterfall"), variable definitions.
- **Additional results / robustness** — alternative specifications, subsamples,
  alternative SE/clustering, placebo and pre-trend tests, sensitivity à la
  Rambachan–Roth for DiD.
- **Proofs / derivations** — for any theoretical claim.
- **Identification details** — for IV: first stage, relevance, exclusion discussion;
  for RDD: bandwidth, McCrary; for DiD: estimator choice under staggered timing.

### Marketing / IS (Marketing Science / JMR / JM / MISQ / ISR / JCR)
- **Measurement appendix** — scale items, reliability/validity (α, AVE, discriminant
  validity), manipulation checks, full survey wording.
- **Study/stimuli materials** — experimental instructions, screenshots, vignettes.
- **Text/ML method appendix** — corpus construction, preprocessing, model/prompt
  details, and **validation of any automated measure against human coding** (agreement
  metrics). This is the most-scrutinized appendix in text-as-data marketing work.
- **Additional studies / robustness** — replications, alternative DVs, mediation/
  moderation supplements.

### Computer science / ML / NLP (NeurIPS / ICML / ICLR / ACL / EMNLP)
- **Reproducibility checklist** — the venue's own (NeurIPS/ACL checklists); hyper-
  parameters, compute, dataset splits, licenses.
- **Implementation details** — architecture, training regime, prompts (verbatim),
  decoding parameters, seeds, hardware.
- **Additional experiments / ablations** — the ablation table is effectively mandatory.
- **Dataset documentation** — datasheet/data statement, collection, annotation protocol,
  inter-annotator agreement.
- **Limitations & broader impact** — increasingly required as a named section.

### General-interest / multidisciplinary (PNAS / Nature / Science families)
- **Materials & Methods / Supplementary Methods** — full protocol, enough to reproduce.
- **Supplementary analyses / figures / tables** — robustness and secondary results.
- **Data & code availability statement** — repository, DOI, access conditions.
- **Reporting standards** — relevant checklist (e.g. reproducibility, preregistration
  status); see Munafò et al. (2017) for the norms these encode.

## Cross-cutting structure (default appendix skeleton)

```
A  Data
   A.1 Sources and access
   A.2 Sample construction (selection waterfall, N at each step)
   A.3 Variable definitions  ← table; every main-text variable
B  Methods
   B.1 Estimation / specification details (+ canonical citations)
   B.2 Identifying assumptions and the checks that address them
C  Additional results / Robustness
   C.1 Alternative specifications
   C.2 Subsamples / placebos / sensitivity
D  Reproducibility
   D.1 Software, versions, seeds
   D.2 Code & data availability, run order
```

Adapt section letters to the venue, but every empirical appendix should let a reader
answer: *what is the data, how exactly was each number made, why is the identification
believable, and how do I reproduce it.*

## Anchor-as-you-write

The appendix is the one place where every sentence *should* be traceable to an artifact.
Write it so the audit passes by construction: as you draft each statement, note the
evidence anchor (file:line, table, or DOI) in a comment or a parallel column, then
delete the scaffolding once verified. An appendix written this way is far cheaper to
audit later — for the author, for a referee, and for a replicator.

## Style

The appendix is reference material, read non-linearly and out of order. Favor:
- **Tables over prose** for definitions, parameters, and sample steps.
- **Self-contained captions** — each table/figure readable without the surrounding text.
- **Explicit cross-references** to the main-text equation/table each section supports.
- **Precision over polish** — exact thresholds, units, and versions beat smooth prose.
For prose passages, the `paper-writing` skill's register applies; for tables, see `tables`;
for figures, `visualization`.
