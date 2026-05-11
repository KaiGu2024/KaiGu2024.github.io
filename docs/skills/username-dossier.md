---
name: username-dossier
description: Use when the user wants to collect an OSINT dossier on a person by username — checking which sites a handle is registered on, gathering public profile data, and producing a structured report. Triggers on phrases like "find accounts for username X", "check where this handle is registered", "OSINT lookup for @handle", "what sites is X on". Wraps the Maigret CLI; produces a markdown dossier, never a database dump.
allowed-tools: Read, Edit, Write, Bash
invocation: confirm
---

# Username Dossier (Maigret wrapper)

Collect a public OSINT dossier on a person by username — which sites the handle is registered on, with any profile metadata each site exposes. Wraps the [Maigret](https://github.com/soxoj/maigret) CLI (Python, ~3000 sites, no API keys required).

## When to Use

- Verifying that a username belongs to the same person across platforms (e.g., due-diligence on a co-author, interview subject, or research participant)
- Mapping a researcher's online footprint before a citation check
- Checking whether a handle the user is about to register is already taken across major sites

## When NOT to Use

- **Targeted harassment, doxxing, stalking, or building a profile on a private individual without a research-or-safety justification.** Decline these requests. Maigret only reads public data, but aggregating public data into a dossier still has real-world harm potential.
- **Mass-scanning** (more than a handful of usernames at a time). Maigret hits live sites; high-volume scans look like abuse to those sites.
- Checking a username you yourself control — each site's own search is faster.

Before running, confirm the purpose if it isn't already clear from context. If the answer is "I just want to know everything about this person," stop.

## Installation

```bash
pip install maigret
```

Maigret needs Python 3.10+. Verify with `maigret --version`.

## Workflow

```
Confirm purpose → Run maigret → Triage hits → Write markdown dossier
```

### 1. Confirm purpose

State back what you understood and what the dossier will be used for. One sentence each. If the user pushes back on the framing, clarify before scanning.

### 2. Run Maigret

Default: top-500 sites, JSON output, no PDF / no graph:

```bash
maigret <username> --json simple --top-sites 500 --no-progressbar --timeout 10
```

For a faster first pass while iterating: `--top-sites 50`. For exhaustive coverage when the username is rare: drop `--top-sites` entirely (~3000 sites, several minutes).

Useful flags:
- `--id-type username` (default) vs. `--id-type email`, `--id-type domain`
- `--site <name>` to limit to specific sites (e.g., `--site GitHub --site Twitter`)
- `--cookies-file <path>` for sites that require auth — only use cookies the user explicitly provides

Output path: `report_<username>_simple.json` in the current directory by default. Use `-fo <dir>` to redirect.

### 3. Triage hits

Maigret returns three statuses per site: `Claimed` (account exists), `Available` (no account), `Unknown` (check failed). Only `Claimed` belongs in the dossier:

```python
import json
hits = [s for s in json.load(open("report_<username>_simple.json")) if s.get("status") == "Claimed"]
```

For each hit, capture: site name, URL, any `ids` Maigret extracted (name, bio, location, follower counts, joined date).

### 4. Write the dossier

Markdown, one section per platform, sorted by site importance (major social → professional → niche). Header block: target username, scan date, sites checked, sites confirmed, purpose (echo what the user said in step 1).

End with a **Limitations** section: (a) "Claimed" only means a profile exists at that URL, not that it belongs to the same person; (b) usernames are often reused; (c) Maigret cannot see private accounts.

## Output Format

```markdown
# Dossier: @<username>

**Scan date:** 2026-05-11
**Purpose:** <one line, quoted from the user>
**Sites checked:** 500 (top-sites default)
**Confirmed accounts:** 14

## Major Social
### Twitter / X — https://twitter.com/<username>
- Display name: ...
- Bio: ...
- Followers: ...

### Instagram — https://instagram.com/<username>
- Private account — no bio extracted

## Professional
### GitHub — https://github.com/<username>
...

## Limitations
- Confirmed accounts share the username but may not belong to the same person.
- Maigret cannot read private or deleted content.
- Sites with anti-bot measures may be reported as Unknown.
```

## Non-negotiable rules

1. **Public data only.** Maigret reads public-facing pages. Do not combine it with credential-stuffing, paste-site scraping, or anything that needs a breach corpus.
2. **No mass scans.** One target per invocation. If the user asks for a batch, ask why.
3. **Cite the source.** Every line in the dossier traces to a Maigret hit. Do not infer from absence — "no LinkedIn" might mean Maigret's LinkedIn check failed, not that the person has no LinkedIn.
4. **Flag uncertainty.** If two confirmed accounts contradict each other (different real names, conflicting locations), say so in the dossier rather than picking one.
