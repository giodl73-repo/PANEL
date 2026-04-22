# Review: Cross-Portfolio Expert Panels: Holistic Assessment of Multi-Paper Research Programs

**Reviewer**: Ludwig Schmidt (University of Washington)
**Expertise**: Distribution shift, robustness, evaluation methodology
**Round**: 1
**Date**: 2026-02-05

---

## Overall Assessment

This paper introduces cross-portfolio expert panels for assessing multi-paper research programs. The key claim is that portfolio-level assessment surfaces qualitatively different insights compared to individual paper review. The evidence for this claim rests primarily on the 6 cross-cutting themes identified in Section 5, particularly Theme 1 (convergent architecture) and Theme 2 (mutual validation), which are indeed invisible at the individual paper level.

The paper's statistical analysis of reviewer agreement is a strength. The Spearman correlation analysis revealing three reviewer blocs with within-bloc agreement (ρ = 0.60-0.80) and between-bloc near-orthogonality (ρ = 0.05-0.10) is an interesting finding that goes beyond simple inter-rater reliability. However, the analysis raises more questions than it answers: is this bloc structure stable? Does it generalize to other portfolios? How does it relate to known disciplinary divides in the literature?

My primary concern is that the paper lacks the distributional analysis needed to assess robustness. The rankings are presented as point estimates (average scores) without confidence intervals or bootstrap analysis. With only 7 reviewers, the standard error on average scores is substantial. Many of the papers in Table 1 are separated by less than 0.3 points—well within the noise band of a 7-reviewer panel. The tier classifications may not be robust to small perturbations.

## Score

**Score**: 3/4 — Accept

## Major Issues (Blocking)

### M1: No Uncertainty Quantification on Rankings
The rankings in Table 1 present average scores without confidence intervals. With 7 reviewers and score variances mentioned in Section 4.3 (σ = 0.50-1.03), many adjacent papers are within one standard error of each other. The paper needs bootstrap confidence intervals on rankings and a clear indication of which rank differences are statistically significant. Without this, the tier classifications (e.g., B+ vs. B) may be artifacts of noise.

### M2: Single Portfolio Validation
The methodology is validated on a single research program (2 modules, 13 papers). The reviewer bloc structure, the cross-cutting themes, and the tier classification results could be idiosyncratic to this portfolio. The paper needs to discuss generalizability more rigorously—at minimum, a synthetic experiment varying portfolio characteristics to understand when the methodology breaks down.

## Minor Issues

### m1: Consensus Metric Definition
The paper uses standard deviation as the consensus metric but doesn't relate it to established agreement measures. How does σ < 0.5 (strong consensus) compare to Krippendorff's alpha or Fleiss' kappa for the same data?

### m2: Distribution of Scores Not Shown
The paper presents average scores but not the full distribution. A box plot or violin plot showing per-reviewer scores for each paper would be more informative than a single average.

### m3: Theme Identification Method
How are cross-cutting themes identified? The paper presents 6 themes but doesn't describe the process for theme extraction. Is this a qualitative coding process, or are themes identified by counting reviewer mentions?

## Strengths

1. **Clear statistical analysis**: The Spearman correlation analysis of reviewer blocs is well-executed and reveals interesting structure in the disagreement patterns.
2. **Strong cross-cutting themes**: Themes 1 and 2 (convergent architecture, mutual validation) are convincing examples of portfolio-level insight.
3. **Well-structured methodology**: The 5-step protocol is clear, and the tier classification system is reasonable even if the specific thresholds need sensitivity analysis.

## Questions for Authors

1. If you bootstrap the reviewer panel (sample 7 reviewers with replacement from a larger pool), how stable are the rankings?
2. What is the minimum portfolio size (number of papers) for the methodology to produce meaningful results?
3. Have you analyzed whether the score distributions are normal, or are there systematic skewness patterns that would favor median over mean aggregation?

## Recommendations

- Add bootstrap confidence intervals to all rankings and tier classifications
- Include the full score distributions (box plots or violin plots), not just averages
- Conduct sensitivity analysis on tier thresholds and panel composition
- Discuss minimum portfolio size requirements for meaningful results

---

**Verdict**: Accept with Minor Revisions

**Confidence**: High — Evaluation methodology and robustness analysis are core to my research. The statistical concerns I raise are well-grounded, and the recommendations are concrete and actionable.
