# Experimental Protocol — Token-Efficient Reviewer Profiles

**Wave**: 260215+galileo-observer+reviewer-profiles (Galileo, observer)
**Phase**: V1 Experimental Setup
**Date**: 2026-02-15

---

## Research Question

**RQ1**: How much do persistent reviewer profiles reduce token costs compared to the baseline REVIEWER-DATABASE.md approach?

**RQ2**: Does profile caching maintain review quality and consistency across rounds?

**RQ3**: What is the optimal profile structure for persona simulation?

---

## Experimental Design

### A/B Comparison

| Condition | Description | Token Source |
|-----------|-------------|--------------|
| **A: Baseline** | Current system: REVIEWER-DATABASE.md loaded on each review | Full database context (11.5KB, ~3000 tokens × 5 reviewers) |
| **B: Profiles** | New system: Persistent profiles loaded once, cached | Profile files (~2KB each, loaded once per session) |

### Test Papers

5 papers across varied venues to ensure generalizability:

| # | Paper Topic | Venue | Rationale |
|---|-------------|-------|-----------|
| 1 | HCI evaluation methods | CHI 2026 | Human-AI interaction domain |
| 2 | ML benchmarking framework | NeurIPS 2026 | ML research, evaluation focus |
| 3 | Distributed training system | MLSys 2026 | Systems + ML hybrid |
| 4 | Dialogue generation model | ACL 2026 | NLP domain |
| 5 | Program synthesis tool | PLDI 2026 | PL/compilers domain |

**Selection criteria**:
- Each paper from a different venue category
- Mix of systems, theory, and empirical papers
- All papers have complete sections (3000+ words)
- Representative of typical panel workload

### Experimental Protocol

For each paper P in {CHI, NeurIPS, MLSys, ACL, PLDI}:

#### Condition A: Baseline (Database)
1. Run `panel:review P --mode=database`
2. Capture API logs → `logs/baseline-{P}-round1.json`
3. Extract token counts:
   - Total input tokens
   - Reviewer context tokens (REVIEWER-DATABASE.md)
   - Per-reviewer breakdown
4. Save reviews → `results/baseline/{P}/reviews/`
5. Generate synthesis
6. Run round 2 (recheck)
7. Capture round 2 logs → `logs/baseline-{P}-round2.json`

#### Condition B: Profiles
1. Run `panel:review P --mode=profiles`
2. Capture API logs → `logs/profiles-{P}-round1.json`
3. Extract token counts:
   - Total input tokens
   - Profile load tokens (first load only)
   - Cache hit rate (round 2)
4. Save reviews → `results/profiles/{P}/reviews/`
5. Generate synthesis
6. Run round 2 (recheck)
7. Capture round 2 logs → `logs/profiles-{P}-round2.json`

### Randomization

- **Order**: Randomize paper order to control for learning effects
- **Condition order**: Alternate baseline/profiles to control for temporal effects
- **Reviewer selection**: Use same 5 reviewers for both conditions per paper

---

## Metrics

### Primary Metrics

| Metric | Formula | Threshold |
|--------|---------|-----------|
| **Token reduction** | `(baseline - profiles) / baseline` | Target: ≥60% |
| **Cost savings** | Token reduction × $0.015/1K tokens | Breakeven: 5,921 reviews |

### Secondary Metrics

| Metric | Purpose |
|--------|---------|
| **Review quality** | P1 alignment (manual annotation: 0-10 scale) |
| **Consistency** | Round 1 ↔ Round 2 correlation (cosine similarity) |
| **Cache efficiency** | Profile cache hit rate on round 2 (target: 100%) |
| **Load time** | Profile load overhead vs database parse (target: <10ms) |

### Data Collection

