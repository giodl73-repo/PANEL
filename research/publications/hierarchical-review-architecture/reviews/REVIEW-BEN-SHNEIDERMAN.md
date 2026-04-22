# Review: Hierarchical Review Architecture: Scaling Expert Feedback Through Three-Tier Synthesis

**Reviewer**: Ben Shneiderman (University of Maryland)
**Expertise**: Human-Centered AI, human agency, oversight, human control
**Round**: 1
**Date**: 2026-02-07

---

## Overall Assessment

This paper presents a hierarchical architecture for AI-simulated expert reviews that addresses a real coordination problem: how to synthesize feedback across multiple papers and organizational levels. The three-tier structure (paper → panel → board) with bidirectional information flow is conceptually sound, and the priority escalation mechanism (P1/P2/P3 → PP1/PP2/PP3 → B1/B2/B3) provides clear decision-making structure.

From a human-centered AI perspective, I appreciate that the system is designed to support human decision-making rather than replace it. The explicit stage gates, revision tracking, and requirement for human confirmation at key points (submission, acceptance) preserve meaningful human control. However, the paper insufficiently addresses several critical human-AI interaction concerns:

1. **Human oversight of emergent patterns**: When the system identifies "emergent" PP1/B1 issues, how do humans verify these are real problems rather than AI hallucinations or spurious correlations?

2. **Trust calibration**: The paper provides no guidance on when users should trust vs. question the system's priority classifications. Without calibration mechanisms, users may over-trust incorrect classifications or under-trust correct ones.

3. **Agency and control**: While humans confirm final decisions, the intermediate review synthesis is fully automated. What happens when the system consolidates reviews incorrectly or misclassifies priorities?

4. **Transparency and explainability**: The paper doesn't describe how the system explains its priority classifications or how users can inspect the reasoning behind emergent pattern detection.

These concerns are addressable, and the core architecture is valuable. But for a venue interested in software engineering research methodology, the human factors need more attention.

## Score

**Score**: 3/4 — Accept

The architecture is solid and the problem is important. With revisions addressing human oversight and trust calibration, this could be a strong contribution to research methodology.

## Major Issues (Blocking)

### M1: No Mechanism for Human Oversight of AI-Generated Priorities

The system automatically classifies issues as P1/P2/P3, PP1/PP2/PP3, B1/B2/B3 based on reviewer frequency and severity. But AI reviewers can be systematically wrong — they might all miss the same critical issue or all flag the same spurious concern. The paper provides no mechanism for humans to:

- **Override priority classifications**: What if 4 reviewers say P1 but the author knows it's not blocking?
- **Challenge emergent patterns**: What if the panel identifies a "cross-paper pattern" that doesn't actually exist?
- **Inject domain expertise**: What if the board flags B1 issues that are actually venue-specific and not strategic?

Without human oversight mechanisms, the system risks amplifying AI errors through the hierarchy. A single misclassification at the paper level can cascade into PP1 and B1 priorities affecting multiple papers.

**Recommended action**: Add human oversight mechanisms at each tier:
- **Paper level**: Allow authors to contest P1 classifications with justification, require human review before blocking
- **Panel level**: Require human panel chair to approve PP1 items before propagating to papers
- **Board level**: Require human board review of B1 items before cascading to modules

Alternatively, implement confidence scoring and require human confirmation for low-confidence classifications.

### M2: Insufficient Transparency and Explainability

When the system identifies an emergent pattern (e.g., "37% of PP1 priorities are emergent"), how does it explain this to users? The paper describes the architecture but not the user experience. Critical missing elements:

- **Provenance tracking**: Can users see which paper-level reviews contributed to a PP1 item?
- **Pattern explanation**: When the panel flags a "cross-paper pattern," what evidence is shown?
- **Confidence indicators**: Are priority classifications shown with confidence levels?
- **Alternative views**: Can users toggle between consolidated synthesis and individual reviews?

Transparency is essential for trust and effective human oversight. Users need to understand *why* the system made each classification to make informed decisions.

**Recommended action**: Add a user interface design section showing:
- How priority classifications are presented to users
- How provenance and evidence are displayed
- How users navigate between tiers and drill down into specific reviews
- Example screenshots or mockups of the review interface

## Minor Issues

### m1: Trust Calibration Not Addressed

The paper claims emergent patterns are "invisible at lower tiers" but provides no mechanism to help users distinguish between:
- **True emergents**: Patterns that genuinely appear only at higher tiers
- **False positives**: Spurious correlations the system incorrectly identifies
- **Missed issues**: Critical problems no tier identifies

