---
name: slide
description: Use when generating Reveal.js reading-group slides from a paper PDF or TeX source — TeX route reads source directly; PDF-only route runs MinerU extraction first, then proceeds. Default output slide/<slug>.html; PDF export via Decktape only on explicit request. Aesthetic aligned with the personal Monet/Hokusai brand (Lora display, Inter body, dusty-blue chrome with Hokusai-crimson accent) so embedded figures from data-visualization.md sit calmly inside slide chrome.
allowed-tools: Read, Edit, Write, Bash
user-invocable: true
invocation: auto
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

- **TeX available**: read the `.tex` files directly. Extract equations, table source, and figure paths from source — no extraction script needed.
- **PDF only**: run MinerU (Step 1) to produce markdown, structured tables, and figure PNGs.

Generate slides only when explicitly requested. Default to Reveal.js HTML; use Beamer (`slide/<slug>.tex`) only if TeX is requested. Export to PDF only when asked — Step 4.

---

## Step 1 — Extract PDF Text

Install (one-time; downloads ~3–5 GB of model weights on first run): `pip install magic-pdf`.

```python
import json, pathlib, subprocess

def extract_paper(pdf_path: str, slug: str) -> dict:
    out_dir = pathlib.Path("paper") / slug
    out_dir.mkdir(parents=True, exist_ok=True)
    subprocess.run(["magic-pdf", "-p", pdf_path, "-o", str(out_dir), "-m", "auto"], check=True)

    stem = pathlib.Path(pdf_path).stem
    auto_dir = out_dir / stem / "auto"
    return {
        "markdown":    (auto_dir / f"{stem}.md").read_text(encoding="utf-8"),
        "content":     json.loads((auto_dir / f"{stem}_content_list.json").read_text(encoding="utf-8")),
        "figures_dir": auto_dir / "images",
    }
```

`content` item types used downstream: `{"type": "table", "table_body": [[...]], "img_path": ...}` (use `table_body` for slide tables); `{"type": "image", "img_path": ..., "img_caption": ...}` (figure PNGs); `{"type": "equation", "text": "$$...$$"}` (LaTeX for the identification slide).

---

## Step 2 — Reading Notes

Before generating slides, produce structured reading notes at `notes/<slug>.md` covering: one-liner, research question, data, identification strategy, key results, mechanisms, discussion questions. Read the full extracted text first — include specific numbers, not vague summaries.

---

## Step 3 — Slide Structure (12–16 slides)

### The 7-slide skeleton

| # | Slide | Notes |
|---|---|---|
| 1 | **Title** | Full title; authors + affiliations; journal + year or "Working Paper". *Optional:* one-sentence headline finding in a `.callout-result`. |
| 2 | **Author Bios** | 3-column grid; circular photo + position + PhD + research interests. |
| 3 | **Outline** | Substantive sections only — skip motivation, data, ID; bold title + one sentence each. |
| 4 | **Data & Setting** | Filtering pipeline with N and %; LLM annotation steps with warn callout. |
| 5 | **Identification** | Challenge → strategy → assumptions to discuss. |
| 6–N | **Results** | **One fact per slide**; reproduce original table/figure; pair with brief **Description + Analysis**. If a fact carries heavy content, **split across 2–3 slides**. Required for PDF export — Step 4. |
| N+1 | **Takeaways & Discussion** | 3 bullet takeaways then 5 discussion questions. |

Include an **Analytical Model** slide immediately before Results if the paper has a formal model.

### Equations get a symbol gloss

Every displayed equation (MathJax `$$…$$`, the empirical specification, the model) must be followed by a 2–3 bullet inline gloss naming each non-trivial symbol. Without it a reading-group audience cannot follow the math at slide pace.

