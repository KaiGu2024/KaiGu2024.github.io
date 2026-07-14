---
name: estimand-ladder
description: Generate the Lundberg–Johnson–Stewart (2021, ASR) three-step "estimand ladder" figure in LaTeX — theoretical estimand → empirical estimand (under an identification design) → estimation strategy — laid out for a specific research design. Produces a compilable standalone .tex (and PDF) where the contrast is shown as potential outcomes, then conditional expectations, then fitted predictions. Use this whenever the user mentions an estimand, a theoretical or empirical estimand, the "what is your estimand" framework, a target quantity, what a regression "actually estimates," or wants a figure/diagram connecting theory → identification → estimation. The treatment factor and the conditioning factor are parameterized (the motherhood/employment example is only the default), so it adapts to any causal contrast — switch them to your own treatment, comparison level, conditioning variable, unit, and outcome. Make sure to reach for this skill even when the user just says "draw the estimand ladder," "make the estimand figure," or "lay out my estimand for the paper" without naming Lundberg et al. It has a second mode beyond drawing the figure: INTERPRETING an estimand. Trigger it whenever the user is reading a regression coefficient, a results table, or an empirical claim and wants to know what quantity it actually identifies — "what does this coefficient really estimate," "is this the ATE or something else," "what's the estimand here," "how should I read this result," "does this regression answer my question," whether an effect is a variance-weighted average — apply the estimand-audit lens even when no figure is requested.
allowed-tools: Read, Edit, Write, Bash
invocation: manual
disable-model-invocation: true
---

# Estimand Ladder

