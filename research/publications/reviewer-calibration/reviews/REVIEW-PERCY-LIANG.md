# Review: Calibrating AI Reviewer Personas: Domain Expertise Simulation Without Fine-Tuning

**Reviewer**: Percy Liang (Stanford / HELM)
**Expertise**: Benchmarks, evaluation, foundation models
**Round**: 1
**Date**: 2026-02-05

---

## Overall Assessment

This paper addresses a genuinely important question: whether LLM-generated reviewer personas produce distinct feedback or merely replicate generic model tendencies. The framing is crisp, and the research question is well-scoped. The empirical approach — analyzing 186+ reviews across 14 papers from 45+ personas — provides a reasonable corpus for drawing conclusions.

The core contribution — demonstrating that profile-based prompting (especially key-question injection) produces measurably distinct reviewer behavior — is interesting and practically useful. The bloc formation analysis and the pairwise rank correlation framework are the paper's strongest analytical elements.

However, I have significant concerns about the evaluation methodology. For a paper that is fundamentally *about* calibration and measurement, the evaluation framework itself needs to meet a high bar. Several aspects of the experimental design and statistical analysis fall short of what I would expect at EMNLP.

## Score

**Score**: 2/4 — Weak Accept

## Major Issues (Blocking)

### M1: No Ground Truth for Calibration Claims
The paper claims personas are "calibrated" but calibrated *to what*? There is no comparison against actual human expert reviews. Without ground truth from real reviewers, we cannot distinguish between "personas that produce distinct outputs" and "personas that produce distinct but unrealistic outputs." The distinction between genuinely calibrated personas and merely different random outputs is never established.

### M2: Limited Statistical Rigor in Bloc Analysis
The hierarchical clustering that identifies three blocs is reported without critical methodological details: What distance metric was used? What linkage criterion? How was the number of clusters determined (silhouette score, elbow method, or chosen a priori)? The $\rho$ values are reported without confidence intervals or significance tests. With only 14 papers, statistical power for pairwise correlations is limited.

### M3: Evaluation Corpus is Self-Generated
All 14 papers being reviewed appear to be from the same project/author. This raises serious concerns about corpus diversity. Calibration claims should hold across papers from different authors, domains, and quality levels. The current evaluation cannot distinguish persona effects from paper-specific effects.

## Minor Issues

### m1: Ablation Study is Incomplete
The key-question ablation (Section 4.3) compares "with" vs. "without" key questions. A fuller ablation would separately measure the contribution of each profile field: name, affiliation, expertise tags, venue alignment, and key question. This would strengthen the claim that key questions are the "single most effective" mechanism.

### m2: Jensen-Shannon Divergence Needs Baselines
The JS divergence values (0.08 within-bloc, 0.42 between-bloc) lack context. What is the expected JS divergence between two random reviewers? Between two identical prompts with different random seeds? Without baselines, the absolute values are uninterpretable.

### m3: Limited Discussion of Model Dependence
The authors acknowledge model dependence as a limitation but do not test even one alternative model. A single comparison point would substantially strengthen the claims.

## Strengths

1. Well-defined research question that addresses a real gap in the AI-simulated review literature
2. Comprehensive persona database (45+ reviewers, 10 categories) is a useful artifact
3. The key-question effect is a novel and actionable finding — practical guidelines are clear

## Questions for Authors

1. Have you considered validating persona outputs against real reviews by these researchers (e.g., from OpenReview)?
2. What happens to bloc structure when the same paper is reviewed multiple times with identical prompts? Is the clustering stable across runs?
3. The 89% calibration quality indicator — what characterizes the 11% that fail? Are they from specific categories?

## Recommendations

- Add a comparison against real human reviews (even a small-scale study with 2-3 papers) to establish ground truth
- Report confidence intervals for all correlation values and perform significance testing
- Include a random baseline for the JS divergence metric
- Expand the evaluation corpus to include papers from different authors/domains

---

**Verdict**: Major Revisions Required

**Confidence**: High — Evaluation methodology is my core expertise, and the gaps identified are fundamental to the paper's claims.
