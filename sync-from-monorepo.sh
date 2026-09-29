#!/usr/bin/env bash
# Copies the publishable plugin files from the private DataFluxor monorepo into
# this public repo layout. Run from the root of the public repo checkout:
#   MONOREPO=/path/to/datafluxor ./sync-from-monorepo.sh
# Deliberately excluded: .app.json (private ChatGPT developer connection id),
# evals.md (internal test notes) and the Codex manifest.
set -euo pipefail

: "${MONOREPO:?set MONOREPO to the DataFluxor monorepo checkout}"
src="$MONOREPO/plugins/datafluxor"
dst="./plugins/datafluxor"

rm -rf "$dst"
mkdir -p "$dst/.claude-plugin" "$dst/skills" "$dst/assets"
cp "$src/.claude-plugin/plugin.json" "$dst/.claude-plugin/plugin.json"
cp "$src/.mcp.json" "$dst/.mcp.json"
cp -R "$src/skills/." "$dst/skills/"
cp "$src/assets/logo.png" "$dst/assets/logo.png"
cp "$MONOREPO/docs/submission/public-plugin-repo/plugin-README.md" "$dst/README.md"
echo "synced; now run: claude plugin validate . && claude plugin validate $dst"
