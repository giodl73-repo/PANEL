# Revision Plan: Multi-Round Revision Dynamics

**Paper**: panel-revision-dynamics
**Round**: 1 → 2
**Date**: 2026-02-05
**Source**: reviews/SYNTHESIS.md

---

## Summary

All 5 reviewers scored 2/4 (Major Revisions Required) with unanimous consensus. The core findings (P1/P2/P3 decomposition, convergence predictors) were praised, but the paper needs stronger statistical methodology, ecological validity grounding, formal model testing, and revision process analysis.

## Expert Reviewers

| # | Reviewer | Affiliation | Score | Verdict |
|---|---------|-------------|-------|---------|
| 1 | Percy Liang | Stanford | 2/4 | Major Revisions Required |
| 2 | Michael Bernstein | Stanford | 2/4 | Major Revisions Required |
| 3 | Saleema Amershi | Microsoft Research | 2/4 | Major Revisions Required |
| 4 | Ludwig Schmidt | UW | 2/4 | Major Revisions Required |
| 5 | Shreya Shankar | Berkeley | 2/4 | Major Revisions Required |

---

## P1: Must Complete (Blocking)

### P1.1: Statistical methodology insufficient for N=14 single-author dataset
**Source**: P1.1 in SYNTHESIS.md
**Raised by**: Percy Liang, Ludwig Schmidt, Saleema Amershi, Shreya Shankar
**Action**:
- [x] Add bootstrap 95% CIs to all aggregate statistics in Tables 1-3
- [x] Add per-paper score trajectories subsection showing variance
- [x] Reframe claims as descriptive pilot results with explicit caveats
- [x] Add statistical methodology subsection to Study Design
- [x] Discuss non-i.i.d. structure (modules, single author) explicitly
**Target section**: sections/03-study-design.tex, sections/04-score-trajectories.tex, sections/05-revision-strategies.tex

### P1.2: Circularity / ecological validity — AI reviews studying AI review dynamics
**Source**: P1.2 in SYNTHESIS.md
**Raised by**: Percy Liang, Michael Bernstein, Ludwig Schmidt, Saleema Amershi
**Action**:
- [x] Add explicit framing in Introduction: characterizing *this AI review system's* dynamics
- [x] Expand Discussion: systematic comparison of AI vs. human review properties
- [x] Add author experience comparison as partial external validation
- [x] Define prospective validation protocol for venue submissions
**Target section**: sections/01-introduction.tex, sections/06-discussion.tex

### P1.3: Logarithmic improvement model asserted but not tested
**Source**: P1.3 in SYNTHESIS.md
**Raised by**: Percy Liang, Ludwig Schmidt
**Action**:
- [x] Formal curve fitting: logarithmic, linear, exponential, power law models
- [x] Report R², AIC for each model
- [x] Note limitation: 3 aggregate data points, limited model selection power
- [x] Show per-paper trajectories supporting the pattern
**Target section**: sections/04-score-trajectories.tex

### P1.4: Revision process treated as black box / no failure mode analysis
**Source**: P1.4 in SYNTHESIS.md
**Raised by**: Saleema Amershi, Shreya Shankar, Michael Bernstein
**Action**:
- [x] Add revision process subsection: timing, strategy, decision-making
- [x] Add failure mode analysis: non-converging papers, misclassified priorities
- [x] Analyze P1 classification accuracy: items addressed but scores didn't improve
- [x] Include rework rate metric
**Target section**: sections/05-revision-strategies.tex

---

## P2: Should Complete (Important)

### P2.1: Missing connection to iterative crowd workflow literature
**Source**: P2.1 in SYNTHESIS.md
**Raised by**: Michael Bernstein, Saleema Amershi
**Action**:
- [x] Add crowd workflow subsection to Related Work (Soylent, find-fix-verify)
- [x] Connect P1/P2/P3 framework to crowd task decomposition
**Target section**: sections/02-related-work.tex

### P2.2: No analysis of review quality/content across rounds
**Source**: P2.2 in SYNTHESIS.md
**Raised by**: Michael Bernstein, Saleema Amershi
**Action**:
- [x] Add review content analysis subsection
- [x] Test for score inflation patterns
**Target section**: sections/05-revision-strategies.tex

---

## P3: Nice to Have

### P3.1: Basecamp case study under-discussed
- [x] Added detailed Basecamp 4-round trajectory in Section 4

### P3.2: Cross-portfolio score mapping unclear
- [x] Added explicit mapping formula in Section 3

---

## Revision Timeline

| Day | Focus | Deliverable |
|-----|-------|-------------|
| 1 | P1.1 — Statistical rigor | CIs in all tables, per-paper trajectories, methodology subsection |
| 2 | P1.2 — Ecological validity | Reframed intro, expanded discussion with validation protocol |
| 3 | P1.3 — Formal model fitting | Curve fitting results, model comparison table |
| 4 | P1.4 — Process + failure modes | New subsections in revision strategy and discussion |
| 5 | P2.1, P2.2 — Literature + content analysis | Expanded related work, review quality analysis |

## Quality Gates

- [x] All P1 items addressed
- [x] Claims reframed with appropriate uncertainty
- [x] Per-paper data shown alongside aggregates
- [x] Formal model comparison for diminishing returns
- [x] Revision process and failure modes analyzed

---

*Begin revision work. Address P1 items first, then P2.*
