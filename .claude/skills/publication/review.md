# panel:publication review

### `review [targets]`

Full review lifecycle. Advances each publication through its current stage gate.

```
panel:publication review                       # all eligible
panel:publication review token-efficiency      # single
panel:publication review --until ready         # run until ready stage
panel:publication review --track empirical     # all in track
```

**Stage lifecycle:**

| Stage | Gate | Action |
|-------|------|--------|
| `draft` | main.tex + venue set | Select 5 reviewers, load OLE profiles, assign |
| `panel` | 5+ reviews | Generate `reviews/REVIEW-{NAME}.md` via `buildReviewerContext()` |
| `synthesis` | SYNTHESIS.md | Consolidate → P1/P2/P3 |
| `revision` | P1 items addressed | Create REVISION-PLAN.md, offer to apply |
| `recheck` | avg ≥ 2.5, min ≥ 2 | Round N review cycle |
| `ready` | module panel complete | Awaiting `panel:module review` |
| `submit` | venue confirmed | Submitted |
| `accepted` | acceptance confirmed | Done |

**Reviewers**: loaded from `.craft/roles/panel-reviewer/` via `pluginReviewersPath`.
All reviews use `buildReviewerContext(profile)` — OLE preamble + structured fields.

**Bulk**: each publication advances independently. Gate failures reported but don't
block other publications.
