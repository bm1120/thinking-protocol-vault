#!/usr/bin/env bash
# _template/tests/test_sync_to_plugin.sh
# Builds a fake source/plugin pair, runs sync, asserts inclusions/exclusions.
set -euo pipefail

WORK="$(mktemp -d)"
trap "rm -rf $WORK" EXIT

mkdir -p "$WORK/source/_template/.claude/skills/foo" \
         "$WORK/source/_template/.claude/skills/port-vault" \
         "$WORK/source/_template/.claude/agents" \
         "$WORK/source/_template/.claude/hooks" \
         "$WORK/source/_template/scripts" \
         "$WORK/source/_template/00_Idea_Inbox" \
         "$WORK/plugin/.git"  \
         "$WORK/source/scripts"

# Files that SHOULD sync
echo "skill foo" > "$WORK/source/_template/.claude/skills/foo/SKILL.md"
echo "agent x" > "$WORK/source/_template/.claude/agents/x.md"
echo "hook" > "$WORK/source/_template/.claude/hooks/session-start.sh"
echo "core" > "$WORK/source/_template/Core_Thinking_Protocol.md"
echo "rules" > "$WORK/source/_template/Stage_Transition_Rules.md"
echo "research" > "$WORK/source/_template/Research_Integration_Protocol.md"
echo "fetch" > "$WORK/source/_template/scripts/fetch_research.py"
echo "0.4.0" > "$WORK/source/_template/VERSION"

# Files that should NOT sync
echo "port-vault skill" > "$WORK/source/_template/.claude/skills/port-vault/SKILL.md"
echo "user note" > "$WORK/source/_template/00_Idea_Inbox/note.md"

# Plugin repo seed
echo '{"name": "thinking-protocol-plugin", "version": "0.0.0"}' > "$WORK/plugin/plugin.json"
echo "0.0.0" > "$WORK/plugin/VERSION"

# Copy real sync script in
cp scripts/sync_to_plugin.sh "$WORK/source/scripts/"

# Run
cd "$WORK/source"
PLUGIN_REPO="$WORK/plugin" bash scripts/sync_to_plugin.sh

# Assertions
PASS=0; FAIL=0
check() {
  local label="$1" path="$2" should_exist="$3"
  if [[ "$should_exist" == "yes" && -e "$path" ]]; then PASS=$((PASS+1)); echo "PASS: $label"
  elif [[ "$should_exist" == "no" && ! -e "$path" ]]; then PASS=$((PASS+1)); echo "PASS: $label"
  else FAIL=$((FAIL+1)); echo "FAIL: $label (path=$path, should_exist=$should_exist, actual_exists=$([[ -e $path ]] && echo yes || echo no))"
  fi
}

check "skill_foo_synced" "$WORK/plugin/system_files/.claude/skills/foo/SKILL.md" "yes"
check "agent_x_synced" "$WORK/plugin/system_files/.claude/agents/x.md" "yes"
check "hook_synced" "$WORK/plugin/system_files/.claude/hooks/session-start.sh" "yes"
check "core_synced" "$WORK/plugin/system_files/Core_Thinking_Protocol.md" "yes"
check "rules_synced" "$WORK/plugin/system_files/Stage_Transition_Rules.md" "yes"
check "research_synced" "$WORK/plugin/system_files/Research_Integration_Protocol.md" "yes"
check "fetch_synced" "$WORK/plugin/system_files/scripts/fetch_research.py" "yes"
check "port_vault_excluded" "$WORK/plugin/system_files/.claude/skills/port-vault/SKILL.md" "no"
check "user_content_excluded" "$WORK/plugin/system_files/00_Idea_Inbox/note.md" "no"

# VERSION sync
[[ "$(cat $WORK/plugin/VERSION)" == "0.4.0" ]] && { PASS=$((PASS+1)); echo "PASS: VERSION_synced"; } || { FAIL=$((FAIL+1)); echo "FAIL: VERSION_synced"; }

# plugin.json version field updated
if command -v jq >/dev/null 2>&1; then
  v="$(jq -r .version "$WORK/plugin/plugin.json")"
  [[ "$v" == "0.4.0" ]] && { PASS=$((PASS+1)); echo "PASS: plugin_json_version"; } || { FAIL=$((FAIL+1)); echo "FAIL: plugin_json_version (got $v)"; }
fi

echo ""
echo "=== Result: PASS=$PASS, FAIL=$FAIL ==="
[[ $FAIL -eq 0 ]] || exit 1
