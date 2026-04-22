# Revision Plan — Hierarchical Review Architecture

**Paper**: panel-hierarchical-review-architecture
**Round**: 1
**Date**: 2026-02-07
**Status**: Pending

---

## Overview

This revision plan addresses the blocking issues (P1) and important issues (P2) identified in the Round 1 synthesis. The paper received strong consensus (σ = 0.49) with an average score of 2.6/4, indicating the architecture is sound but needs major revisions before resubmission.

**Overall verdict**: Revise and Resubmit (Major Revisions)

**Next steps**:
1. Address all P1 items (blocking)
2. Address P2 items (important but not blocking)
3. Consider P3 items if time permits

---

## Priority 1: Blocking Issues (Must Address)

### P1.1: Evaluation Lacks Ground Truth and Validation ⬜

**Source**: Percy Liang (M1), Ben Shneiderman, Ece Kamar, Michael Bernstein (M3)

**Issue**: The evaluation demonstrates the system produces hierarchical reviews with emergent patterns, but provides no evidence these patterns are correct, useful, or better than alternatives. Missing:
- Human baseline comparison
- Ground truth for synthetic papers
- Outcome validation (did addressing PP1/B1 items improve papers?)
- Comparative evaluation (three-tier vs. alternatives)
- Validation of "emergent patterns" (37% PP1, 52% B1)

**Action required**:
1. Add human baseline: Compare system's reviews to human expert panel on 5-10 papers
2. Validate emergent patterns: Show human panels identify the same patterns, measure false positive rate
3. Add outcome analysis: Correlate addressing PP1/B1 with paper quality improvement
4. Include user study: Survey researchers who used the system
5. Ablation studies: Compare three-tier vs. two-tier vs. flat aggregation

**Files to modify**:
- `sections/04-results.tex` — Add validation subsection
- `sections/03-methodology.tex` — Add human baseline methodology
- `sections/05-discussion.tex` — Add limitations on evaluation scope

**Addressed**: ⬜ No

---

### P1.2: No Human Oversight Mechanisms for AI-Generated Classifications ⬜

**Source**: Ben Shneiderman (M1), Ece Kamar, Shreya Shankar

**Issue**: The system automatically classifies issues as P1/P2/P3, PP1/PP2/PP3, B1/B2/B3 without human oversight. AI reviewers can be systematically wrong, and misclassifications cascade through the hierarchy. No mechanism for:
- Humans to override incorrect priority classifications
- Authors to challenge spurious emergent patterns
- Detecting low-confidence classifications that need human review

**Action required**:
1. Add confidence-based deferral: Compute confidence scores, escalate low-confidence classifications
2. Implement human override mechanisms: Authors contest P1, panel chair approves PP1
3. Require human validation for high-criticality emergent patterns
4. Add transparency: Show evidence/reasoning with confidence indicators

**Files to modify**:
- `sections/03-methodology.tex` — Add "Human Oversight Mechanisms" subsection
- `shared/synthesis-engine.md` — Implement confidence scoring
- `shared/stage-machine.md` — Add human override gates

**Addressed**: ⬜ No

---

### P1.3: Aggregation Algorithm Is Unspecified ⬜

**Source**: Michael Bernstein (M1), Percy Liang, Ece Kamar

**Issue**: The paper says reviews are "consolidated" but doesn't describe *how*. Missing details:
- Priority classification logic (P1 vs. P2 decision criteria)
- Synthesis generation (concatenation vs. intelligent merging)
- Emergent pattern detection algorithm
- Reviewer weighting (equal vs. quality-based)

**Action required**:
1. Add detailed aggregation section:
   - Algorithm for P1/P2/P3 classification
   - How synthesis merges/deduplicates/reconciles reviews
   - How emergent patterns are detected
2. Provide worked examples: raw reviews → synthesis
3. Compare aggregation strategies (majority vote, weighted, consensus)
4. Implement reviewer quality scoring

**Files to modify**:
- `sections/03-methodology.tex` — Add "Review Aggregation Algorithm" subsection (2-3 pages)
- `shared/synthesis-engine.md` — Document current algorithm
- `sections/04-results.tex` — Add aggregation strategy comparison

**Addressed**: ⬜ No

---

