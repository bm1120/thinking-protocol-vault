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

## v0.4.0 — 2026-04-26 — Phase 7-2: Plugin distribution + research automation

- Kind: structure
- Source: `docs/superpowers/specs/2026-04-26-phase-7-2-plugin-distribution-design.md`; `docs/superpowers/plans/2026-04-26-phase-7-2-plugin-distribution.md`
- Affected files: NEW `bm1120/thinking-protocol-plugin` repo (plugin.json, lib/migrate.sh, lib/classify.sh, commands/migrate.{md,sh}, hooks/plugin-{hooks.json,session-start.sh}, system_files/, tests/), NEW `scripts/sync_to_plugin.sh`, NEW `_template/tests/test_layer1_v04.sh` + `_template/tests/test_sync_to_plugin.sh`, MODIFY all 16 skill SKILL.md + 6 agent .md (frontmatter `system: true`), MODIFY `_template/.claude/hooks/session-start.sh` (first-line marker + multi-line reminder), MODIFY `_template/scripts/fetch_research.py` (first-line marker), MODIFY `_template/Core_Thinking_Protocol.md` + `_template/Stage_Transition_Rules.md` + `_template/Research_Integration_Protocol.md` (frontmatter blocks), MODIFY `_template/SETUP.md` (Migration & rollback section), MODIFY `_template/.gitignore` (+ `_backup/`, `_logs/`), MODIFY `_template/VERSION` (0.3.0 → 0.4.0).
- Change: hybrid distribution model. Existing vaults run `/plugin install bm1120/thinking-protocol-plugin` then `/migrate` to migrate from v0.1-0.3, with auto-backup to `_backup/<timestamp>/` and frontmatter-driven fork detection (`system: false` files preserved). `scripts/sync_to_plugin.sh` keeps plugin repo derived from `_template/`. Research feed Step 1 automation: OS crontab fallback (plugin spec lacks `schedules` per Task 1 findings). Researcher subagent invocation surface validated structurally (plugin manifest registers agents); end-to-end surfacing requires user verification in fresh Claude session per Task 17 dogfood notes.
- Shadow Test: source vault dogfood (Task 17, `00_Idea_Inbox/Dogfood_Notes_2026-04-26_phase-7-2-plugin.md`). Acceptance checklist: PASS_WITH_NOTES (researcher surfacing pending manual verification, framer.md source-vault drift documented as Watch 24).
- Tests: 8/8 setup PASS; 11/11 sync_to_plugin PASS; 20/20 layer1_v04 PASS; 12/12 layer_marking PASS; 11/11 migration PASS.

### Watch list updates

- **Watch 18 retired** — template upgrade gap closed by hybrid distribution model.
- **Watch 19 partially retired** — Step 1 automation closed via cron registration in `register_cron_if_consented`. Researcher invocation surface implemented at structural level (plugin manifest); end-to-end verification pending. Steps 2-6 automation deferred → tracked under new Watch 21.
- **Watch 20 NEW** — Cron job availability. Plan-stage finding (Task 1) confirmed plugin spec has no `schedules` field. Mitigation in place via OS crontab fallback in `lib/migrate.sh`. Trigger: dogfood Task 17 cron declined path verified, but consented path needs separate test in real session.
- **Watch 21 NEW (TRIGGER FIRED 2026-05-05)** — Pre-filter threshold for research absorption. Observation #1 = 2026-04-26 batch (0/7 acceptance + clinical-pathology dominance, `04_Archives/research_rejected/2026-04-26-batch-rejection.md`). Observation #2 = 2026-05-05 batch (0/6 acceptance + same dominance pattern, `04_Archives/research_rejected/2026-05-05-batch-rejection.md`). Cumulative: 0/13 unique articles, ~55 min human cost. **Trigger threshold met** (≥2 observations per Anti-Pattern #6). Next action: design pre-filter rule for `scripts/fetch_research.py` as harness-modification sub-project (Phase 7-3 candidate). Candidate rules: clinical-pathology keyword skip on ScienceDaily titles, profile-series URL skip, essay/meta heuristic.
- **Watch 22 NEW** — Hybrid distribution model migration failures. Track post-release. Trigger: any external user reports `/migrate` failure not covered by spec §5.4 edge cases.
- **Watch 23 NEW** — Fork frequency. Track usage. Trigger: ≥3 distinct system files toggled to `system: false` → revisit hybrid file policy (currently CLAUDE.md vault-root = entirely user, may need finer-grained marking).
- **Watch 24 NEW** — Source vault `framer.md` drift from plugin distribution. Source vault has source-vault-only customization (examples/domain-contexts bullets per CLAUDE.md §6) that plugin doesn't ship; `/migrate` overwrites them. Mitigation options for v0.4.1+: (a) mark source-vault `framer.md` as `system: false` permanently, or (b) source-vault devs `git checkout -- .claude/agents/framer.md` after each /migrate. Trigger: user reports it as friction in source-vault dev workflow.

