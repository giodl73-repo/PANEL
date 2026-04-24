# panel:module status

## `status [modules]`

Track health, paper coverage, PP item progress.

```
panel:module status
═══════════════════════════════════════════════════════════════════════

Module: reviewer-simulation | Round 1 | Score: 7.2/10 (B+)

Track Health:
  Track A (methodology)   Score: 7.8  Chain: Strong  Weak links: none    Numbers: 3/3 ✓
  Track B (empirical)     Score: 6.9  Chain: Partial  Weak link: paper-3  Numbers: 2/3 ⚠
  Track C (theory)        Score: —    Chain: Broken   (paper-5 missing)   Numbers: 1/2 ✗

Paper Coverage:
  paper-1  Tracks: A, C   Stage: recheck  Round: 1  Score: 2.8/4
  paper-2  Tracks: A, B   Stage: revision Round: 1  Score: —
  paper-3  Track:  B      Stage: draft    Round: 0  Score: — ⚠ weak link
  paper-4  Tracks: B, C   Stage: recheck  Round: 1  Score: 2.6/4
  paper-5  Track:  C      Stage: planned  (not yet created)

Orphan papers: none

PP Progress:
  PP1 items: 2 total — 1 addressed ✓, 1 open
  PP2 items: 3 total — 0 addressed
  PP3 items: 2 total

Cross-module tracks:
  Track A also in: module-beta (aligned ✓)
```
