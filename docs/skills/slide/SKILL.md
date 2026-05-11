---
name: slide
description: Use when generating Reveal.js reading-group slides from a paper PDF or TeX source — TeX route reads source directly; PDF-only route runs MinerU extraction first, then proceeds. Default output slide/<slug>.html; PDF export via Decktape only on explicit request. Aesthetic aligned with the personal Monet/Hokusai brand (Lora display, Newsreader body, dusty-blue chrome with Hokusai-crimson accent) so embedded figures from the visualization skill sit calmly inside slide chrome.
allowed-tools: Read, Edit, Write, Bash
user-invocable: true
invocation: auto
---

Output paths:
- `slide/<slug>.html` — Reveal.js HTML (default).
- `slide/<slug>.pdf` — exported from the HTML via Decktape, **on request only** (see `references/pdf-export.md`).

Reference files:
- `references/aesthetics.md` — full brand styling spec (palette, fonts, layouts, callouts, animation, paper grain, Hokusai wave). Read this before writing the `<style>` block in the Reveal.js template — the template references tokens defined there.
- `references/pdf-export.md` — Decktape command, splitting rules, audit checklist. Read only when the user explicitly asks for a PDF.

---

## Workflow

```
TeX source provided  →  read directly        → reading notes → Reveal.js slides → [PDF on request]
PDF only             →  MinerU extraction    → reading notes → Reveal.js slides → [PDF on request]
```

- **TeX available**: read the `.tex` files directly. Extract equations, table source, and figure paths from source — no extraction script needed.
- **PDF only**: run MinerU (Step 1) to produce markdown, structured tables, and figure PNGs.

Generate slides only when explicitly requested. Default to Reveal.js HTML; use Beamer (`slide/<slug>.tex`) only if TeX is requested. Export to PDF only when asked — see `references/pdf-export.md`.

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
| 6–N | **Results** | **One fact per slide**; reproduce original table/figure; pair with brief **Description + Analysis**. If a fact carries heavy content, **split across 2–3 slides**. Required for PDF export — see `references/pdf-export.md`. |
| N+1 | **Takeaways & Discussion** | 3 bullet takeaways then 5 discussion questions. |

Include an **Analytical Model** slide immediately before Results if the paper has a formal model.

### Equations get a symbol gloss

Every displayed equation must (a) sit inside a `.eq` block — cream paper background with a Hokusai-Prussian left rule — and (b) be followed by a 2–3 bullet `.gloss` list naming each non-trivial symbol. Without the gloss a reading-group audience cannot follow the math at slide pace.

```html
<div class="eq">
  $$P_{ijt} = \alpha_i + \beta Q_{jt} + \gamma X_{ijt} + \varepsilon_{ijt}$$
</div>
<ul class="gloss">
  <li><strong>$P_{ijt}$</strong>: price paid by household $i$ for product $j$ in week $t$</li>
  <li><strong>$Q_{jt}$</strong>: weekly category-level demand shock</li>
  <li><strong>$\alpha_i$</strong>: household fixed effect</li>
</ul>
```

`.eq` is defined in `references/aesthetics.md` §4. MathJax (loaded by the Reveal.js template via `RevealMath.MathJax3`) renders the `$$…$$` content; standard LaTeX math syntax works (`\sum`, `\mathbf{}`, `\mathbb{1}`, `\sum_{w \neq -1}`, `\begin{aligned}…\end{aligned}` for multi-line, etc.).

Skip the gloss only for textbook identities ($E[Y \mid X]$) where every symbol is fully standard. Inline math (`$x$`) inside prose does not need a `.eq` wrapper — `.eq` is for display equations only.

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

The `<style>` block referenced by `<!-- paste styling block -->` below is defined in full in `references/aesthetics.md` — read that file before populating the inline styles. Tokens like `--c-primary`, `--font-display`, `.col-7-5`, `.callout-result`, `.hokusai-wave`, and the slide-entry animation are all defined there.

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>{{Paper Title}}</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Lora:ital,wght@0,400;0,600;0,700;1,400&family=Newsreader:ital,opsz,wght@0,6..72,400..700;1,6..72,400&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@5/dist/reset.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@5/dist/reveal.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@5/dist/theme/white.css">
  <style>/* paste the full styling system from references/aesthetics.md — sections 1–6 — verbatim */</style>
</head>
<body>
<div class="reveal"><div class="slides">

  <!-- 1. Title — cream card with a Hokusai wave ornament bleeding off bottom-right.
       The wave is the deck's wordmark; it does not repeat on other slides. -->
  <section class="slide-title">
    <svg class="hokusai-wave" viewBox="0 0 400 160" aria-hidden="true">
      <path d="M0,120 C60,40 120,40 180,120 C240,200 300,40 400,100 L400,160 L0,160 Z"
            fill="var(--c-primary)" opacity="0.85"/>
      <path d="M0,140 C60,80 130,80 200,140 C260,190 320,80 400,130 L400,160 L0,160 Z"
            fill="var(--c-accent)" opacity="0.75"/>
    </svg>
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

  <!-- 3. Outline — two-column numbered map. Reads as the trip plan, not a TOC. -->
  <section>
    <h2>Outline</h2>
    <ol class="outline-grid">
      <li><strong>{{Section ≤5 words}}</strong><span>{{One sentence on finding or method}}</span></li>
      <li><strong>{{Section}}</strong><span>{{…}}</span></li>
      <li><strong>{{Section}}</strong><span>{{…}}</span></li>
      <li class="outline-coda"><strong>Takeaways &amp; Discussion</strong><span>{{punchline + Qs}}</span></li>
    </ol>
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

---

## Step 4 — PDF Export (on request)

Only when the user explicitly asks for a PDF. The procedure (Decktape command, page-fit splitting rules, audit checklist) is in `references/pdf-export.md` — read that file when needed. Do not load it for HTML-only generations.

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

Output uses the Quick Template — three labeled lines, **Definition** / **Description** / **Takeaway**. (For multi-section writeups, see [report.md](../report.md).)

**Definition:** Paper (title, authors, venue, year); output path `slide/<slug>.html`; N slides generated.
**Analyses:** Sections covered; figure sourcing method (TeX source / PDF extraction / placeholder); whether `notes/<slug>.md` was produced first.
**Takeaway:** Missing assets (photos, figures, formulas) or identification assumptions requiring human input before slides are presentation-ready.
