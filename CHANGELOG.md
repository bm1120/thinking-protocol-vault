# Template CHANGELOG

Tracks changes to this `_template/` bundle. Separated from source vault `CHANGELOG.md` per Phase 6 design decision Q4-C.

Schema for each entry:
```
## YYYY-MM-DD — vX.Y.Z — <short title>
- Kind: major | minor | patch
- Source: source vault Phase N close (or specific spec change reference)
- Affected: <changed files / new files / removed files>
- Migration (for existing users): <how to upgrade> | N/A (PATCH)
- Breaking: yes | no
```

Semantic versioning:
- **MAJOR**: breaking changes (placeholder var add/remove, dir structure change, required env dep)
- **MINOR**: backward-compatible additions (new skill, subagent, anti-pattern, doc section)
- **PATCH**: bug fixes, typos, clarifications (no setup procedure change)

---

## 2026-04-25 — v0.1.2 — verify mode false-positive fix

- Kind: patch
- Source: source vault Phase 6 dogfood Layer 3 (verify reported `FAIL: 9 orphan {{VAR}} markers found` after a successful substitute, blocking deployment confidence even when output files were clean)
- Affected:
  - modified: `setup.sh` verify mode (lines 107-117) — exclude `setup.sh` itself and `tests/` directory from orphan scan; the 9 `{{VAR}}` patterns in those files are intentional (sed commands + test fixtures, not deployment artifacts)
  - modified: `setup.sh` orphan grep — wrap in `(grep ... || true)` so the empty-match case (grep exit 1) does not trip `set -euo pipefail` and silently abort the script
  - modified: `tests/test_setup.sh` — added Test 7: substitute mode invokes auto-verify; assert exit code 0 (regression guard for the silent-abort bug)
- Migration: re-run `./setup.sh --verify` to confirm clean state. Previous v0.1.1 substitute-mode runs that appeared to fail (silent exit 1 after substituting all `.tmpl` files) actually succeeded — the abort happened *after* the deployment files were written, in the auto-verify step.
- Breaking: no

Two latent bugs surfaced together: (1) verify orphan check did not exclude its own substitution code, so the 9 legitimate patterns produced FAIL output; (2) when those 9 patterns were excluded, grep returned 0 matches → exit 1 → pipefail → silent abort. Test 7 covers both because it exercises the substitute → auto-verify path end-to-end.

All 8 tests PASS (T1.1, T1.2, T2, T3, T4, T5, T6, T7).

---

## 2026-04-25 — v0.1.1 — setup.env auto-source + .gitignore

- Kind: minor
- Source: source vault Phase 6 dogfood Layer 3 (UX gap discovered when running `./setup.sh` without env vars produced bare error message; user expected interactive or env-file workflow)
- Affected:
  - new: `setup.env.example` — annotated env file with validation rules per variable
  - new: `.gitignore` — excludes `setup.env` (contains absolute paths), `.bak/`, OS metadata
  - modified: `setup.sh` — auto-sources `setup.env` if present in script directory (lines 19-26)
  - modified: `SETUP.md` §2 — restructured to A (skill-driven) / B (env file, recommended for external users) / C (inline env vars for CI). Added validation rules table.
  - modified: `tests/test_setup.sh` — added Test 6 (setup.env auto-source)
- Migration (existing v0.1.0 users): no-op. The env-var inline workflow still works exactly as before. `setup.env` auto-sourcing is opt-in (only triggers if file exists). To adopt the new flow: `cp setup.env.example setup.env && $EDITOR setup.env`.
- Breaking: no

Backward-compatibility verified by Test 6 (env file path) plus T1-T5 (inline env vars path) all PASS.

---

## 2026-04-24 — v0.1.0 — Initial template release

- Kind: major (initial)
- Source: source vault Phase 6 close
- Affected: full _template/ bundle (16 components per spec §2)
- Migration: N/A (initial release — no prior version)
- Breaking: N/A

Initial portable bundle from source vault `Business_SecondBrain` Phase 1-5 complete state:

