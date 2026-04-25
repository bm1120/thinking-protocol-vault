---
tags:
  - knowledge
  - causal_reasoning
  - statistics
date: 2026-04-24
status: seed
---

# 상관 vs 인과 (Correlation vs Causation)

> **Seed note.** 이 노트는 Phase 2에서 Core 프로토콜의 근거 링크 타겟으로 생성된 시드입니다. 내용은 Research Integration Protocol을 통해 점진적으로 채워집니다.

## 한 줄 요약

상관관계와 인과관계의 혼동은 의사결정에서 가장 빈번하고 가장 비싼 오류 유형이며, 구별의 기준은 개입(intervention)에 대한 결과의 안정성이다.

## 핵심 개념 (Key concepts)

- Pearson correlation은 두 변수의 선형 공변만 포착하며, 혼입변수·역인과·우연한 공변 모두와 구분하지 못한다.
- Pearl의 do-calculus는 관찰 분포 P(Y|X)와 개입 분포 P(Y|do(X))를 구분해, 인과 주장의 수학적 의미를 명확히 한다.
- 관찰 연구는 혼입을 통제하지 못하므로 인과 주장을 뒷받침하기 어렵고, 실험(RCT)이나 준실험 설계가 필요하다.
- 기업 의사결정에서는 상관 패턴을 그대로 정책으로 전환하는 실수(예: "성과 좋은 팀이 X를 쓴다 → 전사적으로 X 도입")가 흔하다.

## 6단계 프로토콜에서의 역할

Converge와 Decide 단계의 '인과 타당성 검토' 체크리스트 항목의 근거. `validator`의 `causal-reasoning-check` 스킬(Phase 3 예정)이 이 노트를 핵심 참조로 삼음.

## 추가 연구 필요

- Instrumental variable, regression discontinuity 등 준실험 기법 개요
- 비즈니스 맥락에서의 A/B 테스트 설계 함정

## 관련 링크

- [[Counterfactuals_and_DAGs]]
- [[Causal_Illusions_and_Biases]]
