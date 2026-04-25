#!/usr/bin/env bash
# SessionStart hook: inject date, recent CHANGELOG, and research feed freshness.
# Output format: Claude Code hook v2 — we emit a JSON blob with hookSpecificOutput.additionalContext.
set -euo pipefail

VAULT="${CLAUDE_PROJECT_DIR:-$(pwd)}"
TODAY="$(date '+%Y-%m-%d %H:%M %Z')"

CHANGELOG_TAIL=""
if [[ -f "$VAULT/CHANGELOG.md" ]]; then
  CHANGELOG_TAIL="$(tail -n 5 "$VAULT/CHANGELOG.md" 2>/dev/null || echo "(empty)")"
else
  CHANGELOG_TAIL="(CHANGELOG.md not yet created — Phase 2 artifact)"
fi

FEED_LINE=""
FEED_FILE="$VAULT/00_Idea_Inbox/Automated_Research_Feed.md"
if [[ -f "$FEED_FILE" ]]; then
  FEED_LINE="$(grep -m1 '업데이트' "$FEED_FILE" 2>/dev/null || echo "(no update marker found)")"
else
  FEED_LINE="(feed file missing)"
fi

# Emit context. Escape via jq to avoid JSON injection from CHANGELOG content.
if command -v jq >/dev/null 2>&1; then
  jq -n \
    --arg today "$TODAY" \
    --arg changelog "$CHANGELOG_TAIL" \
    --arg feed "$FEED_LINE" \
    '{
      "hookSpecificOutput": {
        "hookEventName": "SessionStart",
        "additionalContext": ("## Session start context\n\n- Today: " + $today + "\n- Research feed latest: " + $feed + "\n- CHANGELOG tail (last 5 lines):\n```\n" + $changelog + "\n```\n")
      }
    }'
else
  # Fallback without jq: emit a minimal, hand-escaped payload (CHANGELOG omitted to avoid injection risk).
  printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"Today: %s\\nFeed: (jq not installed; CHANGELOG omitted)"}}' "$TODAY"
fi
