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
- In `own`, build the talk map in the exact order defined by `references/own-work.md`, with the headline magnitude stated consistently across preview, results, conclusion, and speaker notes.

Record figure and table provenance in the notes: source file or PDF page, caption, panel, and any conversion or crop. For external motivation evidence allowed in `own`, record the publisher, year, URL, and retrieval date.

## Shared evidence rules

- Preserve exact numbers, units, signs, uncertainty, sample definitions, and comparison groups.
- Pair each estimate with a standard error or confidence interval when the paper provides one.
- Reproduce substantive figures and tables from the paper or verified project outputs. Do not fabricate missing results or silently redraw them from an inferred pattern.
- Rebuild tables natively in the target format. Do not use screenshots of tables.
- Define nontrivial symbols next to every displayed equation; omit familiar specifications when the identifying assumption and diagnostic are more useful to the audience.
- State causal claims no more strongly than the design permits.
- Use one claim per slide and keep visual text large enough for projection.
- Attribute every external asset visibly on the slide.

## Verify before delivery

Apply the mode-specific checklist, then confirm:

1. Every planned block appears once and in the required order.
2. Every result number and visual traces to the paper or a verified project artifact.
3. Figures, tables, equations, notes, and source lines render without clipping or overlap.
4. The title, densest content slide, each distinct results layout, and conclusion have been visually inspected.
5. Temporary extraction, conversion, edit, and build artifacts have been removed; retain only source inputs needed for reproducibility and intended deliverables.

## Report completion

Use three labeled lines:

**Definition:** Paper metadata, selected mode, output paths, and number of slides.

**Analyses:** Blocks covered, evidence-sourcing method, notes artifact, and mode-specific validation completed.

**Takeaway:** Missing assets, unresolved identification assumptions, or other human decisions still required before presentation.
