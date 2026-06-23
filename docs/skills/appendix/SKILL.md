---
name: appendix
description: Use when writing or auditing the appendix / online appendix / supplementary materials of an empirical paper or thesis — variable-definition tables, sample-construction details, method and identification descriptions, robustness tables, and reproducibility notes. Derives what the appendix must contain FROM the main text (which main-text claims need deferred support), then traces a three-link chain — main-text claim → appendix item → evidence in the project directory (data, code, output, logs, codebook) and literature — checking coverage (does the appendix back every main-text claim that needs it), grounding (does every appendix statement trace to real evidence), and consistency (do the numbers match across text, appendix, and data). Decomposes every statement into a typed claim (definitional / factual-quantitative / methodological / citational / result-robustness / procedural) and classifies each as SUPPORTED / UNSUPPORTED / MISMATCH. Make sure to use this skill whenever the user mentions an appendix, online appendix, or supplementary materials, asks to "check my appendix", "does my appendix match the paper/code/data", "what should go in my appendix", wants a data or variable-definitions appendix drafted, or wants appendix claims verified — even if they don't say the word "verify". Never silently rewrites a number; flags mismatches for the user to resolve.
allowed-tools: Read, Glob, Grep, Bash, Edit, Write
invocation: manual
---

# Appendix — derive it from the paper, then prove every line of it

An appendix is not a free-standing document — it exists **to support the main text**. So
its contents are not arbitrary: they are *determined by what the article claims*. Every
appendix item should answer a demand the main text creates ("see Appendix A for the full
definition", a headline number whose construction is deferred, a method whose assumptions
are relegated, a promised robustness check), and every such demand should have a matching
appendix item. That is the **chain** this skill builds and checks:

```
main-text claim  →  appendix item  →  evidence (project directory + literature)
```

Three things can break along that chain, and the skill checks all three:

- **Coverage** (main-text → appendix): does the appendix actually back every main-text
  claim that needs deferred support? A promised-but-absent first stage is a *coverage gap*.
- **Grounding** (appendix → evidence): does every appendix statement trace to something
  real — a line of code, a data value, a produced table, a verifiable citation?
- **Consistency** (main-text ↔ appendix ↔ data): does the sample N in the abstract equal
  the N in the data appendix equal the N the build script actually produces?

The unit of work, throughout, is borrowed from `literature-review`'s claim-decomposition:
**a sentence is not the unit of truth.** A single sentence — in the main text or the
appendix — bundles a definition, a count, a method, and a citation, each true or false on
its own terms and verifiable in a different place. So you split prose into *atomic, typed
statements* and chase each to ground.

This skill does two jobs against the chain — **audit** an existing appendix end to end,
and **author** a new one by deriving it from the main text so it's anchored by
construction. Authoring is "audit, run forward."

## When to use

- The user has an appendix / online appendix / supplementary section and wants it checked
  against their data and code.
- A referee or editor asked whether the appendix "matches the analysis."
- The user is drafting a data appendix, variable-definitions table, methods appendix, or
  robustness section.
- Pre-submission: making the appendix airtight before it reaches reviewers.

## Mode A — Audit an appendix

### Step 1 — Read the main text; derive the required-support set

The appendix is judged against the article, so start there. Read the main text and
decompose its claims into atomic typed statements (same six types as below), then keep
only the ones that **create a demand for deferred support** — i.e., the appendix *should*
contain something for them. A main-text statement needs an appendix anchor when it:

- references a definition/construction that is deferred ("active users, defined in App. A");
- reports a headline number whose derivation isn't shown inline (the sample N, a key share);
- names a method/identification whose details or assumptions are relegated to the appendix;
- promises a robustness or secondary result ("results are robust to …, see App. C");
- makes a citation that must resolve to a real source;
- relies on data whose provenance/sample construction is deferred.

