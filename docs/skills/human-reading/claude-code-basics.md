# Claude Code basics: model, harness, and everyday operation

This is a human-facing introduction to Claude Code. It explains the product concepts and controls that a user needs before configuring an agent for a specific research project. For behavior that may change between releases, follow the linked official documentation.

Last reviewed: 2026-07-19.

## Contents

1. [Model and harness](#model-and-harness)
2. [Install and update Claude Code](#install-and-update-claude-code)
3. [Choose a model](#choose-a-model)
4. [Sessions, context, and memory](#sessions-context-and-memory)
5. [Choose the right extension mechanism](#choose-the-right-extension-mechanism)
6. [Control skill invocation](#control-skill-invocation)
7. [Permissions and safe execution](#permissions-and-safe-execution)
8. [Configure a status line](#configure-a-status-line)

## Model and harness

The **model** is the reasoning and language engine, such as a Claude Sonnet or Opus model. It interprets the available context and decides whether to answer, inspect a file, call a tool, or take another step.

The **harness** is a useful informal name for the runtime around the model. In Claude Code, it assembles the prompt and context, exposes tools, applies permissions, executes approved actions, returns results to the model, manages sessions and compaction, and loads features such as `CLAUDE.md`, skills, hooks, subagents, and MCP servers. Anthropic generally describes this machinery as Claude Code's **agentic loop**, tools, and execution environment rather than as one official component named “the harness.”

```text
user request
    ↓
Claude Code assembles instructions, context, and tools
    ↓
model reasons and answers or requests a tool
    ↓
Claude Code checks permissions and executes the tool
    ↓
tool result returns to the model; the loop repeats
```

Changing the model changes the reasoning engine. Changing the harness configuration changes what the model can see, do, remember, and verify. See [How Claude Code works](https://code.claude.com/docs/en/how-claude-code-works) and [How the agent loop works](https://code.claude.com/docs/en/agent-sdk/agent-loop).

## Install and update Claude Code

Anthropic recommends the native installer.

On Windows PowerShell:

```powershell
irm https://claude.ai/install.ps1 | iex
```

On macOS, Linux, or WSL:

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

On native Windows, Git for Windows is recommended so Claude Code can use Git Bash; without it, Claude Code can fall back to PowerShell. WSL is a separate supported environment and should use the Linux installer inside WSL.

Verify the installation and diagnose configuration problems with:

```text
claude --version
claude doctor
```

Native installations update automatically. Run `claude update` to request an update manually. WinGet installations require `winget upgrade Anthropic.ClaudeCode`. See the current [installation guide](https://code.claude.com/docs/en/installation) before troubleshooting or automating installation.

## Choose a model

Use `/model` during an interactive session or `claude --model <alias-or-model-id>` when launching a session. A user or project `settings.json` can also set the initial model.

Model aliases such as `sonnet` and `opus` can move to newer releases. Use an alias when you want the current model in that family; pin a full model identifier when an evaluation, replication exercise, or regulated workflow requires a stable model version. Account tiers and administrators can restrict which models are available.

Model choice and harness configuration are separate decisions: selecting a stronger model does not grant additional file access or bypass permissions. See [model configuration](https://code.claude.com/docs/en/model-config) and the [CLI reference](https://code.claude.com/docs/en/cli-reference).

## Sessions, context, and memory

Each new session starts with a fresh context window. The context can contain system instructions, conversation history, file and command output, `CLAUDE.md`, auto memory, loaded skills, and tool definitions. Claude Code manages context automatically and compacts as it approaches the limit.

Use the built-in commands instead of relying on a fixed percentage threshold:

| Command | Purpose |
|---|---|
| `/context` | Show what is consuming the current context window. |
| `/compact [focus]` | Replace older history with a summary, optionally stating what must be preserved. |
| `/clear` | Begin with an empty context while keeping the old session resumable. |
| `/memory` | Inspect loaded instruction files and auto memory. |
| `/resume` | Reopen a saved session. |

Compact when `/context` shows that stale conversation or large tool outputs are crowding out the current task, or before a long new phase that must preserve a specific working set. For example:

```text
/compact preserve the current objective, accepted decisions, modified files, failing tests, and remaining verification
```

Project-root `CLAUDE.md` is re-read after compaction, so durable project rules belong there rather than only in conversation. Nested instruction files reload when Claude next works in their directories. Keep `CLAUDE.md` concise and concrete because it consumes context at session start. See [context-window behavior](https://code.claude.com/docs/en/context-window), [session management](https://code.claude.com/docs/en/sessions), and [project memory](https://code.claude.com/docs/en/memory).

## Choose the right extension mechanism

| Mechanism | Use it for | Loading or execution behavior |
|---|---|---|
| `CLAUDE.md` | Concise project rules that should apply throughout a session | Loaded at session start; the project-root file is restored after compaction. |
| `.claude/rules/` | Modular or path-specific project instructions | Loaded globally or when matching files are used, depending on configuration. |
| Skills | Reusable domain knowledge or workflows | Descriptions advertise availability; bodies load when invoked. |
| Hooks | Deterministic actions at lifecycle events | Execute at configured events rather than depending on model compliance. |
| MCP | Connections to external tools, services, and data | Makes external capabilities available through MCP servers. |
| Subagents | Isolated or parallel work | Run with a separate context and return a result to the parent session. |

Use `CLAUDE.md` for rules, a skill for an on-demand procedure, a hook when an action must execute at a specific lifecycle point, and MCP when Claude needs an external system. See [Claude Code extensions](https://code.claude.com/docs/en/features-overview), [hooks](https://code.claude.com/docs/en/hooks-guide), and [MCP](https://code.claude.com/docs/en/mcp).

## Control skill invocation

A skill is a directory containing `SKILL.md`. Its YAML frontmatter controls discovery and invocation.

| Frontmatter | Effect |
|---|---|
| `name` | Sets the skill name; otherwise the directory name is used. |
| `description` | Explains what the skill does and when Claude should use it. |
| `disable-model-invocation: true` | Prevents Claude from invoking the skill automatically; the user can still invoke it. |
| `user-invocable: false` | Hides the skill from the user command menu while allowing Claude to invoke it. |
| `allowed-tools` | Lets the listed tools run without an additional permission prompt while the skill is active, subject to higher-priority policy. |
| `model` | Temporarily selects a model for the turn in which the skill runs. |

With neither invocation restriction, both the user and Claude may invoke the skill. Use `disable-model-invocation: true` for timed or side-effecting workflows such as deployment. Use `user-invocable: false` for background knowledge that is useful to Claude but is not a meaningful user command.

Do not rely on home-grown fields such as `invocation: manual`; use the fields documented by Claude Code. Keep skill bodies concise because invoked skill content occupies context. See [skills and invocation controls](https://code.claude.com/docs/en/slash-commands).

## Permissions and safe execution

The harness mediates tool use. Open `/permissions` to inspect and change rules:

- `deny` blocks matching actions;
- `ask` requires confirmation;
- `allow` permits matching actions without another prompt.

Denials take precedence over asks, which take precedence over allows. Treat `bypassPermissions` as an isolated-container or disposable-VM option, not a normal convenience setting. Permissions govern whether tools may act; sandboxing separately constrains what shell processes can reach at the operating-system level.

Put team-shared settings in `.claude/settings.json` and personal project settings in `.claude/settings.local.json`. See [permissions](https://code.claude.com/docs/en/permissions) and [configuration scopes](https://code.claude.com/docs/en/configuration).

## Configure a status line

The status line is a human interface feature. It can display the current model, directory, Git state, cost, duration, and context usage without adding text to the agent's prompt.

Ask Claude Code to configure it directly:

```text
/statusline show the model, git branch, and context percentage with a compact progress bar
```

Claude Code writes a local script and adds the `statusLine` setting. Keep the command fast because it runs repeatedly, and test custom scripts with mock JSON input. See the [status-line guide](https://code.claude.com/docs/en/statusline) for the current input fields and examples.
