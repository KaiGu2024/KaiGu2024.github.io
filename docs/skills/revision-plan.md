---
name: revision-plan
description: Use when a referee + editor letter needs to be turned into an atomic, dependency-ordered revision plan — parse atomically (one task per reviewer ask, with verbatim quote and stable task ID), classify into five buckets (argumentative / empirical robustness / measurement / theory / presentation), order via DAG, execute, and quote back verbatim in the response letter. The inverse of writing.md.
allowed-tools: Read, Edit, Write, Bash
user-invocable: true
invocation: auto
---

# Revision Plan

The referee report has arrived. The temptation is to read it once, panic, and start re-running specifications at random. The empirical-econ revision pipeline is structured enough to resist that. This skill turns a referee+editor letter into an **atomic, dependency-ordered revision plan** that you can execute, and that the response letter can quote back to verbatim.

It is the inverse of [writing.md](writing.md): writing builds the paper from artifacts; the revision plan tears the paper apart against an external skeptic and rebuilds it. For revisions large enough that scheduling pays off (10+ tasks, or when the editor's bar requires a defensible roadmap), this skill also runs a computational DAG validation via NetworkX — see the **Advanced: computational DAG validation** section at the end. The validator is adapted from Jukka Sihvonen's [strategic-revision](https://github.com/jusi-aalto/strategic-revision) Claude Code skill.

---

## Movement 1 — Parse atomically

The unit of work is one reviewer ask. Not one paragraph, not one "concern" — one ask. A paragraph that says "the identification is unclear, the standard errors look small, and Table 3 has a typo" is three tasks, not one.

For each task, record:

- **Verbatim quote.** The reviewer's exact words. No paraphrase. The response letter will quote this back, and you will lose track of what was actually requested if you summarize at this stage.
- **Source.** Reviewer ID (R1, R2, AE) + section of their letter (major comment 3, minor comment 7).
- **Task ID.** Stable identifier that survives renumbering — e.g. `R1-MC3a`.

Goldsmith-Pinkham's rule from the talk: **traceability or nothing**. Every entry in the revision plan must trace back to a reviewer quote. Summaries are insufficient because you will be challenged on whether you addressed the comment, and the only defense is the quote.

A 26-task plan from a typical R&R is not unusual.

---

## Movement 2 — Classify

Five buckets. Each routes to a different work stream and a different reviewer expectation.

- **Argumentative.** Framing, contribution claim, positioning vs. literature, scope of conclusion. Cheap to type, expensive to think — these often require returning to [brainstorm.md](brainstorm.md) and re-validating the wedge.
- **Empirical robustness.** Re-estimate on alternative sample, alternative measure, alternative specification, placebo, falsification. The largest bucket in most R&Rs. Each task points back to a [report.md](report.md) §Analyses entry — extend the table, add a panel, or write a new appendix table.
- **Structural.** Re-organize sections, move material to appendix, split a table, combine sections. Cheap once decided; expensive to undo. Decide late.
- **Clarification.** Reword a definition, expand a footnote, clarify the sample, clarify a variable. Often the reviewer's actual concern is hiding behind a "clarification" ask — read carefully before classifying.
- **Editorial.** Typos, citations, formatting, table notes. Last block. Do not interleave with substantive work — interruptions are the largest cost in revision.

Tag each task with exactly one bucket. If a task fits two, split it.

---

## Movement 3 — Map dependencies

Tasks are not independent. The reviewer who asked for a re-framing in major-comment-1 has implicitly asked for every empirical table to be re-described against the new frame. The reviewer who asked for an alternative sample in major-comment-4 has implicitly asked for every robustness table to be re-run on that sample.

Build a directed acyclic graph (DAG):

- **Nodes.** Tasks.
- **Edges.** Task A → Task B if A must be completed before B starts. Edges come from data dependencies (B re-uses A's sample), argumentative dependencies (B's framing follows A's contribution claim), and tabular dependencies (B refers to a number A produces).
- **Validation.** The graph must be acyclic. A cycle means you have classified two tasks at the wrong granularity — usually because one "task" is actually two with feedback between them. Split.

**Inter-reviewer conflicts are first-class nodes.** R1 wants more structure; R2 wants less. R1 wants a longer intro; AE wants a shorter one. These are not bugs in the plan — they are decisions you must make explicit, with the editor letter as the venue. Mark conflict nodes and resolve them in Movement 5 before downstream work begins.

For large revisions, run the DAG through NetworkX to validate acyclicity, surface the critical path, and identify bottlenecks — see **Advanced: computational DAG validation** below.

---

## Movement 4 — Group into execution blocks

A topological sort of the DAG gives an execution order; grouping by dependency level gives **parallel blocks**.

- **Block 1 — Framing decisions.** Argumentative tasks that drive everything else. Resolve inter-reviewer conflicts. Re-validate the wedge sentence if it has shifted.
- **Block 2 — Core empirical re-estimates.** Sample changes, measure changes, identification clarifications. The bottleneck block — most other tasks wait on it.
- **Block 3 — Mechanism and heterogeneity tasks.** Once Block 2 is stable, mechanism tests can be re-run.
- **Block 4 — Robustness expansion.** Alternative specifications, placebo, falsification. Parallelizable across team members.
- **Block 5 — Structural reorganization.** Section moves, appendix splits.
- **Block 6 — Clarifications and editorial.** Last. Do not start before Block 5 is stable — clarifications reference structure.

**GO/NO-GO checkpoints between blocks.** Before moving from Block 2 to Block 3: is the headline number robust to the reviewer's preferred sample? If no, the contribution claim from Block 1 may need to weaken — return to Block 1. Do not push downstream work on an unstable headline.

---

## Movement 5 — Comply, partial-comply, or push back

For every task, write one of three decisions, with a one-line justification. The skill cannot make this call — you do.

- **Comply.** Do exactly what the reviewer asked.
- **Partial comply.** Do part; explain what part and why the rest is out of scope or infeasible.
- **Push back.** Do not do it; explain why the request is wrong (the reviewer misread the data, the alternative test does not identify what they think it does, the literature already addresses the concern).

Push-backs are not always confrontational, but they are always explicit. The response-letter rule from McCloskey applies: never imply you complied when you didn't, and never bury a non-compliance in a paragraph that reads like compliance. Reviewers re-read their own comments first, and they notice.

The most common failure mode is silent partial compliance — the author addresses the easy half and hopes the reviewer forgets the hard half. The reviewer does not forget. Mark every task with its decision before any drafting begins.

---

## Movement 6 — Map plan into the response letter

Each task generates one paragraph in the response letter, in a fixed structure:

> *Reviewer comment.* [Verbatim quote, italicized.]
>
> *Response.* [What we did, or why we did not. One short paragraph.]
>
> *Where in the revised paper.* [Section / page / table / line numbers in the revised manuscript.]

Three rules:

- **Quote, never paraphrase.** The reviewer is reading to check that you addressed *their* concern, not your reconstruction of it.
- **Cross-reference precisely.** Page and table numbers refer to the *revised* manuscript, not the submitted version. Reviewers pull the new PDF and check.
- **One paragraph per task.** No combining. The reviewer scans for their own comment numbers and skips to the response. Long combined paragraphs make this impossible.

Group response-letter sections by reviewer (R1, R2, AE), and within each reviewer follow the order of their original letter. The reviewer reads top-to-bottom against their own letter; do not make them re-sequence.

Do not let Claude write these paragraphs without your decision per task. Comment-mode editing (per [writing.md](writing.md) Movement 6) applies — draft the paragraph yourself, then ask Claude for comments on clarity and tone, not for prose.

---

## Cross-cutting rules

- **Verbatim quotes only.** No task without a quote, no response paragraph without a quote.
- **No task without an owner.** On a coauthored paper, every task ID points to one person. Tasks owned by "us" are tasks owned by no one.
- **Conflicts are decisions, not bugs.** Inter-reviewer conflicts get marked, surfaced in the editor letter, and resolved before downstream work.
- **Do not interleave editorial with substantive work.** The cost of interruptions is larger than the time the editorial pass takes.
- **Re-validate the wedge.** If Block 1 framing changes shift the contribution claim, return to [brainstorm.md](brainstorm.md) before continuing. A revision that keeps the old wedge under a new frame is incoherent.
- **The accountability rule.** Every push-back is signed by you, not by the model. Claude can suggest the argument; you decide whether it is correct, and the response letter goes out under your name.

---

## Handoff

What this skill produces, fed into the next stage:

- A **DAG of tasks** with quotes, classifications, dependencies, and per-task decisions.
- An **execution-block schedule** matched to coauthor calendars.
- A **response-letter scaffold** with one paragraph per task, structured comment / response / location.

The revised manuscript is then drafted against [writing.md](writing.md); new tables and figures follow [report.md](report.md) and [visualization.md](visualization.md); the response letter is the final artifact this skill owns.

If a referee report returns a task list that fails Movement 3 (the DAG has cycles after two passes) or Movement 5 (more than one task is "TBD" at execution start), the plan is not yet ready. Do not start re-running specifications. Stay in revision planning.

---

## Advanced: computational DAG validation

For routine R&Rs (≤ ~10 tasks), the by-hand DAG in Movement 3 is sufficient. For larger revisions — or when the editor's letter requires a defensible roadmap — validate the graph computationally with NetworkX. This catches cycles you missed and surfaces the critical path and bottlenecks that hand-drawing always undersells.

Adapted from Jukka Sihvonen's [strategic-revision](https://github.com/jusi-aalto/strategic-revision) Claude Code skill. The `dag_validator.py` script lives alongside this skill in `~/.claude/skills/revision/scripts/dag_validator.py`.

### When to use this

- More than ~10 reviewer tasks
- Inter-reviewer conflicts that cascade (R1's reframe touches half of R2's robustness asks)
- A reviewer who is also an Associate Editor — the response letter needs a defensible scheduling argument
- You have already drafted the by-hand DAG once and want a sanity check before scheduling

### Step 1 — Serialize the tasks

Convert the Movement 1–3 tables into `revision_tasks.json`. One key per task, dependencies via `depends_on`:

```json
{
  "R1_MC1": {
    "category": "ARGUMENTATIVE",
    "block": "1",
    "description": "Reframe contribution against literature X",
    "depends_on": [],
    "collateral_risks": [
      {"task_id": "R2_MC3", "risk": "Reframe may invalidate R2's robustness motivation"}
    ]
  },
  "R1_MC2": {
    "category": "EMPIRICAL",
    "block": "2",
    "description": "Re-estimate Table 3 on R1's preferred sample",
    "depends_on": ["R1_MC1"]
  }
}
```

Fields: `category` ∈ {ARGUMENTATIVE, EMPIRICAL, STRUCTURAL, CLARIFICATION, EDITORIAL} (Movement 2). `block` ∈ {1..6} (Movement 4). `depends_on` lists upstream task IDs (Movement 3). `collateral_risks` is informational only — it does not create structural edges. Use `"block": "?"` if Movement 4 is not yet done.

### Step 2 — Validate acyclicity (fail-fast gate)

```bash
python dag_validator.py revision_tasks.json --validate-only
```

If the script reports a cycle, the task list is broken. Common causes:

- **Collateral risk encoded as a hard dependency** — move it from `depends_on` to `collateral_risks`. Risks are informational, not structural.
- **Bidirectional dependency** (A blocks B *and* B blocks A) — one task is really two; split.
- **Transitive chain through a merged task** — a single "task" is actually two with feedback between them.

Fix and re-run until the graph passes. Do not move to Step 3 with a broken graph.

### Step 3 — Full analysis (after Movement 4 block assignments are in)

```bash
python dag_validator.py revision_tasks.json
```

Produces three artifacts that feed back into the revision plan:

- **Parallel batches** — tasks with no remaining prerequisites at each level. Batch 1 = tasks with `depends_on: []` and can start today. Batch 2 = tasks blocked only by Batch 1. Etc. Use these to assign work across co-authors.
- **Critical path** — the longest chain of dependent tasks. This is the minimum revision timeline; any delay here delays the whole revision. Mark these `[CP]` in the execution roadmap.
- **Bottlenecks** — tasks with the most downstream dependents. A bottleneck that is also on the critical path is the single most expensive task in the revision. Mark `[BN]`. Cross-reference with Movement 5 — bottlenecks that already carry process risk deserve explicit mitigation.

If the computational batches show that tasks from different Movement-4 blocks can run in parallel, the computational result takes precedence for scheduling. The block logic still drives narrative coherence, but it should not impose serial constraints that the DAG does not require.

### What this changes in the response letter

Nothing. The response letter still quotes verbatim and addresses one task per paragraph. The NetworkX analysis is a project-management artifact, not a reviewer-facing one. Do not mention `dag_validator.py` in the letter to the editor.
