# Review: Hierarchical Review Architecture: Scaling Expert Feedback Through Three-Tier Synthesis

**Reviewer**: Shreya Shankar (UC Berkeley)
**Expertise**: ML ops, observability, testing pipelines, production ML systems
**Round**: 1
**Date**: 2026-02-07

---

## Overall Assessment

This paper presents a three-tier hierarchical architecture for AI-simulated expert reviews. As someone who works on ML ops and production systems, my first question is: *how do you debug this?* The system has three layers of AI-generated content (reviews → synthesis → panel → board), each producing prioritized issue lists that propagate bidirectionally. When something goes wrong — a spurious P1 item, a missed critical issue, a bad emergent pattern — how do you trace it back to the source?

The architecture is conceptually sound, and I like the explicit state management (_panel.yaml), stage gates, and round tracking. But the paper treats this as a research contribution without sufficient attention to operational concerns:

1. **Observability**: How do you monitor review quality? Are there metrics, dashboards, anomaly detection?
2. **Testing**: How do you test the system before deploying it on real papers? Are there regression tests?
3. **Debugging**: When a review is wrong, how do you trace the issue? Is there logging, provenance tracking?
4. **Reliability**: What's the failure rate? How do you handle API errors, model updates, rate limits?
5. **Data quality**: How do you ensure reviewer personas are consistent? Do they drift over time?

Without addressing these, the system is a research prototype, not a production-ready tool. For a venue like ICSE/FSE, which cares about software engineering practices, this needs more operational rigor.

That said, the core ideas are good. The stage machine is well-designed, the priority escalation makes sense, and the evaluation shows the system works in controlled conditions. I'd accept this with major revisions focused on operationalization.

## Score

**Score**: 2/4 — Weak Accept

Good research ideas, but insufficient attention to production concerns for a software engineering venue. Needs observability, testing, and debugging infrastructure.

## Major Issues (Blocking)

### M1: No Observability or Monitoring

The paper describes what the system does but not how you observe it working correctly. In production ML systems, you need:

- **Metrics**: What do you track? (review completion rate, consensus score distribution, P1 item frequency, etc.)
- **Dashboards**: How do users monitor system health? Are there alerts for anomalies?
- **Quality checks**: How do you detect when a reviewer is giving low-quality feedback? When synthesis misclassifies priorities?
- **Drift detection**: Do reviewer personas stay consistent over time? How do you detect when a model update changes behavior?

Without observability, you can't tell if the system is working correctly or degrading. This is especially critical for emergent patterns — if the panel flags a "cross-paper pattern," how do you know it's real and not a hallucination?

**Recommended action**: Add an observability section:
- Define key metrics for system health (review quality, consensus, priority distribution)
- Describe how metrics are tracked and visualized (logs, dashboards, alerts)
- Implement quality checks: flag reviews with outlier scores, detect when synthesis classifications are inconsistent with individual reviews
- Add regression detection: compare metrics over time to catch degradation

Even better: show example dashboards or monitoring outputs from your deployed system.

### M2: No Testing or Validation Strategy

How do you test this system before using it on real papers? The evaluation section shows it works on 14 papers, but:

- **Unit tests**: Are there tests for each stage handler (draft → panel, panel → synthesis, etc.)?
- **Integration tests**: Do you test the full pipeline (draft → accepted) on synthetic papers?
- **Regression tests**: When you update a prompt or reviewer persona, how do you ensure you didn't break existing functionality?
- **Golden datasets**: Do you have reference papers with known-good reviews to validate against?

Production ML systems need test suites. Without them, every change risks breaking something, and you can't confidently deploy updates.

**Recommended action**: Add a testing section:
- Describe unit tests for each stage (e.g., test that synthesis correctly identifies P1 items from reviews)
- Describe integration tests for full lifecycle
- Create a golden dataset of 5-10 papers with manually validated reviews, use as regression suite
- Show test coverage: what % of code is tested?

### M3: Debugging and Provenance Tracking Are Missing

When something goes wrong, how do you debug it? Likely issues:

- **Spurious P1 item**: A review flags a non-issue as blocking → how do you trace which reviewer and why?
- **Missed critical issue**: No reviewer identifies a fundamental flaw → how do you audit what went wrong?
- **Bad emergent pattern**: Panel claims "cross-paper pattern" that doesn't exist → how do you inspect the pattern detection logic?
- **Conflicting priorities**: Paper says P1, panel says P3 → how do you reconcile?

The paper mentions provenance ("which reviews contributed to this PP1 item?") but doesn't implement it. For a production system, you need:

- **Logging**: Detailed logs at each stage (review generation, synthesis, priority classification)
- **Provenance**: Track which reviews/reviewers contributed to each priority item
- **Replay**: Re-run synthesis on the same reviews to verify reproducibility
- **Inspection tools**: View intermediate outputs (pre-synthesis reviews, draft priority classifications)

**Recommended action**: Add debugging infrastructure:
- Implement structured logging at each stage with trace IDs for end-to-end tracking
- Build provenance tracking: every P1/PP1/B1 item links back to source reviews and reviewers
- Add inspection commands: `panel:inspect <paper>` shows all intermediate artifacts
- Document debugging workflows: "If you see a bad P1 item, here's how to trace it"

## Minor Issues

### m1: Reliability and Error Handling Not Discussed

What happens when the system fails? Likely failures:

