# Review: Cross-Portfolio Expert Panels: Holistic Assessment of Multi-Paper Research Programs

**Reviewer**: Percy Liang (Stanford)
**Expertise**: Evaluation, benchmarks, foundation models
**Round**: 1
**Date**: 2026-02-05

---

## Overall Assessment

This paper proposes cross-portfolio expert panels as a methodology for assessing multi-paper research programs holistically rather than paper-by-paper. The core insight—that portfolio-level review surfaces qualitatively different information than aggregated individual reviews—is compelling and well-motivated. The identification of 6 cross-cutting themes across 13 papers, particularly the convergent architecture and mutual validation themes, demonstrates concrete value that individual reviews cannot provide.

However, as someone who has spent considerable effort building rigorous evaluation frameworks (HELM), I find the evaluation methodology here insufficiently rigorous. The paper claims structured disagreement between reviewer blocs is "a feature, not a bug," but provides no baseline or calibration to distinguish meaningful disciplinary differences from noise. With AI-simulated reviewers, this distinction is critical. The Spearman correlation analysis is a good start but needs grounding in what we'd expect from real expert panels.

The tier classification system (A through B-) is reasonable but the score ranges feel arbitrary. Why is 7.0 the boundary between A- and B+? The paper would benefit from sensitivity analysis showing how rankings change with different threshold choices.

## Score

**Score**: 3/4 — Accept

## Major Issues (Blocking)

### M1: No Calibration Against Real Expert Panels
The paper presents AI-simulated panel results without any comparison to human expert panels. Even a small-scale study with 2-3 real experts reviewing the same portfolio would provide essential calibration. Without this, we cannot assess whether the structured disagreement patterns reflect genuine disciplinary perspectives or LLM prompt engineering artifacts. The limitations section acknowledges this but it remains a fundamental gap.

### M2: Insufficient Evaluation of the Methodology Itself
The paper evaluates a portfolio of papers but does not rigorously evaluate the panel methodology. Key missing elements: (a) inter-rater reliability metrics beyond Spearman correlations, (b) test-retest reliability (do panels produce consistent results across runs?), (c) comparison against simpler baselines (e.g., averaging individual paper review scores).

## Minor Issues

### m1: Arbitrary Tier Thresholds
The tier boundaries (8.0, 7.0, 6.5, 6.0) lack justification. A sensitivity analysis showing ranking stability under threshold perturbation would strengthen the contribution.

### m2: Limited Related Work on Research Assessment
The related work section covers only three areas briefly. It should engage with the research evaluation literature more deeply—Grant panel processes (NIH study sections), the UK REF methodology in detail, and the scientometrics literature on research group evaluation.

### m3: Inconsistent Paper Count
The introduction mentions "13 papers total" and later "14 papers, 2 modules." This inconsistency should be resolved.

## Strengths

1. **Novel contribution**: Portfolio-level review is genuinely underexplored, and the methodology is well-structured with clear protocol steps.
2. **Cross-cutting theme identification**: The 6 themes, especially convergent architecture and mutual validation, demonstrate concrete value that justifies the methodology.
3. **Structured disagreement analysis**: The reviewer bloc analysis with Spearman correlations is an interesting contribution that provides richer information than simple score aggregation.

## Questions for Authors

1. Have you conducted any test-retest reliability studies? If you run the same panel protocol twice, how stable are the rankings and theme identifications?
2. How sensitive are the tier classifications to the choice of thresholds? What happens if you shift all boundaries by 0.5 points?
3. Could the structured disagreement patterns be an artifact of how reviewer personas are constructed rather than genuine disciplinary differences?

## Recommendations

- Conduct a small-scale human calibration study, even with 2-3 experts, to ground the AI-simulated results
- Add inter-rater reliability metrics (Krippendorff's alpha, Cohen's kappa) alongside Spearman correlations
- Include sensitivity analysis for tier threshold choices
- Expand the related work to engage with grant panel and research evaluation literatures

---

**Verdict**: Accept with Minor Revisions

**Confidence**: High — This is squarely within my expertise in evaluation methodology and benchmarking. The contribution is real but needs stronger evaluation of its own methodology.
