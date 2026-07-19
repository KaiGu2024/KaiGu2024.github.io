# Own-work mode — presenting your own paper

Use this as the single authoritative reference for an `own` deck. It governs both the talk's narrative and its Beamer/PDF production. Also read [`paper-writing/references/main-text.md`](../../paper-writing/references/main-text.md) before writing speaker notes; its contribution-first, number-first, evidence-calibrated prose rules govern the spoken script.

## Contents

- [Hard rules](#hard-rules)
- [Required narrative spine](#required-narrative-spine)
- [Motivation assets](#motivation-assets)
- [Spoken notes](#spoken-notes)
- [Notes by block](#notes-by-block)
- [Files and assets](#files-and-assets)
- [Beamer document](#beamer-document)
- [Frames and notes](#frames-and-notes)
- [Compilation](#compilation)
- [Verification](#verification)

## Hard rules

- Produce `slide/<slug>.tex` and compile `slide/<slug>.pdf`. Beamer/PDF is the default and primary format, even when the input is a PDF rather than TeX.
- Follow this narrative spine in order: **Opening → Motivation → Research Question → Preview of Findings → Context → Data & Research Design → Results → Conclusion**.
- Give **Research Question** and **Preview of Findings** one separate slide each. Never merge them.
- Do not add Author Bios or Outline slides unless the user explicitly asks for them.
- Put a substantive `\note{...}` in every frame. There are no own-mode skip exceptions.
- Present as the author making and defending a claim, not as a discussant appraising someone else's work.

## Required narrative spine

The number of slides inside a block may vary, but do not reorder or silently omit blocks.

| Block | Typical length | Job |
|---|---:|---|
| **Opening** | 1 slide | Use the title frame to begin the argument in spoken notes: one concrete tension, then the paper's promise. Do not read the title or give an agenda. |
| **Motivation** | 1–3 slides | Establish that the phenomenon is real and consequential. Move from a concrete instance to scale or stakes. One idea and one dominant visual per slide. |
| **Research Question** | exactly 1 slide | State the precise question, the unresolved tension, and—only if needed—the estimand or construct. Do not reveal the answer here. |
| **Preview of Findings** | exactly 1 slide | Give the answer plainly. Lead with the headline magnitude and uncertainty, then at most two supporting findings or mechanisms. This must be distinct from the question slide. |
| **Context** | 1–3 slides | Explain only the institutional, market, or theoretical details needed to understand the design and interpret the effect. End with the variation or comparison that makes the study possible. |
| **Data & Research Design** | 1–3 slides | Name the data, sample, period, unit, outcome, treatment, identification logic, key assumption, and most relevant diagnostic. Integrate identification here rather than inserting a new top-level block. |
| **Results** | 3–7 slides | Lead with the main estimate, then mechanism or heterogeneity, then the decisive robustness or scope result. One finding per slide; show the number, uncertainty, benchmark, and interpretation. |
| **Conclusion** | 1 slide | Restate the same headline magnitude, state two or three contributions, name the dominant scope condition honestly, and end on the implication rather than an open-question list. |

Use section-divider frames sparingly. If one is necessary for a long talk, it belongs inside the corresponding block and still requires a note. Do not use a divider to create an extra Outline section.

## Motivation assets

External assets are allowed only in Motivation. Results, identification, and mechanism visuals must come from the paper or verified project outputs.

1. Find a reputable primary or citable source: official statistics, a research organization, a peer-reviewed paper, or the original publisher of a documented example.
2. Record the source name, year, page URL, and retrieval date in `notes/<slug>.md`.
3. Save the local asset under `slide/assets/<slug>/`; use a stable descriptive filename.
4. Add a visible source line on the frame, such as `\source{Source: Eurostat (2025).}`. Do not rely on speaker notes for attribution.

Prefer one clean chart, headline, document, or photograph over a montage. If no defensible visual exists, use a sourced statistic in large type. Never fabricate a number or use decorative stock imagery as evidence.

## Spoken notes

Write notes as language the author could actually say aloud. Use complete sentences and short paragraphs, usually 60–120 words or roughly 30–60 seconds per frame. The title note may be shorter. Do not use labels such as “Hook,” “Claim,” “Caveat,” or “Transition,” and do not write telegraphic fragments.

Each note should do three things smoothly:

1. Connect to what the audience has just heard, except on the opening frame.
2. Add the interpretation, emphasis, or defense that is not already visible on the slide.
3. End with a natural sentence that makes the next idea feel necessary.

Follow the paper-writing discipline:

- Use active voice and first-person plural where natural: “We estimate,” “We compare,” “We cannot rule out.”
- Give concrete numbers with units, a benchmark, and uncertainty. Repeat the headline magnitude verbatim in the findings preview, main result, and conclusion.
- Calibrate verbs to evidence. Prefer “shows,” “suggests,” or “is consistent with” over “proves” or “establishes” unless the design warrants the stronger claim.
- Let one sentence do one job. Remove throat-clearing, generic importance claims, canned contrasts, and decorative em dashes.
- Anticipate the most credible objection and answer it with the relevant diagnostic, robustness result, or scope condition. Do not sound defensive.
- Do not narrate every object on the slide. Say what the audience should notice and why it changes the argument.

Write natural transitions, not mechanical signposts. “That pattern gives us the comparison we need” is smoother than “On the next slide, I discuss identification.” Vary the transition so the notes read as one talk rather than isolated mini-scripts.

## Notes by block

| Block | Spoken emphasis |
|---|---|
| **Opening** | Begin with the concrete tension or phenomenon, make its stakes specific, and arrive at what the paper will explain. |
| **Motivation** | Explain why the example is representative and why its consequence matters. State the source naturally when using external evidence. |
| **Research Question** | Narrow the broad phenomenon to one answerable question. Define unfamiliar terms in plain language and hold back the result. |
| **Preview of Findings** | State the answer without teasing. Read the headline number once, interpret its size, and preview how the rest of the talk supports it. |
| **Context** | Explain only the rule, institution, or mechanism needed for the audience to understand the comparison. |
| **Data & Research Design** | Make the unit and variation intuitive. State the identifying assumption in plain language, then explain which diagnostic addresses the most plausible violation. |
| **Results** | Say the headline number, direct attention to the relevant visual region, interpret the magnitude, and handle one serious objection or scope condition. |
| **Conclusion** | Repeat the headline magnitude verbatim, distinguish finding from implication, own the main limit, and finish on the broader idea the evidence supports. |

## Files and assets

Create:

```text
slide/
├── <slug>.tex
├── <slug>.pdf
└── assets/
    └── <slug>/
        ├── main-result.pdf
        └── motivation-stat.png
```

Keep paper-native vector figures as PDF when possible. Use PNG or JPEG for raster sources. Convert SVG/EPS only when the active TeX engine cannot include it. Rebuild compact tables in native LaTeX with `booktabs`; do not paste screenshots of tables. Do not copy assets that are never used.

Reference assets as `assets/<slug>/<filename>` and compile with `latexmk -cd`, so paths resolve from the `slide/` directory.

## Beamer document

Start from this minimal system and adapt content, not the delivery format. Keep the design restrained: white background, navy text, blue accent, generous whitespace, and projection-size type. Do not reproduce the Reveal.js CSS or depend on web fonts.

```tex
\documentclass[aspectratio=169,11pt]{beamer}

\usepackage[T1]{fontenc}
\usepackage{lmodern}
\usepackage{amsmath,mathtools}
\usepackage{booktabs,tabularx}
\usepackage{graphicx}
\usepackage{xcolor}
\usepackage{pgfpages}

\definecolor{DeckNavy}{HTML}{17324D}
\definecolor{DeckBlue}{HTML}{2563EB}
\definecolor{DeckMuted}{HTML}{64748B}
\definecolor{DeckPale}{HTML}{EFF6FF}

\setbeamercolor{normal text}{fg=DeckNavy,bg=white}
\setbeamercolor{frametitle}{fg=DeckNavy,bg=white}
\setbeamercolor{structure}{fg=DeckBlue}
\setbeamercolor{alerted text}{fg=DeckBlue}
\setbeamerfont{frametitle}{series=\bfseries,size=\Large}
\setbeamertemplate{navigation symbols}{}
\setbeamertemplate{itemize item}{\color{DeckBlue}\small$\blacksquare$}
\setbeamertemplate{footline}{%
  \hfill\usebeamerfont{page number in head/foot}%
  \color{DeckMuted}\insertframenumber\hspace{0.8em}\vspace{0.5em}}

\newcommand{\source}[1]{%
  \vfill{\tiny\color{DeckMuted}\raggedright #1\par}}

% Main PDF hides notes. Define \shownotes at compile time to create a notes PDF.
\ifdefined\shownotes
  \setbeameroption{show notes on second screen=right}
\else
  \setbeameroption{hide notes}
\fi

\title{<Paper title>}
\author{<Authors>}
\institute{<Affiliations>}
\date{<Venue or status, date>}

\begin{document}

\begin{frame}[plain]
  \titlepage
  \note{<Natural opening in complete spoken sentences.>}
\end{frame}

% Follow the exact narrative spine above.

\end{document}
```

Use one claim per frame. Keep frame titles short and informative. Prefer a full-width figure or a simple two-column composition. Avoid tiny multi-panel plots, ornamental card grids, automatic section-divider frames, and overlays that turn one logical slide into several PDF pages. Put useful backup frames after `\appendix` and write notes for them too.

Put a plain-language symbol gloss below every displayed equation. Keep only the equation required for the argument. For canonical designs, explain the identifying assumption and diagnostic rather than spending a full frame on a familiar regression equation.

## Frames and notes

Write every slide as an explicit `frame` environment and put exactly one substantive `\note{...}` inside it. This includes the title frame, any section divider, conclusion, acknowledgments, and appendix frames. Do not use automatic frame generators because they can create slides without notes.

```tex
\begin{frame}{Preview of findings}
  \begin{block}{Main result}
    Treatment raises purchases by \alert{3.2 percentage points}
    (95\% CI: 2.1 to 4.3), a 27\% increase over baseline.
  \end{block}
  \begin{itemize}
    \item The effect is concentrated among first-time buyers.
    \item Placebo outcomes remain flat.
  \end{itemize}
  \note{We find a 3.2 percentage-point increase in purchases, with a 95 percent
  confidence interval from 2.1 to 4.3 points. Relative to the 12-point baseline,
  that is about a 27 percent increase. The concentration among first-time buyers
  is useful because it points to acquisition rather than heavier purchasing by
  existing customers. I will first explain the setting that generates our
  comparison and then show the estimates behind this preview.}
\end{frame}
```

The note is spoken prose, not a second slide. Apply the style and block-specific guidance above. Escape TeX-sensitive characters and keep citations or source details concise enough to say naturally. Do not put unsourced numbers in either the frame or its note.

## Compilation

Compile the main deliverable from the repository root:

```bash
latexmk -cd -pdf -interaction=nonstopmode -halt-on-error slide/<slug>.tex
```

The main PDF must compile successfully before delivery. If the user also wants printable or presenter notes, compile a second PDF from inside `slide/` so `\shownotes` activates `pgfpages`:

```bash
pdflatex -interaction=nonstopmode -halt-on-error -jobname=<slug>-notes "\def\shownotes{1}\input{<slug>.tex}"
pdflatex -interaction=nonstopmode -halt-on-error -jobname=<slug>-notes "\def\shownotes{1}\input{<slug>.tex}"
```

Do not replace a failed local compile with an unverified `.tex` handoff. Report a genuinely missing TeX dependency or asset explicitly.

## Verification

1. Count frames and notes; the counts must match. In PowerShell:

   ```powershell
   (rg -o '\\begin\{frame\}' slide/<slug>.tex | Measure-Object).Count
   (rg -o '\\note\{' slide/<slug>.tex | Measure-Object).Count
   ```

2. Search the log for `Overfull` boxes, missing files, undefined control sequences, and unresolved references. Fix them rather than shrinking an entire deck.
3. Confirm the PDF page count matches the intended slide count. Overlays can silently create extra pages.
4. Render representative pages—including the densest data slide, every distinct results layout, and the conclusion—to images and inspect them. Check clipping, minimum type size, source visibility, table legibility, and figure labels.
5. Read the notes from beginning to end without looking at the slides. They should sound like one coherent talk. Revise abrupt openings, repeated transitions, unexplained terms, unsupported numbers, and paragraphs that merely recite visible bullets.
6. Verify that the same headline magnitude appears verbatim in the preview, main result, conclusion, and corresponding notes.
