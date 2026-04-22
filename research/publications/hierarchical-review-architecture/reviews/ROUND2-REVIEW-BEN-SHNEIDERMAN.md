# Round 2 Review: Hierarchical Review Architecture: Scaling Expert Feedback Through Three-Tier Synthesis

**Reviewer**: Ben Shneiderman (University of Maryland)
**Expertise**: Human-Centered AI, human agency, oversight, human control
**Round**: 2
**Date**: 2026-02-07

---

## Overall Assessment

The authors have made exemplary revisions addressing human-centered AI principles. The addition of human oversight mechanisms (Section 3.7) transforms this from a fully automated system into a proper human-AI collaboration framework. The confidence-based deferral, human override capability, and emergent pattern validation ensure meaningful human control at all tiers.

This is exactly what human-centered AI looks like: AI handles tedious synthesis and pattern detection, but humans retain authority over high-stakes decisions. The 12% deferral rate and 3-8% override rate demonstrate the system appropriately balances automation and human judgment.

The transparency additions (provenance tracking, confidence indicators, trace IDs) enable users to understand and trust the system's classifications. The validation study showing 73% agreement with human panels provides calibration guidance: users should trust high-confidence classifications but scrutinize borderline cases.

**Previous score**: 3/4 (Accept)
**Updated score**: 4/4 (Strong Accept)

This is now an exemplar of thoughtful human-AI system design for research methodology.

## Changes from Round 1

### ✓ M1: Human Oversight Mechanisms — FULLY ADDRESSED

Section 3.7 implements three oversight layers:

1. **Confidence-based deferral**: Items with confidence < 0.60 escalate to human review (12% of items trigger this). This prevents low-quality AI classifications from affecting revision plans.

2. **Human override capability**: Authors can contest P1 items, panel chairs approve PP1 items, board requires unanimous consent for multi-module B1 items. The 3-8% override rate suggests the system makes good default choices but preserves human authority when needed.

3. **Emergent pattern validation**: High-criticality patterns require human approval before cascading. This is critical because "emergent" patterns (not in lower-tier reviews) could be AI hallucinations.

The validation results (Section 4.8) show 85% of overrides were correct (human judgment superior to AI), 15% were debatable. This demonstrates the oversight mechanisms catch real errors without excessive false alarms.

**Round 1 concern**: "No mechanism for humans to override AI classifications"
**Resolution**: Comprehensive oversight at all three tiers with empirical validation. ✓

### ✓ M2: Transparency and Explainability — FULLY ADDRESSED

Section 3.8 adds provenance tracking: every priority item includes source reviews, confidence breakdown, escalation path, and trace ID. The `panel:inspect <paper>` command enables debugging.

This addresses my concern about trust calibration. Users can:
- See which reviewers flagged an issue (provenance)
- Understand why the system classified it as P1 vs. P2 (confidence breakdown)
- Trace PP1/B1 items back to contributing P/PP items (escalation path)
- Verify reproducibility by replaying synthesis (trace ID + structured logs)

Combined with confidence scores on all classifications, this provides the transparency needed for informed human decisions.

**Round 1 concern**: "How do users know when to trust the system?"
**Resolution**: Provenance tracking, confidence scoring, and validation study (73% agreement) provide calibration. ✓

### ✓ m1: Trust Calibration — ADDRESSED

The validation study (Section 4.6) provides calibration benchmarks:
- 73% agreement with human experts overall
- Confidence scores correlate with human agreement (r = 0.71, p < 0.01)
- High-confidence items (>0.85) have 89% agreement; low-confidence (<0.60) have 54% agreement

This tells users: trust high-confidence classifications, scrutinize low-confidence ones. The correlation between confidence and accuracy validates the calibration mechanism.

**Round 1 concern**: "No guidance on when to trust vs. question classifications"
**Resolution**: Confidence-agreement correlation provides clear calibration guidance. ✓

### ✓ m2: Revision Application Workflow — ADDRESSED

While not explicitly detailed as a subsection, Section 3.4 (revision stage) and Section 5.6 (operational considerations) describe the revision workflow. The two-phase approach (create plan, apply edits) with human choice (accept/decline revisions) preserves human agency.

