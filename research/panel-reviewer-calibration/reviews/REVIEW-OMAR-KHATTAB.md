# Review: Calibrating AI Reviewer Personas: Domain Expertise Simulation Without Fine-Tuning

**Reviewer**: Omar Khattab (Stanford / Databricks)
**Expertise**: DSPy, prompt optimization, retrieval-augmented systems
**Round**: 1
**Date**: 2026-02-05

---

## Overall Assessment

This paper studies a timely question: can LLM personas be calibrated to produce diverse, expertise-specific reviews through structured prompting alone? The answer — largely yes, with key-question injection as the primary mechanism — is useful and well-supported by the correlation and clustering analysis.

From a prompt optimization perspective, the paper's approach is sensible but leaves considerable potential on the table. The persona prompts are hand-crafted templates, which works but raises an obvious question: can these prompts be optimized automatically? The paper's own data (186+ reviews with known quality indicators) provides a natural training signal for prompt optimization. Not exploring this feels like a missed opportunity given the paper's claims about practical frameworks.

The empirical analysis is solid for a first study. The bloc formation result and the key-question effect are the paper's strongest contributions. I would accept this paper with revisions that address the optimization angle and strengthen the experimental controls.

## Score

**Score**: 3/4 — Accept

## Major Issues (Blocking)

### M1: No Exploration of Automatic Prompt Optimization
The paper constructs persona prompts manually from profile fields. But if the goal is calibrated personas, why not optimize the prompts? With 186+ reviews and three calibration quality indicators (score discrimination, issue specificity, expertise alignment), there is a natural objective function. Even a simple experiment — using the quality indicators to tune the weighting of profile fields in the prompt — would significantly strengthen the paper and connect it to the prompt optimization literature.

## Minor Issues

### m1: Profile Field Contribution Not Isolated
The ablation in Section 4.3 only compares "with key question" vs. "without key question." A more informative ablation would measure the marginal contribution of each profile field: name → +affiliation → +expertise → +key question → +venue. This progressive ablation would reveal the information content of each field.

### m2: Reproducibility Concerns — Prompt Not Shown
The five-component prompt structure is described at a high level, but the actual prompt text is not provided. For a paper about prompting methodology, the exact prompts are essential for reproduction.

### m3: No Discussion of Prompt Sensitivity
How sensitive are the results to minor prompt variations? If the key question is rephrased slightly (e.g., "What evaluation methodology was used?" vs. "How was this evaluated?"), does the persona's behavior change? Robustness analysis would strengthen confidence in the method.

### m4: Database Size Justification
Why 45+ reviewers across 10 categories? Is there a saturation analysis — at what point do additional personas stop adding diversity to a panel?

## Strengths

1. The key-question effect (34% variance increase) is a clean, quantifiable finding with immediate practical value
2. Bloc formation analysis is methodologically sound and produces an interesting result
3. The paper is well-scoped — it asks a specific question and answers it with appropriate evidence

## Questions for Authors

1. Can the three calibration quality indicators be used as an optimization objective for automatic prompt tuning (e.g., with DSPy or similar)?
2. What is the minimum profile information needed for a well-calibrated persona? Could you achieve 80% of the distinctness with just name + key question?
3. Have you measured the marginal value of the 5th reviewer — does distinctness improve linearly with panel size, or is there diminishing returns?

## Recommendations

- Add even a preliminary experiment on automatic prompt optimization using the calibration indicators as the objective
- Include the full prompt template in an appendix
- Run a progressive ablation: name → name+affiliation → ... → full profile
- Add a panel size analysis (how does distinctness scale with N reviewers?)

---

**Verdict**: Accept with Minor Revisions

**Confidence**: High — Prompt construction and optimization are my direct research area, and the connection to DSPy-style optimization is clear.
