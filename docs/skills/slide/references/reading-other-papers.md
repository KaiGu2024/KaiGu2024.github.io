# Reading other papers — report mode

Use this mode for a reading group, class, discussant slot, or any presentation of work the user did not author. Present from a discussant's stance and deliver a self-contained Reveal.js HTML deck.

## Contents

- [Hard rules](#hard-rules)
- [Build order](#build-order)
- [Deck structure](#deck-structure)
- [Content rules](#content-rules)
- [Figures, tables, and author photos](#figures-tables-and-author-photos)
- [Reveal.js document contract](#revealjs-document-contract)
- [Editing and verification](#editing-and-verification)

## Hard rules

- Produce `slide/<slug>.html`. Export `slide/<slug>.pdf` only when explicitly requested; then read `pdf-export.md`.
- Read `aesthetics.md` before writing the inline `<style>` block and `speaker-notes.md` before populating notes.
- Use the paper's own tables and figures. Do not web-source or generate substantive assets. Author photos are the only web-sourced exception.
- Produce `notes/<slug>.md` before the deck, after reading the full paper.
- Keep the HTML self-contained: embed all content assets; allow CDN links only for Reveal.js, MathJax, and fonts.

## Build order

1. Read `notes/<slug>.md` and the full paper source or extraction.
2. Map the paper to the seven-block skeleton below; add an Analytical Model slide only when the paper has a formal model.
3. Reproduce the paper's evidence with exact numbers, uncertainty, labels, and captions.
4. Build one self-contained Reveal.js file using the aesthetic and notes references.
5. Render representative slides and inspect them. Reveal.js does not report clipping or overflow.
6. Export PDF only on request and apply every check in `pdf-export.md`.

## Deck structure

Target roughly 12–16 slides by expanding Results, not by inventing extra framing slides.

| Block | Purpose |
|---|---|
| **Title** | Full title, authors, affiliations, venue and year or “Working Paper.” Optionally preview the analysis structure or one headline finding. |
| **Author Bios** | Use a compact author grid: photo, position, institution, PhD, and three to five research interests. |
| **Outline** | List substantive analyses only. Omit motivation, data, identification, and the closing discussion. |
| **Data & Setting** | Show the setting, sample-construction pipeline with N and percentages, measurement, and any annotation or classification process. |
| **Identification** | Explain challenge → strategy → assumptions and diagnostics. |
| **Results** | Use one or more slides per substantive analysis. Reproduce the relevant figure or table and pair it with Description + Analysis. |
| **Takeaways & Discussion** | Give three takeaways and up to five questions that can sustain discussion. |

Insert **Analytical Model** immediately before Results when needed. Explain the intuition and distinctive prediction, not every derivation.

**Use one map.** Let the Outline name each substantive analysis with a short label and one sentence. Do not add another roadmap, “three levers,” or framing slide that repeats the same items.

## Content rules

### Titles and density

- Keep each content-slide `<h2>` to one row, normally no more than about 33 characters.
- Use a stable `Section: topic` title with `<span class="h2-section">Section:</span> topic` so the audience can locate the slide in the Outline.
- Name the analytical role and object, not the punchline. Put the estimate or conclusion in a result callout.
- Avoid em-dash compound titles. Use a subtitle only when it adds information; let either the title or subtitle carry the underline, never both.
- Add `class="dense"` only to text-heavy Outline, Identification, or closing slides. Do not shrink figure or results slides by hand.

### Equations

Wrap each displayed equation in `.eq` and follow it with a two- or three-item `.gloss` that defines nontrivial symbols. Skip the gloss only for textbook identities. Use MathJax-safe LaTeX, write `\lt` or `\leq` instead of a bare `<` inside math, and break long expressions with `aligned`.

Verify the rendered equation after navigation to its slide. The Reveal initialization below re-typesets the active slide because the initial MathJax pass can miss hidden or animated content.

### Identification

For canonical DiD, IV, RD, or RCT, omit the familiar regression equation. Spend the slide on the identifying assumption most likely to fail and the diagnostic that bears on it. Show the specification only for a nonstandard variant such as staggered DiD, shift-share IV, fuzzy RD, or recentered IV.

| Strategy | Assumption to discuss | Standard diagnostic |
|---|---|---|
| **DiD** | Parallel trends, no anticipation, and strict exogeneity | Pre-trend event study; sensitivity bounds where relevant |
| **IV** | Independence, exclusion, relevance, and monotonicity for LATE | First stage; placebo outcomes; covariate balance; weak-IV diagnostics |
| **RD** | Continuity and no manipulation at the cutoff | Density and covariate-smoothness checks |
| **RCT** | Random assignment and SUTVA | Balance, attrition by arm, and spillover checks |

Add a no-spillovers caveat for DiD and RCT when units are spatially or socially proximate. Structure the slide as Challenge → Strategy → Assumptions to discuss, and close on the most useful credibility question for the room.

### Results

- Show one finding per slide and reproduce the paper's figure or table.
- Keep Description factual: pattern, point estimate, uncertainty, units, and sample.
- Keep Analysis interpretive: economic magnitude, benchmark, mechanism, limitation, or identification consequence.
- Never cite a number from a different table or figure as though it appeared on the current slide.
- Put the headline number with units and benchmark in `.callout-result`; make the corresponding speaker note say that number aloud.
- Split crowded multi-panel figures across slides instead of shrinking labels below projection size.

## Figures, tables, and author photos

Apply this sourcing order:

1. **TeX source available:** rebuild tables as native HTML. Convert PDF/EPS figures to PNG before embedding; browsers cannot render a paper figure through `<img src="figure.pdf">`.
2. **PDF only:** use MinerU's structured table rows and extracted images.
3. **Extraction failure:** insert a visible caveat and `<!-- MANUAL: supply figure here -->`; tell the user which asset is missing. Do not fabricate it.

For an arXiv paper, download the original PDF, locate a figure by caption text, crop it with PyMuPDF, and inspect the crop before embedding. Check panel identity, axes, captions, and clipping.

Make the HTML self-contained:

- Render tables as native `<table>` elements, never screenshots.
- Convert PNG/JPEG figures and author photos to base64 data URIs.
- Inline SVG figures.
- Discard temporary conversions after embedding; do not create a persistent `slide/assets/` directory for report mode.

For Author Bios, try the institutional or personal site before omitting a photo. Square-crop and resize the image, embed it, and include position, institution, post-PhD experience when relevant, PhD program and year, and research interests. Omit the `<img>` when no credible photo is available rather than linking remotely.

## Reveal.js document contract

Use the full CSS system from `aesthetics.md` and the notes markup from `speaker-notes.md`. At minimum, preserve this shell and initialization:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>{{Paper Title}}</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Source+Serif+4:opsz,wght@8..60,400;8..60,600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@5/dist/reset.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@5/dist/reveal.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@5/dist/theme/white.css">
  <style>/* paste aesthetics.md sections 1–6 verbatim */</style>
</head>
<body>
<div class="reveal"><div class="slides">
  <!-- explicit sections following the skeleton; populate notes per speaker-notes.md -->
</div></div>
<script src="https://cdn.jsdelivr.net/npm/reveal.js@5/dist/reveal.js"></script>
<script src="https://cdn.jsdelivr.net/npm/reveal.js@5/plugin/math/math.js"></script>
<script>
Reveal.initialize({
  width: 1280,
  height: 720,
  hash: true,
  slideNumber: 'c/t',
  plugins: [RevealMath.MathJax3],
  math: { mathjax: 'https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js' },
  keyboard: { 78: () => document.body.classList.toggle('show-notes') }
});
Reveal.on('slidechanged', event => {
  if (window.MathJax && MathJax.typesetPromise) {
    MathJax.typesetPromise([event.currentSlide]);
  }
});
</script>
</body>
</html>
```

Every ordinary content section should contain an `<aside class="notes">`. Press `N` for the in-window overlay and `S` for Reveal's dual-monitor speaker view.

## Editing and verification

Once the HTML contains several base64 figures, do not load or rewrite the whole file through a context-limited text editor. Patch it with a temporary script under `.tmp_edit/`, run the script, then delete it. To inspect structure, print headings and `<section>` boundaries while replacing long base64 lines with a length marker.

Render changed slides in headless Edge or Chrome at a window larger than 1280×720. Inspect the title, equation, densest text slide, every distinct results layout, and the closing slide. Check:

- no right-edge or bottom clipping;
- readable axes, table text, and source lines;
- typeset equations rather than raw delimiters;
- symmetric margins and grids whose children use `min-width: 0`;
- wide images constrained to their grid columns;
- one current-slide notes panel when `N` is toggled.

If the left margin appears but the right content spills off-screen, fix `.reveal .slides section { box-sizing: border-box; }` at the root rather than applying slide-specific width patches.

Report the paper metadata, output path, number of slides, analyses covered, sourcing method, missing assets, and any identification assumption that still needs human judgment.
