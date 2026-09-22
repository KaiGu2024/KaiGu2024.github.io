# Main Text — drafting the paper

Academic writing makes the paper's **contribution legible**. The introduction should quickly establish the question, why it matters, and what the paper contributes. This skill consumes the artifacts that [report](../../report/SKILL.md) produces and turns them into the abstract, introduction, results, and conclusion of a paper.

The following is an adaptable writing framework for empirical economics, management, information systems, and marketing. Its rhetorical moves are not universal journal requirements. Match the paper's contribution, the author's requested scope, and the target venue's verified constraints.

---

## Movement 1 — Abstract

### Compress the argument, not the paper

Treat the abstract as the paper's intellectual argument in miniature, not one sentence per manuscript section. Finalize it after the findings and framing stabilize; an earlier working abstract can help clarify the argument.

Use the author's supplied word budget. For submission-ready work, verify the target journal's current abstract limit and format from official author guidance; flag any conflict with the requested budget. If no venue or budget is given, produce a concise draft without claiming a universal limit. If guidance cannot be accessed, state that the limit is unverified and proceed with a clearly provisional budget. Do not impose five sentences or 150 words unless explicitly required.

These are **five rhetorical moves, not five mandatory sentences**. Combine, reorder, or omit conditional moves when the argument warrants it:

1. **Problem and tension.** Make the substantive question, unresolved distinction, puzzle, constraint, or decision legible. Prefer the paper's specific problem to an opening about a technology's growing importance. Do not invent a paradox or opposing effects for a paper whose contribution does not require them.
2. **Empirical object.** Identify the setting, comparison, and design needed to understand what the evidence represents. Include scale when informative; compress secondary sample sizes, estimator names, implementation details, and validation steps unless these are central contributions. Retain what distinguishes descriptive, causal, and model-based evidence.
3. **Central finding.** State the substantive pattern before or together with a selective quantitative anchor. Organize around the conceptual result, not the order of tables. Give the unit and comparison needed to interpret a magnitude, and retain uncertainty when it changes the takeaway; do not pack in every estimate or silently turn imprecision into certainty.
4. **Interpretation and informative extensions.** Include a boundary condition, mechanism, characterization, institutional comparison, or simulation only when it materially changes the headline's interpretation. Heterogeneity is not automatically a mechanism; model-implied outcomes are not observed effects. Omit this move if unsupported or unnecessary.
5. **Significance.** Name what readers should now distinguish, believe, evaluate, or decide differently. "Provides new insights" or "has important implications" is insufficient unless the precise object follows. A measured distinction can warrant a new evaluation question without establishing a welfare ranking or policy prescription.

The contrast with Results prose is deliberate: **abstract = substantive pattern → selective quantitative anchor → interpretation; Results subsection = question → finding/estimate with decisive evidence → interpretation.** Neither requires a bare number as the opening words.

### Select evidence by its job

Before compressing, classify the available findings internally. This is a priority guide, not a quota or an instruction to manufacture missing analyses.

| Role | Abstract treatment |
|---|---|
| Headline | State the central finding or decomposition directly. |
| Explanatory | Include supported evidence needed to understand why, where, or for whom the headline holds; distinguish a tested mechanism from an interpretation. |
| Interpretive extension | Include selectively if it changes the theoretical or managerial takeaway. |
| Corroborative | Usually fold into the headline clause, preserving any different sample or measurement scope. |
| Robustness | Usually omit from the abstract; retain when it materially qualifies credibility or is itself the contribution. |

Assign roles by the paper's claim, not by method name. A simulation can be the headline in a model-based paper; validation can be central in a measurement paper. Use a deletion test: if removing an analysis leaves the central interpretation unchanged, it probably does not need its own abstract sentence. Material contradictory evidence is not disposable "robustness."

### Decomposition before a masking aggregate

When the contribution is that an aggregate masks opposing components, foreground those components and explain the net outcome as their consequence. Do not automatically headline the aggregate merely because it has the largest or most familiar number. Conversely, do not bury an aggregate that is the author's actual central question.

An accounting identity such as `Y = A + B` requires compatible units, populations, and definitions, with exhaustive, nonoverlapping components. Estimated component changes need the same estimand and compatible estimation to reconcile; do not add estimates from different samples or specifications. Conceptual contrasts such as quantity versus quality are not automatically additive identities, and opposing movements alone do not identify a causal tradeoff.

**Hypothetical illustration, not a reported study:** suppose a common-sample accounting decomposition attributes a 6-unit increase in total content to 8 more transferred units and 2 fewer source-relative additions. "More content contains more transfer but fewer additions beyond the source" conveys the tension before the magnitudes. Whether that is an improvement requires a separate evaluation criterion; "source-relative additions" does not mean verified knowledge or world-first novelty.

Apply the local construct lock in Movement 8 before drafting, then the evidence hierarchy here, then the substantive-compression rules in Movement 5. Deliver the requested abstract, not the internal planning apparatus, unless the author asks for it.

---

