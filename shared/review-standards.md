# Review Standards — Shared Review Protocol

Common review standards used by `panel:paper review`, `panel:publication review`, `panel:module review`, and `panel:board review`. All tiers follow the same core protocol; the scope and impact classification differ.

## Review Lifecycle

The review lifecycle is identical for papers and publications:

```
draft → panel → synthesis → revision → recheck → ready → submit → accepted
                    ↑                       |
                    └───────────────────────┘  (loop if gate fails)
```

### Stage Gates

| Stage | Gate | Action |
|-------|------|--------|
| `draft` | main.tex/paper.md exists + venue set | Select 5 reviewers, load profiles, assign |
| `panel` | 5+ reviews exist | Generate `REVIEW-{NAME}.md` per reviewer using `buildReviewerContext()` |
| `synthesis` | SYNTHESIS.md exists | Consolidate reviews → P1/P2/P3 tiering |
| `revision` | All P1 items addressed | Create REVISION-PLAN.md, apply edits |
| `recheck` | avg >= 2.5/4, min >= 2/4 | Round N review cycle |
| `ready` | Panel review complete | PP1 items addressed, cleared for submission |
| `submit` | User confirms submission | Submission recorded |
| `accepted` | User confirms acceptance | Done |

See `config/stages.yaml` for canonical definitions and `shared/stage-machine.md` for gate logic.

## Reviewer Selection

### Paper Level (5 reviewers)

1. Match paper's venue and keywords against reviewer database
2. Select 5 reviewers with diverse expertise (at least 2 categories represented)
3. Prefer reviewers with experience at the target venue
4. Load persistent profiles via `shared/reviewer-profile-loader.md`
5. Store profile references in `_panel.yaml.reviewers[].profile_ref`

### Module Level (7 panel members)

1. Round 1: fresh selection from reviewer database
2. Round 2+: retain 5 core members, rotate 2 for fresh perspective
3. Cross-portfolio coverage: members should span the module's paper topics
4. Load profiles at session start, cache for reuse across all papers

### Board Level (7 board members)

1. Same rotation pattern as module level
2. Members should span the breadth of all modules being reviewed
3. Include at least one member per major research area

See `shared/reviewer-selector.md` for selection algorithm.

## Review Generation

Each review follows the template in `templates/review-template.md`:

1. **Load reviewer profile**: `loadReviewerProfile(name)` from `shared/reviewer-profile-loader.md`
2. **Build context**: `buildReviewerContext(profile)` — constructs the full persona context:
   - Research background and expertise
   - Evaluation lens (characteristic questions)
   - Review criteria checklist
   - Characteristic concerns
   - Voice and tone descriptors
3. **Generate review**: Using the reviewer context, assess the paper against:
   - Overall quality and contribution
   - Methodology rigor
   - Evidence strength
   - Clarity and presentation
   - Venue fit
4. **Score**: 1-4 scale (see `shared/scoring-rubrics.md` for definitions)
5. **Issues**: Categorize as Major (blocking) or Minor (improvement opportunity)

### Content Mode Awareness

Reviews adapt to the paper's `content_mode` (from `_panel.yaml`):

| Mode | Focus | Do NOT Critique |
|------|-------|-----------------|
| `abstract` | Concept viability, novelty, feasibility | Missing implementation, methodology gaps |
| `draft` | Structure, approach, preliminary results | Writing polish, minor gaps, incomplete sections |
| `full` | Publication readiness, rigor, completeness | Standard peer review criteria |

## Synthesis Protocol

Synthesis consolidates individual reviews into `SYNTHESIS.md` with priority classification:

### Priority Classification

| Level | Criteria | Action |
|-------|----------|--------|
| **P1** (High Impact) | 3+ reviewers raise it, OR any reviewer marks as major issue, OR threatens validity | Address before next round |
| **P2** (Important) | 2+ reviewers raise it, OR substantive improvement | Should address; strengthens paper |
| **P3** (Nice-to-have) | 1 reviewer, minor suggestion | Address if time permits |

### Synthesis Algorithm

1. Parse all `REVIEW-{NAME}.md` files
2. Load reviewer profiles (for expertise attribution)
3. Extract all issues (major + minor + recommendations)
4. Deduplicate: group similar issues across reviewers
5. Count mentions: track which reviewers raised each issue
6. Classify: P1/P2/P3 based on count and severity
7. Attribute with expertise: "[ML Research] notes..." "[Systems] raises..."

See `shared/synthesis-engine.md` for implementation.

## Impact Classification by Tier

| Tier | Prefix | High Impact | Medium Impact | Low Impact |
|------|--------|------------|---------------|-----------|
| Paper | P1/P2/P3 | 3+ reviewers or critical gap | 2+ reviewers | 1 reviewer |
| Module | PP1/PP2/PP3 | Cross-paper pattern, threatens module, or affects 3+ papers | 2+ papers affected | 1 paper |
| Board | B1/B2/B3 | 3+ board members flag it, threatens program coherence, or affects 3+ modules | 2+ modules affected | 1 module |

## Round Tracking

### Paper Level
- Round 1: `reviews/REVIEW-{NAME}.md`, `reviews/SYNTHESIS.md`
- Round 2+: `reviews/ROUND{N}-REVIEW-{NAME}.md`, `reviews/ROUND{N}-SYNTHESIS.md`

### Module Level
- Stored in `panel-reviews/round-{N}/`
- `REVIEW_PANEL.md` (canonical, always latest) + snapshot in round directory

### Board Level
- Stored in `board-reviews/round-{N}/`
- `REVIEW_BOARD.md` (canonical) + snapshot in round directory

## Revision Protocol

After synthesis, the revision stage:

1. Generate `REVISION-PLAN.md` from P1/P2/P3 items
2. Each item gets a checkbox, section reference, and suggested fix
3. Author addresses items (edits sections, adds evidence, etc.)
4. P1 items are tracked in `_panel.yaml.p1_items[]` with `addressed` flag
5. Once all P1 items are addressed, paper advances to recheck

## Quality Framing

All reviews use quality improvement framing, not peer review framing:

- Reviews are **AI-generated simulations**, not real peer review
- Named researchers are **personas**, not participants
- P1/P2/P3 are **improvement suggestions**, not mandates
- Language: "strengthen," "enhance," "improve" — not "must fix," "blocking"

See `templates/review-template.md` and `templates/synthesis-template.md` for the canonical templates with AI Simulation Disclosure.

## Dependencies

- `shared/stage-machine.md` — Stage gate validation
- `shared/reviewer-selector.md` — Reviewer matching
- `shared/reviewer-profile-loader.md` — Profile loading and caching
- `shared/synthesis-engine.md` — P1/P2/P3 consolidation
- `shared/scoring-rubrics.md` — All scoring scales and thresholds
- `shared/score-utils.md` — Score aggregation and consensus
- `config/stages.yaml` — Stage definitions
- `config/scoring.yaml` — Scoring configuration
- `templates/review-template.md` — Individual review structure
- `templates/synthesis-template.md` — Synthesis document structure
- `templates/revision-plan-template.md` — Revision plan structure
