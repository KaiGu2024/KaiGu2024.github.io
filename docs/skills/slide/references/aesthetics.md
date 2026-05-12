# Slide Aesthetics — Full Styling Spec

Aligned with the personal Monet/Hokusai brand — dusty-blue chrome, warm cream paper, Hokusai-crimson accent. Embedded figures from `visualization.md` sit calmly inside this chrome instead of fighting it.

Read this file before populating the `<style>` block in the Reveal.js template (`SKILL.md` → "Reveal.js template"). Sections 1–6 below are pasted into the template's `<style>` tag verbatim and in order.

---

## Aesthetic discipline

**The direction is refined minimalism — book-voice serif on warm paper, dusty Prussian chrome, single crimson accent.** Brutalist, maximalist, retro-futuristic, and luxury are all valid commitments for other projects; converging to sans-on-white is not. The model's natural pull on slide-generation tasks is toward generic-modern (Inter body, pure white background, blue links, Roboto in fallbacks, system-ui everywhere) — that is AI slop, and the only thing every extreme aesthetic has in common is rejecting it. This brand has already picked its extreme. Do not re-open the question per deck.

Hold the line on:

- **Typography.** Lora display + Newsreader body, both serif. Never substitute Inter, Roboto, Arial, system-ui, or Space Grotesk — not even as a fallback.
- **Palette role-distribution.** Dominant colors with sharp accents, not an evenly-balanced wheel. Roughly: cream / off-white surfaces cover ~90% of the slide area (warm paper + grain), dusty Prussian chrome ~8% (h2 color, table header band, eq-block left rule, callout borders, code background), Hokusai crimson ≤2% (one accent moment per slide — `.callout-result`, `.with-accent` h2 underline, outline-grid numerals, drop-pin on event lines). If crimson starts covering area, it has stopped being an accent.
- **Color sourcing.** Warm cream paper (`--c-paper-warm: #EFE6D2`), dusty-blue chrome, Hokusai-crimson accent. Not pure white. Not purple-gradient-on-white. Not generic blue-on-white "professional" themes. If a future edit pulls toward those, push back.
- **Layout.** Asymmetric where it helps the eye land (title slide); generous negative space over crowding everywhere else. Predictable component grids are the wrong solution to a "make it look clean" instinct — but heavy overlap, diagonal flow, and grid-breaking on interior result slides is the wrong solution to "make it look interesting." Reading clarity wins on Results.
- **Deck signature — one memorable differentiator per deck.** The Hokusai wave is this deck's wordmark: title slide only, bleeding off the lower-right corner. Do not repeat it on section dividers or interior slides — repeating a signature turns wordmark into decoration. Other decks may swap the wave for a different one-time mark (a stamped seal, a torn-paper edge, a single oversized initial), but the rule holds: one mark, title only, never twice.
- **Execution density.** Refined minimalism asks for *restraint and precision* — careful spacing, exact font weights, deliberate hierarchy. It is not the same as "fewer details" — fewer details executed sloppily reads as draft, not as refinement.

When in doubt, the test: would this slide look the same as a slide generated for a different paper, by a different person? If yes, the aesthetic has drifted to default. The brand only earns its keep when slides for *this* person are recognizable as such.

---

## 1. Design system tokens

These values are also mirrored in the personal-site `docs/css/tokens.css` so the website, slides, and figures share one identity. When updating either file, sync the other — the values are the source of truth, not the file.

