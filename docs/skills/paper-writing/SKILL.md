---
name: paper-writing
description: >-
  Draft or polish main-text sections of empirical economics, management, information systems, and marketing papers: abstracts, introductions, conceptual frameworks, data and methods, results, discussions, and conclusions. Use for section drafting, argument revision, or a requested journal-voice pass. Supports AER, QJE, Econometrica, JPE, Management Science, and Marketing Science with venue-bounded, move-based abstracts that compress the substantive argument; contribution-oriented introductions with flexible conceptual openings; results organized around findings and decisive evidence; and conclusions that state what changes in interpretation or decision making. For titles alone use paper-titles; for appendices or supplementary materials use appendix.
allowed-tools: Read, Edit, Write
user-invocable: true
invocation: auto
---

# Paper Writing

Turn grounded research into a paper's main text. Read these two shared guides when using the skill:

- [Main text](references/main-text.md): argument development, construct consistency, substantive compression, and a map to six section guides. It links optional checks for source or terminology problems.
- [Academic voice](references/academic-voice.md): precise words, sentence emphasis and variety, paragraph development, pacing, and evidence-preserving revision.

Then load only the section guidance needed for the task:

| Requested section | Guidance |
|---|---|
| Abstract | [Abstract](references/sections/abstract.md) |
| Introduction or contribution framing | [Introduction](references/sections/introduction.md) |
| Conceptual framework or theoretical development | [Conceptual Framework](references/sections/conceptual-framework.md) |
| Setting, data, measurement, design, or estimation | [Data and Methods](references/sections/data-and-methods.md) |
| Findings, mechanisms, or heterogeneity | [Results](references/sections/results.md) |
| Discussion or conclusion | [Discussion](references/sections/discussion.md) |

Background records under `references/evidence/` and `audits/` document sources and completed comparisons. Consult them for provenance or exemplar comparisons; the current guides govern drafting. [Main-text](references/main-text.md#supporting-evidence) maps these records.

The conceptual-framework section grounds constructs and their relationships in literature. The separate conceptual-framework skill makes a figure from a supplied paper.

For a requested journal-voice adaptation, follow the optional pass in academic-voice. Naming a venue during drafting sets the audience and submission constraints.

Return the requested draft, revision, outline, or critique. Keep working notes internal and raise unresolved choices when they affect the result. Check official venue guidance when a submission requirement matters.

## TeX Build and Cleanup

- After every edit to a `.tex` file, immediately compile the affected document before making further writing edits or reporting completion.
- Use the document's documented build command. For context reports, run `pdflatex -interaction=nonstopmode -halt-on-error <file>.tex` twice from that report directory.
- If a TeX compiler is unavailable or the build fails, report the source/PDF mismatch explicitly and do not present the PDF as current.
- After a successful build, remove only that document's generated intermediates: `.aux`, `.bbl`, `.bcf`, `.blg`, `.fdb_latexmk`, `.fls`, `.lof`, `.log`, `.lot`, `.out`, `.run.xml`, `.synctex.gz`, and `.toc`. Keep the `.tex` source and final `.pdf`. Retain the affected `.log` only while diagnosing a failed build.

## How this fits the other skills

- [`report`](../report/SKILL.md) can supply organized findings and supporting evidence for drafting.
- [`literature-review`](../literature-review.md) Path A resolves `[CITE: handle]` placeholders into verified DOIs.
- [`appendix`](../appendix/SKILL.md) is the **separate** skill for the appendix / online appendix / supplementary materials — it derives required support from this main text and audits it against code and data. Drafting prose for an appendix still follows `references/main-text.md` register, but the appendix skill owns its structure and verification.
- [`revision-plan`](../revision-plan.md) handles the referee+editor letter when the R&R arrives — the inverse of this skill.