## Movement 2 — Introduction

Build a short path from the substantive question to the paper's answer and contribution. Choose the opening's level of abstraction according to what readers need to understand that question. A construct-led opening is useful when the conceptual relationship needs explanation before the setting becomes informative. An opening through an existing mechanism, a concrete puzzle, or the question itself can move faster when that relationship is already clear. Do not manufacture a disruption or force every paper through the same opening. Length and paragraph count follow the argument, the author's budget, and verified venue constraints.

### Developing the first two or three paragraphs

Use three connected moves: **conceptual relationship → concrete manifestation → consequential problem**, followed by an explicit research-question bridge before the empirical overview. These are argumentative functions, not fixed paragraph slots. Problematization may begin in the first move and sharpen as the opening becomes more concrete.

1. **Establish the construct through its relationship to the paper's other central subject.** Choose the abstraction that carries the research question; it can concern an outcome, explanatory factor, process, or relationship, and need not be the dependent variable. Define its essential meaning where needed, especially for a new construct, and keep terminology consistent with Movement 8. Explain the historical, theoretical, practical, or substantive relationship that motivates the inquiry. Select the relevant connection rather than covering every kind of background. History earns space when it explains how the relationship arose or why a prior expectation makes sense. By the end of this move, readers should see the direction of the question, even if its exact formulation comes later. Specific sites, datasets, and operational measures can wait unless they are necessary to understand the conceptual problem.

2. **Narrow to a concrete manifestation and explain why it is informative.** Introduce a particular form, application, practice, or institution that realizes the abstraction. Describe real-world development or adoption only insofar as it changes the relationship, reveals a relevant condition, or makes the unresolved issue consequential. Explain why this manifestation helps investigate the same conceptual question. A definite determiner or more specific noun phrase can maintain continuity, but the substantive narrowing must identify what changed in scope and why it matters. Keep the construct's meaning stable as its domain narrows. Distinguish the manifestation from the empirical setting where it is studied and the measure used to observe it; these do not have to enter together. Conceptual relevance motivates the setting choice; empirical credibility still requires a design and evidence.

3. **Develop the consequential problem.** Identify what remains uncertain and why resolving it matters. Practical motivation should name the decision, behavior, or consequence affected by the uncertainty. Theoretical motivation should identify the assumption, mechanism, prediction, or boundary condition that existing explanations leave unresolved. An omitted moderator or mitigating process matters when it could change an explanation or prediction; its omission alone is insufficient. Distinguish an unexamined application, an unresolved prediction, and evidence that contradicts a prediction. Claim theoretical failure only when supported. Avoid relying solely on a lack of studies in this setting, and do not require both practical and theoretical motivation if only one carries the contribution. Establish the stakes and direction of the question; use the bridge below to articulate the precise unresolved issue.

**Paragraph allocation.** In a two-paragraph motivation, establish the conceptual relationship and initial uncertainty in paragraph 1; connect its manifestation to the sharpened problem in paragraph 2. In a three-paragraph motivation, the manifestation and developed problem can each receive a paragraph. Alternatively, develop the theoretical problem before introducing the manifestation when that order makes the setting's relevance clearer. Signal the question's direction early; do not spend two paragraphs on background before revealing what needs explaining. Follow with the research-question bridge, or let the final motivation paragraph perform that function when it can do so clearly without repetition.

Support factual and literature claims with supplied evidence or visible source placeholders. Keep the opening focused on the relationship and problem; broad background earns space only when it advances that argument.

### Research-question bridge

Connect the final motivating problem to the nuance of the closest prior research: **what prior work establishes → what its assumptions, scope, or evidence leave unresolved → the question this paper must answer empirically**. Use a focused paragraph before "what we do" when the gap needs its own development. Integrate the bridge into the final motivation paragraph or the opening of the study preview when the reasoning is already compact and clear. Cite only the work needed to establish the gap; broader literature positioning follows the findings.

Make the gap an unresolved inference, not a declaration that few studies exist. Explain why available knowledge does not settle the relevant direction, magnitude, conditions, or interpretation. "Therefore, this is an empirical question" should express that reasoning rather than substitute for it. A known directional prediction can still leave consequential magnitudes or boundary conditions unresolved; do not manufacture opposing predictions. State the question as an explicit interrogative or a research-objective statement, choosing the form that suits the project. Use the constructs established in the opening and a scope the evidence can address. If there are subquestions, show how they develop the central question.

**Where to explain answerability.** When an observation, measurement, or identification obstacle constrained prior work, explain what previously prevented an answer and what this study makes possible. Place this explanation in the bridge if it helps establish the question, or in "what we do" if readers need the dataset or design description to understand the advance. State the specific capability gained; claims that earlier studies could not answer the question need support. Develop the explanation once, in whichever location fits the argument.

### From the research question to the contribution

Use the preferred progression **what we do → findings and their interpretation → literature positioning → contributions and their significance → roadmap**. These are rhetorical moves within the introduction, not required section headings. Findings and interpretation can each span multiple paragraphs or be developed together. Separate design and mechanism paragraphs are optional additions when those features carry a distinctive contribution.