```css
:root {
  /* Palette — Monet/Hokusai-aligned (matches visualization.md brand) */
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

  /* Typography — Lora display + Newsreader body. Both serif, both warm; pairing
     keeps the reading-group register (book voice, not magazine voice). Newsreader
     was designed for on-screen reading and holds at slide body sizes where Lora's
     display weight would feel heavy. Never substitute Inter / Roboto / Arial /
     system-ui / Space Grotesk — those are the AI-slop default that this brand
     exists to avoid. */
  --font-display: 'Lora', Georgia, 'Times New Roman', serif;
  --font-body:    'Newsreader', Georgia, 'Iowan Old Style', serif;
  --font-mono:    ui-monospace, 'JetBrains Mono', Consolas, monospace;

  /* Tuned for projection (≥24px body); HTML view scrolls when slides exceed
     720px, PDF export still requires the splits documented in references/pdf-export.md. */
  --fs-h1:    clamp(2.5rem,  5.5vw, 3.8rem);    /* 61px @1280 */
  --fs-h3:    clamp(1.4rem,  2.8vw, 1.85rem);   /* 29.6px */
  --fs-body:  clamp(1.3rem,  2.4vw, 1.6rem);    /* 25.6px */
  --fs-small: clamp(1.05rem, 1.7vw, 1.35rem);   /* 21.6px */
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

Load fonts in `<head>` before stylesheets (already in the SKILL.md template).

---

## 2. Base slide overrides

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
/* Use on headline-result slides so the eye knows this one matters.
   Hokusai crimson rule replaces the default thin cream. */
.reveal h2.with-accent {
  border-bottom-color: var(--c-accent);
  border-bottom-width: 3px;
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

---

## 3. Layouts, figures, tables

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

/* Outline grid — numbered two-column map. Each item is a flex stack so
   the section name sits above its one-sentence gloss. */
.outline-grid {
  list-style: none; padding: 0; margin: var(--sp-4) 0 0;
  display: grid; grid-template-columns: 1fr 1fr;
  gap: var(--sp-4) var(--sp-6);
  counter-reset: outline;
}
.outline-grid li {
  counter-increment: outline;
  position: relative; padding-left: var(--sp-6);
  display: flex; flex-direction: column; gap: 2px;
}
.outline-grid li::before {
  content: counter(outline, decimal-leading-zero);
  position: absolute; left: 0; top: 0;
  font-family: var(--font-display); font-weight: 700;
  font-size: 1.1em; color: var(--c-accent);
  line-height: 1.2;
}
.outline-grid li strong { font-family: var(--font-display); color: var(--c-ink); font-weight: 600; }
.outline-grid li span   { color: var(--c-ink-soft); font-size: var(--fs-small); }
.outline-grid li.outline-coda::before { color: var(--c-mint); }

/* Author bios grid */
.author-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: var(--sp-5); }
/* Cream offset ring reads as "matted print" — each photo sits inside
   a soft halo of paper-warm before the ink border. More museum than
   thumbnail. */
.author-card img.photo {
  width: 100%; max-width: 140px; aspect-ratio: 1 / 1;
  object-fit: cover; border-radius: 50%;
  border: var(--border);
  box-shadow: 0 0 0 5px var(--c-paper-warm), var(--shadow-xs);
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

---

## 4. Callouts

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

/* Equation block — wraps a display MathJax expression. Distinct from
   advisory callouts: left rule only (not full border), centered, slightly
   larger font for projection. MathJax renders $$…$$ inside. */
.eq {
  background: var(--c-paper-warm);
  border-left: 3px solid var(--c-primary);
  border-radius: var(--radius-sm);
  padding: var(--sp-4) var(--sp-5);
  margin: var(--sp-4) 0;
  text-align: center;
  font-size: var(--fs-body);
}
```

Usage: `.callout-warn` for LLM quality concerns and identification threats; `.callout-result` for headline findings; `.callout-tip` for methodological notes; `.eq` for any displayed equation that needs visual separation from prose (always pair with a `.gloss` list — see SKILL.md §"Equations get a symbol gloss").

---

## 5. Animation

Two layers: (a) a slide-entry choreography that plays once when each section becomes `.present` — heading first, then figure, then bullets cascade; (b) the existing fragment / li-stagger primitives for in-slide reveals.

```css
/* Slide-entry choreography — fires once when Reveal.js marks a section
   .present. Heading at 0ms, figure at +120ms, list at +200ms (then the
   li-stagger inside takes over). One orchestrated load per slide. */
.reveal .slides section.present > h2 { animation: slide-in 0.45s var(--ease-expo) both; }
.reveal .slides section.present > img,
.reveal .slides section.present .col-7-5 > img,
.reveal .slides section.present .fig-full {
  animation: slide-in 0.5s var(--ease-expo) 0.12s both;
}
.reveal .slides section.present > ul,
.reveal .slides section.present > ol,
.reveal .slides section.present .callout {
  animation: slide-in 0.45s var(--ease-expo) 0.2s both;
}
@keyframes slide-in { from { opacity:0; transform:translateY(14px); } to { opacity:1; transform:none; } }

/* Manual fragment + li-stagger primitives — unchanged. */
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
  *, .reveal .fragment,
  .reveal .slides section.present > * { animation: none !important; transition: none !important; }
}
```

---

## 6. Atmospheric texture & title-slide signature

Plain white paper reads as Slides™. Two cheap moves break out: a faint paper-grain SVG overlaid on every slide, and a Hokusai-wave ornament bleeding off the title slide. Together they make the deck recognisable as *yours* at a glance.

