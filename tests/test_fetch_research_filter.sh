#!/usr/bin/env bash
# _template/tests/test_fetch_research_filter.sh
# Verify scripts/fetch_research.py pre-filter (should_skip + _match_keyword)
# matches spec §5 acceptance cases. No network dependency.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# In source vault: _template/tests/ → _template/scripts/fetch_research.py
# In template-rendered vault: tests/ → scripts/fetch_research.py
# Detect both and pick the right path.
if [[ -f "$SCRIPT_DIR/../scripts/fetch_research.py" ]]; then
  FETCH_PY="$SCRIPT_DIR/../scripts/fetch_research.py"
elif [[ -f "$SCRIPT_DIR/../../scripts/fetch_research.py" ]]; then
  FETCH_PY="$SCRIPT_DIR/../../scripts/fetch_research.py"
else
  echo "FAIL: fetch_research.py not found relative to test"
  exit 1
fi
SCRIPTS_DIR="$(cd "$(dirname "$FETCH_PY")" && pwd)"

PASS=0
FAIL=0

assert() {
  local label="$1"
  local actual="$2"
  local expected="$3"
  if [[ "$actual" == "$expected" ]]; then
    PASS=$((PASS+1))
    echo "PASS: $label"
  else
    FAIL=$((FAIL+1))
    echo "FAIL: $label — expected '$expected', got '$actual'"
  fi
}

run_should_skip() {
  # Args: $1=link, $2=title
  local link="$1" title="$2"
  python3 -c "
import sys
sys.path.insert(0, '$SCRIPTS_DIR')
from fetch_research import should_skip
item = {'link': '''$link''', 'title': '''$title'''}
skip, rule = should_skip(item, 'TestSource')
print(f'{skip}|{rule}')
"
}

# Test 1: URL deny match
result="$(run_should_skip 'https://behavioralscientist.org/what-its-like-to-be-a-funeral-director/' 'What It Is Like to Be a Funeral Director')"
assert "1: URL deny BS profile" "$result" "True|URL_DENY_profile"

# Test 2: URL deny miss (BS legit research URL)
result="$(run_should_skip 'https://behavioralscientist.org/the-hard-truths/' 'The Hard Truths')"
assert "2: URL deny miss (BS non-profile)" "$result" "False|"

# Test 3: biomarker keyword (substring single-word with \b)
result="$(run_should_skip 'https://example.com/x' 'Scientists discover new alzheimer biomarker')"
assert "3: biomarker keyword" "$result" "True|TITLE_DENY:biomarker"

# Test 4: early detection (multi-word substring)
result="$(run_should_skip 'https://example.com/x' 'Nose may enable early detection of Alzheimer disease')"
assert "4: early detection multi-word" "$result" "True|TITLE_DENY:early detection"

# Test 5: blood test (multi-word substring)
result="$(run_should_skip 'https://example.com/x' 'Simple blood test predicts depression')"
assert "5: blood test multi-word" "$result" "True|TITLE_DENY:blood test"

# Test 6: screening word-boundary true
result="$(run_should_skip 'https://example.com/x' 'New cancer screening tool announced')"
assert "6: screening word-boundary true" "$result" "True|TITLE_DENY:screening"

# Test 7: screening word-boundary miss (screenings, plural)
result="$(run_should_skip 'https://example.com/x' 'Screenings showed cohort differences')"
assert "7: screening word-boundary miss (plural)" "$result" "False|"

# Test 8: disease name not filtered (mechanism research)
result="$(run_should_skip 'https://example.com/x' 'Schizophrenia genetics reveal belief updating mechanism')"
assert "8: disease name (Schizophrenia) not filtered" "$result" "False|"

# Test 9: empty title graceful (no crash, no match)
result="$(run_should_skip 'https://example.com/x' '')"
assert "9: empty title graceful" "$result" "False|"

echo ""
echo "=== Filter pre-filter test: PASS=$PASS, FAIL=$FAIL ==="
[[ $FAIL -eq 0 ]] || exit 1
