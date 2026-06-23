# Methodological Standards — by journal layer

A verified, citable map of the methods literature an empirical appendix is most often
checked against. Use it for two jobs:

1. **Auditing a methodological statement** — when the appendix says "we use the
   Callaway–Sant'Anna estimator" or "we cluster at the firm level," check that the
   *named* method matches a real, current standard and that the appendix cites an
   appropriate guide. A method described without its canonical reference, or anchored
   only to a decade-old citation when the field has since moved (e.g. naïve two-way
   fixed effects for staggered adoption), is a weak spot the audit should flag.
2. **Authoring** — when you draft a method or robustness paragraph, reach for the
   current standard in the relevant field rather than the first paper that comes to
   mind.

Every DOI below was resolved against Crossref. They are anchors, not a reading list —
cite the one the appendix actually relies on, plus at most one foundational paper for
lineage (see the recency rule in `literature-review`). The layers exist because the
*same* method is described to different audiences: an econ referee wants the
staggered-DiD literature; a CS reviewer wants the prompt-engineering survey; a
*Nature* editor wants the reproducibility manifesto. Match the citation to the venue.

> **Scope.** These are methodological *guides and standards*, deliberately not the
> applied papers that use them. When the topic is niche or newer than this list, fall
> back to the `literature-review` skill (OpenAlex → Crossref) rather than citing from
> memory. Years are publication years; a few differ from Crossref's online-first date.

---

## Layer 1 — Economics

| Topic | Reference | Venue | DOI |
|---|---|---|---|
| Event-study / staggered DiD | Borusyak, Jaravel & Spiess (2024), *Revisiting Event-Study Designs* | Review of Economic Studies | 10.1093/restud/rdae007 |
| Parallel-trends sensitivity | Rambachan & Roth (2023), *A More Credible Approach to Parallel Trends* | Review of Economic Studies | 10.1093/restud/rdad018 |
| DiD, multiple periods | Callaway & Sant'Anna (2021), *Difference-in-Differences with Multiple Time Periods* | Journal of Econometrics | 10.1016/j.jeconom.2020.12.001 |
| TWFE under heterogeneity | de Chaisemartin & D'Haultfœuille (2020), *Two-Way Fixed Effects Estimators with Heterogeneous Treatment Effects* | American Economic Review | 10.1257/aer.20181169 |
| DiD synthesis / survey | Roth, Sant'Anna, Bilinski & Poe (2023), *What's Trending in Difference-in-Differences?* | Journal of Econometrics | 10.1016/j.jeconom.2023.03.008 |
| Staggered timing diagnosis | Goodman-Bacon (2021), *Difference-in-Differences with Variation in Treatment Timing* | Journal of Econometrics | 10.1016/j.jeconom.2021.03.014 |
| Synthetic control | Abadie (2021), *Using Synthetic Controls: Feasibility, Data Requirements, and Methodological Aspects* | Journal of Economic Literature | 10.1257/jel.20191450 |
| Clustered standard errors | MacKinnon, Nielsen & Webb (2023), *Cluster-Robust Inference: A Guide to Empirical Practice* | Journal of Econometrics | 10.1016/j.jeconom.2022.04.001 |
| ML for empirical work | Mullainathan & Spiess (2017), *Machine Learning: An Applied Econometric Approach* | Journal of Economic Perspectives | 10.1257/jep.31.2.87 |
| ML methods overview | Athey & Imbens (2019), *Machine Learning Methods That Economists Should Know About* | Annual Review of Economics | 10.1146/annurev-economics-080217-053433 |
| Double/debiased ML | Chernozhukov et al. (2018), *Double/Debiased Machine Learning for Treatment and Structural Parameters* | The Econometrics Journal | 10.1111/ectj.12097 |
| Text as data | Gentzkow, Kelly & Taddy (2019), *Text as Data* | Journal of Economic Literature | 10.1257/jel.20181020 |
| Text algorithms | Ash & Hansen (2023), *Text Algorithms in Economics* | Annual Review of Economics | 10.1146/annurev-economics-082222-074352 |

Journals represented: REStud, J. Econometrics, AER, JEL, JEP, Econometrics Journal, Annual Review of Economics (7).

## Layer 2 — Marketing & Information Systems

| Topic | Reference | Venue | DOI |
|---|---|---|---|
| Text/semantics measurement | Liu & Toubia (2018), *A Semantic Approach for Estimating Consumer Content Preferences from Online Search Queries* | Marketing Science | 10.1287/mksc.2018.1112 |
| Topic models for brand analysis | Tirunillai & Tellis (2014), *Mining Marketing Meaning from Online Chatter: Strategic Brand Analysis of Big Data Using LDA* | Journal of Marketing Research | 10.1509/jmr.12.0106 |
| Text-classifier comparison | Hartmann et al. (2019), *Comparing Automated Text Classification Methods* | Int. J. of Research in Marketing | 10.1016/j.ijresmar.2018.09.009 |
| Deep learning on visual/social data | Shin, He & Lee (2020), *Enhancing Social Media Analysis with Visual Data Analytics* | MIS Quarterly | 10.25300/misq/2020/14870 |
| AI strategy framework | Huang & Rust (2021), *A Strategic Framework for Artificial Intelligence in Marketing* | J. of the Academy of Marketing Science | 10.1007/s11747-020-00749-9 |
| Generative AI in marketing | Grewal, Satornino, Davenport & Guha (2024), *How Generative AI Is Shaping the Future of Marketing* | J. of the Academy of Marketing Science | 10.1007/s11747-024-01064-3 |

