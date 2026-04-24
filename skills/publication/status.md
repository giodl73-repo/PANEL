# panel:publication status

### `status [targets]`

```
panel:publication status
═══════════════════════════════════════════════════════════════════════

Module: reviewer-simulation | Publications

 #  Publication                    Track(s)  Stage      Rd  Score   Next
 ─  ──────────────────────────────  ──────── ─────────  ──  ──────  ────────────────────
 1  panel-token-efficiency          A, C     recheck    1   2.8/4   panel:module review
 2  panel-profile-caching           A, B     revision   1   —       Apply P1 items
 3  panel-ole-injection             B        synthesis  1   —       Generate SYNTHESIS.md
 4  panel-cross-venue               C        draft      0   —       panel:publication author

Track coverage (publications only):
  Track A: panel-token-efficiency → panel-profile-caching ✓
  Track B: panel-profile-caching → panel-ole-injection ✓
  Track C: panel-token-efficiency → panel-cross-venue (partial — 1 paper in track C also)
```