---

## 2026-04-26 — v0.3.0 — Vault evolution skills (context-engineering + harness-modification)

- Kind: minor (additive — 2 new workflow skills, no spec breakage, no setup procedure change)
- Source: post-Phase-7-1 design discussion (vault-evolution discipline separation)
- Affected:
  - new: `.claude/skills/context-engineering/SKILL.md` — workflow skill for vault context-layer changes (CLAUDE.md, agent.md, SKILL.md, *_Context.md, Stage_Transition_Rules.md, Core_Thinking_Protocol.md). Includes Step 0 trigger detection + diagnosis (A/B/C/D/E routing), Complexity gate (Trivial inline / Non-trivial → brainstorming), 6-step procedure, Anti-Pattern #6 enforcement.
  - new: `.claude/skills/harness-modification/SKILL.md` — workflow skill for vault harness-layer changes (`.claude/hooks/*.sh`, `.claude/settings.json`, `scripts/*.py`, `scripts/*.sh`). Same Step 0 / Complexity gate / 6-step structure, with TDD-style Step 3 (mock input → expected output + exit code).
  - modified: `CLAUDE.md` §6 routing table — 2 new rows for context-engineering and harness-modification triggers (direct + symptom-based).
- Migration (existing v0.2.x deployments): pull 2 new SKILL.md files via `curl` from `https://raw.githubusercontent.com/bm1120/thinking-protocol-vault/main/.claude/skills/{context-engineering,harness-modification}/SKILL.md`, plus the updated `CLAUDE.md` for the routing rows. Or generate a fresh vault from the updated template repo.
- Breaking: no (no setup procedure change, no env-var change, no behavioral change to existing skills/agents).

Skill counts: template now ships **16 skills** (was 14 at v0.2.x). Source vault has **17** (the additional one is `port-vault`, source-only by design — see v0.1.0 entry note).

Driver: post-Phase-7-1 reflection — Phase 7-1 made spec-only edits (markdown) but the user identified that future enforcement work would need a **separate discipline** (harness layer: hooks, settings, scripts) and that **trigger detection** should handle symptom-based phrasing ("이런 에러", "시스템적으로 처리해야") not just direct requests ("hook 추가해줘"). Two skills codify this: one for context, one for harness, with shared Step 0 diagnosis pattern + Anti-Pattern #6 gating.

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
16. **Vault-evolution skills' Step 0 diagnosis honor-system (v0.3.0, 2026-04-26)** — `context-engineering` and `harness-modification` both gate Step 1 entry on Anti-Pattern #6 evidence (≥ 2 spec violations OR plan task OR Watch trigger). The gate is a markdown instruction with no runtime enforcement; an over-eager session could skip Step 0 and proceed to Step 1 directly.
    - Trigger to harden: ≥ 2 instances observed where Step 0 was skipped → the speculative engineering it should have caught caused over-built changes. Resolve by adding a hook that scans for "Skipping Step 0" patterns in vault-evolution commits, OR by demoting both skills to require an explicit "diagnosis" parameter from caller before proceeding.
    - Status: same honor-system pattern as Watch 8 (revisit-reminder) and Watch 10 (diverge-compression caller restriction). Proportional to actual misuse; not pre-emptively hardened.
