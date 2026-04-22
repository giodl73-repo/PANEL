# REVIEW: Token-Efficient Persona Simulation

**Reviewer**: Song Han (MIT)
**Venue**: EMNLP Demo
**Date**: February 15, 2026

> **AI Simulation Disclosure**: This review is AI-generated, simulating Song Han's review perspective based on his efficiency and measurement-focused research. Song Han did not write this review.

---

## Overall Assessment

The paper addresses a real efficiency problem (35K wasted tokens per paper) with a reasonable solution (persistent profiles). However, the experimental design has critical measurement gaps: no overhead analysis, no amortization calculation, and insufficient rigor in token counting methodology. The 71% reduction claim needs precise instrumentation before it can be validated.

**Recommendation**: Major revisions
**Score**: 2/4 (major concerns)

---

## Strengths

1. **Clear problem motivation**
   35K tokens per paper is a concrete, measurable waste. The economic impact is well-articulated.

2. **Controlled A/B design**
   Comparing database generation vs. profile loading in paired experiments is the right experimental structure.

3. **Unexpected consistency benefit**
   The 19% consistency improvement (r=0.86 vs 0.72) is a valuable secondary finding, though it needs statistical validation.

---

## Major Issues (Blocking)

### M1: Missing measurement protocol
**Concern**: "71% token reduction" lacks detailed instrumentation. How exactly are tokens counted? At API call level? Including system prompts? Excluding them? Per-reviewer or aggregate? What's the measurement granularity (per-review, per-round, per-paper)?
**Impact**: Cannot reproduce or validate the claimed savings. Different counting methods could yield vastly different results.
**Suggestion**: Provide explicit measurement protocol: (1) exact token counting method (tiktoken? API response?), (2) what's included/excluded (system prompts, assistant responses, tool calls), (3) logging harness (code snippet showing how tokens are captured), (4) example log entries with token breakdowns.

### M2: Overhead analysis completely missing
**Concern**: Paper optimizes token count but ignores file I/O cost, parsing overhead, cache management latency, and memory footprint. Profile loading isn't free—it has wall-clock time and memory costs.
**Impact**: Real-world deployments care about end-to-end latency, not just token count. If profile loading adds 200ms overhead per paper, that could matter more than token savings in high-throughput scenarios.
**Suggestion**: Measure and report: (1) profile loading time (50th/95th/99th percentile), (2) memory footprint (45 profiles cached vs. database), (3) cache hit/miss latency, (4) total request latency (baseline vs. profiles). Plot latency distribution across papers.

### M3: No amortization analysis
**Concern**: Profiles have one-time generation cost (manual curation of 45 profiles) plus ongoing maintenance cost (updates for new publications). Paper doesn't analyze when these costs are recovered by per-review savings.
**Impact**: Cannot assess cost-benefit tradeoff. For small-scale users (1-10 papers), profile generation overhead might exceed savings.
**Suggestion**: Provide amortization calculation: (1) one-time profile generation cost (hours × hourly rate), (2) per-review savings (tokens × cost per token), (3) breakeven point (number of reviews), (4) sensitivity analysis (what if profile update frequency doubles?).

### M4: Baseline may be artificially inefficient
**Concern**: "Database loaded 5+ times per paper" is the baseline, but why isn't the database cached once in memory? The comparison seems to be "no caching" vs. "profile caching," not "profile persistence" vs. "database caching."
**Impact**: Token savings might come from adding any caching, not from profile architecture specifically. You may be solving a strawman problem.
**Suggestion**: Add third condition: "baseline-cached" where database is loaded once and cached in memory (same as profiles but without compression). If profiles still win significantly, you've validated that profile design (not just caching) matters. If not, you're just demonstrating the value of caching.

---

## Minor Issues

### m1: Quality preservation metrics insufficient
**Suggestion**: Cosine similarity of P1 item embeddings (μ=0.89) is a proxy, not direct quality measurement. Add human evaluation: n=2-3 experts rate blinded review pairs (baseline vs. profiles) on 5-point scale for domain accuracy, citation precision, argumentation depth. Report inter-rater agreement (Cohen's κ).

### m2: No per-venue analysis
**Suggestion**: 5 venues (CHI, NeurIPS, ICML, ACL, PLDI) have different review cultures and token usage patterns. Report token reduction separately per venue. If variance is high, discuss why some venues benefit more than others.

### m3: Caching semantics vague
**Suggestion**: "Session-level caching" needs precise definition. Session = one paper? One day? One user? What's the cache size limit? Eviction policy? Thread-safety model? These details matter for production systems.

### m4: No profile size distribution
**Suggestion**: "~2KB markdown profiles" is an average. Report distribution (min/max/median/std dev). Are some reviewers 500 bytes? Others 5KB? Size variance affects token savings variability.

### m5: Missing failure mode analysis
**Suggestion**: What happens when a profile is corrupted, missing, or out-of-date? Does fallback to database work smoothly? Measure fallback latency and token cost. Report fallback frequency in practice.

---

## Questions for Authors

1. **Exact token counting**: Do you count input tokens only, or input+output? System prompts included? How do you handle multi-turn reviews (accumulation across turns)?

2. **Overhead measurement**: What's the profile loading latency? How does it compare to database loading latency? What's the memory footprint?

3. **Amortization**: At what review volume does profile generation cost break even with token savings? What if profile update frequency increases?

4. **Baseline fairness**: Why not cache the database once in memory? How do profiles compare to cached-database baseline?

5. **Cache hit rate**: What percentage of profile loads are cache hits vs. misses? Does cache effectiveness degrade over long sessions?

6. **Profile staleness**: How often do profiles need updates in practice? What's the update cost? How does staleness affect review quality?

---

## Recommendation Summary

Do not proceed with experiments as designed. First, add detailed measurement protocol (token counting, overhead analysis), perform amortization calculation, and compare against cached-database baseline. The core idea is sound, but efficiency claims need rigorous validation with multiple metrics (tokens, latency, memory). Prioritize M1 (measurement protocol), M2 (overhead analysis), and M4 (baseline comparison).

---

*AI Simulation Disclosure: This review was generated to simulate Song Han's measurement-focused perspective based on his efficiency research.*
