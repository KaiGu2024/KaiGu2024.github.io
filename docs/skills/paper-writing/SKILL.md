---
name: paper-writing
description: >-
  Use when drafting or polishing any main-text section of an empirical economics / marketing paper — abstract, introduction, framing, contribution paragraph, results, mechanism, discussion, conclusion — or when adapting finished prose to a target journal's house voice. Triggers on "draft this section", "rewrite my intro", "help me with this paper", "what should I say about X in §3", "summarize this for an abstract", explicit section names, and "match this to JM/MS/JCR voice". Top-journal template (AER, QJE, Econometrica, JPE, Marketing Science): five-sentence abstracts, contribution-first introductions, results that lead with the number. Consumes artifacts from report.md; the inverse of revision-plan.md. For the appendix / online appendix / supplementary materials, use the separate appendix skill.
allowed-tools: Read, Edit, Write
user-invocable: true
invocation: auto
---

# Paper Writing

Turning verified analysis into a paper's **main text**, then matching that prose to a target journal's voice. Two stages, loaded on demand:

- **Drafting and structure** → [`references/main-text.md`](references/main-text.md). The Cochrane/McCloskey template for top empirical-econ journals: five-sentence abstract, contribution-first introduction, results that lead with the number, short honest conclusion, the cross-cutting prose rules, the "writing with an LLM without sounding like one" discipline (the AI tells + accountability test), Movement 7's strict-traceability mode for sections (especially Methods) where claim provenance matters more than narrative flow, and Movement 8's terminology-anchoring pass that extracts the draft's construct/method terms and round-trips them through `literature-review` to anchor each to its settled term (or flag a deliberate coinage). **This is the default** — load it for any drafting request.

- **Journal house-voice pass** → [`references/academic-voice.md`](references/academic-voice.md). The final polish: third-person past tense for *JM*, equation-heavy formality for *MS*, narrative first person for *JCR*, and so on, emitted as a side-by-side diff with a justification per change. **Opt-in only** — run it when the user explicitly asks for a voice pass or names a target journal, not on a vague "fix this paragraph." It never changes a claim, number, or citation; it changes voice, tense, register, and sentence structure.

Sequence: draft against `main-text.md` first (structure + content), then run the `academic-voice.md` pass last (voice for the target venue). The two rule sets are not redundant — the same sentence lands differently in *JM* vs. *MS* vs. *JCR*.

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

- [`report`](../report.md) packages results into the artifacts this skill consumes; the artifact → section mapping is in `references/main-text.md`.
- [`literature-review`](../literature-review.md) Path A resolves `[CITE: handle]` placeholders into verified DOIs.
- [`appendix`](../appendix/SKILL.md) is the **separate** skill for the appendix / online appendix / supplementary materials — it derives required support from this main text and audits it against code and data. Drafting prose for an appendix still follows `references/main-text.md` register, but the appendix skill owns its structure and verification.
- [`revision-plan`](../revision-plan.md) handles the referee+editor letter when the R&R arrives — the inverse of this skill.