- **What we do.** Explain how the empirical approach answers the question established by the bridge. Identify the setting, data, comparison, and design needed to understand what the evidence represents. Include sample, period, source of variation, and the central identifying assumption where relevant. Make clear whether the approach supports descriptive, causal, or model-based claims. Introduce measurement detail here when it materially bounds the conceptual claim; reserve implementation detail for later sections. Include the essential credibility argument here even when the design does not warrant a separate paragraph.
- **Findings and interpretation: develop a logical line.** Identify the central answer and the role of each supporting finding: what it establishes, explains, qualifies, or changes about that answer. Select findings with Movement 1's evidence hierarchy, then order them by these substantive dependencies across as many paragraphs as the argument needs. Explain why each next finding follows and how it changes the interpretation of the preceding evidence. State the substantive finding before or with a selective magnitude and relevant uncertainty; connect the combined answer to the conceptual relationship in the opening. Avoid an inventory of analyses or equally weighted results. Do not force a mechanism, decomposition, or causal sequence unsupported by the evidence. **Optional alternative-explanation check:** if the project includes an analysis that materially distinguishes the proposed interpretation from another explanation, include it briefly in the findings or their interpretation. State the ambiguity addressed and what remains unresolved. Do not require a check paragraph or new analysis merely to fill this move.
- **Literature positioning.** Use a focused paragraph to locate the paper within the relevant literature strands: what the closest work establishes, how the strands connect, and where this paper extends, qualifies, or links them. Establish the scholarly relationship rather than repeat the motivating gap or list citations. Expand across paragraphs when meaningful comparisons require it.
- **Contributions and their significance.** A separate paragraph can explain what the paper adds. For substantive empirical papers, build this account primarily from the findings: what they establish or change about the phenomenon, explanation, or decision. This gives it a different job from literature positioning, so the two paragraphs need not overlap. Identify substantive, methodological, or theoretical advances only where supported; no category is mandatory. A methodological contribution requires a new or materially improved research capability, beyond applying a method. A theoretical contribution changes an explanation, prediction, or boundary condition, beyond studying a new setting. Separate contribution type from audience: explain what supported advances change for relevant subjects such as platforms, content creators, or policy-makers, without requiring a stakeholder list. Tie implications to evidence and concrete understanding or decisions; do not turn descriptive findings into causal prescriptions. Bound claims to the constructs, population, and evidence studied.
- **Roadmap.** End the introduction with a short paragraph describing the actual order and purpose of the remaining sections. Match the manuscript's section names and numbering; avoid repeating the findings or contributions.

**Optional design and mechanism paragraphs.** Give credibility a separate paragraph when an unusually informative causal design or identification solution is itself a central contribution and needs explanation beyond the empirical overview. Give mechanism evidence a separate paragraph when it offers a distinctive, well-supported explanation that materially changes the main answer. Place either where it advances the findings argument. Otherwise integrate the essential design information into "what we do" and the supported interpretation into "what we find." These optional paragraphs do not displace literature positioning or contributions. Preserve the distinction between tested channels and plausible explanations, and retain consequential inferential limitations wherever needed.

**Evidence and flexibility.** Consult the [three-paper empirical audit](introduction-three-paper-audit.md) when checking the basis for these choices. It records source versions, paragraph maps, and departures from this preferred sequence. The requested order and closing roadmap are drafting defaults, not universal conventions. Keep topic-specific examples in the audit rather than importing them into reusable prose.

A conceptual schematic may help when a new construct or a complex relationship is central. Use it only when it reduces the explanation needed; no opening figure is required.

---

## Movement 3 — Results

"Tell, don't dump." The empirical-econ norm is that *something* carries the punchline and the rest carries the precision — but it is not always a figure. Across award papers the punchline is carried by a figure, by a **single headline number repeated verbatim**, or by one decisive table about as often as by a plot. Lead with whichever the reader will remember; let tables carry the precision behind it.

**Build the argument from the paper's promise.** Before drafting or reorganizing Results, read the title, abstract, conceptual framework, and methods. Identify the questions these sections promise to answer and map each to the evidence that answers it. Order subsections by how those answers build on one another; script numbers and existing figure order do not determine the storyline. Flag a promised answer that lacks evidence rather than filling the gap with interpretation.

**Open with an argumentative roadmap.** Put a short paragraph directly below the Results heading explaining how the findings build on one another and why that sequence answers the paper's questions. For example, a knowledge-expansion paper might establish expansion → separate transfer from enrichment → characterize the enrichment shortfall → examine integration-related change → illustrate allocation implications. This is a project example, not a universal template. The roadmap should explain the progression of the argument rather than merely list analyses.

Use the following evidence components where they advance that argument; they are not a mandatory subsection order. Use Movement 1's evidence hierarchy to place explanatory, corroborative, and robustness material; none becomes a coequal headline just because it has a separate table:

1. **Headline display.** A figure or decisive table that captures the main result. Often a comparison: treatment vs. control over time, NJ vs. PA employment, a mobility heatmap, a binscatter against the wedge variable. The reader who sees only the display should leave with the right belief. Choose the format around the comparison: a curve can show two outcomes across allocation choices, a table supports exact lookup, and stacked bars can show total volume and composition together. When revising, assess whether simplifying or refining the existing design communicates the comparison better before replacing it with a more elaborate one. See [visualization](../../visualization/SKILL.md) for execution.
2. **Main table.** Headline regression. Point estimate, standard error, sample, controls, fixed effects. State both economic and statistical significance. Pair every estimate with uncertainty (95% CI or SE — never alone).
3. **Mechanism tests.** Two to three. Pre-specified — state the prediction *before* the test. If A is the channel, B should appear in subsample C. Report the prediction direction in the text and the result in the table.
4. **Heterogeneity.** Theoretically motivated cuts; cite the theory or mechanism that predicts each cut. Lifts directly from [report](../../report/SKILL.md) §Heterogeneity. Interpret in three layers: the observed pattern; any accounting or composition explanation supported by the design; and cautiously labeled substantive explanations supported by existing evidence. For language differences, for example, distinguish measured source composition from possible editorial practices. A plausible explanation is not a tested mechanism; state what the evidence can distinguish and keep unresolved explanations tentative.
5. **Robustness.** Alternative samples, measures, specifications, placebo, falsification. One robustness table is usually enough; the rest goes to the appendix. Robustness should be exhausting to write — that is the point.
6. **Comparison with prior estimates.** Explicit, with the table from [report](../../report/SKILL.md) §Benchmark. Where estimates differ, name the most plausible reconciliation: data difference (sample, period), measure difference, or method difference.

For structural papers, follow DellaVigna's order: present moments → identification logic → estimates → welfare counterfactuals. Reduced-form moments come first because they anchor the model in a fact the reader can see.

Each results subsection begins with the artifact supplied by [report](../../report/SKILL.md): a subquestion heading, compact empirical setup, main figure or table, and direct description of what it shows. Paper prose then adds the interpretation required for the paper's argument and connects the answer to the next subquestion.

**Give every main-text display a distinct job.** Ask: "What does the reader understand from this display that the preceding evidence does not establish?" Move redundant tables and exhaustive breakdowns to the appendix. Conversely, give a central construct, such as knowledge stock, visible evidence in a main-text display when the argument depends on it; prose alone should not carry its empirical support. One display can support several connected constructs without requiring a separate figure for each.

**Explain relationships between measures and estimates.** When outcomes are linked by an accounting identity, distinguish what each measure means, whether its model is estimated separately, and which coefficient relationships follow mechanically from the identity under the actual estimator. Check identical samples, regressors, weights, and compatible outcome scales before claiming such a relationship; an identity among levels does not automatically imply the same relationship among coefficients from transformed or nonlinear models. Explain any resulting redundancy in the estimates so the reader does not mistake a mechanical relationship for independent corroboration. Definitions alone do not settle these questions.

**Resolve confusion where it arises.** Give terms such as "comparable," "assisted," and "priority-based" an operational meaning at first use in the relevant result, with a methods cross-reference for full construction. State what is held comparable, the numerator and denominator of a percentage, and how the reported value was selected. If an allocation simulation reports a matched comparison, explain the matching rule and the selected scenario or point. Calling a simulation "illustrative" does not explain how its headline percentage was obtained.

**Simplify presentation while retaining construction and uncertainty.** Keep plot labels short, essential estimation details in the caption, and interpretation in the text. If bars are constructed as a benchmark plus an estimated coefficient, explain the benchmark and addition in the caption even if "adjusted" is removed from the label. Check confidence intervals at the intended display size: intervals may be present but visually tiny, which should be explained rather than mistaken for missing uncertainty or exaggerated graphically. Identify what intervals or bands represent and distinguish statistical uncertainty from deterministic variation across scenarios. If statistical uncertainty is unavailable, state that limitation; a scenario range does not substitute for a confidence interval.

**Interpreting the numbers — three moves the award papers share:**

- **Keep repeated magnitudes consistent.** When an estimate recurs across abstract, introduction, and conclusion, preserve its value, unit, comparison, scope, and precision convention. Do not force the same number into every section or suppress central component estimates to manufacture one memorable statistic. If rounding differs for readability, make the approximation explicit and ensure it does not change the interpretation.
- **Handle nulls without over-claiming.** A failure to reject is not evidence of equivalence. Say "we cannot detect a difference; the estimate is consistent with effects between −x and +y," and attribute the silence to power or remaining uncertainty — never "there is no effect." Bound what the null rules out rather than declaring zero.
- **End the interpretation on a one-line verdict.** After presenting the evidence, distill the section's conclusion into a single quotable sentence — the "this is a data problem, not a model problem" move. The verdict is what gets quoted in the referee report and the seminar; write it deliberately rather than leaving the reader to compose it.

