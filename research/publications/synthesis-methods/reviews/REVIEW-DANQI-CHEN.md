# Review: From Reviews to Revisions: Automated Synthesis and Priority Classification of Expert Feedback

**Reviewer**: Danqi Chen (Princeton)
**Expertise**: Dense retrieval, question answering, NLP
**Round**: 1
**Date**: 2026-02-05

---

## Overall Assessment

This paper presents an automated pipeline for synthesizing multi-reviewer feedback. From an NLP perspective, the core technical components—issue extraction, semantic deduplication, and classification—are well-established NLP tasks applied to a specific domain. The paper's strength lies not in novel NLP methods but in the thoughtful application of known techniques to a practical problem.

The extraction and deduplication stages are technically sound but underspecified. The paper describes what these stages do but not how they do it in sufficient detail for reproducibility. For a venue like AAAI, I would expect either novel methods or a thorough engineering contribution with full reproducibility—this paper currently falls between the two.

## Score

**Score**: 3/4 — Accept

## Major Issues (Blocking)

### M1: Insufficient Technical Detail on Deduplication
The deduplication stage uses "semantic similarity" but the specific method is unspecified. Is this embedding-based (which encoder? what dimensionality?), rule-based (what rules?), or LLM-prompted (what prompt?)? The 91% precision / 78% recall figures are meaningful only if the method is reproducible. This is the paper's core NLP contribution and it deserves a full technical description.

## Minor Issues

### m1: Issue Extraction Relies on Template Structure
The extraction stage leverages the structured review template (major/minor separation). This is a strength (reliable extraction) but also a limitation: the method may not generalize to free-form reviews without section headings. This should be discussed explicitly.

### m2: Topic Taxonomy is Fixed and Narrow
The 8-category taxonomy is presented without justification. How were these categories chosen? Were they derived from data analysis or expert intuition? A data-driven taxonomy would be more convincing.

### m3: Recall at 78% Means Substantial Information Loss
22% of duplicate issues remaining separate means the synthesis may overcount issues. If 3 reviewers raised the same concern but 2 copies were merged and 1 left separate, the "3+ reviewers" threshold might not be met—potentially underclassifying P1 items.

### m4: No Error Analysis by Issue Type
Which types of issues are hardest to deduplicate? Are methodology issues easier to match than framing issues? An error analysis would guide improvement.

## Strengths

1. Practical application of NLP techniques to a real problem
2. The evaluation is multifaceted: precision/recall for deduplication, coverage and attribution for synthesis quality, and score impact for priority classification
3. The paper is clearly written with good use of tables
4. The "safer to under-merge" design philosophy is well-reasoned

## Questions for Authors

1. What specific method is used for semantic similarity in the deduplication stage?
2. How does deduplication recall (78%) affect downstream priority classification? Have you measured the impact?
3. Could you apply the pipeline to reviews from a public dataset (e.g., ICLR OpenReview) to demonstrate domain transfer?

## Recommendations

- Fully specify the deduplication method with enough detail for reproduction
- Add error analysis: which issue types are hardest to deduplicate?
- Measure the impact of deduplication recall on downstream P1 classification accuracy
- Discuss limitations of template-dependent extraction

---

**Verdict**: Accept with Minor Revisions

**Confidence**: High — NLP pipeline design and evaluation are core to my research.
