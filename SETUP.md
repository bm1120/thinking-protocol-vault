# SETUP — Business SecondBrain Template

> Template version: see `VERSION` file
> Source spec: source vault `docs/superpowers/specs/2026-04-24-phase-6-porting-template-design.md`

## 1. 이 vault가 무엇인가

이 vault는 6단계 의사결정 protocol (Frame → Diverge → Incubate → Illuminate → Converge → Decide) 기반의 **Thinking-Protocol Second Brain**입니다. 심리학·행동경제학·신경과학 연구를 통합한 4축 Knowledge Base (Decision-Making / Problem-Solving / Causal Reasoning / Creativity)와 14개 skills, 6개 subagents, 3개 hook scripts가 protocol을 자동화합니다.

핵심 원칙:
- **모드 분리** — Diverge(생성)와 Converge(평가)가 같은 턴에 섞이지 않음
- **Incubate 강제** — non-trivial 결정은 의도적 pause 후에만 평가
- **Cite or abstain** — KB 출처 없는 주장은 "근거 없음" 라벨
- **Right-size** — 작은 결정은 Frame→Converge→Decide 압축 플로우

## 2. 시작 (5분)

세 가지 경로:

### A. Skill-driven (Source vault 보유 시 추천)

Source vault (`port-vault` skill 보유)에서 호출 → 5개 질문 답 → 자동 setup.

```bash
mkdir my-vault && cd my-vault
claude
# Inside Claude Code:
# > port-vault skill을 사용해 이 디렉토리를 설정해줘
```

### B. Env file (외부 사용자 추천)

GitHub template repo에서 새 repo 생성하거나 `_template/`을 복사한 뒤, `setup.env.example`을 편집해 실행:

```bash
# 1) Template 가져오기
#    Option 1: GitHub template "Use this template" 버튼 → clone
gh repo clone <owner>/<your-new-vault-repo>
cd <your-new-vault-repo>

#    Option 2: 로컬 복사
cp -r /path/to/_template/ my-vault/
cd my-vault

# 2) Env 파일 준비 + 편집
cp setup.env.example setup.env
$EDITOR setup.env   # 5개 변수 채우기 (주석에 validation rule 명시)

# 3) 실행
./setup.sh
./setup.sh --verify   # 모든 placeholder 치환됐는지 확인
```

`setup.sh`는 동일 디렉토리에 `setup.env`가 있으면 자동으로 source합니다. `setup.env`는 .gitignore에 추가하거나 해당 vault 안에서만 보관하세요 (절대경로 노출 가능).

### C. Inline env vars (CI/one-shot)

env file 두지 않고 일회성으로:

```bash
PROJECT_NAME=My_Vault \
DOMAIN_NAME=Marketing \
PRIMARY_DOMAINS="IT 제품 기획, 의사결정 분석" \
RECURRING_TASKS="" \
VAULT_ABS_PATH="$(pwd)" \
./setup.sh
```

### Validation rules (요약)

| 변수 | 규칙 | 예시 |
|---|---|---|
| `PROJECT_NAME` | `^[A-Za-z][A-Za-z0-9_]*$` (공백/한글 X) | `My_Vault`, `MyVault` |
| `DOMAIN_NAME` | `^[A-Z][A-Za-z]*$` (단일 PascalCase, `_`/숫자 X) | `Marketing`, `Engineering` |
| `PRIMARY_DOMAINS` | 1–200 chars, `<>&` 금지 (한글 OK) | `"IT 제품 기획, 의사결정 분석"` |
| `RECURRING_TASKS` | optional, 빈 문자열 또는 `(skip)` | `"주간 회고"` 또는 `""` |
| `VAULT_ABS_PATH` | 존재하는 디렉토리 절대경로 | `$(pwd)` 또는 `/Users/me/my-vault` |

## 3. 환경 의존성 점검

| 의존성 | 필수도 | 없을 때 영향 |
|---|---|---|
| `claude` CLI | 필수 | port-vault skill, hooks, subagents 모두 작동 안 함 |
| bash 4+ | manual mode 필수 | setup.sh 작동 안 함 |
| `sed` (POSIX) | manual mode 필수 | placeholder 치환 작동 안 함 |
| `jq` | optional | session-start hook의 CHANGELOG tail 출력 안 됨 |
| `git` | 권장 | initial commit, version tracking 안 됨 |
| **CronCreate (Claude Code)** | optional | `revisit-reminder` skill의 자동 알림 안 됨 → manual fallback (사용자가 직접 cron 등록)만 가능 |
| Python 3.8+ | optional | `scripts/fetch_research.py` 자동 research feed 안 됨 |

