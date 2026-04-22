# Review: Hierarchical Review Architecture: Scaling Expert Feedback Through Three-Tier Synthesis

**Reviewer**: Ece Kamar (Microsoft Research)
**Expertise**: AI complementarity, human-AI deferral, decision support systems
**Round**: 1
**Date**: 2026-02-07

---

## Overall Assessment

This paper tackles a practical problem in AI-assisted research workflows: coordinating expert feedback across multiple papers and organizational levels. The three-tier hierarchical architecture is well-motivated, and the bidirectional flow between tiers (upward issue escalation, downward directive propagation) makes sense for real research programs.

From a complementarity perspective, I'm interested in how the system divides labor between AI and humans. The architecture automates review generation and synthesis while preserving human decision-making at key gates (revision, submission, acceptance). This is reasonable, but the paper misses opportunities to leverage complementarity principles more deeply:

1. **Selective deferral**: The system should recognize when its priority classifications are uncertain and defer to human judgment, rather than uniformly classifying all issues.

2. **Learning from human corrections**: When humans override P1/PP1/B1 classifications, does the system learn from these corrections to improve future reviews?

3. **Confidence-based routing**: Should high-confidence reviews proceed automatically while low-confidence ones trigger human review?

4. **Expertise matching**: Does the system consider which humans are best suited to evaluate different types of emergent patterns?

The architecture is solid, but more sophisticated complementarity mechanisms would make it stronger. The evaluation demonstrates the system works but doesn't compare it to alternatives or measure complementarity effectiveness.

## Score

**Score**: 3/4 — Accept

The core architecture is sound and addresses a real problem. With revisions incorporating complementarity principles and comparative evaluation, this would be a strong contribution.

## Major Issues (Blocking)

### M1: No Complementarity Mechanisms for Uncertain Classifications

The system classifies issues as P1/P2/P3 based on frequency and severity, but what about cases where the classification is uncertain? For example:

- **Borderline cases**: 2 reviewers flag as major, 3 as minor → is this P1 or P2?
- **Novel issues**: The system identifies an "emergent pattern" never seen before → is this PP1 or spurious?
- **Conflicting priorities**: Paper-level says P1, panel-level says P3 → which takes precedence?

Without uncertainty awareness, the system either (a) makes confident classifications that might be wrong, or (b) forces humans to review everything, negating automation benefits.

**Recommended action**: Add confidence-based complementarity:
- Compute confidence scores for priority classifications (based on reviewer agreement, issue prevalence, historical patterns)
- Automatically proceed for high-confidence classifications (e.g., all 5 reviewers flag as major → definitely P1)
- Defer to human review for low-confidence cases (e.g., 2-3 split → ask human to decide)
- Surface uncertainty explicitly: "P1 (confidence: 0.7)" so humans know when to scrutinize

This improves efficiency (fewer unnecessary human reviews) and safety (humans review uncertain cases).

### M2: No Learning from Human Feedback

The paper describes a closed-loop system where reviews → synthesis → revision → recheck, but it's not a learning system. When humans make decisions, the system doesn't learn from them:

- **Priority corrections**: If an author marks a P1 as "won't fix" with good justification, does the system learn not to over-prioritize similar issues?
- **Pattern validation**: If humans reject an "emergent pattern" as spurious, does the system adjust its pattern detection?
- **Review quality**: If one reviewer consistently gives unhelpful feedback, does the system downweight them?

Without learning, the system makes the same mistakes repeatedly. This is especially problematic for "emergent patterns," which the paper claims are valuable but doesn't validate.

**Recommended action**: Add feedback loops:
- Track human corrections (P1 → P2 downgrades, PP1 rejections, etc.)
- Use corrections to calibrate future priority classifications
- Implement reviewer quality scoring based on how often their feedback is acted upon
- Show metrics: "This reviewer's P1 items are addressed 85% of the time" → high trust

Alternatively, if full learning is out of scope, at least track and report corrections to help users calibrate trust.

## Minor Issues

### m1: Complementarity Evaluation Is Missing

The paper evaluates whether the hierarchy surfaces emergent patterns (it does), but not whether the human-AI division of labor is effective. Key missing measurements:

- **Efficiency**: How much human review time does the system save vs. manual panel review?
- **Accuracy**: Do AI-generated priorities match human expert judgment?
- **Agreement**: When humans do review, how often do they agree with the system's classifications?
- **Workload distribution**: Does the system appropriately balance automated synthesis vs. human oversight?

Without these metrics, we can't assess whether the complementarity is working.

**Suggestion**: Add a complementarity evaluation section:
- Measure human review time with vs. without the system
- Compare AI priority classifications to human expert ground truth on a validation set
- Report human agreement rates with P1/PP1/B1 classifications
- Analyze which types of issues benefit from AI automation vs. require human judgment

