# Review Synthesis — Calibrating AI Reviewer Personas: Domain Expertise Simulation Without Fine-Tuning

**Paper**: panel-reviewer-calibration
**Round**: 1
**Date**: 2026-02-05
**Reviewers**: 5

---

## Overview

| Metric | Value |
|--------|-------|
| Average Score | 2.4/4 |
| Score Range | 2-3/4 |
| Consensus | Moderate (σ = 0.49) |
| Overall Verdict | Major Revisions Required |

## Score Distribution

| Reviewer | Affiliation | Score | Verdict |
|----------|-------------|-------|---------|
| Percy Liang | Stanford / HELM | 2/4 | Major Revisions Required |
| Jason Wei | OpenAI | 3/4 | Accept with Minor Revisions |
| Michael Bernstein | Stanford | 2/4 | Major Revisions Required |
| Danqi Chen | Princeton | 2/4 | Major Revisions Required |
| Omar Khattab | Stanford / Databricks | 3/4 | Accept with Minor Revisions |

---

## Priority 1: Blocking Issues

Issues that must be addressed before resubmission. Raised by 3+ reviewers or flagged as major by any reviewer.

### P1.1: No Ground Truth or Validation Against Human Reviews
**Raised by**: Percy Liang (M1), Michael Bernstein (M3), Danqi Chen (M1)
**Description**: The paper claims personas are "calibrated" but provides no comparison against actual human expert reviews. Without ground truth, "distinct" and "calibrated" are conflated — distinct outputs may not be realistic outputs. The evaluation corpus is also self-generated (all 14 papers from the same project/author), making it impossible to separate persona effects from paper-specific effects.
**Impact**: This is the central validity threat. Without external validation, the paper's calibration claims are undermined. Reviewers noted that EMNLP/ACL public reviews on OpenReview offer a natural comparison dataset.
**Recommended action**: (1) Compare AI panel score distributions and agreement patterns against published human review statistics at NLP venues. (2) If possible, obtain real reviews for a subset of papers and compare. (3) At minimum, evaluate on papers from different authors/domains to demonstrate generalizability.

### P1.2: Insufficient Statistical Methodology
**Raised by**: Percy Liang (M2), Michael Bernstein (M1), Danqi Chen (implied)
**Description**: The statistical analysis lacks rigor expected at a top NLP venue. Specific gaps: (a) hierarchical clustering reported without distance metric, linkage criterion, or cluster count justification; (b) correlations reported without confidence intervals or significance tests; (c) no established inter-rater reliability metrics (Krippendorff's alpha, Cohen's kappa, ICC) used despite these being standard in the evaluation literature; (d) JS divergence values lack random baselines.
**Impact**: The quantitative claims are the paper's core contribution. Without proper statistical treatment, the numbers are uninterpretable.
**Recommended action**: (1) Add Krippendorff's alpha or ICC alongside Spearman's rho. (2) Report confidence intervals for all correlations. (3) Provide random baselines for JS divergence. (4) Document clustering methodology fully.

### P1.3: Limited Technical Novelty — No Comparison with Alternative Approaches
**Raised by**: Jason Wei (M2), Danqi Chen (M1), Omar Khattab (M1)
**Description**: The method is structured prompt construction from profiles — essentially prompt engineering with templates. No alternative approaches are compared (chain-of-thought persona reasoning, few-shot calibration from real reviews, retrieval-augmented persona construction, automatic prompt optimization). The paper's own data provides a natural signal for optimization but this is unexplored.
**Impact**: Without baselines or alternatives, the contribution appears incremental. For EMNLP, either a more sophisticated method or a significantly deeper analysis is expected.
**Recommended action**: (1) Compare at least one alternative (retrieval-augmented persona construction or automatic prompt optimization using calibration quality indicators as the objective). (2) Or deepen the empirical analysis substantially — formalize the calibration framework, add progressive ablations, and run ambiguity analysis.

### P1.4: Missing Error Analysis of Calibration Failures
**Raised by**: Jason Wei (M1), Omar Khattab (implied)
**Description**: 89% of personas meet all three calibration quality indicators, but the paper says nothing about the 11% that fail. Which personas fail? On which papers? Is failure correlated with expertise category, profile specificity, or paper topic?
**Impact**: Understanding failure modes is essential for practitioners and for establishing the method's boundaries.
**Recommended action**: Provide a systematic breakdown of the 11% failure cases by category, paper, and which indicator(s) failed.

---

## Priority 2: Important Improvements

Issues that would significantly strengthen the paper. Raised by 2+ reviewers.

### P2.1: Incomplete Ablation Study — Progressive Profile Field Analysis
**Raised by**: Percy Liang (m1), Omar Khattab (m1)
**Description**: The ablation only compares "with key question" vs. "without." A progressive ablation (name → +affiliation → +expertise → +key question → +venue) would reveal the marginal contribution of each profile field and strengthen the claim about key questions being the dominant mechanism.
**Recommended action**: Run progressive ablation measuring distinctness at each additive step.

