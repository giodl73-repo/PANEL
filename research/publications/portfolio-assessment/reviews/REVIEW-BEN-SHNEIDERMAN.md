# Review: Cross-Portfolio Expert Panels: Holistic Assessment of Multi-Paper Research Programs

**Reviewer**: Ben Shneiderman (University of Maryland)
**Expertise**: Human-Centered AI, human agency, oversight
**Round**: 1
**Date**: 2026-02-05

---

## Overall Assessment

This paper proposes a methodology for assessing research programs at the portfolio level rather than individual papers. The motivation is sound: research programs do exhibit emergent properties invisible at the paper level, and traditional review processes miss these entirely. The identification of cross-cutting themes—particularly the "Human Dimensions Deficit" (Theme 5) and the "Missing Learning Loop" (Theme 3)—demonstrates the methodology's ability to surface strategic gaps.

However, I am concerned that this paper's methodology perpetuates the very problem it identifies in Theme 5. The cross-portfolio panel is entirely automated—AI-simulated reviewers generating assessments without meaningful human oversight or participation. The paper acknowledges this in limitations but treats it as a secondary concern. I would argue it is a primary concern: if the paper's own findings show that 85% of the reviewed papers lack human dimensions, shouldn't the assessment methodology itself prioritize human involvement?

The paper also raises a deeper epistemological question it doesn't adequately address: when AI simulates expert disagreement, does the resulting "structured disagreement" have the same epistemic value as genuine disagreement between human experts? The paper's reviewer bloc analysis (Systems vs. Agents vs. HCI) is interesting, but I'm not convinced that LLM personas reliably reproduce the deep theoretical commitments that drive real disciplinary disagreements.

## Score

**Score**: 2/4 — Weak Accept

## Major Issues (Blocking)

### M1: Human Agency in the Assessment Process
The paper presents a fully automated assessment methodology but never engages with whether human researchers should be in the loop. For a paper targeting JCDL/Scientometrics—venues that care deeply about research practice—this is a significant gap. The methodology should explicitly describe: (a) where human judgment enters, (b) what decisions humans make vs. what the system decides, and (c) how researchers can contest or override panel assessments.

### M2: Epistemic Status of AI-Simulated Disagreement
The paper treats AI-simulated reviewer bloc disagreement (ρ = 0.05-0.30 between blocs) as equivalent to genuine disciplinary disagreement. This is a strong claim that requires justification. Real disciplinary disagreements arise from years of training, theoretical commitments, and methodological preferences. Can LLM personas with brief descriptions reproduce this? The paper needs either empirical validation or a much more careful discussion of what the simulated disagreement actually represents.

## Minor Issues

### m1: Theme 5 Self-Referentiality
The paper identifies "Human Dimensions Deficit" as a cross-cutting theme but doesn't apply this insight to its own methodology. This is a missed opportunity for self-aware methodological design.

### m2: Oversight Mechanisms Missing
What happens when the panel produces clearly wrong assessments? There's no discussion of quality assurance, appeals processes, or human review of panel outputs. For a methodology aimed at research assessment, this is important.

### m3: Accessibility of Panel Outputs
The tier classification and rankings are presented as tables, but there's no discussion of how these results would be presented to researchers in practice. Visualization, interactive exploration, and narrative summaries would make the outputs more useful.

## Strengths

1. **Portfolio-level insight generation**: The 6 cross-cutting themes are genuinely valuable and demonstrate clear portfolio-level signal invisible to individual review.
2. **Honest limitations**: The paper acknowledges the AI-simulation limitation directly rather than burying it. This transparency is appreciated.
3. **Practical protocol**: The 5-step assessment protocol (read all, score, rank, identify themes, recommend) is clear and replicable.

## Questions for Authors

1. Does this methodology preserve meaningful human control over research assessment, or does it automate away the very judgments that should remain human?
2. If you ran this panel with real experts, what would you expect to change? Which findings would survive and which might not?
3. How would you handle a case where the panel assessment conflicts with the researchers' own understanding of their program's strengths?

## Recommendations

- Add a section on human-in-the-loop design for the panel methodology, specifying where human judgment is essential
- Include a discussion of the epistemic differences between AI-simulated and human expert disagreement
- Design an appeals or contestation mechanism for researchers to challenge panel assessments
- Consider a hybrid design where AI generates initial assessments and human experts validate, revise, and deliberate

---

**Verdict**: Major Revisions Required

**Confidence**: High — This directly relates to my decades of work on human-centered AI and the importance of maintaining human agency in automated systems. The paper needs to reckon with its own findings about human dimensions.
