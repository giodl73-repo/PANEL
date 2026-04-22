---
name: panel:help
description: Interactive help system with topics (stages, reviewers, scoring, workflow)
user-invocable: true
---

# panel:help — Interactive Help System

Provides contextual help on the panel review lifecycle, commands, and concepts.

## Arguments

- `<topic>` — Help topic (optional). If omitted, shows topic list.

## Topics

### stages
Explains the 8-stage lifecycle: draft → panel → synthesis → revision → recheck → ready → submit → accepted. Details gate conditions, artifacts produced, and common issues at each stage.

### reviewers
How reviewer selection works: categories, venue matching, expertise tags, panel composition guidelines (5 per paper, mix of industry + academic, complementary perspectives).

### scoring
The scoring rubrics: 4-point scale (per reviewer), 10-point scale (cross-portfolio), verdict mapping, consensus metrics, submission readiness thresholds.

### workflow
Typical workflow walkthrough: setting up a project, running first review cycle, interpreting synthesis, implementing revisions, passing recheck, preparing for submission.

### synthesis
How the synthesis engine works: consolidating reviews, P1/P2/P3 classification, extracting actionable items, tracking resolution.

### state
The `_panel.yaml` state file: fields, schema, how it's read/written, manual editing tips.

### venues
Venue selection guidance: matching paper type to conferences, understanding review standards, submission timelines.

### commands
Quick reference for all 9 panel commands with one-line descriptions and common usage patterns.

## Output Format

```
Panel Help
═══════════════════════════════════════════════════════════════════════

Available topics:

  stages      The 8-stage review lifecycle
  reviewers   Reviewer selection and panel composition
  scoring     Scoring rubrics and thresholds
  workflow    Typical review workflow walkthrough
  synthesis   Review consolidation and priority classification
  state       The _panel.yaml state file
  venues      Venue selection guidance
  commands    Quick command reference

Usage: panel:help <topic>
```

### Topic Detail Example

```
Panel Help — Stages
═══════════════════════════════════════════════════════════════════════

The review lifecycle has 8 stages. Each stage has a gate condition
that must be met to advance. The `panel:go` command handles progression.

  Stage        Gate                              Artifacts
  ─────        ────                              ─────────
  1. draft     main.tex exists + venue set       main.tex, sections/
  2. panel     5+ REVIEW-*.md generated          reviews/REVIEW-*.md
  3. synthesis SYNTHESIS.md with P1/P2/P3        reviews/SYNTHESIS.md
  4. revision  All P1 items addressed            REVISION-PLAN.md
  5. recheck   avg ≥ 2.5/4, none < 2/4          ROUND{N}-REVIEW-*.md
  6. ready     Cross-portfolio panel done        REVIEW_PANEL.md
  7. submit    User confirms submission          —
  8. accepted  User confirms acceptance          —

Loop: If recheck gate fails, loops back to synthesis for another round.
```

## Dependencies

- templates/help/ — Help topic content files
