# Review: From Reviews to Revisions: Automated Synthesis and Priority Classification of Expert Feedback

**Reviewer**: Denny Zhou (Google DeepMind)
**Expertise**: Structured decomposition, self-consistency, reasoning
**Round**: 1
**Date**: 2026-02-05

---

## Overall Assessment

The paper proposes structured decomposition of multi-reviewer feedback into a prioritized action plan via three stages: extraction, deduplication, and classification. The decomposition is logical and the P1/P2/P3 framework is intuitive. The paper is well-written and the pipeline is clearly described.

My primary concern is the lack of formal analysis of the classification rules. The P1 threshold (3+ reviewers OR any major) is presented as calibrated but no systematic analysis justifies this particular threshold over alternatives. The paper would benefit from analyzing the sensitivity of the classification to different threshold choices, which would make the contribution more principled rather than heuristic.

## Score

**Score**: 3/4 — Accept

## Major Issues (Blocking)

### M1: Threshold Sensitivity Not Analyzed
The P1 rule uses "3+ reviewers" as the threshold for a panel of 5-9 reviewers. Why 3? What happens at 2? At 4? The paper should include a sensitivity analysis showing how the 72% score impact changes as the threshold varies. This would demonstrate that the chosen threshold is robust rather than lucky.

## Minor Issues

### m1: No Formal Definition of "Issue Equivalence"
The deduplication step groups "similar issues" but the similarity function is not formally defined. For a paper about structured methodology, this is surprisingly informal.

### m2: The "Any Major" Override Deserves More Analysis
The paper acknowledges this can overweight idiosyncratic concerns (Section 6) but does not quantify how often this happens. What percentage of P1 items were elevated solely by the override?

### m3: Missing Ablation Studies
What is the contribution of each pipeline stage? What if you skip deduplication and classify raw issues? What if you use only reviewer count without severity?

### m4: Priority Distribution Should Be Related to Panel Size
The paper treats panels of 5 and panels of 9 with the same threshold. Presumably larger panels should have higher thresholds. This adaptive threshold is mentioned in future work but seems essential.

## Strengths

1. The three-stage decomposition is clean and each stage has a clear purpose
2. Strong empirical finding: P1 = 72% of improvement is a compelling validation
3. The software engineering bug triage analogy is apt and will be accessible to the AAAI audience
4. Honest limitations section that identifies key concerns the authors themselves recognize

## Questions for Authors

1. Can you provide a sensitivity curve showing P1 score impact vs. reviewer count threshold?
2. How many P1 items were classified as P1 solely due to the "any major" override (i.e., raised by fewer than 3 reviewers but flagged as major)?
3. Have you considered using severity as a continuous signal rather than binary (major/minor)?

## Recommendations

- Add threshold sensitivity analysis as a core evaluation component
- Formalize the similarity function used in deduplication
- Include ablation study: full pipeline vs. no deduplication vs. no severity signal
- Consider adaptive thresholds based on panel size

---

**Verdict**: Accept with Minor Revisions

**Confidence**: High — Structured decomposition and classification are directly in my area.
