#!/bin/bash
# test_setup.sh — Layer 2 unit tests for setup.sh
# Run from _template/ directory: bash tests/test_setup.sh

set -uo pipefail

PASS=0
FAIL=0

make_test_dir() {
  local d
  d=$(mktemp -d)
  mkdir -p "$d/sub"
  echo "Project: {{PROJECT_NAME}}, Path: {{VAULT_ABS_PATH}}" > "$d/test1.md.tmpl"
  echo "Domain: {{DOMAIN_NAME}}" > "$d/sub/test2.md.tmpl"
  cp "$(dirname "$0")/../setup.sh" "$d/setup.sh"
  chmod +x "$d/setup.sh"
  echo "$d"
}

cleanup() {
  if [ -n "${TEST_DIR:-}" ] && [ -d "$TEST_DIR" ]; then
    rm -rf "$TEST_DIR"
  fi
}
trap cleanup EXIT

assert_eq() {
  local name="$1" expected="$2" actual="$3"
  if [ "$expected" = "$actual" ]; then
    echo "PASS: $name"
    PASS=$((PASS + 1))
  else
    echo "FAIL: $name — expected '$expected', got '$actual'"
    FAIL=$((FAIL + 1))
  fi
}

# Test 1: Happy path
TEST_DIR=$(make_test_dir)
export PROJECT_NAME="My_Vault"
export VAULT_ABS_PATH="$TEST_DIR"
export DOMAIN_NAME="Marketing"
export PRIMARY_DOMAINS="marketing campaigns"
export RECURRING_TASKS=""

cd "$TEST_DIR" && ./setup.sh > /dev/null 2>&1
result=$(cat test1.md 2>/dev/null || echo "MISSING")
assert_eq "T1.1 happy path: substituted content" "Project: My_Vault, Path: $TEST_DIR" "$result"
remaining=$(find . -name "*.tmpl" 2>/dev/null | wc -l | tr -d ' ')
assert_eq "T1.2 happy path: no .tmpl remain" "0" "$remaining"
cd - > /dev/null

# Test 2: Missing var
TEST_DIR=$(make_test_dir)
unset PRIMARY_DOMAINS
exit_code=0
cd "$TEST_DIR" && ./setup.sh > /dev/null 2>&1 || exit_code=$?
assert_eq "T2 missing PRIMARY_DOMAINS: exit code 1" "1" "$exit_code"
cd - > /dev/null
export PRIMARY_DOMAINS="marketing campaigns"

# Test 3: Invalid PROJECT_NAME
TEST_DIR=$(make_test_dir)
export PROJECT_NAME="my project"
exit_code=0
cd "$TEST_DIR" && ./setup.sh > /dev/null 2>&1 || exit_code=$?
assert_eq "T3 invalid PROJECT_NAME: exit code 1" "1" "$exit_code"
cd - > /dev/null
export PROJECT_NAME="My_Vault"

# Test 4: Idempotency
TEST_DIR=$(make_test_dir)
export VAULT_ABS_PATH="$TEST_DIR"
cd "$TEST_DIR" && ./setup.sh > /dev/null 2>&1
output=$(./setup.sh 2>&1)
assert_eq "T4 idempotency: 2nd run is no-op" "Already setup — no .tmpl files to process. (Re-run is a no-op.)" "$output"
cd - > /dev/null

# Test 5: Dry-run
TEST_DIR=$(make_test_dir)
export VAULT_ABS_PATH="$TEST_DIR"
cd "$TEST_DIR" && ./setup.sh --dry-run > /dev/null 2>&1
remaining=$(find . -name "*.tmpl" 2>/dev/null | wc -l | tr -d ' ')
assert_eq "T5 dry-run: .tmpl preserved" "2" "$remaining"
cd - > /dev/null

# Test 6: setup.env auto-source
TEST_DIR=$(make_test_dir)
cat > "$TEST_DIR/setup.env" <<EOF
PROJECT_NAME=Env_File_Vault
DOMAIN_NAME=Marketing
PRIMARY_DOMAINS="loaded from env file"
RECURRING_TASKS=""
VAULT_ABS_PATH=$TEST_DIR
EOF
unset PROJECT_NAME DOMAIN_NAME PRIMARY_DOMAINS RECURRING_TASKS VAULT_ABS_PATH
cd "$TEST_DIR" && ./setup.sh > /dev/null 2>&1
result=$(cat test1.md 2>/dev/null || echo "MISSING")
assert_eq "T6 setup.env auto-sourced: substitution succeeded" "Project: Env_File_Vault, Path: $TEST_DIR" "$result"
cd - > /dev/null
export PROJECT_NAME="My_Vault"
export DOMAIN_NAME="Marketing"
export PRIMARY_DOMAINS="marketing campaigns"
export RECURRING_TASKS=""

# Test 7: substitute mode auto-verify exits 0 (no false-positive orphans)
# Regression guard for v0.1.1 bug: setup.sh and tests/ contain legitimate
# {{VAR}} patterns that the orphan scan was incorrectly flagging.
TEST_DIR=$(make_test_dir)
export VAULT_ABS_PATH="$TEST_DIR"
exit_code=0
cd "$TEST_DIR" && ./setup.sh > /dev/null 2>&1 || exit_code=$?
assert_eq "T7 substitute auto-verify: exit code 0" "0" "$exit_code"
cd - > /dev/null

echo ""
echo "Tests: $((PASS + FAIL)) total, $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
