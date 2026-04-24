# Review: Calibrating AI Reviewer Personas: Domain Expertise Simulation Without Fine-Tuning

**Reviewer**: Michael Bernstein (Stanford)
**Expertise**: Crowdsourcing, human computation, social computing
**Round**: 1
**Date**: 2026-02-05

---

## Overall Assessment

This paper presents a profile-based method for constructing AI reviewer personas and evaluates whether those personas produce distinct feedback. From a human computation perspective, the paper is tackling a well-known challenge: how do you ensure that multiple assessors provide independent, diverse evaluations rather than converging on the same judgment? This is the AI-simulation analog of the "wisdom of crowds" question.

The core idea — constructing personas from structured profiles with key questions — is straightforward and practical. The analysis of bloc formation and pairwise correlations provides evidence for genuine diversity. I appreciate that the paper is honest about the limitations of persona-as-approximation.

However, the paper misses a major opportunity by not engaging with the rich literature on crowd quality and inter-rater reliability. The evaluation also treats "distinctness" as inherently good, without addressing the critical question of whether distinct feedback is *useful* feedback.

## Score

**Score**: 2/4 — Weak Accept

## Major Issues (Blocking)

### M1: No Connection to Inter-Rater Reliability Literature
The crowdsourcing and psychometrics communities have decades of work on inter-rater reliability (Krippendorff's alpha, Cohen's kappa, ICC). The paper uses only Spearman's rho for pairwise correlations. This is a significant gap — established IRR metrics would allow direct comparison with human reviewer panels and would place the results in context. Are AI persona panels more or less consistent than typical human reviewer panels at EMNLP?

### M2: Distinctness vs. Quality Conflation
The paper treats reviewer distinctness as the primary goal, but distinctness is only valuable if the distinct perspectives are also *valid*. A reviewer who consistently focuses on formatting issues is "distinct" from one who focuses on methodology, but the former provides less value. The paper needs a quality dimension alongside the distinctness dimension — do distinct reviewers produce actionable, paper-improving feedback?

### M3: No User Study or Downstream Evaluation
How do authors actually use these reviews? Does multi-perspective feedback lead to better revisions than single-perspective feedback? A user study (even with a small N) would transform this from a measurement paper to a contribution with demonstrated impact. At CHI/CSCW, this would be expected. For EMNLP, a downstream evaluation showing that better-calibrated panels produce more useful synthesis is the minimum bar.

## Minor Issues

### m1: Panel Composition Rules Are Ad Hoc
The diversity constraints (Section 3.3) — at least 1 industry, at least 2 categories, max 2 per institution — are stated without justification. Why these thresholds? Were alternatives tested?

### m2: Bloc Labels May Be Overfitting
Three blocs from 45+ reviewers across 14 papers — the sample may be too small for robust clustering. Have you tested with leave-one-paper-out cross-validation?

### m3: Missing Comparison to Real Review Panels
EMNLP/ACL have public reviews on OpenReview. A comparison of score distributions, issue topic distributions, and agreement patterns between AI panels and real panels would dramatically strengthen the paper.

## Strengths

1. Addresses a genuine gap — most multi-agent papers assume personas work without measuring it
2. The key-question finding is practical and immediately actionable
3. Honest limitations section that acknowledges ethical concerns about using real identities

## Questions for Authors

1. How does the pairwise agreement in your AI panels compare to typical inter-reviewer agreement at EMNLP (which is historically low)?
2. Have you considered a Mechanical Turk or expert study where humans rate the quality/usefulness of AI-generated reviews?
3. What is the cost (tokens, time) of running a full 5-reviewer panel vs. a single review?

## Recommendations

- Add Krippendorff's alpha or ICC analysis alongside Spearman's rho
- Include a "review quality" dimension — rate whether major issues are valid and actionable
- Compare AI panel agreement patterns to published statistics on human reviewer agreement at NLP venues
- Consider a small user study where paper authors rate review usefulness

---

**Verdict**: Major Revisions Required

**Confidence**: High — Crowd quality assessment and inter-rater reliability are core to my research on human computation systems.
