---
name: academic-voice
description: Use when the user wants prose revised to match a target academic journal's voice. Produces a side-by-side diff (original vs. revised) with a one-line justification for each change. Does not change content, claims, or numbers — only voice, tense, register, and sentence structure.
allowed-tools: Read, Edit, Write
invocation: auto
disable-model-invocation: true
---

Revise prose to match a target journal's house voice — third-person past tense for *JM* findings, narrative-friendly first-person allowed in *JCR* discussions, equation-heavy formality for *Marketing Science*, and so on. Polish stage; runs on a draft after [writing.md](writing.md) has already gotten the structure and content right.

This skill is `disable-model-invocation: true` — voice revision is a delicate operation that should run only when explicitly invoked (`/academic-voice` or by name). Implicit triggering on a vague prompt like "fix this paragraph" risks unwanted style changes the user did not ask for.

---

## When to Use

- Final pass on a draft before submission to a specific journal
- Adapting a paper rejected at *JM* for resubmission to *MS* (or vice versa)
- Tightening a discussion section that drifted into marketing-speak or industry jargon
- Cover letters and responses to reviewers, where house voice matters as much as in the paper

Do **not** use this skill for first-draft composition — that's [writing.md](writing.md). Do not use it to fix substantive content; if the argument is unclear, that's a content problem, not a voice problem.

---

## Non-negotiable rules

1. **Never change a substantive claim, a number, or a citation.** If a sentence makes a claim that the journal style would not, flag it but do not delete it.
2. **Never add new claims or hedges that were not in the original.** Voice revision is subtractive and lateral, not additive.
3. **Always emit a side-by-side diff** so the user can see every change.
4. **Each change must have a one-line justification keyed to a style rule.** "Sounds better" is not a justification.

---

## Workflow

```
Identify journal → Tokenize → Apply voice rules → Diff with justifications → Final pass
```

### Step 1 — Identify the target journal

Ask the user for the target journal and the input text. If the journal is in the profile list below, load it directly. If unknown, ask the user to name 2–3 papers from that journal as exemplars, then proceed.

| Journal | Voice profile |
|---|---|
| *Journal of Marketing* | Third person, past tense for findings, no first-person claims, conservative on hedging |
| *Marketing Science* | Formal, equation-heavy, defines all terms, no informal connectors ("so", "really") |
| *Journal of Consumer Research* | Narrative-friendly, first person allowed in discussion, theoretical framing emphasized |
| *Journal of Marketing Research* | Crisp, methods-forward, minimal qualifiers |
| *Quantitative Marketing and Economics* | Economics-style, theorems before intuition |

### Step 2 — Tokenize the input into sentences

Split the input into individual sentences, preserving paragraph boundaries. Number them.

### Step 3 — Apply voice rules sentence by sentence

For each sentence, decide whether to (a) keep, (b) revise, or (c) flag. Common revision rules:

- Replace contractions with full forms (`don't` → `do not`)
- Replace hedges that journal style avoids (`we think` → `the data suggest`)
- Tighten passives where the agent is clear; preserve passives where they are intentional
- Remove rhetorical adverbs (`clearly`, `obviously`, `interestingly`)
- Replace marketing-speak with technical terms (`game-changing` → `substantial`; `leverage` → `use`)

### Step 4 — Emit a diff with justifications

```
### Sentence 3

**Original:** We obviously found that consumers really care about scarcity cues.

**Revised:** Consumers responded to scarcity cues (Section 4).

**Justifications:**
- "obviously" → removed (rhetorical adverb; *JM* avoids)
- "we found" → recast in third person (*JM* convention)
- "really care about" → "responded to" (specific verb; testable)
```

### Step 5 — Final pass

Print the full revised text as a single block at the end so the user can copy-paste. Above it, print a one-line summary: *"Revised 14 of 22 sentences. Flagged 1 substantive claim for review."*

---

## How this composes with the other writing skills

```
brainstorm → literature-review → eda → report.md artifacts
                                          ↓
                                       writing  ← draft (structure + content)
                                          ↓
                                   academic-voice  ← polish for target journal
                                          ↓
                                      revision  (if R&R arrives)
```

Sequential, not overlapping:

- [writing.md](writing.md) gets the paper *structurally and substantively* right against a generic empirical-econ template — including Movement 7's strict-traceability mode for sections (especially Methods) where claim provenance matters more than narrative flow.
- This skill does the final pass to match the *target journal's* house voice.
- [revision-plan.md](revision-plan.md) handles referee responses if and when the R&R arrives.

The discipline-generic rules in `writing.md` Movement 5 ("Active voice, first person plural", "No throat-clearing", "Concrete numbers beat vague summary") and the journal-specific rules here are not redundant — the same sentence lands differently in *JM* vs. *MS* vs. *JCR*. Apply both, in order.

---

## Notes for extending

- **Profile files.** Journal voice profiles can live in `profiles/<journal-slug>.md` and be loaded as Level-3 resources. Currently the profiles are inline in Step 1; splitting them out is a clean extension once the list grows past ~10 journals.
- **Voice from exemplars.** When the journal is unknown, sample 5–10 sentences from a recent exemplar paper and infer the rules instead of asking the user to articulate them. The exemplar-driven path is more reliable than asking authors to introspect their own house style.
- **Multi-pass register.** Cover letters, response-to-reviewers, and the paper itself have different sub-registers within the same journal. A single profile is a starting point, not the final word.