### P1.4: Missing Ablation Studies on Architecture Design ⬜

**Source**: Percy Liang (M2), Michael Bernstein

**Issue**: No evidence that the three-tier design is necessary. What changes with:
- Two tiers instead of three?
- Flat aggregation with tags?
- Different priority thresholds?
- Bottom-up only (no downward flow)?

**Action required**:
1. Add ablation experiments comparing:
   - Three-tier vs. two-tier vs. flat
   - Priority threshold variations
   - Bidirectional vs. unidirectional flow
2. Show full architecture performs measurably better on human agreement, revision efficiency, or outcome quality

**Files to modify**:
- `sections/04-results.tex` — Add "Ablation Studies" subsection
- `sections/03-methodology.tex` — Document baseline/alternative architectures

**Addressed**: ⬜ No

---

### P1.5: No Observability, Testing, or Debugging Infrastructure ⬜

**Source**: Shreya Shankar (M1, M2, M3)

**Issue**: For a software engineering venue, insufficient attention to:
- **Observability**: No metrics, dashboards, anomaly detection for review quality
- **Testing**: No unit tests, integration tests, regression tests, golden datasets
- **Debugging**: No logging, provenance tracking, inspection tools when things go wrong
- **Reliability**: No error handling (API failures, malformed output, state corruption)

**Action required**:
1. Add observability section: Metrics (review quality, consensus, priority distribution), dashboards/alerts, quality checks, drift detection
2. Add testing section: Unit tests per stage, integration tests, golden dataset, test coverage
3. Add debugging infrastructure: Structured logging, provenance tracking (which reviews → which P1/PP1/B1), inspection commands
4. Address reliability: Error handling, retry logic, output validation, state consistency checks

**Files to modify**:
- `sections/03-methodology.tex` — Add "System Observability and Testing" subsection
- `shared/` — Add observability-utils.md, testing-utils.md
- `config/` — Add monitoring.yaml with metric definitions
- `sections/05-discussion.tex` — Add "Operational Considerations" subsection

**Addressed**: ⬜ No

---

## Priority 2: Important Issues (Should Address)

### P2.1: Scalability Claims Not Supported by Evidence ⬜

**Source**: Percy Liang (M3), Shreya Shankar, Ece Kamar (m4)

**Issue**: Claims the architecture "addresses scaling challenges" but evaluation uses only 14 papers across 3 modules — too small. Missing: larger-scale evaluation (50+ papers), complexity analysis, performance metrics, human oversight scalability.

**Action**: Either (1) scale evaluation to 50+ papers, or (2) remove scalability claims and focus on hierarchical synthesis benefits at small scale. Add complexity/performance analysis.

**Files**: `sections/04-results.tex`, `sections/01-introduction.tex` (temper claims), `sections/05-discussion.tex`

---

### P2.2: No Learning from Human Feedback ⬜

**Source**: Ece Kamar (M2), Shreya Shankar

**Issue**: When humans make decisions (mark P1 as "won't fix," reject emergent patterns), the system doesn't learn. Makes the same mistakes repeatedly.

**Action**: Add feedback loops: track human corrections, use to calibrate future classifications, implement reviewer quality scoring based on acceptance rate.

**Files**: `sections/03-methodology.tex` — Add "Learning from Human Feedback" subsection

---

### P2.3: No Mechanism for Handling Reviewer Quality Variation ⬜

**Source**: Michael Bernstein (M2), Shreya Shankar (m4)

**Issue**: All reviewers weighted equally, but quality varies (inconsistent scoring, superficial feedback, domain mismatch). No quality control.

**Action**: Implement reviewer quality scoring (consistency, detail, agreement), weighted aggregation, flag low-quality reviews, conflict resolution for disagreements.

**Files**: `shared/reviewer-selector.md`, `shared/synthesis-engine.md`, `sections/03-methodology.tex`

---

### P2.4: Priority Classification Criteria Are Vague ⬜

**Source**: Percy Liang (m1), Ben Shneiderman

**Issue**: Definitions like "PP1 = cross-paper pattern or threatens module" aren't operationalized.

**Action**: Provide explicit decision rules (e.g., "PP1 if raised in 3+ papers OR flagged as critical by domain expert OR affects module's core claim").

**Files**: `sections/03-methodology.tex`, `config/stages.yaml`