## 4. 디렉토리 구조

```
.
├── CLAUDE.md                          (프로젝트 instructions, 매 세션 자동 로드)
├── VERSION                            (template 버전, e.g., 0.1.0)
├── SETUP.md                           (이 파일)
├── <Domain>_Context.md                (도메인 layer; setup 시 채워짐)
├── Multi_Agent_Debate_Prompt.md       (멀티에이전트 토론 프롬프트, 도메인 무관)
├── Core_Thinking_Protocol.md          (6단계 spec)
├── Stage_Transition_Rules.md          (단계 전환 규칙)
├── Research_Integration_Protocol.md   (연구 통합 6-step protocol)
├── .claude/
│   ├── settings.json                  (permissions, hooks)
│   ├── agents/                        (6 subagents)
│   ├── skills/                        (14 skills)
│   └── hooks/                         (3 hook scripts)
├── 00_Idea_Inbox/                     (free-capture, System 1 모드 허용)
├── 03_Knowledge_Base/                 (4축 + Cross_Cutting + Meta_Lessons aggregator)
├── 04_Archives/decisions/             (Decision + Compound 문서, 영구 보관)
├── 04_Archives/{plugin_analysis,research_rejected}/   (보조 archive)
├── 05_Framework_Templates/            (7개 framework templates)
└── scripts/fetch_research.py          (자동 research feed, 선택 사용)
```

> **참고:** Source vault에는 15개 skills이 있고 (`port-vault`는 bootstrap 전용), 설치된 template에는 14개가 있습니다. 이 차이는 의도된 것입니다 — 새로 만든 vault는 자기 자신을 또 setup할 필요가 없으므로 `port-vault` skill을 가질 필요가 없습니다.

## 5. 첫 결정 dogfood (15분)

**Small decision 1건**으로 압축 플로우 (Frame → Converge → Decide, Incubate skip) 시도. Right-size 기준: 가역적, 1축, 단일 이해관계자.

예시:
- "이번 주 어떤 책을 읽을까"
- "이 함수를 refactor할까 말까"
- "다음 회의에 어떤 안건을 가져갈까"

**절차:**
1. Claude Code에서: `framer subagent를 호출해서 [your decision]을 frame해줘`
2. framer가 problem statement + scope + success criteria 생성
3. Right-size = "small" 판정되면 자동으로 Diverge skip → Converge로
4. validator subagent가 candidates 평가 (bias-check, premortem-analysis, causal-reasoning-check)
5. presenter가 결정 문서 생성 → `04_Archives/decisions/Decision_<date>-<slug>.md`
6. 1줄 Compound learning을 paired `Compound_<date>-<slug>.md`에 저장

결과 검증:
```bash
ls 04_Archives/decisions/
# Expected: Decision_<date>-<slug>.md, Compound_<date>-<slug>.md
```

## 6. Anti-patterns 체크 (사용 전 필독)

CLAUDE.md §Anti-Patterns 8건 요약:

1. **No extrapolation beyond KB** — `근거 없음` 라벨 사용 (출처 없는 심리/신경과학 주장 금지)
2. **No stage-skipping under time pressure** — "빨리"는 right-size 체크 트리거
3. **No unconditional agreement in Converge** — validator는 반대 주장 또는 null result로 시작
4. **No writing to `03_Knowledge_Base/` without protocol** — Research Integration Protocol 통과 필수
5. **No framework name-dropping** — SCAMPER/JTBD는 sub-step 실제 산출물 필수
6. **No speculative engineering** — 구체 문제 시연 없이 spec 변경 금지
7. **No silent TEST MODE** — 3-part activation 필수 ("TEST MODE" + `TEST_` filename + `status: test-mode` frontmatter)
8. **No affordance leak into Diverge or Converge** — Co-Execution Scope는 Decide 단계에서만

## 7. Updating from a newer template version

Source vault가 진화하면 새 template 버전이 출시됩니다. 자동 merge는 **없습니다** — Anti-Pattern #6 준수.

절차:
1. Source vault의 `_template/CHANGELOG.md` 확인 (git pull 또는 download)
2. 자기 프로젝트 VERSION과 비교: `cat VERSION`
3. 각 새 entry의 `Migration:` 필드 따라 수동 적용
4. 자기 프로젝트 VERSION 갱신

