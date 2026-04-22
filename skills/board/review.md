# board review — Cross-Module Board Review

See `shared/review-standards.md` for review protocol, impact classification (B1/B2/B3), and quality framing.
See `shared/scoring-rubrics.md` Section 3 for the 10-point board scale and completion criteria.

Cross-module board review. Reads all module `REVIEW_PANEL.md` files and
`MODULE.md` files, assembles 7-member board, produces `REVIEW_BOARD.md`.

**Prerequisites:**
- 2+ modules with completed `REVIEW_PANEL.md` (from `panel:module review`)
- Panel reviews must be substantive (not placeholders)

**Flow:**

1. **Resolve repo**: find monorepo root
2. **Discover modules**: scan all configured projects for completed `REVIEW_PANEL.md`
3. **Load cross-module track map** via `discoverCrossModuleTracks()`:
   - Scan all `MODULE.md` files for track definitions
   - Identify tracks spanning multiple modules
   - Assess alignment: `aligned` | `subset` | `parallel` | `divergent` | `unique`
4. **Select 7-member board**: shared/board-utils.select_board()
   - Round 1: fresh selection
   - Round 2+: retain 5 core, rotate 2
5. **Load profiles**: `loadReviewerProfile()` + `buildReviewerContext()` for all 7
6. **Generate assessments**: each board member reviews all module panels
   - Read each module's `REVIEW_PANEL.md` and `MODULE.md`
   - Inject OLE context string as reviewer persona
   - Assess module quality (10-point scale)
   - Assess cross-module track alignment:
     - `aligned` → program strength, cite explicitly
     - `divergent` → B1 candidate: conflicting chain logic
     - `parallel` → B2 candidate: papers should cite each other
     - `subset` → depth signal (good)
   - Identify cross-module themes and synergies
   - Rank modules within the program
7. **Synthesize** into `REVIEW_BOARD.md`:
   - Program score and tier
   - Module rankings with consensus and agreement matrix
   - **Cross-module track map**: alignment status per track
   - Cross-module themes (derived from track alignment + panel findings)
   - Per-module assessments
8. **Generate per-module revision plans**: `BOARD-REVISION-PLAN-{module}.md`
   - B1/B2/B3 items **tagged to tracks** where applicable:
     - `B1 [Track methodology]` — divergent track logic across modules
     - `B2 [Track empirical, alpha + beta]` — parallel papers should cite each other
     - `B3 [module]` — module-level item
9. **Snapshot round** to `board-reviews/round-{N}/` with MANIFEST.md
10. **Report**:

```
panel:board review
═══════════════════════════════════════════════════════════════════════

Board Review — Round 1

Modules reviewed:
  module-alpha   Score: 7.2/10 (B+)   Tier: Solid
  module-beta    Score: 7.8/10 (A-)   Tier: Strong
  module-gamma   Score: 8.1/10 (A-)   Tier: Strong

Program score: 7.7/10 (A-)

Cross-module tracks:
  Track methodology   alpha + beta    aligned ✓    (program strength)
  Track empirical     beta + gamma    parallel ⚠   (B2: add cross-citations)
  Track theory        alpha only      unique        (no cross-module implication)

B1 items (blocking): 1
  B1.1 [Track empirical] beta + gamma parallel papers need cross-citation framework

B2 items (important): 3
B3 items (nice-to-have): 2

Revision plans written:
  BOARD-REVISION-PLAN-module-alpha.md
  BOARD-REVISION-PLAN-module-beta.md
  BOARD-REVISION-PLAN-module-gamma.md

Archived: board-reviews/round-1/
Next: modules address B1 items → panel:module review (round 2) → panel:board review (round 2)
```
