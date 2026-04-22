# Round 2 Review: Hierarchical Review Architecture: Scaling Expert Feedback Through Three-Tier Synthesis

**Reviewer**: Ece Kamar (Microsoft Research)
**Expertise**: AI complementarity, human-AI deferral, decision support systems
**Round**: 2
**Date**: 2026-02-07

---

## Overall Assessment

The authors have made significant improvements to the complementarity mechanisms. The confidence-based deferral (Section 3.7) implements exactly what I advocated in Round 1: the system recognizes when its classifications are uncertain and defers to human judgment. The 12% deferral rate with 67% confirmation rate suggests appropriate calibration — the system escalates borderline cases while handling clear cases autonomously.

The validation study (Section 4.6) provides evidence the human-AI division of labor is effective: 73% agreement overall, but confidence correlates with accuracy (r=0.71). This demonstrates the system's uncertainty estimates are well-calibrated, a key requirement for effective complementarity.

My remaining concern is the lack of learning from human feedback. The system tracks overrides (Section 4.8) but doesn't use them to improve future classifications. This is a missed opportunity for adaptive complementarity where the system learns which types of decisions it handles well vs. should defer.

**Previous score**: 3/4 (Accept)
**Updated score**: 4/4 (Strong Accept)

The complementarity mechanisms are now strong enough to warrant strong accept, even without the learning component (which could be future work).

## Changes from Round 1

### ✓ M1: Confidence-Based Complementarity — FULLY ADDRESSED

Section 3.7.1 implements confidence-based deferral exactly as I recommended:

- **Confidence scoring** (Equation 4): Combines frequency (how many reviewers flag the issue) with agreement (semantic similarity of descriptions). This is principled — high confidence requires both multiple mentions and consistent descriptions.

- **Deferral threshold**: confidence < 0.60 triggers human review (12% of items). This is empirically validated: low-confidence items have 54% human agreement vs. 89% for high-confidence items.

- **User experience**: Deferred items show the user: issue description, source reviews, confidence score, contributing factors. This enables informed human decisions rather than just "approve/reject."

The deferral rate (12%) demonstrates good calibration. If it were 50%, the system would overwhelm users with uncertain cases. If it were 1%, it would miss borderline cases that need human judgment.

**Round 1 concern**: "No mechanism for uncertain classifications to defer to humans"
**Resolution**: Confidence-based deferral with empirically validated threshold. ✓

### ✓ M2: Learning from Human Feedback — PARTIALLY ADDRESSED

The system now tracks human overrides and corrections (Section 4.8):
- 3-8% override rate across tiers
- 85% of overrides were correct (human judgment superior to AI)
- Post-override analysis categorizes corrections

However, the paper doesn't describe using this feedback to improve future classifications. The authors acknowledge this as a limitation (Section 5.7) and mention it as future work, which is intellectually honest.

**Round 1 concern**: "System doesn't learn from human corrections"
**Resolution**: Tracking implemented, learning acknowledged as future work. Partially addressed.

### ✓ m1: Complementarity Evaluation — ADDRESSED

Section 4.8 provides complementarity metrics:

- **Efficiency**: 54 minutes wall-clock for 14 papers vs. hours/days for manual review
- **Accuracy**: 73% agreement with human experts (κ=0.69 substantial agreement)
- **Workload distribution**: AI handles 88% of items autonomously, 12% deferred to humans

These metrics demonstrate effective complementarity: the system handles the high-volume common case (88%) while preserving human oversight for edge cases (12%).

**Round 1 concern**: "No measurement of complementarity effectiveness"
**Resolution**: Efficiency, accuracy, and workload metrics provided. ✓

### ✓ m2: Deferral Policy — ADDRESSED

Section 3.7 defines explicit deferral criteria:
- Confidence < 0.60 (low reviewer agreement)
- Emergent patterns with confidence < 0.70 (higher bar for "invisible" patterns)
- High-criticality items (B1 affecting 3+ modules) require unanimous board consent

The tiered thresholds (0.60 for regular, 0.70 for emergent, 1.0 for multi-module B1) demonstrate thoughtful risk-based deferral: higher-stakes decisions require higher confidence.

**Round 1 concern**: "No discussion of when to defer to humans"
**Resolution**: Explicit deferral policy with risk-based thresholds. ✓

### ✓ m3: Reviewer Selection for Complementarity — PARTIALLY ADDRESSED

