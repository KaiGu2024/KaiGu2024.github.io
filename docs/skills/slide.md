---
name: slide
description: Use when generating Reveal.js reading-group slides from a paper PDF or TeX source — TeX route reads source directly; PDF-only route runs MinerU extraction first, then proceeds. Default output slide/<slug>.html; PDF export via Decktape only on explicit request. Follows the reading-group slide template.
allowed-tools: Read, Edit, Write, Bash
user-invocable: true
---

Output paths:
- `slide/<slug>.html` — Reveal.js HTML (default).
- `slide/<slug>.pdf` — exported from the HTML via Decktape, **on request only** (Step 4).

---

## Workflow

```
TeX source provided  →  read directly        → reading notes → Reveal.js slides → [PDF on request]
PDF only             →  MinerU extraction    → reading notes → Reveal.js slides → [PDF on request]
```

- **TeX available**: Read the `.tex` files directly. Extract equations, table source, and figure paths from source — no extraction script needed.
- **PDF only**: Run the MinerU extraction (Step 1) to produce markdown, structured tables, and figure PNGs, then proceed.

Generate slides only when explicitly requested. Default to the Reveal.js HTML format; use `slide/<slug>.tex` (Beamer / metropolis theme) only if TeX is requested. Export to PDF only when the user asks for a PDF version — Step 4.

---

## Step 1 — Extract PDF Text

Install (one-time; downloads ~3–5 GB of model weights on first run):
```bash
pip install magic-pdf
```

```python
import json, pathlib, subprocess

def extract_paper(pdf_path: str, slug: str) -> dict:
    out_dir = pathlib.Path("paper") / slug
    out_dir.mkdir(parents=True, exist_ok=True)

    subprocess.run(
        ["magic-pdf", "-p", pdf_path, "-o", str(out_dir), "-m", "auto"],
        check=True,
    )

    stem = pathlib.Path(pdf_path).stem
    auto_dir = out_dir / stem / "auto"

    prose = (auto_dir / f"{stem}.md").read_text(encoding="utf-8")
    content = json.loads((auto_dir / f"{stem}_content_list.json").read_text(encoding="utf-8"))
    figures_dir = auto_dir / "images"

    return {
        "markdown":    prose,         # full text + table markdown + LaTeX formulas as $$...$$
        "content":     content,       # structured list: {type, text/table_body, img_path, ...}
        "figures_dir": figures_dir,   # PNG files, one per extracted figure
    }
```

`content` item types used in later steps:
- `{"type": "table", "table_body": [[...rows...]], "img_path": "..."}` — use `table_body` for slide tables
- `{"type": "image", "img_path": "...", "img_caption": "..."}` — figure PNGs for results slides
- `{"type": "equation", "text": "$$...$$"}` — LaTeX for the identification slide

---

## Step 2 — Reading Notes

Before generating slides, produce structured reading notes at `notes/<slug>.md` covering: one-liner, research question, data, identification strategy, key results, mechanisms, discussion questions. Read the full extracted text first — include specific numbers, not vague summaries.

---

## Step 3 — Slide Structure (12–16 slides)

| # | Slide | Notes |
|---|---|---|
| 1 | **Title** | Full title; authors + affiliations; journal + year or "Working Paper". *Optional:* one-sentence headline finding in a `.callout-result` to anchor the deck. |
| 2 | **Author Bios** | 3-column grid; photo (circular) + position + PhD + research interests |
| 3 | **Outline** | Substantive sections only — skip motivation, data, ID; one bold title + one sentence each |
| 4 | **Data & Setting** | Filtering pipeline with N and %; LLM annotation steps with amber callout boxes |
| 5 | **Identification** | Three sections: challenge → strategy → **assumptions to discuss** (see strategy table below). Skip the empirical specification for canonical DiD/IV/RD — audience knows it; show the spec in LaTeX only if the paper deviates (staggered DiD, shift-share IV, fuzzy RD, etc.). |
| 6–N | **Results** | **One fact per slide**; reproduce original table/figure; pair with brief **Description + Analysis** (see below). If a single fact carries heavy content (large table + long commentary, multi-panel figure, or a figure paired with a regression table), **split across 2–3 slides** rather than cramming — e.g. slide A = figure + description, slide B = analysis + caveats; or one slide per panel. Prefer splitting over scrolling. **Required for PDF export — see Step 4.** |
| N+1 | **Takeaways & Discussion** | 3 bullet takeaways then 5 discussion questions stacked vertically |

