# Help: The 8-Stage Review Lifecycle

The panel plugin drives papers through 8 stages from initial draft to venue acceptance.

## Stage Overview

```
1. draft     → Paper exists, target venue identified
2. panel     → 5+ reviewers assigned, individual reviews generated
3. synthesis → Reviews consolidated with P1/P2/P3 priority tiering
4. revision  → Author revises based on synthesis findings
5. recheck   → Round N reviews; loops to synthesis if scores insufficient
6. ready     → All reviewers Accept; cross-portfolio panel complete
7. submit    → Paper submitted to target venue
8. accepted  → Paper accepted at venue
```

## Stage Details

### 1. Draft
**Gate**: `main.tex` exists AND venue set in `_panel.yaml`
**What happens**: Paper exists in a directory with LaTeX source. Author sets the target venue.
**Artifacts**: main.tex, sections/

### 2. Panel
**Gate**: 5+ `REVIEW-*.md` files in reviews/
**What happens**: Reviewers are selected from the database. Each reviewer generates an individual review with a score (1-4) and detailed feedback.
**Artifacts**: reviews/REVIEW-{NAME}.md

### 3. Synthesis
**Gate**: `SYNTHESIS.md` exists with P1/P2/P3 classification
**What happens**: All reviews are consolidated into a single synthesis document. Issues are classified by priority.
**Artifacts**: reviews/SYNTHESIS.md

### 4. Revision
**Gate**: All P1 items marked `addressed: true` in `_panel.yaml`
**What happens**: Author creates a revision plan and implements changes to address P1 (blocking) and P2 (important) items.
**Artifacts**: REVISION-PLAN.md, updated sections/

### 5. Recheck
**Gate**: Average score >= 2.5/4, no individual score < 2/4
**What happens**: Reviewers re-review the revised paper. Scores are updated. If scores don't meet threshold, loops back to synthesis for another round.
**Artifacts**: reviews/ROUND{N}-REVIEW-*.md, reviews/ROUND{N}-SYNTHESIS.md

### 6. Ready
**Gate**: REVIEW_PANEL.md exists (multi-paper modules)
**What happens**: Paper has passed all review rounds. For multi-paper modules, a cross-portfolio panel ranks papers.
**Artifacts**: REVIEW_PANEL.md

### 7. Submit
**Gate**: User confirms submission
**What happens**: Paper is submitted to the target venue. User confirms the submission.

### 8. Accepted
**Gate**: User confirms acceptance
**What happens**: Paper is accepted at the venue. Lifecycle complete.

## The Recheck Loop

If at stage 5 (recheck) the scores don't meet thresholds, the paper loops back to stage 3 (synthesis) for another round of review. This can repeat until scores pass or the author decides to change venues.

```
recheck (scores fail) → synthesis → revision → recheck (try again)
```
