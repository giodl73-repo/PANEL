# Review: Cross-Portfolio Expert Panels

**Reviewer**: Michael Bernstein (Stanford)
**Expertise**: Crowdsourcing, human computation, social computing
**Round**: 2
**Date**: 2026-02-05

---

## Overall Assessment

The revision addresses the most critical gaps from Round 1. The baseline comparison (Section 4.3) was my top concern, and it's handled well: the $\rho = 0.83$ with aggregated individual scores is both honest and useful. The key finding---that rankings are mostly preserved but cross-cutting themes and strategic priorities are unique to the portfolio process---gives the paper a clear value proposition that the original lacked.

The human-in-the-loop section (6.3) is the most significant addition. The distinction between automatable stages (score aggregation, theme extraction) and human-essential stages (panel composition, strategic priority setting) is well-reasoned. The three-tier appeals mechanism is a practical contribution that other assessment systems could adopt. The "AI drafts, human decides" deployment model is the right framing for the current state of the technology.

The related work is much improved. The engagement with grant panels, Dawid-Skene, and crowdsourcing quality control properly positions the contribution. The operationalization section provides the replication details I asked for.

My remaining concern is that the failure mode analysis, while present, could be deeper. The ordering effects and score drift subsections acknowledge the issues but don't provide empirical evidence. This is a minor issue for the current paper but should be addressed in follow-up work.

## Score

**Score**: 3/4 — Accept

## Major Issues (Blocking)

None.

## Minor Issues

### m1: Failure Mode Analysis Depth
The failure modes section (6.5) identifies composition sensitivity, ordering effects, and score drift but provides no empirical evidence for their magnitude. Even a simple ablation (remove one reviewer, re-run) would strengthen this section.

### m2: Strategic Priority Ranking
The consensus-weighted voting method (Section 5.3) is now specified, which is good. But the conviction weights (high=3, medium=2, low=1) are arbitrary---is there a principled basis for these weights?

## Strengths

1. Baseline comparison clearly demonstrates the unique value of portfolio panels
2. Human-in-the-loop design is practical and well-specified
3. Appeals mechanism is a genuine contribution to assessment methodology
4. Operationalization section provides actionable replication details
5. Expanded related work properly positions the contribution

## Questions for Authors

1. Has anyone actually used the appeals mechanism? Even hypothetically, what would trigger a Level 3 (panel recomposition) appeal?
2. The operationalization section reports $15--25 per module assessment. How does this compare to the cost of a human expert panel?

## Recommendations

- Consider a simple ablation study (leave-one-reviewer-out) for the failure modes section
- Provide a brief justification for the conviction weight scale

---

**Verdict**: Accept with Minor Revisions

**Confidence**: High — Crowdsourcing quality control and human computation are my primary research areas.
