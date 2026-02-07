# Git Utilities — Auto-Commit on Command Completion

**DEPRECATED**: This file is superseded by `shared/git-helper.md`. New commands should use `gitCommitIfEnabled()` from git-helper.md. This file is maintained for backward compatibility only.

Provides `auto_commit(context)` for panel commands that modify files. Called as a final step after a command writes artifacts, keeping the working tree clean.

## auto_commit(context)

### Parameters

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `command` | string | yes | The panel command name (`paper`, `panel`, `board`, `setup`, `import`) |
| `paths` | string[] | yes | Directories/files to stage (scoped `git add`) |
| `message` | string | yes | Commit message (must include `[panel]` prefix) |
| `dry_run` | boolean | no | If true, skip commit entirely (default: false) |

### Logic

```
1. If dry_run is true → return silently (command already skipped file writes)

2. Check git repo:
   - Run: git rev-parse --is-inside-work-tree
   - If not a git repo → return silently (supports non-git usage like test fixtures)

3. Stage scoped paths:
   - For each path in context.paths:
     - Run: git add <path>
   - NEVER use git add -A or git add . (avoid staging unrelated changes)

4. Check for changes:
   - Run: git diff --cached --quiet
   - If exit code 0 (nothing staged) → return silently

5. Commit:
   - Run: git commit -m "<context.message>"

6. Report:
   - Count staged files: git diff --cached --name-only (before commit)
   - Output: "Committed {count} file(s): {message}"
```

### Commit Message Templates

Each command provides its own message via the `message` field. Standard patterns:

| Command | Template | Example |
|---------|----------|---------|
| `panel:review` | `[panel] {paper}: advance to {stage} (round {round})` | `[panel] panel-review-methodology: advance to synthesis (round 1)` |
| `panel:convene` | `[panel] {module}: panel review round {round}` | `[panel] panel: panel review round 1` |
| `panel:convene --member` | `[panel] {module}: update panel member {name}` | `[panel] panel: update panel member Percy Liang` |
| `panel:board` | `[panel] Board review round {round}` | `[panel] Board review round 1` |
| `panel:board --update` | `[panel] Board: update {section}` | `[panel] Board: update synthesis` |
| `panel:board --member` | `[panel] Board: update member {name}` | `[panel] Board: update member Yoshua Bengio` |
| `panel:setup` (project) | `[panel] Setup: initialize {module} research infrastructure` | `[panel] Setup: initialize boost research infrastructure` |
| `panel:setup` (paper) | `[panel] Setup: add paper {paper-name} ({venue})` | `[panel] Setup: add paper panel-cross-venue-analysis (ACL 2026)` |
| `panel:import` (discovery) | `[panel] Import: {count} papers from {source}` | `[panel] Import: 2 papers from roadmap` |
| `panel:import` (artifact) | `[panel] Import: artifacts for {paper}` | `[panel] Import: artifacts for panel-review-methodology` |

### Scoping Rules

Each command stages only the files it touched:

| Command | Paths to stage |
|---------|---------------|
| `panel:review` | `{paper_dir}/` (includes `_panel.yaml`, `reviews/`, `REVISION-PLAN.md`) |
| `panel:convene --review` | Module directory: `REVIEW_PANEL.md`, `PANEL-REVISION-PLAN.md`, `panel-reviews/` |
| `panel:convene --member` | Module directory: `REVIEW_PANEL.md` |
| `panel:board --review` | Repo root: `REVIEW_BOARD.md`, `BOARD-REVISION-PLAN-*.md`, `board-reviews/` |
| `panel:board --update` | Repo root: `REVIEW_BOARD.md`, `BOARD-REVISION-PLAN-*.md` |
| `panel:board --member` | Repo root: `REVIEW_BOARD.md` |
| `panel:setup` | `{research_dir}/` |
| `panel:import` | `{research_dir}/` |

### Skip Conditions

Auto-commit is skipped (silently, no error) when:

1. `--dry-run` flag is set on the command
2. Not inside a git repository
3. No files were changed (nothing to commit)
4. Command mode is read-only (`--status`, `--revisions`, `--check`)
