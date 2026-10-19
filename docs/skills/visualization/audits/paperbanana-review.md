# PaperBanana review for skill maintenance

Reviewed 2026-10-19. Sources: [paper v2](https://arxiv.org/html/2601.23265v2), original [PaperVizAgent implementation at e088a8f](https://github.com/google-research/papervizagent/tree/e088a8fff74cc363b6897c0843631fff76484908), and author-maintained [PaperBanana at f1da3db](https://github.com/dwzhu-pku/PaperBanana/tree/f1da3db8d5f4c3add947dfd3ddd93dddd3394dc3). Review covered the paper and appendix material, visual inspection of failure examples, agent prompts, style synthesis, evaluation, and revision orchestration. The generation pipeline was not run locally.

## Findings and adaptations

- Table 2 shows style refinement can improve presentation while reducing faithfulness; critique recovers some lost fidelity. Adaptation: check scientific content after polishing, not just before drawing.
- The planner separates source content from visual intent; the retriever prioritizes compatible visual structure. Adaptation: write a short brief and select examples by the comparison they solve.
- The critic requests specific corrections to the existing description and permits no change. Adaptation: repair observed defects locally and stop when checks pass.
- Figures 9–10 show numerical and connection errors. Adaptation: preserve code-based quantitative plots and editable diagrams; inspect values and relationships against structured sources as well as looking at the image.
- In the inspected code, critic parsing can default to “No changes needed,” while the orchestration's “best” image advances on successful rendering without a comparative content check. Adaptation: failed review remains unverified; keep the last verified version until its replacement passes.

These are workflow adaptations, not measured improvements to our skills. The study focuses on NeurIPS methodology diagrams and a curated plot benchmark. Its style preferences and evaluation scores do not establish universal publication standards. Retain our own brand, export formats, concise notes, and event-study wording.

The initial adaptation used sequential working passes. The user's subsequent preference supersedes that choice: new figures and substantial redesigns now use separate Retriever, Planner, Stylist, Visualizer and Critic agents, with only relevant roles activated for small edits. The shared workflow owns handoffs and revision control; the Critic independently checks original evidence and the saved render. There is still no fixed revision quota. This is an agent workflow implemented through skill instructions, not integration of PaperBanana's external runtime or evidence of measured quality gains.

Follow-up inspection found actual reference plotting code in the [PaperBananaBench plot dataset](https://huggingface.co/datasets/dwzhu/PaperBananaBench/viewer/plot/ref), in the `gt_code` field alongside images, data, and visual intent. This is reference code derived from ChartMimic, not necessarily the code for PaperBanana's generated illustrations. Our [gallery](../guidance/gallery.md) uses original examples to teach compatible design choices; its [validation record](gallery-validation.md) documents the exports inspected.

Current procedure: [figure planning and revision](../guidance/figure-review.md). Related changes belong in conceptual-framework, slide, tables, and skill-creator; paper-writing already supplies the concise-note principle.

Workflow instruction review (2026-10-19): an independent agent checked role separation, shared handoffs, limited slots, fallback status and three routing cases (new event study, label-only edit, existing figure placed in a slide). No blocking contradiction was found; follow-up edits clarified delegation permissions, Planner ownership of evidence preparation and disclosed self-review when delegation is unavailable. Local links were checked. This review did not execute a full five-agent figure-generation run or compare figure quality with a baseline.