Include an **Analytical Model** slide immediately before Results if the paper has a formal model.

**Figure and table sourcing — tiered policy:**

1. **TeX available** → rebuild **tables** as HTML from source; for **figures**, browsers will not render `<img src="*.pdf">`, so convert each `\includegraphics` PDF/EPS to PNG first:
   ```bash
   pdftoppm -png -r 200 figures/fig1.pdf /tmp/fig1   # → /tmp/fig1-1.png
   ```
2. **PDF only** → use MinerU output: `figures_dir/` for figure PNGs, `content` list for table rows. Use extracted assets if successful.
3. **Extraction fails** → insert a `<!-- MANUAL: supply figure here -->` placeholder with a visible caveat block in the slide, and tell the user which asset to provide. **Do not self-generate** a table or figure unless the user explicitly instructs it.

**Self-contained output — embed everything in the HTML:**

The generated `slide/<slug>.html` must be a single self-contained file with **no external asset references** (no `slide/assets/`, no relative image paths). Every figure and table lives inside the HTML itself.

- **Tables** → write as native `<table>` HTML (always — never as an image of a table).
- **Raster figures (PNG/JPG)** → embed as base64 data URIs:
  ```python
  import base64, pathlib
  def to_data_uri(path):
      data = pathlib.Path(path).read_bytes()
      mime = "image/png" if str(path).lower().endswith(".png") else "image/jpeg"
      return f"data:{mime};base64,{base64.b64encode(data).decode()}"
  # then: <img src="{{to_data_uri('fig1.png')}}" class="fig-full" alt="...">
  ```
- **Vector figures (SVG)** → inline the `<svg>...</svg>` element directly (smaller than base64 PNG, stays crisp).
- **Author photos** → same treatment: base64-embed; if no photo is available, omit the `<img>` entirely rather than linking to a remote URL.
- **No `slide/assets/` directory** should be created. Convert PDFs to PNG in a temp location, base64 it, then discard.

CDN links for Reveal.js/MathJax/Google Fonts are the one allowed exception — those are infrastructure, not content. Everything that is *content of the paper* must be inlined.

---

## Step 4 — PDF Export (on request)

