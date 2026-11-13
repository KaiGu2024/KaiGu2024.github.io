# Where’s Waldo? — reading-group preparation

Session: 13 November 2026. Presenter: Kai Gu, Bocconi University. Report mode.

Paper: Dayeon Ki, Ruochen Zhang, Silviu Cucerzan, Ryen W. White, and Ning Gao (2026), *Where’s Waldo? Query-language Preference under Cross-lingual Knowledge Disparities*, preprint, arXiv:2610.00606v1, 30 September 2026. The supplied PDF is authoritative. Original TeX and figure PDFs retrieved from https://arxiv.org/src/2610.00606v1 on 12 November 2026. TeX was available, so MinerU was unnecessary. Source inspection copies are in ignored exploratory/previews/slides/where-waldo/source/.

## Contribution and design

One-line contribution: a controlled multilingual QA benchmark shows that retrieving a missing fact across languages and choosing between conflicting accounts are different capabilities.

Research question: holding multilingual evidence fixed, does changing the query language change which account a model follows?

Data: Wikipedia dumps available 1 June 2026; revisions since January 2020; French, Simplified Chinese, Japanese, Korean, Bengali, each paired with English. This is five source languages plus English, not five total languages. Approximately 0.3% of candidate revisions survive initial curation. Final benchmark: 11,888 QA pairs. Model-specific filters retain facts occurring after each reported cutoff and questions answered incorrectly without documents in both languages. Samples differ by model: GPT-4o 5,129, GPT-4.1 3,708, GPT-5.5 968 (Table 8, p. 26).

Gap: target fact is in the source-language document and missing in English. Conflict: an LLM inserts a plausible incompatible fact into English, preserving tone and changing core attributes. Conflicts are constructed, not a sample of naturally contested claims. Reference answers always recover the original source-supported fact, rendered in the query language. The main experiment supplies two documents and randomizes document order while varying the query language. It isolates generation conditional on evidence availability; it does not identify the full retrieval-to-answer effect in a deployed search system.

Agreement is a judged match to the original reference fact, not agreement between documents or direct cross-language answer matching. Probability is a geometric mean of token probabilities for a fixed source-language reference answer; it is not the chance an answer is correct and is only reported for open-weight models. Figure 2 error bars are 95% bootstrap CIs; McNemar tests for agreement and Wilcoxon signed-rank tests for probability, with Bonferroni correction.

## Main results and interpretation

Figure 2 (p. 6): source-minus-English agreement gaps under missing knowledge are 15.9, 12.1, 18.2, 5.5, 3.5, 2.0, 1.3, 0.3 percentage points for LLaMA-3.1, Qwen-3, Aya-Expanse, GPT-4o, GPT-4.1, DeepSeek-V4, Grok-4.3, GPT-5.5 respectively. Conflict gaps are 69.0, 52.8, 52.3, 50.7, 51.4, 48.3, 52.4, 68.3 pp. All conflict differences are significant. The three OpenAI models descriptively show narrowing gaps for missing facts and widening gaps for conflicts. This is not a longitudinal or matched-sample causal comparison. In particular, the newer model's original-fact recovery under source queries rises much more than under English queries.

The English-query conflict agreement is roughly 20% for GPT-5.5 by visual reading of Figure 2, not uniformly 20% across models. It is recovery of the source-supported fact despite conflicting English evidence. A pooled rate cannot separate stochastic variation within items from stable heterogeneity across items. Do not label this a measured 20% random-answer probability. The locality explanation is a hypothesis; cite what has already been tested.

Mechanisms and mitigation: QPHA selects and ablates attention heads using gradient-activation attribution; QLoRA promotes original English answers and optionally contrasts conflicting answers. Three open-weight models only; selected conflict cases exhibiting preference; revision-level train/development/test separation. QLoRA reduces the agreement gap by up to 61.5% (abstract); this does not establish welfare gains or an optimal policy for genuinely unresolved conflicts. Retain only a short mitigation bridge in the final discussion, given the user's requested deck scope.

## Existing checks that change the discussion

- Reversed conflict roles: main-text Table 2, p. 7. Original facts are moved to English and conflicts to the other language. Direction reverses for all models. This is not a naturally sampled English-origin gap benchmark and does not establish symmetry of magnitudes.
- Retrieval: Appendix B.1, pp. 26–27, Table 9. 100 sampled QA pairs; original two Wikipedia documents are retained, plus two source-language and two English web documents. Pattern persists. The retrieval and evidence composition remain constrained; no unrestricted live-search estimate follows.
- Locality: Appendix C.4, pp. 32–33, Table 17 (caption uses an inconsistent subsection label). Binary LLM classification of culturally specific versus agnostic items; Welch tests of the source-minus-English agreement difference, for three open-weight models. No significant differences. This is not a test of English-query recovery levels or of locality effects on citations for OpenAI models. A null difference in a difference does not establish zero effects on either underlying rate. Do not quote Table 17's Chinese LLaMA difference: its printed subtraction is inconsistent (90.0 versus 55.0, listed as 0.150).
- Citation attribution: Appendix B.4, Table 12, p. 29; separate from answer agreement. Prompt A.7, p. 42, requests one sentence and the most relevant document ID. This can discourage richer expressions of unresolved disagreement.
- Knowledge parity: Appendix B.5, Table 13, p. 28. Adding the same fact to English generally yields near-zero gaps. The top row of Figure 2 is knowledge GAP, not this parity control.

## Talk map (user order takes precedence over generic skeleton)

