# Review: From Reviews to Revisions: Closed-Loop Automation of Academic Paper Improvement

**Reviewer**: Michael Bernstein (Stanford University)
**Expertise**: Crowdsourcing, Human Computation, Collaborative Systems
**Round**: 1
**Date**: 2026-02-07

---

## Overall Assessment

This paper makes an interesting contribution to automated writing assistance, but it misses a critical opportunity to leverage human computation insights. The authors present a fully automated pipeline (synthesis → planning → execution), but decades of crowdsourcing research show that **hybrid human-AI workflows often outperform pure automation**. The paper would be significantly stronger if it explored mixed-initiative designs or crowd-in-the-loop validation.

The empirical results are impressive (78% P1 completion, 94% acceptance), but these numbers mask important questions: What about the 22% that couldn't be automated? How do we handle disagreements between automated edits and author preferences? The paper treats these as edge cases, but they're actually the **design space** where human computation could add value.

The comparison to crowd workflows is superficial (one paragraph in Related Work). Given that both systems decompose complex tasks (paper revision / microtasks) and coordinate multiple agents (reviewers / crowd workers), a deeper analysis would strengthen the contribution.

## Score

**Score**: 2/4 — Weak Accept (Major Revisions Required)

## Major Issues (Blocking)

### M1: Missing Comparison to Crowd-Based Revision Workflows

The paper claims closed-loop automation reduces revision time by 64%, but doesn't compare to crowd-based alternatives. For example:
- **Crowd proofreading**: Services like Upwork or Scribbr provide human editing with 24-hour turnaround
- **Peer revision systems**: Platforms like Coauthor or Overleaf collaborative editing
- **Hybrid workflows**: Crowd workers validate automated edits before author review

**Required addition**: Add a subsection in Related Work (or Discussion) titled "Comparison to Crowd-Based Revision" that addresses:
- How does closed-loop automation compare to hiring a professional editor (cost, time, quality)?
- Could crowd workers validate automated edits to improve the 94% acceptance rate?
- What tasks are better suited for automation vs. crowd workers?

This comparison is essential for CHI/CSCW audiences who understand crowd workflows deeply.

### M2: No Analysis of Disagreement Resolution

The paper reports 2% rejection rate (Table 5) but doesn't analyze *why* authors rejected edits or how the system should handle disagreements. In crowdsourcing, disagreement is **signal** (indicates ambiguity, subjective preferences, or task complexity). Here, it's treated as failure.

**Required evidence**:
- Qualitative analysis of rejected edits: What patterns emerge? Were rejections due to domain-specific terminology, subjective style, or errors in edit localization?
- Disagreement between reviewers: Do automated edits sometimes satisfy Reviewer A but contradict Reviewer B? How does the system resolve this?
- Author expertise: Do expert authors reject more edits than novice authors?

This analysis would reveal the boundaries of automation and inform future mixed-initiative designs.

### M3: Insufficient Discussion of Human-AI Task Allocation

The paper assumes a binary model: either the system automates an edit (78%) or flags it for humans (22%). But crowdsourcing research shows that **task allocation** is more nuanced. Some tasks benefit from AI assistance + human validation, not pure automation.

**Needed**: A subsection in Discussion titled "Task Allocation: When to Automate vs. When to Involve Humans" that proposes a taxonomy:
- **Fully automatable**: Typo fixes, citation formatting (current P1 items)
- **AI-assisted**: Complex phrasing changes where AI proposes, human approves
- **Human-led**: Structural changes, content expansion (current "requires human judgment" items)
- **Hybrid validation**: AI applies edits, crowd workers validate before author review

This taxonomy would be a valuable contribution for CSCW, showing how insights from human computation apply to automated writing.

## Minor Issues

### m1: Lack of Author Experience Data

The paper measures *efficiency* (time reduction) but not *experience* (satisfaction, trust, sense of control). In crowdsourcing, we've learned that worker satisfaction matters for quality and retention. Here, author experience likely affects edit acceptance and willingness to use the system.

**Suggested addition**: Brief survey or interview with authors asking:
- Do you feel you maintained authorial control over the revision process?
- How much do you trust the automated edits?
- Would you use this system for future papers?

Even 5 qualitative responses would enrich the Discussion.

### m2: Missing Cost Analysis

The paper compares time (8.2 hrs → 2.9 hrs) but not cost. For a fair comparison to crowd-based alternatives:
- What's the computational cost (API calls to Claude)?
- What's the dollar cost per paper?
- How does this compare to hiring a professional editor (~$500-$1000 per paper)?

A brief cost analysis in Discussion would help readers assess practical viability.

### m3: Limited Generalization Beyond LaTeX

The paper claims the system generalizes to "code refactoring, legal document editing, technical specifications" (lines 52-53), but the evaluation is entirely LaTeX papers. LaTeX has well-defined syntax and structure, making it easier to automate than, say, legal documents (complex dependencies, ambiguous language) or code refactoring (semantic correctness).

**Recommendation**: Either remove the generalization claim or add a paragraph discussing the specific properties of LaTeX that make it amenable to automation (structured syntax, localized edits, compilation-based validation) and how these properties may not hold for other domains.

## Strengths

1. **Clear decomposition**: The three-phase pipeline (synthesis → planning → execution) is well-designed and reusable.
2. **Honest reporting**: The paper openly discusses failure modes (9% compilation errors, 22% items requiring human judgment).
3. **Large-scale evaluation**: 14 papers, 33 cycles — this is solid evidence.
4. **Practical system**: The integration with Claude Code plugin makes this usable by others.

## Questions for Authors

1. Did you consider hybrid workflows where crowd workers validate automated edits before author review? How would this affect acceptance rates and edit quality?

2. For the 22% of P1 items requiring human judgment, could crowd workers handle some of these tasks (e.g., "expand related work with 3+ new citations" could be outsourced to a crowd worker familiar with the domain)?

3. How does the system handle conflicting reviewer feedback? For example, if Reviewer A says "add more detail" and Reviewer B says "be more concise", how does the automated edit resolve this?

4. Have you considered a mixed-initiative interface where authors specify preferences (e.g., "I prefer formal tone" or "avoid jargon") and the system adapts edits accordingly?

## Recommendations

- **Compare to crowd workflows**: Show how closed-loop automation compares (time, cost, quality) to hiring professional editors or using crowd-based revision services
- **Analyze disagreements**: Treat rejections and conflicts as signal, not noise — what do they reveal about task boundaries?
- **Propose hybrid designs**: Discuss how crowd-in-the-loop validation could improve acceptance rates or handle the 22% of items requiring judgment
- **Add author experience data**: Brief qualitative findings on satisfaction, trust, and sense of control

---

**Verdict**: Major Revisions Required

**Confidence**: High — This paper sits at the intersection of human computation and AI-assisted writing, squarely in my area of expertise. The technical contribution is solid, but the framing misses key opportunities to connect to crowdsourcing insights.

---

> **AI Simulation Disclosure**: This review was generated by a large language model
> (Claude, Anthropic) simulating the perspective of the named reviewer. The named
> individual did **not** write or endorse this review. The AI persona is informed by
> the reviewer's published work, known research priorities, and public scholarship,
> but the opinions expressed are synthetic outputs, not the actual views of the
> named researcher. This process is used for pre-submission quality improvement and
> does not represent a real peer review.
