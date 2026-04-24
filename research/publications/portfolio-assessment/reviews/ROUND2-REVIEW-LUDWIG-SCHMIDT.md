# Review: Cross-Portfolio Expert Panels

**Reviewer**: Ludwig Schmidt (UW)
**Expertise**: Distribution shift, robustness, evaluation methodology
**Round**: 2
**Date**: 2026-02-05

---

## Overall Assessment

The revised paper addresses my Round 1 concerns about statistical rigor comprehensively. The uncertainty quantification section (4.2) is the strongest addition: bootstrap CIs, tier boundary sensitivity, and test-retest reliability provide the statistical backbone that was missing. The key finding---that A-vs-B tier distinctions are robust but adjacent rankings within tiers are within noise---is exactly the kind of honest reporting that builds trust in the methodology.

The Krippendorff's $\alpha = 0.41$ contextualization is useful. Relating the $\sigma$-based metric to established agreement measures connects this work to the broader evaluation literature. The within-bloc $\alpha$ values (0.62--0.71) provide additional evidence that the bloc structure reflects genuine disciplinary clustering rather than random variation.

The calibration section's four-step protocol is well-designed from a methodology perspective. Step 2 (disagreement pattern matching) is particularly interesting---if real experts form blocs with similar correlation structure, that would be strong evidence for the validity of the simulation. Step 4 (decision-relevant calibration) is practical: even if the simulation doesn't perfectly replicate human judgment, it may still lead to the same actionable decisions.

The baseline comparison rounds out the paper. I'm satisfied that the value proposition is clearly established.

## Score

**Score**: 3/4 — Accept

## Major Issues (Blocking)

None. The statistical rigor concerns from Round 1 have been thoroughly addressed.

## Minor Issues

### m1: ICC Reporting Convention
The ICC(2,7) = 0.87 is reported without a confidence interval. For a reliability metric, the CI is important---especially since it's based on only two runs.

### m2: Effect Size for Rank Shifts
The baseline comparison notes three papers that shift 2+ positions. Reporting the effect size (e.g., Kendall's tau distance) would quantify how different the panel rankings are from the aggregated baseline.

## Strengths

1. Bootstrap CIs and sensitivity analysis provide proper uncertainty quantification
2. Test-retest reliability demonstrates reproducibility
3. Krippendorff's $\alpha$ connects to established agreement metrics
4. Calibration protocol is methodologically sound and actionable
5. Tier stability classification ("stable" vs. "borderline") is a practical contribution

## Questions for Authors

1. With only 7 reviewers, the bootstrap CIs are necessarily wide. Have you considered approaches beyond bootstrap for small-n uncertainty quantification (e.g., Bayesian credible intervals)?
2. The ICC is based on two runs. What would a more rigorous test-retest study look like?

## Recommendations

- Report CI on the ICC estimate
- Add Kendall's tau for the baseline comparison to quantify ranking divergence

---

**Verdict**: Accept with Minor Revisions

**Confidence**: High — Evaluation methodology and robustness analysis are my primary research areas.
