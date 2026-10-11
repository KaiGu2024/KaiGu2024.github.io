# PDF Export — Decktape pipeline

When the user explicitly asks for a PDF (not before), render `slide/<slug>.html` via [Decktape](https://github.com/astefanutti/decktape) (headless Chrome → fixed-size pages):

```bash
npm install -g decktape                                          # one-time
decktape reveal --size 1280x720 slide/<slug>.html slide/<slug>.pdf
```

Decktape walks every `<section>` and writes one fixed-size page per slide. Unlike the HTML view, **PDF pages cannot scroll** — content overflowing the viewport is silently clipped. The HTML's `overflow-y: auto` is a safety net for HTML viewing only; in PDF it does nothing.

**Use the HTML deck's typography unchanged.** Decktape renders the CSS from `aesthetics.md`, including the standard 56px title, 30px subtitle/subheading, and 27px body caps at a 16px root font. Do not introduce a separate PDF font-size override. Compare HTML and PDF at the same slide display size, and ensure the webfonts have loaded before capture. This applies to HTML-derived PDFs; `own` mode's Beamer PDFs follow `own-work.md`.

---

## Splitting rules

Audit each slide for fit before exporting. Any section that does not fit a single 1280×720 page must be split at logical boundaries:

- **Description + Analysis exceeds the page** → slide A = figure + Description, slide B = Analysis + caveats. Keep the same `<h2>`, no "(cont.)" suffix.
- **Multi-panel figures** → one panel per slide; share the headline; subordinate the panel label to `<h3>` (e.g. *Panel A: by income decile*).
- **Figure + regression table** → figure on slide A, table on slide B.
- **Long bulleted lists** → split at the first natural `<h3>` boundary. Each `<h3>` block belongs to exactly one slide; never let an `<h3>` straddle a page break.
- **Wide tables** → split by row group or move overflow to an appendix slide. Do not shrink the font below `var(--fs-small)`.

---

## Audit checklist

Open the HTML in a browser and scroll each `<section>`. Any section that needs scrolling must be split before Decktape runs:

- Each section fits 720px without scrolling (scroll-fit ≠ print-fit).
- Figures respect `max-height: 400px` (`.fig-full`) or `340px` (column cells).
- One `<h2>` per section; `<h3>` blocks don't straddle pages.
- Callouts and code blocks not clipped at the bottom.

After splits, re-run Decktape.

Inspect the exported PDF itself, including the title, densest content slide, every distinct results layout, and conclusion. Save any rasterized pages or contact sheets needed for inspection under project-root `exploratory/previews/slides/<slug>/`, with `/exploratory/previews/` excluded from version control. These disposable previews stay outside `slide/` and are not companion PNG deliverables.
