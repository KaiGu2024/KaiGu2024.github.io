# Agent Skill: Agent Configuration

Configuring Claude Code for a research project: CLAUDE.md, status line, context management, and subagent delegation.

---

## Installation (Windows)

**Prerequisites — Git for Windows:**

Claude Code's installer requires Git for Windows (provides the Unix tools it depends on).

1. Download from https://git-scm.com/download/win and run the installer.
2. On the *Adjusting your PATH* screen, select **"Git from the command line and also from 3rd-party software"** (the default).
3. Complete the install, then open a new PowerShell window.

**Install Claude Code:**

```powershell
irm https://claude.ai/install.ps1 | iex
```

This handles PATH registration automatically. Verify with `claude --version`.

**Fallback (if you prefer npm):**

```powershell
npm install -g @anthropic-ai/claude-code
```

If `claude` is not found after install, add the npm bin dir to PATH:

```powershell
$npmBin = "$(npm config get prefix)"
$current = [Environment]::GetEnvironmentVariable("Path", "User")
if ($current -notlike "*$npmBin*") {
    [Environment]::SetEnvironmentVariable("Path", "$current;$npmBin", "User")
}
```

Then restart the terminal and verify with `claude --version`.

---

## CLAUDE.md

`CLAUDE.md` is loaded into every session and survives `/compact`. It is the one place for rules that must persist — put anything here that you would otherwise need to repeat after a context reset.

**What belongs in CLAUDE.md:**

- Project layout (which directories hold what)
- Tool constraints (e.g., which compiler to use, path overrides)
- Non-obvious conventions (naming, output locations, forbidden actions)
- Verification commands (how to test that the code/analysis is correct)
- Subagent inventory — names, purposes, and the scope constraints to re-state when spawning each one. Spawned subagents do not inherit CLAUDE.md, so the main agent needs the canonical text here to paste into every subagent brief.

**What does not belong:**

- Things derivable from the code (don't describe what the code already says)
- Temporary task state (use task notes or a separate scratchpad)
- Generic best practices (the model already knows these)

**Compaction survival test:** Read each line in CLAUDE.md and ask "if this disappeared after `/compact`, would the agent make a wrong decision?" If no, cut it.

```markdown
# Project: [Name]

## Layout
- `data/raw/`       — immutable source files, never overwrite
- `data/cleaned/`   — outputs of cleaning scripts
- `code/`           — all scripts; one file per pipeline stage
- `writing/`        — draft text, LaTeX source

## Constraints
- Never edit files in `data/raw/`
- Compile with: [exact compile command]
- Output figures to `output/figures/`

## Subagents
- `data-loader` — pulls and harmonizes raw files into `data/cleaned/`.
  Re-state in every brief: "do not look in `..` or modify anything in `data/raw/`".
- `figure-builder` — produces figures in `output/figures/`.
  Re-state in every brief: "house style is Kieran Healy; one chart per file; never write outside `output/figures/`".

## Verification
- Run `make test` to check pipeline end-to-end
```

---

## Custom Status Line

The status line appears at the bottom of the Claude Code terminal and shows live session state. It runs as a script that Claude Code polls — you describe what you want and the agent writes and wires the script for you.

**Initial prompt (paste into a fresh session):**

```
Please create a custom status line for Claude Code. I want it
to show my context-window usage as a horizontal progress bar
followed by the exact percentage as a number. The bar should
be colored based on usage:

  - green when usage is below 50%
  - yellow when usage is between 50% and 70%
  - red when usage is above 70%

Also show the model name on the left and the cost so far on
the right. When you are done, write the script, wire it into
~/.claude/settings.json, and tell me where you saved it so I
can open it later.
```

**Iteration prompts (one line each, same session):**

```
Make the bar twice as long.
```

```
Add an emoji for each zone (✅ / 🟡 / 🚨).
```

```
Show the git branch at the right instead of cost.
```

```
Use a darker shade of yellow — the current one is hard to read.
```

Each request is one line. You do not need to touch the script yourself — the agent edits and re-wires it each time.

**Rule of thumb:** Include context-window usage in every long research session. When it hits ~70%, plan a `/compact` or delegate remaining work to a subagent.

---

## Context Management

The context window fills as the session grows. When it reaches capacity, responses degrade silently before erroring.

**Signs of context pressure:**

- Agent stops following rules it followed earlier
- Responses become shorter and less specific
- The agent "forgets" files or constraints it previously knew

**`/compact` — when and how:**

Run `/compact` before context pressure causes degradation (~70–80% usage). Always include a preservation prompt:

```
/compact Preserve: (1) the current task and what's done vs. remaining,
(2) all rules from CLAUDE.md, (3) the output file paths agreed on.
Do not summarize code that hasn't changed.
```

Without a preservation prompt, compaction may lose the task state and force you to re-explain the situation.

---

## Subagent Delegation

Delegate to a subagent when a subtask is:

- **Isolated** — it doesn't need the main session's full context
- **Context-heavy** — running it inline would fill the window before the main task finishes
- **Risky** — you want failures contained and recoverable

**What makes a good subagent prompt:**

A subagent starts cold. It has no memory of your session. Write its prompt as if briefing someone who just walked in:

```
Context: [1–2 sentences on the project and why this task matters]
Task: [Exactly what to do, with file paths]
Output: [Where to write results and in what format]
Constraints: [Any rules from CLAUDE.md that apply]
```

**When not to delegate:** If the subtask needs information that only exists in the current conversation (live variable values, intermediate results held in memory), keep it in the main session.
