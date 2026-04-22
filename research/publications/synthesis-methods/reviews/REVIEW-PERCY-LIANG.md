# Review: From Reviews to Revisions: Automated Synthesis and Priority Classification of Expert Feedback

**Reviewer**: Percy Liang (Stanford)
**Expertise**: Benchmarks, evaluation methodology, foundation models
**Round**: 1
**Date**: 2026-02-05

---

## Overall Assessment

This paper presents a three-stage pipeline (issue extraction, cross-reviewer deduplication, priority classification) for consolidating multi-reviewer feedback into prioritized revision guidance. The core idea—that P1/P2/P3 triage directs author effort effectively—is validated by the finding that P1 items account for 72% of score improvement.

The paper addresses a genuine practical gap. Anyone who has received 5+ reviews knows the cognitive burden of manual synthesis. The structured approach is sensible and the evaluation, while limited in scope, supports the central claim. However, I have significant concerns about how the evaluation was conducted and whether the reported metrics are meaningful given the self-contained nature of the system.

## Score

**Score**: 2/4 — Weak Accept

## Major Issues (Blocking)

### M1: Circular Evaluation Methodology
The system generates reviews, synthesizes them, then evaluates the synthesis against the same generated reviews. The 72% score improvement metric is measured within rounds of the same system. This creates a circular validation: the priority classification is tuned to the same review generation process. There is no independent ground truth. How would this synthesis method perform on reviews written by actual human experts?

### M2: No Comparison to Baselines
The paper claims the synthesis is effective but compares to nothing. What happens if an author simply reads reviews sequentially? What if they use a naive "sort by frequency" approach? What about existing meta-review tools from OpenReview or other platforms? Without baselines, we cannot assess whether the three-stage pipeline adds value beyond simpler alternatives.

### M3: Evaluation Scale and Generalizability
33 review cycles across 14 papers is a small dataset, and all papers appear to come from a single research program. The paper acknowledges the 8-category topic taxonomy is designed for AI/ML systems papers, but the claims are stated broadly. The contribution needs to be scoped more carefully, or the evaluation needs to include papers from other domains and research groups.

## Minor Issues

### m1: Deduplication Threshold Not Specified
The paper mentions a "merge threshold" for semantic similarity but never specifies what it is. This is a critical parameter that affects the entire pipeline.

### m2: Section 4 Statistics Lack Error Bars
The priority distribution table (Table 3) reports averages without confidence intervals. With only 33 cycles, variance matters.

### m3: Missing Discussion of LLM-Specific Artifacts
Since reviews are AI-generated, they may share systematic biases (e.g., always flagging "generalization concerns"). The deduplication step might conflate genuine consensus with LLM-generated uniformity.

## Strengths

1. Clear three-stage pipeline design that is easy to understand and implement
2. The P1/P2/P3 classification is well-motivated by the software engineering bug triage analogy
3. Honest discussion of limitations, including the "any major" override concern

## Questions for Authors

1. Have you tested this synthesis pipeline on human-written reviews? Even a small comparison would significantly strengthen the paper.
2. What is the semantic similarity threshold for deduplication, and how sensitive are results to this parameter?
3. The 72% figure—is this consistent across all 14 papers, or are there outliers that drive the average?

## Recommendations

- Add at least one baseline comparison (even "read reviews sequentially" as a lower bound)
- Include a small-scale validation with human-written reviews from a public review dataset (e.g., PeerRead, ICLR OpenReview)
- Report confidence intervals on all aggregate statistics
- Specify all pipeline parameters explicitly

---

**Verdict**: Major Revisions Required

**Confidence**: High — Evaluation methodology is my primary area; the circular validation concern is fundamental.
