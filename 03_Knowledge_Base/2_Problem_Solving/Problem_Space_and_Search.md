---
tags:
  - knowledge
  - problem_solving
  - newell_simon
date: 2026-04-24
status: seed
---

# 문제 공간과 탐색 (Problem Space and Search)

> **Seed note.** 이 노트는 Phase 2에서 Core 프로토콜의 근거 링크 타겟으로 생성된 시드입니다. 내용은 Research Integration Protocol을 통해 점진적으로 채워집니다.

## 한 줄 요약

문제 해결은 'problem space' 내의 상태-공간 탐색으로 모델링되며, 초기 상태·목표 상태·허용 연산자의 정의가 해결 품질의 상한을 결정한다.

## 핵심 개념 (Key concepts)

- Newell & Simon의 problem space 이론은 인간 사고를 상태(state)와 연산자(operator)로 구성된 탐색 과정으로 본다.
- 초기 상태(initial state)와 목표 상태(goal state)가 모호하면 이후 어떤 탐색 전략도 방향을 잃는다.
- Means-ends analysis는 현재 상태와 목표 상태의 차이를 줄이는 연산자를 반복 적용하는 기본 전략이다.
- 표현(representation) 선택이 탐색 공간의 크기와 해결 난이도를 결정하므로, 문제 재표상은 강력한 해결 기법이다.

## 6단계 프로토콜에서의 역할

Frame 단계의 핵심 이론적 배경 — `framer` 서브에이전트가 problem statement·scope·success criteria를 정의하는 행위가 problem space의 초기/목표 상태·허용 연산자를 암묵적으로 설정하는 행위임.

## 추가 연구 필요

- ill-structured problem에서 problem space 이론의 한계
- 전문가-초보자 표현 차이 연구(Chi, Glaser)

## 관련 링크

- [[Analogical_Reasoning]]
- [[Prefrontal_Problem_Solving]]
