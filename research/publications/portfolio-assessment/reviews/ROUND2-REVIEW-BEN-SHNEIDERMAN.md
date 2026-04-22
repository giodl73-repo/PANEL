# Review: Cross-Portfolio Expert Panels

**Reviewer**: Ben Shneiderman (UMD)
**Expertise**: Human-Centered AI, human agency, oversight
**Round**: 2
**Date**: 2026-02-05

---

## Overall Assessment

The revised paper has addressed my fundamental concern about human agency in assessment. The human-in-the-loop section (6.3) is the most important addition in this revision. The clear distinction between automatable and human-essential stages demonstrates that the authors understand the difference between tool and replacement. The three-tier appeals mechanism is a genuine design contribution---the progression from factual correction through scope contestation to panel recomposition provides escalating recourse that respects author agency.

The calibration section (6.4) is honest about what is and isn't known. The epistemic framing---"plausible but unvalidated"---is appropriate. I remain cautious about the strength of claims one can make from AI-simulated panels, but the paper now frames its contributions with the right level of humility.

The "AI drafts, human decides" deployment model is the correct framing. My Round 1 concern was that the paper presented a fully automated methodology as the endpoint; the revision correctly positions it as a structured input to human decision-making.

I'm upgrading my score from 2/4 to 3/4. The paper now has a human-centered design for what is inherently a human-centered process.

## Score

**Score**: 3/4 — Accept

## Major Issues (Blocking)

None. The critical human agency gap has been addressed.

## Minor Issues

### m1: Appeals Mechanism Scope
The appeals mechanism addresses individual assessment disputes but doesn't cover portfolio-level contestation. What if an author disagrees with the cross-cutting theme characterization of their paper?

### m2: Deployment Safeguards
The deployment model recommends "AI drafts, human decides" but doesn't specify minimum qualifications for the human validator. In practice, who validates? A peer researcher? A department chair? The criteria matter.

## Strengths

1. Human-in-the-loop design directly addresses the Round 1 concern about human agency
2. Three-tier appeals mechanism is a practical, adoptable design
3. Epistemic framing of AI-simulated disagreement is appropriately cautious
4. "AI drafts, human decides" is the right deployment model
5. Failure modes section shows awareness of methodological limitations

## Questions for Authors

1. In the appeals mechanism, who adjudicates? Is there a meta-panel, or does the system designer decide?
2. How would you handle a case where the human validator fundamentally disagrees with the AI panel's tier classification?

## Recommendations

- Extend the appeals mechanism to cover portfolio-level disputes (theme characterization, strategic priorities)
- Specify minimum qualifications or selection criteria for human validators

---

**Verdict**: Accept with Minor Revisions

**Confidence**: High — Human-centered AI and human oversight in automated systems are my primary research focus.