```html
<p>$$P_{ijt} = \alpha_i + \beta Q_{jt} + \gamma X_{ijt} + \varepsilon_{ijt}$$</p>
<ul class="gloss">
  <li><strong>$P_{ijt}$</strong>: price paid by household $i$ for product $j$ in week $t$</li>
  <li><strong>$Q_{jt}$</strong>: weekly category-level demand shock</li>
  <li><strong>$\alpha_i$</strong>: household fixed effect</li>
</ul>
```

Skip the gloss only for textbook identities ($E[Y \mid X]$) where every symbol is fully standard.

### Figure and table sourcing — tiered policy

1. **TeX available** → rebuild **tables** as HTML from source; for **figures**, browsers will not render `<img src="*.pdf">`, so convert each `\includegraphics` PDF/EPS to PNG first.

   ```bash
   pdftoppm -png -r 200 figures/fig1.pdf /tmp/fig1   # → /tmp/fig1-1.png
   ```

   Preferred for journal-grade fidelity — PyMuPDF at 2.5× zoom (sharper than `-r 200`):

   ```python
   import fitz
   def render_figure(pdf_path: str, out_png: str, zoom: float = 2.5) -> None:
       page = fitz.open(pdf_path).load_page(0)
       page.get_pixmap(matrix=fitz.Matrix(zoom, zoom), alpha=False).save(out_png)
   ```

2. **PDF only** → use MinerU output: `figures_dir/` for PNGs, `content` list for table rows.
3. **Extraction fails** → insert `<!-- MANUAL: supply figure here -->` with a visible caveat block; tell the user which asset to provide. **Do not self-generate** a table or figure unless the user explicitly instructs it.

### Self-contained output — embed everything in the HTML

`slide/<slug>.html` must be a single self-contained file with no external asset references (no `slide/assets/`, no relative image paths).

- **Tables** → native `<table>` HTML (always — never an image of a table).
- **Raster figures (PNG/JPG)** → base64 data URIs:
  ```python
  import base64, pathlib
  def to_data_uri(path):
      data = pathlib.Path(path).read_bytes()
      mime = "image/png" if str(path).lower().endswith(".png") else "image/jpeg"
      return f"data:{mime};base64,{base64.b64encode(data).decode()}"
  ```
- **Vector figures (SVG)** → inline `<svg>...</svg>` (smaller than base64 PNG, stays crisp).
- **Author photos** → same: base64-embed; if no photo, omit `<img>` rather than linking remote.
- **No `slide/assets/` directory.** Convert PDFs to PNG in a temp location, base64 it, discard.

CDN links for Reveal.js / MathJax / Google Fonts are the one allowed exception — infrastructure, not content.

### Author Bios slide

For each author (in order): (1) name as heading, (2) circular photo (faculty/personal site first; omit if unavailable), (3) position + institution, (4) post-PhD experience if any, (5) PhD program + year, (6) bachelor's degree only if Chinese (mainland/Taiwan/HK) or non-econ/business major, (7) research interests — 3–5 keywords.

**Photo pipeline.** Empty grid cells make the slide feel under-built. Always try the pipeline before omitting:

1. **Find** — `WebSearch` for `"<author name>" <institution> faculty photo`.
2. **Fetch** — `WebFetch` the page, locate the headshot URL.
3. **Normalize + embed** — square-crop to 1:1, resize to 280×280, JPEG q=82, base64-embed:

   ```python
   from PIL import Image
   from io import BytesIO
   import base64, requests

   def author_photo_data_uri(url: str, size: int = 280) -> str:
       img = Image.open(BytesIO(requests.get(url, timeout=10).content)).convert("RGB")
       w, h = img.size; s = min(w, h)
       img = img.crop(((w-s)//2, (h-s)//2, (w+s)//2, (h+s)//2)).resize((size, size), Image.LANCZOS)
       buf = BytesIO(); img.save(buf, format="JPEG", quality=82, optimize=True)
       return "data:image/jpeg;base64," + base64.b64encode(buf.getvalue()).decode()
   ```