The output is the **required-support set**: a list of main-text claims that demand
appendix backing, each tagged with the appendix section that *should* hold it, and with
the specific value/claim to later check for consistency (e.g. "abstract says N = 4,213").
Explicit "see Appendix X" pointers are the easy ones; the valuable catches are the
*implicit* demands — a method named in §3 with no assumption discussion anywhere, a
number in a main-text table never reconstructed. (`references/empirical-exemplars.md`
shows, per method family, the categories of support a top-journal main text implies.)

### Step 2 — Survey the directory: build the evidence map

You cannot verify against a project you haven't looked at. Before reading the appendix
closely, inventory where evidence could live, so each later claim has somewhere to go.

```bash
# data
find . -maxdepth 3 -regextype posix-extended -iregex '.*\.(csv|dta|parquet|rds|xlsx|feather|json)$' 2>/dev/null
# analysis code
find . -maxdepth 3 -regextype posix-extended -iregex '.*\.(R|do|py|jl|ipynb|sql)$' 2>/dev/null
# output & logs
find . -maxdepth 3 -regextype posix-extended -iregex '.*\.(tex|log|out|txt)$' 2>/dev/null | head -50
# documentation
find . -maxdepth 3 -iname 'readme*' -o -iname '*codebook*' -o -iname '*dictionary*' -o -iname 'requirements*' -o -iname '*.lock' -o -iname 'renv.lock' -o -iname 'environment.y*ml' 2>/dev/null
```

Skim names and headers (not whole files yet). Produce a short evidence map: *where do
data live, which script builds the sample, which produces each table, is there a codebook,
is there an environment/seed record.* This map tells you, for each statement type, the
first place to look. (Adapt `find` to PowerShell `Get-ChildItem -Recurse -Include` on
Windows if the Bash tool isn't available; the project's `code/`, `output/`, `docs/`
layout is described in CLAUDE.md.)

### Step 3 — Decompose the appendix into typed statements

Read the appendix and split it into atomic statements, tagging each with exactly one of
six types. Tag at the level of the smallest thing that could independently be true or
false. The types, their evidence homes, and detection cues are in
**`references/statement-taxonomy.md`** — read it before your first decomposition; it has
the cue patterns and a worked example.

| Type | Asserts | Evidence home |
|---|---|---|
| Definitional | meaning/scope of a construct, variable, sample bound | codebook, construction code |
| Factual-quantitative | a count, range, share, moment | the data, summary-stat output, the script |
| Methodological | an estimator, design, specification, procedure | estimation code + canonical citation |
| Citational | attribution to a source | Crossref |
| Result-robustness | a finding or its stability | the table/figure/log produced |
| Procedural-reproducibility | software, versions, seeds, run order, access | env files, README, scripts |

Keep the statements in a working list (a table) — each row is one statement, its type,
the parent sentence, and (to be filled) evidence + verdict.

### Step 4 — Trace the chain: coverage, grounding, consistency

Now connect the three lists — the required-support set (Step 1), the evidence map (Step
2), and the appendix statements (Step 3) — along the chain.

**Coverage (main-text → appendix).** Walk the required-support set and match each item to
an appendix statement that backs it. An unmatched item is a **COVERAGE GAP**: the main
text needs or promises support the appendix doesn't provide (the classic "see Appendix B
for the first stage" with no first stage). The reverse — an appendix item that supports no
main-text claim — is an **ORPHAN** (usually harmless leftover, occasionally a sign the
main text dropped a result; note it, lightly).

**Grounding (appendix → evidence) and consistency.** For each appendix statement, find its
evidence and assign one of three verdicts — applied the way `verify-citations` classifies
and the way `analysis-cleanup` refuses to silently change a number. Where a statement also
appears in the required-support set with a value (e.g. the sample N), check the *three*
match: main text == appendix == data.

- **SUPPORTED** — evidence confirms it; record the `file:line`, table cell, or DOI.
- **UNSUPPORTED** — no evidence found; record what you searched and where. (Possibly true,
  just not anchored.)
- **MISMATCH** — evidence *contradicts* it; record exactly what the evidence says.