### P2.2: Distinctness vs. Quality Not Separated
**Raised by**: Michael Bernstein (M2), Danqi Chen (M2)
**Description**: Distinctness is treated as inherently good. But distinct reviews must also be *valid* and *useful*. A reviewer focusing on formatting is "distinct" but unhelpful. The paper needs a quality dimension alongside distinctness — do distinct reviewers produce actionable, paper-improving feedback?
**Recommended action**: Add a review quality assessment (e.g., rate whether major issues are valid and actionable) and show that distinct reviews are also high-quality reviews.

### P2.3: Reproducibility — Full Prompt Template Missing
**Raised by**: Jason Wei (m3), Omar Khattab (m2)
**Description**: The five-component prompt is described at a high level but the exact template is not shown. For a paper about prompting methodology, full reproducibility requires the verbatim prompt.
**Recommended action**: Include the complete prompt template as an appendix.

---

## Priority 3: Minor Suggestions

Suggestions from individual reviewers. Address if time permits.

### P3.1: Temperature and Sampling Parameters Not Reported
**Raised by**: Jason Wei (m1)
**Suggestion**: Report all generation hyperparameters (temperature, top-p, max tokens). Persona distinctness could be partially attributable to sampling rather than persona construction.

### P3.2: Venue Alignment Analysis Underdeveloped
**Raised by**: Danqi Chen (m2)
**Suggestion**: Systematically analyze whether venue-matched reviewers produce more appropriate feedback than venue-mismatched reviewers.

### P3.3: Panel Composition Rules Lack Justification
**Raised by**: Michael Bernstein (m1)
**Suggestion**: Justify the diversity thresholds (5 reviewers, 2 categories, etc.) — were alternatives tested?

### P3.4: Key Question Specificity Scale
**Raised by**: Jason Wei (m2)
**Suggestion**: Quantify key-question specificity on a scale (generic → domain-specific → paper-specific) with corresponding distinctness metrics.

### P3.5: Panel Size Saturation Analysis
**Raised by**: Omar Khattab (m4)
**Suggestion**: At what point do additional personas stop adding diversity? Diminishing returns analysis for panel size.

### P3.6: Prompt Robustness / Sensitivity
**Raised by**: Omar Khattab (m3)
**Suggestion**: Test whether minor prompt rephrasing changes persona behavior — robustness analysis.

### P3.7: Missing Related Work References
**Raised by**: Danqi Chen (m1)
**Suggestion**: Add citations for ChatEval, PandaLM, and role-playing evaluation in NLP benchmarks.

### P3.8: Category Coverage Unevenness
**Raised by**: Danqi Chen (m3)
**Suggestion**: Verify calibration findings are stable across all 10 categories, not just the 3 analyzed in depth.

---

## Areas of Strength

Aspects that reviewers agreed were done well:

1. **Clear, well-scoped research question** — cited by 5/5 reviewers
2. **Key-question effect is a strong, novel finding** (34% variance increase) — cited by 4/5 reviewers
3. **Practical and immediately useful** — cited by 4/5 reviewers
4. **Bloc formation analysis is methodologically interesting** — cited by 3/5 reviewers
5. **Honest limitations discussion** — cited by 2/5 reviewers

## Areas of Disagreement

Points where reviewers diverged:

1. **Technical novelty** — Wei (3/4) and Khattab (3/4) see sufficient contribution in the empirical findings; Liang (2/4), Bernstein (2/4), and Chen (2/4) want either deeper analysis or a more sophisticated method
2. **Venue fit** — Chen questions whether this fits EMNLP as-is (reads as engineering report); others consider it appropriate for NLP evaluation
3. **Severity of ground truth gap** — Liang and Bernstein consider it blocking; Wei and Khattab see it as desirable but not blocking

---

## Recommended Next Steps

1. **Add external validation** — Compare AI panel patterns to real EMNLP review statistics (addresses P1.1)
2. **Strengthen statistical methodology** — Add IRR metrics, confidence intervals, baselines (addresses P1.2)
3. **Add one alternative approach** — Retrieval-augmented personas or auto-prompt optimization (addresses P1.3)
4. **Error analysis** — Systematic breakdown of calibration failures (addresses P1.4)
5. **Progressive ablation** — Measure marginal contribution of each profile field (addresses P2.1)
6. **Quality assessment** — Rate whether distinct reviews are also useful/actionable (addresses P2.2)
7. **Reproducibility appendix** — Full prompt template + generation hyperparameters (addresses P2.3, P3.1)

---

*Generated by panel synthesis engine — see shared/synthesis-engine.md*
