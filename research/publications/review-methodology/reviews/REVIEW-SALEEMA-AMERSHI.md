# Review: AI-Simulated Expert Review: A Methodology for Pre-Submission Paper Assessment

**Reviewer**: Saleema Amershi (Microsoft Research)
**Expertise**: Interactive machine learning, human-in-the-loop systems, AI/ML user experience
**Round**: 1
**Date**: 2026-02-05

---

## Overall Assessment

This paper presents a practical methodology for AI-simulated expert review, framing it as a pre-submission quality assurance pipeline. The system design — 8 stages with gates, priority triage, iterative refinement — is solid engineering. The priority classification (P1/P2/P3) is particularly well-motivated, and the empirical finding that P1 items drive 72% of improvement is valuable for practitioners considering adoption.

From an interactive ML perspective, the methodology is missing the "interactive" part. The current pipeline is batch-mode: generate reviews, synthesize, revise, regenerate. There is no mechanism for the author (the human in the loop) to interact with or steer the review process — no ability to clarify reviewer questions, no dialogue about contested points, no refinement of reviewer focus based on what the author finds most useful. For a CHI/CSCW submission, this gap in interactivity is notable.

That said, the methodology addresses a real need. Solo researchers and small teams genuinely lack access to structured pre-submission feedback. The framework is well-documented and clearly implementable. With revisions addressing the interactivity gap and evaluation concerns, this could be a strong contribution.

## Score

**Score**: 2/4 — Weak Accept

## Major Issues (Blocking)

### M1: No Interactive or Adaptive Mechanisms
The pipeline operates in batch mode with no human-in-the-loop interaction during review generation. Key missing capabilities:
- Author cannot clarify reviewer questions before synthesis
- No mechanism to redirect reviewer attention (e.g., "focus on methodology, I know the related work needs expansion")
- No feedback loop from author to improve reviewer persona accuracy
- No adaptive scoring that accounts for the author's response quality

For CSCW, where the focus is collaborative and social computing, the absence of any collaborative dimension in the human-AI review process is a significant gap.

### M2: Self-Referential Evaluation Problem
The evaluation conflates the process output with the evaluation measure. The same system generates reviews, scores, and the improvement metrics. This is analogous to evaluating a recommendation system using its own predicted ratings rather than actual user satisfaction. The paper needs evaluation grounded in outcomes external to the system.

### M3: No User Study or Experience Data
For a CHI/CSCW submission, the complete absence of user experience data is problematic. Even a case study with the single author would add value: How did receiving AI-generated reviews compare to receiving human feedback? Which reviews were most useful? Which were misleading? What was the cognitive load of processing 5 AI reviews versus 1 human review?

## Minor Issues

### m1: Reviewer Diversity Claims Need Evidence
The paper claims diversity through institutional balance and expertise complementarity but does not measure feedback diversity directly. Two reviewers from different institutions with different expertise tags could still produce substantively similar feedback.

### m2: Missing Error Analysis
What types of issues do AI reviewers miss? Are there systematic blind spots (e.g., conceptual novelty assessment, domain-specific methodological concerns)? Understanding limitations is as important as documenting successes.

### m3: Scalability Discussion Absent
The paper demonstrates the methodology on 14 papers. What are the practical limits? Cost per review? Time per stage? These operational metrics matter for adoption.

## Strengths

1. **Practical value**: Addresses a genuine gap in the research workflow — structured pre-submission feedback for researchers without access to expert pre-reviewers.
2. **Priority triage system**: The P1/P2/P3 classification is well-designed, and the 72% finding provides empirical backing for the triage approach.
3. **Reproducible framework**: Templates, rubrics, and stage definitions are clearly specified and could be adopted by others.

## Questions for Authors

1. Have you considered adding an interactive mode where the author can respond to reviewer questions before synthesis? This would make the process more conversational and potentially more useful.
2. What was your subjective experience as the author of all 14 papers? Were there cases where AI reviews were misleading or where you disagreed with the synthesized P1 items?
3. Could you compare the cognitive effort of processing AI reviews versus the few human reviews you may have received on similar work?
4. What is the cost (time, API calls, tokens) of running the full lifecycle for one paper?

## Recommendations

- Add at minimum an author experience case study (structured reflection on receiving/using AI reviews)
- Design an interactive mode where authors can steer reviewer focus and respond to questions
- Include error analysis: types of issues AI reviewers miss or get wrong
- Add operational metrics: cost, time, token usage per paper
- Compare batch AI review against a simpler "ask the LLM for feedback" baseline

---

**Verdict**: Major Revisions Required

**Confidence**: High — Interactive ML, human-in-the-loop systems, and the design of AI-assisted workflows are my primary research areas.