### m2: No Discussion of When to Defer to Humans

The paper places human gates at fixed stages (revision, submission, acceptance) but doesn't discuss when the system should dynamically defer within a stage. For example:

- Should the system defer to humans when reviewer scores are widely split (e.g., 1/4 and 4/4)?
- Should emergent patterns above a certain criticality always get human validation?
- Should papers in high-stakes venues (e.g., Nature, Science) get more human oversight?

**Suggestion**: Add a deferral policy section:
- Define criteria for when the system escalates to human review
- Discuss how deferral thresholds can be tuned based on use case (high-stakes vs. exploratory)
- Provide examples of issues that should always be human-reviewed

### m3: Reviewer Selection Doesn't Consider Complementarity

The paper mentions selecting reviewers by expertise (shared/reviewer-selector.md) but doesn't discuss:

- **Complementary perspectives**: Are reviewers selected to provide diverse, complementary views, or do they tend to agree?
- **Human-AI handoff**: Should certain reviewers be "AI-friendly" (good at prompting/verification) vs. domain experts?
- **Conflict resolution**: When reviewers disagree, who adjudicates — another AI or a human meta-reviewer?

**Suggestion**: Extend reviewer selection to optimize for complementarity:
- Ensure panels include reviewers with different priorities (e.g., one systems-focused, one HCI-focused, one evaluation-focused)
- Select reviewers whose feedback complements each other rather than overlaps
- Consider human meta-reviewers for conflict resolution

### m4: Scalability of Human Oversight Is Unclear

The paper claims the architecture "scales expert feedback," but as the portfolio grows (50+ papers, 10+ modules), does human oversight scale? Questions:

- At 100 papers, how many PP1 items does the panel generate? Can humans review them all?
- At 10 modules, how many B1 items does the board generate? Is this manageable?
- Do higher tiers create bottlenecks where humans can't keep up with the volume?

**Suggestion**: Add scalability analysis:
- Plot human review volume vs. portfolio size (papers, modules)
- Identify bottlenecks (e.g., board review becomes infeasible at 10+ modules)
- Propose solutions (e.g., automated pre-filtering, hierarchical human review teams)

## Strengths

1. **Clear human-AI division of labor**: AI handles tedious synthesis, humans make high-stakes decisions (submission, acceptance).

2. **Stage gates preserve human control**: The system can't auto-advance papers without meeting quality thresholds, ensuring human checkpoints.

3. **Bidirectional flow supports collaboration**: Humans set strategic priorities (B1 items) that cascade down, while ground-level issues (P1) bubble up. This is good complementarity design.

4. **Practical deployment**: The system has been used on real papers, showing it's feasible for production use.

5. **Explicit priority classification reduces cognitive load**: Humans don't have to process all feedback equally — P1 items are clearly marked as blocking.

## Questions for Authors

1. How often do humans override or modify the system's priority classifications? What's the agreement rate?

2. Have you observed cases where the system was confidently wrong (e.g., flagged a non-issue as P1)? How were these caught?

3. Does the system track which P1/PP1/B1 items actually get addressed vs. marked "won't fix"? Can this inform future prioritization?

4. How do you handle cases where addressing one P1 item breaks something else (introducing new issues)?

5. What happens when the panel and board give conflicting directives (e.g., panel says "add more evaluation," board says "reduce scope")?

6. Have you considered active learning: the system identifies which papers/issues it's most uncertain about and requests targeted human feedback?

## Recommendations

- **Add confidence-based deferral**: Surface uncertainty and escalate low-confidence classifications to human review.
- **Implement learning from feedback**: Track human corrections and use them to calibrate future prioritization.
- **Evaluate complementarity**: Measure efficiency gains, agreement rates, and optimal human-AI workload distribution.
- **Define deferral policies**: Specify when the system should escalate to human review within a stage.
- **Optimize reviewer selection for complementarity**: Ensure diverse, non-overlapping perspectives.
- **Analyze scalability of human oversight**: Show whether the architecture remains manageable at scale.

---

**Overall verdict**: This is solid systems work on a practical problem. The hierarchical architecture is well-designed and the bidirectional flow is valuable. With deeper attention to complementarity principles — uncertainty-aware deferral, learning from feedback, and efficiency evaluation — this could be a strong contribution to human-AI collaboration research.

---

> **AI Simulation Disclosure**: This review was generated by an AI system (Claude, Anthropic)
> simulating the perspective of Ece Kamar based on her published work on human-AI complementarity,
> deferral mechanisms, and collaborative decision-making. Ece Kamar did not write this review and
> has no involvement with this work. This is a synthetic artifact for testing the hierarchical
> review system described in the paper.
