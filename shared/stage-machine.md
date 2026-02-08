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
| revision | `REVISION-PLAN.md` exists AND (all items in `_panel.yaml.p1_items` have `addressed: true` OR `revision_declined: true` flag set) |
| recheck | Average score >= 2.5/4 AND minimum score >= 2/4 |
| ready | `REVIEW_PANEL.md` completed by `panel:convene` AND all PP1 items addressed |
| submit | User confirmation flag in `_panel.yaml` |
| accepted | User confirmation flag in `_panel.yaml` |

### Mode-Aware Gates

Content mode restricts maximum stage advancement:

| Content Mode | Terminal Stage | Blocked Stages |
|-------------|----------------|----------------|
| `abstract` | `synthesis` | Cannot advance past synthesis |
| `draft` | `revision` | Cannot advance past revision |
| `full` | `accepted` | No restrictions |

**Gate modification logic**:

```
function check_gate_with_mode(paper_dir, stage):
    mode = state['content_mode'] or 'full'

    # Check mode-based terminal stage
    if mode == 'abstract' and stage == 'synthesis':
        return {
            passed: false,
            reason: "Terminal stage for abstract mode",
            terminal: true,
            action: "Upgrade to draft/full mode to continue"
        }

    if mode == 'draft' and stage == 'revision':
        return {
            passed: false,
            reason: "Terminal stage for draft mode",
            terminal: true,
            action: "Upgrade to full mode to continue"
        }

    # Otherwise, run standard gate check
    return check_gate(paper_dir, stage)
```

**Terminal stage handling**:
- When reaching terminal stage for a mode, show upgrade instructions
- Synthesis verdict for abstract mode: "Concept Approved/Rejected"
- Revision verdict for draft mode: "Ready for Full Review"
- User can upgrade by editing `_panel.yaml.content_mode` and re-running

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
- **revision_handler**: MUST complete both phases before gate check: (1) Create or update REVISION-PLAN.md from synthesis P1/P2/P3 items, track P1 items in _panel.yaml; (2) Immediately use AskUserQuestion to offer revision application — if user accepts, edit sections/*.tex to address P1/P2 items and mark complete; if user declines, set revision_declined flag. The handler does NOT exit until user makes a choice.
- **recheck_handler**: Generate round N reviews, calculate scores
- **ready_handler**: Check REVIEW_PANEL.md from panel:convene, verify PP1 items addressed
- **submit_handler**: Prompt for submission confirmation
- **accepted_handler**: Prompt for acceptance confirmation

## Re-entrancy

The stage machine is fully re-entrant:
- Reads current state from `_panel.yaml` on every invocation
- Never assumes previous state — always checks artifacts on disk
- Safe to interrupt and resume at any point
- Multiple invocations of `panel:review` will pick up where the last one stopped