4. **Mark up** — `<img class="photo" src="{{data_uri}}" alt="{{name}}">` inside `.author-card`.

### Identification slide

For canonical DiD / IV / RD / RCT, **skip the empirical specification** — the audience knows it. Spend the slide on the assumption(s) most likely to fail and the diagnostic. Show the spec only for non-standard variants (staggered DiD, shift-share IV, fuzzy RD, recentered IV).

| Strategy | Identifying assumption | Standard diagnostic |
|---|---|---|
| **DiD** | Strict exogeneity (parallel trends + no anticipation) | Pre-trend event-study; honest-DiD bounds (Rambachan-Roth) |
| **IV** | Validity (independence + exclusion) + relevance | First-stage F (>10; tF / Lee 2022 for weak-IV); placebo outcomes; covariate balance |
| **RD** | Continuity / no manipulation at the cutoff | McCrary or Cattaneo-Jansson-Ma density; covariate smoothness at $c$ |
| **RCT** | Random assignment + SUTVA | Balance table; attrition by arm; spillover-robust design |

Always add a **SUTVA / no-spillovers** caveat for DiD and RCT when units are spatially or socially proximate. For IV-LATE, note the **monotonicity** assumption.

Slide layout: three `<h3>` blocks — *Challenge* → *Strategy* → *Assumptions to discuss* — closing with `.callout-tip`: "Discussion: Is each assumption credible here? What stories would violate it?"

### Reveal.js template

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>{{Paper Title}}</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Lora:ital,wght@0,400;0,600;0,700;1,400&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@5/dist/reset.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@5/dist/reveal.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@5/dist/theme/white.css">
  <style>/* paste the Aesthetic & animation system block — sections 1–5 — verbatim */</style>
