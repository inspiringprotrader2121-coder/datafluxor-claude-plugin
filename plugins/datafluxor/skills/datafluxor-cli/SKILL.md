---
name: datafluxor-cli
description: Use the datafluxor command-line tool for live Google SERP results, Google autocomplete suggestions, bounded technical SEO site crawls, page metadata and link extraction, index checks, competitor keyword gaps, SERP volatility, AI Overview visibility and EA SPORTS FC (FUT) market prices. Use it when the user asks for search, SEO or web evidence and a shell is available. Always run it with --json.
---

# DataFluxor CLI

The `datafluxor` CLI calls DataFluxor's authenticated tools (the same tools as the `datafluxor` MCP server) from a shell and prints JSON. Use it when the user asks for search or web evidence: a Google SERP check, autocomplete ideas, a bounded site crawl, page metadata, index checks, a competitor gap or FUT prices. If a `datafluxor` MCP connection is already available in this session, its tools are the same; use whichever is at hand. Never claim a tool ran until its result is returned.

## Before the first call

1. `datafluxor version --json` checks that the CLI is installed. If it is not, ask the user before installing software, then run `curl -fsSL https://datafluxor.com/install.sh | sh` (macOS, Linux) or `irm https://datafluxor.com/install.ps1 | iex` (Windows PowerShell). The installers verify the SHA-256 checksum. If `datafluxor` is not on PATH afterwards, use the full path the installer printed.
2. `datafluxor whoami --json` checks the credential without spending credits. Exit code 3 means nobody is signed in:
   - A person at the terminal runs `datafluxor login` (browser sign-in, tokens refresh automatically) or `datafluxor init`.
   - Agents, CI and containers use an API key from the environment: `export DATAFLUXOR_API_KEY=...`; every command picks it up. Keys are created at https://datafluxor.com/app/access.
   - Never ask for a key in chat, echo it, write it into a file, or pass it as `--api-key` when the environment variable works. Do not retry authentication in a loop.
3. `datafluxor tools --json` lists the tools this credential's plan includes; `datafluxor tools <tool> --json` shows one tool's input schema. Both are free. A tool that is not listed is not in the plan; do not work around that.

## Commands

Always pass `--json`. Output is JSON anyway when stdout is not a terminal, and progress messages go to stderr.

| Task | Command | Tool |
| --- | --- | --- |
| Google organic results for one query | `datafluxor serp "<query>" --country GB [--language en] [--depth 10] [--freshness standard\|fresh] --json` | `google_serp_scrape` |
| Autocomplete ideas from a seed | `datafluxor suggest "<seed>" [--country GB] [--language en] [--recursive] --json` | `google_suggest_harvest` |
| Technical SEO crawl of a site | `datafluxor crawl <url> [--max-pages 30] --json` | `site_seo_crawler` |
| Title, meta, canonical, Open Graph, headings and links of one page | `datafluxor extract <url> --json` | `html_metadata_extractor` |
| FC Ultimate Team prices by EA item id | `datafluxor fut prices <ea_id> [<ea_id> ...] [--platform ps\|pc\|xbox] --json` | `fut_player_prices` |
| Any other tool | `datafluxor call <tool> key=value ... [--input args.json\|-] --json` | any |

Other tools reached through `call`: `google_index_check` (a Google `site:` heuristic, not Search Console proof), `competitor_gap_extractor` (only the domains and keywords given), `serp_volatility_sensor`, `ai_overview_visibility_tracker` (Google AI Overviews, not ChatGPT), and retained runs with `scraper_run_create` / `scraper_run_get` / `scraper_run_list` / `scraper_run_cancel`.

- `call` parses each value as JSON when it is valid JSON, otherwise as a plain string; fields the schema types as strings keep their literal text. A repeated key builds an array: `datafluxor call google_index_check urls=https://a.example urls=https://b.example --json`. Pass nested values as JSON (`competitor_domains='["rival.com"]'`) or pipe a JSON object with `--input -`.
- `serp` takes a two-letter `--country` code and a Google `--language`. An unsupported market exits 2 with `COUNTRY_UNSUPPORTED` or `LANGUAGE_UNSUPPORTED`; the list is at https://datafluxor.com/api/v1/serp/markets.
- `fut prices` takes 1-100 EA item ids; each card version has its own id. Prices are delayed observations of the lowest buy-now listing with `observed_at`, not a live auction feed. Ids that cannot be mapped yet come back as unresolved and are not billed. It needs the FUT Data plan or FUT enabled for the workspace.
- For work to keep or recover later, use `datafluxor call scraper_run_create ... idempotency_key=<key> --json`, then `datafluxor call scraper_run_get run_id=<id> --json`.

## JSON results

- Success: `{"ok": true, "tool": ..., "arguments": ..., "credit_cost": N|null, "data": {...}}`. `arguments` are the normalized arguments the server used.
- Failure: `{"ok": false, "error": {"type", "code", "message", "hint"}, "exit_code": N}`. Read `hint`; it says what to do next.

## Credits, time and retries

- Most tools spend plan credits; `tools`, `whoami` and `--help` never do. Report `credit_cost`; `null` means the server did not confirm a cost, not zero.
- SERP: 5 credits per 10-result page fetched live, 1 per page served from cache. `--freshness standard` (default) may reuse a copy up to 24 hours old; `fresh` always fetches live. Crawls cost 1 credit per 10 pages crawled.
- Before a large call (high `--depth`, big crawls, many URLs or ids, `--recursive`, `fresh` in bulk), state the scope and get the user's agreement.
- A live SERP can take 30-120 seconds. Requests time out after 5 minutes by default (`--timeout 10m` raises it). If a SERP call times out, repeat the identical command once: the server finishes the search and returns it from cache without charging twice.
- Never retry a paid call automatically with changed arguments or a new idempotency key.

| Exit code | Meaning | What to do |
| --- | --- | --- |
| 0 | ok | Use the result. |
| 1 | tool, API or network error | Report it; do not retry automatically, except the SERP timeout case above. |
| 2 | invalid command line or arguments | Fix the arguments with `datafluxor tools <tool> --json`. |
| 3 | authentication required, rejected or expired | Ask the user to run `datafluxor login` or set `DATAFLUXOR_API_KEY`. |
| 4 | insufficient credits | Stop and tell the user; plans and credits are at https://datafluxor.com/app/access. |

## Report the result

Present what was actually returned: URLs, positions, titles, collection time or cache age, and the country and language requested. Say when a SERP came from cache and how old it is. Report failures, unresolved ids and gaps as such; never fill them in.
