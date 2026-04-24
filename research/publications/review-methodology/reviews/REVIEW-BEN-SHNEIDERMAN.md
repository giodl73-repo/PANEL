# Review: AI-Simulated Expert Review: A Methodology for Pre-Submission Paper Assessment

**Reviewer**: Ben Shneiderman (University of Maryland)
**Expertise**: Human-centered AI, human agency, information visualization
**Round**: 1
**Date**: 2026-02-05

---

## Overall Assessment

This paper describes a system for AI-simulated expert review that drives papers through an 8-stage lifecycle. The framework is well-structured and the engineering is competent — the stage definitions, gate conditions, and priority classification show careful design. The results across 14 papers suggest the methodology can identify areas for improvement.

However, the paper fundamentally undertheorizes the human-centered dimensions of its contribution. An AI system that impersonates named human experts to generate "reviews" raises profound questions about human agency, the nature of expertise, and the role of peer review in scholarly discourse. These questions are treated in a single paragraph (Section 6.3) when they deserve to be a central thread of the paper. The paper reads as a systems paper about a review pipeline, when it should also be a paper about the relationship between human and AI judgment in scholarly quality assessment.

The framing also conflates two distinct claims: (1) structured pre-submission self-assessment improves papers, and (2) AI-generated reviewer personas are the right mechanism for this assessment. The first claim is well-supported. The second needs much stronger justification.

## Score

**Score**: 2/4 — Weak Accept

## Major Issues (Blocking)

### M1: Insufficient Human-Centered Analysis
The paper treats reviewer personas as a technical design choice rather than engaging with what it means to simulate human expertise. Key missing dimensions: How do authors experience the process? Do they trust AI-generated feedback differently than human feedback? Does the use of named personas (e.g., "Percy Liang") change how authors respond to feedback compared to anonymous or generic AI feedback? Without studying the human experience of the system, the methodology claims are incomplete.

### M2: Agency and Autonomy Concerns
The 8-stage lifecycle with automatic gate conditions reduces author agency to "address P1 items." Where is the space for creative disagreement? Real peer review involves negotiation — authors sometimes push back on reviewer concerns, and this discourse improves both the paper and the reviewers' understanding. The current methodology enforces compliance rather than enabling dialogue.

### M3: Confounding Structure with Personas
The evaluation cannot distinguish whether improvements come from the structured lifecycle (which would work with any feedback mechanism) or from the AI personas specifically. The 8-stage model, P1/P2/P3 triage, and gate conditions are valuable regardless of whether feedback comes from AI personas, generic LLM prompts, or human checklists. This confound must be addressed.

## Minor Issues

### m1: Overstated Generalizability
The abstract claims the framework is "applicable to any research program" based on 14 papers from one author. This is a strong claim that needs qualification.

### m2: Missing Failure Analysis
What happens when the methodology fails? Are there papers that did not improve? Papers stuck in recheck loops? Understanding failure modes is essential for a methodology paper.

### m3: Visual Design of the Lifecycle
The paper describes an 8-stage lifecycle but relies on a plain table (Table 2) for presentation. A well-designed process diagram showing the recheck loop, gate conditions, and artifact flow would significantly improve comprehension — especially for a CHI audience that values information design.

## Strengths

1. **Explicit gate conditions**: The quantitative thresholds for stage progression (avg >= 2.5/4, no score < 2/4) are a valuable design pattern for quality-gated processes.
2. **Priority triage**: The P1/P2/P3 classification with the finding that P1 items account for 72% of improvement is a strong practical insight.
3. **Reproducibility**: The framework is well-documented with templates, scoring rubrics, and stage definitions that others could implement.

## Questions for Authors

1. How do authors emotionally and cognitively experience receiving AI-generated reviews attributed to named researchers? Have you reflected on your own experience as the author of all 14 papers?
2. What happens when the author believes a P1 item is wrong — i.e., the AI reviewers have misunderstood the paper? Is there a mechanism for disputing feedback?
3. Could the methodology work equally well with anonymous, non-persona-based AI feedback? What evidence suggests personas add value beyond generic feedback?

## Recommendations

- Add a section on the human experience of receiving AI-simulated reviews — author reflection, trust calibration, the psychology of receiving feedback from "Percy Liang" vs. an anonymous AI
- Include a mechanism for author-reviewer dialogue or pushback, not just compliance
- Design an ablation study: structured lifecycle with generic AI feedback vs. full persona-based approach
- Add a process flow diagram for the 8-stage lifecycle with the recheck loop
- Expand Section 6.3 into a full discussion of the ethics, agency, and epistemic implications

---

**Verdict**: Major Revisions Required

**Confidence**: High — Human-centered AI, human agency, and the role of human judgment in AI systems are central to my research.
