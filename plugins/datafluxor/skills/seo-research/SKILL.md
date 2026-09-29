---
name: seo-research
description: Use DataFluxor MCP for an explicitly requested Google SERP check, bounded site crawl, page metadata extraction, suggestions, competitor gap, or retained scraper run.
---

# DataFluxor SEO research

Use this skill when the user requests fresh search or web evidence that DataFluxor can collect. The DataFluxor MCP server supplies the tools; this skill helps select and interpret them. Do not claim that a tool ran until its result is returned.

## Before a call

- Use the authenticated `datafluxor` MCP connection. Let the user complete OAuth and choose the intended workspace. Never ask for or put an API key, password, or token in a prompt or plugin file.
- Check the available tool list. Access depends on the user's plan, workspace role, and credits. A missing tool is unavailable; do not work around its entitlement.
- State the intended query, URL or domain set, scope, and relevant limits before a credit-consuming run. For broad or repeated collection, ask the user to choose a bound. Do not silently retry a failed paid call with a new idempotency key.
- Browser-rendered Google SERP collection is currently verified for Great Britain only. If the user asks for another country's local organic results, explain that location accuracy is not established and ask whether to proceed with an explicitly qualified result.

## Choose a tool

- `google_serp_scrape`: organic search observations for one keyword. Supply `country: "GB"` for a verified Great Britain request. Distinguish a cached `standard` result from a `fresh` acquisition using the returned timestamps and cache age.
- `google_suggest_harvest`: autocomplete ideas from a seed. Avoid recursive expansion unless requested.
- `google_index_check`: a Google `site:` heuristic, not Search Console proof of indexing.
- `html_metadata_extractor`: page metadata and headings for a URL; it does not extract JSON-LD/schema.
- `site_seo_crawler`: bounded technical audit. Set a reasonable `max_pages` and report pages that failed separately from pages without issues.
- `competitor_gap_extractor`: compare only the domains and keywords the user supplied. It does not discover a competitor's full keyword universe.
- `fut_player_prices`, `fut_card_search`, `fut_card_details`, `fut_price_history`: EA FC Ultimate Team market data, listed only when the workspace has FUT access. Always identify a card by its exact EA item id and version; never merge prices of different card versions. Each call states its credit cost in its description.
- `serp_volatility_sensor` and `ai_overview_visibility_tracker`: use when the user asks for their specific signals; do not describe AI Overview observations as ChatGPT visibility.

The synchronous scraper tools return temporary results. For work the user wants to retain, use `scraper_run_create` with the chosen `organization` or verified `project` scope and an idempotency key, then use `scraper_run_get` or `scraper_run_list` to inspect status. Preserve the same key and inputs if recovering a lost response. `scraper_run_cancel` is only for an explicit cancellation request; poll the run to a terminal state. Never assume that cancellation refunded credits.

## Report the result

Give the actual observations with source URLs, requested location, freshness or collection time when returned, and material gaps or failures. Treat an empty or incomplete result as such. Include confirmed credit cost if the server reports it; `unknown` is not zero. Do not present a successful MCP handshake, HTTP response, or started run as completed research.
