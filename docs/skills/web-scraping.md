# Agent Skill: Web Scraping

Toolset and patterns for collecting data from the web and social media platforms.

---

## Format Preference

Prefer structured, stable contracts over layout-dependent formats:

```
JSON API  >  XML feed  >  CSV download*  >  HTML (BeautifulSoup / Playwright)
```

JSON and XML are machine contracts — they break loudly when the schema changes. HTML breaks silently when a site redesigns. Only fall back to HTML parsing when no structured endpoint exists.

*CSV download is convenient for small, one-shot exports but is not always better than HTML: if the CSV is paginated, requires auth per chunk, or exceeds memory, a streaming JSON API or direct HTML parse may be preferable. Choose based on stability and size, not format alone.

---

## Raw Web Page Fetching (`requests`)

```python
import requests, time

SESSION = requests.Session()
SESSION.headers.update({
    "User-Agent": "Mozilla/5.0 (compatible; ResearchBot/1.0; +mailto:you@example.com)",
    "Accept":     "application/json, text/html;q=0.9",
    "Accept-Language": "en-US,en;q=0.5",
})

def fetch(url, params=None, auth=None, retries=3, backoff=2):
    for attempt in range(retries):
        try:
            r = SESSION.get(url, params=params, auth=auth, timeout=15)
            r.raise_for_status()
            return r
        except requests.HTTPError as e:
            if r.status_code == 429:            # rate-limited
                time.sleep(backoff ** attempt)
            elif r.status_code in (401, 403):
                raise PermissionError(f"Auth failed: {url}") from e
            else:
                raise
    raise RuntimeError(f"Failed after {retries} retries: {url}")
```

### Authentication patterns

```python
# Bearer token (OAuth2 / API key as header)
SESSION.headers["Authorization"] = f"Bearer {API_TOKEN}"

# API key as query param
r = SESSION.get(url, params={"api_key": KEY, "q": query})

# Basic auth
from requests.auth import HTTPBasicAuth
r = SESSION.get(url, auth=HTTPBasicAuth("user", "pass"))

# Session cookie (after login)
SESSION.post("https://site.com/login", data={"user": U, "pass": P})
# SESSION now carries the auth cookie automatically
```

### Rate limiting

```python
import time
from itertools import islice

def rate_limited_fetch(urls, rps=2):
    interval = 1 / rps
    for url in urls:
        yield fetch(url)
        time.sleep(interval)

# Or use tenacity for exponential backoff
from tenacity import retry, wait_exponential, stop_after_attempt
@retry(wait=wait_exponential(multiplier=1, min=2, max=30),
       stop=stop_after_attempt(5))
def robust_fetch(url):
    return SESSION.get(url, timeout=15)
```

### Parallel Fetching

Web scraping is I/O-bound — the bottleneck is waiting for responses, not CPU. Use threads or async, not processes.

**ThreadPoolExecutor** (simplest, drop-in replacement for a loop):

```python
from concurrent.futures import ThreadPoolExecutor, as_completed

def fetch_safe(url):
    try:
        return url, fetch(url)
    except Exception as e:
        return url, e

urls = [...]
results = {}
with ThreadPoolExecutor(max_workers=10) as pool:
    futures = {pool.submit(fetch_safe, url): url for url in urls}
    for future in as_completed(futures):
        url, result = future.result()
        results[url] = result
```

**asyncio + aiohttp** (higher throughput, better for 1000+ URLs):

```python
import asyncio, aiohttp

async def fetch_async(session, url, semaphore):
    async with semaphore:
        async with session.get(url, timeout=aiohttp.ClientTimeout(total=15)) as r:
            r.raise_for_status()
            return url, await r.json()

async def fetch_all(urls, rps=5):
    semaphore = asyncio.Semaphore(rps)
    async with aiohttp.ClientSession(headers=SESSION.headers) as session:
        tasks = [fetch_async(session, url, semaphore) for url in urls]
        return await asyncio.gather(*tasks, return_exceptions=True)

results = asyncio.run(fetch_all(urls, rps=5))
```

