# 04_Archives/decisions/

Canonical store for all Decide-stage outputs (Decision documents) and their paired Compound learning notes.

## Filename convention

- **Decision:** `Decision_YYYY-MM-DD-<slug>.md`
- **Compound:** `Compound_YYYY-MM-DD-<slug>.md` (paired with the Decision of the same `<slug>`)
- **TEST MODE outputs:** stay in `00_Idea_Inbox/` with `TEST_` prefix per `Core_Thinking_Protocol.md#test-mode`. Never move TEST files here.

## Templates

- `Decision_template.md` — copy and fill for new Decisions.
- `Compound_template.md` — copy and fill for new Compound learning notes (paired with a Decision).

## Lifecycle

This is a flat archive — no subdirectories by status. Decisions stay here from creation through retrospective trigger and beyond.

If a Decision is later revised:
- Update its `status:` frontmatter from `decided` → `revised` and append a `## Revision YYYY-MM-DD` section. Do NOT move or duplicate the file.

If a Decision is abandoned (e.g., scope evaporated):
- Update `status:` to `archived` and append a one-line abandonment note. Keep the file.

## Why no separate `02_Decision_Records/`?

Phase 4 backlog originally proposed a separate `02_Decision_Records/` for "active" decisions vs `04_Archives/decisions/` for "closed". Phase 5 dogfood usage showed the active-vs-closed distinction is unnecessary — frontmatter `status:` is sufficient and avoids file relocation churn. See `docs/superpowers/plans/phase-1-forward-refs.md` Phase 5 design decision D1.

## Compound files: pairing vs aggregation

Compound files stay paired with their source Decision (next to it in this directory). Aggregated meta-lessons (patterns extracted across ≥ 3 Compound files) live in `03_Knowledge_Base/Meta_Lessons/` per `03_Knowledge_Base/Meta_Lessons/README.md`.
