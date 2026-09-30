# Documentation layers — the five-layer model

Read when scaffolding or auditing a research project's layout, analysis naming, or notes wiki.

### Where documentation lives — the layers, and AGENTS.md's place in them

The five directories below hold project work; AGENTS.md supplies the operational guidance governing them.

| Layer | Holds | Rule |
|---|---|---|
| `code/` | Preprocessing, crawling, ingestion, and other input-preparation scripts | Name scripts in run order and key them to the substantive analysis (`01_ingest.py`, `02_localization.R`) |
| `data/` | Raw data plus processed data that remains large or is a primary project input | **Never edit `raw/` — read only** |
| `docs/` | Stable reference specs | Change only when design/schema/method changes |
| `notes/` | The living wiki | Changes every session |
| `output/` | Results and supporting sources: `output/code/` result-generating scripts, `output/data/` smaller processed data or reproducibility caches, tables, figures, reports, and manuscript sources | Preserve scripts, manuscripts, retained data, and final outputs; document provenance and decompose results by fact/analysis |

**Location does not establish disposability.** `output/paper/ms/`, `output/code/`, and retained `output/data/` may contain authoritative work. Even regenerable outputs can be required for replication or submission. Keep disposable build files in a separately identified build root and apply the [source-protection procedure](source-protection.md); neither `output`, `temp`, nor `build` in a path authorizes deletion.

### Analysis naming and outputs

When several analyses address the same substantive topic, use the listing number as the analysis name (for example, `01_localization`, `02_localization`). Keep that number and name consistent across scripts, outputs, notes, and documentation.

Keep input preparation in `code/` and result-generating reproducibility scripts in `output/code/`; do not duplicate a preprocessing script there. Each result-generating script should consume a named input, record its provenance, and write a predictable output keyed to the numbered analysis. Keep smaller processed inputs and reproducibility caches in `output/data/`.

### Documentation roles

| Role | Kind | Audience | Changes | Answers |
|---|---|---|---|---|
| `AGENTS.md` | Front door | The **agent** | When durable decisions / layout / constraints / conventions change | "How do I *operate* in this repo?" |
| `README.md` (root) | Front door | **Humans** | When onboarding facts change | "What *is* this and how do I start?" |
| `docs/` | Content — **stable reference** | Human + agent | Only when the design / schema / method actually changes | "What *exactly* is X?" |
| `notes/` | Content — **living wiki** | Agent (+ human) | Every session | "What do we *think* / what's next?" |

Keep AGENTS.md and README brief and link into the content directories. Environment and build configuration hold setup details; `docs/methodology/` holds method explanations.

- **`docs/`:** Use neutral, declarative prose. Organize stable material into `design/` (experiment/design specifications frozen before analysis), `methodology/` (replicator detail), `technical/` (data, code, and analysis architecture), and `references/` (external immutable material). Visualization and table conventions belong to their dedicated skills.
- **`notes/`:** Use Markdown, YAML frontmatter, and Obsidian `[[wiki-links]]` for evolving arguments and commentary. The core pages are `index.md` (catalog; search first), `overview.md` (evolving thesis and open work), `log.md` (chronology), and `methodology/decisions.md` (choices and rationale). Subfolders can include immutable `sources/`, `concepts/`, `entities/`, `findings/`, `literature/`, `methodology/`, and `paper/`. Link each fact from one authoritative page instead of copying it elsewhere; favor cross-links over hierarchy.

### History and wiki maintenance

- **Without a wiki:** README holds orientation, detailed rationale, and a dated update log.
- **With a wiki:** Move chronology to `notes/log.md`, rationale to `notes/methodology/decisions.md`, and the evolving thesis to `notes/overview.md`. README holds orientation; maintain one running log.

Include the maintenance, typed logging, and periodic wiki-lint rules from the [AGENTS.md template](../SKILL.md#generating-a-research-agentsmd-workflow) in persistent project instructions. Keep detailed wiki procedures in `notes/index.md`.
