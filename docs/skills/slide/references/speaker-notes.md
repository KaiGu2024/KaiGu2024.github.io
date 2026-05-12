# Speaker Notes — what to write per slide

Every `<section>` in the deck gets an `<aside class="notes">` element holding the **script you would say aloud** for that slide. At presentation time, press `N` to surface a cream overlay anchored to the bottom of the screen showing the current slide's notes; press `N` again to dismiss. The keybind (Reveal.js init script in `SKILL.md`) overrides Reveal's default N-as-next-slide. Reveal's built-in "S" key still opens the dual-monitor speaker view from the same `<aside class="notes">` source.

The styling for the overlay lives in `aesthetics.md` §7. The CSS scopes the visible panel to `section.present`, so only the current slide's notes appear when N is toggled — exactly what you want mid-talk.

---

## The rule

Notes are a **script**, not a recap of what's already on the slide. Read what's on the slide; *write what you'd add*. 30–60 seconds of speaking. Three short paragraphs or 3–5 bullets, never more than fits the panel without scrolling (≈38vh).

If the slide already has bullets, don't restate them. The bullets are for the audience; the notes are for you.

---

## What to write, per slide type

| Slide | Note content |
|---|---|
| **Title** | (1) the 1-sentence hook — a concrete example or stat that lands the motivation in the first 20 seconds; (2) why *this* paper / why *this* audience cares; (3) where the talk is going (preview the punchline). |
| **Author Bios** | One line per author *only if* there's something the audience should weight — known prior work, lab affiliation, methodological background. Skip names and titles; the slide already shows those. Often the right answer is no notes at all. |
| **Outline** | A one-sentence trip plan: *"We'll spend most of the time on §3 and §5; §2 is fast."* Cue the audience on pacing so they know where the load is. |
| **Data & Setting** | (1) the *real* reason for the dataset (often opportunistic, not principled — say it); (2) the single biggest sample-design concern *you* would push back on if you were the discussant; (3) which filtering step is most consequential — usually the one that drops the most informative units, not the largest one. |
| **Identification** | Plain-English restatement of the identifying assumption — no jargon. Then: the most plausible *story* that would violate it, and whether the diagnostic the authors run actually addresses *that* story (often it addresses a different, easier one). |
| **Analytical Model** | The intuition behind the key comparative static, not the algebra. What does the model *predict* that a non-model account doesn't? |
| **Results (each)** | (1) the headline number to read aloud, with units and benchmark — *"a 3.2 percentage-point increase, off a 12 pp base — about a 27% lift"*; (2) what to physically point at on the figure; (3) one sentence of interpretation; (4) the most likely audience pushback and how the paper handles it (or doesn't). |
| **Mechanism / Heterogeneity** | The "so what" — what this slide *rules out*, not just what it shows. Mechanisms are credible when they kill alternatives, not when they're consistent with the headline. |
| **Takeaways & Discussion** | The 30-second elevator version of the paper, then a bridge sentence into the discussion: which question you most want the room to take up first. |

---

## Markup

Markup-light HTML — `<p>`, `<ul><li>`, `<strong>` for the words you most want your eye to catch when glancing down. No tables, no images, no callouts (the overlay is itself the callout).

```html
<section>
  <h2>Treatment raised purchases by 3.2 pp</h2>
  <img src="{{data_uri}}" class="fig-full" alt="Event study, ±8 weeks">
  <h3>Description</h3>
  <ul><li><strong>Magnitude</strong>: +3.2 pp, 95% CI [2.1, 4.3]</li></ul>
  <aside class="notes">
    <p><strong>Read aloud:</strong> 3.2 percentage points off a 12-point base — about a 27% lift.</p>
    <p><strong>Point at:</strong> the pre-period — flat, no anticipation. The kink is sharp at week 0.</p>
    <p><strong>Pushback to expect:</strong> the CI widens after week 4 because the panel thins. Authors handle it with a balanced-panel robustness in Table A5 (mention only if asked).</p>
  </aside>
</section>
```

---

## When to skip notes

A few slide types are fine without an `<aside class="notes">`:

- Author Bios where there's nothing notable beyond name + institution.
- Pure-figure recap slides shown briefly in transition (rare).
- The Outline slide, if pacing is obvious from the section sizes.

In all other cases, ship the deck with notes populated — even one line is better than none. An empty `<aside class="notes">` is a code smell that the slide hasn't been rehearsed.