Renders the three-step figure from **Lundberg, Johnson & Stewart (2021), "What Is Your Estimand?", *American Sociological Review*** ([doi:10.1177/00031224211004187](https://journals.sagepub.com/doi/10.1177/00031224211004187)) for a chosen research design. The figure walks one causal contrast down three rungs, each demanding a different kind of justification:

| Rung | Header | What the math shows | Requires |
|---|---|---|---|
| 1 | Set the target — *define a theoretical estimand* | average of **potential outcomes** $Y_i(\cdot)$ | substantive **argument** |
| 2 | Link to observables — *define an empirical estimand under a certain identification design* | average of **conditional expectations** $\mathbb{E}(Y\mid\dots)$ | conceptual **assumptions** |
| 3 | Learn from data — *select an estimation strategy* | average of **fitted predictions** $\widehat{\mathbb{E}}(Y\mid\dots)$ | statistical **evidence** |

The whole point of the figure is that the *target quantity* is one thing held fixed across all three rungs; only the justification changes. Keep that invariant when adapting it.

## Two modes

Same framework, two jobs. Pick by what the user is doing:

- **Build the ladder** — they want the figure for a specific design. Follow *The asset* → *Workflow* below.
- **Interpret an estimand** — they're reading a regression, a results table, or a claim and want to know *what quantity it actually identifies* and whether it's the one they care about. No figure needed; go straight to *Interpreting an estimand*. Offer to draw the ladder afterward only if making the target explicit would help.

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

### 1b. …or extract the slots from a paper (TeX or PDF)
If the user points at a paper instead of describing the design, read the slots out of it. Every slot lives in the **data / sample / empirical-strategy / specification** sections and the regression equation — not the intro or results. Extraction *infers* the contrast, so this path always ends at the confirmation step below, never straight at compile.

**TeX source — preferred, read it directly (no conversion).** `Grep` for the specification: `\begin{equation}`, `reg`/`areg`/`\hat`, "we estimate", "the coefficient on", `\beta`, the dependent-variable and treatment macro names, and the sample-definition sentence. TeX hands you exact variable names and the reference category, which is precisely what the slots need.

**PDF only — convert to text first, then read.** Equation fidelity does not matter here (the slots are prose), so the lightest tool wins:
```bash
pdftotext -layout paper.pdf paper.txt   # poppler, already installed; -layout keeps columns readable
```
Then `Grep`/`Read` `paper.txt` for the same cues as the TeX route. Only reach for a heavier converter if `pdftotext` garbles the sections you need — e.g. `markitdown paper.pdf > paper.md` (needs `pip install 'markitdown[pdf]'`) or MinerU (the `slide` skill's route, best for layout+equation reconstruction but heavyweight). Don't install either unless the light path actually fails.

**Map what you find onto the slots:**
- treatment factor + two levels ← the key regressor and its contrast / reference category
- conditioning factor + fixed level ← a covariate the contrast is evaluated *within* (if the paper conditions on one). If it doesn't, this is the no-conditioning-factor variant — a scaffold edit, see below.
- unit / outcome ← the sample unit and the dependent variable
- six glosses ← **write these yourself** from the paper's framing. The paper won't phrase them as counterfactual / factual / mechanical, so paraphrase one per rung; that register shift is your contribution, not the paper's.

**Then confirm before compiling.** Show the user the filled macro block — treatment, both levels, conditioning factor + fixed level, unit, outcome, all six glosses — and let them correct it. A flipped reference category or a covariate mistaken for the treatment makes the figure confidently wrong.

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

## Interpreting an estimand (no figure)

The framework's payload for reading results: **a coefficient is an *estimator*, not the quantity of interest.** Interpreting one means recovering the estimand it targets, then asking whether that's the estimand the user actually wants. Given a regression, a results table, or an empirical claim, walk the checks below — report what you find and flag the traps; never invent numbers, and say plainly when the paper/output gives you too little to judge.

1. **Name the target — "whose effect, aggregated how?"** A theoretical estimand is a *unit-level quantity* averaged over a *target population*. ATE, ATT, and CATE differ only in that population/weighting. Before reading magnitude, state which one the coefficient is an average over — a number can be large for the treated and ≈0 for the population, and both are honestly "the effect."

2. **Infinite-data test.** Ask: with the whole population and every potential outcome observed, what number would this compute? If you can't write it down, the target is undefined and the coefficient is interpreting *itself* (whatever the model emits) rather than answering a question. Fast triage for "is this result even about something."

3. **Estimator weighting under heterogeneity** (Angrist 1998; Aronow–Samii 2016, foregrounded by the paper). OLS-with-controls does **not** return the ATE when effects vary — it returns a *variance-weighted* average that up-weights strata where treatment is most variable. Matching, IPW, and regression target *different* weighted estimands. When effects plausibly differ across segments (usually, in marketing), flag that the reported number is an implicit weighting and ask whether it matches the population the decision is about.

4. **Identification gap.** The causal content lives in the assumptions bridging empirical → theoretical estimand (conditional ignorability, overlap/positivity, SUTVA/consistency), *not* in which regression was run. A perfectly estimated empirical estimand is still the wrong number if overlap fails or a confounder is uncontrolled. Interpret by naming what must be true, not by re-reading the spec.

5. **Table 2 fallacy** (Westreich–Greenland 2013). Coefficients on *control* variables are not effects and must not be read as a ranked "what matters" list — each is conditioned on a different, often nonsensical, adjustment set. A garbage-can regression has no single estimand at all.

6. **Descriptive estimands count too.** "The X gap" / "the loyalty premium" is also an estimand: it needs an explicit population and adjustment set or it's uninterpretable. Apply the same discipline to descriptive claims, not just causal ones.

7. **Target population / transportability.** The estimand pins down *to whom the number applies*. A clean effect in the sample is silent about a different population of interest absent a transportability argument. Ask whether the estimand's population is the one the user cares about.

The throughline mirrors the figure: **define the target before reading the estimate**, so the model serves the question instead of the question being reverse-engineered from whatever the model produced. (For a full results-table referee pass, this complements `analysis-review` and `paper-review`; this skill is the estimand lens specifically.)

## Sync to the active skill library

After editing, this skill must be copied into `~/.claude/skills/` to take effect (manual `cp`, no symlink — see the repo CLAUDE.md):

```bash
cp docs/skills/estimand-ladder/SKILL.md ~/.claude/skills/estimand-ladder/SKILL.md
mkdir -p ~/.claude/skills/estimand-ladder/assets
cp docs/skills/estimand-ladder/assets/estimand-ladder.tex ~/.claude/skills/estimand-ladder/assets/
```
