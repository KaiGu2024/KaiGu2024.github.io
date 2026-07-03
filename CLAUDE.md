# Personal Academic Website — CLAUDE.md

## Project Overview

Personal academic website for Kai Gu (PhD student in Marketing, Bocconi University), hosted on GitHub Pages at `kaigu.github.io`. The repo has three concerns, in order of weight:

1. **The website itself** — `docs/` is the Jekyll publishing root. Bio, papers, CV, reading group, skill library, learning materials.
2. **A published Claude Code skill library** — `docs/skills/` doubles as on-site documentation and the user's own active skills. Skills are synced manually to `~/.claude/skills/<name>/SKILL.md`.
3. **Reading-group Reveal.js decks** — `docs/reading_group/<session>/` produced via the `slide` skill, brand-aligned (blue-white academic), with embedded base64 figures and the press-N speaker-notes overlay.

This is NOT a research replication package; the research-specific Data Provenance / Citation Policy / AI Disclosure sections are intentionally omitted.

---

## Directory Layout

```
website/
├── CLAUDE.md           # this file
├── code/cv.tex         # LaTeX CV source
├── output/             # LaTeX build artifacts (do not edit manually)
├── docs/               # GitHub Pages root
│   ├── index.html      # personal site landing
│   ├── css/
│   │   ├── tokens.css  # source-of-truth design tokens for the SITE brand
│   │   └── style.css   # site styles
│   ├── assets/
│   │   ├── cv.pdf      # copied from output/cv.pdf after recompile
│   │   └── photo.jpg
│   ├── skills/         # skill library (see "Skill library" below)
│   └── reading_group/  # Reveal.js decks (see "Reading-group decks" below)
├── notes/              # working notes, drafts, screenshots — not published
└── .tmp_edit/          # scratch space for slide-HTML Python patches (gitignored)
```

---

## Compiling the CV

There is **one CV source**, `code/cv.tex`, and it always includes the paper abstracts (2 pages). No short/long toggle: the old `\hideabstracts` mechanism and the `cv_short.tex` wrapper were removed. The website ships this single build in `docs/assets/cv.pdf`.

pdflatex is provided by TinyTeX; it is not on `PATH` and Anaconda shadows it, so always invoke with explicit path + clean `PATH`. Run from the `code/` directory so the `\input{cv.tex}` form resolves.

```bash
TINYTEX="/c/Users/kaizhu/AppData/Roaming/TinyTeX/bin/windows"
cd code

PATH="$TINYTEX:/c/Windows/System32" "$TINYTEX/pdflatex.exe" \
  -interaction=nonstopmode \
  -output-directory="../output" \
  cv.tex
```

After recompiling, sync the PDF: `cp output/cv.pdf docs/assets/cv.pdf`.

### Installing missing LaTeX packages

TinyTeX ships minimal — install on demand via `tlmgr`. `tlmgr.bat` needs the TinyTeX bin dir on `PATH` to locate itself:

```bash
PATH="$TINYTEX:$PATH" "$TINYTEX/tlmgr.bat" install <package>
```

Currently required by `cv.tex`: `fontawesome5`, `parskip`, `ragged2e`, `siunitx`.

---

## Brand system — two cousins, not one identity

Two visual brands live in this repo. They are *cousins* (both quiet, both reject the AI-slop default), not the same identity. Keep them separate.

| | Personal site (incl. reading-group index) | Slide decks |
|---|---|---|
| **Source of truth** | `docs/css/tokens.css` | `docs/skills/slide/references/aesthetics.md` |
| **Type** | Lora (display) + Newsreader (body), both serif | Plus Jakarta Sans throughout (sans), Source Serif 4 for math |
| **Palette** | Hokusai Prussian `#2E4A75`, warm cream `#EFE6D2`, Hokusai crimson `#A03830` | Navy `#1d3a6e`, white, electric blue `#0046AD` |
| **Surface** | Warm cream paper with faint paper-grain | Pure white, no texture |
| **Register** | Book voice — slow read | Conference house slides — eye-catch at slide pace |

**Rules to hold.**

- **No Inter, anywhere on the site or CV** — body is Newsreader (paired with Lora). Inter / Roboto / Arial / system-ui-only are treated as the AI-slop default.
- **Slide-context exception.** Plus Jakarta Sans is allowed in slide decks only. Slides need eye-catch sans-serif; the site rule does not transfer.
- **No warm tones for slides.** No cream paper, no Hokusai crimson on slides. The slide brand is cool only.
- **Hokusai crimson is for the site, and used sparingly** — ≤2% of visible area. If crimson covers area, it stopped being an accent.
- **No section dividers** in styling — spacing alone separates blocks.
- **Saturated colors look old-school for *decorative* fills and default series** (see `feedback_figure_aesthetic` memory); keep those muted. The exception is **subject identity** — the fixed `subject_palette` in the visualization skill deliberately uses vivid/deep hues, because there color's whole job is to name a recurring subject across a comparison. Pick one color per hue family when a figure colors more than one subject.

---

## Skill library — `docs/skills/`

The skill files in `docs/skills/` are simultaneously (a) documentation rendered by Jekyll on the site and (b) the user's active Claude Code skills. They are kept in sync by **manual `cp`**, not a symlink (the symlink path needs Windows admin which is gated).

