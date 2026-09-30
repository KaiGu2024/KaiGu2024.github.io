# General principles — rationale and sources

Read for the core task rule's examples or when tailoring the optional coding principles,
adapted from [Karpathy's LLM-coding CLAUDE.md](https://github.com/multica-ai/andrej-karpathy-skills/blob/main/CLAUDE.md).
The [AGENTS.md template](../SKILL.md#generating-a-research-agentsmd-workflow) holds the concise rules;
this reference supplies supporting detail.

## Advance the core task

Spend effort where it improves the answer, develops the argument, or makes the current
implementation reliable. Before adding a qualification, defensive branch, or extra analysis,
ask: **What concrete interpretation, decision, or result would change if this were omitted?**
If none, leave it out. A credible risk can justify prevention before a failure occurs.

- **Writing:** State supported findings directly. Explain consequential assumptions and
  uncertainty where readers need them; repeat a qualification only when the new claim
  requires it. Address an objection when it exposes a real gap in the argument. See the
  existing [writing guidance](../../paper-writing/references/main-text.md#state-the-answer-directly).
- **Coding:** Implement current requirements. Add validation at actual input boundaries
  and handle plausible failures; avoid speculative configuration, redundant checks in
  trusted internal paths, and fallbacks that conceal a broken assumption.
- **Analysis:** Run an additional check when it could change the substantive conclusion
  or resolve a concrete uncertainty. For example, investigate duplicate join keys when
  they could inflate the sample; skip an unused multi-format loader for a fixed input.

Material uncertainty, necessary tests, security, and the project's source-protection
rules remain part of doing the task correctly.

This is a synthesis of the user's requested principle and the following guidance:

- **Writing:** The public [econ-writing skill](https://github.com/Silas1929/econ-writing/blob/main/SKILL.md)
  discourages cascaded hedging while preserving meaning. [Oxford's hedging guidance](https://lifelong-learning.ox.ac.uk/hedging/)
  ties qualification to evidential limits and discourages indiscriminate hedging.
- **Coding:** The [deslop skill](https://github.com/rohitg00/pro-workflow/blob/main/skills/deslop/SKILL.md)
  targets unnecessary defenses in trusted paths and premature abstractions.
  [Fowler's YAGNI](https://martinfowler.com/bliki/Yagni.html) explains the cost of speculative
  capabilities while preserving work that keeps code maintainable and tested.

## Should this block go into a project's AGENTS.md at all?

Keep the core task rule in the operational instructions. Include the four optional coding
principles only when the team wants explicit house rules. Link to supporting detail instead
of copying it into AGENTS.md.

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them — don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Keep changes focused and preserve files outside the authorized edit.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- Preserve unrelated code; remove task-related dead code when its obsolescence is clear.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- File cleanup follows the project's **Protected files and cleanup** section and the [source-protection procedure](source-protection.md). Being stale, unused, untracked, or regenerable is insufficient authorization to delete a file.

The test: every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:

```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require
constant clarification.

---

**These guidelines are working if:** fewer unnecessary changes in diffs, fewer rewrites due to
overcomplication, and clarifying questions come before implementation rather than after mistakes.

**Tradeoff:** they bias toward caution over speed. For trivial tasks, use judgment.