When the user asks for a PDF version, render `slide/<slug>.html` via [Decktape](https://github.com/astefanutti/decktape) (headless Chrome → fixed-size pages):

```bash
npm install -g decktape                                          # one-time
decktape reveal --size 1280x720 slide/<slug>.html slide/<slug>.pdf
```

Decktape walks every `<section>` and writes one fixed-size page per slide. Unlike the HTML view, **PDF pages cannot scroll** — content that overflows the viewport is silently clipped. The HTML's `overflow-y: auto` on `.reveal .slides section` is a safety net for HTML viewing only; in PDF it does nothing.

### One section per page; split if overflowing

Before exporting, audit each slide for fit. Any section that does not fit a single 1280×720 page must be split at logical section boundaries *before* the export. Splitting rules:

- **Description + Analysis exceeds the page** → slide A = figure + Description, slide B = Analysis + caveats. Keep the same `<h2>` headline; the second slide carries it verbatim with no "(cont.)" suffix.
- **Multi-panel figures** → one panel per slide; share the headline; subordinate the panel label to a `<h3>` (e.g. *Panel A: by income decile*).
- **Figure + regression table** → figure on slide A, table on slide B.
- **Long bulleted lists** → split at the first natural `<h3>` boundary (e.g. between *Mechanism* and *Heterogeneity*). Each `<h3>` block belongs to exactly one slide; never let an `<h3>` straddle a page break.
- **Wide tables** → split by row group (one result type per slide) or move overflow to an appendix slide. Do not shrink the font below `var(--fs-small)` to force fit.

Rule: every `<h3>` subheading lives on one and only one page in the PDF.

### Audit checklist before exporting

Open the HTML in a browser. For each `<section>`, scroll its body. Any section that requires scrolling to read all content **must be split** before running Decktape — scroll-fit and print-fit are different problems.

- All figures fit within `max-height: 400px` (`.fig-full`) or `360px` (`.col-7-5` right cell).
- No `<section>` body exceeds the 650px viewport at the default 1280×720 page size.
- Tables that span more rows than fit are split at logical row boundaries.
- Each slide has at most one `<h2>` and a small number of `<h3>` blocks.
- Callout boxes and code blocks fit without their bottom edge being clipped.

After the audit + splits, re-run Decktape. The resulting PDF should have one self-contained slide per page with no clipped content.

---

## Author Bio Format

For each author (in order):
1. Name as heading
2. Photo — circular crop; search faculty/personal site first; omit if unavailable
3. Position and institution (rank + department + school)
4. Post-PhD working experience (if any fellowship, postdoc, industry, or visiting role)
5. PhD program and graduation year
6. Bachelor's degree — only if author is Chinese (mainland/Taiwan/HK) OR non-econ/business major
7. Research interests — 3–5 keywords

---

## Reveal.js Template

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>{{Paper Title}}</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@5/dist/reset.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@5/dist/reveal.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@5/dist/theme/white.css">
  <style>
    /* ===========================================================
       Paste the full design-system CSS here from the
       "Aesthetic & Animation Guidelines" section below — sections
       1–6 in order: design tokens (:root), base overrides, layout
       grids, figures, tables, callouts, author grid, animation.
       The Aesthetic & Animation Guidelines section is the
       canonical source; do not maintain a second copy here.

       Author-grid block (only needed on the Author Bios slide):
         .author-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: var(--sp-5); }
         .author-card img { width: 80px; height: 80px; border-radius: 50%;
                             object-fit: cover; border: var(--border); box-shadow: var(--shadow-xs); }
         .author-card h3 { font-size: var(--fs-h3); font-weight: 700;
                             margin: var(--sp-2) 0 var(--sp-1); color: var(--c-ink); }
         .author-card p  { font-size: var(--fs-small); margin: 2px 0; color: var(--c-ink-soft); }
       =========================================================== */
  </style>
</head>
<body>
<div class="reveal">
  <div class="slides">

    <!-- 1. Title -->
    <section>
      <h2>{{Full Paper Title}}</h2>
      <p>{{Author 1}} ({{Affiliation}}), {{Author 2}} ({{Affiliation}}), {{Author 3}} ({{Affiliation}})</p>
      <p><em>{{Journal}}, {{Year}}</em></p>
    </section>

    <!-- 2. Author Bios -->
    <section>
      <h2>Author Bios</h2>
      <div class="author-grid">
        <div class="author-card">
          <img src="{{photo_url_1}}" alt="{{Name 1}}">
          <h3>{{Name 1}}</h3>
          <p>{{Position}}, {{Institution}}</p>
          <p>PhD, {{University}} ({{Year}})</p>
          <p>{{Research interests}}</p>
        </div>
        <!-- repeat for each author -->
      </div>
    </section>

    <!-- 3. Outline -->
    <section>
      <h2>Outline</h2>
      <ul>
        <li><strong>{{Section title ≤5 words}}</strong> — {{One sentence on finding or method}}</li>
        <!-- omit motivation, data, identification from outline -->
        <li style="color:#999">Takeaways &amp; Discussion</li>
      </ul>
    </section>

    <!-- 4. Data & Setting -->
    <section>
      <h2>Data &amp; Setting</h2>
      <h3>Sample construction</h3>
      <table>
        <tr><th>Step</th><th>N</th><th>% of raw</th></tr>
        <!-- one row per filtering step -->
      </table>
      <!-- If LLM annotation present: -->
      <h3>LLM Classification Pipeline</h3>
      <div class="callout callout-warn">
        ⚠ <strong>Quality concern</strong>: LLMs can hallucinate or apply inconsistent criteria at scale.
        Validate: sample size reviewed, inter-rater agreement, gold standard comparison?
      </div>
      <pre><code>{{Actual prompt verbatim — Step N}}</code></pre>
    </section>

    <!-- 5. Identification -->
    <!-- Skip the empirical specification for canonical DiD/IV/RD — show only if
         the paper deviates (staggered DiD, shift-share IV, fuzzy RD, etc.). -->
    <section>
      <h2>Identification</h2>
      <h3>1. Challenge</h3>
      <p>{{What the naive OLS estimator gets wrong and why}}</p>
      <h3>2. Strategy</h3>
      <p>{{Source of variation; why plausibly exogenous}}</p>
      <h3>3. Assumptions to Discuss</h3>
      <ul>
        <li><strong>{{Assumption 1}}</strong>: {{statement}} — diagnostic: {{test/plot}}</li>
        <li><strong>{{Assumption 2}}</strong>: {{statement}} — diagnostic: {{test/plot}}</li>
      </ul>
      <div class="callout callout-tip">
        Discussion: Is each assumption credible here? What stories would violate it?
      </div>
    </section>

    <!-- 6–N. Results — one fact per slide; slide scrolls if content overflows -->
    <!-- Description + Analysis must describe ONLY the figure/table on this slide:
         every bullet should be readable off the displayed asset. Do not bring in
         numbers from other tables, robustness checks, or general framing — those
         belong on their own slides. See report.md §3+ (compressed for slides). -->

    <!-- Single figure: use .fig-full -->
    <section>
      <h2>{{Single fact stated as a sentence}}</h2>
      <img src="{{original_figure_path}}" class="fig-full" alt="{{figure caption}}">
      <h3>Description</h3>
      <ul>
        <li><strong>{{Pattern}}</strong>: {{observable trend / number / direction}}</li>
        <li><strong>{{Magnitude}}</strong>: {{point estimate}} ({{SE or 95% CI}})</li>
      </ul>
      <h3>Analysis</h3>
      <ul>
        <li><strong>{{Practical significance}}</strong>: {{benchmark or threshold comparison}}</li>
        <li><strong>{{Caveat}}</strong>: {{main threat or scope limit}}</li>
      </ul>
    </section>

    <!-- Figure + commentary: use .col-7-5 -->
    <section>
      <h2>{{Single fact stated as a sentence}}</h2>
      <div class="col-7-5">
        <div>
          <h3>Description</h3>
          <ul>
            <li><strong>{{Pattern}}</strong>: {{what the figure shows}}</li>
            <li><strong>{{Magnitude}}</strong>: {{number with units}}</li>
          </ul>
          <h3>Analysis</h3>
          <ul>
            <li><strong>{{Mechanism}}</strong>: {{why → consequence}}</li>
            <li><strong>{{Caveat}}</strong>: {{threat or scope}}</li>
          </ul>
          <div class="callout callout-result">★ {{Headline number with units and benchmark}}</div>
        </div>
        <img src="{{original_figure_path}}" class="fig-side" alt="{{figure caption}}">
      </div>
    </section>

    <!-- Takeaways & Discussion -->
    <section>
      <h2>Takeaways &amp; Discussion</h2>
      <h3>Takeaways</h3>
      <ul>
        <li>{{Takeaway 1}}</li>
        <li>{{Takeaway 2}}</li>
        <li>{{Takeaway 3}}</li>
      </ul>
      <h3>Discussion Questions</h3>
      <ol>
        <li>{{Q1}}</li>
        <li>{{Q2}}</li>
        <li>{{Q3}}</li>
        <li>{{Q4}}</li>
        <li>{{Q5}}</li>
      </ol>
    </section>

  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/reveal.js@5/dist/reveal.js"></script>
<script src="https://cdn.jsdelivr.net/npm/reveal.js@5/plugin/math/math.js"></script>
<script>
  Reveal.initialize({
    hash: true,
    plugins: [RevealMath.MathJax3],
    math: { mathjax: "https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js" }
  });
</script>
</body>
</html>
```

---

## Aesthetic & Animation Guidelines

All tokens below go in the `<style>` block of every generated slide. Copy the full block; swap palette variables per deck.

### 1. Design System Tokens

```css
:root {
  /* Palette — Academic Blue */
  --c-primary:      #0046AD;
  --c-primary-soft: #e6efff;
  --c-accent:       #ffd84d;  /* sticker yellow */
  --c-coral:        #ff5b3d;  /* key-result callout */
  --c-mint:         #14b888;  /* tip callout */
  --c-ink:          #0a0a0a;
  --c-ink-soft:     #4a4a4a;
  --c-ink-mute:     #8a8a8a;
  --c-paper:        #ffffff;
  --c-paper-warm:   #f7f5f0;
  --c-line:         #ebe6dc;

  /* Typography */
  --font-display: 'Plus Jakarta Sans', system-ui, sans-serif;
  --font-body:    'Plus Jakarta Sans', system-ui, sans-serif;
  --font-mono:    ui-monospace, 'JetBrains Mono', Consolas, monospace;
  --fs-h1:    clamp(1.6rem, 4vw,   2.4rem);
  --fs-h2:    clamp(1.1rem, 2.5vw, 1.6rem);
  --fs-h3:    clamp(0.9rem, 2vw,   1.2rem);
  --fs-body:  clamp(0.75rem, 1.5vw, 1rem);
  --fs-small: clamp(0.65rem, 1vw,  0.82rem);
  --ease-expo: cubic-bezier(0.16, 1, 0.3, 1);

  /* Spacing (4px base scale) */
  --sp-1: 4px;  --sp-2: 8px;  --sp-3: 12px; --sp-4: 16px;
  --sp-5: 24px; --sp-6: 32px; --sp-7: 48px; --sp-8: 64px;

  /* Borders & shadows — neo-brutalist flat offset */
  --border-w: 2px;
  --border:   var(--border-w) solid var(--c-ink);
  --radius-sm: 6px; --radius-md: 10px; --radius-lg: 16px;
  --shadow-xs: 2px 2px 0 var(--c-ink);
  --shadow-sm: 3px 3px 0 var(--c-ink);
  --shadow-md: 4px 4px 0 var(--c-primary);
}
```

Load Plus Jakarta Sans from Google Fonts — add in `<head>` before stylesheets:
```html
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;700;800&display=swap" rel="stylesheet">
```

---

### 2. Base Slide Overrides

```css
.reveal .slides section {
  text-align: left; height: 650px; overflow-y: auto;
  font-family: var(--font-body); font-size: var(--fs-body); line-height: 1.5;
  padding: var(--sp-6) var(--sp-7);
  background: var(--c-paper);
}
.reveal h2 {
  font-size: var(--fs-h1); font-weight: 800; letter-spacing: -0.025em;
  color: var(--c-primary); margin-bottom: var(--sp-4);
  border-bottom: 1px solid var(--c-line); padding-bottom: var(--sp-2);
}
.reveal h3 {
  font-size: var(--fs-h3); font-weight: 700;
  color: var(--c-ink); margin: var(--sp-4) 0 var(--sp-2);
}
.reveal p, .reveal li { color: var(--c-ink-soft); }
.reveal strong { color: var(--c-ink); font-weight: 700; }
code { font-family: var(--font-mono); font-size: 0.88em;
       background: var(--c-primary-soft); padding: 1px 5px; border-radius: 4px; }
```

---

### 3. Layout Patterns

Named column grids — wrap slide content in the appropriate div:

| Class | Columns | Use case |
|---|---|---|
| `.col-full` | block | Single figure or table |
| `.col-7-5` | `7fr 5fr` | Text left, figure right |
| `.col-6-6` | `1fr 1fr` | Two equal result columns |
| `.col-3` | `repeat(3, 1fr)` | Three mechanism cards |

```css
.col-7-5, .col-6-6, .col-3 {
  display: grid; gap: var(--sp-5) var(--sp-6); align-items: start;
}
.col-7-5 { grid-template-columns: 7fr 5fr; }
.col-6-6 { grid-template-columns: 1fr 1fr; }
.col-3   { grid-template-columns: repeat(3, 1fr); }
@media (max-width: 700px) {
  .col-7-5, .col-6-6, .col-3 { grid-template-columns: 1fr; }
}
```

---

### 4. Figure & Table Sizing

**Figures**
- Full-width (main result): `width: 100%; max-height: 400px; object-fit: contain; border: var(--border); border-radius: var(--radius-sm); box-shadow: var(--shadow-xs);`
- In `.col-7-5` right cell: natural width, `max-height: 360px; object-fit: contain;`
- Thumbnail grid: `height: 180px; width: 100%; object-fit: cover;`

**Tables**

```css
.reveal table {
  width: 100%; border-collapse: collapse;
  font-size: var(--fs-small); line-height: 1.4;
  border: var(--border); border-radius: var(--radius-sm); overflow: hidden;
}
.reveal table th {
  background: var(--c-primary); color: #fff;
  padding: var(--sp-2) var(--sp-3);
  font-family: var(--font-display); font-weight: 700;
  text-align: left; letter-spacing: 0.03em;
}
.reveal table td {
  padding: var(--sp-2) var(--sp-3);
  border-bottom: 1px solid var(--c-line);
  color: var(--c-ink-soft);
}
.reveal table tr:nth-child(even) td { background: var(--c-paper-warm); }
.reveal table tr:last-child td     { border-bottom: none; }
```

---

### 5. Callout Variants

Replace the single `.amber` class with three semantic variants:

```css
.callout {
  border-radius: var(--radius-md); border: var(--border-w) solid;
  padding: var(--sp-3) var(--sp-4); margin: var(--sp-3) 0;
  font-size: var(--fs-small); line-height: 1.5;
}
.callout-warn   { background: #fef9f0; border-color: #b45309; box-shadow: var(--shadow-sm); }
.callout-result { background: #fff1ef; border-color: var(--c-coral); box-shadow: 3px 3px 0 var(--c-coral); }
.callout-tip    { background: #f0fdf8; border-color: var(--c-mint);  box-shadow: 3px 3px 0 var(--c-mint); }
```

Usage:
- `.callout-warn` — LLM quality concern, identification threat (replaces `.amber`)
- `.callout-result` — headline finding worth emphasis
- `.callout-tip` — methodological note, "what to look for"

Example:
```html
<div class="callout callout-warn">
  ⚠ <strong>Quality concern</strong>: LLMs can hallucinate or apply inconsistent criteria at scale.
  Validate: sample size reviewed, inter-rater agreement, gold standard comparison?
</div>
```

---

### 6. Animation

```css
.reveal .fragment.fade-up {
  opacity: 0; transform: translateY(16px);
  transition: opacity 0.28s var(--ease-expo), transform 0.28s var(--ease-expo);
}
.reveal .fragment.fade-up.visible { opacity: 1; transform: none; }

/* Staggered list — set style="--i:0" style="--i:1" etc. on each <li> */
.reveal li {
  animation: li-in 0.3s var(--ease-expo) both;
  animation-delay: calc(var(--i, 0) * 0.07s);
}
@keyframes li-in { from { opacity:0; transform:translateY(12px); } to { opacity:1; transform:none; } }

@media (prefers-reduced-motion: reduce) {
  *, .reveal .fragment { animation: none !important; transition: none !important; }
}
```

---

## Identification Slide — Assumptions by Strategy

For canonical DiD / IV / RD, **skip the empirical specification** . Spend the slide on the assumptions and what would violate them. Show the spec only if the paper uses a non-standard variant (staggered DiD with heterogeneous timing, shift-share IV, fuzzy RD, recentered IV, etc.).

### DiD — Difference-in-Differences

Following Chiu, Lan, Liu, Xu (2023, *APSR*). Two assumptions, not five — **parallel trends** and **no anticipation** are the testable manifestations of strict exogeneity, so discuss them under one heading:

| Assumption | Statement | Diagnostic / how violated |
|---|---|---|
| **Strict exogeneity** *(parallel trends + no anticipation)* | Treatment assignment is independent of the unobserved shocks in **any** period, conditional on FEs and covariates. Implies (i) **parallel trends**: absent treatment, treated and control would have evolved on the same trend; (ii) **no anticipation**: future treatment does not affect today's potential outcomes. | **PT diagnostic:** pre-trend event-study plot, placebo periods, honest-DiD / Rambachan-Roth sensitivity bounds. **No-anticipation diagnostic:** pre-period coefficients ≈ 0; institutional knowledge of announcement vs. implementation timing. **Substantive argument:** is the policy timing plausibly orthogonal to unit-level shocks (no Ashenfelter dip, no selection-on-shocks)? |
| **SUTVA / no spillovers** | Control units are unaffected by treatment of treated units. | Spatial / network proximity to treated; ring-buffer robustness; geography of the policy. |

### IV — Instrumental Variables

Independence and exclusion are typically discussed together as **instrument validity** (Angrist-Pischke); keep them merged unless the paper invokes them separately.

| Assumption | Statement | Diagnostic / how violated |
|---|---|---|
| **Instrument validity** *(independence + exclusion)* | $Z$ is as-good-as-randomly assigned conditional on controls, AND affects $Y$ only through $X$. | **Untestable** — argue from institutional knowledge. Support with balance on pre-determined covariates and placebo outcomes that should be unaffected. Discuss alternative pathways from $Z$ to $Y$. |
| **Relevance** | $Z$ predicts $X$ (first stage non-zero). | First-stage F-stat (rule of thumb F > 10; tF / Lee 2022 for weak-IV-robust inference). |
| **Monotonicity** *(for LATE)* | No "defiers" — $Z$ moves $X$ in the same direction for everyone. | Untestable; argue from setting. Without it, the estimand is not LATE. |

### RD — Regression Discontinuity

Continuity and no-manipulation are two sides of the same identifying claim — manipulation is the canonical way continuity fails — so discuss them together.

| Assumption | Statement | Diagnostic / how violated |
|---|---|---|
| **Continuity at the cutoff** *(no manipulation)* | Potential outcomes $E[Y(0) \mid r]$ and $E[Y(1) \mid r]$ are continuous in $r$ at $c$; equivalently, units cannot precisely manipulate $r$ to land on the desired side. | McCrary / Cattaneo-Jansson-Ma density test for sorting; smoothness of pre-determined covariates at $c$; any other determinant of $Y$ that jumps at $c$ violates it. |

### Experiment / RCT

| Assumption | Statement | Diagnostic / how violated |
|---|---|---|
| **Random assignment** | Treatment is statistically independent of potential outcomes. | Covariate balance table; randomization protocol; compliance and attrition by arm (LATE via IV if non-compliance is non-trivial). |
| **SUTVA / no spillovers** | No interference between units; one version of treatment. | Network / cluster structure; spillover-robust design. |

**Discussion questions** should follow the relevant field's norms (from Journals Covered):

| Journal | Discussion emphasis |
|---|---|
| AER | Identification validity and external validity |
| Marketing Science (Frontiers) | Behavioral mechanisms and managerial implications |
| Management Science | Information systems / operational mechanisms |
| PNAS / Science | Broader societal significance |

---

## Report

See [Report format](report.md).

**Definition (measure):** Paper (title, authors, venue, year); output path `slide/<slug>.html`; N slides generated.  
**Analyses:** Sections covered; figure sourcing method (TeX source / PDF extraction / placeholder); whether `notes/<slug>.md` was produced first.  
**Takeaway:** Any missing assets (photos, figures, formulas) or identification assumptions that require human input before the slides are presentation-ready.
