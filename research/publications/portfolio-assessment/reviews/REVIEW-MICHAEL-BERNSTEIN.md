# Review: Cross-Portfolio Expert Panels: Holistic Assessment of Multi-Paper Research Programs

**Reviewer**: Michael Bernstein (Stanford)
**Expertise**: Crowdsourcing, human computation, social computing
**Round**: 1
**Date**: 2026-02-05

---

## Overall Assessment

This paper reimagines research assessment at the portfolio level, proposing cross-portfolio expert panels that evaluate entire collections of papers rather than individual submissions. As someone deeply invested in how we aggregate human judgment at scale, I see this as fundamentally a crowd computation problem: how do you design a process where multiple assessors produce a collective judgment that exceeds any individual assessment?

The strongest aspect of this work is the cross-cutting theme identification. The finding that two independently-developed modules converge on the same architectural pattern (Theme 1: Structured Expertise Injection) is exactly the kind of insight that justifies portfolio-level review. Individual paper reviewers would never see this—they'd evaluate each module's approach in isolation.

Where the paper falls short is in its treatment of the panel process as a social computation system. The paper describes the protocol mechanically (each reviewer reads all papers, scores on a 10-point scale, produces a ranking) but doesn't engage with the rich literature on how panel composition, ordering effects, and social dynamics affect collective judgment. In real expert panels, anchoring effects, status hierarchies, and discussion dynamics profoundly shape outcomes. The AI-simulated setting avoids some of these issues but introduces others (prompt sensitivity, persona consistency).

## Score

**Score**: 2/4 — Weak Accept

## Major Issues (Blocking)

### M1: Missing Panel Process Analysis
The paper treats the panel as a straightforward aggregation mechanism but ignores process effects that are well-documented in the crowdsourcing and judgment aggregation literature. Key missing elements: (a) Does reviewer ordering matter? (b) Would a deliberation phase change outcomes? (c) How does panel composition affect results? The methodology section describes what happens but not why these design choices were made over alternatives.

### M2: No Comparison to Simpler Aggregation Methods
The paper presents a 7-reviewer panel process but doesn't compare against simpler alternatives. What if you simply averaged the individual paper review scores from the per-paper review process? Would the rankings differ meaningfully? Without this baseline, it's unclear whether the added complexity of a cross-portfolio panel is justified for the ranking function (as opposed to the theme identification function).

## Minor Issues

### m1: Panel Size Justification
Why 7 reviewers? The crowdsourcing literature has extensive work on optimal jury size for different decision tasks. The limitations mention this but the methodology should justify the choice.

### m2: Cross-Module Board Composition
The cross-module board includes "3 who served on both module panels and 4 who served on one panel." This creates an asymmetry in familiarity with the material. How does this affect scoring patterns?

### m3: Strategic Priority Ranking Method
Section 5.3 ranks strategic priorities by "consensus" but the method isn't specified. Is this majority vote? Weighted by conviction? Ranked-choice?

## Strengths

1. **Cross-cutting theme identification is genuinely valuable**: Theme 1 (convergent architecture) and Theme 2 (mutual validation) are insights that no individual paper review could surface, providing clear justification for portfolio-level assessment.
2. **Structured disagreement framing**: Treating reviewer bloc disagreement as signal rather than noise is a productive framing that the field should adopt more broadly.
3. **Practical applicability**: The methodology is described concretely enough to be replicated by other research groups assessing their own portfolios.

## Questions for Authors

1. Have you considered a Delphi-style multi-round process where reviewers see each other's assessments and revise? This is standard in panel assessment and might improve convergence.
2. What happens if you remove one reviewer bloc entirely (e.g., drop all HCI reviewers)? How do rankings and themes change?
3. Could you decompose the value of portfolio-level review into its component functions (ranking, theme identification, strategic recommendations) and evaluate each separately?

## Recommendations

- Add a baseline comparison: aggregate individual paper review scores and compare against portfolio panel rankings
- Engage with the judgment aggregation literature (Dawid-Skene, GLAD, spectral methods) for more principled score combination
- Include an ablation study varying panel composition to understand sensitivity
- Specify the strategic priority ranking method explicitly

---

**Verdict**: Major Revisions Required

**Confidence**: High — This is directly related to my work on crowdsourcing, human computation, and collective intelligence. The paper needs to engage more deeply with how panel processes produce collective judgments.