1. Title and paper metadata.
2. “What’s Where’s Waldo?” using the supplied image, with its existing circle intact; visual search as the metaphor.
3. Authors, affiliations, and concise verified backgrounds.
4. Original Figure 1: naturally missing fact versus injected conflict; fixed-document comparison.
5. Original Figure 2: complete figure plus an interpretation view on the same slide. Explain agreement, OpenAI descriptive differences, roughly 20% following the other-language account, and the question characteristics distinguishing this group from the other 80%; retain the sample caveat. Preserve figure colors, intervals, axes, and legends. A magnification dialog allows either original row to fill the screen.
6. Reverse direction: does the result generalize to naturally English-origin information?
7. Interpretive knowledge: what changes when the task is explaining why?
8. Contested knowledge: what counts as a good answer to genuinely unresolved evidence?
9. Live search: how does source selection before generation change the result?
10. Locality: what distinguishes the roughly 20% of English-query questions that follow the other-language account from the other 80%? Compare local versus international topics and ask the same question in reverse, without assuming symmetric rates.
11. Consequences: niche cross-border shopping/recall context; separate language spillover from language preference and measure behavioral outcomes.
12. Sampling: distinguish within-item randomness from between-item selection.
13. Model comparison: evaluate shared items before calling the figure a generation trend.
14. Objective: consistency, accuracy, and calibrated acknowledgement of conflict can diverge.

One main discussion question per slide. Proposed applications and tests are explicitly hypothetical, not findings from this paper. No new research diagrams are drawn; placing original figures does not trigger the figure-agent workflow.

Working slot assumption: 30 minutes including discussion. Opening/example/authors 2 min; design 2 min; results 3 min; nine question introductions about 6 min combined; discussion 14 min; interruptions 3 min. Optional shorter route: slides 1–5, 6, 9–11, 14. Notes provide roughly 30–60 seconds of natural narration per slide, following project AGENTS.md over the skill's default brief-cue convention. Figure 2 can be held longer for discussion. No timed oral rehearsal is claimed.

## Asset provenance

- Supplied example: docs/reading_group/20261113_where_waldo/image.png, unchanged composition including the hand-drawn circle. User-provided illustration from Where’s Waldo?, Martin Handford; original page/edition unspecified. Embedded in the HTML.
- Figure 1: supplied PDF p. 2, original source figures/main_fig3.pdf; converted with PyMuPDF at 2x, no crop or redraw.
- Figure 2: supplied PDF p. 6, source figures/vanilla_fig.pdf and figures/conflict_fig.pdf; converted at 2x, no crop or redraw. Both complete rows retained. Numeric interpretation transcribed from the source figure, not inferred from pixel positions; ~20% explicitly approximate.
- Dayeon Ki: https://www.cs.umd.edu/people/dayeonki; PhD student, multilingual NLP/human-centered AI/HCI. Official headshot downloaded and square-cropped.
- Ruochen Zhang: https://www.ruochenzhang.com/; senior scientist at Microsoft, PhD Brown (defended April 2026), multilingual representation and interpretation. Current page has no headshot; omit.
- Silviu Cucerzan: paper affiliation Microsoft. Institutional profile https://www.microsoft.com/en-us/research/people/silviu/ now redirects to the people directory. Do not treat its historical search snippet as verified current role or reuse a different person's picture. Limit visible bio to paper affiliation and contribution area supported by his primary-authored workshop bio at https://www.cis.upenn.edu/~danroth/Talks/multi-lingual-EDL-07-18.pdf (NLP, knowledge representation, entity linking; PhD not included without direct verification).
- Ryen W. White: https://www.microsoft.com/en-us/research/people/ryenw/; distinguished scientist and VP, agentic AI/search/knowledge systems. Official headshot downloaded and square-cropped.
- Ning Gao: https://www.microsoft.com/en-us/research/people/nigao/; senior applied scientist, PhD Information Studies at Maryland; NLP/IR/knowledge extraction. Official headshot downloaded and square-cropped.

All author sites accessed 12 November 2026. Links are included with the relevant author entries. Paper affiliations and current roles are kept distinct where relevant.

## Validation record

Rendered all 14 slides in headless Chrome at 1600×900, using Reveal's 1280×720 canvas. Final checks show no slide overflow or out-of-slide content, all embedded images loaded, Plus Jakarta Sans loaded, and no browser JavaScript errors. Visually inspected the title, example, authors, both source figures, interpretation view, discussion layouts, closing slide, and contact sheets. Figure 1 and both Figure 2 rows support keyboard/click enlargement without cropping source content. Figure 2's two view buttons work. N toggles only the current slide's notes; representative notes on slides 1, 5, 10, and 14 fit without scrolling, with visible paragraph spacing and bold emphasis. Every slide has 75–93 words of narration. Reviewed adjacent-slide boundaries and read the narration continuously as text; no timed aloud rehearsal was performed.

Author portraits were available for Ki, White, and Gao. Zhang's current personal site has no photo; Cucerzan's institutional profile redirects. Their names and affiliations remain on the author slide without invented portraits or unverified current job titles. The source PDF and supplied image remain in the session directory; they were pre-existing user inputs and are not included as separate new publication files because the HTML embeds the required assets.

## Interpretation wording revision

The discussion centers on heterogeneity across questions: when both English and Chinese documents are supplied, which questions lead an English query to follow the Chinese account, and are they more local or international than the other questions? Chinese is illustrative: Figure 2’s roughly 20% GPT-5.5 rate pools source languages and does not establish a Chinese-specific rate or an equal reverse-direction rate. The remaining 80% means answers not matching the original fact; it need not consist entirely of answers endorsing the English account. Repeatability remains a separate follow-up question rather than the lead explanation. Updated the interpretation view, locality discussion, and connected speaker notes.

Revision validation: re-rendered slides 5, 10, and 12 and their N-key notes at 1600×900. All slide scroll heights equal the 720px canvas; notes fit without scrolling. Visually checked the interpretation view, locality question, and interpretation notes.
