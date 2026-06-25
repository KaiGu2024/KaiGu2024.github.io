---
name: estimand-ladder
description: Generate the Lundberg–Johnson–Stewart (2021, ASR) three-step "estimand ladder" figure in LaTeX — theoretical estimand → empirical estimand (under an identification design) → estimation strategy — laid out for a specific research design. Produces a compilable standalone .tex (and PDF) where the contrast is shown as potential outcomes, then conditional expectations, then fitted predictions. Use this whenever the user mentions an estimand, a theoretical or empirical estimand, the "what is your estimand" framework, a target quantity, what a regression "actually estimates," or wants a figure/diagram connecting theory → identification → estimation. The treatment factor and the conditioning factor are parameterized (the motherhood/employment example is only the default), so it adapts to any causal contrast — switch them to your own treatment, comparison level, conditioning variable, unit, and outcome. Make sure to reach for this skill even when the user just says "draw the estimand ladder," "make the estimand figure," or "lay out my estimand for the paper" without naming Lundberg et al.
allowed-tools: Read, Edit, Write, Bash
invocation: manual
---

# Estimand Ladder

Renders the three-step figure from **Lundberg, Johnson & Stewart (2021), "What Is Your Estimand?", *American Sociological Review*** ([doi:10.1177/00031224211004187](https://journals.sagepub.com/doi/10.1177/00031224211004187)) for a chosen research design. The figure walks one causal contrast down three rungs, each demanding a different kind of justification:

| Rung | Header | What the math shows | Requires |
|---|---|---|---|
| 1 | Set the target — *define a theoretical estimand* | average of **potential outcomes** $Y_i(\cdot)$ | substantive **argument** |
| 2 | Link to observables — *define an empirical estimand under a certain identification design* | average of **conditional expectations** $\mathbb{E}(Y\mid\dots)$ | conceptual **assumptions** |
| 3 | Learn from data — *select an estimation strategy* | average of **fitted predictions** $\widehat{\mathbb{E}}(Y\mid\dots)$ | statistical **evidence** |

The whole point of the figure is that the *target quantity* is one thing held fixed across all three rungs; only the justification changes. Keep that invariant when adapting it.

## The asset

`assets/estimand-ladder.tex` is a self-contained `article` document (uses only `amsmath`/`amssymb`/`geometry`, all present in TinyTeX). It compiles as-is to the motherhood/employment worked example — that default *is* a working reference, so always compile it once before editing to confirm the toolchain works.

## Workflow

### 1. Capture the design (do this before touching the file)
Pin down the slots from the user's project. If any are unstated, ask — a wrong contrast makes the figure actively misleading. You need:

- **Treatment factor** + its **two levels** (treated, comparison). This is the contrast that *defines* the estimand.
- **Conditioning factor** + the **level it is held fixed at** — the thing both arms share so the contrast is apples-to-apples.
- **Unit** (singular + plural) and the **outcome** symbol.
- **Six brace glosses** — the plain-English reading printed over each term. They shift register down the ladder, and that shift is the pedagogical payload:
  - Rung 1 = **counterfactual** ("if she *were* an employed mother")
  - Rung 2 = **factual** ("women who *actually are* mothers")
  - Rung 3 = **mechanical** ("*recode* all as a mother")
  - Keep the treated/comparison glosses grammatically parallel within each rung.

### 2. Copy and edit only the macro block
Copy the template to wherever the figure lives in the user's project (e.g. their paper's `figures/` directory), then edit **only** the block between `EDIT HERE` and `END EDIT HERE`. Everything below `DO NOT EDIT BELOW` is the scaffold — overbraces, the conditioning-expectation array, the underbraces on rung 3 — and should not be touched.

The level/factor tokens are rendered in math mode (matching the source figure's italic), so a hyphen in e.g. `Non-mother` prints as a math minus. That matches the original; leave it unless the user objects.

**Do not parameterize the three right-flush annotations** (argument / assumptions / evidence) or the rung headers' verbs — those are the paper's fixed claims about what each step demands, not design-specific.

### 3. Compile and check
From the `.tex` file's directory, using this repo's TinyTeX (not on PATH, Anaconda shadows it):

```bash
TINYTEX="/c/Users/kaizhu/AppData/Roaming/TinyTeX/bin/windows"
PATH="$TINYTEX:/c/Windows/System32" "$TINYTEX/pdflatex.exe" \
  -interaction=nonstopmode estimand-ladder.tex
```

Then render a page to eyeball it (MiKTeX's `pdftoppm` is available) and Read the PNG:

```bash
pdftoppm -png -r 90 estimand-ladder.pdf page
```

Two things to watch:
- **One page.** If a longer factor name or gloss pushes content onto a second page, raise `paperheight`. If a header line wraps (the right-flush annotation drops to the next line), raise `paperwidth` or shorten the gloss — never let `\hfill` wrap.
- **No overfull `\hbox`.** Long conditioning labels widen the equation; widen `paperwidth` to absorb it.

### 4. Crop for embedding (optional)
The page already has tight 1.1 cm margins. If the user wants it flush to the ink for a paper float, `pdfcrop estimand-ladder.pdf` (if installed) or set narrower geometry. Clean up `.aux`/`.log`/`page*.png` byproducts; ship only the `.tex` (and `.pdf` if they want the render checked in).

## Adapting beyond a two-factor contrast

The default has one treatment factor and one held-fixed conditioning factor. Common variants:

- **No conditioning factor** (a plain treatment contrast): drop the `\Cfac`/`\Clev` row from the `\condexp` array in the scaffold and remove the second argument from the rung-1 potential outcomes. This is a scaffold edit — flag it to the user rather than doing it silently.
- **Continuous treatment / dose**: the two-level contrast doesn't fit cleanly; tell the user the ladder figure assumes a discrete contrast and offer to render two representative levels instead.
- **More covariates**: the `Covariates X̄ = Observed x̄ᵢ` row already stands in for the full covariate vector; no change needed.

## Sync to the active skill library

After editing, this skill must be copied into `~/.claude/skills/` to take effect (manual `cp`, no symlink — see the repo CLAUDE.md):

```bash
cp docs/skills/estimand-ladder/SKILL.md ~/.claude/skills/estimand-ladder/SKILL.md
mkdir -p ~/.claude/skills/estimand-ladder/assets
cp docs/skills/estimand-ladder/assets/estimand-ladder.tex ~/.claude/skills/estimand-ladder/assets/
```
