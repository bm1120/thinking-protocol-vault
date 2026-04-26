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

## 2026-04-26 — v0.2.0 — Diverge chain enforcement + compression threshold

- Kind: minor (behavior change, backward-compatible setup)
- Source: source vault Phase 6 Layer 3 dogfood + Phase 7-1 spec
- Affected:
  - modified: `.claude/agents/ideator.md` — Calls section converted from optional menu (≥ 1 of remote-assoc / SCAMPER) to mandatory 3-skill chain (SCAMPER + Remote-Association-Matrix + Worst-Possible-Idea). Output reformatted to 3 grouped sections with continuous numbering. User-N reframed as floor (not ceiling) with transparency line.
  - modified: `.claude/skills/diverge-compression/SKILL.md` — invocation threshold ≥ 25 → ≥ 15 (4 sites). Sub-15 case reframed as "Diverge stage incomplete; route back to ideator".
  - modified: `Stage_Transition_Rules.md` — lines 58 and 64 aligned to ≥ 15 threshold. (This file was missing from the original Phase 7-1 plan; the cross-file gap was caught in Task 2 code review and resolved before further tasks.)
  - modified: `Core_Thinking_Protocol.md` Stage 2 — 1-line note recording the chain default and auto-compression coupling, plus Checklist updated to mandate the full 3-skill chain.
- Migration (existing v0.1.x deployments): pull the four updated files via `curl` from `https://raw.githubusercontent.com/bm1120/thinking-protocol-vault/main/...`, or generate a fresh vault from the updated template repo (recommended for clean Layer 3 dogfood attribution).
- Breaking: no (no setup procedure change, no env-var change).

Driver: Phase 6 Layer 3 dogfood (n = 1) where the ideator produced 5 ideas in response to a "5개 brainstorm" request despite its own `## Principles` mandating ≥ 15. Root cause: the existing Calls section allowed ≥ 1 of remote-assoc / SCAMPER to satisfy the force-distance rule, and a single skill cannot reach ≥ 15 substep outputs.

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
13. **diverge-compression threshold lowered ≥ 25 → ≥ 15 (Phase 7-1, 2026-04-26)** — partly speculative based on n = 1 Phase 6 dogfood. The mandatory chain in ideator is evidence-supported; the compression threshold change is not directly evidenced (we have no dogfood of how 16-idea output is digested).
    - Trigger to revert: next Layer 3 dogfood shows users skip the cluster view OR evaluate directly from the grouped raw output → restore threshold to ≥ 25 and downgrade Watch to closed-by-revert.
    - Trigger to escalate: cluster view becomes the primary candidate-selection surface → make "Below 15 incomplete" explicit in `Stage_Transition_Rules.md` (currently asserted only in `diverge-compression/SKILL.md`).
    - Note (added in final review fix-up): the escalation directive's premise "currently asserted only in `diverge-compression/SKILL.md`" was already partially obsolete when written — `Stage_Transition_Rules.md` was updated in commit 7fc9b57 (Task 2 fix-up) to also assert "Below 15, Diverge stage is incomplete; route back to ideator" at lines 58 and 64. The escalation trigger should now read: if cluster view becomes the primary candidate-selection surface, also surface the routing-back rule as an explicit Stage 2 *exit criterion* in `Core_Thinking_Protocol.md` (currently a 1-line note + Checklist bullet, but no explicit exit criterion).
14. **`diverge-compression` precondition #1 expects "no evaluation performed" trailer that ideator does not emit (pre-existing)** — `_template/.claude/skills/diverge-compression/SKILL.md` line 14 declares the trailer as a hard precondition; ideator's `## Output` trailer reads "Diverge 완료. ... Hand off to `incubator` (do not skip)." with no "no evaluation performed" phrase. This mismatch was present BEFORE Phase 7-1 (the old handoff also lacked the trailer); it surfaced during the v0.2.0 code review.
    - Trigger to fix: any future cycle that touches either ideator's `## Output` section OR `diverge-compression`'s preconditions → resolve by either (a) adding "No evaluation performed." to ideator's handoff trailer, or (b) softening compression precondition #1 from a literal-string check to a semantic check.
    - Status: pre-existing, not introduced by Phase 7-1; deferred from Phase 7-1 fix-up scope to keep the change set focused.
    - 3rd site (added in final review fix-up): `Core_Thinking_Protocol.md` Stage 2 Checklist also contains the pre-existing bullet `Explicitly state "no evaluation performed" at the end of the list.` — preserved through the Phase 7-1 I2 fix (commit 495eb49). This means three files now jointly mandate or expect the trailer string, but the ideator does not emit it. Future fix should resolve all three sites coherently (either ideator emits the trailer, or all three references soften to a semantic check).
15. **Zero-slack coupling: chain floor = compression threshold (Phase 7-1, 2026-04-26)** — the mandatory chain in `ideator.md` declares per-skill floors (SCAMPER ≥ 7, remote-assoc ≥ 5, worst-possible ≥ 3) that sum to exactly 15, and the `diverge-compression` invocation threshold is also exactly ≥ 15. Any single chain skill underproducing by one item (e.g., a model returning 4 pairings instead of 5 on a lean run) drops the total to 14, at which point compression refuses to invoke and `Stage_Transition_Rules.md` pre-check fails the ≥ 15 gate. The orchestrator is then forced to route back to ideator with no documented retry cap.
    - Trigger to mitigate: any future Layer 3 dogfood produces a 14-idea Diverge output → either (a) widen one or more skill floors so chain output reliably exceeds 15 with margin, or (b) lower compression threshold to ≥ 13 to absorb the slack, or (c) add an explicit retry-and-fallback policy to ideator (e.g., "if total < 15, run worst-possible-idea twice") with a cap (e.g., 2 retries before degrading session).
    - Status: identified during Phase 7-1 final review. Has not yet manifested in a dogfood, but the brittleness is structural in the current design and will surface eventually.

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
