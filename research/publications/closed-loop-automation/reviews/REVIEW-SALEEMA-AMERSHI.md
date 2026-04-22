# Review: From Reviews to Revisions: Closed-Loop Automation of Academic Paper Improvement

**Reviewer**: Saleema Amershi (Microsoft Research)
**Expertise**: Interactive Machine Learning, Human-in-the-Loop Systems
**Round**: 1
**Date**: 2026-02-07

---

## Overall Assessment

This paper presents a well-executed system for automated paper revision, but it treats human-in-the-loop interaction as an afterthought rather than a first-class design goal. The current design is "human-in-the-loop" only in the minimal sense that authors review final outputs — there's no **active learning** from author feedback, no **personalization** to author preferences, and no **interactive refinement** of edits.

The empirical results are strong (78% P1 completion, 94% acceptance), but the paper misses an opportunity to ask: **What could the system learn from the 6% of edits that were modified or rejected?** In interactive ML, user corrections are training data. Here, they're discarded.

For a CSCW/CHI venue, the paper needs to reframe the contribution through an interactive ML lens: How does the system improve through interaction with authors? How does it adapt to individual author preferences? Without this, the paper is a clever engineering artifact but not a contribution to human-AI interaction.

## Score

**Score**: 2/4 — Weak Accept (Major Revisions Required)

## Major Issues (Blocking)

### M1: No Learning from Author Feedback

The paper reports that 4% of edits are "modified before accepting" and 2% are "rejected" (Table 5), but **the system doesn't learn from these corrections**. This is a fundamental missed opportunity. In interactive ML, user corrections inform future predictions.

**Required addition**: Add a subsection in Discussion titled "Learning from Author Feedback" that addresses:
- How could the system learn from modified/rejected edits to improve future suggestions?
- Could the system build an author preference model (e.g., "Author prefers concise phrasing" or "Author avoids passive voice")?
- What features would enable learning? (edit type, reviewer who suggested it, section of paper, etc.)

Even if learning isn't implemented in this version, the paper should discuss it as future work and explain why it matters for interactive systems.

### M2: Lack of Personalization to Author Preferences

Different authors have different writing styles, domain conventions, and preferences. The current system applies edits uniformly without adapting to individual authors. This is especially problematic for subjective edits (phrasing, tone, terminology).

**Required evidence or discussion**:
- Do authors have consistent patterns in which edits they accept/reject?
- Could the system learn "this author prefers formal tone" or "this author avoids jargon"?
- How would personalization affect acceptance rates?

In interactive ML, personalization is key to user satisfaction. The paper should at least analyze whether authors exhibit consistent preferences (suggesting personalization would help) or inconsistent preferences (suggesting task is inherently subjective).

### M3: Insufficient Analysis of Mixed-Initiative Interaction

The paper presents a **batch processing** model: system applies all edits, then author reviews. But interactive ML systems often use **mixed-initiative** designs where user and AI take turns refining outputs. For paper revision:
- System proposes an edit
- Author approves / rejects / modifies
- System learns from response and proposes next edit

This would give authors more control, reduce the 6% modification/rejection rate, and enable learning.

**Needed**: A subsection in Methodology or Discussion titled "Interaction Models: Batch vs. Mixed-Initiative" that:
- Compares current batch model to mixed-initiative alternatives
- Discusses trade-offs (efficiency vs. control, automation vs. learning)
- Justifies why batch was chosen for this system

Without this analysis, the paper doesn't engage with core HITL design questions.

## Minor Issues

### m1: No Error Analysis of Rejected Edits

Table 5 shows 2% rejection rate, but there's no qualitative analysis of *why* these edits were rejected. Were they:
- Factually incorrect?
- Stylistically inappropriate?
- Domain-specific terminology mismatches?
- Misinterpretations of reviewer feedback?

This error analysis would reveal system limitations and inform future improvements.

### m2: Missing Confidence Scores on Edits

Interactive ML systems often provide confidence scores to help users decide when to trust predictions. The current system doesn't indicate which edits are "safe" vs. "uncertain".

**Suggested addition**: Assign confidence scores to edits (e.g., based on reviewer consensus, edit type, or localization difficulty) and show in REVISION-PLAN.md. This would help authors prioritize review effort: high-confidence edits can be batch-approved, low-confidence edits require careful review.

### m3: Limited Discussion of Active Learning Opportunities

After authors modify/reject edits, the system could ask clarifying questions to understand preferences. For example:
- Author rejects a phrasing change → System: "Do you prefer concise or detailed explanations in methodology sections?"
- Author modifies a citation → System: "Should I prioritize recent papers (2023+) or seminal works (any year)?"

This **active learning** could rapidly personalize the system. Even if not implemented, discussing this in Future Work would strengthen the paper.

## Strengths

1. **Clear system design**: Three-phase pipeline is well-described and reusable.
2. **Comprehensive evaluation**: 14 papers, 33 cycles, detailed metrics — this is solid evidence.
3. **Practical implementation**: Integration with Claude Code makes this usable by real authors.
4. **Honest failure reporting**: Paper openly discusses compilation errors and items requiring human judgment.

## Questions for Authors

1. Did you observe any patterns in which types of edits authors modify or reject? Could these patterns inform a personalization model?

2. Have you considered building an author preference model (e.g., using modified/rejected edits as training data)? How much data would be needed?

3. What would a mixed-initiative version of this system look like? Would it improve edit acceptance rates or author satisfaction?

4. Could the system use active learning (asking authors clarifying questions) to refine its understanding of their preferences?

5. How does the system handle ambiguous reviewer feedback (e.g., "improve clarity")? Does it ever ask authors for clarification before proposing an edit?

## Recommendations

- **Reframe through interactive ML lens**: Emphasize learning from author feedback, personalization, and mixed-initiative interaction
- **Analyze modified/rejected edits**: What do these reveal about task boundaries and author preferences?
- **Discuss confidence scores**: How could the system indicate which edits are safe vs. uncertain?
- **Propose active learning extensions**: How could the system ask clarifying questions to personalize to author preferences?

---

**Verdict**: Major Revisions Required

**Confidence**: High — This is directly in my area (interactive ML, HITL systems). The technical contribution is solid, but the framing needs to engage with interactive ML principles: learning from user feedback, personalization, and mixed-initiative design.

---

> **AI Simulation Disclosure**: This review was generated by a large language model
> (Claude, Anthropic) simulating the perspective of the named reviewer. The named
> individual did **not** write or endorse this review. The AI persona is informed by
> the reviewer's published work, known research priorities, and public scholarship,
> but the opinions expressed are synthetic outputs, not the actual views of the
> named researcher. This process is used for pre-submission quality improvement and
> does not represent a real peer review.
