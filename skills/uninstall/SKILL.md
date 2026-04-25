---
name: uninstall
description: Remove panel plugin data and configuration — clean uninstall with selective retention
user-invocable: true
---

# panel:uninstall — Clean Plugin Removal

Removes panel plugin configuration, state, and generated artifacts from the current project. Provides selective removal with safety confirmations.

## What Gets Removed

| Category | Files | Notes |
|----------|-------|-------|
| **Plugin Config** | `.claude/panel.json` | Plugin settings, git strategy |
| **Paper State** | `research/*/\_panel.yaml` | Review state, scores, round tracking |
| **Review Artifacts** | `research/*/reviews/` | Individual reviews, synthesis, revision plans |
| **Panel Reviews** | `research/REVIEW_PANEL.md`, `panel-reviews/` | Module-level panel reviews |
| **Board Reviews** | `REVIEW_BOARD.md`, `BOARD-REVISION-PLAN-*.md`, `board-reviews/` | Monorepo-level board reviews |
| **Templates** | `templates/REVIEWERS.md`, `RESEARCH.md` | Module-level copied templates |

## What Gets Preserved

| Category | Files | Rationale |
|----------|-------|-----------|
| **Paper Content** | `research/*/main.tex`, `sections/*.tex` | Your work, not generated |
| **Compiled PDFs** | `research/docs/*.pdf` | Build artifacts you may want |
| **Bibliography** | `templates/references.bib` | May contain custom additions |
| **Help Files** | `templates/help/` | Documentation, not state |

## Arguments

| Arg | Description |
|-----|-------------|
| `--all` | Remove everything including paper content (⚠ destructive) |
| `--config-only` | Remove only `.claude/panel.json` (keep all review data) |
| `--reviews-only` | Remove review artifacts but keep state and config |
| `--dry-run` | Show what would be removed without deleting |
| `--force` | Skip confirmation prompts |

## Safety Features

### Confirmation Prompts

Before removing files, the command asks:

```
Panel Uninstall
═══════════════════════════════════════════════════════════════════════

This will remove:
  • .claude/panel.json
  • 5 papers: _panel.yaml, reviews/, REVISION-PLAN.md
  • REVIEW_PANEL.md + panel-reviews/
  • REVIEW_BOARD.md + board-reviews/

This will preserve:
  • main.tex, sections/*.tex (paper content)
  • docs/*.pdf (compiled papers)
  • references.bib

Continue with uninstall?
  [ ] Yes, remove panel data (Recommended)
  [ ] Remove everything including paper content (⚠ Destructive)
  [ ] No, cancel
```

### Backup Option

If user selects full removal (`--all`), prompt for backup:

```
Create backup before removing paper content?
  [ ] Yes, create backup (Recommended)
  [ ] No, delete without backup
```

Backup location: `.panel-backup-{timestamp}.tar.gz`

### Git Safety

If uncommitted changes are detected in files to be removed:

```
⚠ Warning: Uncommitted changes detected in:
  • research/panel-review-methodology/_panel.yaml
  • research/panel-revision-dynamics/reviews/SYNTHESIS.md

Options:
  [ ] Commit changes first, then uninstall
  [ ] Abort uninstall (keep changes)
  [ ] Proceed anyway (⚠ changes will be lost)
```

## Behavior

### Standard Uninstall (no flags)

1. **Scan project**:
   - Find all papers with `_panel.yaml`
   - Locate module and board review files
   - Count total files to remove

2. **Show summary**:
   - List what will be removed
   - List what will be preserved
   - Display file count and disk space to be freed

3. **Confirm**:
   - Multi-choice confirmation (see above)
   - If user cancels, exit cleanly

4. **Remove files**:
   - Delete in order: paper state → panel reviews → board reviews → config
   - Report progress: "Removing {file}..."
   - Handle errors gracefully (skip files that don't exist)

5. **Report completion**:
   ```
   ✓ Panel uninstall complete

   Removed:
     • 5 papers (state + reviews)
     • 1 module panel review
     • 1 board review
     • 1 config file

   Preserved:
     • Paper content (*.tex)
     • Compiled PDFs (docs/)
     • Bibliography

   Freed: 2.4 MB

   To reinstall: panel:setup
   ```

### Selective Uninstall

#### --config-only

Removes only `.claude/panel.json`. Use case: Reset git strategy or suppress settings while keeping all review data.

#### --reviews-only

Removes:
- `reviews/` directories (per-paper)
- `REVIEW_PANEL.md`, `panel-reviews/` (module-level)
- `REVIEW_BOARD.md`, `board-reviews/` (monorepo-level)

Preserves:
- `_panel.yaml` (state files)
- `.claude/panel.json` (config)

Use case: Regenerate all reviews from scratch while keeping stage tracking.

#### --all

Removes everything including:
- Paper directories (`research/panel-*`)
- All LaTeX source files
- Compiled PDFs

**Destructive**: Prompts for backup. Use case: Complete removal of the research project.

### --dry-run

Shows exactly what would be removed without deleting anything:

```
Dry Run: Panel Uninstall
═══════════════════════════════════════════════════════════════════════

Would remove:
  • .claude/panel.json (487 bytes)
  • research/panel-review-methodology/_panel.yaml (1.2 KB)
  • research/panel-review-methodology/reviews/ (45 files, 89 KB)
  • research/panel-reviewer-calibration/_panel.yaml (1.1 KB)
  • research/panel-reviewer-calibration/reviews/ (38 files, 76 KB)
  ... [3 more papers]
  • research/REVIEW_PANEL.md (12 KB)
  • research/panel-reviews/ (8 files, 34 KB)
  • REVIEW_BOARD.md (15 KB)
  • board-reviews/ (4 files, 18 KB)

Total: 124 files, 2.4 MB

Would preserve:
  • research/panel-review-methodology/main.tex
  • research/panel-review-methodology/sections/ (6 files)
  ... [4 more papers]
  • research/docs/ (5 PDFs, 3.8 MB)

Run without --dry-run to execute.
```

## Recovery

If you uninstall by mistake:

1. **Git recovery** (if files were committed):
   ```bash
   git checkout HEAD -- research/
   git checkout HEAD -- .claude/panel.json
   ```

2. **Backup recovery** (if backup was created):
   ```bash
   tar -xzf .panel-backup-{timestamp}.tar.gz
   ```

3. **Rebuild from papers** (if paper content was preserved):
   ```bash
   panel:setup              # Reinitialize infrastructure
   panel:import --existing  # Reimport papers and generate state
   ```

## Dependencies

- shared/message-utils.md — Output formatting
- shared/error-handler.md — Error reporting
- shared/state-loader.md — Read _panel.yaml files for discovery

## Post-Uninstall

After uninstall, the plugin remains installed in Claude Code's plugin system. To fully remove the plugin from Claude Code:

```bash
# From the plugin development location
cd panel
rm -rf .claude-plugin/

# Or from the marketplace/plugins directory
cd plugins
rm -rf panel/
```

The `panel:*` commands will no longer be available after this.
