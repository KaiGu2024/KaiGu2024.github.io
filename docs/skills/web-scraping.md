# Agent Skill: Web Scraping

Toolset and patterns for collecting data from the web and social media platforms.

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

**defuddle** can complement yt-dlp by extracting transcript/description text from YouTube page HTML.

GitHub: [yt-dlp/yt-dlp](https://github.com/yt-dlp/yt-dlp)

---

## Reddit — Native JSON Endpoint

No authentication required for public content. Append `.json` to any Reddit URL:

```
# Subreddit top posts
https://www.reddit.com/r/{subreddit}.json?limit=100&t=all

# Post + comments thread
https://www.reddit.com/r/{subreddit}/comments/{post_id}.json

# User profile posts
https://www.reddit.com/user/{username}.json

# Search within subreddit
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

GitHub: [vladkens/twscrape](https://github.com/vladkens/twscrape)
