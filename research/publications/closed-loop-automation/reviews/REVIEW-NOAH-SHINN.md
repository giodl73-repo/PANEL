# Review: From Reviews to Revisions: Closed-Loop Automation of Academic Paper Improvement

**Reviewer**: Noah Shinn (Princeton University)
**Expertise**: Reflexion, Self-Improvement, Agent Learning
**Round**: 1
**Date**: 2026-02-07

---

## Overall Assessment

This paper presents a functional closed-loop system for paper revision, but it's missing the key ingredient that would make it truly "closed-loop": **self-improvement through reflection on its own outputs**. The system iterates through review cycles, but it doesn't *learn* from mistakes, adapt its revision strategy based on reviewer feedback, or reflect on why certain edits failed.

In Reflexion work, we showed that agents improve by maintaining a memory of past failures and using that memory to adjust future actions. This paper has all the infrastructure for self-improvement (multiple rounds, success/failure signals, edit history) but **doesn't exploit it**. The system applies the same synthesis → planning → execution strategy in round 2 as in round 1, ignoring what it learned from round 1.

The paper would be significantly stronger if it framed the contribution as: "We built a self-improving revision agent that learns from reviewer feedback across rounds, using reflection to refine its edit strategy." Right now, it's an impressive engineering artifact but not an agent that improves itself.

## Score

**Score**: 3/4 — Accept (Minor Revisions Required)

## Major Issues (Blocking)

### M1: No Reflection or Learning Between Rounds

The system goes through multiple rounds (Table 7: 86% converge by round 2), but **there's no reflection mechanism** to learn from round N when generating round N+1 edits. For example:
- Round 1: System applies edit changing "novel" to "extends prior work"
- Round 2 reviewers: "The related work section is still too brief"
- Round 2 system: Does it recognize that the round 1 edit was insufficient? Does it adjust its strategy (e.g., "I need to be more aggressive in expanding related work")?

**Required addition**: Add a subsection in Methodology titled "Reflection and Strategy Adjustment" that describes:
- What the system learns from round N feedback
- How it adjusts its revision strategy for round N+1 (e.g., "prioritize edits that address issues flagged in both rounds")
- Whether it maintains a memory of past edits and their reviewer reception

If the system doesn't currently do this, add it to Discussion or Future Work with a concrete design: "In future work, the system should maintain a reflection log mapping edits → reviewer responses → adjustments."

### M2: Missing Error Analysis and Self-Diagnosis

The paper reports that 22% of P1 items require human judgment (Table 2) but doesn't analyze **why the system couldn't automate them**. A self-improving system would:
1. Identify failure patterns (e.g., "I fail on structural changes" or "I fail when reviewers disagree")
2. Build a model of its own capabilities (e.g., "I'm good at phrase replacement, bad at content expansion")
3. Use this model to improve future planning (e.g., "Flag content expansion items as low-confidence early")

**Needed**: Add a subsection in Results or Discussion titled "Self-Diagnosis of Failure Modes" that:
- Categorizes the 22% of items requiring human judgment (you have Table 8, but need analysis)
- Analyzes whether the system could predict upfront which items it will fail on (based on edit type, reviewer consensus, section of paper)
- Discusses how this self-diagnosis could inform future planning

This would transform the paper from "we built a tool" to "we built an agent that understands its own limitations."

## Minor Issues

### m1: Lack of Meta-Cognitive Prompting

In Reflexion, we use explicit prompts like "Reflect on your previous attempt. What went wrong? How will you adjust?" This paper doesn't describe whether the system uses any meta-cognitive prompting during revision planning.

**Question for authors**: Does the planning phase (Phase 2, Section 3.2) include prompts like:
- "Reviewer A flagged issue X in round 1. It was addressed but Reviewer A still mentions it in round 2. What additional changes are needed?"
- "Edit Y was applied in round 1 but rolled back due to compilation error. What alternative approach would succeed?"

If yes, describe this in Methodology. If no, add to Future Work as "meta-cognitive prompting for revision strategy."

### m2: No Explicit Success/Failure Memory

The system tracks edit completion in `_panel.yaml` (line 143), but it's unclear if this memory is used for future decisions. In Reflexion:
- Memory = past trajectories (action → outcome → reflection)
- Future actions conditioned on memory ("I tried X, it failed because Y, so now I'll try Z")

Does `_panel.yaml` serve this role? Or is it just bookkeeping?

**Suggested clarification**: In Implementation (Section 3.6), explain how `_panel.yaml` is used:
- Is it just for tracking completion status?
- Or does the system read it to inform future revision strategy?

### m3: Limited Comparison to Self-Improving Agents

The Related Work section doesn't mention Reflexion, ReAct with reflection, or other self-improving agent architectures. Given that this paper is about closing the loop (review → revise → re-review → revise again), comparisons to these methods would strengthen the positioning.

**Suggested addition**: Add 1-2 paragraphs to Related Work (Section 2) discussing self-improving agents:
- Reflexion: agents that reflect on failures and adjust strategy
- ReAct with reflection: agents that reason about past actions
- LATS (Language Agent Tree Search): agents that backtrack and explore alternatives

Then explain how this paper relates: "Unlike Reflexion, our system does not yet maintain explicit reflection logs, but the infrastructure (multi-round iteration, success/failure signals) supports future extensions in this direction."

## Strengths

1. **Strong empirical results**: 78% P1 completion, 94% acceptance — this system works.
2. **Multi-round iteration**: The system supports iterative refinement, which is the foundation for self-improvement.
3. **Comprehensive evaluation**: 14 papers, 33 cycles — solid evidence.
4. **Clear architecture**: The three-phase pipeline is well-described and reusable.
5. **Honest failure reporting**: Paper openly discusses items requiring human judgment (22%) and compilation failures (9%).

## Questions for Authors

1. Does the system learn anything from round N when generating round N+1 edits? If yes, what? If no, why not?

2. Could the system predict upfront which P1 items it will fail on (based on edit type, reviewer consensus, etc.) and flag them as low-confidence?

3. Have you considered adding explicit reflection prompts (e.g., "Edit X was rejected. Why? How should you adjust?") to the planning phase?

4. Could the system maintain a "revision strategy log" mapping reviewer feedback → edits → reviewer reception, and use this to improve over time?

5. How does the system handle repeated failures? If an issue appears in round 1, is addressed, but reappears in round 2, does the system recognize this pattern and adjust?

## Recommendations

- **Add reflection mechanism**: Describe how the system learns from round N to improve round N+1 (or add this to Future Work with concrete design)
- **Analyze failure patterns**: Show that the system can self-diagnose which items it will fail on (enabling low-confidence flagging)
- **Compare to self-improving agents**: Add Reflexion, ReAct, LATS to Related Work and position this paper relative to those methods
- **Clarify memory usage**: Explain how `_panel.yaml` informs future decisions (if at all)

---

**Verdict**: Accept with Minor Revisions

**Confidence**: High — This paper is directly related to my work on self-improving agents. The core contribution is solid, but framing it through a reflection/self-improvement lens would make it much stronger.

---

> **AI Simulation Disclosure**: This review was generated by a large language model
> (Claude, Anthropic) simulating the perspective of the named reviewer. The named
> individual did **not** write or endorse this review. The AI persona is informed by
> the reviewer's published work, known research priorities, and public scholarship,
> but the opinions expressed are synthetic outputs, not the actual views of the
> named researcher. This process is used for pre-submission quality improvement and
> does not represent a real peer review.
