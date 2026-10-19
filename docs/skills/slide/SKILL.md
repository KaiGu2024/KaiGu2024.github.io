---
name: slide
title: Slide Generation
permalink: /skills/slide/
description: Generate academic slide decks from a paper PDF or TeX source. Use `report` mode (default) for someone else's work in Reveal.js HTML, or `own` mode for the user's job talk, conference, or seminar presentation in LaTeX Beamer with compiled PDF and natural speaker notes on every slide. Extract a PDF with MinerU only when TeX source is unavailable.
---

# Academic slide decks

Generate slides only when explicitly requested. Select `report` when the user does not name a mode.

## Route by mode

| Mode | Use for | Primary deliverable | Required references |
|---|---|---|---|
| `report` (default) | Reading someone else's paper: reading group, class, or discussant presentation | `slide/<slug>.html` | Read `references/reading-other-papers.md`, `references/aesthetics.md`, and `references/speaker-notes.md`. Read `references/pdf-export.md` only when the user explicitly requests PDF. |
| `own` | Presenting the user's own paper: job talk, conference, or seminar | `slide/<slug>.tex` and compiled `slide/<slug>.pdf` | Read `references/own-work.md` and `../paper-writing/references/main-text.md`. |

Follow the selected mode reference as authoritative. Do not combine skeletons, notes conventions, asset handling, or output formats across modes unless the user explicitly requests a hybrid.

In both modes, read `references/talk-delivery.md` before drafting notes. It covers paragraph breaks as pauses, bold keywords as vocal emphasis, natural oral phrasing, opening hooks, spoken explanations, objections, closing, and pacing; the mode reference determines whether to write full prose or brief cues. Make these delivery cues visible in the rendered notes, not just in their source.

## Acquire the paper

Prefer source in this order:

1. **TeX available:** read the `.tex` files directly and resolve included files, bibliography, equations, table source, and figure paths.
2. **PDF only:** extract it with MinerU before designing slides:

   ```bash
   magic-pdf -p <paper.pdf> -o paper/<slug> -m auto
   ```

   Read the extracted markdown completely. Use the content-list JSON for structured table rows and figure/equation metadata, and the extraction's images directory for raster assets.
3. **Extraction failure:** preserve a visible placeholder and tell the user which asset or passage is missing. Never reconstruct evidence from memory.

When only an arXiv identifier is provided, retrieve the paper PDF first. When the user supplies neither paper nor stable identifier, ask for the source rather than guessing which paper they mean.

## Build the content map

Before generating the deck, write `notes/<slug>.md` from the full source.

- In `report`, record the one-line contribution, research question, data, identification strategy, main results with uncertainty, mechanisms, limitations, and discussion questions.
- In `own`, build the talk map in the exact order defined by `references/own-work.md`: place one Literature Positioning slide after Motivation, then Research Question + Preview of Findings on one combined slide or two consecutive slides, depending on the length and complexity of the findings. State the headline magnitude consistently across preview, results, conclusion, and speaker notes.
  Start the title-slide notes with a greeting, thanks, the presenter's name and affiliation, the project title, and coauthors. Begin the substantive hook and project explanation on Motivation.

Record figure and table provenance in the notes: source file or PDF page, caption, panel, and any conversion or crop. For external motivation evidence allowed in `own`, record the publisher, year, URL, and retrieval date.

For each substantive slide, connect its one claim to the evidence the audience needs to understand it. When choosing a layout example, match the communicative task—explaining identification, comparing estimates, showing a mechanism, or locating a contribution—and the amount of content. Preserve the selected mode's brand. The [figure planning and revision guide](../visualization/guidance/figure-review.md) applies when creating or redesigning a visual; the content map serves as the brief, so no separate planning document is required.

## Shared evidence rules

- Preserve exact numbers, units, signs, uncertainty, sample definitions, and comparison groups.
- Pair each estimate with a standard error or confidence interval when the paper provides one.
- Reproduce substantive figures and tables from the paper or verified project outputs. Do not fabricate missing results or silently redraw them from an inferred pattern.
- Rebuild tables natively in the target format. Do not use screenshots of tables.
- Define nontrivial symbols next to every displayed equation; omit familiar specifications when the identifying assumption and diagnostic are more useful to the audience.
- State causal claims no more strongly than the design permits.
- Use one claim per slide and keep visual text large enough for projection.
- Put a small section label above each content-slide title to orient the audience. Repeat the section's short name and, when numbered in the talk map, its number across all slides in that section. Omit it on the opening title slide; use an explicit Backup label for appendix slides. Keep it visually subordinate to the title and avoid repeating the section name in the title itself. Follow the selected mode's implementation.
- Attribute every external asset visibly on the slide.

## Deliverables and inspection previews

Keep the mode's default deliverables: HTML for `report`, TeX source and compiled PDF for `own`. Generate additional deck formats or a separate notes PDF only when requested. Do not export a companion PNG deck by default.

Save browser screenshots, rasterized PDF pages, and inspection contact sheets under project-root `exploratory/previews/slides/<slug>/`, creating the directory only when needed. Add `/exploratory/previews/` to the project's `.gitignore`. These disposable previews may remain for review, but must stay outside `slide/` and any delivery folder. Keep exploratory analysis scripts and useful working figures elsewhere.

Images embedded in the HTML or referenced by Beamer are deck assets, not inspection previews. Preserve the selected mode's asset rules; do not move required source assets into the disposable preview directory.

## Verify before delivery

Apply the mode-specific checklist, then confirm:

1. Every planned block appears once and in the required order.
2. Every result number and visual traces to the paper or a verified project artifact. After simplifying or restyling, confirm that the claim still has its supporting comparison, units, sample, uncertainty, and material qualification. A crop must not remove the reference category or interval needed to interpret a result. Move supporting explanation into visible labels or speaker notes as appropriate; keep essential visual reading keys on the slide.
3. Figures, tables, equations, notes, and source lines render without clipping or overlap. Section labels match the talk map, sit above content titles consistently, and leave enough room for the slide body.
4. The title, densest content slide, each distinct results layout, and conclusion have been visually inspected.
   Inspect representative rendered notes too: paragraph gaps must be visible, bold stress words easy to find, and text readable without clipping. Apply the [adjacent-slide continuity review](references/talk-delivery.md#continuity-between-slides), checking each ending and following opening together before reading the notes continuously. Read the narration aloud when rehearsing, honoring the pauses and emphasis; distinguish a text review from an actual timed rehearsal.
5. Temporary extraction, conversion, edit, and build artifacts have been removed from the delivery folder; retain source inputs needed for reproducibility and intended deliverables. Any retained inspection previews are confined to the ignored `exploratory/previews/slides/<slug>/` directory.

Use the shared [targeted repair procedure](../visualization/guidance/figure-review.md#repair-a-specific-defect) for visual revisions, applying this slide checklist to affected slides.

## Report completion

Use three labeled lines:

**Definition:** Paper metadata, selected mode, output paths, and number of slides.

**Analyses:** Blocks covered, evidence-sourcing method, notes artifact, and mode-specific validation completed.

**Takeaway:** Missing assets, unresolved identification assumptions, or other human decisions still required before presentation.
