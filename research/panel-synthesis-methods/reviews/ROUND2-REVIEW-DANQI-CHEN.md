# Review: From Reviews to Revisions — Automated Synthesis (Round 2)

**Reviewer**: Danqi Chen (Princeton University)
**Expertise**: Dense retrieval, question answering, NLP systems
**Round**: 2
**Date**: 2026-02-05

---

## Overall Assessment

The deduplication method is now fully specified and the paper's core NLP contribution is reproducible. The use of \texttt{text-embedding-3-small} with cosine similarity and a grid-searched threshold of 0.82 is a reasonable design choice — not novel in isolation, but well-calibrated for this specific task. The precision/recall curve and the worked example make the method concrete.

The external validation on PeerRead reviews is the most important addition. The 5–8 pp performance gap is informative: it quantifies exactly how much the pipeline depends on structured input formats. The finding that extraction failures dominate on human reviews (unstructured paragraphs, implicit severity) points to a clear direction for future improvement.

The baseline comparison is adequate. The full pipeline's advantage over frequency-based aggregation (94% vs. 76% coverage) confirms that semantic deduplication matters. The gap between severity-weighted voting and the full pipeline (+0.2 score impact) is smaller but still meaningful, suggesting that deduplication contributes incrementally beyond severity estimation.

## Score

**Score**: 3/4 — Accept

## Major Issues (Blocking)

None.

## Minor Issues

### m1: Embedding Model Sensitivity
The pipeline uses \texttt{text-embedding-3-small}. How sensitive are results to the choice of embedding model? A brief comparison with one alternative (e.g., \texttt{text-embedding-3-large} or an open-source model) would characterize this dependency.

### m2: Deduplication Recall Impact on P1
My Round 1 concern about 78% recall (22% of duplicates remaining separate) and its downstream impact on P1 classification is not directly addressed. If duplicates remain separate, some P1 items may be classified as P2 (fewer than 3 reviewers after incomplete merging). Quantify this impact.

### m3: PeerRead Domain Mismatch
PeerRead reviews are from ACL 2017 — NLP reviews from 8 years ago may differ substantially from current AI/ML review norms. Discuss whether this temporal gap affects the validation's conclusions.

## Strengths

1. **Deduplication is now the paper's strongest contribution**: Fully specified, reproducible, well-evaluated with threshold sensitivity.
2. **PeerRead validation breaks circularity**: Small but honest. The performance gap is informative rather than damaging.
3. **Failure mode analysis is practical**: The categorization (false merge, missed extraction, severity misclassification, incomplete attribution) with frequencies is useful for practitioners.
4. **Operational metrics aid adoption**: Knowing that synthesis costs $0.08 and takes 45s is practically useful.

## Questions for Authors

1. What is the marginal cost of using \texttt{text-embedding-3-large} vs. \texttt{text-embedding-3-small}?
2. How would the pipeline handle reviews in languages other than English?

## Recommendations

- Add brief embedding model comparison or sensitivity note
- Quantify the downstream P1 impact of 78% deduplication recall
- Note PeerRead temporal gap in external validation discussion

---

**Verdict**: Accept with Minor Revisions

**Confidence**: High — The deduplication specification and external validation address my primary concerns.