- **API errors**: LLM API is down or rate-limited → does the system retry? Queue? Fail gracefully?
- **Malformed output**: AI generates invalid YAML or markdown → how is this caught?
- **Stage gate deadlock**: Paper can't advance because one gate never passes → is there a timeout or manual override?
- **State corruption**: _panel.yaml gets corrupted or manually edited incorrectly → how is this detected?

**Suggestion**: Add error handling section:
- Describe retry/backoff strategy for API calls
- Implement output validation: parse and schema-check all AI-generated content
- Add manual override mechanisms for stuck stages
- Implement state validation: check _panel.yaml for consistency on every load

### m2: No Discussion of Cost and Performance

How expensive is this system? How long does it take? For production use, you need:

- **Cost**: How much does it cost (in API calls) to review one paper at all three tiers?
- **Latency**: How long does each stage take? Is synthesis the bottleneck?
- **Throughput**: How many papers can you process concurrently? Is there a queue?
- **Optimization**: Are there opportunities to cache, batch, or parallelize?

**Suggestion**: Add performance section:
- Report cost per paper (e.g., "~$5 for 5 reviewers + synthesis")
- Report latency per stage (e.g., "review generation: 2 min, synthesis: 30 sec")
- Discuss scalability: how does cost/latency scale with papers/modules?
- Propose optimizations: caching reviewer personas, batching API calls, parallel review generation

### m3: Data Management and Versioning Are Unclear

The system produces lots of artifacts (REVIEW-*.md, SYNTHESIS.md, _panel.yaml). How do you manage these?

- **Versioning**: Are reviews immutable? If you regenerate, do you overwrite or version?
- **Storage**: Where are artifacts stored? Local disk? Git? Database?
- **Synchronization**: If multiple users work on the same paper, how do you prevent conflicts?
- **Archival**: How do you archive completed reviews? Are they kept forever?

The paper mentions git-helper.md but doesn't describe the data management strategy.

**Suggestion**: Add data management section:
- Describe storage backend (git-based, file-based, etc.)
- Explain versioning strategy (immutable reviews vs. in-place updates)
- Document synchronization mechanisms for multi-user scenarios
- Describe archival policy (what's kept, what's deleted, when)

### m4: Reviewer Persona Consistency Not Validated

The system uses "AI personas" (Percy Liang, Ben Shneiderman, etc.) to generate reviews. But do these personas stay consistent?

- **Within a round**: If you regenerate a Percy Liang review, does it say the same things?
- **Across rounds**: Does Percy Liang in Round 2 remember what he said in Round 1?
- **Across papers**: Does Percy Liang's "voice" stay consistent across different papers?

Without consistency validation, the personas might drift, making the system unpredictable.

**Suggestion**: Add persona consistency evaluation:
- Test regeneration: generate the same review 5 times, measure similarity (BLEU, ROUGE, semantic similarity)
- Test round consistency: compare Round 1 and Round 2 reviews from the same reviewer
- Test cross-paper consistency: compare the same reviewer on 5 different papers
- Report consistency metrics (e.g., "reviewers are 85% consistent across regenerations")

## Strengths

1. **Explicit state management**: _panel.yaml tracks all lifecycle state, making the system re-entrant and debuggable.

2. **Stage gates prevent invalid transitions**: The stage machine won't advance until gates pass, ensuring quality thresholds are met.

3. **Round tracking is well-designed**: Separate directories for each round (panel-reviews/round-1/, board-reviews/round-2/) make history clear.

4. **Practical deployment**: The system has been implemented and used on real papers, showing it's feasible.

5. **Modular design**: Shared utilities (stage-machine.md, synthesis-engine.md, reviewer-selector.md) make the system maintainable.

## Questions for Authors

1. Have you run this system in production with multiple users? What operational issues have you encountered?

2. How do you handle model updates? If Claude Opus 5 is released, does reviewer behavior change?

3. What's the false positive rate for emergent patterns? How often does the panel flag patterns that turn out to be spurious?

4. Do you have monitoring/alerting for the deployed system? What do you track?

5. What's the cost breakdown? How much of the total cost is review generation vs. synthesis?

6. How do you ensure reproducibility? If you rerun the same paper through the system, do you get the same reviews?

## Recommendations

- **Add observability infrastructure**: Metrics, dashboards, quality checks, drift detection.
- **Implement testing strategy**: Unit tests, integration tests, regression suite, golden datasets.
- **Build debugging tools**: Logging, provenance tracking, inspection commands, replay capability.
- **Address reliability**: Error handling, retry logic, graceful degradation, state validation.
- **Document cost and performance**: Report cost per paper, latency per stage, scalability analysis.
- **Validate persona consistency**: Test that reviewers behave predictably across regenerations, rounds, papers.

---

**Overall verdict**: This is interesting research on hierarchical review synthesis, but it needs more operational rigor for a software engineering venue. The architecture is sound, but production concerns (observability, testing, debugging, reliability) are insufficiently addressed. With these additions, this could be a strong contribution.

---

> **AI Simulation Disclosure**: This review was generated by an AI system (Claude, Anthropic)
> simulating the perspective of Shreya Shankar based on her work on ML observability, testing,
> and production ML systems. Shreya Shankar did not write this review and has no involvement
> with this work. This is a synthetic artifact for testing the hierarchical review system
> described in the paper.