**Token capture instrumentation**:
```javascript
// Insert into review generation loop
const tokenLog = {
  paper: paperName,
  condition: 'baseline' | 'profiles',
  round: 1 | 2,
  reviewer: reviewerName,
  timestamp: new Date().toISOString(),
  tokens: {
    total_input: response.usage.prompt_tokens,
    total_output: response.usage.completion_tokens,
    reviewer_context: calculateReviewerContextTokens(),
    paper_content: calculatePaperTokens()
  },
  cache: {
    hit: profileCacheHit,
    miss: profileCacheMiss,
    hit_rate: profileCacheHit / (profileCacheHit + profileCacheMiss)
  }
};
fs.appendFileSync(`logs/${condition}-${paperName}-round${round}.json`, JSON.stringify(tokenLog) + '\n');
```

**Review quality annotation**:
- Manual review of P1 items for relevance (0-10 scale)
- Inter-rater reliability: 2 annotators, κ agreement target: ≥0.80
- Dimensions: Actionability, Specificity, Accuracy

**Consistency measurement**:
- Extract P1 items from Round 1 and Round 2 syntheses
- Compute cosine similarity of item embeddings
- Target: ≥0.70 correlation (high consistency)

---

## Sample Size & Power

- **Papers**: n=5 (varied venues)
- **Conditions**: 2 (baseline, profiles)
- **Rounds**: 2 per condition
- **Total review sessions**: 5 papers × 2 conditions × 2 rounds = **20 sessions**
- **Power analysis**: With n=5, effect size d=1.5 (large), α=0.05, power=0.80

---

## Statistical Analysis Plan

### Tests

1. **Paired t-test**: Compare token usage (baseline vs profiles) per paper
   - Null hypothesis: μ_baseline = μ_profiles
   - Alternative: μ_baseline > μ_profiles (one-tailed)
   - Significance level: α = 0.05

2. **Effect size**: Cohen's d for token reduction magnitude
   - Small: d=0.2, Medium: d=0.5, Large: d=0.8
   - Expected: d ≥ 1.0 (very large effect)

3. **Confidence intervals**: 95% CI for mean token reduction
   - Report: "Token reduction: 68% (95% CI: 62-74%)"

### Expected Results

**H1 (Token efficiency)**: Profile system reduces tokens by 60-75%
**H2 (Quality preservation)**: No significant difference in P1 relevance (p > 0.05)
**H3 (Consistency improvement)**: Higher Round 1↔2 correlation in profile condition (p < 0.05)

---

## Timeline

| Phase | Duration | Deliverable |
|-------|----------|-------------|
| Setup | 1 day | Protocol finalized, papers selected |
| Baseline runs | 2 days | 10 review sessions complete |
| Profile runs | 2 days | 10 review sessions complete |
| Quality annotation | 1 day | P1 items annotated |
| Analysis | 1 day | Statistical results |
| **Total** | **7 days** | Complete experimental dataset |

---

## Risk Mitigation

| Risk | Mitigation |
|------|------------|
| API rate limits | Stagger requests, add delays between sessions |
| Token logging failure | Dual logging (file + database) |
| Profile cache miss | Verify cache warming before round 2 |
| Quality annotation bias | Blind annotation (annotators don't know condition) |
| Insufficient sample | Pre-registered stopping rule: add 2 papers if d < 0.5 |

---

## Ethical Considerations

- **Simulation disclosure**: All reviews include AI Simulation Disclosure
- **No real submission**: These are quality improvement simulations, not peer review
- **Persona attribution**: Named researchers are personas, not actual participants
- **Data privacy**: No real paper content (use synthetic test papers if needed)

---

## Deliverables

1. **Experimental protocol** (this document) ✓
2. **Test paper selection** (5 papers, identified above)
3. **Instrumentation code** (token logging, cache tracking)
4. **Data collection forms** (quality annotation rubric)
5. **Analysis scripts** (statistical tests, visualization)

---

## References

- Research paper: `research/panel-reviewer-profiles/main.tex`
- Profile loader: `shared/reviewer-profile-loader.md`
- Test fixtures: `test/fixtures/profiles/`
- Master registry: `context/panel/reviewers/_index.yaml`
