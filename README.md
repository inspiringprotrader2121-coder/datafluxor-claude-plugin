# DataFluxor for Claude Code

Google SERP, SEO and AI-search visibility research from Claude Code, through the hosted DataFluxor MCP server at `https://datafluxor.com/mcp`. The plugin contains no code, no API key and no credentials: it registers the remote server and adds an `seo-research` skill. You sign in to your own DataFluxor workspace with OAuth the first time a tool is used.

## Install

In Claude Code:

```
/plugin marketplace add inspiringprotrader2121-coder/datafluxor-claude-plugin
/plugin install datafluxor@datafluxor
```

Or from a shell:

```
claude plugin marketplace add inspiringprotrader2121-coder/datafluxor-claude-plugin
claude plugin install datafluxor@datafluxor
```

Then run `/mcp`, choose `datafluxor` and select Authenticate. A DataFluxor plan with credits is required (https://datafluxor.com/pricing); every tool call states its credit cost.

## What you get

- The `datafluxor` MCP server: Google SERP results, autocomplete suggestions, index checks, a bounded technical SEO crawler, page metadata extraction, SERP volatility, competitor keyword gap, AI Overview visibility, and retained background runs.
- The `datafluxor:seo-research` skill for choosing tools and reporting results accurately.

## Links

- Product and setup for other clients: https://datafluxor.com/mcp-for-seo
- Privacy policy: https://datafluxor.com/privacy
- Terms: https://datafluxor.com/terms
- Support: support@datafluxor.com

## Maintainers

The `plugins/datafluxor/` folder is generated from the private DataFluxor monorepo by `sync-from-monorepo.sh`; do not edit it here. Validate before every push:

```
claude plugin validate .
claude plugin validate ./plugins/datafluxor
```