The non-negotiable rule: **never edit the appendix to match the evidence without
surfacing the discrepancy first.** A mismatch can mean the prose is stale *or* you found
the wrong artifact — only the author knows which. Report it; let them decide. This is the
same discipline as `analysis-cleanup`'s "never silently changes a number."

Per-type evidence-finding (full detail in `references/statement-taxonomy.md`):

- **Factual-quantitative** → re-derive when cheap. If the data file is present, load it
  and recompute the count/share/moment; compare to the stated value within rounding. If
  only a log/table is present, read it and note the number is second-hand. A number with
  no reproducible source is UNSUPPORTED.
- **Definitional** → find the construction line (`treated = rd_exp > 0`) or codebook row;
  SUPPORTED only when prose and code encode the *same* rule (same threshold, direction,
  population).
- **Methodological** → two layers. (1) Implementation: does code running the named method
  exist (right command/library/estimator, right clustering/weights)? (2) Citation: is the
  method cited to an appropriate, current standard? Use
  **`references/methodology-standards.md`** — it maps causal-inference, ML, NLP, and
  generative-AI methods to verified canonical guides across econ, marketing, CS, and
  general-interest venues. A correctly-implemented method with a stale-or-missing citation
  is a real finding (e.g. staggered-adoption DiD cited only to pre-2018 work).
- **Citational** → hand to `verify-citations` (Crossref); VERIFIED/MISMATCH/FABRICATED map
  onto SUPPORTED/MISMATCH/UNSUPPORTED.
- **Result-robustness** → open the referenced artifact and check it shows the claimed
  pattern (sign, significance, direction). For *whether the analysis behind it is sound*,
  defer to `analysis-review`; this skill only checks that the appendix faithfully reports
  what the artifact contains.
- **Procedural-reproducibility** → check the env file / README / lockfile / seed-setting
  line actually exists and matches.

### Step 5 — Report the audit

Lead with the two tables that mirror the chain: a **coverage table** (main-text demand →
appendix item) and a **grounding table** (appendix statement → evidence), each ordered so
the author can walk their own document. Use the `report` skill's Quick Template framing
for the summary line.

```markdown
# Appendix audit — <paper/section>

**Main-text claims needing support:** R  |  **Covered:** C  |  **Coverage gaps:** G
**Appendix statements checked:** N  |  **Supported:** S  |  **Unsupported:** U  |  **Mismatch:** M
Evidence map: <data dir> · <analysis scripts> · <output dir> · <codebook?> · <env record?>

## Coverage — does the appendix back what the main text needs? (main text → appendix)
| # | Main-text claim (location) | Needs | Appendix item | Status |
|---|---|---|---|---|
| 1 | abstract: "N = 4,213 firms" | data construction | §A.2 sample waterfall | COVERED |
| 2 | §3: "we instrument with judge leniency" | exclusion/first stage | — | COVERAGE GAP |
| 3 | §4: "robust to winsorization (App. C)" | robustness table | §C.1 (claim only) | COVERED (see grounding) |

## Grounding — does each appendix statement trace to evidence? (appendix → evidence)
| # | Appendix location | Statement (atomic) | Type | Verdict | Evidence |
|---|---|---|---|---|---|
| 1 | §A.2 | panel has 4,213 firms | factual | MISMATCH | data has 4,198 distinct firm_id (build_panel.R:88) |
| 2 | §B.1 | Callaway–Sant'Anna estimator | method | SUPPORTED | csdid call, estimate.do:42; cite ✓ |
| 3 | §B.1 | clustered at firm level | method | MISMATCH | code clusters at industry (estimate.do:44) |
| 4 | §A.3 | "active user" = ≥1 login / 28 days | definitional | SUPPORTED | active flag, clean.py:120 |
| 5 | §C.1 | robust to 1% winsorization | result | UNSUPPORTED | no winsorized table found in output/ |

## Coverage gaps (main text promises/needs support the appendix lacks)
- §3 instruments with judge leniency but no appendix first stage / exclusion discussion (see methodology-standards.md: judge-IV standards).

## Mismatches to resolve (author decides)
- §A.2: prose says 4,213; recomputed 4,198 — stale draft, or different sample than build_panel.R?
- §B.1: prose says firm-level clustering; code uses industry — which is intended?

## Grounding gaps & orphans
- §C.1 robustness claim has no backing artifact — produce the table or soften the claim.
- §D (orphan): describes a dataset never referenced in the main text — leftover, or a dropped result?
```

