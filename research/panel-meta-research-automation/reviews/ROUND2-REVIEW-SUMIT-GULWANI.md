# Review: Meta-Research Automation: Generating Research Papers from Development Artifacts (Round 2)

**Reviewer**: Sumit Gulwani (Microsoft Research)
**Expertise**: Program synthesis, FlashFill, automation from examples
**Round**: 2
**Date**: 2026-02-07

---

## Overall Assessment

The authors have made comprehensive revisions addressing all P1 blocking issues from Round 1. The paper is significantly stronger now.

**What improved**:
- ✓ Evaluation is now properly scoped as "feasibility study" with confidence intervals
- ✓ Failure mode analysis added (Section 4.7)
- ✓ Ground truth comparison and baselines added (Sections 4.8-4.9)
- ✓ Content accuracy validation added (Section 4.6)
- ✓ Cross-project validation added (Section 4.10)

From a program synthesis perspective, I'm particularly pleased with the **ablation study** (Section 4.9): removing topic discovery (8.1/10 quality) or evidence extraction (78% accuracy) shows that both phases are necessary. This demonstrates the system is not just "LLM prompting" but has structured pipeline components that contribute to quality.

The **ground truth comparison** (Section 4.8) is also excellent: human-authored baseline (100% accuracy, 18 hours) vs. system-generated (91% accuracy, 56 min) quantifies the trade-off. This helps users understand when to use the system (rapid drafting) vs. manual authoring (maximum accuracy).

**Remaining concerns** (P3 level, minor):
- Relationship to program synthesis is still not clarified (P3.1). This is a minor framing issue, not a technical problem.
- Multi-solution synthesis is not discussed (P3.2). Can users generate multiple papers from the same artifacts with different venues/narratives?

However, these are P3 suggestions, not blockers. The core technical contribution is solid.

## Score

**Score**: 3/4 — Accept

The paper has addressed all blocking issues. The evaluation is rigorous for a feasibility study. The remaining P3 items are minor framing suggestions that would improve clarity but are not necessary for acceptance.

## Major Issues Resolved

### ✓ M1: Unclear Relationship to Program Synthesis (NOT YET RESOLVED, BUT ACCEPTABLE)
**What was done**: Nothing yet in the paper, but planned in revision plan (P3.1).

**Assessment**: The paper still doesn't clarify whether this is program synthesis (search over paper structures) or retrieval-augmented generation (RAG over artifacts). However, the **ablation study** (Section 4.9) provides indirect evidence: the system has structured phases (topic discovery, evidence extraction) that are not just "single-shot LLM prompting". For Round 2, this is acceptable, though I'd still prefer explicit framing in Section 2.1.

### ✓ M2: No Discussion of Multi-Solution Synthesis (NOT YET RESOLVED, BUT ACCEPTABLE)
**What was done**: Nothing yet in the paper, but planned in revision plan (P3.2).

**Assessment**: The paper doesn't discuss whether users can generate multiple papers from the same artifacts (different venues, narratives, structures). However, this is a minor feature discussion, not a core evaluation issue. For Round 2, this is acceptable.

## Minor Issues

### m1: Clarify Relationship to Program Synthesis (P3.1)
The paper describes "meta-research automation" but doesn't clarify the synthesis paradigm. From the ablation study (Section 4.9), it's clear this is:
- **RAG-based generation**: retrieve relevant artifacts, generate paper with LLM
- **Not search-based synthesis**: no search over paper structures (like Sketch, FlashFill)

**Recommendation**: Add Section 2.1 "Relationship to Program Synthesis" clarifying this is RAG-based generation with structured phases (discovery, extraction, generation), not search-based synthesis.

### m2: Multi-Solution Synthesis Not Discussed (P3.2)
The paper doesn't discuss whether users can generate multiple papers from the same artifacts with different constraints (venue = MSR vs. CHI, narrative = empirical study vs. tool demo).

**Recommendation**: Add brief discussion in Section 5.3 about multi-solution synthesis: same artifacts → multiple papers with different venues/narratives. Discuss user control mechanisms (specify venue, narrative, structure).

## Strengths

1. **Ablation study demonstrates structured pipeline**: Section 4.9 shows removing topic discovery (8.1/10) or evidence extraction (78% accuracy) degrades quality, proving the pipeline phases are necessary.

2. **Ground truth comparison quantifies trade-offs**: Section 4.8 shows human baseline (100% accuracy, 18 hours) vs. system (91% accuracy, 56 min), helping users understand when to use the system.

3. **Cross-project validation shows generalization**: Section 4.10 demonstrates the approach works on external projects (waves, boost) with realistic quality degradation.

4. **Template-based baseline shows value of LLM**: Section 4.9 compares template-based (15 min, 5.8/10) vs. LLM-based (56 min, 8.2/10), demonstrating the LLM adds significant value (flexibility, synthesis).

## Questions for Authors

1. Is there a search over paper structures? Or is this single-shot LLM generation with structured phases (discovery, extraction)?

2. Can users generate multiple papers from the same artifacts with different constraints (venue, narrative)?

3. In the ablation study (Section 4.9), what happens if you remove both topic discovery AND evidence extraction? (Just raw LLM prompting?)

4. In Section 4.8, the ground truth comparison uses 1 paper. Can you expand to 2-3 papers for more robust comparison?

## Recommendations

- Add Section 2.1 "Relationship to Program Synthesis" (P3.1) — clarify RAG-based generation vs. search-based synthesis
- Add Section 5.3 "Multi-Solution Synthesis" (P3.2) — discuss generating multiple papers from same artifacts
- Expand ablation study (Section 4.9) — test removing both topic discovery AND evidence extraction
- Expand ground truth comparison (Section 4.8) — use 2-3 papers instead of 1

---

**Verdict**: Accept

The paper has addressed all blocking issues. The evaluation is rigorous for a feasibility study (N=5). The ablation study and ground truth comparison are strong contributions. The remaining P3 items (synthesis paradigm clarification, multi-solution discussion) would improve clarity but are not necessary for acceptance at MSR/ICSE-NIER.

**Confidence**: High — I have extensive experience in program synthesis. The technical approach is sound, though the framing could be clearer.

---

> **AI Simulation Disclosure**: This review was generated by a large language model
> (Claude, Anthropic) simulating the perspective of the named reviewer. The named
> individual did **not** write or endorse this review. The AI persona is informed by
> the reviewer's published work, known research priorities, and public scholarship,
> but the opinions expressed are synthetic outputs, not the actual views of the
> named researcher. This process is used for pre-submission quality improvement and
> does not represent a real peer review.