---

## Movement 4 — Discussion and Conclusion

Short. The temptation is to repeat the introduction; resist. The recurring four-part shape across award papers is: **restate → implications → limitations → labeled speculation.**

- **Restate the finding in one sentence** — the central reframing, with a quantitative anchor only if useful. Repeated estimates must stay consistent (Movement 3); repeat a priority claim only if it is verified and important to the contribution.
- **Implications, often split by audience.** When a finding lands on more than one constituency, address them in turn rather than in one blur — a paragraph (or labeled sub-paragraph) per stakeholder: publishers / advertisers / regulators; researchers / industry; theory / practice. The split shows you know who pays for the result, and it pre-empts "what does this mean for X?"
- **Acknowledge the dominant limit honestly.** Don't fish for praise — the reader can tell. Award papers frame limitations three ways, and the framing matters: (1) an **explicit, sometimes numbered list** owning specific design choices; (2) a **data-availability constraint** — "we observe desktop, not cross-device" — which reads as scope, not flaw; (3) **woven-in caveats** at the point each result is stated. Owning the limit as scope-or-data beats confessing it as failure; either beats hiding it.
- **Close on the specific change in understanding or decision making.** What distinction, belief, evaluation criterion, or managerial choice changes because of the evidence? "Offers important implications" and "provides a new way to evaluate" need an immediate, concrete object. Broader speculation is optional and must be explicitly labeled; do not require an unsupported leap merely to end on a bigger idea.

McCloskey: don't pad. Cochrane: short conclusions are fine. Two pages is more than enough — even the longest award conclusions run only a handful of paragraphs.

The honest-limits paragraph is seeded by [report](../../report/SKILL.md) §Limitations: name the threat to validity that would most change the conclusion if addressed, and suggest the next study.

---

## Movement 5 — Cross-cutting writing rules

Distilled from McCloskey's *Economical Writing* and Cochrane's *Writing Tips*:

- **Make the substantive result easy to find.** Give enough problem and comparison context for the result to mean something; in abstracts, select quantitative anchors rather than opening automatically with a number.
- **Concrete numbers beat vague summary.** "N = 14,203, 47 duplicates removed, 0.3% missingness on the outcome" beats "the dataset was cleaned."
- **Report uncertainty where estimates are presented and defended.** Results text and tables should supply SEs, intervals, or appropriate uncertainty measures. A short abstract need not repeat every SE, but must retain uncertainty that changes its conclusion, especially for nulls or imprecise contrasts. Never invent missing precision.
- **Active voice, first person plural.** "We estimate" beats "It is estimated."
- **One sentence, one idea.** Shorter sentences read faster and survive translation.
- **No throat-clearing.** Cut "It is well known that…", "Recently…", "An important question is…", "In this paper, we will…".
- **Bold key terms, numbers, conclusions.** Matches the [report](../../report/SKILL.md) convention.
- **Use → for logic chains.** "high churn → low LTV → unprofitable segment." Matches [report](../../report/SKILL.md).
- **Write early, revise late.** Varian: writing is part of thinking, so start before the analysis is finished. McCloskey: every revision pass should remove words.
- **Audience: the busy referee.** Imagine them on a train, with thirty minutes, deciding among reject / R&R / accept. Write so they can decide on the abstract and intro alone.
- **Offload the banal, protect the important.** Boilerplate emails, regression-table summaries, section roadmaps, and reference-list cleanup are safe targets for LLM assistance. The wedge sentence, the framing, the contribution paragraphs, and the limits paragraph are not.

### Substantive compression and local qualification

Translate methods into messages without translating away evidentiary boundaries. Keep the comparison, population or subsample, time window, measurement definition, and inferential status wherever omitting them would change a reasonable reader's interpretation.

- **Combine corroboration into a substantive clause.** In a hypothetical content study, replace "The fact analysis corroborates the sentence analysis" with "The more-transfer, fewer-additions pattern also appears in fact-level measures in the four-edition subsample," if both patterns are actually supported. "In the fact sample" suffices only if that sample's restricted scope is already clear; an abstract must stand alone.
- **Preserve numerators and denominators.** Fewer local facts can coexist with a larger share among remaining additions. Say both if central, and identify the denominator. Do not turn a rising share into a rising count or substitute a compositional shift for an absolute gain.
- **Qualify at the claim.** Prefer "is associated with," "a descriptive comparison around the service integration," "model-implied," or "under the assumed deployment scenario" to an overstrong claim followed by a corrective disclaimer. A separate limitations sentence remains appropriate when the boundary governs the whole paper and cannot be made clear locally. Preserve causal language when the design genuinely warrants it; local qualification does not mean blanket hedging.
- **Do not upgrade the event.** An optional service integration is not necessarily a generic technology advance, mandatory adoption, or exposure to improved technology. Preserve what actually changed and who could be exposed. An estimator label alone does not license a causal interpretation.
- **Keep simulations conditional.** "Under the assumed substitution scenario, deployment reduces independent additions" retains what "the simulation has managerial implications" leaves empty. Use only the outcome and assumptions actually supported; do not present modeled deployment consequences as observed platform behavior.

