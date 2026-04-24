# Git Helper — Auto-Commit with Git Strategy

Provides git auto-commit functionality for panel commands. Supports both the craft-standard `gitCommitIfEnabled(message)` pattern and the panel-specific scoped `auto_commit(context)` pattern.

## Configuration

Git strategy is configured in `.claude/panel.json`:

```json
{
  "gitStrategy": "auto-commit"  // or "manual"
}
```

- **auto-commit**: Commands commit changes automatically when they finish
- **manual**: Changes are left uncommitted for user review

## gitCommitIfEnabled(message, paths)

Simple auto-commit function following craft conventions. Commits changes if `gitStrategy` is "auto-commit".

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `message` | string | yes | Commit message (should include `[panel]` prefix) |
| `paths` | string\|string[] | no | Specific paths to stage (default: all changed files) |

### Behavior

```
1. Load config from .claude/panel.json
2. If gitStrategy !== "auto-commit" → return silently
3. Check git repo: git rev-parse --is-inside-work-tree
   - If not a git repo → return silently
4. Stage changes:
   - If paths provided: git add <paths>
   - Otherwise: git add -u (stage tracked files only)
5. Check for staged changes: git diff --cached --quiet
   - If nothing staged → return silently
6. Commit: git commit -m "<message>"
7. Report: "✓ Committed: <message>"
```

### Usage

```javascript
// At end of command after writing files
await gitCommitIfEnabled('[panel] panel-review-methodology: advance to synthesis (round 1)');

// With specific paths
await gitCommitIfEnabled(
  '[panel] Board review round 2',
  ['REVIEW_BOARD.md', 'BOARD-REVISION-PLAN-*.md', 'board-reviews/']
);
```

## auto_commit(context)

Advanced scoped commit for panel commands. Provides fine-grained control over what gets staged and committed.

### Parameters

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `command` | string | yes | The panel command name (`paper`, `panel`, `board`, `setup`, `import`) |
| `paths` | string[] | yes | Directories/files to stage (scoped `git add`) |
| `message` | string | yes | Commit message (must include `[panel]` prefix) |
| `dry_run` | boolean | no | If true, skip commit entirely (default: false) |

### Logic

```
1. Load config from .claude/panel.json
2. If gitStrategy !== "auto-commit" → return silently
3. If dry_run is true → return silently
4. Check git repo: git rev-parse --is-inside-work-tree
   - If not a git repo → return silently (supports non-git usage like test fixtures)
5. Stage scoped paths:
   - For each path in context.paths:
     - Run: git add <path>
   - NEVER use git add -A or git add . (avoid staging unrelated changes)
6. Check for changes: git diff --cached --quiet
   - If exit code 0 (nothing staged) → return silently
7. Commit: git commit -m "<context.message>"
8. Report: "✓ Committed {count} file(s): {message}"
```

### Commit Message Templates

Each command provides its own message via the `message` field. Standard patterns:

| Command | Template | Example |
|---------|----------|---------|
| `panel:review` | `[panel] {paper}: advance to {stage} (round {round})` | `[panel] panel-review-methodology: advance to synthesis (round 1)` |
| `panel:module review` | `[panel] {module}: panel review round {round}` | `[panel] panel: panel review round 1` |
| `panel:module member` | `[panel] {module}: update panel member {name}` | `[panel] panel: update panel member Percy Liang` |
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
| `panel:module review` | Module directory: `REVIEW_PANEL.md`, `PANEL-REVISION-PLAN.md`, `panel-reviews/` |
| `panel:module member` | Module directory: `REVIEW_PANEL.md` |
| `panel:board --review` | Repo root: `REVIEW_BOARD.md`, `BOARD-REVISION-PLAN-*.md`, `board-reviews/` |
| `panel:board --update` | Repo root: `REVIEW_BOARD.md`, `BOARD-REVISION-PLAN-*.md` |
| `panel:board --member` | Repo root: `REVIEW_BOARD.md` |
| `panel:setup` | `{research_dir}/` |
| `panel:import` | `{research_dir}/` |

### Usage

```javascript
// At end of command
await auto_commit({
  command: 'panel:review',
  paths: [`research/panel-review-methodology/`],
  message: '[panel] panel-review-methodology: advance to synthesis (round 1)',
  dry_run: args['--dry-run'] || false
});
```

## Skip Conditions

Auto-commit is skipped (silently, no error) when:

1. `gitStrategy` is set to "manual" in `.claude/panel.json`
2. `--dry-run` flag is set on the command
3. Not inside a git repository
4. No files were changed (nothing to commit)
5. Command mode is read-only (`--status`, `--revisions`, `--check`)

## Migration Notes

The original `shared/git-utils.md` has been superseded by this file. Commands should update their references:

- Old: `shared/git-utils.md` → New: `shared/git-helper.md`
- The `auto_commit(context)` function is preserved for backward compatibility
- New commands should use `gitCommitIfEnabled(message, paths)` for simpler cases
