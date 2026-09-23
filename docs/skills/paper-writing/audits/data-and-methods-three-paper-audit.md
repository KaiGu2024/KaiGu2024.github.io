# Data-and-methods audit: three established empirical papers

Audited 2026-09-23 against [data-and-methods.md](../references/sections/data-and-methods.md) at repository revision `021a382`. The initial guide covered the necessary topics but offered little development beyond a checklist. This audit examines how the same three papers connect those topics into an empirical account. Their recognition and bibliographic verification are recorded in the [introduction audit](../references/evidence/introduction-three-paper-audit.md).

## Scope and source versions

Read the cached full-text passages below, including surrounding discussion where needed. This is an exposition audit, not a replication or certification of each paper's identification and statistical procedures.

| Paper | Inspected version and locators |
|---|---|
| Egger, Haushofer, Miguel, Niehaus, and Walker, *General Equilibrium Effects of Cash Transfers: Experimental Evidence from Kenya*, Econometrica (2022), DOI 10.3982/ECTA17945 | [Published PDF](https://www.givedirectly.org/wp-content/uploads/2023/02/General-equilibrium-effects-of-cash-transfers-experimental-evidence-from-Kenya.pdf), §2 and §§3.1–3.7, pp. 2607–2615. PDF page = printed page minus 2602. |
| Gordon, Moakler, and Zettelmeyer, *Close Enough? A Large-Scale Exploration of Non-Experimental Approaches to Advertising Measurement*, Marketing Science (2023 issue; online 2022), DOI 10.1287/mksc.2022.1413 | [arXiv v2](https://arxiv.org/pdf/2201.07055v2), manuscript dated September 21, 2022. §3, pp. 10–14, read selection, overview, and feature descriptions; §4.1, pp. 14–15; §5 opening and assumptions through §5.1.1 opening, pp. 18–23. Figure-only intervening pages were inspected for context. PDF page = printed page plus 1. Observations concern this manuscript, not a newly verified final full text. |
| Gu and Zhu, *Trust and Disintermediation: Evidence from an Online Freelance Marketplace*, Management Science (2021 issue; online 2020), DOI 10.1287/mnsc.2020.3583 | Cached [publisher advance PDF](http://fengzhu.info/disintermediation.pdf), §§2–3 and §§4.1–4.2, pp. 3–7, with matching PDF pagination. |

## Observed development

**Economics.** Egger et al. explain the setting, transfer delivery, and two-level randomization before pairing household, enterprise, and price data with their specifications. Sampling, replacement households, follow-up timing, and tracking rates establish what each dataset represents. Linked household and enterprise sources clarify coverage and ownership. The spatial specification follows an explanation of why administrative boundaries are inadequate for spillovers. Coefficients are then translated into reported effects, with weights and normalization connecting populations and units. Assumptions, sensitivity references, and unresolved separation of effects appear near the relevant specification. [Source](https://www.givedirectly.org/wp-content/uploads/2023/02/General-equilibrium-effects-of-cash-transfers-experimental-evidence-from-Kenya.pdf)

**Marketing.** Gordon et al. distinguish experiments, treatment-control pairs, and experiment-outcome combinations, explaining the unit used in comparisons. Selection criteria, feature timing, and sample composition establish the analysis domain. Section 4.1 separates randomized assignment from realized exposure and explains why the experimental and observational analyses need a common treatment-effect target. Section 5 introduces the observational comparison before its assumptions and estimators, relating overlap to the exposure process. Methods and results are grouped by analysis rather than collected in one preliminary block. [Source](https://arxiv.org/pdf/2201.07055v2)

**Information systems.** Gu and Zhu explain the transaction process, reputation information, and experimental display before defining the sample and variables. They distinguish client assignment from job-level analysis, describe exclusions, and report differing availability across outcomes. Their measure discussion distinguishes transaction outcomes from message-based evidence of intent, explains the score's aggregation, and links a threshold to what clients were told. Descriptive distributions motivate transformations. The main regression appears alongside the question it addresses in Results. This illustrates both explicit operationalization and local placement of methods. [Source](http://fengzhu.info/disintermediation.pdf)

## Gaps and editorial decisions

| Initial gap | Development in the guide |
|---|---|
| Setting was mainly a list of background facts | Explain the process that generates behavior, observation, and variation; distinguish assignment and actual exposure where consequential. |
| Sample reporting lacked a connecting narrative | Trace source population to analysis sample, reconcile consequential counts and units, and relate observation windows to the event. |
| Measures were defined without enough interpretation guidance | Explain construction choices, complementary measures, validation, and the distance between observed traces and constructs. |
| Descriptive evidence had no explicit role | Use it to establish sample context, relevant variation, or reasons for an analytical choice; distinguish diagnostics and substantive findings. |
| Comparison and estimation could remain disconnected | State the target first, explain its inferential basis, then connect specifications and reported quantities to it. Align targets when comparing methods. |
| Flexibility lacked organizational criteria | Order by reader dependencies; allow data-specification pairs or methods adjacent to the corresponding results. |
| Methodological detail could become promotional or exhaustive | Explain suitability and consequential choices; reserve an advantage claim for a contribution that actually depends on it and defer routine implementation. |

These decisions combine observed practices with editorial judgment and the author's preference against overstressing methodological or data advantages. They do not imply that each paper states or satisfies every resulting principle.

## Limits and skill-creator review

All three papers use randomized evidence in some role; Gordon et al. also evaluate observational approaches against experimental benchmarks. This set does not directly validate a complete writing template for purely observational, structural, predictive, or qualitative research. The guide's short structural and predictive extensions preserve its existing scope and are general editorial guidance, not findings of this audit.

Source language is not automatically a recommended inference. For example, Gu and Zhu describe balance as confirming random assignment; the guide instead distinguishes evidence about implementation from proof of randomization. Likewise, rich covariates or plausible exposure variation do not by themselves establish all the assumptions needed for causal adjustment. These distinctions calibrate drafting without turning this exercise into a methodological referee report.

The revised guide separates reader needs from method-specific extensions, keeps paragraph and section structure flexible, and leaves source observations in this optional audit. Shared construct, voice, and grounding rules remain in their existing homes. It adds no routine audit deliverable, approval step, fixed paragraph count, or manuscript-specific hypothetical. The current [section guide](../references/sections/data-and-methods.md) governs drafting; this record explains its basis and limits.