Compress wording and secondary detail, not the identity or strength of the claim. Unknown definitions and missing evidence need a focused question or a visible placeholder, not an elegant invented bridge.

---

## Movement 6 — Working with Claude on prose

Drafting a paper with an LLM is a thinking exercise, not a typing exercise. The risk is **cognitive offloading** — the model produces text faster than you can think, and you accept it because it reads well. Goldsmith-Pinkham's rules, adapted:

### Personal style guide

Build a `writing_style.md` from your own published work:

1. Collect five to ten pieces of writing you are satisfied with — published papers, referee reports, blog posts, memos.
2. Ask Claude to extract patterns: sentence length distribution, hedging language, transition verbs, paragraph-opening structures, where you place numbers, how you handle citations in prose.
3. **Curate the output.** Delete what is wrong, add what the model missed, soften rules that are too rigid. The first version always misses things — iterate after every paper you write.
4. Reference it in every drafting prompt: "Edit the following section against `writing_style.md`."

The output will be **recognizable but caricatured** — a shadow of your real voice, not a mirror. Treat the guide as a constraint that pushes prose in better directions, not as voice capture. Nabokov's caveat: writing quirks are often deliberate stylistic choices; do not let the guide flatten them.

**Maintain separate guides per register.** Academic paper, referee report, blog post, slide deck — these have different rules, and one merged guide will produce prose that fits none of them.

### Comments, not rewrites

The default editing prompt:

> *"Edit the following section in the style of a NYT editor for writing and clarity. Do not edit my text directly. Instead, insert inline comments where the argument is poor, the prose is unclear, or a claim is unsupported."*

Why this works:
- The original text is preserved; you read each comment and decide your response.
- Forces active engagement — you cannot passively accept LLM prose because no LLM prose is produced.
- Preserves voice. The most common failure mode of LLM-assisted writing is unintended convergence to the model's average style; comment-mode blocks that.

Use Claude Code (or another file-aware harness) for this — the chat web UI cannot read and annotate the actual draft cleanly.

### The AI tells — a self-audit

Start with substance, not a phrase blacklist. For every abstract sentence, ask: **does it tell the reader something about the phenomenon, evidence, or contribution, or merely announce what an analysis or section does?** "The simulation provides managerial implications" names a rhetorical job, not a finding. "Under the modeled scenarios, outcomes depend on whether assistance supplements or replaces independent production" earns its space only if those scenarios and outcomes are supported. Apply Movement 5's compression rules to replace empty analysis inventories. Ordinary transitions such as "Taken together" are not defects when followed by a precise, warranted inference.

Convergence to the model's average style has a recognizable surface. If a draft carries several of these, a reader is already discounting it — they read it as *you did not think hard about this*. Audit your own prose for:

- **The cliché phrasebook** (representative, not exhaustive): "it's not just X — it's Y", "more than just a [X]", "at the heart of", "stands as a testament to", "navigate the complexities of", "leverage / harness / tap into", "shed light on", "revolutionizes the industry", "game-changer / paradigm shift", "robust, scalable, seamless", "in today's rapidly evolving landscape", "a tapestry of", "delve into", "underscores the importance of", "a myriad of", "ushers in a new era of".
- **Pet tics:** the overused "moat" (build / widen / deepen / strengthen the moat) and the reflexive em-dash. (Yes — like that one.)
- **Three structural patterns**, harder to grep than the phrasebook:
  1. **Exception constructions** — "not just X, it's Y", "this isn't about A, it's about B". The shape performs depth without earning it; a real claim usually doesn't need the scaffolding.
  2. **Overgeneralizations** — "every customer wants…", "always / never / all / none". Empirical claims live in conditions and tradeoffs; sweeping language signals the writer skipped them.
  3. **Broad strong claims** — "revolutionizes", "fundamentally redefines" — used to substitute for evidence. Scope each claim to what the analysis actually supports.

**Verb strength ≤ evidence strength.** The greppable form of the "broad strong claims" tell: no verb outruns the evidence behind it. Empirical work *shows*, *provides evidence*, *is consistent with* — it does not *prove*, *demonstrate*, *establish*, *confirm*, or *guarantee* a universal truth. Watch the same list plus "significantly" used with no test or number attached. Downgrade the verb, or attach the number and test that would license the stronger one ("*prove* our method is better" → "improves held-out accuracy by 4–7 points over the strongest prior estimate, significant at p < 0.01").