Journals represented: Marketing Science, JMR, IJRM, MISQ, JAMS (5). (JM/JCR intentionally excluded.)

## Layer 3 — Computer Science / ML / NLP

| Topic | Reference | Venue | DOI |
|---|---|---|---|
| Causal inference in NLP | Feder et al. (2022), *Causal Inference in Natural Language Processing* | TACL | 10.1162/tacl_a_00511 |
| Embedding stability | Antoniak & Mimno (2018), *Evaluating the Stability of Embedding-Based Word Similarities* | TACL | 10.1162/tacl_a_00008 |
| Prompting survey | Liu et al. (2023), *Pre-train, Prompt, and Predict* | ACM Computing Surveys | 10.1145/3560815 |
| LLM evaluation survey | Chang et al. (2024), *A Survey on Evaluation of Large Language Models* | ACM Trans. Intelligent Systems & Tech. | 10.1145/3641289 |
| LLMs for social science | Ziems et al. (2024), *Can Large Language Models Transform Computational Social Science?* | Computational Linguistics | 10.1162/coli_a_00502 |
| Model explainability | Ribeiro, Singh & Guestrin (2016), *"Why Should I Trust You?" Explaining the Predictions of Any Classifier* (LIME) | KDD | 10.1145/2939672.2939778 |
| LM risks / limits | Bender, Gebru, McMillan-Major & Shmitchell (2021), *On the Dangers of Stochastic Parrots* | ACM FAccT | 10.1145/3442188.3445922 |
| Bias & fairness | Mehrabi et al. (2021), *A Survey on Bias and Fairness in Machine Learning* | ACM Computing Surveys | 10.1145/3457607 |

Venues represented: TACL, ACM Computing Surveys, ACM TIST, Computational Linguistics, KDD, ACM FAccT (6).

## Layer 4 — General-interest / Multidisciplinary

| Topic | Reference | Venue | DOI |
|---|---|---|---|
| Interpretable ML | Murdoch et al. (2019), *Definitions, Methods, and Applications in Interpretable Machine Learning* | PNAS | 10.1073/pnas.1900654116 |
| LLM annotation | Gilardi, Alizadeh & Kubli (2023), *ChatGPT Outperforms Crowd Workers for Text-Annotation Tasks* | PNAS | 10.1073/pnas.2305016120 |
| GenAI for social science | Bail (2024), *Can Generative AI Improve Social Science?* | PNAS | 10.1073/pnas.2314021121 |
| LLM as measurement tool | Rathje et al. (2024), *GPT Is an Effective Tool for Multilingual Psychological Text Analysis* | PNAS | 10.1073/pnas.2308950121 |
| LLM hallucination detection | Farquhar, Kossen, Kuhn & Gal (2024), *Detecting Hallucinations in LLMs Using Semantic Entropy* | Nature | 10.1038/s41586-024-07421-0 |
| LLM behaviour / framing | Shanahan, McDonell & Reynolds (2023), *Role Play with Large Language Models* | Nature | 10.1038/s41586-023-06647-8 |
| LLM information extraction | Dagdelen et al. (2024), *Structured Information Extraction from Scientific Text with LLMs* | Nature Communications | 10.1038/s41467-024-45563-x |
| GenAI effects (causal) | Doshi & Hauser (2024), *Generative AI Enhances Individual Creativity but Reduces Collective Diversity* | Science Advances | 10.1126/sciadv.adn5290 |
| Causal inference with text | Egami, Fong, Grimmer, Roberts & Stewart (2022), *How to Make Causal Inferences Using Texts* | Science Advances | 10.1126/sciadv.abg2652 |
| Replicability | Camerer et al. (2018), *Evaluating the Replicability of Social Science Experiments in Nature and Science* | Nature Human Behaviour | 10.1038/s41562-018-0399-z |
| Reproducible-science standards | Munafò et al. (2017), *A Manifesto for Reproducible Science* | Nature Human Behaviour | 10.1038/s41562-016-0021 |
| Science of science / methods | Fortunato et al. (2018), *Science of Science* | Science | 10.1126/science.aao0185 |

Journals represented: PNAS, Nature, Nature Communications, Science Advances, Nature Human Behaviour, Science (6).

---

## How to use this during an audit

- **A method is named but uncited** → flag as a methodological gap; suggest the matching
  row above as the standard the appendix should cite.
- **A method is cited to an old or wrong source** → e.g. staggered-adoption DiD attributed
  only to a pre-2018 paper. Note that the heterogeneity-robust literature
  (Callaway–Sant'Anna, de Chaisemartin–D'Haultfœuille, Borusyak et al., Goodman-Bacon)
  is now the standard, and that the appendix should either adopt or explicitly address it.
- **A method's assumption is unstated** → e.g. DiD without a parallel-trends discussion,
  IV without relevance/exclusion, LLM annotation without validation against a human
  gold-set. The guides above each foreground the assumption the appendix tends to omit;
  use them to name the missing check.
- **Verify before citing.** When you add any citation to the appendix, run it through
  `verify-citations` / `literature-review` Path B. This file's DOIs are pre-verified;
  anything you add is not.