Without calibration guidance, users don't know when to trust the system. This is especially problematic for emergent patterns, which by definition aren't validated by individual paper reviews.

**Suggestion**: Add:
- Confidence scoring for emergent patterns
- Historical accuracy metrics (what % of past PP1/B1 items were actually important?)
- Calibration studies showing agreement with human expert panels

### m2: Revision Application Is Underspecified

The paper mentions a "revision" stage where authors address P1/PP1/B1 items, but the human-AI workflow is unclear:
- Does the system suggest specific LaTeX edits, or just list issues?
- Can authors mark items as "won't fix" with justification?
- How are revisions verified — by AI re-review or human judgment?
- What happens if addressing one P1 introduces new issues?

The revision process is where human agency matters most. The paper should detail how humans and AI collaborate during revision.

**Suggestion**: Add a subsection on "Human-AI Collaboration During Revision" describing:
- What revision assistance the system provides
- How authors communicate with the system (accept/reject suggestions, request alternatives)
- How revision completeness is verified

### m3: No Discussion of System Failure Modes

What happens when the system fails? Likely failure modes:
- **Conflicting priorities**: Paper-level P1 contradicts panel-level PP1
- **Review quality variation**: One reviewer gives superficial feedback while others are detailed
- **Adversarial usage**: Authors game the system to get favorable reviews
- **Drift over time**: Review quality degrades as reviewers are reused

The paper should discuss failure modes and how the architecture handles them.

**Suggestion**: Add a "Limitations and Failure Modes" section discussing:
- Known failure cases
- Robustness mechanisms (conflict resolution, quality checks)
- How system degradation is detected and corrected

### m4: Accessibility and Inclusivity Not Considered

The system generates long review documents (REVIEW-*.md, SYNTHESIS.md, PANEL-REVISION-PLAN.md). For users with different needs:
- **Cognitive load**: Can users get executive summaries or progressive disclosure?
- **Visual accessibility**: Are the markdown files screen-reader friendly?
- **Language**: Does the system support non-English reviews or papers?
- **Expertise levels**: Can novice researchers interpret the priority classifications?

**Suggestion**: Add a discussion of accessibility considerations and how the system adapts to diverse user needs.

## Strengths

1. **Preserves human control at decision points**: The system requires human confirmation for submission and acceptance, not just auto-submitting based on scores.

2. **Explicit priority structure reduces cognitive load**: P1/P2/P3 classification helps authors focus on what matters most rather than processing all feedback equally.

3. **Bidirectional flow supports human agency**: Authors aren't just passive recipients of top-down directives — they can address P1 items and propagate fixes upward.

4. **Stage gates prevent premature advancement**: The system won't advance papers until quality thresholds are met, ensuring human review at appropriate checkpoints.

5. **Operational implementation shows feasibility**: The system has been deployed and used, demonstrating it's practical for real use.

## Questions for Authors

1. How do you envision users interacting with the system? Is there a GUI, or do they work directly with markdown files?

2. Have you observed cases where users disagreed with P1/PP1/B1 classifications? How were those resolved?

3. What happens if a reviewer gives a score of 1/4 (reject) but others give 3/4? Does the system flag this for human review?

4. Can users customize the priority thresholds (e.g., make PP1 require 4 papers instead of "cross-paper pattern")?

5. How do you prevent reviewer persona drift? Do AI reviewers give consistent feedback over time?

## Recommendations

- **Add human oversight mechanisms**: Require human confirmation for high-stakes classifications (P1, PP1, B1).
- **Design for transparency**: Show users the evidence and reasoning behind each priority classification.
- **Include trust calibration guidance**: Help users distinguish trustworthy classifications from questionable ones.
- **Detail the revision workflow**: Describe how humans and AI collaborate during paper revision.
- **Address failure modes**: Discuss what goes wrong and how to detect/correct it.
- **Consider accessibility**: Ensure the system works for diverse users with different needs and expertise levels.

---

**Overall verdict**: This is valuable work on an important problem. The architecture is sound and preserves human control at key decision points. With stronger attention to transparency, oversight, and trust calibration, this could be an excellent contribution to research methodology and human-centered AI.

---

> **AI Simulation Disclosure**: This review was generated by an AI system (Claude, Anthropic)
> simulating the perspective of Ben Shneiderman based on his published work on Human-Centered AI
> (HCAI), human agency, and human control principles. Ben Shneiderman did not write this review
> and has no involvement with this work. This is a synthetic artifact for testing the hierarchical
> review system described in the paper.
