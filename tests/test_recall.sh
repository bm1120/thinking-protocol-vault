#!/usr/bin/env bash
# tests/test_recall.sh — structure-aware recall engine tests.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
RECALL="$TEMPLATE_ROOT/.claude/skills/recall/recall.py"

PASS=0; FAIL=0
check() { local label="$1" cond="$2"; if eval "$cond"; then PASS=$((PASS+1)); echo "PASS: $label"; else FAIL=$((FAIL+1)); echo "FAIL: $label"; fi; }

# Fixture A: base-only vault (no insights/analyses)
A="$(mktemp -d)"; mkdir -p "$A/00_Idea_Inbox" "$A/03_Knowledge_Base" "$A/04_Archives/decisions"
printf -- '---\ntags: [retention]\ndate: 2026-05-01\n---\n# churn drivers\nretention cohort analysis\n' > "$A/04_Archives/decisions/2026-05-01-churn.md"
# Korean-content note: 2-char content words (분석/결과) are the common case in a Korean-first vault.
printf -- '---\ntags: [analysis]\ndate: 2026-05-02\n---\n# 분석 노트\n리텐션 분석 결과 정리\n' > "$A/04_Archives/decisions/2026-05-02-korean.md"

# Fixture B: customized vault (with insights + MOC)
B="$(mktemp -d)"; mkdir -p "$B/00_Idea_Inbox" "$B/03_Knowledge_Base" "$B/04_Archives/decisions" "$B/insights"
printf -- '---\ntags: [retention]\ndate: 2026-05-20\n---\n# retention is activation-bound\n' > "$B/insights/retention.md"
printf -- '# MOC\n## Retention\n- [[retention]]\n' > "$B/insights/_MOC.md"

# Test 1: base-only vault runs without error and reports skipped layers
out_a="$(python3 "$RECALL" --root "$A" "retention" 2>&1)"
check "base_vault_no_error" '[[ $? -eq 0 ]]'
check "base_reports_skipped_insights" 'echo "$out_a" | grep -qi "skipped"'

# Test 2: intent classification
boost_an="$(python3 "$RECALL" --root "$B" --debug-intent "have I analyzed retention")"
check "intent_analyzed_boosts_analyses" 'echo "$boost_an" | grep -q "intent=analyses"'
boost_kn="$(python3 "$RECALL" --root "$B" --debug-intent "what do I know about retention")"
check "intent_know_boosts_insights" 'echo "$boost_kn" | grep -q "intent=know"'

# Test 3: search/rank/output
res_a="$(python3 "$RECALL" --root "$A" "retention cohort")"
check "finds_decision_match" 'echo "$res_a" | grep -q "04_Archives/decisions/2026-05-01-churn.md"'
check "labels_layer" 'echo "$res_a" | grep -q "\[decision\]"'
res_none="$(python3 "$RECALL" --root "$A" "zzz_nonexistent_term")"
check "low_density_message" 'echo "$res_none" | grep -qi "low connection density"'
# Korean 2-char content words must be searchable (not dropped as if English stopwords)
res_ko="$(python3 "$RECALL" --root "$A" "분석 결과")"
check "korean_2char_term_matches" 'echo "$res_ko" | grep -q "2026-05-02-korean.md"'
res_b="$(python3 "$RECALL" --root "$B" "what do I know about retention")"
check "surfaces_insights" 'echo "$res_b" | grep -q "insights/retention.md"'

# Test 4: SKILL.md
SKILL="$TEMPLATE_ROOT/.claude/skills/recall/SKILL.md"
check "skill_exists" '[[ -f "$SKILL" ]]'
check "skill_has_frontmatter_name" 'grep -q "^name: recall" "$SKILL"'
check "skill_marks_system" 'grep -q "^system: true" "$SKILL"'
check "skill_references_engine" 'grep -q "recall.py" "$SKILL"'

echo "=== Result: PASS=$PASS FAIL=$FAIL ==="
[[ $FAIL -eq 0 ]] || exit 1
