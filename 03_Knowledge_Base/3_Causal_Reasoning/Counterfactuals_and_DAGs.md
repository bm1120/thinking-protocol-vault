---
tags:
  - knowledge
  - causal_reasoning
  - pearl
date: 2026-04-24
status: seed
---

# 반사실과 DAG (Counterfactuals and DAGs)

> **Seed note.** 이 노트는 Phase 2에서 Core 프로토콜의 근거 링크 타겟으로 생성된 시드입니다. 내용은 Research Integration Protocol을 통해 점진적으로 채워집니다.

## 한 줄 요약

반사실(counterfactual) 추론과 Directed Acyclic Graph(DAG) 표현은 인과 주장을 명시화하고 혼입변수(confounder)를 찾아내는 두 가지 핵심 도구이다.

## 핵심 개념 (Key concepts)

- Judea Pearl의 ladder of causation은 association(관찰), intervention(do), counterfactual(만약 ~했다면)의 세 층으로 인과 추론의 위계를 구분한다.
- DAG의 기본 문법은 노드(변수), 방향 간선(직접적 인과), chain(A→B→C), fork(A←B→C), collider(A→B←C)로 구성된다.
- d-separation은 DAG 구조만으로 조건부 독립 관계를 읽어내는 규칙이며, 식별 가능성 판정의 출발점이다.
- Backdoor criterion은 X→Y 인과 효과 추정에 통제해야 할 변수 집합을 체계적으로 식별하는 기준이다.

## 6단계 프로토콜에서의 역할

Converge 단계에서 '이 판단의 인과 모델을 명시하라' 요구의 실행 방법. `bias-check` 스킬이 confounder check를 위해 참조.

## 추가 연구 필요

- Structural Causal Model(SCM)과 potential outcomes 프레임워크의 비교
- DAG 작성 시 자주 빠지는 함정(feedback loop, unobserved confounder)

## 관련 링크

- [[Correlation_vs_Causation]]
- [[Causal_Inference_in_the_Brain]]
