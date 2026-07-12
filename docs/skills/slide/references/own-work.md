# Own-work mode — presenting your own paper

Read this in `own` mode (see `SKILL.md` → "Modes"). It replaces the `report` 7-slide skeleton with an own-work structure and adds two capabilities the `report` mode deliberately withholds: a **motivating-example sequence** before the outline, and **web-sourced external assets** for that motivation.

Everything not covered here is shared with `report` mode — the aesthetic (`aesthetics.md`), self-contained base64 embedding, the `.tmp_edit/` base64-edit discipline, equation glosses, the press-N overlay, titles/dense-slide/results-layout rules in `SKILL.md` Step 3, and PDF export. Do not re-derive those; inherit them.

**The register shift.** `report` mode is a discussant appraising someone else's work — it opens with author bios and closes by handing the room five questions. `own` mode is the author making a case: it opens by convincing the room the problem is *real and worth solving*, and closes by stating what the paper contributes. Two things move to the front and back accordingly.

---

## Own-work skeleton (12–16 slides)

| # | Slide | Notes |
|---|---|---|
| 1 | **Title** | Full title; authors (you + coauthors) + affiliations; venue / status. *Optional* one-sentence headline result in a `.callout-result`. **No Author Bios slide follows** — you are the author; a bios slide is for reporting others. |
| 2–4 | **Motivation sequence (2–3 slides)** | The core of own-work mode. Concrete example → "it's happening" → why it matters. External web-sourced assets allowed here (and only here). See below. |
| 5 | **Research question / gap** | The pivot from motivation to contribution: what is unknown, the tension the example exposes, and the precise question this paper answers. One slide. |
| 6 | **Outline** | Substantive **analyses** only — same rules as `report` (`SKILL.md` Step 3 → Outline). May preview the contribution in the one-liners. `class="dense"`. |
| 7 | **Data & Setting** | Same layout as `report`. Presenter voice: state the design choice and *why it is the right one*, not what a discussant would attack. |
| 8 | **Identification / Strategy** | Same layouts and the `aesthetics.md` §identification table apply. Presenter voice: defend the design; name the assumption *and the diagnostic you ran that supports it*. |
| 9–N | **Results** | Reproduce your own tables/figures (`.fig-full` / `.col-7-5` / `.col-6-6`). Same Description + Analysis structure. Lead with the number. |
| — | **Analytical Model** | Immediately before Results if the paper has a formal model — same as `report`. |
| N+1 | **Contributions + Conclusion** | Replaces `report`'s Takeaways & Discussion. See below. `class="dense"` if it runs long. |

**Two hard differences from `report`:** (1) delete the **Author Bios** slide — never include it in `own` mode; (2) replace the **Takeaways + 5 discussion questions** coda with **Contributions + Conclusion**.

---

## The motivation sequence (slides 2–4)

The job of these slides is to make the room believe, before any theory, that the problem is **real** (it is actually happening, not hypothetical) and **important** (the stakes are large enough to care). This is where a talk earns attention. **Simplicity is the governing rule** — one idea per slide, a big visual, few words. If a slide needs a paragraph to land, it is doing too much.

Build the sequence in this order (use all three when the problem needs the full setup; collapse to two when the example itself already conveys scale):

1. **Concrete example — the hook.** One vivid, real instance the audience can picture: "meet X…", a screenshot of the actual thing, a single case walked through in a sentence. Not aggregate statistics yet — a person, a document, a transaction. Layout: `.col-7-5` (the image left/right + a one-line caption) or `.fig-full` for a single dominant image. This is the slide people remember.
2. **"It's happening" — evidence of scale.** Show the example is not a one-off: a trend line going up, a large count, a cluster of real headlines. This is where an **external** figure or statistic earns its place — a market-size number, an adoption curve, a news montage the paper itself does not contain. Layout: `.stat-hero` for a single dominant number, or an external chart via `.col-7-5`. **Any web-sourced asset carries a `.source-caption`** (see below).
3. **Why it matters — the stakes.** Who is affected and by how much; why the field or practice should care that this is happening. Keep it to one claim: the consequence that makes the question worth a paper. This slide can fold into slide 2 if the scale number already implies the stakes.

**What the motivation is *not*.** It is not a literature-positioning slide (that belongs to the research-question slide and the contribution paragraph). Do not open with "prior work has studied…"; open with the phenomenon. Resist stacking three statistics where one lands harder.

---

## Web-sourcing external motivation assets

`own` mode is the one context where the skill may pull assets the paper does not contain — but **only for the motivation slides**, and results/identification figures still come from the paper. The pipeline parallels the Author-photo pipeline in `SKILL.md`:

1. **Find** — `WebSearch` for the statistic, chart, or image (e.g. `"generative AI adoption" survey 2024 chart`, `<phenomenon> news`). Prefer a reputable, citable source — a research org (Pew, gov statistics, an established outlet, a peer-reviewed figure) over a random blog.
2. **Fetch** — `WebFetch` the page; locate the asset URL and note the source name + year for attribution.
3. **Normalize + embed** — download, and **base64-embed** it. The self-contained-HTML rule still holds: no external `src=` URLs in the deck, no `slide/assets/`. Reuse the helpers already in `SKILL.md`: `to_data_uri()` for a raster you keep as-is, or the PIL crop/resize snippet from the Author-photo pipeline when it needs squaring/downsizing.
4. **Attribute** — every web-sourced asset gets a visible `.source-caption` line beneath it (e.g. `<p class="source-caption">Source: Pew Research Center, 2024</p>`). Attribution is not optional; it is what separates a credible motivation from a decorative one.

**Guardrails.** Prefer figures/stats you could cite in the paper over stock imagery. Favor clarity and legibility over completeness — one clean external chart beats a screenshot of a dense dashboard. If nothing reputable turns up, state the scale in words with `.stat-hero` rather than embedding a weak asset. Do **not** fabricate a statistic to fill the slide.

---

## Contributions + Conclusion (closing slide)

Replaces `report`'s Takeaways & Discussion. The room should leave able to state, in one breath, what the paper adds. Structure:

- **Contributions** — 2–3 bullets, each naming *what is new* (a fact established, a mechanism identified, a method, a managerial lever), not a summary of what you did. Phrase as the addition to knowledge, not the activity.
- **Headline result** — restate the single number that carries the paper, with its benchmark, in a `.callout-result`.
- **Conclusion** — one or two sentences on what it means and, optionally, what is next. Close on a clean Q&A / thank-you beat rather than a list of open questions posed to the room.

`class="dense"` if contributions + result + conclusion overflow the large tier.

---

## Speaker notes — presenter voice

The per-slide guidance in `references/speaker-notes.md` is written for a discussant ("pushback to expect", "what *you'd* push back on as the discussant"). In `own` mode, **invert it**: the notes anticipate the objection *and carry your answer*.

- **Title / motivation** — the notes hold the hook you say aloud and the one-line stakes, not "why this audience cares about someone else's paper."
- **Results / identification** — instead of "the most likely audience pushback and whether the paper handles it," write **the objection you expect and your ready response** (the robustness table, the placebo, the scope condition). You are defending, not appraising.
- **No Author-Bios note, no discussion-questions bridge** — those slide types do not exist in `own` mode.

Everything else about the notes (a 30–60s script, not a recap; markup-light `<p>`/`<ul>`/`<strong>`; the press-N overlay) is unchanged.
