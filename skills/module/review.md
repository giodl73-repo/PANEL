# panel:module review

See `shared/review-standards.md` for review protocol, impact classification (PP1/PP2/PP3), and quality framing.
See `shared/scoring-rubrics.md` Section 2 for the 10-point module scale and three properties.

## `review [modules]`

Cross-portfolio panel review. Assembles 7-member panel, generates REVIEW_PANEL.md
with track scores, PP1/PP2/PP3 items tagged to tracks, cross-module track map.

**Single module**: `panel:module review`
**Multiple**: `panel:module review alpha beta`
**All**: `panel:module review --all`

**Prerequisites per module:**
- 2+ papers at `recheck` stage or beyond
- Passing scores (avg >= 2.5/4, min >= 2/4)

**Flow** (per module):

1. **Assess readiness**: check papers via shared/panel-utils.assess_paper_readiness()
2. **Load module architecture**: read `MODULE.md` via shared/module-utils.md
   - Extract track definitions, paper-to-track assignments
   - Identify orphan papers — include but flag
   - Discover cross-module tracks via `discoverCrossModuleTracks()`
3. **Select 7-member panel**: shared/panel-utils.select_cross_portfolio_panel()
   - Round 1: fresh selection
   - Round 2+: retain 5 core, rotate 2
4. **Load profiles**: `loadReviewerProfile()` + `buildReviewerContext()` for all 7
5. **Generate assessments**: each member reviews all ready papers
   - Inject OLE context string as reviewer persona
   - Assess paper quality (10-point scale)
   - Assess each track's causal chain integrity
   - Rank papers within module
6. **Synthesize** into `REVIEW_PANEL.md`:
   - Module score and tier
   - Track scores (score, chain health, weak links per track)
   - Cross-module tracks (tracks spanning this module and others)
   - Paper rankings with consensus
   - PP1/PP2/PP3 items tagged to tracks
7. **Write `PANEL-REVISION-PLAN.md`**: PP items with track tags, open checkboxes
8. **Update MODULE.md**: write track scores back via `updateTrackScore()`
9. **Archive**: snapshot to `panel-reviews/round-{N}/` (includes MODULE.md)
10. **Offer to apply**: PP1/PP2 items immediately

**Bulk** (multiple modules): runs sequentially, shared progress report at end.

```
panel:module review --all
═══════════════════════════════════════════════════════════════════════

Running module review on 3 modules...

[1/3] module-alpha   Round 1 -> REVIEW_PANEL.md ✓  Score: 7.2/10 (B+)
[2/3] module-beta    Round 1 -> REVIEW_PANEL.md ✓  Score: 6.8/10 (B+)
[3/3] module-gamma   Skipped — only 1 paper at recheck (needs 2+)

Done. 2/3 modules reviewed.
Cross-module tracks found: Track A spans module-alpha + module-beta (aligned ✓)
Next: panel:board review
```
