# Review: Panel-Driven Research Quality Impact

**Reviewer**: Ece Kamar (Microsoft Research)
**Expertise**: Complementarity, deferral, human-AI systems
**Round**: 1
**Date**: 2026-02-07

---

## Overall Assessment

This paper tackles an important question about human-AI complementarity in research: when should humans direct AI, and when should AI drive with human facilitation? The framing around role dynamics is excellent, and the +127% quality improvement suggests panel-driven workflows may achieve better complementarity than traditional user-directed approaches. The four mechanisms identified (systematic questioning, embracing negatives, standards elevation, iteration forcing) provide actionable insights for designing human-AI research systems.

However, the paper misses a critical analysis: **when should the system defer to the human vs. proceed autonomously?** Complementarity literature shows that optimal human-AI teams adaptively allocate decisions based on confidence, expertise, and task characteristics. The panel-driven paradigm seems to allocate decision-making statically—panel always drives scientific direction, user always facilitates—without adaptation. What if the panel drives exploration in the wrong direction? When should the user override?

The edge-weighting breakthrough is illustrative: the user intervened at round 5 with a critical domain insight after panel-driven exploration stalled at Alabama 49.6%. This suggests **complementarity worked**, but the paper doesn't analyze *when* and *why* user intervention was needed. Was it because Claude exhausted algorithmic alternatives? Because domain knowledge was required? Because the panel's questions triggered a user insight? Understanding these deferral conditions is essential for generalizing the workflow.

I'm also concerned about **single-user evidence**. The author produced the panel system, has software engineering expertise, and successfully identified when to intervene with domain insights. Would users without this expertise recognize intervention moments? The paper claims panel-driven workflows "lower expertise thresholds," but evidence comes from an expert user. Complementarity may require both parties to have sufficient capability.

## Score

**Score**: 3/4 — Accept (with revisions)

## Major Issues (Blocking)

### M1: Deferral Conditions Not Analyzed

The paper describes role dynamics (user as facilitator, panel as driver) but doesn't analyze **when the system should defer to the human**. Complementarity literature emphasizes adaptive allocation: in some contexts, AI should lead; in others, humans should lead. The panel-driven workflow seems static—panel always drives—without deferral logic.

