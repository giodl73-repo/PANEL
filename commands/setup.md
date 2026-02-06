<command-name>panel:setup</command-name>

# panel:setup — Initialize Panel in a Project

Sets up the panel review infrastructure in a research project.

## Arguments

- `--project <path>` — Target project directory (default: cwd)
- `--papers <dir>` — Paper directories location (default: auto-detect)
- `--reviewer-db <path>` — Custom reviewer database path

## Behavior

1. **Detect project structure**: Look for existing paper directories (containing `main.tex`).
2. **Create panel infrastructure**:
   - Copy REVIEWER-DATABASE.md to project root (if not present)
   - Create `RESEARCH_GUIDE.md` reference (if not present)
   - Create `REVISION-PROMPT-TEMPLATE.md` reference (if not present)
3. **Initialize per-paper state**: For each detected paper directory:
   - Create `_panel.yaml` with stage: draft
   - Create `reviews/` directory
4. **Create module files**:
   - `RESEARCH.md` — Paper inventory template
   - `REVIEWERS.md` — Module reviewer subset template
   - `REVIEW_PANEL.md` — Placeholder for cross-portfolio panel
5. **Report**: Show what was created and next steps.

## Output Format

```
Panel Setup — C:\src\panel\research
═══════════════════════════════════════════════════════════════════════

Detected 5 paper directories:
  ✓ panel-review-methodology/     → _panel.yaml created (stage: draft)
  ✓ panel-reviewer-calibration/   → _panel.yaml created (stage: draft)
  ✓ panel-revision-dynamics/      → _panel.yaml created (stage: draft)
  ✓ panel-portfolio-assessment/   → _panel.yaml created (stage: draft)
  ✓ panel-synthesis-methods/      → _panel.yaml created (stage: draft)

Created:
  ✓ REVIEWER-DATABASE.md (copied from plugin)
  ✓ RESEARCH.md (paper inventory template)
  ✓ REVIEWERS.md (module reviewer subset)
  ✓ REVIEW_PANEL.md (placeholder)

Next steps:
  1. Set venue for each paper:  Edit _panel.yaml in each paper directory
  2. Run reviews:               panel:go --paper <name>
  3. Check status:              panel:status
```

## Dependencies

- shared/state-loader.md — Create _panel.yaml files
- shared/display-utils.md — Terminal formatting
