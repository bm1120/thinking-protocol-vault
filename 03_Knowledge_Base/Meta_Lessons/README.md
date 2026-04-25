---
tags:
  - knowledge_base
  - meta_lessons
  - cross_cutting
date: 2026-04-24
status: aggregator
---

# Meta_Lessons/

Aggregates reusable principles extracted across multiple Compound learning files in `04_Archives/decisions/`.

## What lives here

- `Index.md` — wikilink index of all Compound files in `04_Archives/decisions/`, grouped by axis (Decision-Making / Problem-Solving / Causal Reasoning / Creativity).
- `<extracted-pattern-slug>.md` — extracted patterns (one per pattern). Created when ≥ 3 Compound files share a theme.

## What does NOT live here

- Original Compound files — those stay in `04_Archives/decisions/` paired with their source Decision.
- Knowledge derived from external research — that stays in the 4 axis directories under `03_Knowledge_Base/`.

## Extraction policy

A new file in this directory is justified only when **3 or more Compound files share a recurring principle**. The extraction process:

1. Read all candidate Compound files.
2. State the shared principle in 1–2 sentences (must be more general than any single Compound's wording).
3. List the source Compounds via wikilinks.
4. List counter-conditions where the principle does NOT apply (each Compound's "반대 신호" section is the input).
5. Map to the 6-stage protocol: at which stage(s) does this principle change behavior?
6. Add to `Index.md` under the appropriate axis section.

## Extraction template

```markdown
---
tags:
  - meta_lesson
  - extracted
  - <axis>
  - <domain-tags>
date: YYYY-MM-DD
status: extracted
sources:
  - "[[Compound_YYYY-MM-DD-<slug-1>]]"
  - "[[Compound_YYYY-MM-DD-<slug-2>]]"
  - "[[Compound_YYYY-MM-DD-<slug-3>]]"
---

# <Pattern title>

## 원칙 (1–2 sentences)
<the generalized principle, more general than any single source>

## 적용 조건
- <condition 1>
- <condition 2>

## 반대 신호
- <where this principle does NOT apply>
- ...

## 6단계 프로토콜에서의 역할
- Frame: ...
- Diverge: ...
- Converge: ...
- Decide: ...

## 출처 Compound 파일
- [[Compound_YYYY-MM-DD-<slug-1>]] (<one-line context>)
- [[Compound_YYYY-MM-DD-<slug-2>]] (<one-line context>)
- [[Compound_YYYY-MM-DD-<slug-3>]] (<one-line context>)

## 관련 Knowledge Base 항목 (Optional)
- [[03_Knowledge_Base/<axis>/<note>]] — <relationship>
```

## Why N=3 threshold for extraction?

- N=1: a single Compound is just a paired note about one decision; not yet a pattern.
- N=2: could be coincidence; small risk of premature abstraction (Anti-Pattern #6).
- N=3: a pattern that has manifested 3 independent times is strong enough signal to justify a separate file.

If a 2nd Compound emerges that *might* extract with the 1st, add a comment to the Compound file's "Aggregation status" section noting the candidate, but do NOT extract yet.

## Relationship to 4 research axes

Extracted patterns are tagged with one or more of the 4 axes (Decision-Making / Problem-Solving / Causal Reasoning / Creativity) plus `Cross_Cutting` if they span axes. The Index groups by axis to surface clusters.