자기 customization (Domain Context, 추가 KB notes, 자기 dogfood 결과)이 새 template과 충돌하면 **자기 customization 우선**.

## 8. Watch list — 모니터링만, 트리거 시에만 액션

이 template은 source vault의 Phase 4-5 dogfood + 리뷰에서 발견된 12 항목을 Watch list로 가집니다. **각 항목은 트리거 조건 발생 전까지 spec 변경 안 함** (Anti-Pattern #6).

자세한 항목은 `_template/CHANGELOG.md` 참조 또는 source vault의 `docs/superpowers/plans/phase-1-forward-refs.md`.

핵심 모니터링 영역:
- field-count drift (구조적 카운트 변경 시 grep 전파 필요)
- political over-weighting (비즈니스 도메인 dogfood에서 정치 고려 과적합)
- caller restriction honor-system (revisit-reminder, diverge-compression이 의도된 caller가 아닌 곳에서 호출되는지)
- multi-axis Compound 배치 규칙 (3-axis 이상 spanning 시 정책 미정의)

## 9. Troubleshooting

| 증상 | 원인 | 해결 |
|---|---|---|
| "skill not found: port-vault" | source vault 외부에서 호출 (template 안에는 없음) | source vault 위치에서 호출 |
| "skill not found: <other>" | `.claude/skills/` 경로 또는 권한 문제 | `ls .claude/skills/` 확인, 14개 모두 있는지 |
| Hook 안 발동 | `.claude/settings.json`의 hook command 절대 경로 오류 | `$CLAUDE_PROJECT_DIR` 사용 확인 |
| "permission denied on Read" | `.claude/settings.json` permissions에 vault path 누락 | `setup.sh --verify`로 placeholder 치환 확인 |
| Research feed 빈 상태 | `scripts/fetch_research.py` 미실행 | 수동 `python3 scripts/fetch_research.py` |
| `setup.sh: command not found` | 실행 권한 없음 | `chmod +x setup.sh` |

## 10. License & attribution

- 이 template은 Business_SecondBrain vault 기반 (date: 2026-04-24).
- 신경과학 KB seed notes는 cited research 인용 — 사용자가 자기 KB 추가 시 동일 원칙 따라야 합니다.
- License: TBD by source vault maintainer (현재 명시되지 않음).

## 다음 단계

1. **`<Domain>_Context.md` 직접 작성** — skill이 placeholder만 남김
2. **첫 small decision dogfood** — §5 절차
3. **Watch list 모니터링** — §8 영역에서 트리거 발생 시 source vault 알림

이 vault는 **Anti-Pattern #6 (no speculative engineering)**을 따릅니다. 구체적 문제가 발생하지 않은 채 spec을 변경하지 마세요.

## Migration & rollback (v0.4+)

This vault uses a hybrid distribution model from v0.4.0:
- **Vault scaffold** (this repo) ships user-layer + bootstrap
- **Plugin** (`bm1120/thinking-protocol-plugin`) ships system layer (skills/agents/hooks/Core protocol/fetch script)

### Migration from v0.1-0.3

If your vault was created before v0.4.0:

1. `claude` (start session in vault)
2. `/plugin install bm1120/thinking-protocol-plugin`
3. `/migrate` — auto-detects existing vault, creates `_backup/<timestamp>/`, overwrites system files with v0.4.0 versions
4. Run: `./setup.sh --verify`
5. If 8/8 PASS: migration successful
6. If failure: `cp -rp _backup/<timestamp>/. . && ./setup.sh --verify` (rollback)

### Updating

```
/plugin update
/migrate
```

`/migrate` is idempotent: same backup+overwrite logic. Forked system files (frontmatter `system: false`) are preserved.

### Forking a system file

To customize a system file without losing your changes on plugin update:
1. Open the file (e.g., `.claude/agents/researcher.md`)
2. Change frontmatter `system: true` → `system: false`
3. Optionally add `forked_from: <plugin_version>`
4. Edit freely. `/migrate` will skip this file.

### Rollback

The most recent `/migrate` invocation creates a backup at `_backup/<timestamp>/`.
- Rollback: `cp -rp _backup/<timestamp>/. .` (note trailing `/.` for dotfiles)
- After rollback, optionally: `/plugin uninstall thinking-protocol-plugin`

Backups accumulate; prune manually if needed (e.g., `rm -rf _backup/2026-*`).
