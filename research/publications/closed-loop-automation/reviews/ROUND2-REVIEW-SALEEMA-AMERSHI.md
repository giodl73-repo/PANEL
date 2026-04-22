# Review: From Reviews to Revisions: Closed-Loop Automation of Academic Paper Improvement

**Reviewer**: Saleema Amershi (Microsoft Research)
**Expertise**: Interactive Machine Learning, Human-in-the-Loop Systems
**Round**: 2
**Date**: 2026-02-07

---

## Overall Assessment

The revision makes **significant progress** on interactive ML and learning mechanisms. The two new Future Work subsections ("Learning from Author Feedback" and "Reflection Across Rounds") provide exactly the detailed designs I requested. The preference modeling architecture (logistic regression on edit features) is concrete and implementable. The reflection log structure (edits → reviewer responses → adjustments) mirrors Reflexion architectures appropriately.

The paper now engages seriously with interactive ML principles: learning from user feedback, personalization, and mixed-initiative interaction. The selective automation concept (authors configure preferences) shows awareness of user agency in interactive systems.

My remaining concerns are: (1) these designs are Future Work rather than implemented/evaluated, and (2) the author experience data is thin. However, the paper is honest about this and the designs are detailed enough to be actionable.

## Score

**Score**: 3/4 — Accept

## Major Issues Resolved

### ✓ M1: Learning from Author Feedback (RESOLVED)

The "Learning from Author Feedback" subsection is excellent. The architecture is concrete:
- Data collection: edit metadata + author action + explanation
- Preference modeling: logistic regression predicting P(accept | edit features)
- Cross-author learning: aggregate data to identify safe edit types
- Cold start: conservative strategy for new authors, personalize after 10-15 edits

The estimated impact (82% completion, down to 4% rejection) is plausible given the approach. This is a genuine contribution to interactive ML for writing assistance.

**Caveat**: This is Future Work, not implemented. The paper would be stronger with at least a pilot implementation (even on 2-3 papers) to validate feasibility. But the design is detailed enough that I'm satisfied.

### ✓ M2: Personalization and Reflection (RESOLVED)

The "Reflection Across Rounds" subsection provides the meta-cognitive architecture I wanted. The memory structure (reflection log mapping edits → responses → adjustments) is clear. The strategy adjustment queries (which edits insufficient? which reviewers unsatisfied?) are practical.

The meta-cognitive prompting example is helpful: "You previously added power analysis but Reviewer A noted effect size too optimistic — how revise?" This shows concrete implementation.

The estimated impact (1.6 rounds from 2.0) is reasonable given that reflection would address issues more thoroughly in earlier rounds.

### ✓ M3: Mixed-Initiative Interaction (PARTIALLY RESOLVED)

The "Human Agency" subsection discusses selective automation (authors specify which tasks to automate vs. flag for review) and the Future Work mentions "Human-in-the-loop planning" (plan then execute rather than execute then review). These address the mixed-initiative concern.

However, the paper doesn't deeply analyze the interaction model trade-offs. For example:
- Batch (current): efficient but low control
- Stepwise (plan then execute): high control but slower
- Confidence-based (automate high-confidence, flag low-confidence): balanced but requires good calibration

A comparison table or brief analysis would strengthen the discussion. Not blocking, but a missed opportunity.

## Minor Issues

### m1: Author Experience Data Lacks Depth

The author experience section (7 interviews) provides useful quotes but lacks the depth typical of HCI papers. Missing:
- Systematic coding of interview transcripts
- Themes beyond satisfaction/trust/control (e.g., learning, ownership, creativity)
- Comparison to expectations (did authors expect to feel loss of control?)
- Variation by author experience level (novice vs. expert)

For a paper targeting CSCW, richer qualitative data would strengthen claims about author agency and learning.

### m2: No Confidence Scores in Current System

The Future Work mentions confidence scores (based on reviewer consensus, edit type, localization difficulty) but the current system doesn't implement them. This is a limitation for authors trying to prioritize review effort.

Even a simple heuristic (P1 + 3 reviewers = high confidence, P3 + 1 reviewer = low confidence) would help. Consider adding this as a minor enhancement rather than future work.

### m3: Cold Start Problem Underspecified

The learning architecture mentions "cold start: conservative for new authors, personalize after 10-15 edits." But 10-15 edits is ~1 paper for most authors. What happens for authors who revise only 1 paper? Do they never benefit from personalization?

Alternative: Use cross-author priors (avg preferences across all authors) as initial model, then fine-tune with author-specific feedback. This would help even single-paper authors.

## Strengths

1. **Detailed learning architecture** — Preference modeling with concrete features and algorithms
2. **Reflection mechanisms** — Memory structure, strategy adjustment, meta-cognitive prompting
3. **Interactive ML principles** — Learning from feedback, personalization, cold start strategy
4. **Estimated impact** — Plausible quantitative predictions (82% completion, 1.6 rounds)
5. **Selective automation concept** — Shows awareness of user agency

## Questions for Authors

1. Why keep learning mechanisms as Future Work rather than implementing them? Even a pilot on 2-3 papers would validate feasibility.

2. Have you analyzed the 28 modified/rejected edits (4% + 2%) to identify patterns? This would inform the preference model features.

3. Could you add confidence scores to the current system as a minor enhancement (rather than waiting for full learning architecture)?

4. For cold start, have you considered using cross-author priors rather than conservative strategy? This would help single-paper authors.

5. What interaction model do you recommend for future systems: batch, stepwise, confidence-based, or hybrid?

## Recommendations

- Implement pilot learning study (even 2-3 papers) to validate preference modeling feasibility
- Expand author experience section with deeper qualitative analysis (systematic coding, themes)
- Add confidence scores to current system (simple heuristic based on reviewer consensus + edit type)
- Discuss cold start alternatives (cross-author priors) and trade-offs
- Add comparison table of interaction models (batch vs. stepwise vs. confidence-based)

---

**Verdict**: Accept

**Confidence**: High — The paper now engages seriously with interactive ML principles. The learning and reflection architectures are detailed and implementable. While I wish they were implemented, the designs are strong contributions to HITL systems.

---

> **AI Simulation Disclosure**: This review was generated by a large language model
> (Claude, Anthropic) simulating the perspective of the named reviewer. The named
> individual did **not** write or endorse this review. The AI persona is informed by
> the reviewer's published work, known research priorities, and public scholarship,
> but the opinions expressed are synthetic outputs, not the actual views of the
> named researcher. This process is used for pre-submission quality improvement and
> does not represent a real peer review.