</head>
<body>
<div class="reveal"><div class="slides">

  <!-- 1. Title — cream card, centered both axes -->
  <section class="slide-title">
    <div class="title-card">
      <h2>{{Full Paper Title}}</h2>
      <p class="title-authors">{{Author 1}} ({{Affiliation}}) &middot; {{Author 2}} ({{Affiliation}})</p>
      <p class="title-venue"><em>{{Journal}}, {{Year}}</em></p>
      <!-- Optional headline finding — uncomment when the paper has a punchy one-sentence result -->
      <!-- <div class="callout callout-result"><strong>★ {{One-sentence headline finding}}</strong></div> -->
    </div>
  </section>

  <!-- 2. Author Bios -->
  <section>
    <h2>Author Bios</h2>
    <div class="author-grid">
      <div class="author-card">
        <img class="photo" src="{{data_uri_1}}" alt="{{Name 1}}">
        <h3>{{Name 1}}</h3>
        <p>{{Position}}, {{Institution}}</p>
        <p>PhD, {{University}} ({{Year}})</p>
        <p>{{Research interests}}</p>
      </div>
      <!-- repeat .author-card for each author -->
    </div>
  </section>

  <!-- 3. Outline -->
  <section>
    <h2>Outline</h2>
    <ul>
      <li><strong>{{Section ≤5 words}}</strong> — {{One sentence on finding or method}}</li>
      <li style="color:var(--c-ink-mute)">Takeaways &amp; Discussion</li>
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
    <h3>LLM Classification Pipeline</h3>
    <div class="callout callout-warn">
      <strong>Quality concern</strong>: LLMs can hallucinate or apply inconsistent criteria at scale.
      Validate: sample size reviewed, inter-rater agreement, gold standard comparison?
    </div>
    <pre><code>{{Actual prompt verbatim}}</code></pre>
  </section>

  <!-- 5. Identification (skip empirical spec for canonical DiD/IV/RD) -->
  <section>
    <h2>Identification</h2>
    <h3>1. Challenge</h3>
    <p>{{What naive OLS gets wrong}}</p>
    <h3>2. Strategy</h3>
    <p>{{Source of variation; why plausibly exogenous}}</p>
    <h3>3. Assumptions to Discuss</h3>
    <ul>
      <li><strong>{{Assumption}}</strong>: {{statement}} — diagnostic: {{test/plot}}</li>
    </ul>
    <div class="callout callout-tip">
      Discussion: Is each assumption credible here? What stories would violate it?
    </div>
  </section>

  <!-- Results — one fact per slide. Description + Analysis must describe ONLY
       the figure/table on this slide; no numbers from other tables. -->

  <!-- Single figure: .fig-full -->
  <section>
    <h2>{{Single fact stated as a sentence}}</h2>
    <img src="{{data_uri}}" class="fig-full" alt="{{caption}}">
    <h3>Description</h3>
    <ul>
      <li><strong>{{Pattern}}</strong>: {{trend / number / direction}}</li>
      <li><strong>{{Magnitude}}</strong>: {{point estimate}} ({{SE or 95% CI}})</li>
    </ul>
    <h3>Analysis</h3>
    <ul>
      <li><strong>{{Practical significance}}</strong>: {{benchmark comparison}}</li>
      <li><strong>{{Caveat}}</strong>: {{main threat or scope limit}}</li>
    </ul>
  </section>

  <!-- Figure + commentary: .col-7-5 -->
  <section>
    <h2>{{Single fact stated as a sentence}}</h2>
    <div class="col-7-5">
      <div>
        <h3>Description</h3>
        <ul><li><strong>{{Pattern}}</strong>: {{what it shows}}</li>
            <li><strong>{{Magnitude}}</strong>: {{number with units}}</li></ul>
        <h3>Analysis</h3>
        <ul><li><strong>{{Mechanism}}</strong>: {{why → consequence}}</li>
            <li><strong>{{Caveat}}</strong>: {{threat or scope}}</li></ul>
        <div class="callout callout-result"><strong>★ {{Headline number with units and benchmark}}</strong></div>
      </div>
      <img src="{{data_uri}}" class="fig-side" alt="{{caption}}">
    </div>
  </section>

  <!-- Takeaways & Discussion -->
  <section>
    <h2>Takeaways &amp; Discussion</h2>
    <h3>Takeaways</h3>
    <ul><li>{{T1}}</li><li>{{T2}}</li><li>{{T3}}</li></ul>
    <h3>Discussion Questions</h3>
    <ol><li>{{Q1}}</li><li>{{Q2}}</li><li>{{Q3}}</li><li>{{Q4}}</li><li>{{Q5}}</li></ol>
  </section>

</div></div>
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

### Aesthetic & animation system

Aligned with the personal Monet/Hokusai brand — dusty-blue chrome, warm cream paper, Hokusai-crimson accent. Embedded figures from `data-visualization.md` sit calmly inside this chrome instead of fighting it.

#### 1. Design system tokens

