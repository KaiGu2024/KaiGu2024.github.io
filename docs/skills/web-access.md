---
name: web-access
description: Use for substantial web research, public or logged-in page retrieval, dynamic websites, browser navigation, browser interaction, or tasks that require a real browser session. Prefer the platform's native web tools for read-only public pages; use browser automation only when interaction, authentication, dynamic rendering, or a user-provided browser session is necessary.
---

# Web Access

Use this skill to choose the least invasive reliable way to access web content and to verify that the result actually answers the user's request.

## Operating principles

- Define the target and success condition before browsing. Identify whether the user needs discovery, a cited answer, an extracted artifact, or an action performed on a website.
- Start with the simplest suitable method and escalate only when the result is incomplete or inaccessible.
- Treat every result as evidence, not merely as a success/failure signal. Check relevance, completeness, freshness, and provenance before stopping.
- Prefer primary sources: official documentation, original publications, government sources, company pages, and original datasets. Use search engines and aggregators for discovery, not as the final authority when a primary source is available.
- Preserve source URLs and cite the pages that support factual claims.
- Do not repeatedly retry an approach that produces no new evidence. Reassess whether the target exists, whether the URL is correct, or whether another access method is required.

## Choose an access method

Use the environment's native web-search and page-fetch tools when they are available.

| Situation | Preferred method |
|---|---|
| Discover sources or search by keywords | Native web search |
| Read a known public URL | Native page fetch or direct HTTP request |
| Retrieve raw HTML, metadata, JSON-LD, or a downloadable file | Direct HTTP request |
| Read a dynamic page whose content is rendered in the browser | Browser automation |
| Use an existing login session or navigate through a site interactively | Browser automation |
| Submit a form, upload a file, send a message, purchase something, or change account state | Browser automation only after explicit user authorization |

Do not use browser automation merely because a URL is known. Do not use a search snippet as evidence when the underlying source can be opened.

### Optional text extraction services

An intermediary such as Jina Reader may convert an article, document, or PDF to Markdown and reduce context usage. Treat its output as a convenience layer, not as the authoritative source. Verify important claims against the original page. Avoid it for dashboards, product pages, highly structured tables, and other layouts where extraction can change the meaning.

## Browser automation and CDP

Use a real browser session when the task requires authentication, client-side rendering, user-like navigation, or interaction that static retrieval cannot reproduce.

Before connecting, verify that the required browser bridge or CDP proxy is available. If this repository includes dependency-check or browser-start scripts, run those scripts first. If the scripts are not installed, do not invent their location; report the missing dependency and explain how the user can provide or enable it.

When using a user-provided browser session:

- Keep the user's existing tabs and state intact.
- Prefer creating a separate background tab for the task.
- Never expose, copy, or summarize credentials, session tokens, private messages, or unrelated personal data.
- Close tabs created for the task when finished, unless the user asks to keep them open.
- Do not claim that automation safeguards eliminate account or platform risk.

### Inspect before acting

First inspect the page structure and visible state. Use DOM inspection or an equivalent read operation to locate links, buttons, forms, text, and loading indicators. Choose the next action based on what is actually present rather than assuming a fixed page layout.

For dynamic pages:

1. Open the target or navigate from a trusted page link.
2. Inspect the page and wait for relevant content to render.
3. Scroll or expand sections only when needed to expose the target content.
4. Extract text or structured data and verify that it is complete.
5. Use a screenshot only when visual layout, an image, chart, or video frame carries information that DOM extraction cannot capture.

### Confirmation before consequential actions

Reading public or already-authorized private content is normally non-consequential. Ask for confirmation immediately before any action that changes external state, including:

- sending or publishing content;
- submitting forms or applications;
- uploading or deleting files;
- making purchases, bookings, donations, or financial transfers;
- changing account, privacy, security, or subscription settings;
- accepting terms or granting permissions;
- liking, following, sharing, or otherwise interacting publicly.

The confirmation should state what will happen and identify the relevant target. Do not infer consent from a general request to browse or from the user's continued conversation.

## Local browser history and bookmarks

If the user refers to a page they previously visited or an internal site that is not publicly searchable, search local bookmarks or history only when the browser integration explicitly supports it and the user has provided that context.

Treat history and bookmarks as sensitive. Search narrowly, return only the matching URL or requested information, and do not disclose unrelated entries.

## Media and structured content

When a page contains images, audio, video, charts, or tables:

- Extract the underlying URL or structured data when possible.
- Scroll or trigger lazy loading before concluding that media is absent.
- Distinguish a missing element from an inaccessible element.
- For video, use the page's rendered state or permitted media URL only when necessary; do not bypass access controls.
- For tables and dashboards, preserve headers, units, filters, dates, and the page state used for extraction.

## Login walls and access limits

Try to obtain the requested content without logging in first. If the content genuinely requires authentication, tell the user which site needs their existing browser session or ask them to complete the login themselves. Never request or handle passwords, one-time codes, recovery codes, or session cookies in chat.

If a page is blocked by a login wall, robots policy, rate limit, paywall, or anti-automation control, do not misrepresent the result as evidence. Explain the limitation and offer a legitimate alternative, such as an official API, public copy, user-provided export, or manual user action.

## Source verification

Use search results and aggregation platforms to locate sources. Then open the original source whenever possible.

For claims about policy, law, company announcements, software behavior, or tool capabilities, verify against the responsible organization's current documentation or publication. For academic claims, prefer the original paper or publisher page.

When the primary source cannot be found, label the limitation clearly and identify the secondary source used. Do not treat several outlets repeating the same report as independent confirmation.

## Parallel research

Parallelize independent read-only research targets when the environment supports subagents and the tasks do not share mutable browser state.

Give each subagent:

- the precise target and success condition;
- the source or domain scope;
- the required output format and citation requirements;
- a read-only constraint unless the user separately authorized an action.

Do not parallelize tasks that depend on another task's result, share a tab or mutable session, or could produce duplicate external actions. If multiple workers use one browser profile, each must use a separate task tab and must not interact with another worker's tab.

## Site-specific notes

Record verified, reusable site behavior only when this skill is installed as a full package with a writable `references/site-patterns/` directory. Store notes by domain and include the observation date. Record confirmed URL patterns, rendering behavior, required navigation, and known limitations; do not record credentials or guesses.

Read a site's pattern file only after identifying the target domain and only when the file exists. Treat it as a possibly stale hint, not a guarantee. If it fails, return to the general workflow and update the note only with newly verified facts.

## Completion checklist

Before stopping, confirm:

- the requested target was found or the access limitation is explicit;
- extracted content is relevant and sufficiently complete;
- important claims are supported by direct source URLs;
- dates, units, filters, and page state are recorded where relevant;
- no consequential action was taken without confirmation;
- temporary browser tabs or artifacts created for the task were cleaned up when appropriate.