Section 3.2 (paper tier) mentions "matched to domain and venue" but doesn't detail complementarity optimization (ensuring diverse, non-overlapping perspectives). Section 4.3 shows reviewers have moderate agreement (ρ=0.68 paper-panel, 0.71 panel-board), suggesting some diversity.

The paper doesn't explicitly address my concern about optimizing panel composition for complementarity vs. consensus.

**Round 1 concern**: "Reviewer selection doesn't optimize for complementary perspectives"
**Resolution**: Moderate agreement suggests diversity, but not explicitly optimized. Partially addressed.

## Minor Remaining Issues

### m1: Adaptive Deferral Thresholds

The confidence threshold (0.60) is fixed across all papers and domains. But some domains might be harder to classify (novel research areas, interdisciplinary papers) and benefit from lower thresholds (more deferral). Has the system been tested with adaptive thresholds based on paper characteristics?

**Suggestion**: Future work could explore per-paper or per-domain threshold tuning based on classification difficulty.

### m2: Active Learning for Feedback

Beyond passive learning from overrides, the system could actively request feedback on items it's most uncertain about. This would enable efficient human teaching: focus human effort on the examples that improve the model most.

**Suggestion**: Add to future work: active learning where the system identifies high-value feedback requests (e.g., "I'm uncertain about this P1/P2 boundary; can you label 5 examples?").

### m3: Complementarity Metrics Over Time

The complementarity metrics (12% deferral, 73% agreement) are measured at a single point. How do these evolve as the system is used? Does agreement improve (system learns patterns) or degrade (reviewer drift, domain shift)?

**Suggestion**: In future deployment, track complementarity metrics over time to detect degradation and trigger recalibration.

## Strengths (Updated)

1. **Well-calibrated uncertainty**: Confidence scores correlate with human agreement (r=0.71), enabling principled deferral decisions.

2. **Risk-based deferral policy**: Higher thresholds for higher-stakes decisions (0.60 regular, 0.70 emergent, 1.0 multi-module B1) demonstrates thoughtful risk management.

3. **Empirical complementarity validation**: 88% autonomous handling, 12% human oversight, 73% agreement shows effective human-AI division of labor.

4. **Operational efficiency**: 54 minutes vs. hours/days for manual review demonstrates practical value while preserving human control.

5. **Transparency for trust**: Provenance tracking and confidence indicators enable informed human decisions rather than blind trust.

## Questions for Authors

1. Have you experimented with different confidence thresholds (0.50, 0.70, 0.80)? How sensitive is the deferral rate and agreement to threshold choice?

2. For the 12% deferred items, what's the average time for human review? Does deferral create bottlenecks or is it absorbed smoothly?

3. Have you observed cases where the system should have deferred but didn't (high confidence but wrong)? What characterizes these false confidence cases?

4. If you implemented learning from overrides, what would you update — the confidence scoring formula, the semantic clustering threshold, or the reviewer persona prompts?

## Recommendations for Camera-Ready

- **Expand on learning roadmap**: Section 5.7 mentions learning as future work. Briefly describe what specifically would be learned (confidence calibration? clustering thresholds? reviewer weights?) and how (supervised learning on overrides? Active learning?).

- **Compare to other deferral mechanisms**: Cite work on learned deferral (Mozannar & Sontag 2020, Madras et al. 2018) and compare your confidence-based approach to learned classifiers.

- **Report deferral latency**: In addition to the 54-minute wall-clock time, report how much time humans spend on the 12% deferred items. This completes the efficiency picture.

- **Discuss failure modes of confidence**: When is confidence misleading? (All reviewers confidently wrong, or confidence high but human disagreement for valid reasons.) This helps users calibrate trust.

---

**Overall verdict**: This is now excellent work on human-AI complementarity for research methodology. The confidence-based deferral, risk-based thresholds, and empirical validation demonstrate thoughtful system design. The lack of adaptive learning is a limitation but doesn't prevent strong accept — it's appropriate future work.

**Recommendation**: Strong Accept for publication.

---

> **AI Simulation Disclosure**: This review was generated by an AI system (Claude, Anthropic)
> simulating the perspective of Ece Kamar based on her published work on human-AI complementarity,
> deferral mechanisms, and collaborative decision-making. Ece Kamar did not write this review and
> has no involvement with this work. This is a synthetic artifact for testing the hierarchical
> review system described in the paper.