**Preserve — the over-correction failure mode.** The audit above is one-directional: it removes tells. Run it too hard and you introduce the opposite defect — flattening the calibrated hedging that scholarship *requires*. Turning "the results suggest X" into "the results show X" does not de-AI the prose; it manufactures an over-claim. Before deleting, check that you are not stripping a legitimate construct:

  - **Evidence-tied hedging is correct and stays.** "suggests", "is consistent with", "we hypothesize that", "may indicate", "appears to" — keep them whenever the claim is genuinely uncertain. A calibrated verb is not a tell.
  - **Passive voice is fine when the actor is irrelevant** — "samples were normalized to total protein." Recast passives only where naming the agent adds information (Movement 5's active-voice rule targets *those*, not all passives).
  - **First-person plural "we" is standard** — do not rewrite to avoid it.
  - **Semicolons and an occasional triple** are fine in moderation; only the em-dash is removed outright.
  - **Definitions, named methods/metrics, symbols, equations, and every number and citation stay verbatim.**

  The two disciplines run together: remove the tells, but never at the cost of a verb that was correctly calibrated to its evidence.

**Why it matters (the empirical case):** detectably-AI work is penalized by evaluators (Reif/Larrick/Soll 2025; Raj/Berg/Seamans 2026), and over-reliance homogenizes output — more text per author, fewer distinct ideas across a field (Anderson 2024; Doshi & Hauser 2024; Moon 2025). Distinctiveness is the asset; generic confidence is not a substitute for specific reasoning. (Adapted from the MGMT430 *"Using AI without sounding like AI"* lecture; the slide-deck counterpart — *visual* tells — lives in [`slide/references/aesthetics.md`](../../slide/references/aesthetics.md).)

### The accountability test

Before sending a draft to a coauthor or referee, ask: *"Can I defend every paragraph in this section without the LLM open?"* If the answer is no for any paragraph, that paragraph is not yet yours. Rewrite it by hand, or delete it. The 1977 IBM rule — a computer cannot be held accountable, therefore a computer cannot make the editorial decision — applies to every sentence the paper claims under your name.

Do not draft with Claude when tired. The output looks fine and isn't, and you stop pushing back.

---

## Movement 7 — Strict-traceability mode

The default movements above are flow-first: establish the argument, choose the relevant moves, and polish later while keeping claims grounded. **Strict-traceability mode** makes that grounding explicit claim by claim: accept no claim that doesn't trace to a specific input, and flag every gap. Use it when the cost of an invented number outweighs the cost of a slower draft.

**When to switch on:**

- Methods sections — one fabricated detail sinks credibility
- Results sections drafted directly from regression output, where misreading a coefficient is unacceptable
- Discussion sections drafted against fieldnotes or interview matrices, where misattributing a quote breaks trust
- Any section the user wants to read with the inputs open in another window and check claim-by-claim

The accountability test from Movement 6 — *"can I defend every paragraph without the LLM open?"* — is the same idea applied at paragraph granularity. Strict-traceability mode applies it at *claim* granularity.

**Three rules — non-negotiable:**

1. Every empirical claim traces to a `file:line` in the input. If it cannot, the line gets `[TODO: source]`.
2. Every reference to a paper, dataset, or method uses a `[CITE: short-handle]` placeholder. Never invent author-year strings.
3. Numbers absent from the input become `[TODO: number]` placeholders. Never guess a coefficient, p-value, or N.

**Workflow:**

```
identify section + inputs → load template → map inputs to slots → draft → emit TODO/CITE checklist
```

Section templates (Methods / Results / Discussion slots) live in [`report`](../../report/SKILL.md) §Paper-section Templates. Map each slot to the input that supplies it; slots with no source become `[TODO]` markers, never silent omissions.

**Inline source attribution** — flag the source as the finding is stated:

> Treatment increased click-through by 12.4% (p < 0.01) [source: `analysis.R:184`].

If the input doesn't contain the claim:

> Treatment increased click-through by [TODO: number]% (p [TODO: p-value]) [source: TODO].

**Closing checklist** — append after the draft so the revision pass is concrete:

```
## TODO
- [ ] line 23: number for treatment effect (could not find in inputs)
- [ ] line 41: citation for "scarcity messaging literature"

## CITE placeholders
- [CITE: cialdini1984] x3
- [CITE: kahneman2011] x1
```

The gap inventory is visible — every line that needs a number, every reference that needs resolving — before the section is circulated. Pair with [`literature-review`](../../literature-review.md) Path A to resolve `[CITE: handle]` strings into verified DOIs.

---

## Movement 8 — Construct lock and terminology anchoring

### Within-paper construct lock

Before drafting or compressing the abstract and introduction, map the central terms from the supplied paper, especially those in its title and headline contribution:

`term → exact meaning → allowed shorthand → misleading near-synonyms`

Keep this map internal for a small edit; show only unresolved definitions or consequential choices. Reserve each load-bearing term for its defined construct across the title, abstract, and introduction, and check that Results and the conclusion use it consistently. A stylish synonym must not change the measured object, reference set, or theoretical claim. Literature familiarity alone cannot guarantee within-paper consistency.

For illustration only, a paper might define *expansion* as growth in target content, *transfer* as source information represented in the target, and *enrichment* as additions relative to that source. In that paper, casually calling transfer "expansion" would blur the title's distinction; calling enrichment "new knowledge" would add truth and novelty claims not supplied by a source comparison. Derive the actual map from the manuscript, not this example. A phrase such as *knowledge stock* requires its own explicit definition and accounting boundary, not an assumed synonym for total content.

If title and body definitions conflict, flag the conflict rather than silently choosing the catchier meaning. Proposed renaming is an author decision; propagate an approved choice consistently. For title generation itself, use the separate paper-titles skill when available.

### Literature anchoring

A draft can be structurally clean and still name its objects wrong. When a paper coins its own label for a construct the literature already names — "engagement decay" for what the field calls *churn*, "attention spillover" for *demand cannibalization* — the referee reads it as not-having-read-the-literature, and the contribution gets discounted before the result is even weighed. The fix is not to flatten every term into the nearest cliché; coining is sometimes the contribution (Movement 2's *new construct*). It is to make the choice **deliberate**: anchor to the literature's term where you are describing a known object, and reserve a coined term for where you are genuinely introducing one.

Literature anchoring is a **polish pass**, run after the draft has structure and content; the local construct lock above starts before drafting and does not require a new literature search. The anchoring pass round-trips with [`literature-review`](../../literature-review.md): the skill that resolves `[CITE: handle]` strings is the same one that knows how the anchoring papers name each construct.

**When to run it.** After Movement 2–4 drafting, before the [`academic-voice.md`](academic-voice.md) pass. Especially when the paper sits on top of an established literature whose vocabulary the referee will expect, or when the draft was written fast and may have drifted into ad-hoc labels.

**Three steps:**

1. **Extract the construct/method terms.** Scan the section for the nouns and noun phrases that name an economic object, a mechanism, a measure, or a method — the words a referee would expect to map onto a known concept. Skip ordinary prose; collect the load-bearing terms. Output a list, each with the sentence it appears in, so the term is judged in context (the same word can be load-bearing in one sentence and incidental in another).
2. **Find the literature-anchored term for each.** Hand the list to [`literature-review`](../../literature-review.md) Path A: for each extracted term, retrieve how the anchoring papers (the ones the paper already cites, plus the canonical refs for that construct) name the same object. Some terms will map cleanly to a standard label; some will have two or three competing conventions; some will have no established anchor, which is itself the signal that the term may be a genuine coinage.
3. **Emit a diff, never a silent rewrite.** For each term, propose: keep, or replace with the anchored term — with the citation that licenses the anchored choice and a one-line reason. The author decides. Three verdicts:
   - **Anchor** — the draft drifted from a settled term; replace it and cite. ("'engagement decay' → *churn* [CITE: reichheld1996]; field uses *churn* for exactly this hazard.")
   - **Choose** — two or three conventions compete; surface them with their citations and let the author pick the one whose framing fits the contribution. Do not pick silently.
   - **Coin** — no established anchor, or the author is deliberately introducing a construct. Keep the term, but flag that it needs the explicit definition Movement 2 requires for a new construct, and that it should *not* be quietly swapped for a near-synonym elsewhere in the paper.

**Output shape** — a per-term table the author reads top to bottom:

```
## Terminology anchoring
| Draft term | Verdict | Anchored term | Licensing cite | Note |
|---|---|---|---|---|
| engagement decay | anchor | churn | [CITE: reichheld1996] | settled term for this hazard; draft drifted |
| attention spillover | choose | cannibalization / demand diversion | [CITE: ...] | two conventions; pick by framing |
| trust transfer | coin | — | — | no anchor; define it (Movement 2), don't synonym-swap later |
```

The discipline mirrors Movement 7's: the skill never silently changes the word the author chose — it surfaces the literature's term, the citation that licenses it, and the reason, then leaves the editorial decision with the author. Anchoring to a borrowed term and coining a new one are both defensible; drifting into an ad-hoc label by accident is not.

This pass also feeds the `feedback_prose_restraint` discipline ("prefer literature-anchored terms") with a mechanism rather than a reminder: the anchored term comes back with a verified citation, not from model memory.

---

## How `report.md` artifacts feed into the paper

| Report artifact | Lands in |
|---|---|
| §1 Data & Sample | Intro's empirical setup + Data section + Abstract's empirical-object move |
| §2 Definitions | Measurement section (brief in body, full in appendix) |
| §3 Findings | Results subsections; empirical setup, figure/table, and description preserved |
| §Heterogeneity | Its own Heterogeneity section |
| §Benchmark | Discussion / Comparison subsection before the conclusion |
| §Limitations | The honest-limits paragraph in the conclusion |

The flow: [brainstorm.md](../../brainstorm.md) produces a question → [literature-review.md](../../literature-review.md) and [eda.md](../../eda.md) verify it → empirical work produces results → [report](../../report/SKILL.md) packages results into structured artifacts → this skill turns those artifacts into a paper (switch to Movement 7's strict-traceability mode for sections where claim provenance matters more than narrative flow) → [academic-voice.md](academic-voice.md) does the final voice pass for the target journal → [revision-plan.md](../../revision-plan.md) handles the R&R if it arrives.