```css
:root {
  /* Palette — Monet/Hokusai-aligned (matches data-visualization.md brand) */
  --c-primary:      #2E4A75;  /* Hokusai-Prussian deep — headings, h2 underline */
  --c-primary-soft: #EFE6D2;  /* warm cream — code background, soft fills */
  --c-accent:       #A03830;  /* Hokusai crimson — single high-emphasis */
  --c-warn:         #C9824D;  /* Hokusai ochre — warn callout */
  --c-mint:         #9CAF88;  /* Monet sage — tip callout */
  --c-ink:          #1A1A1A;
  --c-ink-soft:     #4A4A4A;
  --c-ink-mute:     #8A8A8A;
  --c-paper:        #FFFFFF;
  --c-paper-warm:   #EFE6D2;
  --c-line:         #D4CDB8;

  /* Typography — Lora display + Inter body. Lora matches the personal website
     identity; Inter holds at slide font sizes where Lora's serifs muddy. */
  --font-display: 'Lora', Georgia, 'Times New Roman', serif;
  --font-body:    'Inter', system-ui, sans-serif;
  --font-mono:    ui-monospace, 'JetBrains Mono', Consolas, monospace;

  /* Tuned for projection (≥24px body); HTML view scrolls when slides exceed
     720px, PDF export still requires the §4 splits. */
  --fs-h1:    clamp(2.2rem,  5.0vw, 3.3rem);    /* 53px @1280 */
  --fs-h3:    clamp(1.25rem, 2.5vw, 1.6rem);    /* 25.6px */
  --fs-body:  clamp(1.15rem, 2.1vw, 1.4rem);    /* 22.4px */
  --fs-small: clamp(0.95rem, 1.5vw, 1.2rem);    /* 19.2px */
  --ease-expo: cubic-bezier(0.16, 1, 0.3, 1);

  /* Spacing (4px base) */
  --sp-1: 4px;  --sp-2: 8px;  --sp-3: 12px; --sp-4: 16px;
  --sp-5: 24px; --sp-6: 32px; --sp-7: 48px; --sp-8: 64px;

  /* Borders & shadows — soft drop shadow over thin border. Replaces the
     earlier brutalist offset. */
  --border:   1.5px solid var(--c-ink);
  --radius-sm: 6px; --radius-md: 10px;
  --shadow-xs: 0 1px 2px rgba(0,0,0,0.08);
  --shadow-sm: 0 2px 4px rgba(0,0,0,0.10);
}
```

Load fonts in `<head>` before stylesheets (already in the template above).

#### 2. Base slide overrides

When body and display fonts differ, **explicitly assign `var(--font-display)` to every heading-like element** — `h2`, `h3`, `table th`, `.author-card h3`. Without explicit assignment, headings inherit the body font and the display/body distinction collapses.

```css
.reveal .slides section {
  text-align: left; height: 720px; overflow-y: auto;
  font-family: var(--font-body); font-size: var(--fs-body); line-height: 1.5;
  padding: var(--sp-6) var(--sp-7);
  background: var(--c-paper);
}
.reveal h2 {
  font-family: var(--font-display);
  font-size: var(--fs-h1); font-weight: 700; letter-spacing: -0.015em;
  color: var(--c-primary); margin-bottom: var(--sp-4);
  border-bottom: 1px solid var(--c-line); padding-bottom: var(--sp-2);
}
.reveal h3 {
  font-family: var(--font-display);
  font-size: var(--fs-h3); font-weight: 600;
  color: var(--c-ink); margin: var(--sp-4) 0 var(--sp-2);
}
.reveal p, .reveal li { color: var(--c-ink-soft); }
.reveal strong { color: var(--c-ink); font-weight: 600; }
code { font-family: var(--font-mono); font-size: 0.88em;
       background: var(--c-primary-soft); padding: 1px 5px; border-radius: 4px; }
```

#### 3. Layouts, figures, tables

Named column grids — wrap slide content in the appropriate div:

| Class | Grid | Use case |
|---|---|---|
| `.col-full` | block | Single figure or table |
| `.col-7-5` | `7fr 5fr` | Text left, figure right |
| `.col-6-6` | `1fr 1fr` | Two equal result columns |
| `.col-3` | `repeat(3, 1fr)` | Three mechanism cards |