**Rule of thumb:** `ThreadPoolExecutor(max_workers=10–20)` for most scraping jobs. Switch to `asyncio` when jobs exceed ~500 URLs or when latency variance is high (some requests blocking others in a thread pool).

### Trial Run Before Full Collection

Always test on 5–10 URLs before scaling up:

```python
import time

sample = urls[:10]
trial = []
for url in sample:
    r = fetch(url)
    trial.append({"url": url, "status": r.status_code, "size": len(r.content)})
    time.sleep(1 / rps)

for row in trial:
    print(row)
```

Check before proceeding:
- All status codes are 200 (or expected redirects)
- Response size is plausible — a login wall or CAPTCHA returns a very small, uniform page
- Parsed fields are present and correctly typed
- Estimated total time: `total_urls / rps / 60` minutes

Only run the full collection after the trial passes all four checks.

### Parsing response formats

```python
# JSON
data = r.json()

# XML
import xml.etree.ElementTree as ET
root = ET.fromstring(r.text)
items = root.findall(".//item")

# HTML (last resort)
from bs4 import BeautifulSoup
soup = BeautifulSoup(r.text, "lxml")
rows = soup.select("table.data-table tr")
```

---

## Social Media — ScrapeCreators

Use [ScrapeCreators](https://scrapecreators.com) for social media APIs:
- Unified APIs for Twitter/X, Instagram, TikTok, LinkedIn
- Manages authentication, rate limits, and anti-bot measures
- REST API calls — no browser automation or account credentials needed

---

## App & Platform Data — Apify

Use [Apify](https://apify.com) for non-social-media app data:
- **Amazon**: `apify/amazon-crawler` — products, reviews, prices, search results
- **Google Maps**: `compass/google-maps-scraper` — business listings, ratings, reviews
- Cloud-hosted actors handle JavaScript rendering and captchas
- Pay-per-use; free tier available

---

## Web → Markdown → JSON Pipeline

Convert unstructured web pages into structured data in two steps:

**Step 1 — Crawl to Markdown**

Two options:

- [**Firecrawl**](https://firecrawl.dev) — paid SaaS (free tier: 500 credits/month). Handles JS rendering, auth, and pagination automatically.
```python
from firecrawl import FirecrawlApp
app = FirecrawlApp(api_key="...")
result = app.scrape_url("https://example.com")
markdown = result["markdown"]
```

- [**MarkItDown**](https://github.com/microsoft/markitdown) — free, open-source (Microsoft, MIT). Runs locally, no API key. Best for static pages and documents (HTML, PDF, DOCX, XLSX).
```python
from markitdown import MarkItDown
md = MarkItDown()
result = md.convert("https://example.com")
print(result.text_content)
```

- [**defuddle**](https://github.com/kepano/defuddle) — free, open-source (TypeScript). Extracts main article content from any page, strips boilerplate.

**Step 2 — Extract JSON via LLM (schema-constrained)**

Use Pydantic structured outputs — eliminates invalid or missing fields entirely:

```python
from pydantic import BaseModel
from openai import OpenAI

class Article(BaseModel):
    title: str
    author: str | None
    date: str | None
    summary: str

client = OpenAI()
resp = client.beta.chat.completions.parse(
    model="gpt-4o-mini",
    messages=[{"role": "user", "content": prompt}],
    response_format=Article,
)
data = resp.choices[0].message.parsed   # typed Article object, not raw JSON
```

**Prompt structure for reliable extraction** (three research-backed rules):

1. **Schema first** — "lost in the middle" causes 30%+ accuracy drops for instructions buried mid-prompt (Liu et al., TACL 2024). Put field definitions before the content block.
2. **XML tags** — wrap instructions and content in separate tags; Claude was trained on XML structure.
3. **Repeat schema after content** — prompt repetition wins 47/70 benchmark-model combinations with zero losses (Google Research, 2025).

```
<instructions>
Extract these fields from the page below.
Fields: title (str), author (str or null), date (ISO 8601 or null), summary (1–2 sentences).
If a field is absent, return null — do not guess.
</instructions>

<content>
{markdown}
</content>

Fields to extract: title, author, date, summary.
```

**Batch size** — when extracting from multiple pages in one call, cap at 15–25 items. Naive batching at 64 drops accuracy from 90.6% to 72.8% (BatchPrompt, ICLR 2024).

---

## YouTube — yt-dlp + defuddle

**yt-dlp** downloads video, audio, subtitles, and metadata:
```bash
# Full video + metadata JSON
yt-dlp --write-info-json URL

# Subtitles only (no video download)
yt-dlp --write-subs --write-auto-subs --skip-download URL

# Audio only (mp3)
yt-dlp -x --audio-format mp3 URL

# Channel: all videos metadata
yt-dlp --flat-playlist --print-json "https://www.youtube.com/@channel"
```

**defuddle** can complement yt-dlp by extracting transcript/description text from YouTube page HTML.

GitHub: [yt-dlp/yt-dlp](https://github.com/yt-dlp/yt-dlp)

---

## Reddit — Native JSON Endpoint

No authentication required for public content. Append `.json` to any Reddit URL:

```
https://www.reddit.com/r/{subreddit}.json?limit=100&t=all
https://www.reddit.com/r/{subreddit}/comments/{post_id}.json
https://www.reddit.com/user/{username}.json
https://www.reddit.com/r/{subreddit}/search.json?q={query}&restrict_sr=1
```

**Pagination**: use `?after={fullname}` where `fullname` is the `t3_xxx` id from the last result.

**Rate limit**: set `User-Agent: YourBotName/1.0` header and stay under ~60 req/min.

```python
import requests, time

def fetch_subreddit(sub, limit=500):
    posts, after = [], None
    headers = {"User-Agent": "ResearchBot/1.0"}
    while len(posts) < limit:
        url = f"https://www.reddit.com/r/{sub}.json?limit=100"
        if after:
            url += f"&after={after}"
        data = requests.get(url, headers=headers).json()["data"]
        posts += data["children"]
        after = data.get("after")
        if not after:
            break
        time.sleep(1)
    return posts
```

---

## Twitter/X — twscrape

Requires Twitter account credentials:
```python
import asyncio
from twscrape import API

async def main():
    api = API()
    await api.pool.add_account("username", "password", "email", "email_password")
    await api.pool.login_all()

    async for tweet in api.search("query lang:en", limit=200):
        print(tweet.id, tweet.rawContent)

    async for tweet in api.user_tweets(user_id, limit=100):
        print(tweet.rawContent)

asyncio.run(main())
```

---

## Responses API with `web_search` (One-off Queries)

For small-scale research lookups — a few pages, no bulk collection — the OpenAI Responses API lets the model handle the fetch itself, skipping the requests+parse pipeline entirely:

```python
from openai import OpenAI

client = OpenAI()
resp = client.responses.create(
    model="gpt-4o",
    tools=[{"type": "web_search_preview"}],
    input="Fetch example.com and extract: site name, main product, pricing model.",
)
print(resp.output_text)
```

**Trade-offs vs. requests + parse:**

| | Responses API | requests + parse |
|---|---|---|
| Setup | Zero — model fetches | Session, headers, retries |
| Auth/rate control | None | Full control |
| Cost | Per search call | Compute only |
| Scale | One-off queries | Bulk collection |
| JS rendering | Handled automatically | Needs Playwright |

Use Responses API for exploratory lookups and quick checks. Use requests for any collection exceeding ~20 pages.

---

## Report

See [Report format](report.md).

**Definition (measure):** N records / pages fetched; coverage % of target universe (if known); date range; wall-clock scraping time; output file and format.  
**Analyses:** Source URL(s) and endpoint type (JSON API / XML / HTML); auth method; rate-limit handling applied; HTTP status breakdown (e.g., 200 × 1,842 · 404 × 12 · 429 × 3).  
**Takeaway:** Data quality verdict; error diagnosis for any non-200 responses — e.g., 401/403 = auth required or IP blocked, 404 = URL pattern changed or content removed, 429 = rate limit hit, 5xx = server-side failure. Flag URLs that returned errors for manual review.
