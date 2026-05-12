# Slide Aesthetics — Full Styling Spec

**Blue-white academic clean** — Plus Jakarta Sans on white, academic-blue primary and accent. This is the slide-deck brand, intentionally *different* from the personal-site Hokusai/Lora brand. Reading-group decks want a quieter conference-house register (think NeurIPS / ICML / Marketing Science author slides), not the magazine-paper warmth the personal site uses.

Read this file before populating the `<style>` block in the Reveal.js template (`SKILL.md` → "Reveal.js template"). Sections 1–6 below are pasted into the template's `<style>` tag verbatim and in order.

---

## Aesthetic discipline

**The direction is academic-clean sans-serif on white with a single blue accent.** Tight type, generous padding, no warm-paper textures, no Lora/Newsreader (those belong to the personal site). The default model pull toward generic-modern (Inter body, sky-blue links, oversaturated charts) is rejected here just as in figures and on the personal site — but the *form* the rejection takes for slides is different from the site's. On the site the rejection is *book-voice serif on warm paper*; on slides it's *quiet sans on white with one decisive blue moment*.

Hold the line on:

- **Typography.** Plus Jakarta Sans, weight 400–800 across heading and body. One typeface only — no mixing with serif Lora / Newsreader. Source Serif 4 is loaded for math/citations but should not appear as body type. Never substitute Inter, Arial, system-ui-only (Plus Jakarta Sans falls back to system-ui only when the webfont fails to load), or Space Grotesk.
- **Palette role-distribution.** White surfaces dominate (~92% of slide area), blue chrome ~6% (h2 color, table header band, eq-block left rule, callout borders, code background), electric-blue accent ≤2% (one accent moment per slide — `.callout-result`, `.with-accent` h2 underline, outline-grid numerals). If electric blue starts covering area, it has stopped being an accent.
- **No warm tones.** No cream paper. No Hokusai crimson. No banana-yellow accents. No coral warns. The personal site uses warm cream and crimson; the slide deck does not. If you find yourself reaching for `#EFE6D2` or `#A03830` while generating a deck, you are conflating brands — stop.
- **Layout.** Asymmetric where it helps the eye land (title slide gets a big blue underline rule), generous negative space everywhere else. **Fewer, bigger words.** Bullets should breathe; max ~8 words per bullet where possible. The body font sizes in §1 are intentionally one tier larger than the previous deck spec — eye-catch at slide pace, not document-style density.
- **Execution density.** Academic-clean asks for *restraint and precision* — careful spacing, deliberate type hierarchy, no decorative flourishes. Plain white with a blue stripe is the right answer; a tasteful paper-grain texture is *not* (warm in feel; against the brand).
- **Symmetric column heights.** For any `.col-7-5` or `.col-6-6` slide, the left and right columns must have the same vertical extent. The deck CSS stretches both columns and centers content inside each, so a short text column sits visually opposite the figure rather than floating above its bottom edge. Per-slide overrides (inline `style="align-items: stretch"`, `style="justify-content: center"`) are unnecessary and should be deleted when found.
- **Drop per-column h3s that break top-alignment.** If two adjacent panels have headings that occupy different vertical heights (one wraps, one doesn't), drop the heading entirely and fold the label into the caption sentence below the figure (e.g., `<p class="small"><strong>Deadline (Fig. 7).</strong> ...</p>`). The panels then top-align cleanly.
- **Cap figure height to match a shorter text column.** When the right column has only one short paragraph or callout, the figure looks oversized at the default 360px cap. Drop an inline `style="max-height: 320px"` (or lower) on that slide's `<img>` so figure and text match visually.

When in doubt, the test: would this slide look at home on a NeurIPS or Marketing Science author page? If yes, hold the line. If it looks magazine-y, conference-poster-y, or designer-portfolio-y, dial back.

> **Why this brand differs from the personal site.** The personal site (`docs/css/tokens.css`, `docs/index.html`, CV) uses Lora display + Newsreader body + Hokusai cream/crimson — book-voice warmth, slow read. Slides need eye-catch at 30-second-per-slide pace under projector light, which is the opposite register. The site brand and slide brand are *cousins* (both quiet, both serif-discipline-aware, both reject the AI-slop default), not the same identity. Keep them separate.

---

## 1. Design system tokens

These tokens are **specific to slide decks** — they do NOT mirror `docs/css/tokens.css`. The personal site has its own tokens; this file is the source of truth for the slide deck only.

```css
:root {
  /* Palette — blue-white academic, no warm tones */
  --c-primary:      #0046AD;   /* academic blue — h2, h3, chrome, links */
  --c-primary-soft: #eef3fb;   /* very pale blue — code bg, table stripes (when needed) */
  --c-accent:       #0046AD;   /* accent moment (same hue as primary; emphasis via weight / position / box) */
  --c-warn:         #8a6d24;   /* muted amber — warn callout */
  --c-mint:         #0e6e5a;   /* deep teal — tip callout */
  --c-ink:          #0a1422;
  --c-ink-soft:     #3b4554;
  --c-ink-mute:     #7a8392;
  --c-paper:        #FFFFFF;
  --c-paper-cool:   #f6f8fc;   /* faintest cool tint — table even-row stripe, eq block bg */
  --c-line:         #d8dee8;

  /* Typography — Plus Jakarta Sans everywhere; Source Serif 4 only for math */
  --font-display: 'Plus Jakarta Sans', system-ui, -apple-system, sans-serif;
  --font-body:    'Plus Jakarta Sans', system-ui, -apple-system, sans-serif;
  --font-serif:   'Source Serif 4', Georgia, 'Times New Roman', serif;
  --font-mono:    ui-monospace, 'JetBrains Mono', Consolas, monospace;

  /* Sized one tier larger than the previous spec — eye-catch over density */
  --fs-h1:    clamp(2.8rem,  6.0vw, 4.2rem);
  --fs-h3:    clamp(1.55rem, 3.1vw, 2.0rem);
  --fs-body:  clamp(1.45rem, 2.7vw, 1.8rem);
  --fs-small: clamp(1.15rem, 1.9vw, 1.5rem);
  --ease-expo: cubic-bezier(0.16, 1, 0.3, 1);

  /* Spacing (4px base) */
  --sp-1: 4px;  --sp-2: 8px;  --sp-3: 12px; --sp-4: 16px;
  --sp-5: 24px; --sp-6: 32px; --sp-7: 48px; --sp-8: 64px;

  /* Borders & soft shadows — no brutalist offsets */
  --border:    1.5px solid var(--c-line);
  --radius-sm: 6px; --radius-md: 10px;
  --shadow-xs: 0 1px 2px rgba(15,30,60,0.06);
  --shadow-sm: 0 2px 6px rgba(15,30,60,0.09);
}
```

Load fonts in `<head>` before stylesheets:

```html
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Source+Serif+4:opsz,wght@8..60,400;8..60,600&display=swap" rel="stylesheet">
```

---

## 2. Base slide overrides

When body and display fonts are the same (Plus Jakarta Sans across the board), the hierarchy still has to be visible through weight + size, not through typeface contrast. So h2 jumps to weight 800 with negative letter-spacing; body is 400; small-caps eyebrows are 600 with positive letter-spacing.

```css
.reveal .slides section {
  text-align: left; height: 720px; overflow-y: auto;
  font-family: var(--font-body); font-size: var(--fs-body); line-height: 1.55;
  letter-spacing: -0.005em;
  padding: var(--sp-7) var(--sp-8);   /* roomy padding — fewer/bigger words */
  background-color: var(--c-paper);   /* pure white, no grain */
}
.reveal h2 {
  font-family: var(--font-display);
  font-size: var(--fs-h1); font-weight: 800; letter-spacing: -0.022em;
  color: var(--c-primary); margin-bottom: var(--sp-5);
  border-bottom: 1px solid var(--c-line); padding-bottom: var(--sp-3);
  text-transform: none;
}
/* Use on headline-result slides so the eye knows this one matters.
   Electric-blue rule replaces the default thin line. */
.reveal h2.with-accent {
  border-bottom-color: var(--c-accent);
  border-bottom-width: 3px;
}
.reveal h3 {
  font-family: var(--font-display);
  font-size: var(--fs-h3); font-weight: 700;
  color: var(--c-ink); margin: var(--sp-5) 0 var(--sp-3);
  letter-spacing: -0.012em;
}
.reveal p, .reveal li { color: var(--c-ink-soft); }
.reveal strong { color: var(--c-ink); font-weight: 700; }
.reveal em { color: var(--c-ink); font-style: italic; }
code { font-family: var(--font-mono); font-size: 0.88em;
       background: var(--c-primary-soft); padding: 1px 5px; border-radius: 4px;
       color: var(--c-primary); }

/* Bullet rhythm — breathe */
.reveal ul, .reveal ol { margin: var(--sp-3) 0; }
.reveal li { margin: var(--sp-2) 0; }
.reveal ul.tight li, .reveal ol.tight li { margin: 4px 0; }
```

---

## 3. Layouts, figures, tables

Named column grids — wrap slide content in the appropriate div:

| Class | Grid | Use case |
|---|---|---|
| `.col-full` | block | Single figure or table |
| `.col-7-5` | `7fr 5fr` | Text left, figure right |
| `.col-6-6` | `1fr 1fr` | Two equal result columns |
| `.col-3` | `repeat(3, 1fr)` | Three mechanism cards |
| `.col-4` | `repeat(4, 1fr)` | Four author cards |

```css
.col-7-5, .col-6-6, .col-3, .col-4 {
  display: grid; gap: var(--sp-5) var(--sp-6); align-items: start;
}
.col-7-5 { grid-template-columns: 7fr 5fr; }
.col-6-6 { grid-template-columns: 1fr 1fr; }
.col-3   { grid-template-columns: repeat(3, 1fr); }
.col-4   { grid-template-columns: repeat(4, 1fr); }
.col-7-5 > *, .col-6-6 > *, .col-3 > *, .col-4 > * {
  display: flex; flex-direction: column; justify-content: flex-start;
}
.col-7-5 img, .col-6-6 img, .col-3 img, .col-4 img {
  max-height: 360px; width: auto; max-width: 100%;
  margin: 0 auto; object-fit: contain;
}
@media (max-width: 700px) {
  .col-7-5, .col-6-6, .col-3, .col-4 { grid-template-columns: 1fr; }
}

/* Symmetric two-column heights -- for figure-plus-text slides, stretch
   both columns to equal height and vertically center each column's content
   inside it. Without this, a short text column floats above the figure's
   bottom edge and the slide feels lopsided.

   Kept off .col-3 and .col-4 (card grids), where top-alignment is required
   so card headings line up across a row. */
.col-7-5, .col-6-6 { align-items: stretch; }
.col-7-5 > *, .col-6-6 > * { justify-content: center; }

/* Side-by-side comparison grid -- pairs items row-by-row so two columns
   stay aligned regardless of wrap. Use for slides that compare two
   paradigms or two findings line-by-line. Row 1 = h3 vs h3, row 2 =
   question vs question, rows 3+ = bullet points. */
.compare-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: var(--sp-4) var(--sp-7);
  align-items: start;
  margin-top: var(--sp-4);
}
.compare-grid h3 { margin: 0; font-size: var(--fs-h3); }
.compare-grid .question {
  color: var(--c-ink-mute); margin: 0;
  font-style: italic; font-family: var(--font-body);
}
.compare-grid .point {
  color: var(--c-ink-soft); margin: 0;
  padding-left: 1.4em; position: relative;
}
.compare-grid .point::before {
  content: "\2022";
  position: absolute; left: 0; top: 0;
  color: var(--c-accent); font-weight: 800;
}
.compare-grid .point strong { color: var(--c-ink); }

/* Title slide — centered, big title with electric-blue underline */
.reveal .slides section.slide-title {
  display: flex; align-items: center; justify-content: center;
  text-align: center;
}
.title-card {
  background: var(--c-paper); border: none;
  padding: var(--sp-6) var(--sp-7);
  max-width: 88%;
}
.title-card h2 {
  border-bottom: 3px solid var(--c-accent);
  display: inline-block;
  padding-bottom: var(--sp-3);
  margin-bottom: var(--sp-5);
  font-size: clamp(2.0rem, 4.6vw, 3.0rem);
  line-height: 1.18;
}
.title-card .subtitle {
  font-family: var(--font-display);
  font-weight: 500; color: var(--c-ink-soft);
  font-size: var(--fs-h3);
  margin: 0 0 var(--sp-5);
}
.title-card .title-venue {
  display: inline-block;
  background: var(--c-primary-soft);
  border: 1px solid var(--c-line);
  padding: 4px 14px;
  font-family: var(--font-display); font-weight: 600;
  color: var(--c-primary);
  font-size: var(--fs-small);
  margin-bottom: var(--sp-5);
  border-radius: 4px;
  letter-spacing: 0.02em;
}
.title-card .title-authors { font-size: var(--fs-body);  color: var(--c-ink);      margin-bottom: var(--sp-3); }
.title-card .title-aff     { font-size: var(--fs-small); color: var(--c-ink-soft); margin: 0 0 var(--sp-4); }
.title-card .callout       { margin-top: var(--sp-5); text-align: left; }
.title-card .meta {
  margin-top: var(--sp-5);
  font-size: var(--fs-small); color: var(--c-ink-mute);
}

/* Figures */
.fig-full {
  width: 100%; max-height: 420px; object-fit: contain;
  border: var(--border); border-radius: var(--radius-sm); box-shadow: var(--shadow-xs);
}

/* Tables */
.reveal table {
  width: 100%; border-collapse: collapse;
  font-size: var(--fs-small); line-height: 1.45;
  border: var(--border); border-radius: var(--radius-sm); overflow: hidden;
}
.reveal table th {
  background: var(--c-primary); color: var(--c-paper);
  padding: var(--sp-3) var(--sp-4);
  font-family: var(--font-display); font-weight: 700;
  text-align: left; letter-spacing: 0.02em;
}
.reveal table td {
  padding: var(--sp-3) var(--sp-4);
  border-bottom: 1px solid var(--c-line);
  color: var(--c-ink-soft);
}
.reveal table tr:nth-child(even) td { background: var(--c-paper-cool); }
.reveal table tr:last-child td     { border-bottom: none; }

/* Outline grid — numbered two-column map, electric-blue numerals */
.outline-grid {
  list-style: none; padding: 0; margin: var(--sp-5) 0 0;
  display: grid; grid-template-columns: 1fr 1fr;
  gap: var(--sp-5) var(--sp-7);
  counter-reset: outline;
}
.outline-grid li {
  counter-increment: outline;
  position: relative; padding-left: var(--sp-7);
  display: flex; flex-direction: column; gap: 6px;
}
.outline-grid li::before {
  content: counter(outline, decimal-leading-zero);
  position: absolute; left: 0; top: 0;
  font-family: var(--font-display); font-weight: 800;
  font-size: 1.25em; color: var(--c-accent);
  line-height: 1.2; letter-spacing: -0.02em;
}
.outline-grid li strong { font-family: var(--font-display); color: var(--c-ink); font-weight: 700; font-size: 1.08em; }
.outline-grid li span   { color: var(--c-ink-soft); font-size: var(--fs-small); }
.outline-grid li.outline-coda::before { color: var(--c-mint); }

/* Author bios — white cards, thin border, no warm tone */
.author-card {
  border: var(--border); border-radius: var(--radius-md);
  background: var(--c-paper); padding: var(--sp-4);
  box-shadow: var(--shadow-xs); font-size: var(--fs-small);
}
.author-card .photo {
  width: 100%; max-width: 150px; aspect-ratio: 1 / 1;
  object-fit: cover; border-radius: var(--radius-sm);
  border: 1px solid var(--c-line);
  display: block; margin: 0 auto var(--sp-3);
}
.author-card .name {
  font-family: var(--font-display); font-weight: 800;
  color: var(--c-ink); margin: var(--sp-2) 0 var(--sp-1);
  font-size: 1.0em; text-align: center; letter-spacing: -0.012em;
}
.author-card .role { color: var(--c-primary); font-weight: 600; font-size: 0.88em; margin: 0 0 4px; text-align: center; }
.author-card .aff  { color: var(--c-ink-soft); font-size: 0.85em; margin: 0 0 8px; text-align: center; }
.author-card .interests { color: var(--c-ink-soft); font-size: 0.82em; line-height: 1.45; }
```

**Layout selection:**

| Slide content | Layout |
|---|---|
| Single figure, no commentary | `.col-full` (just `<img class="fig-full">`) |
| Figure + short bullets | `.col-7-5` |
| Two parallel results | `.col-6-6` |
| Three mechanisms / panels | `.col-3` |
| Figure + table + interpretation | `.col-6-6` row; `.callout-result` *below* the row, never inside |

Photos for `.author-card` are square-cropped to 1:1 and resized to ~150px before base64-embedding. See the photo-pipeline snippet in `SKILL.md` under "Author Bios slide".

---

## 4. Callouts

Three semantic variants — colors kept cool / muted:

```css
.callout {
  border-radius: var(--radius-md); border-width: 1.5px; border-style: solid;
  padding: var(--sp-4) var(--sp-5); margin: var(--sp-4) 0;
  font-size: var(--fs-small); line-height: 1.55;
  box-shadow: var(--shadow-xs);
}
.callout-warn   { background: #fbf6ea; border-color: var(--c-warn);    color: var(--c-ink); }
.callout-result { background: var(--c-primary-soft); border-color: var(--c-accent); color: var(--c-ink); }
.callout-tip    { background: #eaf6f2; border-color: var(--c-mint);    color: var(--c-ink); }
.callout strong { color: var(--c-ink); }

/* Equation block — wraps a display MathJax expression. Cool-tinted background,
   electric-blue left rule, centered, slightly larger font for projection. */
.eq {
  background: var(--c-paper-cool);
  border-left: 3px solid var(--c-accent);
  border-radius: var(--radius-sm);
  padding: var(--sp-5) var(--sp-6);
  margin: var(--sp-5) 0;
  text-align: center;
  font-size: var(--fs-body);
  color: var(--c-ink);
}
.eq ul, .gloss {
  text-align: left; margin: var(--sp-3) 0 0; padding-left: 1.2em;
  font-size: var(--fs-small); line-height: 1.55;
}
```

Usage: `.callout-warn` for LLM quality concerns and identification threats; `.callout-result` for headline findings; `.callout-tip` for methodological notes; `.eq` for any displayed equation that needs visual separation from prose (always pair with a `.gloss` list — see SKILL.md §"Equations get a symbol gloss").

---

## 5. Animation

Two layers: (a) a slide-entry choreography that plays once when each section becomes `.present` — heading first, then figure, then bullets cascade; (b) the existing fragment / li-stagger primitives for in-slide reveals.

```css
.reveal .slides section.present > h2 { animation: slide-in 0.4s var(--ease-expo) both; }
.reveal .slides section.present > img,
.reveal .slides section.present .col-7-5 > img,
.reveal .slides section.present .fig-full {
  animation: slide-in 0.45s var(--ease-expo) 0.1s both;
}
.reveal .slides section.present > ul,
.reveal .slides section.present > ol,
.reveal .slides section.present .callout {
  animation: slide-in 0.4s var(--ease-expo) 0.18s both;
}
@keyframes slide-in { from { opacity:0; transform:translateY(12px); } to { opacity:1; transform:none; } }

.reveal .fragment.fade-up {
  opacity: 0; transform: translateY(16px);
  transition: opacity 0.28s var(--ease-expo), transform 0.28s var(--ease-expo);
}
.reveal .fragment.fade-up.visible { opacity: 1; transform: none; }

/* Staggered list — set style="--i:0", "--i:1", ... on each <li> */
.reveal li {
  animation: li-in 0.28s var(--ease-expo) both;
  animation-delay: calc(var(--i, 0) * 0.06s);
}
@keyframes li-in { from { opacity:0; transform:translateY(10px); } to { opacity:1; transform:none; } }

@media (prefers-reduced-motion: reduce) {
  *, .reveal .fragment,
  .reveal .slides section.present > * { animation: none !important; transition: none !important; }
}
```

---

## 6. No atmospheric texture, no Hokusai signature

Earlier versions of this spec added a faint paper-grain SVG overlay and a Hokusai-wave SVG on the title slide. Both belong to the personal-site brand and are out of place on slides:

- **Paper-grain texture is warm.** The grain is what makes the personal site read as printed paper; on a slide deck it pushes toward magazine/poster territory, which the brand explicitly rejects. Slides stay pure white.
- **The Hokusai wave is the personal site's wordmark.** Using it on slides imports site-brand cues into the slide context — wrong register, brand confusion. If a deck needs a visual signature, use a single blue-rule moment somewhere (e.g., the title-slide h2 underline) rather than an illustration.

If you find a previous deck or skill snapshot that uses the wave or grain, those are leftover from the unified-brand era. Strip them.

---

## 7. Speaker-notes overlay — toggle on "N"

Reveal.js's built-in "S" key opens a popup speaker view in a second window — useful for dual-monitor podiums, useless on a laptop at a reading group. The "N" overlay is the lightweight alternative: a bottom-anchored panel that fades over the *current* slide and shows the script for that slide only. Press N to show, N again to hide.

The markup convention is Reveal.js's standard `<aside class="notes">` element placed inside each `<section>`, so the same content also feeds the "S" popup if someone uses it.

```css
.reveal aside.notes { display: none; }

body.show-notes .reveal section.present aside.notes {
  display: block;
  position: fixed;
  left: var(--sp-6); right: var(--sp-6); bottom: var(--sp-5);
  max-height: 38vh; overflow-y: auto;
  background: var(--c-paper);
  border: 1px solid var(--c-line);
  border-left: 4px solid var(--c-accent);
  border-radius: var(--radius-md);
  padding: var(--sp-4) var(--sp-5);
  font-family: var(--font-body);
  font-size: var(--fs-small); line-height: 1.55;
  color: var(--c-ink); text-align: left;
  box-shadow: 0 6px 22px rgba(15,30,60,0.18);
  z-index: 1000;
}
body.show-notes .reveal section.present aside.notes::before {
  content: "Notes — press N to dismiss";
  display: block;
  font-family: var(--font-display);
  font-size: 0.78em; letter-spacing: 0.08em;
  text-transform: uppercase; font-weight: 700;
  color: var(--c-primary);
  margin-bottom: var(--sp-3);
  padding-bottom: var(--sp-2);
  border-bottom: 1px solid var(--c-line);
}
body.show-notes .reveal aside.notes p,
body.show-notes .reveal aside.notes li { color: var(--c-ink-soft); margin: var(--sp-1) 0; }
body.show-notes .reveal aside.notes strong { color: var(--c-primary); font-weight: 700; }
body.show-notes .reveal aside.notes ul { padding-left: var(--sp-5); margin: var(--sp-2) 0; }
```

The keybinding itself lives in the Reveal.js init script — see `SKILL.md` → "Reveal.js template". It overrides Reveal's default N-as-next-slide binding through the `keyboard` config map (`78: () => document.body.classList.toggle('show-notes')`), so Space and → still advance the deck while N is repurposed for the notes overlay.