```css
.col-7-5, .col-6-6, .col-3 {
  display: grid; gap: var(--sp-5) var(--sp-6); align-items: stretch;
}
.col-7-5 { grid-template-columns: 7fr 5fr; }
.col-6-6 { grid-template-columns: 1fr 1fr; }
.col-3   { grid-template-columns: repeat(3, 1fr); }

.col-7-5 > *, .col-6-6 > *, .col-3 > * {
  display: flex; flex-direction: column; justify-content: center;
}
.col-7-5 img, .col-6-6 img, .col-3 img {
  max-height: 340px; width: auto; max-width: 100%;
  margin: 0 auto; object-fit: contain;
}
@media (max-width: 700px) {
  .col-7-5, .col-6-6, .col-3 { grid-template-columns: 1fr; }
}

/* Title slide — centered cream card so the title doesn't float in empty space */
.reveal .slides section.slide-title {
  display: flex; align-items: center; justify-content: center;
  text-align: center;
}
.title-card {
  background: var(--c-paper-warm);
  border: var(--border); border-radius: var(--radius-md);
  box-shadow: var(--shadow-sm);
  padding: var(--sp-7) var(--sp-8);
  max-width: 80%;
}
.title-card h2 {
  border-bottom: none; padding-bottom: 0;
  margin-bottom: var(--sp-5);
}
.title-card .title-authors { font-size: var(--fs-body);  color: var(--c-ink);      margin-bottom: var(--sp-3); }
.title-card .title-venue   { font-size: var(--fs-small); color: var(--c-ink-soft); margin: 0; }
.title-card .callout       { margin-top: var(--sp-5); text-align: left; }

/* Figures */
.fig-full {
  width: 100%; max-height: 400px; object-fit: contain;
  border: var(--border); border-radius: var(--radius-sm); box-shadow: var(--shadow-xs);
}

/* Tables */
.reveal table {
  width: 100%; border-collapse: collapse;
  font-size: var(--fs-small); line-height: 1.4;
  border: var(--border); border-radius: var(--radius-sm); overflow: hidden;
}
.reveal table th {
  background: var(--c-primary); color: var(--c-paper);
  padding: var(--sp-2) var(--sp-3);
  font-family: var(--font-display); font-weight: 600;
  text-align: left; letter-spacing: 0.02em;
}
.reveal table td {
  padding: var(--sp-2) var(--sp-3);
  border-bottom: 1px solid var(--c-line);
  color: var(--c-ink-soft);
}
.reveal table tr:nth-child(even) td { background: var(--c-paper-warm); }
.reveal table tr:last-child td     { border-bottom: none; }

/* Author bios grid */
.author-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: var(--sp-5); }
.author-card img.photo {
  width: 100%; max-width: 140px; aspect-ratio: 1 / 1;
  object-fit: cover; border-radius: 50%;
  border: var(--border); box-shadow: var(--shadow-xs);
}
.author-card h3 { font-family: var(--font-display); font-size: var(--fs-h3);
                  font-weight: 600; margin: var(--sp-2) 0 var(--sp-1); color: var(--c-ink); }
.author-card p  { font-size: var(--fs-small); margin: 2px 0; color: var(--c-ink-soft); }
```

**Layout selection:**

| Slide content | Layout |
|---|---|
| Single figure, no commentary | `.col-full` (just `<img class="fig-full">`) |
| Figure + short bullets | `.col-7-5` |
| Two parallel results | `.col-6-6` |
| Three mechanisms / panels | `.col-3` |
| Figure + table + interpretation | `.col-6-6` row; `.callout-result` *below* the row, never inside |

#### 4. Callouts

Three semantic variants — colors aligned with the brand:

```css
.callout {
  border-radius: var(--radius-md); border-width: 1.5px; border-style: solid;
  padding: var(--sp-3) var(--sp-4); margin: var(--sp-3) 0;
  font-size: var(--fs-small); line-height: 1.5;
  box-shadow: var(--shadow-xs);
}
.callout-warn   { background: #FAF3E8; border-color: var(--c-warn);   }  /* ochre */
.callout-result { background: #FCEFEC; border-color: var(--c-accent); }  /* crimson */
.callout-tip    { background: #F0F4EC; border-color: var(--c-mint);   }  /* sage */
```

Usage: `.callout-warn` for LLM quality concerns and identification threats; `.callout-result` for headline findings; `.callout-tip` for methodological notes.

#### 5. Animation

