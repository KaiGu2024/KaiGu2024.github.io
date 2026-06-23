# Empirical Exemplars — methodology-heavy applied papers and what their appendices carry

`methodology-standards.md` lists *guides* (papers about a method). This file lists the
other thing the audit/authoring needs: **methodology-heavy empirical papers** — applied
work that leans hard on causal inference, ML, NLP, or generative AI, and whose appendices
are good models for what a methodology-heavy appendix actually contains. Read them when
you want to see *how much* a top-journal appendix carries for a given method, and what a
referee will therefore expect yours to carry.

All DOIs resolved against Crossref. Use as exemplars, not citations to drop into a draft
unverified — and note that the *appendix* of each is the thing worth imitating, not just
the headline result.

## Layer 1 — Economics (heavy causal inference / text)

| Paper | Venue / DOI | Method load → appendix carries |
|---|---|---|
| Dobkin, Finkelstein, Kluender & Notowidigdo (2018), *The Economic Consequences of Hospital Admissions* | AER · 10.1257/aer.20161038 | event-study DiD → pre-trend tests, event-window robustness, sample-construction waterfall |
| Bhuller, Dahl, Løken & Mogstad (2020), *Incarceration, Recidivism, and Employment* | JPE · 10.1086/705330 | judge-leniency IV → instrument construction, monotonicity/exclusion, first stage, balance |
| Martin & Yurukoglu (2017), *Bias in Cable News: Persuasion and Polarization* | AER · 10.1257/aer.20160812 | IV + text-based slant measure → measure construction, instrument validity, robustness |
| Harasztosi & Lindner (2019), *Who Pays for the Minimum Wage?* | AER · 10.1257/aer.20171445 | DiD with exposure design → specification grid, alternative controls, placebo |
| Djourelova (2023), *Persuasion through Slanted Language* | AER · 10.1257/aer.20211537 | text-as-data measurement → corpus, dictionary/measure construction, validation, robustness |

## Layer 2 — Marketing & IS (heavy ML / NLP)

| Paper | Venue / DOI | Method load → appendix carries |
|---|---|---|
| Liu, Lee & Srinivasan (2019), *Large-Scale Cross-Category Analysis of Consumer Review Content … Leveraging Deep Learning* | JMR · 10.1177/0022243719866690 | deep-learning text pipeline → architecture, training, holdout validation, robustness |
| Hartmann, Heitmann, Schamp & Netzer (2021), *The Power of Brand Selfies* | JMR · 10.1177/00222437211037258 | image ML (CNN) → classifier construction, human-validation, alternative-measure robustness |
| Timoshenko & Hauser (2019), *Identifying Customer Needs from User-Generated Content* | Marketing Science · 10.1287/mksc.2018.1123 | ML/NLP pipeline → preprocessing, model details, human-validation of extracted needs |
| Liu, Dzyabura & Mizik (2020), *Visual Listening In* | Marketing Science · 10.1287/mksc.2020.1226 | deep learning on images → architecture, training, validation against human ratings |
| Shin, He & Lee (2020), *Enhancing Social Media Analysis with Visual Data Analytics: A Deep Learning Approach* | MIS Quarterly · 10.25300/misq/2020/14870 | deep learning on images+text → model architecture, training, evaluation, ablations |
| Golossenko et al. (2020), *Seeing Brands as Humans* | IJRM · 10.1016/j.ijresmar.2020.02.007 | scale + ML validation → item development, reliability/validity, replication studies |

> Journals: JMR, Marketing Science, MISQ, IJRM (4) — JMR / MS / MISQ-ISR / IJRM are the
> field-top outlets in the `literature-review` whitelist. (Earlier JCR and JM entries were
> dropped per preference.)

## Layer 3 — CS / NLP (empirical evaluation & benchmark studies)

These are the marquee-venue counterparts: empirical evaluation / benchmark papers whose
appendices are *the* model for reproducibility-heavy method reporting (prompts verbatim,
decoding params, compute, splits, annotation protocols). NeurIPS/ICLR proceedings carry
no Crossref DOI, so they're cited by arXiv ID + venue (each verified to exist on arXiv).

| Paper | Venue / link | Method load → appendix carries |
|---|---|---|
| Brown et al. (2020), *Language Models Are Few-Shot Learners* (GPT-3) | NeurIPS 2020 · arXiv:2005.14165 | large-scale few-shot eval → dataset/decontamination details, per-task setup, compute, broader-impact |
| Hendrycks et al. (2021), *Measuring Massive Multitask Language Understanding* (MMLU) | ICLR 2021 · arXiv:2009.03300 | multi-domain benchmark → task construction, source provenance, per-subject breakdowns |
| Wei et al. (2022), *Chain-of-Thought Prompting Elicits Reasoning in LLMs* | NeurIPS 2022 · arXiv:2201.11903 | prompting eval → prompts verbatim, decoding params, per-benchmark setup, ablations |
| Zhang, Ladhak et al. (2024), *Benchmarking Large Language Models for News Summarization* | TACL · 10.1162/tacl_a_00632 | LLM evaluation → prompts, decoding params, annotation protocol, agreement, compute |

> **On TACL:** it's the ACL flagship *journal* (rigorous peer review, presented at
> ACL/EMNLP) — a legitimately strong venue, kept here as the journal-style example. The
> NeurIPS/ICLR rows are the marquee-conference exemplars. CS conference appendices are
> also governed by venue reproducibility checklists — see `appendix-conventions.md`.

## Layer 4 — General-interest (methodology-heavy empirical)

| Paper | Venue / DOI | Method load → appendix carries |
|---|---|---|
| Chetty et al. (2022), *Social Capital I: Measurement* | Nature · 10.1038/s41586-022-04996-4 | population-scale measurement → data construction, privacy protocol, measure validation, robustness |
| Doshi & Hauser (2024), *Generative AI Enhances Individual Creativity…* | Science Advances · 10.1126/sciadv.adn5290 | field experiment + LLM → design, randomization, scoring/rater protocol, full materials |
| Guess et al. (2020), *A Digital Media Literacy Intervention…* | PNAS · 10.1073/pnas.1920498117 | multi-country experiment → design, balance, multiple-comparison handling, instruments |
| Hackenburg & Margetts (2024), *Evaluating the Persuasive Influence of Political Microtargeting…* | PNAS · 10.1073/pnas.2403116121 | LLM-generated treatment + experiment → message generation protocol, preregistration, robustness |
| Le Mens et al. (2023), *Uncovering the Semantics of Concepts Using GPT-4* | PNAS · 10.1073/pnas.2309350120 | genAI as measurement → prompt protocol, validation against human judgments, reliability |
| Rathje et al. (2024), *GPT Is an Effective Tool for Multilingual Psychological Text Analysis* | PNAS · 10.1073/pnas.2308950121 | genAI measurement → validation against human-coded benchmarks across languages |

---

## How to use these during authoring/audit

- **Calibrate expectations.** When the paper uses method X, find the exemplar above that
  uses X and check your appendix carries the same *categories* of support (construction,
  assumptions/validity, robustness, materials). A genAI-measurement paper with no
  human-validation appendix is below the bar these papers set.
- **The pattern is consistent across method families:** appendix = construction details +
  the assumption/validation the method hinges on + robustness + full materials. The
  fourth column above names the method-specific version of that pattern.
- **Pair with the guides.** The exemplar shows *what* to include; the matching row in
  `methodology-standards.md` gives the citable standard for *why* it's done that way.