---

### P2.5: Insufficient Transparency and Explainability ⬜

**Source**: Ben Shneiderman (M2), Ece Kamar

**Issue**: Doesn't describe how the system explains classifications to users. Missing: provenance tracking, pattern explanation, confidence indicators, drill-down capability.

**Action**: Add user interface design section: how classifications are presented, evidence displayed, navigation between tiers (include mockups/screenshots).

**Files**: `sections/03-methodology.tex` — Add "User Interface and Explainability" subsection

---

### P2.6: Trust Calibration Not Addressed ⬜

**Source**: Ben Shneiderman (m1), Ece Kamar

**Issue**: No guidance on when to trust vs. question classifications. Users may over-trust incorrect or under-trust correct classifications.

**Action**: Add confidence scoring, historical accuracy metrics, calibration studies showing agreement with human panels.

**Files**: `sections/04-results.tex`, `sections/05-discussion.tex`

---

## Priority 3: Nice-to-Have Improvements (Consider if Time Permits)

### P3.1: Revision Application Workflow Is Underspecified
**Source**: Ben Shneiderman (m2)

### P3.2: No Discussion of System Failure Modes
**Source**: Ben Shneiderman (m3), Shreya Shankar (m1)

### P3.3: Reviewer Diversity Not Discussed
**Source**: Percy Liang (m2), Michael Bernstein (m2)

### P3.4: Missing Related Work on Meta-Review Systems
**Source**: Percy Liang (m3), Michael Bernstein (m3)

### P3.5: Cost and Performance Not Discussed
**Source**: Shreya Shankar (m2)

### P3.6: Data Management and Versioning Are Unclear
**Source**: Shreya Shankar (m3)

### P3.7: Reviewer Persona Consistency Not Validated
**Source**: Shreya Shankar (m4)

### P3.8: Accessibility and Inclusivity Not Considered
**Source**: Ben Shneiderman (m4)

### P3.9: No Discussion of When to Defer to Humans
**Source**: Ece Kamar (m2)

### P3.10: Reviewer Selection Doesn't Optimize for Complementarity
**Source**: Ece Kamar (m3), Michael Bernstein (m2)

### P3.11: No User Study or Deployment Evaluation
**Source**: Michael Bernstein (m4)

### P3.12: Consensus vs. Diversity Not Discussed
**Source**: Michael Bernstein (m1)

---

## Revision Strategy

**Phase 1: Critical validation (P1.1, P1.4)** — ~2-3 weeks
- Add human baseline study (5-10 papers)
- Validate emergent patterns
- Ablation studies (three-tier vs. alternatives)
- Outcome analysis (correlation with paper quality)

**Phase 2: Technical depth (P1.3, P1.5)** — ~1-2 weeks
- Detail aggregation algorithm with worked examples
- Add observability/testing/debugging infrastructure
- Compare aggregation strategies

**Phase 3: Human-AI interaction (P1.2, P2.5, P2.6)** — ~1 week
- Add human oversight mechanisms (confidence-based deferral, overrides)
- Design transparency/explainability features
- Trust calibration guidance

**Phase 4: Polish P2/P3 items** — ~1 week
- Address important issues (P2.1-P2.6)
- Selectively address nice-to-have improvements (P3)
- Update related work, discussion, limitations

**Total estimated effort**: 5-7 weeks for major revision

---

## Status Tracking

| Item | Status | Date | Notes |
|------|--------|------|-------|
| P1.1 | ⬜ Pending | — | Validation study |
| P1.2 | ⬜ Pending | — | Human oversight |
| P1.3 | ⬜ Pending | — | Aggregation algorithm |
| P1.4 | ⬜ Pending | — | Ablation studies |
| P1.5 | ⬜ Pending | — | Observability/testing |
| P2.1 | ⬜ Pending | — | Scalability |
| P2.2 | ⬜ Pending | — | Learning from feedback |
| P2.3 | ⬜ Pending | — | Reviewer quality |
| P2.4 | ⬜ Pending | — | Classification criteria |
| P2.5 | ⬜ Pending | — | Transparency/explainability |
| P2.6 | ⬜ Pending | — | Trust calibration |

---

**Next action**: Address P1 items before advancing to recheck stage.
