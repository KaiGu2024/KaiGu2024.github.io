# Reveal.js speaker notes (`report` mode)

This file applies only to the Reveal.js `report` mode for reading other people's papers. In `own` mode, use `own-work.md`: every Beamer frame requires natural spoken prose in `\note{...}`, with no skip exceptions.

Except for the skip cases below, each `<section>` in a report-mode deck gets an `<aside class="notes">` element holding **brief speaking cues** for that slide. At presentation time, press `N` to surface a cream overlay anchored to the bottom of the screen showing the current slide's notes; press `N` again to dismiss. The keybind (Reveal.js init script in `reading-other-papers.md`) overrides Reveal's default N-as-next-slide. Reveal's built-in "S" key still opens the dual-monitor speaker view from the same `<aside class="notes">` source.

The styling for the overlay lives in `aesthetics.md` §7. The CSS scopes the visible panel to `section.present`, so only the current slide's notes appear when N is toggled — exactly what you want mid-talk.

---

## The rule

Use **brief speaking cues**. Cue what to point to, what it means, and when to pause. Use keywords and short sentences the presenter can scan quickly. Cover each substantive element on screen, and anchor each planned claim or example in a visible label, mark, or short phrase.

Apply [talk-delivery.md](talk-delivery.md) for the opening, spoken interpretation, objections, closing, and time budget. Phrase claims as an appraisal of the authors' evidence. Keep detailed pacing plans and optional Q&A answers in `notes/<slug>.md`; only short reminders belong in the overlay.

Use 3–5 rows when possible, within the panel's height (≤38vh). Choose the cues the slide needs, such as context, a reading key, a finding, or its scope. Use prose to explain what a visible bullet means.

---

## What to write, per slide type

The table below is for a discussant appraising someone else's paper.

| Slide | Note content |
|---|---|
| **Title** | Introduce the paper and credit its authors. |
| **Motivation** | Point to the broad question or example. Explain the stakes in plain language before introducing names for paper-specific concepts. |
| **Author Bios** | One line per author *only if* there's something the audience should weight — known prior work, lab affiliation, methodological background. Skip names and titles; the slide already shows those. Often the right answer is no notes at all. |
| **Outline** | A one-sentence trip plan: *"We'll spend most of the time on §3 and §5; §2 is fast."* Cue the audience on pacing so they know where the load is. |
| **Data & Setting** | Explain why the authors used the dataset, how the sample was selected, and how the main restriction affects interpretation. |
| **Identification** | Explain the identifying assumption in plain language. Describe the condition the diagnostic tests and what it establishes about the design. |
| **Analytical Model** | The intuition behind the key comparative static, not the algebra. What does the model *predict* that a non-model account doesn't? |
| **Results (each)** | Say what the axes or table headings represent, point to one comparison, and pause while the audience finds it. Then say the headline number with units and uncertainty and explain its meaning and scope. |
| **Mechanism / Heterogeneity** | Explain what the comparison reveals about the proposed mechanism or the groups studied. State remaining ambiguity directly. |
| **Takeaways & Discussion** | The 30-second elevator version of the paper, then a bridge sentence into the discussion: which question you most want the room to take up first. |

---

## Markup

Markup-light HTML — use one `<p>` per speaking unit, with a visible gap that cues a pause. A short organizational label is optional; put `<strong>` around the actual words or short phrases to stress aloud. Labels alone are not vocal-emphasis cues. Follow [talk-delivery.md](talk-delivery.md) for natural phrasing and selective emphasis, while keeping the overlay brief. No tables, images, or callouts (the overlay is itself the callout).

```html
<section>
  <h2>Purchases rose by 3.2 percentage points</h2>
  <img src="{{data_uri}}" class="fig-full" alt="Event study of purchase-rate differences by weeks since treatment, with confidence intervals">
  <p>Week 0 · 95% CI [2.1, 4.3] percentage points</p>
  <aside class="notes">
    <p>Weeks since treatment on the horizontal axis. Estimated difference in purchase rates between treatment and control in percentage points on the vertical axis. Bars show 95% confidence intervals.</p>
    <p>[Point to week zero and pause.] The difference is <strong>3.2 percentage points</strong>. The interval runs from 2.1 to 4.3 percentage points.</p>
  </aside>
</section>
```

Use verified evidence in place of the illustrative finding. Inspect both the N overlay and S speaker view when used. Check that paragraph gaps and bold stress words are visible and that the cues fit without scrolling.

---

## When to skip report-mode notes

A few slide types are fine without an `<aside class="notes">`:

- Author Bios where there's nothing notable beyond name + institution.
- The Outline slide, if pacing is obvious from the section sizes.

In all other cases, ship the deck with notes populated — even one line is better than none. An empty `<aside class="notes">` is a code smell that the slide hasn't been rehearsed.