**Critical example**: Edge-weighting breakthrough (Section 4.4). The user intervened at round 5 with a domain insight after Claude exhausted algorithmic alternatives. This was the *right moment* to defer, but the paper doesn't explain:
- What triggered user intervention? (Panel question? Claude stalling? User's own realization?)
- Could the system have requested user input earlier? Later?
- Would a less expert user have recognized this intervention point?

**Required changes**:
- Add subsection (Section 5.2 or new 5.3): "Deferral Conditions in Panel-Driven Research"
- Analyze edge-weighting example: Why was round 5 the right moment for user intervention?
- Identify deferral triggers: When should panel request user input vs. continue autonomous exploration?
- Discuss: Can deferral be automated (confidence thresholds, exploration termination conditions) or must users self-initiate?
- Relate to complementarity literature: Wilder et al. (learning to defer), Madras et al. (predict-then-defer)

### M2: Complementarity May Require Expert Users

The paper claims panel-driven workflows "enable users without deep research backgrounds to produce rigorous work" (conclusion, page 21), but the evidence comes from the **author**—who has software engineering expertise, produced the panel system, and successfully provided domain insights at critical junctures. This is a **significant generalizability gap**.

**Concern**: Complementarity works when both parties have sufficient capability. The author could:
- Recognize when Claude exhausted algorithmic alternatives (round 5)
- Translate VRA requirements into edge-weighting strategy (domain expertise)
- Debug METIS errors (technical facilitation)

Would a user without software engineering background successfully facilitate? Would a user without redistricting domain knowledge provide the edge-weighting insight?

**Required changes**:
- Acknowledge expert-user confound explicitly in limitations
- Reframe claims: "Panel-driven workflows shift expertise requirements from research methodology to domain knowledge and technical facilitation"
- Discuss: What capabilities must users possess for complementarity to work? (Not "no expertise," but *different* expertise)
- Future work: Multi-user study varying expertise levels (novice, domain expert, methodology expert, both)

### M3: Innovation Attribution Ignores Complementarity

The paper attributes the edge-weighting breakthrough to the panel ("primary driver") with user "facilitation," but this undersells complementarity. The breakthrough required **essential contributions from both**:
- Panel: Systematic exploration exposing multi-constraint limitations (rounds 1-4)
- Claude: Implementing and testing alternatives (n-way, adaptive, tree variations)
- User: Domain insight translating VRA preservation into graph topology (round 5)

No single party could have achieved the breakthrough alone. This is **textbook complementarity**—each party contributes what they're best at. But the paper frames it as panel primacy with user support.

**Required changes**:
- Reframe Section 4.4 and 5.2: Edge-weighting as "complementary innovation" rather than "panel-driven innovation"
- Add Figure: Innovation dependency graph showing essential contributions from panel, Claude, and user
- Discuss: Which breakthroughs require complementarity vs. achievable by single party (panel or user)?
- Relate to complementarity theory: Division of cognitive labor, comparative advantage

## Minor Issues

### m1: Quality Improvement May Reflect Complementarity, Not Panel Superiority

The +127% quality improvement is attributed to panel-driven methodology, but an alternative interpretation is **better complementarity**. Panel-driven work had:
- Panel providing systematic questioning (AI strength: tireless exploration)
- User providing domain insights (human strength: transfer from related knowledge)
- Claude executing experiments (AI strength: rapid implementation)

Traditional work had only user + Claude (missing systematic review), so complementarity was worse. The improvement may be from *adding a third party* (panel) rather than *changing who directs* (user → panel).

**Suggestion**: Reframe Discussion (Section 5.1) to emphasize complementarity—each party contributes unique strengths—rather than panel superiority. Discuss: Would adding a human expert reviewer achieve similar gains?

### m2: Confidence-Based Deferral Not Discussed

In human-AI systems, confidence scores often determine when to defer. High AI confidence → proceed autonomously; low AI confidence → request human input. Did Claude or the panel exhibit confidence signals that could have triggered user intervention earlier?

**Example**: After round 4, Claude had tested 6 tree structures, 3 partitioning methods, and constraint relaxation—all failing to exceed 49.6%. This exhaustive exploration suggests low confidence in remaining algorithmic alternatives. Could this signal have prompted user input earlier?

**Suggestion**: Add paragraph discussing confidence-based deferral in panel-driven research. Could Claude's exhaustive exploration failures trigger user input requests?

### m3: User Burden Analysis Missing

The paper notes panel-driven work required 8+ rounds vs. 1-2 for traditional, but never quantifies **user burden**. If the user must monitor 8+ rounds, respond to panel questions, and provide insights at critical junctures, is this more or less burdensome than directing 1-2 rounds?

Complementarity aims to reduce *total* burden (human + AI), not just shift it. If panel-driven workflows require 10x time investment, that's a cost worth discussing.

**Suggestion**: Add subsection quantifying time costs for user (monitoring, intervention, facilitation) and discussing burden tradeoffs.

## Strengths

1. **Role dynamics analysis**: Section 5.2 characterizing user role shift (director → facilitator) and identifying when domain expertise matters is excellent. This generalizes beyond AI research to other human-AI collaboration domains.

2. **Mechanistic insights**: Four mechanisms (systematic questioning, embracing negatives, standards elevation, iteration forcing) are clearly articulated and actionable. These explain *how* panel review improves quality, not just *that* it does.

3. **Within-project design**: Comparing papers from the same project controls for confounds admirably. While N=1 limits statistical inference, the design is rigorous for a pilot study.

4. **Process tracing**: Git commits and session notes provide grounding for role dynamics claims. The Alabama example beautifully illustrates when user intervention mattered.

5. **Honest limitations**: Acknowledging single-user, single-domain, and expert-user confounds is commendable. More discussion of complementarity implications would strengthen this.

## Questions for Authors

1. **Deferral triggers**: What signals (panel questions, Claude stalling, user intuition) prompted the edge-weighting insight? Could these be automated?

2. **Expertise requirements**: What minimum capabilities must users possess for complementarity to work? Domain knowledge? Technical facilitation? Research methodology?

3. **Confidence indicators**: Did Claude or the panel exhibit low-confidence signals (exhaustive exploration failures, hedging language) that could have triggered earlier user intervention?

4. **Human comparison**: Would adding a human expert reviewer achieve similar quality gains as the AI panel? Or does AI enable more systematic, tireless questioning?

5. **Burden quantification**: How much time did panel-driven work require from the user (monitoring, intervention, facilitation) compared to traditional?

## Recommendations

- **Add deferral analysis** explaining when and why user intervention matters (Section 5.2 or new 5.3)
- **Reframe as complementarity** rather than panel superiority—each party contributes unique strengths
- **Acknowledge expert-user confound** and discuss what capabilities users need for complementarity
- **Discuss confidence-based deferral** as mechanism for adaptive allocation
- **Quantify user burden** to assess total cost (human + AI time) of panel-driven workflows

---

**Verdict**: Accept with Revisions

**Confidence**: High — Complementarity and human-AI systems are my core expertise. I'm confident about deferral analysis and role dynamics, though less familiar with computational redistricting specifics.

---

> **AI Simulation Disclosure**: This review was generated by a large language model
> (Claude, Anthropic) simulating the perspective of the named reviewer. The named
> individual did **not** write or endorse this review. The AI persona is informed by
> the reviewer's published work, known research priorities, and public scholarship,
> but the opinions expressed are synthetic outputs, not the actual views of the
> named researcher. This process is used for pre-submission quality improvement and
> does not represent a real peer review.
