# Source protection and build cleanup

Read this reference when configuring a research project's protected paths, build roots, or cleanup procedure. Populate paths from the project; the manuscript layout below is an example, not a required structure. Keep the essential rules in AGENTS.md and link to a tailored procedure in the project's documentation.

## Preservation boundary

“Clean build artifacts” authorizes neither directory deletion nor deletion of manuscript sources, bulk file rollback, or repository cleaning. Finishing a task or committing changes does not imply cleanup permission. These limits govern cleanup; they do not prevent separately authorized manuscript edits or code refactoring.

Protect authoritative sources and retained artifacts by default:

- Manuscripts, including `output/paper/ms/` when present.
- `.tex`, `.bib`, `.bbl`, `.sty`, and `.cls` files; required images, data, and PDFs.
- Preprocessing and result-generating scripts, including `output/code/`.
- Raw data, retained processed data, replication inputs/caches, and final outputs.
- Uncommitted and untracked work, and files whose purpose is unknown.

An extension, modification time, Git ignore rule, or directory name such as `output`, `temp`, or `build` does not prove a file is disposable. In particular, `.bbl` remains protected even though some builds regenerate it. An explicit, separate request is needed to remove a protected artifact; a build cleanup manifest must not silently reclassify it.

## Cleanup contract

1. **Prepare a concrete dry-run.** Report the absolute build root and every candidate's full path, reason for deletion, and evidence that it can be regenerated from available inputs. This list, together with recorded provenance and file/path state, is the cleanup manifest even when the build tool does not produce one. Require explicit approval of that exact list before deletion. Existing approval remains valid only for the same list and unchanged file/path state; a general “clean up” request is insufficient.
2. **Require build provenance.** Accept only ordinary auxiliary files confirmed created by this build inside the approved root and unused by active processes. Prefer a manifest recorded as the build creates files. An extension allowlist is an additional filter, never the source of authority. Do not search the entire project for matching suffixes. If ownership or regeneration is uncertain, preserve the file.
3. **Validate containment and file types.** Inspect the build root, all ancestors along each path, and each candidate without following links. Reject junctions, symbolic links, other reparse points, unknown types, inspection failures, and paths outside the approved root. Normalize paths and compare directory components; a text prefix such as `build` also matches `build-old` and is insufficient. A normalized or absolute path alone does not prove physical containment.
4. **Revalidate before execution.** Compare the manifest and file/path state with the approved dry-run, including identity/content information sufficient to detect replacement. Cancel on changes. Never regenerate a broader deletion list after approval. Stop active writers first; path checks alone do not eliminate a race between checking and deleting.
5. **Delete individual listed files only.** Do not delete directories, even empty ones, as build cleanup. Do not invoke recursive tree deletion such as `Remove-Item -Recurse`, `rmdir /s`, `rd /s`, `rm -rf`, or `shutil.rmtree`. Do not use `git clean`, bulk restore/reset, mirror/purge operations, or directory moves as substitutes. On PowerShell, use literal file paths; do not pass enumerated paths into `cmd` or construct deletion commands as strings.
6. **Stop on the first error.** Preserve the original error and report files already removed and files left untouched. Do not retry through another shell, library, or implementation, elevate privileges, alter ACLs, or expand writable roots to complete cleanup. Uncertain cleanup ends with temporary files left in place.

A cleanup helper should implement this contract with dry-run as its default and execution bound to the reviewed manifest. Its checks protect only operations performed through that helper; an unrestricted agent can still invoke other tools. Do not call an unimplemented or untested helper an installed safeguard.

## Separate builds from sources

Prefer a dedicated local scratch directory outside the authoritative project and cloud-synced manuscript tree. Configure the compiler to write auxiliary files there, or build from a real copy of the required inputs. Do not link the source tree into scratch with junctions, symlinks, or hard links. Copied source files remain excluded from cleanup.

When configuring runtime protection for build/cleanup sessions, keep the authoritative project read-only at the sandbox or OS level and grant writes only to scratch and necessary caches. For editing, use a separately authorized editing session or a disposable working copy followed by reviewed changes to the authoritative project. Missing runtime protection does not block documentation work or authorized editing/builds, but must be reported as unverified; cleanup still requires the contract above. Keep publishing final outputs separate from auxiliary-file cleanup.

