# Review: Multi-Round Revision Dynamics

**Reviewer**: Saleema Amershi (Microsoft Research)
**Expertise**: Interactive machine learning, human-in-the-loop systems
**Round**: 1
**Date**: 2026-02-05

---

## Overall Assessment

This paper takes an interesting systems perspective on the iterative review-revise cycle, treating it as a feedback loop amenable to empirical characterization. The study design—14 papers, 5–9 AI reviewers per paper, 2–4 rounds, with structured P1/P2/P3 priority classification—is well-conceived for this type of process analysis. The findings about diminishing returns and P1-driven improvement are practically useful.

From an interactive ML perspective, this paper describes a human-in-the-loop system where the human (author) iteratively improves artifacts based on structured AI feedback. The key missing piece is the *interaction analysis*: how does the author interpret and respond to feedback? The paper treats revision as a black box between review rounds, but the interaction between feedback and revision strategy is where the most interesting dynamics lie.

The paper is a solid first step, but needs more depth on the human side of the loop. Right now it's primarily a score trajectory study with limited insight into *why* scores change and *how* the author processes feedback.

## Score

**Score**: 2/4 — Weak Accept

## Major Issues (Blocking)

### M1: Revision Process is a Black Box
The paper tracks scores across rounds but provides no analysis of the revision process itself. How did the author decide which P1 items to address first? How long did each revision take? Were some P1 items partially addressed? Were there disagreements between the author's assessment and the reviewers' assessment of what was "addressed"? This interaction data is critical for understanding revision dynamics.

### M2: No Feedback Loop Analysis
The paper describes an iterative feedback loop but doesn't analyze it as one. Key questions: Does feedback in round N improve the *type* of feedback in round N+1 (not just scores)? Do reviewers converge or diverge across rounds? Is there evidence of the system learning—do later papers in the sequence revise more efficiently than earlier ones? These feedback loop dynamics are the paper's natural contribution.

### M3: Statistical Methodology Insufficient for Claims
With N=14 and a single author, the paper lacks the statistical power to support claims like "85% of papers reach submission readiness within two rounds." The paper would be stronger with: (a) explicit uncertainty quantification, (b) mixed-effects models that account for the nested structure (reviews within papers within modules), and (c) clear acknowledgment that these are descriptive statistics, not predictive models.

## Minor Issues

### m1: Interactive ML Framing Missing
This paper describes a classic interactive ML loop (human improves artifact based on AI feedback) but doesn't frame it that way. Connecting to the interactive ML literature would strengthen the contribution and open new analysis directions.

### m2: Score Inflation Mitigation Insufficiently Evaluated
The limitation about score inflation in later rounds is acknowledged but not tested. Compare the specificity and severity of issues identified in round 1 vs. round 2 reviews for the same paper to check for inflation patterns.

## Strengths

1. Clean study design with standardized protocol across all papers and rounds
2. The P1/P2/P3 decomposition provides a principled way to prioritize revision effort with clear empirical validation
3. Convergence predictors offer practical utility—knowing that papers with ≤2 P1 items and initial scores ≥6.0 converge fastest is actionable

## Questions for Authors

1. Did the author (you) learn to revise more effectively over the course of the study? Is there a learning curve effect?
2. How did you decide when a P1 item was "addressed"? Was this validated by the AI reviewers before the next round?
3. Could the revision dynamics be partially explained by the AI reviewers being more consistent than human reviewers, rather than by properties of revision itself?

## Recommendations

- Add a "Revision Process" section analyzing how feedback was interpreted and acted upon
- Frame the paper within interactive ML and include relevant interaction metrics
- Use mixed-effects models to properly account for the nested data structure
- Test for score inflation by comparing review content specificity across rounds

---

**Verdict**: Major Revisions Required

**Confidence**: High — Human-AI feedback loops and interactive ML are my core research focus.
