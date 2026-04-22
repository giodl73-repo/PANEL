# Round 2 Review: Hierarchical Review Architecture: Scaling Expert Feedback Through Three-Tier Synthesis

**Reviewer**: Shreya Shankar (UC Berkeley)
**Expertise**: ML ops, observability, testing pipelines, production ML systems
**Round**: 2
**Date**: 2026-02-07

---

## Overall Assessment

The authors have completely transformed this paper from a research prototype to production-ready systems work. The addition of Section 3.8 (observability and testing) addresses all my operational concerns:

- **15 metrics tracked** with anomaly detection catching real issues (reviewer drift, excessive P1 items, confidence trends)
- **3 test suites** with 87-92% coverage (42 unit, 12 integration, 8 regression tests)
- **Provenance tracking** with trace IDs enabling end-to-end debugging
- **Cost and performance analysis** ($4.33 for 14 papers, 54 minutes wall-clock)

The operational discussion (Section 5.6) shows the authors have actually run this in production and encountered real issues: Reviewer D consistency degraded, semantic clustering threshold needed adjustment, model API update affected confidence scores. This is the kind of "been there, debugged that" experience I look for in ML systems papers.

The validation study (Section 4.6) and ablation studies (Section 4.7) demonstrate the system doesn't just work in theory — it outperforms alternatives empirically.

**Previous score**: 2/4 (Weak Accept)
**Updated score**: 3/4 (Accept)

This is now solid systems work appropriate for ICSE/FSE. With one more round of polish on the operational metrics (see minor issues), this could be a strong accept.

## Changes from Round 1

### ✓ M1: Observability and Monitoring — FULLY ADDRESSED

Section 3.8.1 implements comprehensive observability:

**15 metrics tracked**:
- Review quality: score distribution, consensus (σ), outlier detection
- Priority classification: P1/P2/P3 distribution, escalation rates
- Synthesis quality: deduplication rate, cross-paper pattern frequency
- Revision efficiency: P1 resolution rate, cascade completion time
- Confidence distribution: % triggering deferral

**Anomaly detection** (Section 5.6.1): Three real examples of anomalies caught in production:
1. Reviewer D consistency degraded (σ: 0.4 → 1.2) — flagged for recalibration
2. Excessive P1 items (>15/paper) — revealed over-sensitive clustering
3. Confidence declined 8% over rounds — correlated with model API update

This demonstrates the observability infrastructure works: it catches real degradation and surfaces actionable insights. The dashboard (Figure~\ref{fig:dashboard}, apparently in appendix) provides real-time visibility.

**Round 1 concern**: "No metrics, dashboards, or anomaly detection"
**Resolution**: 15 metrics, anomaly detection with real examples, dashboard reference. ✓

### ✓ M2: Testing Strategy — FULLY ADDRESSED

Section 3.8.2 implements three test suites:

1. **Unit tests** (42 tests): Each stage handler tested for correct state transitions, priority classification, error handling
2. **Integration tests** (12 tests): Full lifecycle (draft→accepted) on synthetic papers with known-good outputs
3. **Regression tests** (8 golden papers): Reference papers with manually validated reviews, catch drift when prompts/models change

**Test coverage**: 87% stage-machine, 92% synthesis-engine (branch coverage).

**Regression prevention** (Section 5.6.2): 7 regressions caught during development, including prompt changes breaking P1/P2 boundaries and state machine refactors introducing bugs.

This is production-grade testing discipline. The golden dataset for regression testing is especially important for AI systems where prompt/model changes can cause silent degradation.

**Round 1 concern**: "No unit tests, integration tests, regression tests"
**Resolution**: Comprehensive test suite with good coverage and real regression catches. ✓

### ✓ M3: Debugging and Provenance — FULLY ADDRESSED

Section 3.8.3 implements provenance tracking:

Every priority item includes:
- **Source reviews**: Which reviewers flagged the issue
- **Confidence breakdown**: How confidence was computed
- **Escalation path**: If PP1/B1, which P/PP items contributed
- **Trace ID**: Unique ID linking item through all tiers

The `panel:inspect <paper>` command provides debugging UI. Structured JSON logs enable replay of synthesis to verify reproducibility.

This is exactly what I need to debug production issues: end-to-end tracing from B1 board directive back to the original P1 paper-tier issues that triggered it.

**Round 1 concern**: "No logging, provenance, or inspection tools"
**Resolution**: Full provenance with trace IDs, inspection command, structured logs for replay. ✓

### ✓ m1: Reliability and Error Handling — PARTIALLY ADDRESSED

Section 5.6 mentions "error handling" and "reliability" but doesn't detail the mechanisms. What happens when:
- API rate limits are hit?
- LLM generates malformed YAML?
- Stage gate deadlocks (paper stuck in revision)?
- State file (_panel.yaml) is corrupted?

The paper would benefit from explicit error handling protocols.

**Round 1 concern**: "No error handling for API failures, malformed output, deadlocks"
**Resolution**: Mentioned but not detailed. Partially addressed.

### ✓ m2: Cost and Performance — ADDRESSED

Section 5.6.3 provides detailed cost/performance analysis:

**Cost**: $0.20/paper (paper tier), $0.36/module (panel tier), $0.45/program (board tier). For 14 papers: $4.33 total. Scales linearly with papers, sublinearly with modules.

**Latency**: 2.3 min/paper, 5.1 min/module, 6.8 min/board. Total 54 minutes for 14 papers with parallelization.

**Scalability projections**: 50 papers ($12.25), 100 papers ($24.05). Linear scaling demonstrated.

This is the kind of operational analysis I expect for systems papers. The cost ($0.20-0.25/paper at scale) is very reasonable compared to human expert review.

**Round 1 concern**: "No cost or performance analysis"
**Resolution**: Detailed cost/performance/scalability analysis. ✓

### ✓ m4: Reviewer Persona Consistency — ADDRESSED

Section 5.6.1 mentions reviewer drift as a detected anomaly (Reviewer D consistency degraded). Section 5.7 acknowledges persona accuracy depends on prompt quality and training data.

While not a full consistency validation study (regenerating reviews 5x to measure similarity), the operational monitoring demonstrates the system detects drift when it occurs.

**Round 1 concern**: "No validation of persona consistency"
**Resolution**: Drift monitoring implemented, detected in production. Partially addressed.

## Minor Remaining Issues

### m1: Error Handling Protocols Not Detailed

While reliability is mentioned, explicit error handling protocols would strengthen the operational section:
- **API failures**: Retry with exponential backoff? Queue for later? Fail-fast?
- **Malformed output**: Schema validation? Regenerate? Human intervention?
- **Stage deadlock**: Manual override command? Auto-timeout?

**Suggestion**: Add a paragraph in Section 5.6 or 3.8 detailing error handling strategies.

### m2: Missing Latency Breakdown

The 54-minute total latency is reported, but what's the breakdown?
- How much is review generation vs. synthesis?
- Where's the bottleneck (API calls, semantic clustering, file I/O)?
- Could this be optimized further (caching, batching, parallelization)?

**Suggestion**: Add a latency breakdown table showing time per stage and identifying bottlenecks.

### m3: No Discussion of Rollback/Recovery

What happens if synthesis generates bad P1/P2/P3 classifications and you don't notice until papers are deep into revision? Can you rollback to a previous round? Regenerate synthesis with different parameters?

**Suggestion**: Describe recovery procedures: rollback to previous stage, regenerate artifacts, manual state correction.

### m4: Monitoring Dashboard Not Shown

Figure~\ref{fig:dashboard} is referenced but apparently in an appendix not shown. For systems work, seeing the actual dashboard would be valuable.

**Suggestion**: Include Figure~\ref{fig:dashboard} in main paper or provide a URL to live demo dashboard.

## Strengths (Updated)

1. **Production-grade observability**: 15 metrics with real anomaly detection examples demonstrate operational maturity.

2. **Comprehensive testing**: 87-92% coverage across three test suites with regression prevention examples shows this is maintainable code.

3. **Real deployment experience**: The anomaly examples (Reviewer D drift, clustering over-sensitivity, model API impact) show the authors have run this in anger and learned from it.

4. **Cost-effective**: $0.20/paper at scale is very reasonable for automated expert review. 54-minute latency enables rapid iteration.

5. **Debuggable**: Provenance tracking with trace IDs and `panel:inspect` command enable efficient debugging when things go wrong.

## Questions for Authors

1. What's the most common production failure you've encountered? How long does it take to diagnose and fix?

2. Have you implemented automated alerting? (Email/Slack when anomaly detected, API failure, excessive latency?)

3. What percentage of the 54-minute wall-clock time is API calls vs. local computation?

4. Do you version review artifacts (REVIEW-*.md, SYNTHESIS.md)? If you regenerate, do you overwrite or create versioned files?

5. Have you load-tested the system? What's the maximum concurrent papers it can handle before bottlenecking?

## Recommendations for Camera-Ready

- **Add error handling details**: Describe retry logic, output validation, deadlock recovery procedures.

- **Include latency breakdown**: Show where time is spent (review gen, synthesis, file I/O) to guide optimization.

- **Show dashboard screenshot**: Include Figure~\ref{fig:dashboard} in paper or supplementary materials.

- **Compare to baseline**: The $0.20/paper cost is great, but how does it compare to human expert review cost? (Estimated $50-100/reviewer × 5 reviewers = $250-500/paper?)

- **Add operational runbook section**: Brief "what to do when things go wrong" guide for production operators.

---

**Overall verdict**: This is now solid ML systems work with production-ready infrastructure. The observability, testing, and operational experience demonstrate this isn't just a research prototype — it's been battle-tested. With minor polish on error handling and latency analysis, this is a strong contribution to ICSE/FSE.

**Recommendation**: Accept for publication.

---

> **AI Simulation Disclosure**: This review was generated by an AI system (Claude, Anthropic)
> simulating the perspective of Shreya Shankar based on her work on ML observability, testing,
> and production ML systems. Shreya Shankar did not write this review and has no involvement
> with this work. This is a synthetic artifact for testing the hierarchical review system
> described in the paper.
