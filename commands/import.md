<command-name>panel:import</command-name>

# panel:import — Import Existing Review Process

Creates `_panel.yaml` state files from papers that already have review artifacts (e.g., merit/waves papers with existing REVIEW-*.md files).

## Arguments

- `--paper <dir>` — Specific paper directory to import
- `--module <path>` — Import all papers in a module directory
- `--dry-run` — Show what would be imported without creating files

## Behavior

1. **Scan for review artifacts**: Find `REVIEW-*.md`, `ROUND*-REVIEW-*.md`, `SYNTHESIS.md`, `REVISION-PLAN.md` files.
2. **Detect current stage**: Based on which artifacts exist:
   - Has `main.tex` only → `draft`
   - Has `REVIEW-*.md` files → `panel`
   - Has `SYNTHESIS.md` → `synthesis`
   - Has `REVISION-PLAN.md` → `revision`
   - Has `ROUND2-REVIEW-*.md` → `recheck`
   - Has `REVIEW_PANEL.md` in parent → `ready`
3. **Extract reviewer data**: Parse reviewer names, affiliations, and scores from review files.
4. **Extract scores**: Parse score lines from review files (handles `Score: 3/4`, `Overall: Accept`, etc.).
5. **Build history**: Reconstruct stage transition timeline from file modification dates.
6. **Write `_panel.yaml`**: Create state file with all extracted data.

## Output Format

```
Panel Import — merit/merit-data-first-architecture
═══════════════════════════════════════════════════════════════════════

Detected artifacts:
  reviews/REVIEW-PERCY-LIANG.md        Score: 3/4
  reviews/REVIEW-MATEI-ZAHARIA.md      Score: 4/4
  reviews/REVIEW-HARRISON-CHASE.md     Score: 3/4
  reviews/REVIEW-SHREYA-SHANKAR.md     Score: 3/4
  reviews/REVIEW-ION-STOICA.md         Score: 3/4
  reviews/SYNTHESIS.md                 P1: 3, P2: 5, P3: 2
  reviews/ROUND2-REVIEW-*.md           5 files, avg 3.4/4
  REVISION-PLAN.md                     Exists

Inferred state:
  Stage: ready (round 2 complete, all scores ≥ 2/4, avg 3.4/4)
  Reviewers: 5
  Rounds: 2

Created: _panel.yaml
```

## Batch Import

```bash
# Import all merit papers
panel:import --module merit/

# Import all waves papers
panel:import --module waves/
```

## Dependencies

- shared/state-loader.md — Write _panel.yaml
- shared/score-utils.md — Score parsing and aggregation
