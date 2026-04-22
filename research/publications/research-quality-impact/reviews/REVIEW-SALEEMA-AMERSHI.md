# Review: Panel-Driven Research Quality Impact

**Reviewer**: Saleema Amershi (Microsoft Research)
**Expertise**: Interactive ML, human-in-the-loop, learning from feedback
**Round**: 1
**Date**: 2026-02-07

---

## Overall Assessment

This paper presents a compelling case for structured review processes in AI-assisted research. The +127% quality improvement and mechanistic analysis (systematic questioning, embracing negatives, standards elevation, iteration forcing) provide actionable insights for improving human-AI collaboration. As someone who works on interactive machine learning and human-in-the-loop systems, I find the iterative refinement process particularly interesting—8+ review rounds with adaptive exploration mirrors interactive ML workflows where models improve through repeated feedback cycles.

However, the paper has a **fundamental gap**: the system doesn't actually *learn* from feedback. Each review round generates new suggestions, Claude responds, but there's no evidence that the panel or Claude adapt based on what worked in prior rounds. In interactive ML, we emphasize closing the loop—using feedback to update models. Here, feedback improves the *paper*, but does the *system* improve? Can the panel recognize "we tried n-way partitioning and it failed" and avoid suggesting it again? Can Claude learn which types of panel feedback lead to productive revisions?

The lack of learning is especially problematic given the **8+ iteration cost**. If each paper requires 8 rounds to achieve quality thresholds, that's expensive. But if the system learned from paper 1 to apply to papers 2-N (transfer learning for research workflows), the cost would be worthwhile. The paper hints at this—noting that revision dynamics and synthesis methods are documented in other papers—but never analyzes whether the panel *system* improves over time.

Second concern: **user feedback is passive**. The user responds to panel questions and provides insights when prompted, but the system doesn't actively solicit user feedback to improve its own behavior. In interactive ML, we design interfaces that make it easy for users to provide corrective feedback ("no, that's wrong, try this instead"). Where are those affordances in panel-driven research? How does the user correct the panel when it drives exploration in wrong directions?

## Score

**Score**: 3/4 — Accept (with revisions)

## Major Issues (Blocking)

### M1: System Doesn't Learn From Feedback

The paper describes 8+ review rounds where panel generates feedback, Claude revises, panel reviews again. But there's **no evidence the system learns**. Each round seems independent—panel doesn't reference prior failed approaches, Claude doesn't avoid previously unsuccessful strategies, user doesn't train the panel on domain-specific preferences.

**Missing elements**:
- Does the panel recognize repeated issues across rounds and adapt questioning?
- Does Claude learn which panel feedback types lead to productive revisions?
- Does the user provide feedback on panel review quality ("this suggestion was helpful, that one was not")?
- Can the system transfer learning across papers (apply insights from paper 1 to paper 2)?

**Required changes**:
- Add subsection (Section 5 or 6): "Learning From Iterative Feedback"
- Analyze: Do later rounds show evidence of learning (fewer redundant suggestions, better targeting)?
- Discuss: How could the panel learn from feedback? (Maintain review history, recognize failed approaches, adapt questioning)
- Compare to interactive ML: Model updates from feedback vs. paper updates without system learning
- Future work: Implement feedback loops so system improves over time, not just individual papers

### M2: User Feedback Mechanisms Not Designed

The user provides domain insights (edge-weighting) and facilitates execution (debugging), but these contributions seem **ad-hoc** rather than structured. Where are the affordances for users to provide feedback on panel behavior? In interactive ML, we design interfaces that make feedback easy—labeling tools, correction mechanisms, confidence indicators. What's the equivalent for panel-driven research?

**Examples of missing affordances**:
- Can users mark panel suggestions as "helpful" vs. "unhelpful"?
- Can users indicate "this direction is promising, explore more" vs. "this is a dead end"?
- Can users correct panel misunderstandings about domain constraints?
- Can users request specific types of feedback ("focus on methodology, not presentation")?

**Required changes**:
- Add subsection (Section 5.2 or 5.3): "User Feedback Affordances"
- Discuss: How do users currently provide feedback on panel behavior? (Implicit through revisions, or explicit?)
- Design: What affordances would make user feedback more effective? (Rating panel suggestions, requesting focus areas, correcting misunderstandings)
- Compare to interactive ML interfaces: Labeling tools, active learning queries, confidence displays

### M3: Transfer Learning Across Papers Not Analyzed

The paper documents one paper's journey through 8+ rounds, but the panel *system* has reviewed 14 papers across 3 modules (mentioned in introduction). Has the panel gotten better at reviewing over time? Do early papers require more rounds than later papers? Can insights from one paper transfer to others?

