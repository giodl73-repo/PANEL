# Review: Multi-Round Revision Dynamics

**Reviewer**: Ludwig Schmidt (University of Washington)
**Expertise**: Distribution shift, robustness, evaluation methodology
**Round**: 1
**Date**: 2026-02-05

---

## Overall Assessment

This paper presents an empirical study of how paper quality changes across multiple rounds of AI-simulated review. The dataset is small but the analysis is structured: 14 papers, 186+ reviews, tracked across 2–4 rounds with a P1/P2/P3 priority triage system. The findings—32% average improvement, P1 items driving 72% of gains, logarithmic diminishing returns—are plausible and potentially useful for structuring review processes.

My main concern is methodological rigor. The paper makes quantitative claims (specific percentages, point improvements, convergence rates) from a small, non-i.i.d. dataset. The papers are all by one author, they share the same AI review system, and the modules (Merit, Waves, Basecamp) likely have correlated quality characteristics. Standard statistical analysis assuming independent observations would overstate confidence significantly. The paper needs either (a) much more careful statistical treatment, or (b) explicit reframing as a descriptive case study.

Additionally, the claim about logarithmic improvement is stated but never formally tested. For a D&B paper at NeurIPS, this kind of quantitative claim needs rigorous backing.

## Score

**Score**: 2/4 — Weak Accept

## Major Issues (Blocking)

### M1: Non-i.i.d. Data Treated as Independent Observations
The 14 papers are from a single author, grouped in 3 modules, reviewed by overlapping AI reviewer pools. These are not independent observations. The paper reports aggregate statistics (means, percentages) as if they were, which inflates apparent precision. Needed: (a) hierarchical/mixed-effects modeling, (b) bootstrap confidence intervals that account for clustering, or (c) explicit framing as a descriptive case study with appropriate caveats.

### M2: Logarithmic Model Asserted but Not Tested
Section 4.3 claims "score improvement follows a logarithmic curve" but provides only three data points (round 1→2, 2→3, 3→4) with no curve fitting, no goodness-of-fit test, no comparison to alternative models. For a D&B paper, this empirical claim needs: (a) formal model fitting, (b) R² or equivalent, (c) comparison against linear, exponential, and power law alternatives, (d) per-paper trajectories, not just aggregates.

### M3: Distribution Shift Between AI and Human Review
The paper implicitly assumes that dynamics observed under AI review transfer to human review settings. This is a distribution shift problem. AI reviewers may systematically differ from humans in: (a) what they identify as blocking issues, (b) how they respond to revisions, (c) consistency across rounds. Without characterizing this shift, the practical recommendations (e.g., "budget two rounds") may not hold for real venue review.

## Minor Issues

### m1: Per-Paper Trajectories Not Shown
Aggregate statistics hide important variance. Show per-paper score trajectories (e.g., a line plot with 14 lines). This would reveal whether the "85% within 2 rounds" finding reflects a tight cluster or a bimodal distribution.

### m2: Module-Level Confounds
Merit (9 papers), Waves (4), Basecamp (1) differ in paper count, reviewer count, and round count. The per-module comparison in Section 4.2 is confounded by these differences. At minimum, discuss why the modules differ and whether this affects aggregate conclusions.

### m3: Verdict Mapping Inconsistencies
Section 3.3 mentions both 4-point and 10-point scales. The mapping between them is unclear. Provide the explicit formula.

## Strengths

1. Well-structured dataset with consistent review protocol across all papers
2. P1/P2/P3 impact decomposition is a clean contribution with clear empirical results
3. Honest limitations section that identifies the right concerns

## Questions for Authors

1. What is the inter-paper correlation in score trajectories? Do papers from the same module improve similarly?
2. Can you run a permutation test to assess whether the 72% P1 impact figure is statistically distinguishable from chance (e.g., random assignment of items to P1/P2/P3)?
3. What happens if you remove Basecamp (the only 4-round paper) from the diminishing returns analysis?

## Recommendations

- Implement mixed-effects modeling or bootstrap confidence intervals accounting for data structure
- Formally fit and test the logarithmic improvement model with proper model comparison
- Show per-paper trajectories to reveal variance structure
- Add explicit formula for 4-point to 10-point score mapping

---

**Verdict**: Major Revisions Required

**Confidence**: High — Statistical methodology and evaluation rigor are central to my research.
