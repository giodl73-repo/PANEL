# Review: From Reviews to Revisions: Automated Synthesis and Priority Classification of Expert Feedback

**Reviewer**: Michael Bernstein (Stanford)
**Expertise**: Crowdsourcing, human computation, social computing
**Round**: 1
**Date**: 2026-02-05

---

## Overall Assessment

This paper frames multi-reviewer synthesis as a structured aggregation problem, drawing parallels to crowd workflow design. The three-stage pipeline (extract → deduplicate → classify) mirrors established patterns in crowdsourcing: decompose a complex task, aggregate responses, and produce a structured output. From this perspective, the contribution is clear and the design is sound.

However, the paper underexplores the human factors dimension. The synthesis document is only as good as its ability to direct author behavior. Does the author actually follow the P1/P2/P3 ordering? Do they agree with the classifications? Do they find the synthesis more useful than reading reviews individually? These questions about the human side of the pipeline are unaddressed, which limits the paper's contribution to a purely technical system without understanding its actual impact on the revision workflow.

## Score

**Score**: 2/4 — Weak Accept

## Major Issues (Blocking)

### M1: No User Study of Author Behavior
The paper evaluates the synthesis technically (coverage, accuracy, priority distribution) but never studies whether authors find it useful. A synthesis document that is technically correct but that authors ignore or misinterpret has no practical value. Even a small qualitative study with 3-5 authors would address this.

### M2: The "How Does This Compare to Crowd Workflows?" Question
Multi-reviewer synthesis is fundamentally a crowd aggregation problem. The paper does not engage with the extensive literature on answer aggregation (Dawid-Skene, GLAD, spectral methods), quality control in crowdsourcing, or structured crowd workflows. The related work section mentions crowdsourcing in passing but does not draw on the relevant techniques or compare to them.

## Minor Issues

### m1: Reviewer Identity Effects Not Considered
In human crowd work, we know that worker characteristics affect aggregation. Do certain reviewer types (systems vs. HCI vs. NLP) systematically differ in their issue detection patterns? This would inform whether uniform deduplication thresholds are appropriate.

### m2: Conflict Resolution is Underspecified
The paper identifies reviewer conflicts but passes them to the author. In crowd workflow design, disagreements trigger additional adjudication tasks. Could a similar mechanism work here—e.g., soliciting a tie-breaking review focused on the specific conflict?

### m3: No Analysis of Synthesis Document Length
How long are synthesis documents? Is there an information overload problem—do authors actually read the full synthesis, or do they skip to P1?

## Strengths

1. The pipeline design is practical and immediately implementable
2. Deduplication precision of 91% is quite good for an automated system
3. The paper correctly identifies the "erring toward under-merging" design choice as the safer option
4. The evaluation covers multiple relevant dimensions (coverage, attribution, priority agreement)

## Questions for Authors

1. Have any authors used the synthesis documents? What was their experience?
2. How does the P1/P2/P3 classification compare to Dawid-Skene or other crowd aggregation methods applied to the same review data?
3. What is the average length of a synthesis document, and does length correlate with author engagement or revision quality?

## Recommendations

- Conduct a small author study: give 3-5 authors synthesis documents alongside raw reviews and measure which they prefer and how revision behavior differs
- Engage with crowd aggregation literature and position the contribution relative to established methods
- Consider an adaptive conflict resolution mechanism rather than passing conflicts to the author
- Report synthesis document statistics (length, section balance)

---

**Verdict**: Major Revisions Required

**Confidence**: High — Crowd aggregation and human computation workflows are my primary expertise.