**Critical for generalization**: If each paper requires 8+ independent rounds, panel-driven research is expensive. But if the system learns—recognizing common issues, adapting questioning strategies, transferring domain knowledge—then early investment pays off across the portfolio.

**Required changes**:
- Add analysis: Do later papers in the portfolio require fewer rounds to reach quality thresholds?
- Discuss: Can the panel transfer learning from one paper to others? (E.g., "papers on redistricting often lack hypothesis clarity")
- Future work: Implement transfer learning so panel improves over time, reducing per-paper iteration costs

## Minor Issues

### m1: Iteration Cost Not Justified Without Learning

The paper notes 8+ rounds for panel-driven vs. 1-2 for traditional, but never discusses whether this cost is justified. In interactive ML, iteration cost is acceptable if the *model* improves. Here, the *paper* improves, but the *system* doesn't learn. Without system learning, every future paper requires 8+ rounds—that's prohibitively expensive.

**Suggestion**: Add cost-benefit analysis discussing when iteration investment is worthwhile. Argue either: (1) quality improvement justifies per-paper cost, or (2) system learning amortizes cost across portfolio.

### m2: Active Learning Not Leveraged

In interactive ML, active learning identifies high-value feedback requests—"which label would most improve the model?" The panel asks questions, but there's no evidence of strategic question selection. Does the panel prioritize high-impact feedback (theory building, experimental design) over low-impact (presentation, formatting)? Or are questions generic?

**Suggestion**: Discuss how panel could leverage active learning to prioritize high-value feedback. E.g., identify biggest quality gaps and focus questions there.

### m3: Feedback Loop Diagram Missing

The paper describes an iterative process (review → revise → review), but lacks a clear diagram showing information flow. For CHI/CSCW audiences, a visual representation would clarify: Who provides feedback to whom? What gets updated? Where do learning opportunities exist?

**Suggestion**: Add Figure (Section 3 or 5): Feedback loop diagram showing panel → Claude → paper → panel, with annotations for where learning *could* occur (panel adapts, Claude learns, user trains).

## Strengths

1. **Iterative refinement**: The 8-round cycle with adaptive exploration mirrors interactive ML workflows. The paper's strength is documenting how iteration drives quality, even if system learning is absent.

2. **Mechanistic analysis**: Four mechanisms (systematic questioning, embracing negatives, standards elevation, iteration forcing) are well-articulated and actionable. These generalize beyond AI research to other iterative feedback domains.

3. **Process tracing**: Git commits and session notes provide evidence for iteration effectiveness. The Alabama example (Section 4.3) shows how multiple rounds transform failure investigation from notation to exploration.

4. **Role dynamics**: The observation that user value shifts from direction to domain expertise is important. This suggests complementarity—users provide expertise the system lacks (domain knowledge), while the system provides expertise users lack (systematic review).

5. **Honest limitations**: Acknowledging single-user, single-domain, and N=1 limitations shows appropriate epistemic humility. More discussion of learning gaps would strengthen this.

## Questions for Authors

1. **System learning**: Does the panel adapt based on prior rounds? E.g., recognizing "we tried n-way partitioning in round 2 and it failed" to avoid redundant suggestions?

2. **Transfer learning**: Has the panel improved across the 14-paper portfolio? Do later papers require fewer rounds?

3. **User feedback**: How do users currently provide feedback on panel behavior? Is it implicit (through revisions) or explicit (ratings, corrections)?

4. **Active learning**: Does the panel prioritize high-impact feedback (methodology, experimental design) or ask generic questions?

5. **Learning opportunities**: Where in the feedback loop could learning occur? (Panel adapts questioning, Claude learns from revisions, user trains system on domain preferences)

## Recommendations

- **Add system learning analysis** showing whether panel/Claude improve over time (Section 5 or 6)
- **Design user feedback affordances** for correcting panel behavior and providing preferences
- **Analyze transfer learning** across the 14-paper portfolio
- **Add feedback loop diagram** visualizing information flow and learning opportunities
- **Compare to interactive ML** frameworks emphasizing learning from feedback

---

**Verdict**: Accept with Revisions

**Confidence**: High — Interactive ML and HITL systems are my core expertise. I'm confident about learning and feedback mechanisms, though less familiar with computational redistricting specifics.

---

> **AI Simulation Disclosure**: This review was generated by a large language model
> (Claude, Anthropic) simulating the perspective of the named reviewer. The named
> individual did **not** write or endorse this review. The AI persona is informed by
> the reviewer's published work, known research priorities, and public scholarship,
> but the opinions expressed are synthetic outputs, not the actual views of the
> named researcher. This process is used for pre-submission quality improvement and
> does not represent a real peer review.
