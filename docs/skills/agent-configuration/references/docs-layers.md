# Documentation layers — the five-layer model

Extended reference for the `agent-configuration` skill. Loaded on demand when scaffolding a full research-project structure; kept out of `SKILL.md` so it does not cost context on every invocation.

### Where documentation lives — the layers, and CLAUDE.md's place in them

CLAUDE.md does not exist in isolation. A mature research project is organized into **five execution layers**, and CLAUDE.md is the layer that governs the other four rather than storing content itself.

| Layer | Holds | Rule |
|---|---|---|
| `code/` | Preprocessing, crawling, ingestion, and other input-preparation scripts | Name scripts in run order and key them to the substantive analysis (`01_ingest.py`, `02_localization.R`) |
| `data/` | `raw/` (immutable source) + `processed/` | **Never edit `raw/` — read only** |
| `docs/` | Stable reference specs | Change only when design/schema/method changes |
| `notes/` | The living wiki | Changes every session |
| `output/` | Derived results, including `output/code/` result-generating scripts and `output/data/` smaller processed data or reproducibility caches, plus tables, figures, reports, and the paper | `output/code/` and `output/data/` must be regenerable or traceable from `code/` + `data/`; outputs are decomposed by fact/analysis |

The confusing part is always the **documentation roles**, because four things look like "documentation" but do four different jobs. The distinction that keeps them from bleeding into each other: **two are *content* (they hold knowledge); two are *front doors* (they orient a reader and route into the content).** They split on two axes — content vs. orientation, and within each, by stability or by audience.

| Role | Kind | Audience | Changes | Answers |
|---|---|---|---|---|
| `CLAUDE.md` / `AGENTS.md` | Front door | The **agent** | When layout / constraints / conventions change | "How do I *operate* in this repo?" |
| `README.md` (root) | Front door | **Humans** | When onboarding facts change | "What *is* this and how do I start?" |
| `docs/` | Content — **stable reference** | Human + agent | Only when the design / schema / method actually changes | "What *exactly* is X?" |
| `notes/` | Content — **living wiki** | Agent (+ human) | Every session | "What do we *think* / what's next?" |

**The load-bearing rule: front doors are not content bodies.** CLAUDE.md and README are thin. They point *into* `docs/` and `notes/`; they never accumulate the knowledge that belongs there. When you are tempted to explain a method inside CLAUDE.md, write it in `docs/methodology/` and link; when you want to record what changed, append to `notes/log.md`. A front door that grows a knowledge base has stopped being a front door.

- **`CLAUDE.md` / `AGENTS.md` — the agent's operating manual + router.** (Both filenames name the same role; use whichever the toolchain expects, and don't maintain two.) It carries the behavioral rules, the tool constraints, the subagent inventory, and pointers to where content lives (`notes/index.md`, the `docs/` subfolders). It is loaded every session and survives `/compact`, so every line costs context on every turn — hence "thin." Crucially, it is the only place that can carry the **maintenance discipline** for the wiki, because those rules have to fire on every turn and survive compaction (see below).
- **`README.md` (root) — the human front door.** The GitHub landing page. What the project is, how to get set up, where things are, how to run. Orientation for a collaborator or future self — not for the agent (that is CLAUDE.md's job) and not a place for specs (that is `docs/`). Distinct from the *replication-package* README (the public handoff artifact covered later in this skill).
- **`docs/` — the stable reference manual.** Neutral, declarative, specification-style ("3,150 rows × 37 columns"). Four subfolders, each a documentation type: `design/` (the experiment/design spec, frozen before analysis — "what we set out to do and why"), `methodology/` (the how, at replicator detail), `technical/` (`data_architecture.md`, `code_architecture.md`, `analysis_architecture.md`), `references/` (external immutable material — parallels `notes/sources/`). Visualization and table conventions belong to the dedicated `visualization` and `tables` skills, not to a project-level style-guide document.
- **`notes/` — the living wiki.** A file-based knowledge base in plain Markdown with YAML frontmatter and Obsidian `[[wiki-links]]`, maintained across sessions. Argument-and-commentary voice ("the big implication"). Four load-bearing pages: `index.md` (master catalog — search here first), `overview.md` (the evolving thesis + Open Work checklist), `log.md` (chronological history), `methodology/decisions.md` (choices + rationale). Layered subfolders (`sources/` immutable, `concepts/`, `entities/`, `findings/`, `literature/`, `methodology/`, `paper/`). Organizing principles: **single source of truth per fact** (a number lives on one `findings` page and is *linked*, never copied — which is why log entries are thin pointers, not restatements), and **cross-linking over hierarchy**.

**Two configurations — where the running history lives.** The line most projects get wrong is *where the log goes*, and it depends on whether a `notes/` wiki exists:

- **Lightweight project (no wiki).** README does double duty: human front door **plus** a dated changelog. CLAUDE.md is the agent manual. This is the two-document setup the next section describes.
- **Full research project (with wiki).** The running history moves into the wiki: chronology to `notes/log.md`, rationale to `notes/methodology/decisions.md`, the evolving thesis to `notes/overview.md`. README then shrinks back to pure orientation, and CLAUDE.md gains the wiki-maintenance rules. Do not keep a second changelog in README once `notes/log.md` exists — that violates single-source-of-truth.

**The maintenance contract (why it must live in CLAUDE.md).** A wiki decays without discipline, and the discipline is stated in `notes/index.md` — but the *trigger to follow it* has to survive `/compact` and fire every turn, so it belongs in CLAUDE.md as operational rules. Put these two verbatim:

- **Append to the log.** After each meaningful operation, append one entry to `notes/log.md` in a fixed, grep-parseable format — `## [YYYY-MM-DD] operation | description` — with typed operations (`ingest`, `lint`, `strategy`, …) so history is queryable (`grep "^## \[" notes/log.md | tail -10`). The entry *links* to the phase plan and to `[[decisions#...]]`; it does not restate them.
- **Lint periodically.** Every so often, sweep the wiki for orphan pages, stale claims, and missing cross-references, and fix or flag them. Record the sweep as a `lint` log entry.

Both are just two more bullets in the CLAUDE.md "Operational rules" block (see the generator below).