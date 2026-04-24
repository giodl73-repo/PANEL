# Probe Test Run: run-1770441119

**Date**: 2026-02-06
**Duration**: ~260s (parallel execution)
**Tiers**: L0, L1
**Plugin**: panel v1.1.0
**Fixtures**: Sesame Street mock monorepo

## Summary

| Metric | Value |
|--------|-------|
| Total | 28 |
| Passed | 28 |
| Failed | 0 |

## L0 — Structural Validation (12/12)

| # | Test | Result |
|---|------|--------|
| 1 | l0-plugin-manifest | PASS — valid JSON, name=panel, version=1.1.0, 11 commands |
| 2 | l0-commands-exist | PASS — 11 command .md files, all non-empty |
| 3 | l0-shared-exist | PASS — 11 shared utility .md files, all non-empty |
| 4 | l0-config-scoring | PASS — valid YAML with four_point, ten_point, thresholds, consensus, verdict_mapping |
| 5 | l0-config-stages | PASS — 8 stages: draft→panel→synthesis→revision→recheck→ready→submit→accepted |
| 6 | l0-schema-valid | PASS — valid schema, required=[paper, title, venue, stage] |
| 7 | l0-templates-exist | PASS — 7+ template files (review, synthesis, revision-plan, REVIEWER-DATABASE, REVIEWERS, REVIEW_PANEL, RESEARCH) |
| 8 | l0-help-topics-exist | PASS — 4 help topics (commands, scoring, stages, workflow) |
| 9 | l0-references-bib | PASS — 1249 lines, 151 BibTeX entries |
| 10 | l0-research-papers-exist | PASS — 5 papers (review-methodology, reviewer-calibration, revision-dynamics, portfolio-assessment, synthesis-methods) |
| 11 | l0-research-makefile | PASS — 93 lines, has "all" target |
| 12 | l0-ai-disclosure-templates | PASS — AI Simulation Disclosure in review-template, synthesis-template, REVIEWER-DATABASE |

## L1 — Unit Behavior (16/16)

| # | Test | Result |
|---|------|--------|
| 1 | l1-state-loader-read | PASS — chip-distribution: paper, stage=ready, round=2, 5 reviewers, 6 history entries |
| 2 | l1-state-loader-write | PASS — waiter-dilemma: paper, 5 reviewers (Grover, Big Bird, Snuffy, Elmo, Bunsen), 3 history |
| 3 | l1-stage-machine-gates | PASS — 8 stages with gates, recheck→synthesis loop, ready requires panel:panel |
| 4 | l1-stage-machine-recheck-loop | PASS — loop_to: synthesis, thresholds: avg≥2.5, min≥2 |
| 5 | l1-reviewer-selector-match | PASS — 8 reviewer categories, all expected reviewers present |
| 6 | l1-synthesis-engine-consolidation | PASS — SYNTHESIS.md has P1/P2/P3 priority tiers |
| 7 | l1-score-utils-4point | PASS — 1-4 scale (Reject→Strong Accept), thresholds correct, consensus metrics defined |
| 8 | l1-score-utils-10point | PASS — 6 tiers (A→C), contiguous ranges covering 0-10 |
| 9 | l1-display-utils-formatting | PASS — box-drawing chars (═, ──), status indicators (✓, →, ○, ✗) |
| 10 | l1-panel-utils-pp-classification | PASS — PP1/PP2 in REVIEW_PANEL.md, 7-member panel, portfolio rankings |
| 11 | l1-board-utils-module-discovery | PASS — 3 modules (cookie-science, grover-adventures, oscar-trash-lab), 5 papers each |
| 12 | l1-board-utils-b-classification | PASS — REVIEW_BOARD.md references all 3 modules with Modules section |
| 13 | l1-topic-discovery-scan | PASS — discover_from_* functions for roadmap, waves, commits |
| 14 | l1-paper-generator-creates | PASS — main.tex generation, sections/ with 6 .tex files |
| 15 | l1-git-utils-commit | PASS — [panel] prefix, git add (scoped), explicit "NEVER use git add -A" |
| 16 | l1-schema-validates-state | PASS — 3 valid fixtures pass, 1 invalid fixture correctly identified (missing title, bad stage, score OOB) |

## Failures

None.
