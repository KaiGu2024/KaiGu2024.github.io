# Agent Skill: Slide Generation

Generate Reveal.js reading-group slides from a paper PDF. Follows the reading group slide template.

Output path: `slide/<slug>.html`

---

## Workflow

```
TeX source provided  →  read directly → reading notes → Reveal.js slides
PDF only             →  MinerU extraction (Step 1) → reading notes → Reveal.js slides
```

- **TeX available**: Read the `.tex` files directly. Extract equations, table source, and figure paths from source — no extraction script needed.
- **PDF only**: Run the MinerU extraction (Step 1) to produce markdown, structured tables, and figure PNGs, then proceed.

Generate slides only when explicitly requested. Default to the Reveal.js HTML format; use `slide/<slug>.tex` (Beamer / metropolis theme) only if TeX is requested.

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
| 1 | **Title** | Full title; authors + affiliations; journal + year or "Working Paper" |
| 2 | **Author Bios** | 3-column grid; photo (circular) + position + PhD + research interests |
| 3 | **Outline** | Substantive sections only — skip motivation, data, ID; one bold title + one sentence each |
| 4 | **Data & Setting** | Filtering pipeline with N and %; LLM annotation steps with amber callout boxes |
| 5 | **Identification** | Four sections: challenge → strategy → assumption & controls → empirical spec with LaTeX |
| 6–N | **Results** | One slide per major finding; reproduce original table/figure with annotations |
| N+1 | **Takeaways & Discussion** | 3 bullet takeaways then 5 discussion questions stacked vertically |

Include an **Analytical Model** slide immediately before Results if the paper has a formal model.

**Figure and table sourcing — tiered policy:**

