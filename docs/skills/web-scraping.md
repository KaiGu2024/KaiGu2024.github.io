# Agent Skill: Web Scraping

Toolset and patterns for collecting data from the web and social media platforms.

---

## Format Preference

Always prefer structured endpoints over HTML parsing:

```
JSON API  >  XML feed  >  CSV download  >  HTML (BeautifulSoup / Playwright)
```

JSON and XML are stable contracts; HTML structure breaks silently when sites update. Only fall back to HTML parsing when no API or structured endpoint exists.

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
Use [Firecrawl](https://firecrawl.dev) to scrape any URL and return clean Markdown:
```python
from firecrawl import FirecrawlApp
app = FirecrawlApp(api_key="...")
result = app.scrape_url("https://example.com")
markdown = result["markdown"]
```

**Open-source alternative**: [`defuddle`](https://github.com/kepano/defuddle) (TypeScript) — extracts
main article content from any page and converts to Markdown without an API key.

**Step 2 — Extract JSON via LLM**
Pass the Markdown to OpenAI with a schema prompt:
```python
import openai, json
response = openai.chat.completions.create(
    model="gpt-4o-mini",
    messages=[{
        "role": "user",
        "content": f"Extract a JSON object with fields {{title, author, date, summary}} from:\n\n{markdown}"
    }],
    response_format={"type": "json_object"}
)
data = json.loads(response.choices[0].message.content)
```

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

## Report

After completing a scraping task, output a brief report:

**Task:** One sentence — what was scraped and from where.  
**Source:** URL pattern or platform used.  
**Volume:** N records / pages fetched; date range if applicable.  
**Format:** How the data was saved (CSV, JSON, Parquet) and where.  
**Notes:** Any auth errors, rate-limit hits, missing fields, or coverage gaps requiring human review.