## Instructions, enforcement, and recovery

| Layer | What it provides | What must be verified |
|---|---|---|
| AGENTS.md and this procedure | Durable behavioral instructions | Protected paths and cleanup boundaries are present and consistent |
| Manifest and cleanup helper | Checks on the helper's candidate files | Dry-run, provenance, containment, changed-state handling, and stop-on-error behavior |
| Sandbox or OS permissions | Restrictions on filesystem access despite a mistaken command | The effective execution identity/policy cannot modify protected paths, including through aliases |
| Independent versioned backup | Recovery after deletion or overwrite | It includes uncommitted/untracked work, is outside the agent's write access, and can be restored |

Record each layer as unconfigured, configured but untested, or verified with the test date and scope. A marker file, `.gitignore`, or written “read-only” label is not a filesystem boundary. Git checkpoints preserve captured work; do not assume they cover later or untracked changes. Test restoration from an independent backup.

### Codex build profile example

Permission profiles are beta. Verify current support and the effective session profile before deploying an example. This example keeps local sandboxed commands read-only except for a designated Windows scratch directory:

```toml
default_permissions = "paper-build"

[permissions.paper-build]
extends = ":read-only"

[permissions.paper-build.filesystem]
"C:/codex-builds/paper" = "write"
```

Choose the actual scratch path from build configuration. Legacy `sandbox_mode` settings or `--sandbox` can override profile selection; do not assume adding this block activates it. Profiles govern local sandboxed commands; connectors, MCP servers, computer use, and approved escalations have separate controls. `read` blocks modification, renaming, and deletion; `write` also permits deletion. There is no separate delete-only permission in this profile schema. See [OpenAI permission profiles](https://learn.chatgpt.com/docs/permissions).

On native Windows, OpenAI recommends the `elevated` sandbox implementation, which uses dedicated lower-privilege sandbox users. The `unelevated` fallback cannot enforce every split read/write policy. Verify behavior on the actual filesystem, especially mounted or cloud-backed drives. See [Windows sandbox documentation](https://learn.chatgpt.com/docs/windows/windows-sandbox). Installing this skill does not configure either implementation or change an active session's permissions.

### Windows deletion permissions

An OS policy can allow writes while restricting deletion, but Windows allows deletion through either the file's delete permission or its parent's delete-child permission. Account for both, inherited permissions, and the execution identity. Renaming also depends on those rights, so test editor save/replace behavior. See [Microsoft's DeleteFile documentation](https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-deletefilew).

Such a policy still permits content overwrites if write access remains. Prefer read-only source access during builds; use deletion restrictions as an additional measure when editing must remain possible. Do not grant the build worker authority to remove its own protection.

## Verification before claiming protection

Test a proposed helper or permission setup only in an isolated fixture with disposable files, under the same execution identity and policy intended for real builds. Establish scope before creating test links; never target a live manuscript or backup. Explicitly authorize the fixture's deletion tests when the setup is implemented.

Cover these outcomes:

- An approved ordinary auxiliary file can be removed; source files (including `.bbl`), retained PDFs, and unlisted files remain byte-for-byte unchanged.
- A nested junction or symlink to a dummy protected manuscript, a linked build root/ancestor, and any unrecognized reparse point cause cleanup to stop without touching the target.
- A sibling path such as `build-old`, a parent-directory escape, or an unexpected directory is rejected.
- A changed candidate/manifest after dry-run cancels execution.
- An induced deletion failure stops subsequent deletions, preserves the error, and triggers no fallback command.
- The active sandbox/OS boundary rejects direct writes, renames, and deletions against dummy protected sources even outside the helper. Any other tool surface with filesystem access is assessed separately.
- A backup restores both a tracked dummy manuscript and an untracked draft after a simulated loss in the fixture.

For documentation-only changes, review these scenarios without running destructive commands. Report runtime protection as unverified until the actual helper, permissions, and recovery setup have passed their applicable checks.