The outcome validation (Section 4.6) showing +0.8 score improvement for papers addressing P1 items suggests the revision workflow is effective.

**Round 1 concern**: "Revision workflow unclear"
**Resolution**: Workflow described in methodology, outcome validation demonstrates effectiveness. ✓

## Minor Remaining Issues

### m1: User Interface Design

While the paper describes provenance tracking and confidence scoring, it doesn't show how users actually interact with the system. Are there visual dashboards? Command-line tools? Web interfaces?

Figure~\ref{fig:dashboard} is mentioned in Section 3.8 but appears to be in an appendix not included in this version. Showing example UI screenshots or mockups would strengthen the human factors argument.

**Suggestion**: Add an appendix figure showing the dashboard/UI, or at minimum describe the interaction model (CLI commands vs. web UI vs. IDE integration).

### m2: Accessibility Considerations

My Round 1 concern about accessibility (screen readers, cognitive load, non-English support) wasn't explicitly addressed. Section 5.7 (limitations) doesn't mention accessibility.

For a human-centered AI system, considering diverse user needs is important. Even a brief discussion acknowledging accessibility as future work would be appropriate.

**Suggestion**: Add a paragraph in Section 5.7 or 6.0 (future work) discussing accessibility: progressive disclosure for cognitive load, screen-reader compatibility, internationalization support.

### m3: Long-term Human Learning Effects

The system provides AI-generated feedback, which might affect how researchers internalize review norms over time. Do authors who use this system develop better writing skills, or do they become dependent on AI feedback?

This is beyond the paper's scope but worth mentioning as a potential concern for long-term deployment.

**Suggestion**: Add to future work: longitudinal study of author skill development when using AI review systems.

## Strengths (Updated)

1. **Exemplary human-centered AI design**: The three-tier oversight (deferral, override, validation) ensures meaningful human control without micromanagement.

2. **Transparency for trust**: Provenance tracking, confidence scoring, and trace IDs enable informed human decision-making.

3. **Empirical validation of human-AI complementarity**: The 12% deferral rate and 3-8% override rate show the system appropriately delegates: AI handles the common case, humans handle edge cases.

4. **Calibration guidance**: The confidence-agreement correlation (r=0.71) tells users when to trust the system vs. seek human judgment.

5. **Real deployment experience**: The operational discussion (Section 5.6) demonstrates the authors have run this in production and learned from experience.

## Questions for Authors

1. Have you observed user behavior patterns? Do researchers trust high-confidence classifications automatically, or do they inspect evidence regardless?

2. What's the typical response when users receive a low-confidence deferral? Do they appreciate the uncertainty flag or find it frustrating?

3. Have you considered A/B testing: users with vs. without confidence scores? Does showing confidence improve decision quality or just reduce user confidence?

4. For the 15% of overrides that were "debatable," how were those resolved? Did a second human reviewer adjudicate?

## Recommendations for Camera-Ready

- **Add Figure~\ref{fig:dashboard}**: Show the actual dashboard mentioned in Section 3.8. Visual evidence of the UI strengthens human factors claims.

- **Discuss accessibility**: Brief paragraph on screen-reader support, cognitive load management, internationalization.

- **Expand on failure recovery**: When humans override a P1 classification, what happens to downstream PP1/B1 items that depended on it? Does the system propagate the override or require manual intervention?

- **Cite HCAI guidelines**: Reference recent human-centered AI frameworks (NIST AI Risk Management Framework, IEEE Ethically Aligned Design) to position this work in the broader HCAI context.

---

**Overall verdict**: This is now excellent human-centered AI systems work. The oversight mechanisms, transparency features, and empirical validation demonstrate thoughtful attention to preserving human agency while leveraging AI capabilities. This should be a strong accept for ICSE/FSE and could be a model for other AI-assisted research tools.

**Recommendation**: Strong Accept for publication.

---

> **AI Simulation Disclosure**: This review was generated by an AI system (Claude, Anthropic)
> simulating the perspective of Ben Shneiderman based on his published work on Human-Centered AI
> (HCAI), human agency, and human control principles. Ben Shneiderman did not write this review
> and has no involvement with this work. This is a synthetic artifact for testing the hierarchical
> review system described in the paper.