17. **Vault-evolution agent specialization deferred (v0.3.0, 2026-04-26)** — proposed `context-engineer` and `harness-engineer` subagents were considered as alternatives to skills, but rejected for now because (a) general-purpose subagent + task prompt produces equivalent isolated context, (b) current 6 stage-specific agents would lose pattern coherence with meta-agents, (c) usage frequency is too low to amortize agent design cost.
    - Trigger to revisit: vault evolution count ≥ 3 distinct sub-projects in a single phase → task-prompt construction cost accumulates → specialized agent prebake becomes worthwhile.
    - Status: explicitly deferred at design time, not a missed item. Skills carry the discipline; agents are an optimization for high-frequency cases.
18. **Template upgrade gap — plugin distribution candidate (v0.3.0, 2026-04-26)** — current architecture (Phase 6 Q4-C: "template + manual merge") propagates updates to NEW vaults only at instantiation time. Existing vaults receive no updates without manual `curl` per file. Evidence threshold met: 4 migrations in 1 day (v0.1.0 → v0.1.1 → v0.1.2 → v0.2.0 → v0.3.0), accumulating ~10+ files of drift per long-running vault. As of v0.3.0 there are no actual long-running external deployments — but this gap will dominate any future external adoption.
    - Candidate solution: Claude Code plugin distribution. Pack `.claude/skills/`, `.claude/agents/`, `.claude/hooks/`, and Core protocol files (`Core_Thinking_Protocol.md`, `Stage_Transition_Rules.md`, `Research_Integration_Protocol.md`) as a separate plugin repo (e.g., `bm1120/thinking-protocol-plugin`). Vault scaffold repo retains user-layer files (`CLAUDE.md.tmpl`, `<Domain>_Context.md.tmpl`, KB seeds, decision templates, `setup.sh`). Users do `/plugin install` once + `/plugin update` thereafter for system-layer refresh; user-layer files preserved across updates.
    - Trigger to design: **Phase 7-2 brainstorming priority 1** after Phase 7-1 Layer 3 dogfood (Task 7). Phase 7-1 dogfood may surface enforcement needs that affect the plugin scope (e.g., if hook-based enforcement becomes essential, plugin distribution becomes more urgent).
    - Open questions for Phase 7-2: pure plugin (A) vs hybrid template+plugin (B) vs template+sync_script (C — original Q4-D); layer marking metadata; offline / non-Claude-Code-CLI fallback; two-repo build automation from single `_template/` source; existing-vault migration story (currently n=0 external).
    - Status: actively flagged with sufficient evidence; queued behind dogfood for proper sequencing.
19. **Research integration loop only Step 1 partially automated (v0.3.0, 2026-04-26)** — `scripts/fetch_research.py` exists and is permitted in `settings.json`, but no scheduler invokes it (no crontab, no hook). Header claims "매일 아침 9시 업데이트" but is design intent only. As of this entry: 12+ feed entries accumulated since Apr 22, none processed through CLAUDE.md §7 Steps 2-6 (Extract Claim → Map to Stage → Draft Rule Change → Shadow Test → Merge or Reject). Researcher subagent is never invoked automatically.
    - Mitigation applied at v0.3.0: `session-start.sh` hook now detects feed staleness (≥ 1 day since last modification) and emits a reminder line ("⚠️ Research feed last updated N day(s) ago. Run …") into session context. This is **opt-in nudge only**: no auto-fetch, no auto-absorption.
    - Open for Phase 7-2: full automation (CronCreate to fetch + auto-invoke researcher subagent on new entries). Risks: Shadow Test (Step 5) requires LLM judgment that may not be safe to fully automate; auto-merge into protocol files violates current human-in-the-loop discipline.
    - Status: Phase 7-2 candidate — likely paired with plugin distribution (Watch 18) since both touch the harness layer.

---

## Pending design decisions (deferred to Phase 7+)

**Phase 7-2 brainstorming priority 1 (evidence-supported, queued post-Phase-7-1-dogfood):**
- **Plugin distribution architecture** (Watch 18) — pure plugin / hybrid template+plugin / template+sync_script. Subsumes the previously-listed `sync_template.sh --check` and `Auto 3-way merge` items.

**Phase 7-2+ backlog (less urgent):**
- GitHub-mode skill (clone from external repo)
- Windows / PowerShell `setup.ps1`
- `co-execution-planner` skill extraction
- User-side template forking workflow

These items are not bugs — they're consciously deferred. Re-evaluate at each source vault Phase close.
