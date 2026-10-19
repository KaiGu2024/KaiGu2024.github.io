# PaperBanana review for skill maintenance

Reviewed 2026-10-19. Sources: [paper v2](https://arxiv.org/html/2601.23265v2), original [PaperVizAgent implementation at e088a8f](https://github.com/google-research/papervizagent/tree/e088a8fff74cc363b6897c0843631fff76484908), and author-maintained [PaperBanana at f1da3db](https://github.com/dwzhu-pku/PaperBanana/tree/f1da3db8d5f4c3add947dfd3ddd93dddd3394dc3). Review covered the paper and appendix material, visual inspection of failure examples, agent prompts, style synthesis, evaluation, and revision orchestration. The generation pipeline was not run locally.

## Findings and adaptations

- Table 2 shows style refinement can improve presentation while reducing faithfulness; critique recovers some lost fidelity. Adaptation: check scientific content after polishing, not just before drawing.
- The planner separates source content from visual intent; the retriever prioritizes compatible visual structure. Adaptation: write a short brief and select examples by the comparison they solve.
- The critic requests specific corrections to the existing description and permits no change. Adaptation: repair observed defects locally and stop when checks pass.
- Figures 9–10 show numerical and connection errors. Adaptation: preserve code-based quantitative plots and editable diagrams; inspect values and relationships against structured sources as well as looking at the image.
- In the inspected code, critic parsing can default to “No changes needed,” while the orchestration's “best” image advances on successful rendering without a comparative content check. Adaptation: failed review remains unverified; keep the last verified version until its replacement passes.

These are workflow adaptations, not measured improvements to our skills. The study focuses on NeurIPS methodology diagrams and a curated plot benchmark. Its style preferences and evaluation scores do not establish universal publication standards. Retain our own brand, export formats, concise notes, and event-study wording. Use sequential working passes without requiring five agents or three revision rounds.

Current procedure: [figure planning and revision](../guidance/figure-review.md). Related changes belong in conceptual-framework, slide, tables, and skill-creator; paper-writing already supplies the concise-note principle.
