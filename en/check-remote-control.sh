#!/usr/bin/env bash
# check-remote-control.sh — checks the requirements for Claude Code's Remote Control.
# Prints no secrets: for variables it only shows the name, never the value.
set -euo pipefail
failures=0
bad() { echo "✗ $1"; failures=$((failures + 1)); }

command -v claude >/dev/null || { echo "✗ claude is not installed"; exit 1; }
echo "Version: $(claude --version)"

status=$(claude auth status 2>/dev/null || true)
method=$(sed -n 's/.*"authMethod": *"\([^"]*\)".*/\1/p' <<<"$status")
plan=$(sed -n 's/.*"subscriptionType": *"\([^"]*\)".*/\1/p' <<<"$status")
if [ "$method" = "claude.ai" ]; then echo "✓ claude.ai sign-in (plan: ${plan:-unknown})"
else bad "A claude.ai sign-in is required, not an API key (current method: ${method:-not signed in}). Run: claude auth login"; fi
# shortcut: only detects the free plan; any other plan name is assumed to be fine
[ "$plan" != free ] || bad "The free plan doesn't include Remote Control (Pro, Max, Ultra, Team or Enterprise is required)"

for v in ANTHROPIC_API_KEY ANTHROPIC_AUTH_TOKEN CLAUDE_CODE_OAUTH_TOKEN CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC DISABLE_GROWTHBOOK; do
  [ -z "${!v:-}" ] || bad "The variable $v is set and blocks Remote Control: remove it from your environment"
done
if [ -n "${ANTHROPIC_BASE_URL:-}" ] && [[ $ANTHROPIC_BASE_URL != https://api.anthropic.com* ]]; then
  bad "ANTHROPIC_BASE_URL points to another server (proxy, gateway, Ollama or OpenRouter): Remote Control doesn't work that way"
fi

if [ "$failures" -eq 0 ]; then
  echo "✓ All set. In a folder without secrets: claude remote-control --name \"My project\" (space bar = QR)"
else
  echo "$failures problem(s). More help: claude doctor"; exit 1
fi
