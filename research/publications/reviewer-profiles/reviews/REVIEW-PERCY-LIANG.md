# REVIEW: Token-Efficient Persona Simulation

**Reviewer**: Percy Liang (Stanford University)
**Venue**: EMNLP Demo
**Date**: February 15, 2026

> **AI Simulation Disclosure**: This review is AI-generated, simulating Percy Liang's review perspective based on his published evaluation methodology and known research priorities. Percy Liang did not write this review.

---

## Overall Assessment

The core premise is sound—persistent profiles should reduce redundant generation costs—but the experimental design lacks the rigor needed to validate the claimed 60-75% token reduction or demonstrate that review quality is preserved. The 5-paper sample is too small for statistical power, the A/B comparison conflates multiple variables, and critical aspects of reproducibility (profile generation protocol, caching implementation, failure mode analysis) are underspecified.

**Recommendation**: Major revisions
**Score**: 2/4 (1=reject, 2=major concerns, 3=accept with revisions, 4=strong accept)

---

## Strengths

1. **Clear, measurable problem**
   The 35K token waste per paper is well-quantified and economically significant. This makes the optimization target concrete and the potential impact verifiable.

2. **Leverages existing pattern (craft disciplines)**
   Building on a proven architecture reduces design risk and provides a reference implementation. The connection to craft's discipline resolution chain is a practical foundation.

3. **Addresses real system constraint**
   Token efficiency directly impacts feasibility of AI simulation at scale. This is a legitimate engineering challenge worth solving systematically.

---

## Major Issues (Blocking)

### M1: Sample size insufficient for claimed statistical power
**Concern**: Five papers cannot support p<0.001 claims or detect quality degradation at scale. With high variance in review generation (different papers, venues, reviewers), you need n≥20 papers minimum for paired t-test with 80% power at α=0.05.
**Impact**: Expected results section overstates confidence. "71% reduction, p<0.001" is not credible with n=5.
**Suggestion**: Either (1) expand to 20-30 papers across 10+ venues, or (2) reframe as exploratory pilot study (n=5) with effect size estimates and confidence intervals, explicitly stating underpowered status.

### M2: A/B comparison confounds profile persistence with generation method
**Concern**: "Database generation vs. profile loading" compares two different artifacts. If profile content differs from database content (compression, summarization, field selection), token savings might come from information loss, not architectural efficiency.
**Impact**: Cannot attribute delta to persistence mechanism alone. Quality preservation metrics become unreliable.
**Suggestion**: Add ablation study with three conditions: (A) fresh database generation per paper, (B) cached database (loaded once), (C) persistent profiles (loaded once). This isolates caching benefit from profile design benefit.

### M3: No reproducibility protocol for profile generation
**Concern**: "~2KB markdown profiles" is underspecified. How are profiles generated from the 11.5KB database? What compression heuristics? What fields are retained? Is this automated or manual curation?
**Impact**: Core contribution is not reproducible. Other researchers cannot generate equivalent profiles or validate the approach.
**Suggestion**: Document profile generation as an algorithm: input (database YAML), output (profile markdown), transformation steps, field selection rules. Provide reference implementation. Include example input/output pairs in appendix.

### M4: Missing failure mode analysis
**Concern**: Paper doesn't address profile staleness, cache invalidation, or resolution chain failures. What happens when a reviewer's recent work isn't in the profile? When do profiles need updates? How does the system degrade?
**Impact**: Production deployment risks are unquantified. Generalizability to long-running systems is unclear.
**Suggestion**: Add "Robustness" subsection in Methodology: (1) profile update policy (frequency, triggers), (2) fallback behavior when cache misses, (3) monitoring for drift between profile and full database.

### M5: Quality preservation metrics lack construct validity
**Concern**: "Review quality preservation" uses 4-level rubric scores, but these aggregate multiple dimensions (novelty, rigor, clarity). A profile-based review might score 3/4 overall but miss domain-specific nuances that a full database would catch.
**Impact**: Quality metrics may miss subtle degradation (e.g., less precise citations, weaker connection to reviewer's recent work).
**Suggestion**: Decompose quality into subscores (domain accuracy, citation precision, argumentation depth) and measure each independently. Include human expert ratings (n=2-3 judges) on blinded review pairs to validate that differences are imperceptible.

---

## Minor Issues

### m1: Venue diversity may not cover evaluation regimes
**Suggestion**: CHI, NeurIPS, ICML, ACL, PLDI span AI/systems but miss other review cultures (e.g., theory-heavy venues like STOC, interdisciplinary venues like WWW). Consider adding 2-3 venues with distinct review norms to test generalizability.

### m2: Consistency metric operationalization unclear
**Suggestion**: "Same reviewer generates similar reviews for similar papers" needs a distance metric. Use embedding similarity (e.g., cosine distance of BERT embeddings) or structured diff (Levenshtein on normalized text). Define threshold for "acceptable consistency."

### m3: Diversity metric needs negative control
**Suggestion**: "Panel diversity is maintained" should compare against a baseline where all reviewers use identical profiles (diversity floor) and fully independent generation (diversity ceiling). This bounds expected variance.

### m4: Cost-benefit analysis incomplete
**Suggestion**: Include amortization analysis: at what review volume does profile generation cost (one-time) get recovered by per-review savings? This informs adoption threshold for small vs. large-scale users.

---

## Questions for Authors

1. **Profile generation specifics**: Is the 11.5KB → ~2KB compression lossy or lossless? What is the selection criteria for retained fields? Can you provide a diff showing what's removed?

2. **Caching implementation**: Are profiles loaded into context once per paper or once per session? How do you handle concurrent reviews (multiple papers using the same profile simultaneously)? Does caching interact with LLM provider context window limits?

3. **Baseline strength**: Have you compared against alternative efficiency strategies (e.g., database field pruning, lazy loading of reviewer details, compressed embeddings)? Why is persistent profile architecture superior to simpler optimizations?

4. **Expected results justification**: The 71% reduction seems derived from (11.5KB × 5 reviews) - (2KB × 1 load) = ~55KB saved per paper, but this assumes zero profile regeneration. How often do profiles need refreshing in practice? What's the sensitivity analysis on this?

5. **Quality degradation detection**: What is your minimum detectable effect size for quality differences? If profile-based reviews are 2% worse on average, would your n=5 study catch this?

---

## Recommendation Summary

Do not proceed with implementation as designed. First, strengthen the experimental protocol: expand sample size to n≥20, add ablation conditions to isolate mechanisms, document profile generation as a reproducible algorithm, and decompose quality metrics to detect subtle degradation. The core idea is worth building, but the current design cannot validate the claimed benefits with sufficient confidence. Prioritize M1 (sample size), M2 (ablation), and M3 (reproducibility protocol) before running experiments.

---

**Final Note**: This paper addresses a real problem with a sensible solution, but evaluation methodology needs to match the standards of empirical NLP/ML work. I encourage resubmission after addressing experimental rigor—this could be a strong demo contribution with proper validation.
