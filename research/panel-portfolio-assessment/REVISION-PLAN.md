# Revision Plan: Cross-Portfolio Expert Panels

**Paper**: panel-portfolio-assessment
**Round**: 1 → 2
**Date**: 2026-02-05
**Source**: reviews/SYNTHESIS.md

---

## Summary

Round 1 synthesis identified 4 blocking issues (P1), 3 important improvements (P2), and 6 minor suggestions (P3). Average score is 2.4/4 with a "Major Revisions Required" verdict. The revision strategy addresses all P1 items through new sections on calibration, uncertainty quantification, baseline comparison, and human-in-the-loop design.

## Expert Reviewers

| # | Reviewer | Affiliation | Score | Verdict |
|---|---------|-------------|-------|---------|
| 1 | Percy Liang | Stanford | 3/4 | Accept with Minor Revisions |
| 2 | Michael Bernstein | Stanford | 2/4 | Major Revisions Required |
| 3 | Ben Shneiderman | UMD | 2/4 | Major Revisions Required |
| 4 | Shreya Shankar | Berkeley | 2/4 | Major Revisions Required |
| 5 | Ludwig Schmidt | UW | 3/4 | Accept with Minor Revisions |

---

## P1: Must Complete (Blocking)

### P1.1: No Calibration or Validation Against Real Expert Panels
**Source**: P1.1 in SYNTHESIS.md
**Raised by**: Percy Liang, Ben Shneiderman, Ludwig Schmidt
**Action**:
- [x] Add calibration study design subsection to Discussion
- [x] Frame AI-simulated disagreement with explicit epistemic status
- [x] Discuss what simulated disagreement represents vs. genuine expert disagreement
- [x] Add future calibration protocol with 2-3 real experts
**Target section**: sections/06-discussion.tex

### P1.2: Missing Uncertainty Quantification and Robustness Analysis
**Source**: P1.2 in SYNTHESIS.md
**Raised by**: Ludwig Schmidt, Percy Liang, Shreya Shankar
**Action**:
- [x] Add bootstrap confidence intervals on all rankings
- [x] Include sensitivity analysis for tier thresholds
- [x] Report score distributions with standard errors
- [x] Add test-retest reliability discussion
**Target section**: sections/04-ranking-analysis.tex

### P1.3: No Comparison Against Simpler Baselines
**Source**: P1.3 in SYNTHESIS.md
**Raised by**: Michael Bernstein, Percy Liang, Shreya Shankar
**Action**:
- [x] Compute baseline rankings from aggregated individual review scores
- [x] Compare panel rankings vs. baseline rankings
- [x] Identify insights unique to portfolio-level process
- [x] Add baselines subsection to Ranking Analysis
**Target section**: sections/04-ranking-analysis.tex

### P1.4: Human-in-the-Loop Design Missing
**Source**: P1.4 in SYNTHESIS.md
**Raised by**: Ben Shneiderman, Michael Bernstein
**Action**:
- [x] Add human-in-the-loop panel design section
- [x] Specify human judgment vs. automatable decisions
- [x] Design appeals/contestation mechanism
- [x] Describe hybrid AI-generates/human-validates approach
**Target section**: sections/06-discussion.tex

---

## P2: Should Complete (Important)

### P2.1: Deeper Engagement with Related Assessment Literature
**Source**: P2.1 in SYNTHESIS.md
**Raised by**: Percy Liang, Michael Bernstein
**Action**:
- [x] Add grant panel processes (NIH study sections) subsection
- [x] Add judgment aggregation literature (Dawid-Skene, GLAD)
- [x] Add crowdsourcing quality control references
- [x] Position contribution relative to established methodologies
**Target section**: sections/02-related-work.tex

### P2.2: Panel Process Analysis and Failure Modes
**Source**: P2.2 in SYNTHESIS.md
**Raised by**: Michael Bernstein, Shreya Shankar
**Action**:
- [x] Add failure mode analysis subsection
- [x] Discuss ordering and anchoring effects
- [x] Note composition sensitivity considerations
**Target section**: sections/06-discussion.tex

### P2.3: Operationalization Details
**Source**: P2.3 in SYNTHESIS.md
**Raised by**: Shreya Shankar, Michael Bernstein
**Action**:
- [x] Add runtime and compute cost information
- [x] Specify strategic priority ranking method
- [x] Add replication details
**Target section**: sections/03-panel-methodology.tex

---

## P3: Nice to Have

### P3.1: Inconsistent Paper Count
- [x] Resolve "13 papers total" vs. "14 papers" inconsistency

### P3.2: Panel Size Justification
- [x] Add jury size literature reference

### P3.3: Consensus Metric Relationship
- [x] Relate σ-based metric to Krippendorff's alpha

### P3.4: Theme Identification Method
- [x] Describe theme extraction process

### P3.5: Score Aggregation Justification
- [x] Justify mean over median/trimmed mean

### P3.6: Cross-Module Board Composition Asymmetry
- [x] Discuss asymmetric familiarity effects

---

## Revision Timeline

| Day | Focus | Deliverable |
|-----|-------|-------------|
| 1-2 | P1.2 — Uncertainty quantification | Updated Section 4 with CIs, sensitivity |
| 3-4 | P1.3 — Baseline comparison | Updated Section 4 with baselines |
| 5-6 | P1.4 — Human-in-the-loop | New subsections in Section 6 |
| 7-8 | P1.1 — Calibration + P2.1 — Related work | Updated Sections 2, 6 |
| 9 | P2.2, P2.3, P3 items | Strengthened Sections 3, 5, 6 |
| 10 | Rebuild + self-review | Ready for Round 2 |

## Quality Gates

- [x] All P1 items addressed
- [x] Paper rebuilds without errors
- [x] Claims supported by evidence
- [x] Within page limit
- [x] All reviewer questions answered in text

---

*Begin revision work. Address P1 items first, then P2.*
