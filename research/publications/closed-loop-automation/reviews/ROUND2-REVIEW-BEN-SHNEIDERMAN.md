# Review: From Reviews to Revisions: Closed-Loop Automation of Academic Paper Improvement

**Reviewer**: Ben Shneiderman (University of Maryland)
**Expertise**: Human-Centered AI, Human Agency, Oversight Systems
**Round**: 2
**Date**: 2026-02-07

---

## Overall Assessment

The revision is **substantial and responsive**. The authors have fundamentally reframed the paper from automation-centric to human-centered, addressing my core concerns about agency and control. The new "Human Agency in Automated Revision" subsection (Discussion) is excellent — it critically examines what is lost when revision becomes algorithmic, proposes concrete design principles (transparency, selective automation, edit provenance), and acknowledges risks (over-reliance, loss of learning, homogenization).

The reframed contribution now leads with "Mapping the automation boundary" rather than "we automated X%", which aligns much better with CHI/CSCW values. The author experience section adds valuable qualitative data: 2 of 7 authors "stopped reading edits carefully" is honest reporting that supports the concern about passive deference.

The paper is now a genuine contribution to human-centered AI design, not just a technical artifact. The analysis of when automation is appropriate (mechanical corrections: yes, conceptual refinement: no) provides actionable guidance for designers of writing assistance tools.

**Remaining concerns** are minor and mostly about execution rather than framing.

## Score

**Score**: 3/4 — Accept

## Major Issues Resolved

### ✓ M1: Human-Centered Analysis (RESOLVED)

The "Human Agency" subsection comprehensively addresses my concerns. The three-category taxonomy (mechanical corrections, evidence insertion, conceptual refinement) is clear and useful. The design principles (transparency, selective automation, provenance) are grounded in HCAI frameworks. The discussion of 94% acceptance as potential deference (rather than pure success) shows critical thinking.

The homogenization analysis (0.31 → 0.38 similarity) is valuable empirical evidence. The effect is modest but real, and the mitigation strategies (personalization, multiple rephrasings, encourage modification) are practical.

### ✓ M2: Quality Comparison (PARTIALLY RESOLVED)

The cost-benefit analysis table is excellent — clear comparison across manual, professional, crowd, and automated methods with cost/time/quality/tradeoffs. The acknowledgment of the quality comparison gap (lack of blind expert ratings) is honest. While I would still prefer empirical evidence, the authors have been transparent about this limitation and proposed a concrete study design.

The hybrid workflow recommendation (\$212, 4hrs author + 3 days editor) is practical and shows nuanced thinking about when to combine approaches.

### ✓ M3: Limitations and Risks (RESOLVED)

The expanded Limitations section now covers: over-reliance, loss of tacit learning, adversarial gaming, homogenization, and accountability/authorship. These are exactly the risks I wanted acknowledged. The discussion of accountability ("who is responsible for automated edit errors?") raises important ethical questions for the community.

## Minor Issues

### m1: Author Experience Data Could Be Richer

The interview data (7 authors) is a good start, but it's quite thin. Quotes are paraphrased rather than verbatim. For a paper emphasizing human-centeredness, more detailed qualitative analysis would strengthen the claims. For example:
- What specific edits did authors modify? Why?
- How did perceived control vary by author experience (novice vs. expert)?
- Did any authors refuse to use automation for certain sections?

This isn't blocking, but future work should include deeper qualitative investigation.

### m2: Design Principles Need Operationalization

The three design principles (transparency, selective automation, provenance) are well-motivated, but the paper doesn't show how they're implemented in the current system. For example:
- Transparency: Does REVISION-PLAN.md show which reviewer suggested each edit? (It should, per the principle)
- Selective automation: Can authors specify "automate typos, flag phrasing"? (Not clear from Methodology)
- Provenance: The `panel:show --edit-history` command is mentioned, but not demonstrated

Adding 1-2 screenshots or example outputs would make these principles concrete.

### m3: Hybrid Workflow Recommendation Needs Empirical Grounding

The hybrid workflow (\$212 total) is a useful thought exercise, but it's not grounded in actual data. Did any of the 14 papers use a hybrid approach? If not, this is speculation rather than evidence-based recommendation. Consider labeling it as "Proposed Hybrid Workflow" rather than presenting it as established practice.

## Strengths

1. **Fundamentally improved framing** — Now a human-centered AI paper, not just a systems paper
2. **Critical self-reflection** — Honest about limitations (quality gap, deference concerns, homogenization)
3. **Actionable taxonomy** — The mechanical/evidence/conceptual categorization is useful for practitioners
4. **Grounded in HCAI principles** — Cites Shneiderman 2020, Amershi 2019; applies frameworks correctly
5. **Comprehensive risk analysis** — Covers technical, social, and ethical dimensions

## Questions for Authors

1. How would you implement selective automation in practice? Could authors configure preferences ("automate category X, flag category Y")?

2. The similarity analysis (0.31 → 0.38) is interesting but limited. Have you analyzed *which phrases* are being homogenized? Are they domain-specific terminology or general writing patterns?

3. You note that "automation is most appropriate for experienced authors who have internalized writing principles." Should the system adapt its level of automation based on author experience?

## Recommendations

- Add example screenshots showing transparency and provenance features
- Expand author experience section with deeper qualitative analysis (if possible in revision time)
- Label hybrid workflow as "proposed" unless empirical data supports it
- Consider discussing how automation level could adapt to author experience

---

**Verdict**: Accept

**Confidence**: High — The paper now aligns with CHI/CSCW values and makes a genuine contribution to human-centered AI design. The revision directly addressed all my major concerns.

---

> **AI Simulation Disclosure**: This review was generated by a large language model
> (Claude, Anthropic) simulating the perspective of the named reviewer. The named
> individual did **not** write or endorse this review. The AI persona is informed by
> the reviewer's published work, known research priorities, and public scholarship,
> but the opinions expressed are synthetic outputs, not the actual views of the
> named researcher. This process is used for pre-submission quality improvement and
> does not represent a real peer review.
