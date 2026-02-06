# Stage Machine — Stage Progression Logic

Shared utility for managing stage transitions in the panel review lifecycle.

## Stage Definitions

The 8 stages are defined in `config/stages.yaml`. This module implements the progression logic.

## Stage Order

```
draft → panel → synthesis → revision → recheck → ready → submit → accepted
                    ↑                       |
                    └───────────────────────┘  (loop if gate fails)
```

## Gate Checking

Each stage has a gate condition that must pass before advancing:

### check_gate(paper_dir, stage)

```
Input:  paper directory path, current stage name
Output: { passed: bool, reason: string, details: object }
```

| Stage | Gate Check |
|-------|-----------|
| draft | `main.tex` exists AND `_panel.yaml.venue` is non-empty |
| panel | Count `reviews/REVIEW-*.md` files >= 5 |
| synthesis | `reviews/SYNTHESIS.md` exists AND contains P1/P2/P3 sections |
| revision | All items in `_panel.yaml.p1_items` have `addressed: true` |
| recheck | Average score >= 2.5/4 AND minimum score >= 2/4 |
| ready | `REVIEW_PANEL.md` exists in parent (if multi-paper module) OR single-paper mode |
| submit | User confirmation flag in `_panel.yaml` |
| accepted | User confirmation flag in `_panel.yaml` |

## Stage Advancement

### advance(paper_dir, current_stage, options)

```
Input:  paper directory, current stage, { dry_run, until_stage }
Output: { new_stage: string, actions_taken: string[], history_entry: object }
```

1. Check gate for current stage
2. If gate fails: return error with reason
3. If gate passes: determine next stage
4. If at `recheck` and gate fails: set next stage to `synthesis` (loop)
5. If `--until` specified and next stage > until: stop
6. Execute stage handler for next stage
7. Update `_panel.yaml` via shared/state-loader.md
8. Return transition details

## Stage Handlers

Each stage handler performs the work needed at that stage:

- **draft_handler**: Verify paper structure, prompt for venue if missing
- **panel_handler**: Select reviewers (shared/reviewer-selector.md), generate reviews
- **synthesis_handler**: Consolidate reviews (shared/synthesis-engine.md)
- **revision_handler**: Create REVISION-PLAN.md, track P1 items
- **recheck_handler**: Generate round N reviews, calculate scores
- **ready_handler**: Trigger cross-portfolio panel if applicable
- **submit_handler**: Prompt for submission confirmation
- **accepted_handler**: Prompt for acceptance confirmation

## Re-entrancy

The stage machine is fully re-entrant:
- Reads current state from `_panel.yaml` on every invocation
- Never assumes previous state — always checks artifacts on disk
- Safe to interrupt and resume at any point
- Multiple invocations of `panel:go` will pick up where the last one stopped
