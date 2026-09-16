---
name: paper-writing
description: >-
  Draft or polish main-text sections of empirical economics, management, information systems, and marketing papers: abstracts, introductions, framing, contributions, results, mechanisms, discussions, and conclusions. Use for section drafting, argument revision, or a requested journal-voice pass. Supports AER, QJE, Econometrica, JPE, Management Science, and Marketing Science with venue-bounded, move-based abstracts that compress the substantive argument; contribution-first introductions; results organized around findings and decisive evidence; and conclusions that state what changes in interpretation or decision making. For titles alone use paper-titles; for appendices or supplementary materials use appendix.
allowed-tools: Read, Edit, Write
user-invocable: true
invocation: auto
---

# Paper Writing

Turning verified analysis into a paper's **main text**, then matching that prose to a target journal's voice. Two stages, loaded on demand:

- **Drafting and structure** → [`references/main-text.md`](references/main-text.md). Flexible abstract moves, contribution-first introductions, finding-led results, and specific, bounded conclusions. For abstracts and framing revisions, use the cross-cutting sequence **construct lock → evidence hierarchy → substantive compression**: keep central terms stable, select evidence by its argumentative role, and shorten prose without widening claims. Movement 6 checks substantive as well as stylistic AI tells; Movement 7 adds explicit claim provenance; Movement 8 separates within-paper terminology consistency from literature anchoring. **This is the default** — load it for any drafting request.

- **Journal house-voice pass** → [`references/academic-voice.md`](references/academic-voice.md). The final polish, emitted as a side-by-side diff with a justification per change. **Opt-in only** — run it when the user asks for a voice pass or adaptation of finished prose to a target journal, not on a vague "fix this paragraph." Treat the reference's profiles as starting points subordinate to official guidance and the author's exemplars. It never changes a claim, number, or citation; it changes voice, tense, register, and sentence structure.

Sequence: draft against `main-text.md` first (structure + content), then run the `academic-voice.md` pass last (voice for the target venue). The two rule sets are not redundant — the same sentence lands differently in *JM* vs. *MS* vs. *JCR*.

Match the requested deliverable: a short abstract edit does not require a full-paper audit or a terminology report. Keep intermediate maps internal unless a missing definition or evidence conflict needs the author's decision. Naming a target journal sets the audience and constraints; it does not by itself require a separate side-by-side voice report. Current venue requirements override illustrative templates; verify them from official author guidance when needed, and do not present a suggested length or style preference as a journal rule.

## TeX Build and Cleanup

- After every edit to a `.tex` file, immediately compile the affected document before making further writing edits or reporting completion.
- Use the document's documented build command. For context reports, run `pdflatex -interaction=nonstopmode -halt-on-error <file>.tex` twice from that report directory.
- If a TeX compiler is unavailable or the build fails, report the source/PDF mismatch explicitly and do not present the PDF as current.
- After a successful build, remove only that document's generated intermediates: `.aux`, `.bbl`, `.bcf`, `.blg`, `.fdb_latexmk`, `.fls`, `.lof`, `.log`, `.lot`, `.out`, `.run.xml`, `.synctex.gz`, and `.toc`. Keep the `.tex` source and final `.pdf`. Retain the affected `.log` only while diagnosing a failed build.

## How this fits the other skills

```
brainstorm → literature-review → eda → report.md artifacts
                                          ↓
                              paper-writing · main text   ← draft (structure + content)
                                          ↓
                              paper-writing · academic voice   ← polish for target journal
                                          ↓
                                     revision-plan   (if R&R arrives)
```

- [`report`](../report/SKILL.md) packages results into the artifacts this skill consumes; the artifact → section mapping is in `references/main-text.md`.
- [`literature-review`](../literature-review.md) Path A resolves `[CITE: handle]` placeholders into verified DOIs.
- [`appendix`](../appendix/SKILL.md) is the **separate** skill for the appendix / online appendix / supplementary materials — it derives required support from this main text and audits it against code and data. Drafting prose for an appendix still follows `references/main-text.md` register, but the appendix skill owns its structure and verification.
- [`revision-plan`](../revision-plan.md) handles the referee+editor letter when the R&R arrives — the inverse of this skill.