Win condition: every required-support item COVERED, every appendix statement SUPPORTED,
all values consistent — empty coverage gaps, mismatches, and grounding gaps.

## Mode B — Author an appendix

Authoring is the audit run forward: **derive the appendix from the main text**, then write
each statement already knowing its evidence anchor, so the audit passes by construction.

1. **Derive the required-support set from the main text (Step 1 above).** This *is* the
   appendix outline — one appendix item per main-text claim that needs deferred support.
   Don't start from a blank template; start from what the article actually demands.
2. **Map onto a venue skeleton** — slot the required-support items into the sections econ /
   marketing-IS / CS / general-interest reviewers expect (`references/appendix-conventions.md`,
   default Data → Methods → Robustness → Reproducibility). If an expected section has no
   corresponding main-text demand, ask the user whether the main text is missing something
   (e.g. a named method with no stated assumption) rather than padding the appendix.
3. **Calibrate depth against exemplars.** For each method the paper uses, check
   `references/empirical-exemplars.md` for the categories of support a top-journal appendix
   in that field carries (construction + assumption/validation + robustness + materials).
4. **Survey the directory (Step 2 above)** so you write from real artifacts, not memory.
5. **Anchor as you write** — beside each statement, note the `file:line` / table / DOI it
   rests on (a parallel column or comment), then verify it the moment it's written using
   the Step 4 machinery. Delete the scaffolding once green.
6. **Cite methods to current standards** from `references/methodology-standards.md`; run
   any new citation through `verify-citations` before it lands.
7. **Format** — tables for definitions/parameters/sample-waterfalls (`tables` skill),
   self-contained captions, explicit cross-refs to the main-text equation/table each
   section supports. Prose register follows the `paper-writing` skill.

## Composition with sibling skills

This skill is a coordinator; it leans on the repo's existing skills rather than
re-implementing them:
- `verify-citations` / `literature-review` — citational statements, and any new citation.
- `analysis-review` — whether the method *itself* is valid (this skill only checks that
  the appendix describes and reports it faithfully).
- `tables` / `visualization` — formatting appendix tables and figures.
- `paper-writing` / `report` — prose register and the audit report's framing.
- `replication-readme` / `preregistration` — overlap with the reproducibility section.

## Agent process notes

- **Start from the main text, not the appendix.** The appendix's job is defined by the
  article; deriving the required-support set first turns "is this appendix good?" (vague)
  into "does it back claim 1, claim 2, …?" (checkable) and surfaces the most damaging
  error — support the paper needs that simply isn't there.
- **Then build the evidence map.** Decomposing statements before you know where evidence
  could live wastes effort — you'll re-survey for every statement.
- **Recompute, don't trust the prose.** The whole value is independent re-derivation. A
  number that merely "looks plausible" is UNSUPPORTED until a script or the data produces
  it.
- **One statement, one verdict.** Resist grading whole sentences — a sentence that's 80%
  right reads as "fine" and the 20% mismatch slips through. The atomic split is what
  catches the buried wrong cluster level.
- **Stay in your lane on validity.** "Is this the right method?" is `analysis-review`'s
  job. This skill answers "does the appendix say what the code/data/literature actually
  show?"
- **Surface, never silently fix.** Mismatches are reported for the author to resolve.
  Editing a number to match found evidence can hide a deeper problem (wrong script,
  wrong sample) and erases the author's chance to catch it.
