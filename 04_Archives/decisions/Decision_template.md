---
status: decided
date: YYYY-MM-DD
tags: [decision, <domain-tags>]
right-size: small | non-trivial
protocol-path: Frame->Diverge->Incubate->Illuminate->Converge->Decide   # or Frame->Converge->Decide for small
---

# 결정: <decision title>

## 1. Decision (한 문장)
<commit to one sentence — no hedging>

## 2. Rationale (3 bullets)
- <reason 1, referencing a Converge survivor or rejected alternative by name>
- <reason 2>
- <reason 3>

## 3. First action (단일 차기 단계)
- **Owner**: <who>
- **Trigger**: <when — date or condition>
- **Action**: <what — single concrete step>

## 4. Risks retained (1–3)
- <risk 1 you chose to accept, not a risk you mitigated>
- <risk 2>
- <risk 3>

## 5. Compound learning (1줄)
> Next time this decision type comes up, remember: <insight>.

(Also surface this same line in a paired `Compound_<date>-<slug>.md` file — see Compound_template.md.)

## 6. Co-Execution Scope (CLAUDE.md Anti-Pattern #8: Decide-only)

| Component | Tier | 근거 1줄 |
|---|---|---|
| <component 1> | AI 단독 / AI 보조 / 사용자 단독 | <one-line rationale> |
| ... | ... | ... |

*(Table rows: 1–7 typical, matching Frame's "3–7 items" precedent. For decisions with a single dominant component, the table can be omitted in favor of the 세부 3-tier 분류 list below.)*

### 세부 3-tier 분류

- **✅ AI 단독 가능 (자동화/AI only)**
  - <task list>
- **🤝 AI 보조 가능 (사용자 입력 필요)**
  - <task list>
- **❌ 사용자 단독 (AI 부적합)**
  - <task list>

**예상 첫 실행 단위 (AI 협업 시)**: <30~60min step that begins execution>

**Compound learning hook**: <what gets learned from running the first execution unit>

## 7. Rejected Alternatives (간단)
- <alt 1>: <one-line reason for rejection>
- <alt 2>: <one-line reason>

## 8. Causal traceability (CLAUDE.md §3 + Anti-Pattern #1)
For any cause-and-effect claim in §2 Rationale or §5 Compound learning:
- Causal claim: <e.g., "X will reduce Y by Z%">
- Source: traces to Converge candidate <name>; OR `근거 없음` (no `03_Knowledge_Base/` source).

## 9. Retrospective Trigger
- **<date or condition>**: <what to re-measure>
- Failure-mode actions: double-down / pivot / abort with leading indicators per `validator` premortem output.
