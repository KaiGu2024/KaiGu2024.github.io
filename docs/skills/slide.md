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
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@5/dist/reset.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@5/dist/reveal.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@5/dist/theme/white.css">
  <style>
    :root { --r-main-font-size: 26px; }
    .reveal .slides section {
      overflow-y: auto;
      height: 650px;
      text-align: left;
    }
    .amber {
      border-left: 3px solid #b45309;
      background: #fef9f0;
      padding: 0.6em 0.9em;
      margin: 0.5em 0;
      font-size: 0.85em;
    }
    .author-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1.5em; }
    .author-card img { width: 80px; height: 80px; border-radius: 50%; object-fit: cover; }
    .author-card h3 { font-size: 0.9em; margin: 0.3em 0 0.1em; }
    .author-card p  { font-size: 0.75em; margin: 0.15em 0; color: #555; }
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
      <div class="amber">
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
      <div class="amber">
        Discussion: Is the [assumption] credible? What stories could violate it?
      </div>
      <h3>4. Empirical Specification</h3>
      <p>\[ {{LaTeX estimating equation}} \]</p>
      <p>Diagnostic: {{KP F-stat / pre-trend plot / McCrary test}}</p>
    </section>

    <!-- 6–N. Results (one slide per major finding) -->
    <section>
      <h2>{{Result title}}</h2>
      <img src="{{original_figure_path}}" style="max-height:420px">
      <p>{{Effect size with units and benchmark}}</p>
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

### Typography
Use `clamp()` for fluid scaling — no media queries needed:
```css
:root {
  --title-size: clamp(1.4rem, 4vw, 3rem);
  --body-size:  clamp(0.75rem, 1.5vw, 1.1rem);
  --ease-expo:  cubic-bezier(0.16, 1, 0.3, 1);
}
.reveal .slides section { font-size: var(--body-size); line-height: 1.4; }
.reveal h2 { font-size: var(--title-size); }
```

### Layout
- Slide container: Reveal.js handles viewport; keep `height: 650px; overflow-y: auto` on sections.
- Content max-width: `max-width: min(90vw, 1000px)`.
- Responsive columns: `grid-template-columns: repeat(auto-fit, minmax(min(100%, 250px), 1fr))`.

### Animation (professional preset)
Subtle and fast — matches academic context. Add to `<style>`:
```css
/* Fragment entrance */
.reveal .fragment.fade-up {
  opacity: 0;
  transform: translateY(18px);
  transition: opacity 0.3s var(--ease-expo), transform 0.3s var(--ease-expo);
}
.reveal .fragment.fade-up.visible { opacity: 1; transform: none; }

/* Staggered list — set style="--i:0" style="--i:1" etc. on <li> */
.reveal li {
  animation: fadeSlideUp 0.35s var(--ease-expo) both;
  animation-delay: calc(var(--i, 0) * 0.08s);
}
@keyframes fadeSlideUp {
  from { opacity: 0; transform: translateY(14px); }
  to   { opacity: 1; transform: none; }
}

@media (prefers-reduced-motion: reduce) {
  *, .reveal .fragment { animation: none !important; transition: none !important; }
}
```

### Background options
Choose one per deck:
- **Clean white** (default for academic) — no background set.
- **Gradient mesh** (warmer, editorial): `background: radial-gradient(ellipse at 20% 50%, #e8f4f8, transparent 60%), radial-gradient(ellipse at 80% 20%, #f0e8f8, transparent 60%);`
- **Subtle grid** (structured, data-heavy): `background-image: linear-gradient(#e5e7eb 1px, transparent 1px), linear-gradient(90deg, #e5e7eb 1px, transparent 1px); background-size: 40px 40px;`

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
