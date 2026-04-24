# State Loader — Read/Write _panel.yaml

Shared utility for reading and writing per-paper `_panel.yaml` state files.

## File Location

Each paper directory contains a `_panel.yaml` file at its root:
```
paper-directory/
├── _panel.yaml          ← this file
├── main.tex
├── sections/
└── reviews/
```

## Read Operations

### load_state(paper_dir)

```
Input:  path to paper directory
Output: parsed YAML object (validated against config/schemas/panel-state.schema.yaml)
Error:  if _panel.yaml doesn't exist, returns default state with stage: "draft"
```

### discover_papers(project_dir)

```
Input:  path to project root
Output: array of { dir: string, state: object } for each paper with _panel.yaml
```

Scans for directories containing `main.tex` or `_panel.yaml`.

## Write Operations

### save_state(paper_dir, state)

```
Input:  paper directory, state object
Output: writes _panel.yaml (atomic write: write to temp, then rename)
```

Always validates against schema before writing. Preserves YAML comments if possible.

### update_stage(paper_dir, new_stage, note)

```
Input:  paper directory, new stage name, transition note
Output: updates stage field and appends to history array
```

Convenience wrapper that:
1. Loads current state
2. Sets `stage` to new value
3. Appends `{ stage, date: today, note }` to history
4. Saves state

### update_reviews(paper_dir, round, completed, synthesis)

```
Input:  paper directory, round number, completed count, synthesis boolean
Output: updates reviews.round-N entry
```

### update_p1_items(paper_dir, items)

```
Input:  paper directory, array of { item, addressed, notes }
Output: replaces p1_items array in state
```

## Default State

When creating a new `_panel.yaml`:

```yaml
paper: {directory_name}
title: ""
venue: ""
stage: draft
round: 0
reviewers: []
reviews: {}
p1_items: []
history:
  - stage: draft
    date: {today}
    note: "Paper initialized"
```

## Validation

All state files are validated against `config/schemas/panel-state.schema.yaml` on read and write. Invalid files produce a warning but are still loaded (permissive mode).
