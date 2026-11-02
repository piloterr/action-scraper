<p align="center">
  <a href="https://www.piloterr.com"><img src="images/banner.png" alt="Action Scraper API by Piloterr – scrape Action data as JSON" width="100%"></a>
</p>

# Action Scraper API

[![Discord](https://img.shields.io/badge/Discord-Join%20the%20community-5865F2?logo=discord&logoColor=white)](https://discord.gg/CFj3ph8aHU) [![Get API key](https://img.shields.io/badge/Piloterr-Get%20a%20free%20API%20key-111827)](https://app.piloterr.com) [![API docs](https://img.shields.io/badge/Docs-OpenAPI-0EA5E9)](https://app.piloterr.com/openapi) [![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

The **Piloterr Action Scraper API** lets you extract public data from Action as **clean, structured JSON** — no proxies, headless browsers or HTML parsing to maintain. Endpoints available in production:

- **Action Product API** — Action Product API: fetch full product page data from a product ID or URL on Action.com.
- **Action Search API** — Action Search API: search product listings by keyword or URL on Action.com across European locales.

Use it for price monitoring, assortment tracking, competitor analysis, product research or catalog enrichment.

| Endpoint | Path | Credits | What you get |
|---|---|---|---|
| [Action Product API](#action-product-api) | `/v2/action/product` | 2 | Action Product API |
| [Action Search API](#action-search-api) | `/v2/action/search` | 2 | Action Search API |

## Table of contents

- [How it works](#how-it-works)
- [Action Product API](#action-product-api)
- [Action Search API](#action-search-api)
- [Code examples in other languages](#code-examples-in-other-languages)
- [Practical use cases](#practical-use-cases)
- [Why Piloterr?](#why-piloterr)
- [FAQ](#faq)
- [Related scrapers](#related-scrapers)
- [Support](#support)

## How it works

1. **Create a free Piloterr account** and copy your API key from the [dashboard](https://app.piloterr.com).
2. **Send a `GET` (or `POST`) request** to `https://api.piloterr.com/v2/...` with the header `x-api-key: YOUR_API_KEY`.
3. **Receive structured JSON** — Piloterr handles rendering, proxies, retries and parsing.

```bash
export PILOTERR_API_KEY="your-api-key"
pip install requests        # Python
# TypeScript: Node.js 18+ (native fetch), run with `npx tsx file.ts`
```

> Every endpoint accepts both `GET` (query string) and `POST` (JSON body with the same fields).

## Action Product API

Action Product API: fetch full product page data from a product ID or URL on Action.com. Returns pricing, specs, images, breadcrumbs and availability via browser rendering.

`GET | POST https://api.piloterr.com/v2/action/product` · **2 credits per request** · [Full reference](https://app.piloterr.com/openapi)

### Request parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `query` | string | ✅ | Action product ID or full product URL. |
| `region` | string | — | Locale (`fr-fr`, `de-de`, `pt-pt`, …) or country code (`fr`, `de`, `pt`). Default: `fr-fr`. |
| `return_page_source` | boolean | — | When `true`, return the raw HTML page source as `{"result": "..."}` instead of structured JSON. Defaults to `false`. |

### Python example

```python
import json
import os
import requests

response = requests.get(
    "https://api.piloterr.com/v2/action/product",
    headers={"x-api-key": os.environ["PILOTERR_API_KEY"]},
    params={
        "query": "3216159",
    },
    timeout=120,
)
response.raise_for_status()
data = response.json()

print(json.dumps(data, indent=2, ensure_ascii=False)[:2000])
```

### TypeScript example

```typescript
type ActionProduct = {
  url?: string;
  price?: number;
  title?: string;
  images?: string[];
  locale?: string;
  currency?: string;
  in_stock?: boolean;
  image_url?: string;
  product_id?: string;
  breadcrumbs?: string[];
  description?: string;
  availability?: string;
  specifications?: {
    key?: string;
    value?: string;
  }[];
};

const params = new URLSearchParams({
  "query": "3216159",
});

const response = await fetch(`https://api.piloterr.com/v2/action/product?${params}`, {
  headers: { "x-api-key": process.env.PILOTERR_API_KEY! },
});
if (!response.ok) throw new Error(`Piloterr error ${response.status}: ${await response.text()}`);

const data = (await response.json()) as ActionProduct;

console.log(JSON.stringify(data, null, 2).slice(0, 2000));
```

<details>
<summary><b>POST variant</b></summary>

```http
POST https://api.piloterr.com/v2/action/product
x-api-key: YOUR_API_KEY
Content-Type: application/json

{"query": "3216159"}
```
</details>

### Output example

Example response from the API reference, abridged — real values depend on the page you scrape.

```json
{
  "url": "https://www.action.com/fr-fr/p/3216159/etagere/",
  "price": 39.95,
  "title": "Étagère",
  "images": [
    "https://asset.action.com/image/upload/3216159_8718964237609-110_01_lbhy6y",
    "https://asset.action.com/image/upload/3216159_8718964237593-110_01_eglur0"
  ],
  "locale": "fr-fr",
  "currency": "EUR",
  "in_stock": true,
  "image_url": "https://asset.action.com/image/upload/3216159_8718964237609-110_01_lbhy6y",
  "product_id": "3216159",
  "breadcrumbs": [
    "Habitat",
    "Meubles"
  ],
  "description": "Donnez un coup de jeune à votre salon avec cette étagère moderne. Les rayons ouverts sont parfaits pour vos plus belles décorations et pl…",
  "availability": "in_stock",
  "specifications": [
    {
      "key": "Couleur",
      "value": "Beige, Brun, Noir, Blanc"
    },
    {
      "key": "Matériau",
      "value": "Iron, Bois mdf, Melamine"
    }
  ]
}
```

### Response fields

| Field | Type | Description |
|---|---|---|
| `url` | string |  |
| `price` | number |  |
| `title` | string |  |
| `images` | string[] |  |
| `locale` | string |  |
| `currency` | string |  |
| `in_stock` | boolean |  |
| `image_url` | string |  |
| `product_id` | string |  |
| `breadcrumbs` | string[] |  |
| `description` | string |  |
| `availability` | string |  |
| `specifications[]` | object[] |  |
| `specifications[].key` | string |  |
| `specifications[].value` | string |  |

## Action Search API

Action Search API: search product listings by keyword or URL on Action.com across European locales. Returns prices, images, locale, currency and pagination via browser rendering.

`GET | POST https://api.piloterr.com/v2/action/search` · **2 credits per request** · [Full reference](https://app.piloterr.com/openapi)

### Request parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `query` | string | ✅ | Search keyword or full Action.com search URL. |
| `region` | string | — | Locale (`fr-fr`, `de-de`, `pt-pt`, …) or country code (`fr`, `de`, `pt`). Default: `fr-fr`. |
| `page` | number | — | 1-based page number (default: 1). |
| `return_page_source` | boolean | — | When `true`, return the raw HTML page source as `{"result": "..."}` instead of structured JSON. Defaults to `false`. |

### Python example

```python
import json
import os
import requests

response = requests.get(
    "https://api.piloterr.com/v2/action/search",
    headers={"x-api-key": os.environ["PILOTERR_API_KEY"]},
    params={
        "query": "meuble",
    },
    timeout=120,
)
response.raise_for_status()
data = response.json()

print(json.dumps(data, indent=2, ensure_ascii=False)[:2000])
```

### TypeScript example

```typescript
type ActionSearch = {
  results?: {
    url?: string;
    price?: number;
    title?: string;
    locale?: string;
    currency?: string;
    image_url?: string;
    product_id?: string;
  }[];
  pagination?: {
    next?: string;
    page?: number;
    per_page?: number;
    total_pages?: number;
    total_results?: number;
  };
};

const params = new URLSearchParams({
  "query": "meuble",
});

const response = await fetch(`https://api.piloterr.com/v2/action/search?${params}`, {
  headers: { "x-api-key": process.env.PILOTERR_API_KEY! },
});
if (!response.ok) throw new Error(`Piloterr error ${response.status}: ${await response.text()}`);

const data = (await response.json()) as ActionSearch;

console.log(JSON.stringify(data, null, 2).slice(0, 2000));
```

<details>
<summary><b>POST variant</b></summary>

```http
POST https://api.piloterr.com/v2/action/search
x-api-key: YOUR_API_KEY
Content-Type: application/json

{"query": "meuble"}
```
</details>

### Output example

Example response from the API reference, abridged — real values depend on the page you scrape.

```json
{
  "results": [
    {
      "url": "https://www.action.com/fr-fr/p/3220594/meuble-d-entree/",
      "price": 32.95,
      "title": "Meuble d'entrée",
      "locale": "fr-fr",
      "currency": "EUR",
      "image_url": "https://asset.action.com/image/upload/3220594_8718964261123-110_01_l7lvqj",
      "product_id": "3220594"
    },
    {
      "url": "https://www.action.com/fr-fr/p/3216159/etagere/",
      "price": 39.95,
      "title": "Étagère",
      "locale": "fr-fr",
      "currency": "EUR",
      "image_url": "https://asset.action.com/image/upload/3216159_8718964237609-110_01_lbhy6y",
      "product_id": "3216159"
    }
  ],
  "pagination": {
    "next": "https://www.action.com/fr-fr/search/?q=meuble&page=2#product-grid",
    "page": 1,
    "per_page": 24,
    "total_pages": 8,
    "total_results": 185
  }
}
```

### Response fields

| Field | Type | Description |
|---|---|---|
| `results[]` | object[] |  |
| `results[].url` | string |  |
| `results[].price` | number |  |
| `results[].title` | string |  |
| `results[].locale` | string |  |
| `results[].currency` | string |  |
| `results[].image_url` | string |  |
| `results[].product_id` | string |  |
| `pagination` | object |  |
| `pagination.next` | string |  |
| `pagination.page` | integer |  |
| `pagination.per_page` | integer |  |
| `pagination.total_pages` | integer |  |
| `pagination.total_results` | integer |  |

## Code examples in other languages

Ready-to-run examples live in the [`examples/`](examples) folder. Each one reads your key from the `PILOTERR_API_KEY` environment variable.

| Language | Product | Search |
|---|---|---|
| cURL (Bash) | [`product`](examples/curl/product.sh) | [`search`](examples/curl/search.sh) |
| PHP | [`product`](examples/php/product.php) | [`search`](examples/php/search.php) |
| C# | [`product`](examples/csharp/Product.cs) | [`search`](examples/csharp/Search.cs) |
| Go | [`product`](examples/go/product.go) | [`search`](examples/go/search.go) |
| Java | [`product`](examples/java/ProductExample.java) | [`search`](examples/java/SearchExample.java) |
| Ruby | [`product`](examples/ruby/product.rb) | [`search`](examples/ruby/search.rb) |
| Node.js | [`product`](examples/nodejs/product.mjs) | [`search`](examples/nodejs/search.mjs) |

## Practical use cases

- **Price monitoring** — Track prices, promotions and availability over time to react to competitors.
- **Assortment & catalog tracking** — Follow new products, delisted items and category changes.
- **Competitor analysis** — Benchmark ranges, brands and positioning across retailers.
- **Product research** — Spot best-sellers and trends from search results.
- **Catalog enrichment** — Pull titles, images and attributes into your PIM or marketplace listings.

## Why Piloterr?

- **No infrastructure** — no proxies, headless browsers or CAPTCHA solving to run yourself.
- **Structured JSON** — stable, documented fields instead of brittle HTML selectors.
- **Pay per request** — transparent credit cost per endpoint, failed requests are retried for you.
- **One API key, hundreds of sources** — Action plus many other e-commerce, search and company data endpoints in the [Piloterr library](https://www.piloterr.com/library).
- **Any language** — plain HTTPS + JSON, with examples for Python, TypeScript, cURL, PHP, C#, Go, Java, Ruby and Node.js.

## FAQ

### Is it legal to scrape Action?

Collecting publicly available data is generally allowed in many jurisdictions, but rules depend on your country, the data you collect and how you use it. Avoid personal data unless you have a lawful basis, respect the website's terms where they apply, and get legal advice for your specific use case. This is not legal advice.

### Do I need proxies or a headless browser?

No. Piloterr handles rendering, proxy rotation and retries on its side. You only send an HTTPS request with your `x-api-key` header and receive JSON.

### How much does a request cost?

Credits per call: `/v2/action/product` **2**, `/v2/action/search` **2**. See the [Piloterr website](https://www.piloterr.com) for plans.

### What data does the Action API return?

Each endpoint returns structured JSON: **Action Product** — `url`, `price`, `title`, `images`, `locale`, `currency`; **Action Search** — `results[]`, `results[].url`, `results[].price`, `results[].title`, `results[].locale`, `results[].currency`.

### How do I paginate Action results?

Use the `page` parameter and keep requesting while the response indicates more results.

### Can I target a specific country or language?

Yes, use `region` — see the parameter tables above for accepted values.

### Can I get the raw HTML instead of JSON?

Yes. Set `return_page_source=true` and the response becomes `{"result": "..."}` with the page source.

### Which languages are supported?

Any language that can make an HTTP request. This README shows Python and TypeScript; the [`examples/`](examples) folder contains cURL, PHP, C#, Go, Java, Ruby and Node.js.

## Related scrapers

- [About You Scraper API](https://github.com/piloterr/aboutyou-scraper)
- [Aldi Scraper API](https://github.com/piloterr/aldi-scraper)
- [Alibaba Scraper API](https://github.com/piloterr/alibaba-scraper)
- [AliExpress Scraper API](https://github.com/piloterr/aliexpress-scraper)
- [Allegro Scraper API](https://github.com/piloterr/allegro-scraper)
- [Amazon Scraper API](https://github.com/piloterr/amazon-scraper)
- [All Piloterr scrapers on GitHub](https://github.com/piloterr)

## Support

- 💬 Join the [Piloterr Discord](https://discord.gg/CFj3ph8aHU) to ask questions and share what you build.
- 📚 Browse the [API reference (OpenAPI)](https://app.piloterr.com/openapi) and the [Piloterr library](https://www.piloterr.com/library).
- 🔑 [Get your API key](https://app.piloterr.com).

---

<p align="center">
  <a href="https://www.piloterr.com">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="images/logo-dark.svg">
      <img src="images/logo.svg" alt="Piloterr" height="32">
    </picture>
  </a>
  <br>
  <sub>Built by <a href="https://www.piloterr.com">Piloterr</a> — web scraping APIs for e-commerce, search, real estate and more, one API key.</sub>
</p>

<sub>Action is a trademark of its respective owner. This repository is not affiliated with or endorsed by Action. Examples are released under the MIT license.</sub>
