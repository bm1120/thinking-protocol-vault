#!/usr/bin/env bash
# Layer 1 static checks for v0.4 release.
set -euo pipefail
PASS=0; FAIL=0
check() { local label="$1" cmd="$2"; if eval "$cmd"; then PASS=$((PASS+1)); echo "PASS: $label"; else FAIL=$((FAIL+1)); echo "FAIL: $label"; fi; }

# 1. _template/ has no source-vault leakage (Phase 6 pattern)
# Exclude tests/ since test scripts must reference these names to check for them.
check "no_business_secondbrain_context_leak" '! grep -rE --exclude-dir=tests "Business_SecondBrain_Context|Data_Scientist_Context" _template/ 2>/dev/null'

# 2. All system markdown files have system: true (in _template/)
missing="$(grep -rL '^system: true$' _template/.claude/skills/*/SKILL.md _template/.claude/agents/*.md 2>/dev/null || true)"
check "all_system_md_marked" '[[ -z "$missing" ]]'

# 3. Core protocol docs have frontmatter
for f in _template/Core_Thinking_Protocol.md _template/Stage_Transition_Rules.md _template/Research_Integration_Protocol.md; do
  check "frontmatter_$(basename $f .md)" "head -1 $f | grep -q '^---\$'"
done

# 4. Hook + script have first-line marker
check "hook_marker" "head -2 _template/.claude/hooks/session-start.sh | grep -q 'managed-by: thinking-protocol-plugin'"
check "fetch_marker" "head -2 _template/scripts/fetch_research.py | grep -q 'managed-by: thinking-protocol-plugin'"

# 5. .gitignore patterns
for entry in "_backup/" "_logs/"; do
  check "template_gitignore_$entry" "grep -qxF '$entry' _template/.gitignore"
done

# 6. _template/VERSION = 0.4.0
check "template_version_040" "[[ \$(cat _template/VERSION) == '0.4.0' ]]"

# 7. Plugin repo present + valid
PLUGIN_REPO="${PLUGIN_REPO:-../thinking-protocol-plugin}"
check "plugin_repo_present" "[[ -d $PLUGIN_REPO/.git ]]"
check "plugin_json_valid" "jq . $PLUGIN_REPO/plugin.json >/dev/null"
check "plugin_version_match" "[[ \$(cat $PLUGIN_REPO/VERSION) == \$(cat _template/VERSION) ]]"

# 8. plugin.json has required fields (per Revision 1)
check "plugin_json_has_name" "[[ \$(jq -r .name $PLUGIN_REPO/plugin.json) == 'thinking-protocol-plugin' ]]"
check "plugin_json_has_commands" "[[ \$(jq -r .commands $PLUGIN_REPO/plugin.json) == 'commands' ]]"
check "plugin_json_has_hooks" "[[ \$(jq -r .hooks $PLUGIN_REPO/plugin.json) == 'hooks/plugin-hooks.json' ]]"
check "plugin_json_no_lifecycle" "[[ \$(jq -r .lifecycle $PLUGIN_REPO/plugin.json) == 'null' ]]"
check "plugin_json_no_schedules" "[[ \$(jq -r .schedules $PLUGIN_REPO/plugin.json) == 'null' ]]"

# 9. plugin system_files/ has no user-layer files
check "plugin_no_user_dirs" "! find $PLUGIN_REPO/system_files -type d -name '00_*' 2>/dev/null | grep -q ."
check "plugin_no_port_vault" "! [[ -d $PLUGIN_REPO/system_files/.claude/skills/port-vault ]]"

echo ""
echo "=== Layer 1: PASS=$PASS, FAIL=$FAIL ==="
[[ $FAIL -eq 0 ]] || exit 1