**Sync workflow.** After editing any `docs/skills/<name>.md` (or `docs/skills/<name>/SKILL.md` for folder-skills):

```bash
# Single-file skill
cp docs/skills/<name>.md ~/.claude/skills/<name>/SKILL.md

# Folder-skill (with references/)
cp docs/skills/<name>/SKILL.md ~/.claude/skills/<name>/SKILL.md
cp docs/skills/<name>/references/*.md ~/.claude/skills/<name>/references/
```

Always offer the `cp` commands at end-of-edit. Never assume the user has Jekyll preview running; they read changes on the actual site after push.

**Folder-skills** (have a `references/` subdirectory):
- `slide/` — Reveal.js deck generation
- `visualization/` — R + ggplot2 publication figures
- `tables/` — journal-convention + design-principles table formatting (sibling to `visualization/`)
- `paper-review/` — multi-agent referee report
- `paper-writing/` — drafting + journal-voice polish for the main text; `references/main-text.md` (Cochrane/McCloskey template, the AI-tells self-audit, strict-traceability mode) is the default, `references/academic-voice.md` is the opt-in house-voice pass. Folds in the former flat `writing` and `academic-voice` skills. Sibling to `appendix/` (which owns the appendix/supplementary materials)
- `appendix/` — write & audit empirical appendices; derives required support from the main text, then traces the chain main-text claim → appendix item → evidence (directory + literature), checking coverage/grounding/consistency. Decomposes each statement into typed claims (definitional / factual / methodological / citational / result / procedural)

**Flat skills** (single `.md`): `analysis-cleanup`, `ai-disclosure-block`, `agent-configuration`, `big-data-processing`, `brainstorm`, `codebook-generator`, `eda`, `literature-review`, `llm-annotation`, `preregistration`, `replication-readme`, `report`, `revision-plan`, `skill-creator`, `username-dossier`, `verify-citations`, `version-control`, `web-access`, `web-scraping`.

---

## Reading-group decks — `docs/reading_group/`

Each session lives in its own directory; the index at `docs/reading_group/index.html` lists all sessions (newest first). Decks are Reveal.js HTML built via the `slide` skill, self-contained (CSS inline, figures base64-embedded), and ship blue-white per the slide brand.

**Conventions baked into the `slide` skill that affect this repo specifically.**

- **Editing base64-laden HTML** — never `Read` or `Edit` a slide HTML after multiple figures are embedded (a single full-resolution PNG data URI is 30–80k tokens, which trips Read's 25k-token cap). Instead, drop a one-shot Python patch in `.tmp_edit/` and run it. The `.tmp_edit/` directory is scratch — write, run, delete.
- **Inspecting structure without choking** — `Grep` on text content works; raw `print` of the file does not. Use the line-skip pattern documented in `docs/skills/slide/SKILL.md` → "Agent process notes".
- **Press-N speaker notes** — every section should carry `<aside class="notes">` with a 30–60s script (the script, not a recap of what's already on the slide). The init script in the template rebinds key 78 to toggle `body.show-notes`. CSS for the overlay is in `aesthetics.md` §7; per-slide content guide in `references/speaker-notes.md`.
- **No Hokusai wave on slides** — that signature belongs to the personal-site brand only. Slides use a single electric-blue underline on the title-slide h2 as their accent moment.

---

## GitHub Pages setup

- Publishing source: `docs/` folder on `main` branch
- Settings → Pages → Source: Deploy from branch → `main` / `docs`
- Jekyll auto-publishes; no build step in this repo

---

## Do not commit

- `.claude/` — Claude Code state, worktrees, settings.local.json
- `.tmp_edit/` — scratch Python patches for slide HTML
- `bash.exe.stackdump` and `docs/skills/bash.exe.stackdump` — Cygwin/MSYS keeps spawning these; safe to delete on sight
- `output/` LaTeX intermediates (`.aux`, `.log`, `.synctex.gz`) — only `output/cv.pdf` matters and it is copied into `docs/assets/`
- `notes/` working PDFs, TeX scratch, screenshots — not published

If any of the above show up in `git status`, do not stage them. `git add -A` and `git add .` are forbidden because they sweep these in.

---

## Site editing micro-tasks

- **Add a profile photo.** Place `photo.jpg` in `docs/assets/`; in `docs/index.html`, remove the `<div class="photo-placeholder">KG</div>` line and uncomment the `<img src="assets/photo.jpg" ...>` line below it.
- **Update LinkedIn URL.** In `docs/index.html`, replace `YOUR-LINKEDIN-HANDLE` with the actual handle.
- **Add a new paper.** Copy an existing `.paper` div block in `docs/index.html`; update title, authors, abstract, tags, venue.
- **Add a new reading-group session.** Create `docs/reading_group/<YYYYMMDD>_<slug>/`, drop the deck inside, and add a `<a class="session-card">` block at the top of `docs/reading_group/index.html`. Keep newest-first ordering.

---

## VS Code LaTeX preview

LaTeX Workshop is configured in VS Code settings to use TinyTeX pdflatex directly (bypassing the latexmk default and the Anaconda PATH issue). Output directory is set to `output/`.
