# Review: From Reviews to Revisions: Closed-Loop Automation of Academic Paper Improvement

**Reviewer**: Ben Shneiderman (University of Maryland)
**Expertise**: Human-Centered AI, Human Agency, Oversight Systems
**Round**: 1
**Date**: 2026-02-07

---

## Overall Assessment

This paper presents a technically sophisticated system for automating paper revisions from review feedback, but it raises critical questions about human agency and control in the scholarly process. The authors demonstrate impressive automation rates (78% of P1 items, 94% acceptance), but the paper treats automation as an unalloyed good without adequately examining what is lost when revision becomes algorithmic.

The core tension is this: **academic writing is not merely code transformation**. Revision is where authors refine their thinking, discover new connections, and exercise judgment about their contribution. By automating this process, the system may optimize for efficiency while undermining the intellectual growth that comes from engaging deeply with critical feedback.

The paper would be substantially stronger if it framed this as a **human-centered AI system** where automation augments rather than replaces author judgment. The empirical results are solid, but the framing suggests a troubling vision where papers become "self-revising artifacts" rather than products of sustained authorial engagement.

## Score

**Score**: 2/4 — Weak Accept (Major Revisions Required)

## Major Issues (Blocking)

### M1: Insufficient Treatment of Human Agency and Control

The paper celebrates automation without adequately examining the costs. What does it mean for scholarly integrity when 78% of "critical" revisions are applied algorithmically? The 2.9 hours authors spend "reviewing automated edits" suggests a passive role — they are now quality-checking the system rather than actively revising their work.

**Required change**: Add a dedicated subsection (in Discussion) titled "Human Agency in Automated Revision" that addresses:
- When should authors resist automation and engage manually with feedback?
- What revision tasks are *appropriately* automated vs. those that require deep authorial engagement?
- How does the system preserve "meaningful human control" (a core HCAI principle)?

The 94% acceptance rate is presented as success, but it might indicate that authors are deferring too readily to algorithmic suggestions. Where are the tensions? When do authors push back?

### M2: Lack of Comparative Analysis with Manual Revision Quality

The paper shows that automated revision is *efficient* (64% time reduction) but not whether it produces papers of equal *quality* to manual revision. Table 3 shows 94% of edits are accepted, but acceptance rate ≠ quality.

**Required evidence**:
- Compare papers revised manually vs. papers revised with closed-loop automation using blind expert ratings on dimensions like: clarity, coherence, argumentation quality, depth of engagement with feedback
- Or: Compare reviewer scores in Round 2 for manual vs. automated revision paths
- The paper claims "automation does not introduce additional iteration overhead" (line 199), but this only measures convergence time, not final paper quality

Without this comparison, readers cannot assess whether closing the loop sacrifices thoughtfulness for speed.

### M3: Underspecified Limitations and Failure Modes

Section 5 (Discussion) needs a "Limitations and Risks" subsection. The paper mentions compilation failures (9%) and rollback, but doesn't address deeper risks:
- **Over-reliance on automation**: Do authors become less engaged with their own revisions?
- **Homogenization**: Does automation produce formulaic writing (all papers converging to LLM style)?
- **Loss of tacit knowledge**: Revision teaches authors about writing quality. If automation handles this, do authors miss learning opportunities?
- **Adversarial gaming**: Can authors game the system by writing weak drafts and letting automation "fix" them?

These aren't hypothetical — they're predictable consequences of automation that the paper must acknowledge.

## Minor Issues

### m1: Unclear Stakeholder Perspective

The paper primarily centers the system designer's perspective (efficiency, completion rates). It would benefit from foregrounding the **author experience**. How do authors feel about automated revision? Do they trust it? Do they feel they're maintaining authorship, or becoming editors of AI-generated text?

Consider adding quotes from authors (qualitative data) or a brief survey measuring: perceived control, trust in automated edits, satisfaction with the process.

### m2: Missing Discussion of Alternative Interaction Models

The current system is fully automated (apply all edits, then human review). Alternative models could preserve more agency:
- **Stepwise approval**: System proposes edits one-by-one, author approves/rejects/modifies interactively
- **Mixed-initiative**: System flags edits it's confident about vs. edits requiring author input
- **Explanatory interface**: For each edit, system explains *why* (which reviewer, what concern)

Briefly discuss these alternatives in Discussion (or Related Work) and justify why full automation was chosen.

### m3: Venue Appropriateness

The paper targets CHI/CSCW/HCOMP, which emphasize human-centered computing. The current framing (automation-centric) is a poor fit. Reframe as: "We investigate the design space of AI-assisted revision, identifying where automation can safely augment authorial agency and where human judgment must remain central."

This reframing aligns with CHI's values and makes the contribution clearer: not "we automated X%", but "we mapped the boundary between automatable and human-essential revision tasks."

## Strengths

1. **Rigorous empirical evaluation**: 14 papers, 33 cycles, clear metrics — this is solid systems work.
2. **Honest failure analysis**: The paper openly reports compilation failures (9%) and items requiring human judgment (35%).
3. **Generalizable architecture**: The three-phase pipeline (synthesis → planning → execution) could apply beyond academic papers to code review, documentation, legal documents.
4. **Reusable infrastructure**: The system is part of a reusable plugin, making it practical for others to adopt and extend.

## Questions for Authors

1. Did you observe any difference in final paper quality (as measured by reviewer scores, acceptance rates, or author-reported satisfaction) between papers revised manually vs. papers revised with closed-loop automation?

2. How do you envision this system being used ethically? Should conferences allow submission of papers where 78% of revisions were automated? Does this require disclosure?

3. The 22% of P1 items requiring human judgment — can you provide a detailed breakdown of *why* these couldn't be automated? Understanding these boundaries is critical for the contribution.

4. Did any authors express concern about losing control or feeling like they were "editing AI text" rather than revising their own work?

## Recommendations

- **Reframe the contribution**: From "we automated revision" to "we identified the boundary between automatable and human-essential revision tasks, with implications for HCAI design"
- **Add human-centered analysis**: Examine costs (loss of agency, tacit learning) alongside benefits (efficiency)
- **Compare quality**: Show that automated revision produces papers of equal quality to manual revision
- **Foreground author experience**: How does automation affect authors' sense of ownership, control, and intellectual engagement?

---

**Verdict**: Major Revisions Required

**Confidence**: High — This is squarely in my area of expertise (human-centered AI, automation and agency). The technical contribution is solid, but the framing and analysis are insufficient for a human-centered computing venue.

---

> **AI Simulation Disclosure**: This review was generated by a large language model
> (Claude, Anthropic) simulating the perspective of the named reviewer. The named
> individual did **not** write or endorse this review. The AI persona is informed by
> the reviewer's published work, known research priorities, and public scholarship,
> but the opinions expressed are synthetic outputs, not the actual views of the
> named researcher. This process is used for pre-submission quality improvement and
> does not represent a real peer review.