1. **TeX available** → use figures/tables directly from source (preferred).
2. **PDF only** → use MinerU output: `figures_dir/` for figure PNGs, `content` list for table rows. Use extracted assets if successful.
3. **Extraction fails** → insert a `<!-- MANUAL: supply figure here -->` placeholder with a visible caveat block in the slide, and tell the user which asset to provide. **Do not self-generate** a table or figure unless the user explicitly instructs it.

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
    :root {
      --c-primary:      #0046AD;
      --c-primary-soft: #e6efff;
      --c-accent:       #ffd84d;
      --c-coral:        #ff5b3d;
      --c-mint:         #14b888;
      --c-ink:          #0a0a0a;
      --c-ink-soft:     #4a4a4a;
      --c-ink-mute:     #8a8a8a;
      --c-paper:        #ffffff;
      --c-paper-warm:   #f7f5f0;
      --c-line:         #ebe6dc;
      --font-display:   'Plus Jakarta Sans', system-ui, sans-serif;
      --font-body:      'Plus Jakarta Sans', system-ui, sans-serif;
      --font-mono:      ui-monospace, 'JetBrains Mono', Consolas, monospace;
      --fs-h1:    clamp(1.6rem, 4vw,   2.4rem);
      --fs-h2:    clamp(1.1rem, 2.5vw, 1.6rem);
      --fs-h3:    clamp(0.9rem, 2vw,   1.2rem);
      --fs-body:  clamp(0.75rem, 1.5vw, 1rem);
      --fs-small: clamp(0.65rem, 1vw,  0.82rem);
      --ease-expo: cubic-bezier(0.16, 1, 0.3, 1);
      --sp-1:4px; --sp-2:8px; --sp-3:12px; --sp-4:16px;
      --sp-5:24px; --sp-6:32px; --sp-7:48px; --sp-8:64px;
      --border-w: 2px;
      --border:   var(--border-w) solid var(--c-ink);
      --radius-sm: 6px; --radius-md: 10px; --radius-lg: 16px;
      --shadow-xs: 2px 2px 0 var(--c-ink);
      --shadow-sm: 3px 3px 0 var(--c-ink);
      --shadow-md: 4px 4px 0 var(--c-primary);
    }

    /* Base */
    .reveal .slides section {
      text-align: left; height: 650px; overflow-y: auto;
      font-family: var(--font-body); font-size: var(--fs-body); line-height: 1.5;
      padding: var(--sp-6) var(--sp-7); background: var(--c-paper);
    }
    .reveal h2 {
      font-size: var(--fs-h1); font-weight: 800; letter-spacing: -0.025em;
      color: var(--c-primary); margin-bottom: var(--sp-4);
      border-bottom: 1px solid var(--c-line); padding-bottom: var(--sp-2);
    }
    .reveal h3 { font-size: var(--fs-h3); font-weight: 700; color: var(--c-ink); margin: var(--sp-4) 0 var(--sp-2); }
    .reveal p, .reveal li { color: var(--c-ink-soft); }
    .reveal strong { color: var(--c-ink); font-weight: 700; }
    code { font-family: var(--font-mono); font-size: 0.88em; background: var(--c-primary-soft); padding: 1px 5px; border-radius: 4px; }

    /* Layout grids */
    .col-7-5, .col-6-6, .col-3 { display: grid; gap: var(--sp-5) var(--sp-6); align-items: start; }
    .col-7-5 { grid-template-columns: 7fr 5fr; }
    .col-6-6 { grid-template-columns: 1fr 1fr; }
    .col-3   { grid-template-columns: repeat(3, 1fr); }
    @media (max-width: 700px) { .col-7-5, .col-6-6, .col-3 { grid-template-columns: 1fr; } }

    /* Figures */
    .fig-full  { width: 100%; max-height: 400px; object-fit: contain; border: var(--border); border-radius: var(--radius-sm); box-shadow: var(--shadow-xs); }
    .fig-side  { width: 100%; max-height: 360px; object-fit: contain; }
    .fig-thumb { height: 180px; width: 100%; object-fit: cover; }

    /* Tables */
    .reveal table { width: 100%; border-collapse: collapse; font-size: var(--fs-small); line-height: 1.4; border: var(--border); border-radius: var(--radius-sm); overflow: hidden; }
    .reveal table th { background: var(--c-primary); color: #fff; padding: var(--sp-2) var(--sp-3); font-weight: 700; text-align: left; letter-spacing: 0.03em; }
    .reveal table td { padding: var(--sp-2) var(--sp-3); border-bottom: 1px solid var(--c-line); color: var(--c-ink-soft); }
    .reveal table tr:nth-child(even) td { background: var(--c-paper-warm); }
    .reveal table tr:last-child td     { border-bottom: none; }

    /* Callouts */
    .callout { border-radius: var(--radius-md); border: var(--border-w) solid; padding: var(--sp-3) var(--sp-4); margin: var(--sp-3) 0; font-size: var(--fs-small); line-height: 1.5; }
    .callout-warn   { background: #fef9f0; border-color: #b45309; box-shadow: var(--shadow-sm); }
    .callout-result { background: #fff1ef; border-color: var(--c-coral); box-shadow: 3px 3px 0 var(--c-coral); }
    .callout-tip    { background: #f0fdf8; border-color: var(--c-mint);  box-shadow: 3px 3px 0 var(--c-mint); }

    /* Author grid */
    .author-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: var(--sp-5); }
    .author-card img { width: 80px; height: 80px; border-radius: 50%; object-fit: cover; border: var(--border); box-shadow: var(--shadow-xs); }
    .author-card h3 { font-size: var(--fs-h3); font-weight: 700; margin: var(--sp-2) 0 var(--sp-1); color: var(--c-ink); }
    .author-card p  { font-size: var(--fs-small); margin: 2px 0; color: var(--c-ink-soft); }

    /* Animation */
    .reveal .fragment.fade-up { opacity: 0; transform: translateY(16px); transition: opacity 0.28s var(--ease-expo), transform 0.28s var(--ease-expo); }
    .reveal .fragment.fade-up.visible { opacity: 1; transform: none; }
    .reveal li { animation: li-in 0.3s var(--ease-expo) both; animation-delay: calc(var(--i, 0) * 0.07s); }
    @keyframes li-in { from { opacity:0; transform:translateY(12px); } to { opacity:1; transform:none; } }
    @media (prefers-reduced-motion: reduce) { *, .reveal .fragment { animation: none !important; transition: none !important; } }
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
    <section>
      <h2>Identification &amp; Estimation</h2>
      <h3>1. Identification Challenge</h3>
      <p>{{What the naive OLS estimator gets wrong and why}}</p>
      <h3>2. Strategy</h3>
      <p>{{Source of variation; why plausibly exogenous}}</p>
      <!-- IV: write instrument formula in LaTeX via MathJax -->
      <h3>3. Key Assumption &amp; Controls</h3>
      <p>{{Identifying assumption (parallel trends / exclusion restriction / continuity)}}</p>
      <div class="callout callout-tip">
        Discussion: Is the [assumption] credible? What stories could violate it?
      </div>
      <h3>4. Empirical Specification</h3>
      <p>\[ {{LaTeX estimating equation}} \]</p>
      <p>Diagnostic: {{KP F-stat / pre-trend plot / McCrary test}}</p>
    </section>

    <!-- 6–N. Results (one slide per major finding) -->
    <!-- Single figure: use .fig-full -->
    <section>
      <h2>{{Result title}}</h2>
      <img src="{{original_figure_path}}" class="fig-full" alt="{{figure caption}}">
      <p>{{Effect size with units and benchmark}}</p>
    </section>
    <!-- Figure + commentary: use .col-7-5 -->
    <section>
      <h2>{{Result title}}</h2>
      <div class="col-7-5">
        <div>
          <p>{{Key finding explanation}}</p>
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
  /* Palette — Academic Blue (default) */
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

**Palette alt-themes** — swap `:root` values only:

| Theme | `--c-primary` | `--c-accent` | `--c-paper-warm` | When |
|---|---|---|---|---|
| Academic Blue (default) | `#0046AD` | `#ffd84d` | `#f7f5f0` | Causal inference, field experiments |
| Charcoal (no-color) | `#1a1a1a` | `#e5e5e5` | `#f5f5f5` | Theory-heavy or methods papers |

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

## Identification Slide — Strategy Details

Adapt to the paper's strategy:

- **IV**: Write the instrument formula in LaTeX; define every symbol; explain what variation drives the instrument.
- **DiD**: Define treatment and control groups; describe the policy/event; explain why the comparison is valid.
- **RD**: State running variable, cutoff, bandwidth; explain why units just above/below are comparable.
- **Experiment**: Describe randomization unit, assignment mechanism, and compliance.

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
