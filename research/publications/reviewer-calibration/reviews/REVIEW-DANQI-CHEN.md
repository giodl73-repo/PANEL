# Review: Calibrating AI Reviewer Personas: Domain Expertise Simulation Without Fine-Tuning

**Reviewer**: Danqi Chen (Princeton)
**Expertise**: Dense retrieval, question answering, NLP evaluation
**Round**: 1
**Date**: 2026-02-05

---

## Overall Assessment

This paper presents a method for constructing AI reviewer personas from structured profiles and evaluates whether these personas produce distinct, expertise-aligned feedback. The paper is targeting EMNLP/ACL, which makes venue fit an important consideration.

The research question is interesting and increasingly relevant as LLM-based evaluation becomes more common in NLP research. The empirical methodology — analyzing correlation structure across 186+ reviews — is reasonable, though the analysis could be deeper. The finding about key-question prompting is genuinely useful.

My primary concern is that the paper reads more as an engineering report than a scientific contribution. The method is straightforward prompting with structured profiles, and the analysis, while competent, lacks the depth of a typical EMNLP paper. The paper would benefit from a more formal treatment of the calibration problem and stronger connections to the NLP evaluation literature.

## Score

**Score**: 2/4 — Weak Accept

## Major Issues (Blocking)

### M1: Limited Technical Novelty for an NLP Venue
The method consists of structured prompt construction from a profile database. While effective, this is essentially "prompt engineering with structured templates." For EMNLP, I would expect either: (a) a more sophisticated method (e.g., retrieval-augmented persona construction using the reviewer's actual papers), (b) a formal framework for modeling persona behavior (e.g., as a distribution over review attributes), or (c) a significantly deeper empirical analysis. The current contribution sits between a systems paper and an NLP paper without fully committing to either.

### M2: Evaluation Does Not Address Ambiguity Handling
How do different personas handle ambiguous aspects of a paper? When a paper's contribution is genuinely unclear, do all personas converge on the same interpretation, or do they diverge? This is a critical test of persona depth. The current evaluation only measures score and topic divergence, missing the more nuanced question of interpretive diversity.

## Minor Issues

### m1: Related Work Missing Key References
The LLM-as-judge section should cite recent work on multi-LLM evaluation frameworks (e.g., ChatEval, PandaLM). The persona simulation section should reference work on role-playing evaluation in NLP benchmarks.

### m2: Venue Alignment Analysis is Thin
The paper mentions venue alignment as a profile field but doesn't systematically analyze whether venue-matched reviewers produce more appropriate feedback than venue-mismatched reviewers. This seems like a natural experiment to run.

### m3: Category Coverage is Uneven
The database has 10 categories but the analysis focuses heavily on a few (Systems, Agents, Human-Centered). Are the calibration findings stable across all categories?

## Strengths

1. Clear research question with practical implications for the NLP community
2. The 34% variance increase from key-question injection is a strong, quantifiable finding
3. The panel composition rules (Section 3.3) are sensible and well-motivated

## Questions for Authors

1. Have you tried retrieval-augmented persona construction — e.g., retrieving the reviewer's actual papers and using them to ground the persona?
2. How does the method handle papers that are on the boundary between two categories? Do reviewers from adjacent categories agree more?
3. What is the token cost comparison between a 5-reviewer panel and a single detailed review?

## Recommendations

- Strengthen the technical contribution: either formalize the calibration framework or add retrieval-augmented persona construction
- Add an ambiguity analysis — select papers with genuinely debatable contributions and measure interpretive diversity
- Expand the related work to cover recent LLM evaluation frameworks
- Provide a venue-alignment analysis as an additional calibration dimension

---

**Verdict**: Major Revisions Required

**Confidence**: Medium — The paper is adjacent to my core expertise (NLP evaluation), but I am less familiar with the multi-agent simulation literature.
