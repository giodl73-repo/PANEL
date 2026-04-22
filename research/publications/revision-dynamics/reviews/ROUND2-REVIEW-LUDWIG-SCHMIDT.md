# Review: Multi-Round Revision Dynamics (Round 2)

**Reviewer**: Ludwig Schmidt (University of Washington)
**Expertise**: Distribution shift, robustness, evaluation methodology
**Round**: 2
**Date**: 2026-02-05

---

## Overall Assessment

The revision addresses my methodological concerns well. The statistical methodology section (3.4) correctly identifies paper-level bootstrap as the appropriate resampling unit. Confidence intervals now accompany all key claims—the 72% P1 impact figure has a CI of [61%, 82%], which is informative: even at the lower bound, P1 items account for the majority of gains. The "descriptive pilot study" framing with explicit "no population inference" is exactly right.

The formal model comparison (Section 4.4) is handled honestly. The authors correctly note that all four models fit well with 3 data points and that the differences are not statistically meaningful. Reframing the finding as "diminishing returns" rather than asserting a logarithmic functional form is appropriate. The per-paper trajectories section (4.2) adds needed variance information.

The AI vs. human review comparison (Section 6.2) provides a structured framework for thinking about transfer. The "properties likely to transfer" vs. "properties unlikely to transfer" distinction is useful. The specific variance comparison ($\sigma \approx 0.3$--$0.5$ for AI vs. $\sigma \approx 0.8$--$1.2$ for humans) quantifies a key difference.

The paper is now a well-calibrated empirical study that doesn't overreach its claims.

## Score

**Score**: 3/4 — Accept

## Major Issues (Blocking)

None.

## Minor Issues

### m1: Module-Level Analysis Still Underdeveloped
Section 4.3 reports per-module means and SDs but doesn't test whether module is a significant factor. A simple one-way ANOVA or Kruskal-Wallis test on improvement scores by module would indicate whether the module-level differences are meaningful or within noise. Given that modules differ in paper count, reviewer count, and domain, this is relevant for interpreting aggregate results.

### m2: Bootstrap CI Computation Details
The paper states "10,000 resamples at the paper level" but doesn't specify the bootstrap method (percentile, BCa, etc.). For small $n$, the choice can matter. BCa (bias-corrected and accelerated) is recommended for $n < 30$.

## Strengths

1. Statistical methodology is now appropriate for the data structure—paper-level bootstrap CIs, effect sizes, explicit caveats about small $n$
2. Model comparison is honest about limitations—the caveat about 3 data points is exemplary
3. Per-paper trajectories reveal the bimodal structure (high-start vs. low-start papers), which is more informative than the aggregate mean
4. The systematic AI vs. human comparison provides a useful transfer framework

## Questions for Authors

1. Have you computed the intra-class correlation coefficient (ICC) for papers within modules? This would quantify the clustering effect.

## Recommendations

- Test for module effect using Kruskal-Wallis (non-parametric, appropriate for small and unequal groups)
- Specify bootstrap method (recommend BCa for small $n$)

---

**Verdict**: Accept with Minor Revisions

**Confidence**: High — The statistical methodology is now at an appropriate level for this dataset.