```css
.reveal .fragment.fade-up {
  opacity: 0; transform: translateY(16px);
  transition: opacity 0.28s var(--ease-expo), transform 0.28s var(--ease-expo);
}
.reveal .fragment.fade-up.visible { opacity: 1; transform: none; }

/* Staggered list — set style="--i:0", "--i:1", ... on each <li> */
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

## Step 4 — PDF Export (on request)

When the user asks for a PDF, render `slide/<slug>.html` via [Decktape](https://github.com/astefanutti/decktape) (headless Chrome → fixed-size pages):

```bash
npm install -g decktape                                          # one-time
decktape reveal --size 1280x720 slide/<slug>.html slide/<slug>.pdf
```

Decktape walks every `<section>` and writes one fixed-size page per slide. Unlike the HTML view, **PDF pages cannot scroll** — content overflowing the viewport is silently clipped. The HTML's `overflow-y: auto` is a safety net for HTML viewing only; in PDF it does nothing.

### Splitting rules

Audit each slide for fit before exporting. Any section that does not fit a single 1280×720 page must be split at logical boundaries:

- **Description + Analysis exceeds the page** → slide A = figure + Description, slide B = Analysis + caveats. Keep the same `<h2>`, no "(cont.)" suffix.
- **Multi-panel figures** → one panel per slide; share the headline; subordinate the panel label to `<h3>` (e.g. *Panel A: by income decile*).
- **Figure + regression table** → figure on slide A, table on slide B.
- **Long bulleted lists** → split at the first natural `<h3>` boundary. Each `<h3>` block belongs to exactly one slide; never let an `<h3>` straddle a page break.
- **Wide tables** → split by row group or move overflow to an appendix slide. Do not shrink the font below `var(--fs-small)`.

### Audit checklist

Open the HTML in a browser and scroll each `<section>`. Any section that needs scrolling must be split before Decktape runs:

- Each section fits 720px without scrolling (scroll-fit ≠ print-fit).
- Figures respect `max-height: 400px` (`.fig-full`) or `340px` (column cells).
- One `<h2>` per section; `<h3>` blocks don't straddle pages.
- Callouts and code blocks not clipped at the bottom.

After splits, re-run Decktape.

---

## Agent process notes

Two failure modes when editing slide HTML once it has many embedded figures. Both stem from the same root: base64-embedded assets blow up the file past what `Read` and `Edit` handle.

### Editing decks with embedded base64

**Do not** `Read` or `Edit` a slide HTML once it carries multiple base64 figures — `Read` fails on >25k-token files; a single full-resolution PNG data URI can be 30–80k tokens. Reaching for `Read`/`Edit` will silently truncate or error.

**Do** drop a one-off Python script under `.tmp_edit/` and run it:

```python
# .tmp_edit/patch_slide.py
from pathlib import Path
src = Path("slide/<slug>.html")
src.write_text(src.read_text(encoding="utf-8").replace("<old>", "<new>"), encoding="utf-8")
```

Treat `.tmp_edit/` as scratch — write, run, delete. Never commit.

### Inspecting deck structure without choking on base64

When you need to scan `<section>` boundaries, headings, or class names, skip base64 lines before printing — they're the only lines longer than a few hundred chars and contain no structural signal:

```python
from pathlib import Path
for i, ln in enumerate(Path("slide/<slug>.html").read_text(encoding="utf-8").splitlines(), 1):
    print(f"{i:>5}: <<base64 line, {len(ln)} chars>>" if "base64," in ln and len(ln) > 500 else f"{i:>5}: {ln}")
```

---

## Report

See [Report format](report.md).

**Definition:** Paper (title, authors, venue, year); output path `slide/<slug>.html`; N slides generated.
**Analyses:** Sections covered; figure sourcing method (TeX source / PDF extraction / placeholder); whether `notes/<slug>.md` was produced first.
**Takeaway:** Missing assets (photos, figures, formulas) or identification assumptions requiring human input before slides are presentation-ready.
