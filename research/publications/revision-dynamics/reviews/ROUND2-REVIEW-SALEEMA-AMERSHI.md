# Review: Multi-Round Revision Dynamics (Round 2)

**Reviewer**: Saleema Amershi (Microsoft Research)
**Expertise**: Interactive machine learning, human-in-the-loop systems
**Round**: 2
**Date**: 2026-02-05

---

## Overall Assessment

The revision significantly strengthens the paper. The revision process analysis (Section 5.3) directly addresses my main concern—the feedback loop is no longer a black box. The timing data, strategy documentation, and interpretation challenge analysis (20% divergence rate) provide the interaction-level insight I was looking for. The interactive ML framing in the Related Work (Section 2.5) properly positions the contribution.

The failure mode analysis (Section 5.4) is particularly valuable. The distinction between "addressed" and "resolved" (85% vs. 10% rework) is an important finding for anyone designing human-AI feedback systems. The "whack-a-mole" pattern—where fixing one issue introduces another—is a well-known challenge in iterative systems and deserves the attention it now receives.

The statistical methodology (Section 3.4) and the explicit "descriptive pilot study" framing address the methodological concerns well. The review content analysis across rounds (Section 5.5) provides partial evidence against score inflation, which was one of my specific concerns.

The paper is now a well-rounded empirical study of a human-AI feedback loop, with appropriate caveats and transparency.

## Score

**Score**: 3/4 — Accept

## Major Issues (Blocking)

None. All previous major issues have been addressed.

## Minor Issues

### m1: Learning Curve Effect Still Unexamined
My round 1 question about whether the author learned to revise more effectively over the study remains unanswered. Did later papers in the sequence (e.g., paper 12-14) require fewer rounds or show faster convergence than earlier papers (1-3)? This would reveal whether there's a meta-learning effect in the revision process itself.

### m2: Review Content Analysis Could Test for Inflation More Rigorously
The review content comparison (Table 5) is useful but the 34% "new issues" metric could be decomposed: are new issues of similar severity, or are they predominantly minor? If round 2 "new issues" are mostly minor while round 1 issues were major, this is consistent with genuine improvement, not inflation.

## Strengths

1. Revision process analysis provides the interaction transparency needed for a process study
2. 20% interpretation divergence rate is a novel, actionable finding for feedback system design
3. P1 classification accuracy analysis (85% confirmed, 10% rework, 5% misclassified) provides concrete metrics for the triage system's effectiveness
4. Statistical methodology section with paper-level bootstrap is well-designed for the data structure

## Questions for Authors

1. Based on the 20% interpretation divergence, would you recommend that synthesis engines include explicit acceptance criteria for each P1 item?

## Recommendations

- Test for author learning curve effect across the sequence of 14 papers
- Decompose the "new issues" in round 2 by severity level

---

**Verdict**: Accept with Minor Revisions

**Confidence**: High — The paper now properly characterizes the human-AI feedback loop dynamics.
