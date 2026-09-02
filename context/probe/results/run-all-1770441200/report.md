# Probe Test Run: run-all-1770441200

**Date**: 2026-02-06
**Duration**: ~300s (parallel execution, all tiers)
**Tiers**: L0, L1, L2, L3
**Plugin**: panel v1.1.0

## Historical probe boundary

This report is historical evidence for the panel v1.1.0 probe surface. Current
plugin-surface evidence for panel v2.3.0 is recorded in
`context/probe/current-surface.md` and must be checked with
`tests/check-probe-surface.ps1` before this 47/47 pass report is cited as
current adoption evidence.
**Fixtures**: Sesame Street mock monorepo

## Summary

| Metric | Value |
|--------|-------|
| Total | 47 |
| Passed | 47 |
| Failed | 0 |
| Skipped | 0 |

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

## L2 — Integration (12/12)

| # | Test | Result |
|---|------|--------|
| 1 | l2-paper-draft-to-panel | PASS — recycling-optimization (draft→panel), reviewer panel assigned, _panel.yaml updated |
| 2 | l2-paper-panel-generates-reviews | PASS — trash-aesthetics: 5 REVIEW-*.md files from Miss Piggy, Oscar, Scooter, Statler, Waldorf |
| 3 | l2-paper-synthesis | PASS — trash-aesthetics: SYNTHESIS.md with P1/P2/P3 from 5 reviews |
| 4 | l2-paper-revision-cycle | PASS — crumb-analysis: revision plan addresses P1 items, stage advances |
| 5 | l2-paper-recheck | PASS — crumb-analysis: recheck round with score improvement verification |
| 6 | l2-panel-review | PASS — cookie-science: REVIEW_PANEL.md with PP1/PP2/PP3 across 5 papers |
| 7 | l2-panel-apply-revisions | PASS — panel:panel --apply drives PP1/PP2 revisions down to papers |
| 8 | l2-board-review | PASS — full monorepo: REVIEW_BOARD.md with B1/B2/B3 across 3 modules |
| 9 | l2-status-overview | PASS — panel:status shows all papers with stage, round, score columns |
| 10 | l2-show-detail | PASS — chip-distribution: full detail view with reviews, scores, history |
| 11 | l2-import-discover | PASS — topic-discovery scans sources, proposes paper topics |
| 12 | l2-setup-scaffolding | PASS — panel:setup creates directory structure, _panel.yaml, updates RESEARCH.md |

## L3 — End-to-End (7/7)

| # | Test | Result |
|---|------|--------|
| 1 | l3-full-paper-lifecycle | PASS — trash-can-architecture: draft→ready lifecycle, all artifacts produced, chip-distribution reference validated (6 history entries) |
| 2 | l3-three-tier-flow-up | PASS — paper reviews → panel synthesis → board review, findings bubble up correctly |
| 3 | l3-three-tier-flow-down | PASS — board B1/B2 → panel PP1/PP2 → paper revisions, revisions flow down |
| 4 | l3-five-paper-portfolio | PASS — cookie-science 5-paper portfolio: rankings verified, chip=highest, sharing=lowest |
| 5 | l3-multi-round-convergence | PASS — score improvement across rounds, recheck loop triggers correctly |
| 6 | l3-venue-recommendation-pipeline | PASS — chip-distribution: ICBD venue recommended (strong scores), sharing-economics: different strategy (weaker scores) |
| 7 | l3-reviewer-consistency | PASS — reviewer personas maintain consistent scoring patterns and expertise focus |

## Failures

None.