```css
/* Paper grain — SVG noise, 2% opacity. Embedded as a data URI so the
   slide HTML stays self-contained. The fractal noise + low contrast
   reads as paper, not screen artifact. */
.reveal .slides section {
  background-color: var(--c-paper);
  background-image: url("data:image/svg+xml;utf8,\
<svg xmlns='http://www.w3.org/2000/svg' width='160' height='160'>\
<filter id='n'><feTurbulence type='fractalNoise' baseFrequency='0.85' numOctaves='2' seed='4'/>\
<feColorMatrix values='0 0 0 0 0  0 0 0 0 0  0 0 0 0 0  0 0 0 0.04 0'/></filter>\
<rect width='100%25' height='100%25' filter='url(%23n)'/></svg>");
  background-size: 160px 160px;
}

/* Hokusai wave — the deck's wordmark. Title slide only. Sized so it
   bleeds off the lower-right corner; opacity tuned so the title card
   reads on top without contrast loss. */
.slide-title { position: relative; overflow: hidden; }
.hokusai-wave {
  position: absolute; right: -40px; bottom: -20px;
  width: 60%; max-width: 520px; height: auto;
  pointer-events: none; z-index: 0;
}
.slide-title .title-card { position: relative; z-index: 1; }
```

**Tuning notes.** The grain `baseFrequency='0.85'` is paper-fine; drop to `0.5` if it reads as static at projection scale. The wave SVG above is a stylised three-curve approximation, not a tracing of Hokusai's *Great Wave* — replace with your own SVG or a public-domain trace if you want true homage. The title-only rule for the wave is set in §Aesthetic discipline ("Deck signature").

---

## 7. Speaker-notes overlay — toggle on "N"

Reveal.js's built-in "S" key opens a popup speaker view in a second window — useful for dual-monitor podiums, useless on a laptop at a reading group. The "N" overlay is the lightweight alternative: a bottom-anchored panel that fades over the *current* slide and shows the script for that slide only. Press N to show, N again to hide.

The markup convention is Reveal.js's standard `<aside class="notes">` element placed inside each `<section>`, so the same content also feeds the "S" popup if someone uses it. The styling below is what makes "N" usable — it scopes display to `section.present` and skins the panel in brand colors so it reads as off-stage commentary, not slide content.

```css
/* Hidden by default — Reveal's own rule. Re-stated so it doesn't matter
   whether reveal.css loaded first. */
.reveal aside.notes { display: none; }

/* When body.show-notes is on, surface notes for the CURRENT slide only.
   Fixed-position bottom panel keeps the slide visible above it; the
   Hokusai-crimson left rule signals "talker-only", not slide content.
   Cream paper background ties the panel into the deck's surface palette
   so it doesn't read as a system-modal popup. */
body.show-notes .reveal section.present aside.notes {
  display: block;
  position: fixed;
  left: var(--sp-6); right: var(--sp-6); bottom: var(--sp-5);
  max-height: 38vh; overflow-y: auto;
  background: var(--c-paper-warm);
  border: 1.5px solid var(--c-line);
  border-left: 4px solid var(--c-accent);
  border-radius: var(--radius-md);
  padding: var(--sp-4) var(--sp-5);
  font-family: var(--font-body);
  font-size: var(--fs-small); line-height: 1.55;
  color: var(--c-ink); text-align: left;
  box-shadow: 0 4px 18px rgba(0,0,0,0.20);
  z-index: 1000;
}
body.show-notes .reveal section.present aside.notes::before {
  content: "Notes — press N to dismiss";
  display: block;
  font-family: var(--font-display);
  font-size: 0.78em; letter-spacing: 0.08em;
  text-transform: uppercase; font-weight: 600;
  color: var(--c-primary);
  margin-bottom: var(--sp-3);
  padding-bottom: var(--sp-2);
  border-bottom: 1px solid var(--c-line);
}
body.show-notes .reveal aside.notes p,
body.show-notes .reveal aside.notes li { color: var(--c-ink-soft); margin: var(--sp-1) 0; }
body.show-notes .reveal aside.notes strong { color: var(--c-primary); font-weight: 600; }
body.show-notes .reveal aside.notes ul { padding-left: var(--sp-5); margin: var(--sp-2) 0; }
```

The keybinding itself lives in the Reveal.js init script — see `SKILL.md` → "Reveal.js template". It overrides Reveal's default N-as-next-slide binding through the `keyboard` config map (`78: () => document.body.classList.toggle('show-notes')`), so Space and → still advance the deck while N is repurposed for the notes overlay.
