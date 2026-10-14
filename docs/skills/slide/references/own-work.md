# Own-work mode — presenting your own paper

Use this as the single authoritative reference for an `own` deck. It governs both the talk's narrative and its Beamer/PDF production. Also read paper-writing's [shared drafting guidance](../../paper-writing/references/main-text.md) and [academic voice](../../paper-writing/references/academic-voice.md) before writing speaker notes; adapt their argument and prose principles to a spoken presentation.

## Contents

- [Hard rules](#hard-rules)
- [Required narrative spine](#required-narrative-spine)
- [Literature positioning](#literature-positioning)
- [Research question and findings preview](#research-question-and-findings-preview)
- [Motivation assets](#motivation-assets)
- [Spoken notes](#spoken-notes)
- [Title-slide opening](#title-slide-opening)
- [Notes by block](#notes-by-block)
- [Files and assets](#files-and-assets)
- [Beamer document](#beamer-document)
- [Title-slide typography](#title-slide-typography)
- [Frames and notes](#frames-and-notes)
- [Compilation](#compilation)
- [Verification](#verification)

## Hard rules

- Produce `slide/<slug>.tex` and compile `slide/<slug>.pdf`. Beamer/PDF is the default and primary format, even when the input is a PDF rather than TeX.
- Follow this narrative spine in order: **Opening → Motivation → Literature Positioning → Research Question + Preview of Findings → Context → Data & Research Design → Results → Conclusion**.
- Give **Literature Positioning** exactly one slide, immediately before **Research Question + Preview of Findings**. Combine the question and preview on one slide when they fit comfortably; use two consecutive slides, question first, when the findings need more space or explanation.
- Do not add Author Bios or Outline slides unless the user explicitly asks for them.
- Put a substantive `\note{...}` in every frame. There are no own-mode skip exceptions.
- Present as the author making and defending a claim, not as a discussant appraising someone else's work.

## Required narrative spine

The number of slides inside a block may vary, but do not reorder or silently omit blocks.

| Block | Typical length | Job |
|---|---:|---|
| **Opening** | 1 slide | Greet and thank the audience, introduce the presenter and affiliation, say the project title, and credit coauthors. Save the substantive hook and explanation for Motivation. |
| **Motivation** | 1–3 slides | Establish that the phenomenon is real and consequential. Move from a concrete instance to scale or stakes. One idea and one dominant visual per slide. |
| **Literature Positioning** | exactly 1 slide | Connect the closest research streams to what is known, what remains unresolved, and the paper's specific contribution. End with the unresolved issue that motivates the question. |
| **Research Question + Preview of Findings** | 1–2 slides | Combine a concise question and answer on one slide, or put the question first and the findings preview on the next slide when findings are longer or more complex. Lead with the headline magnitude and uncertainty, then at most two supporting findings or mechanisms. |
| **Context** | 1–3 slides | Explain only the institutional, market, or theoretical details needed to understand the design and interpret the effect. End with the variation or comparison that makes the study possible. |
| **Data & Research Design** | 1–3 slides | Name the data, sample, period, unit, outcome, treatment, identification logic, key assumption, and most relevant diagnostic. Integrate identification here rather than inserting a new top-level block. |
| **Results** | 3–7 slides | Lead with the main estimate, then mechanism or heterogeneity, then the decisive robustness or scope result. One finding per slide; show the number, uncertainty, benchmark, and interpretation. |
| **Conclusion** | 1 slide | Show the opening question, the answer with the same headline magnitude, and the implication. Explain the contribution and dominant scope condition in the spoken notes; end on the implication rather than an open-question list. |

Use section-divider frames sparingly. If one is necessary for a long talk, it belongs inside the corresponding block and still requires a note. Do not use a divider to create an extra Outline section.

## Literature positioning

Place this slide after Motivation so the audience first understands why the phenomenon matters. Then establish how the paper changes an existing research conversation, before showing its question and answer. Give the slide a substantive title that names the unresolved issue or contribution.

Use two or three compact rows for the closest research streams or debates; use one if only one is relevant. Each row should connect:

| Research stream | What existing work establishes | What this paper adds |
|---|---|---|
| Short substantive label; one or two representative author–year citations | One specific finding, assumption, or scope boundary | The specific extension, qualification, mechanism, measurement, or evidence supplied here |

Keep each cell to a short phrase or sentence. A simple aligned list can replace the table when it reads better. Finish with one concise sentence naming the unresolved relationship or tension that leads directly to the next slide's question. Reserve numerical findings for the findings preview, whether combined with the question or on the following slide.

Choose streams by their relevance to the contribution, not by the number of papers available. Explain what readers learn beyond existing work; a new country, dataset, or method needs a substantive payoff. Avoid a chronological bibliography, lists of author names without claims, broad “little is known” statements, and unsupported claims to be first.

Ground every characterization of prior work and every novelty claim in the manuscript and its cited sources. Use verified author–year citations beside the relevant claim and record source locators in `notes/<slug>.md`. Consult the original work when the manuscript does not support a precise comparison; flag unresolved positioning rather than inventing a gap. These textual citations are permitted here; the Motivation-only rule for external visual assets does not prohibit citing literature.

In the spoken notes, explain the intellectual relationship in plain language, emphasize the decisive distinction, and end on what remains to be answered. Do not read the citation list aloud. Keep the positioning brief enough that the question and findings arrive early.

## Research question and findings preview

Choose the layout from the length and complexity of the findings, not a fixed slide-count rule. Record the choice in the talk map and check it at presentation size.

- **One combined slide:** use this when a concise question, headline answer with uncertainty, and any essential supporting points fit with clear hierarchy, readable type, and whitespace. Put the question across the top and a clearly labeled findings area below; show both from the start.
- **Two consecutive slides:** use a Research Question slide followed immediately by a Preview of Findings slide when multiple findings, necessary qualifications, construct definitions, or a small visual need more room or explanation. Let the question slide state the question and essential definitions; let the preview slide answer it directly. A short question reminder may orient the preview without repeating the whole first slide.

First remove secondary detail that belongs in Results. If the essential preview still crowds the question, split the slides rather than shrinking type, dropping uncertainty, or rushing the explanation. Two slides still form an early preview, not a full results section. Use explicit frames rather than incremental overlays that create extra PDF pages.

1. **Question:** state the relationship, comparison, or tradeoff being studied in plain language. Define an unfamiliar construct briefly only when necessary to understand the answer.
2. **Main answer:** give the headline finding, exact magnitude, units, benchmark, and available uncertainty. Preserve the design's causal or associational language. For a non-quantitative contribution, state the central supported proposition without inventing a numerical estimate.
3. **Supporting findings:** include at most two short points that clarify the answer, such as a mechanism, heterogeneity pattern, or scope condition. Omit them if they crowd the main message. Save the full specification, robustness inventory, and detailed figures for later slides.

On a combined slide, keep the question visually distinct from the findings with whitespace and a restrained heading or block. Use a short section label such as “Question & Findings” for either layout to avoid an overlong orientation line. Shorten prose or split the slides rather than shrinking the font to fit.

In the notes, connect the unresolved issue from literature positioning to the question, then give the answer plainly. In the combined layout, pause at a paragraph break between question and answer. In the two-slide layout, give each frame its own note and make the transition directly from question to answer. Bold the key comparison or magnitude for vocal stress. Close the preview with why the setting or design can support that answer, leading into Context. Choose separation for clarity and pacing, not to create suspense.

## Motivation assets

External assets are allowed only in Motivation. Results, identification, and mechanism visuals must come from the paper or verified project outputs.

1. Find a reputable primary or citable source: official statistics, a research organization, a peer-reviewed paper, or the original publisher of a documented example.
2. Record the source name, year, page URL, and retrieval date in `notes/<slug>.md`.
3. Save the local asset under `slide/assets/<slug>/`; use a stable descriptive filename.
4. Add a visible source line on the frame, such as `\source{Source: Eurostat (2025).}`. Do not rely on speaker notes for attribution.

Prefer one clean chart, headline, document, or photograph over a montage. If no defensible visual exists, use a sourced statistic in large type. Never fabricate a number or use decorative stock imagery as evidence.

## Spoken notes

Write notes as language the author could actually say aloud. Use complete sentences and short paragraphs, usually 60–120 words per frame as an initial drafting range; delivery time depends on pauses, figures, and the speaker. The title note may be shorter. Do not use labels such as “Hook,” “Claim,” “Caveat,” or “Transition,” and do not write telegraphic fragments.

Each paragraph is a speaking unit, with its visible gap cueing a brief pause and a look up at the audience. Mark selected words or short phrases with `\textbf{...}` to cue vocal stress. These are part of writing the note, not optional decoration: avoid a dense unbroken script, and do not rely on bold section labels to indicate emphasis. Follow [talk-delivery.md](talk-delivery.md) for pause length, emphasis selection, and conversational phrasing.

Apply [talk-delivery.md](talk-delivery.md) when choosing what to say and budgeting time. The usual note length is a starting point; expand the explanation of a central result or shorten a transition to match the rehearsed block budget.

Each content-slide note should do three things smoothly; the title slide follows the personal opening below:

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

## Title-slide opening

For Kai Gu's own-work talks, begin with a brief, warm personal introduction. Use this wording as the default, adapting the greeting to the session and filling in the verified title and coauthors:

> Good morning, everyone. Thank you for being here.
>
> I'm **Kai Gu** from **Bocconi University**. I'm very honored to present this project, titled **[project title]**.
>
> This is joint work with **[coauthor names]**.

Use “Good afternoon” for an afternoon session, or “Hello, everyone” when the time is unknown. Say “joint work with” rather than “coworked with.” Match the title and coauthors to the current manuscript or user-supplied metadata; do not copy names from a different project. Omit the joint-work sentence for solo work, and use the actual presenter's name and affiliation when preparing a talk for someone else.

Keep the paragraph gaps as brief pauses, and use bold to mark natural emphasis on names, affiliation, and title. This short introduction is sufficient for the title frame's note; it does not need an additional research claim, result, agenda, or hook. Advance to the first Motivation slide before explaining the project, for example with “Let me start with a concrete example.” Include the greeting and pauses in the opening time budget.

## Notes by block

| Block | Spoken emphasis |
|---|---|
| **Opening** | Greet and thank the audience; introduce the presenter, affiliation, project title, and coauthors. Pause naturally between these speaking units; begin the substantive explanation on Motivation. |
| **Motivation** | Explain why the example is representative and why its consequence matters. State the source naturally when using external evidence. |
| **Literature Positioning** | Explain what the closest research establishes, what this paper adds, and which unresolved issue motivates its question. Emphasize the substantive distinction without reciting citations. |
| **Research Question + Preview of Findings** | State the question, pause or advance to the immediately following preview slide, then give the answer and interpret its size. Preview how the rest of the talk supports it. Match notes to the chosen one- or two-slide layout. |
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

Do not export a companion PNG deck by default. Rasterized pages and contact sheets used only for inspection belong under project-root `exploratory/previews/slides/<slug>/`, outside `slide/` and excluded from version control through `/exploratory/previews/` in `.gitignore`. Keep required Beamer assets in `slide/assets/<slug>/`; they are not disposable previews.

Reference assets as `assets/<slug>/<filename>` and compile with `latexmk -cd`, so paths resolve from the `slide/` directory.

## Beamer document

Start from this minimal system and adapt content, not the delivery format. Keep the design restrained: white background, navy text, blue accent, generous whitespace, and projection-size type. Do not reproduce the Reveal.js CSS or depend on web fonts.

```tex
\documentclass[aspectratio=169,11pt]{beamer}

\usepackage[T1]{fontenc}
\usepackage{lmodern}
\usepackage{amsmath,mathtools}
\usepackage{mathpazo}
\usefonttheme{professionalfonts}
\usepackage{booktabs,tabularx}
\usepackage{graphicx}
\usepackage{xcolor}
\usepackage{pgfpages}

% Keep speaking units visibly separated when notes are rendered.
\addtobeamertemplate{note page}{\setlength{\parskip}{0.6em}}{}

\definecolor{DeckNavy}{HTML}{17324D}
\definecolor{DeckBlue}{HTML}{2563EB}
\definecolor{DeckMuted}{HTML}{64748B}
\definecolor{DeckPale}{HTML}{EFF6FF}

\setbeamercolor{normal text}{fg=DeckNavy,bg=white}
\setbeamercolor{frametitle}{fg=DeckNavy,bg=white}
\setbeamercolor{structure}{fg=DeckBlue}
\setbeamercolor{alerted text}{fg=DeckBlue}
\setbeamerfont{frametitle}{series=\bfseries,size=\Large}
\setbeamercolor{section label}{fg=DeckMuted,bg=white}
\setbeamerfont{section label}{size=\footnotesize,series=\mdseries}
\setbeamertemplate{frametitle}{%
  \nointerlineskip
  \begin{beamercolorbox}[wd=\textwidth,sep=0pt]{frametitle}
    \vskip0.6em
    \ifnum\value{section}>0
      {\usebeamerfont{section label}\usebeamercolor[fg]{section label}%
       \insertsectionnumber\enspace\insertsectionhead\par}%
      \vskip0.3em
    \fi
    {\usebeamerfont{frametitle}\insertframetitle\par}%
    \ifx\insertframesubtitle\empty\else
      {\usebeamerfont{framesubtitle}\usebeamercolor[fg]{framesubtitle}%
       \insertframesubtitle\par}%
    \fi
    \vskip0.3em
  \end{beamercolorbox}}
\setbeamerfont{title}{family=\rmfamily,series=\bfseries,size=\LARGE}
\setbeamerfont{subtitle}{family=\rmfamily,series=\bfseries,size=\Large}
\setbeamerfont{author}{family=\rmfamily,size=\normalsize}
\setbeamertemplate{title page}{%
  \centering
  {\usebeamerfont{title}\mbox{\inserttitle}\par}
  \ifx\insertsubtitle\empty\else
    \vspace{0.35em}
    {\usebeamerfont{subtitle}\mbox{\insertsubtitle}\par}
  \fi
  \vspace{1.4em}
  {\usebeamerfont{author}\insertauthor\par}
  \vspace{0.4em}
  {\usebeamerfont{institute}\insertinstitute\par}
  \vspace{0.8em}
  {\usebeamerfont{date}\insertdate\par}}
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

\title{<Main title>}
\subtitle{<Subtitle>}
\author{<Authors>}
\institute{<Affiliations>}
\date{<Venue or status, date>}

\begin{document}

\begin{frame}[plain]
  \titlepage
  \note{Good morning, everyone. Thank you for being here.

  I'm \textbf{Kai Gu} from \textbf{Bocconi University}. I'm very honored to
  present this project, titled \textbf{<Project title>}.

  This is joint work with \textbf{<Coauthor names>}.}
\end{frame}

% Follow the exact narrative spine above. Declare each block before its frames:
\section{Motivation}
% \begin{frame}{<Slide-specific title>} ... \end{frame}

\end{document}
```

Use one claim per frame. Keep frame titles short and informative. Prefer a full-width figure or a simple two-column composition. Avoid tiny multi-panel plots, ornamental card grids, automatic section-divider frames, and overlays that turn one logical slide into several PDF pages. Put useful backup frames after `\appendix` and write notes for them too.

**Section labels above titles.** Declare each narrative block with `\section{<Short section name>}` before its first content frame. The template prints the current section number and name above every frame title, as a small orientation line; the opening title frame has no label. Keep section names stable and consistent with the talk map, and let each frame title name its own topic without repeating the section. If the talk map is unnumbered, omit `\insertsectionnumber\enspace` from the template. After `\appendix`, declare `\section{Backup}` so backup frames do not inherit Conclusion. Shorten an overlong section label instead of shrinking it; inspect alignment, the gap above the title, and the remaining body space in the compiled PDF.

Put a plain-language symbol gloss below every displayed equation. Keep only the equation required for the argument. For canonical designs, explain the identifying assumption and diagnostic rather than spending a full frame on a familiar regression equation.

## Title-slide typography

Center the title horizontally. Place the main title on the first line and the subtitle on the second, with a deliberate break and balanced spacing. Use bold Palatino through `mathpazo`, matching the manuscript's font family, and center the author block beneath it. The template explicitly selects `\rmfamily` for both title lines so Beamer's default sans-serif font does not override Palatino.

Keep each title line unbroken: use separate `\title{...}` and `\subtitle{...}` fields and the template's `\mbox` wrappers. If the paper has no subtitle, omit `\subtitle` rather than inventing one. Measure and visually inspect both lines at the intended slide size. If either overflows, adjust its font size locally while keeping it readable; if necessary, agree on a shorter display title. Do not silently wrap a title line or scale the entire frame. Keep more space between the subtitle and author block than between the two title lines.

## Frames and notes

Write every slide as an explicit `frame` environment and put exactly one substantive `\note{...}` inside it. This includes the title frame, any section divider, conclusion, acknowledgments, and appendix frames. Do not use automatic frame generators because they can create slides without notes.

```tex
\section{Question \& Findings}
\begin{frame}{Does treatment bring in new buyers?}
  \textbf{Research question:} How does treatment change purchases,
  and is the increase concentrated among first-time buyers?
  \medskip
  \begin{block}{Main result}
    Treatment raises purchases by \alert{3.2 percentage points}
    (95\% CI: 2.1 to 4.3), about 27\% above a 12-point baseline.
  \end{block}
  \begin{itemize}
    \item The effect is concentrated among first-time buyers.
  \end{itemize}
  \note{That leaves a question about \textbf{who responds}. How does treatment
  change purchases, and is the increase concentrated among first-time buyers?

  We find a \textbf{3.2 percentage-point increase} in purchases, with a
  95 percent confidence interval from 2.1 to 4.3 points. Relative to the
  12-point baseline, that's about a \textbf{27 percent increase}.

  The increase is concentrated among \textbf{first-time buyers}. That suggests
  we're bringing in new buyers, rather than seeing existing customers buy more.

  So where does our comparison come from? Let me explain the setting, and
  then we'll look at the estimates behind these findings.}
\end{frame}
```

This example demonstrates the combined layout with an illustrative question and findings, not evidence to copy into a real deck. For a longer preview, move the question and its opening note paragraph into a preceding frame; keep the findings and their spoken explanation in the next frame, giving each a substantive note. The paragraph gaps cue pauses between the question, magnitude, interpretation, and transition; bold spans cue stress within the spoken sentences. The note is spoken prose, not a second slide. Apply the style and block-specific guidance above. Escape TeX-sensitive characters and keep citations or source details concise enough to say naturally. Do not put unsourced numbers in either the frame or its note.

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
4. Render representative pages—including the title, literature positioning, the question and findings preview in their chosen layout, densest data slide, every distinct results layout, and conclusion—to inspection images in project-root `exploratory/previews/slides/<slug>/` and inspect them. Check clipping, minimum type size, source visibility, table legibility, and figure labels. Confirm that positioning follows Motivation, its claims have supporting citations, and the question and preview follow on either one combined page or two consecutive pages, question first. Verify that the chosen layout accommodates the essential findings at readable size, without overlays or omitted uncertainty. On the title slide, verify bold Palatino, horizontal centering, two unbroken title lines when a subtitle exists, balanced spacing, and the centered author block.
5. Read the notes from beginning to end without looking at the slides. They should sound like one coherent talk. Confirm that the title note contains the personal greeting, introduction, verified title, and coauthor credit where applicable, with the substantive hook starting on Motivation. Revise abrupt openings, repeated transitions, unexplained terms, unsupported numbers, and content-slide paragraphs that merely recite visible bullets.
   Inspect a temporary notes rendering even when a separate notes PDF is not a requested deliverable; keep that inspection build under the ignored preview directory. Check that paragraph gaps survive compilation, bold words visibly differ from normal text, and the longest note fits at a comfortable reading size. Shorten or reflow an overflowing note rather than shrinking it into a dense block. In an aloud rehearsal, pause at paragraph gaps and stress the bold words to check that both feel natural.
6. Verify that the same headline magnitude appears verbatim in the preview, main result, conclusion, and corresponding notes.
7. Check the block-level time budget, interruption allowance, backup-slide references, and route to the conclusion against `talk-delivery.md`. Distinguish estimated timing from an actual timed rehearsal.
