# Review: Calibrating AI Reviewer Personas (Round 2)

**Reviewer**: Danqi Chen (Princeton University)
**Expertise**: Dense retrieval, question answering, NLP evaluation methodology
**Round**: 2
**Date**: 2026-02-05

---

## Overall Assessment

The revision significantly strengthens the paper. My primary concerns from Round 1 — insufficient statistical methodology and limited technical novelty — have both been addressed.

The inter-rater reliability analysis using standard metrics (Krippendorff's alpha, ICC) with bootstrap confidence intervals now meets the NLP evaluation literature standard. The finding that AI panels achieve alpha = 0.41, at the upper end of human reviewer agreement (0.20-0.40), is noteworthy and well-contextualized.

The four-method comparison provides the technical depth I was looking for. The progressive ablation from no persona ($|\rho| = 0.85$) to full profile ($|\rho| = 0.42$) to retrieval-augmented ($|\rho| = 0.39$) clearly quantifies what each component contributes. The finding that retrieval augmentation adds only marginal benefit over structured profiles is practically important — it suggests that most of the calibration signal is in the structured profile, not in the reviewer's actual publications.

The addition of ChatEval, PandaLM, and the peer review reliability literature improves the related work section. The paper now reads as an evaluation contribution rather than an engineering report, which addresses my venue fit concern.

## Score

**Score**: 3/4 — Accept

## Minor Issues

### m1: Cross-Domain Generalization
All 14 papers are in AI/ML. Would the calibration findings hold for other domains (biomedical, social sciences)? A brief discussion of expected generalizability would be useful.

### m2: Category Coverage
The failure analysis shows problems in Security and Compilers categories. Are the calibration findings reported in Section 5 driven primarily by the well-represented categories (ML, Agents, HCI)?

## Strengths

1. **IRR metrics with bootstrap CIs**: Clean, interpretable, comparable to human review literature.
2. **Four-method comparison**: Strong technical contribution showing diminishing returns of retrieval augmentation.
3. **Progressive ablation**: Key-question as dominant mechanism is well-quantified.
4. **Improved related work**: ChatEval, PandaLM, and peer review reliability literature properly contextualize the work.

---

**Verdict**: Accept with Minor Revisions

**Confidence**: High — The statistical methodology and evaluation rigor now meet the standards I expect for NLP evaluation papers.
