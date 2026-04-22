# Review: Calibrating AI Reviewer Personas (Round 2)

**Reviewer**: Percy Liang (Stanford / HELM)
**Expertise**: Evaluation methodology, language model benchmarking, transparency
**Round**: 2
**Date**: 2026-02-05

---

## Overall Assessment

The revision substantially strengthens the paper's empirical rigor. The addition of Krippendorff's alpha (0.41) and ICC (0.38) alongside Spearman correlations provides the standard inter-rater reliability metrics expected at NLP venues. The bootstrap confidence intervals and random baselines for JS divergence address my core concern about statistical interpretability. The comparison against published EMNLP/ACL review statistics is a valuable addition — finding that AI panels fall within the range of human reviewer agreement patterns lends credibility to the calibration claims.

The four-method comparison (no persona → name-only → full profile → retrieval-augmented) clearly decomposes the contribution of each persona construction approach. The progressive ablation confirming key-question injection as the dominant mechanism (+0.15 JS divergence) is a clean result. The finding that retrieval augmentation provides only marginal additional benefit is interesting and practically useful.

The failure analysis revealing domain-mismatch as the primary failure mode is insightful and directly actionable. The clustering methodology is now properly documented (Ward's linkage, silhouette analysis).

Remaining concerns are minor: the 5-paper subset for the method comparison is small, and the venue statistics comparison is distributional rather than review-level.

## Score

**Score**: 3/4 — Accept

## Minor Issues

### m1: Method Comparison Sample Size
The four-method comparison uses only 5 papers. While the direction is clear and the differences large, framing these as preliminary results would be appropriate.

### m2: Venue Comparison Granularity
The comparison against published statistics is at the distributional level. Comparing specific review patterns (e.g., what topics human reviewers focus on vs. AI reviewers) would strengthen the validation.

## Strengths

1. **Statistical rigor now meets venue standards**: Krippendorff's alpha, ICC, bootstrap CIs, random baselines, silhouette analysis.
2. **Four-method comparison is clean**: Clear decomposition from no persona to retrieval-augmented.
3. **Progressive ablation is compelling**: Key-question as dominant mechanism (+0.15 JS divergence) is well-quantified.
4. **Failure analysis is actionable**: Domain-mismatch pattern has direct implications for panel design.

---

**Verdict**: Accept with Minor Revisions

**Confidence**: High — The statistical improvements directly address my Round 1 concerns.
