# General principles — the full source

This is the long form of the **General principles** block that the `agent-configuration`
skill can emit into a research CLAUDE.md. It is adapted from
[Karpathy's LLM-coding CLAUDE.md](https://github.com/multica-ai/andrej-karpathy-skills/blob/main/CLAUDE.md)
(multica-ai/andrej-karpathy-skills), which is itself general behavioral guidance meant to be
merged with project-specific instructions.

It is kept **here**, in the skill's `references/`, rather than in the skill body or in the
generated CLAUDE.md, for one reason: a research CLAUDE.md loads on **every turn** and survives
`/compact`, so it must not carry generic best-practice text the model already knows. The skill
therefore emits at most four condensed one-liners; this file holds the reasoning behind them for
when you are deciding whether to include the block or expanding a principle into a concrete rule.

## Should this block go into a project's CLAUDE.md at all?

Default: **only the four one-liners, and only if the team wants them enforced as visible house
rules.** Otherwise drop the block. The value is never novelty (the model has these internalized)
— it is making the standard explicit so a reviewer can point at it. Never paste the full text
below into a generated CLAUDE.md; that trades permanent every-turn context for prose the model
does not need. If a project wants the full rationale on hand, link to this file or the upstream
URL rather than inlining it.

The four principles are ordered by how often they prevent a bad diff, and each maps to one
condensed line in the template.

---

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them — don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

*Condensed line:* **Think before coding.** State assumptions explicitly. If a request has
multiple interpretations, present them — do not pick silently. If something is unclear, stop and
name what's confusing before implementing.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

*Condensed line:* **Simplicity first.** Minimum code that answers the question. No speculative
features, no abstractions for single-use scripts, no error handling for impossible inputs. If
200 lines could be 50, rewrite it.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it — don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: every changed line should trace directly to the user's request.

*Condensed line:* **Surgical changes.** Touch only what the task requires. Match the existing
style. Do not refactor adjacent blocks or "improve" unrelated code. Mention dead code; do not
delete it unasked. The test: every changed line traces directly to the user's request.

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

*Condensed line:* **Goal-driven execution.** Convert tasks into verifiable goals before running
them, and state a brief plan as `[step] → verify: [check]` for multi-step work. Strong success
criteria let the agent loop until verified without re-asking.

---

**These guidelines are working if:** fewer unnecessary changes in diffs, fewer rewrites due to
overcomplication, and clarifying questions come before implementation rather than after mistakes.

**Tradeoff:** they bias toward caution over speed. For trivial tasks, use judgment.
