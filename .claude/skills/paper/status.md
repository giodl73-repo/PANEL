# panel:paper status

## `status [targets]`

Show stage, round, score, and next action for papers.

**All papers**: `panel:paper status`
**Track**: `panel:paper status --track empirical`

```
panel:paper status
═══════════════════════════════════════════════════════════════════════

Module: reviewer-simulation
Research: research/reviewer-simulation/

 #  Paper                         Track(s)   Stage      Round  Score   Next
 ─  ────────────────────────────  ─────────  ─────────  ─────  ──────  ────────────────
 1  panel-token-efficiency        A, C       recheck    1      2.8/4   panel:module review
 2  panel-profile-caching         A, B       revision   1      —       Apply P1 items
 3  panel-ole-injection           B          synthesis  1      —       Generate SYNTHESIS
 4  panel-cross-venue-analysis    C          draft      0      —       panel:paper author
 5  panel-calibration-study       B, C       draft      0      —       plan.md missing ⚠

Track coverage:
  Track A: 2 papers (panel-token-efficiency → panel-profile-caching) ✓
  Track B: 3 papers (panel-profile-caching → panel-ole-injection → panel-calibration-study) partial
  Track C: 3 papers (panel-token-efficiency → panel-cross-venue-analysis → ?) broken — needs paper-3

Orphan papers: none
```