- 3 Core protocol files (Core_Thinking_Protocol, Stage_Transition_Rules, Research_Integration_Protocol)
- 6 subagents (framer, ideator, incubator, validator, presenter, researcher)
- 14 skills (bias-check, causal-reasoning-check, diverge-compression, idea-incubation-log, jobs-to-be-done, premortem-analysis, remote-association-matrix, research-integration, revisit-reminder, scamper-ideation, stage-transition-check, strategic-decision-journal, ux-psychology-checklist, worst-possible-idea)
- 3 hooks (post-tool-use-core, session-start, user-prompt-submit)
- 7 framework templates
- 21 KB seed notes across 4 axes + 1 Cross_Cutting note
- Meta_Lessons/ aggregation layer (README + empty Index)
- Decision/Compound templates + decisions/README
- Multi_Agent_Debate_Prompt
- scripts/fetch_research.py
- 3 .tmpl files (CLAUDE.md.tmpl, settings.json.tmpl, <Domain>_Context.md.tmpl)
- setup.sh + Layer 2 unit tests
- SETUP.md user guide (10 sections, Korean)

5 customization variables: PROJECT_NAME, VAULT_ABS_PATH, DOMAIN_NAME, PRIMARY_DOMAINS, RECURRING_TASKS.

8 CLAUDE.md Anti-Patterns from source vault.

12 Watch list items deferred to trigger-based monitoring (per Anti-Pattern #6).

---

## Watch list (initial state at v0.1.0)

These 12 items are flagged for monitoring without immediate action. Each names a trigger condition that turns it back into actionable work.

1. **researcher meta-commentary leak surface** (source vault Phase 4 Watch #1) — researcher has highest leak surface among the 3 untouched-by-Phase-4-T4 agents. Trigger: future dogfood produces a researcher-source meta-commentary leak.
2. **Compound learning hook reader mechanism is aspirational** (source vault Phase 4 Watch #2) — no skill/hook reads archived hooks. Currently human-mediated. Trigger: Phase 6+ builds Meta_Lessons/ aggregator or co-execution-planner skill.
3. **Field count drift discipline** (source vault Phase 4 Watch #3) — recurred 4× across Phases 4-5. Trigger: any structural count change → grep all occurrences before commit.
4. **Political over-weighting in business-domain decisions** (source vault Phase 4 Watch #4) — observed 2-of-2 business dogfoods. Trigger: 3rd business dogfood with same pattern.
5. **Meta_Lessons extraction predicate ambiguity** (source vault Phase 5 T3 review I1) — "share a recurring principle" not operationally specific. Trigger: N=2 Compound files emerge sharing apparent theme.
6. **Meta_Lessons multi-axis placement rule undefined** (source vault Phase 5 T3 review I2) — no rule for Compound spanning 2 axes. Trigger: next Compound is plausibly multi-axis.
7. **Compound "Aggregation status" vs Index "Extraction candidates" duplication** (source vault Phase 5 T3 review M5) — drift risk. Trigger: 2nd Compound emerges linking to extraction candidate.
8. **revisit-reminder caller restriction is honor-system** (source vault Phase 5 T4 review I3) — no enforcement check. Trigger: dogfood shows surprise notification scheduled.
9. **stage-transition-check forward reference for revisit trigger** (source vault Phase 5 T4 review minor #8) — incubator.md says skill "verify the revisit trigger fired" but skill itself not yet wired. Trigger: dogfood shows incubator yielding without verification.
10. **diverge-compression caller restriction is honor-system** (source vault Phase 5 T5 review I3) — ideator could in principle invoke. Trigger: dogfood shows ideator self-invoking compression.
11. **diverge-compression Singletons unbounded** (source vault Phase 5 T5 review M3) — degenerate output legal. Trigger: dogfood produces compression with > 15% Singletons.
12. **diverge-compression cluster-order implicit ranking** (source vault Phase 5 T5 review M4) — explicit ranking banned but order can imply ranking. Trigger: dogfood reveals reader bias toward Cluster 1.

---

## Pending design decisions (deferred to Phase 7+)

Per spec §8 Out-of-scope:
- GitHub-mode skill (clone from external repo)
- Windows / PowerShell `setup.ps1`
- Auto 3-way merge for upgrades
- `sync_template.sh --check` automation
- `co-execution-planner` skill extraction
- User-side template forking workflow

These items are not bugs — they're consciously deferred. Re-evaluate at each source vault Phase close.
