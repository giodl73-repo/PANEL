# Round 2 Review: Hierarchical Review Architecture: Scaling Expert Feedback Through Three-Tier Synthesis

**Reviewer**: Michael Bernstein (Stanford)
**Expertise**: Crowdsourcing, human computation, collective intelligence, social computing
**Round**: 2
**Date**: 2026-02-07

---

## Overall Assessment

The authors have made exemplary revisions addressing aggregation quality and collective intelligence principles. The detailed aggregation algorithm (Section 3.6) with explicit equations for P1/P2/P3 classification and semantic clustering is exactly what I needed. The worked example showing P1 → PP1 escalation demonstrates the algorithm in practice.

The validation study (Section 4.6) provides strong evidence the aggregation produces valid collective intelligence: emergent patterns detected by the system match human panel identification at 75% precision / 82% recall. This validates that hierarchical synthesis produces insights no individual reviewer generates — the hallmark of collective intelligence.

The ablation studies (Section 4.7) demonstrate the three-tier structure outperforms flat aggregation (16 vs. 6 emergent patterns, 2.1 vs. 3.4 cycles/paper), convincingly showing hierarchical aggregation adds value beyond simple voting.

**Previous score**: 3/4 (Accept)
**Updated score**: 4/4 (Strong Accept)

This is now excellent work on multi-level aggregation and collective intelligence in AI systems.

## Changes from Round 1

### ✓ M1: Aggregation Algorithm Specified — FULLY ADDRESSED

Section 3.6 provides comprehensive aggregation details:

**Paper-tier classification** (Equations 1-3):
- P1: frequency (≥3 reviewers) OR severity (any score=1) OR high-confidence low-score
- P2: non-P1 AND ≥2 reviewers mention
- P3: non-P1/P2 AND 1 reviewer mentions

**Confidence scoring** (Equation 4):
$$\text{confidence}(I) = \frac{|R_i : I \in M_i \cup m_i|}{n} \times \text{agreement}(I)$$

This is principled: confidence requires both frequency (how many reviewers) and agreement (semantic similarity of descriptions). Low agreement → low confidence → human review.

**Semantic clustering**:
- Embed issues with text-embedding-3-large
- Cluster at cosine similarity ≥ 0.80 (paper), 0.75 (panel), 0.70 (board)
- Decreasing thresholds at higher tiers reflect broader pattern detection

**Panel/board aggregation** (Equations 5-7): Cross-paper patterns detected via clustering, escalated to PP1/B1 based on frequency (≥3 papers/modules) or threat assessment.

The worked example (Section 3.6.4) showing 5 "statistical rigor" issues clustering into PP1 demonstrates the algorithm in action.

**Round 1 concern**: "How do you aggregate reviews? Algorithm unspecified"
**Resolution**: Detailed equations, semantic clustering approach, worked example. ✓

### ✓ M2: Reviewer Quality Variation — PARTIALLY ADDRESSED

Section 5.6.1 mentions reviewer quality monitoring (Reviewer D consistency degraded), and Section 3.8 tracks metrics like outlier detection. However, the paper doesn't implement weighted aggregation based on reviewer quality.

The confidence scoring (Equation 4) uses frequency and agreement but treats all reviewers equally. This is reasonable for AI reviewers (assumed high quality) but might not scale to mixed human-AI panels.

**Round 1 concern**: "No mechanism for handling reviewer quality variation"
**Resolution**: Quality monitoring implemented, but no weighted aggregation. Partially addressed.

### ✓ M3: Emergent Patterns Validated — FULLY ADDRESSED

Section 4.6.2 validates emergent patterns against human panels:
- **75% precision**: 9/12 AI-detected patterns confirmed by humans (2 false positives, 1 borderline)
- **82% recall**: 9/11 human-detected patterns found by AI (2 missed patterns)
- **Confidence correlation**: Confidence scores predict human agreement (r=0.71)

The analysis of false positives (spurious correlations) and false negatives (stylistic issues, unstated assumptions) shows intellectual honesty about failure modes.

This is exactly the validation I requested: emergent patterns aren't just system artifacts — they're real insights that human panels independently identify.

**Round 1 concern**: "Are emergent patterns real or AI hallucinations?"
**Resolution**: Validated against human panels with good precision/recall. ✓

### ✓ m1: Consensus vs. Diversity — ADDRESSED

Table 4.5 reports inter-rater agreement (Spearman ρ = 0.68 paper-panel, 0.71 panel-board). This indicates moderate agreement — sufficient consensus to aggregate, but enough diversity to bring varied perspectives.

The discussion (Section 5.6) acknowledges this balance: "moderate agreement suggests diversity, but not explicitly optimized." This is appropriate — optimizing too hard for consensus risks groupthink, optimizing for diversity risks incoherence.

**Round 1 concern**: "Is consensus or diversity better? How do you balance?"
**Resolution**: Moderate agreement observed, tradeoff acknowledged. ✓

### ✓ m3: Related Work on Crowdsourcing — ADDRESSED

Section 2.4 adds related work on meta-review and crowdsourcing aggregation:
- Dawid-Skene model for estimating worker quality via EM
- EM approaches for inferring ground truth from noisy labels
- Collective intelligence research on when groups outperform individuals
- Warnings about groupthink and cascade effects

This positions the work properly in the crowdsourcing/collective intelligence literature.

**Round 1 concern**: "Missing related work on aggregation algorithms"
**Resolution**: Comprehensive related work on Dawid-Skene, EM, collective intelligence. ✓

## Minor Remaining Issues

### m1: No Weighted Aggregation

The confidence scoring treats all reviewers equally (Equation 4 uses count, not weighted sum). In human crowdsourcing, we weight by worker quality (Dawid-Skene, GLAD, etc.). For AI reviewers, weighting by historical accuracy or domain match might improve aggregation quality.

**Suggestion**: Future work could explore weighted aggregation: $\text{confidence}(I) = \sum_{i:I \in R_i} w_i \times \text{quality}(i)$ where $w_i$ is reviewer weight based on past override rate or domain match.

### m2: No Discussion of Strategic Behavior

In human crowdsourcing, workers sometimes game the system (copy others' answers, submit random responses). Could AI reviewers exhibit analogous issues (homogeneous personas, prompt injection)?

The paper mentions adversarial usage (Section 5.7: "authors gaming the system") but doesn't detail defenses.

**Suggestion**: Add a paragraph on strategic behavior: How do you detect if all reviewers converge on identical responses (lazy prompting)? How do you prevent prompt injection attacks on reviewer personas?

### m3: Inter-Rater Reliability Across Rounds

Table 4.5 reports agreement within Round 1. How does inter-rater reliability change across rounds? Do reviewers become more consistent (learning) or less consistent (fatigue/drift)?

**Suggestion**: Report Round 1 vs. Round 2 inter-rater agreement to assess stability over time.

### m4: No Comparison to Alternative Aggregation Methods

The paper uses semantic clustering (cosine similarity ≥ 0.80) to deduplicate issues. How does this compare to:
- Simple keyword matching?
- LLM-based deduplication ("are these the same issue?")?
- Manual human deduplication?

**Suggestion**: Ablate the clustering method: compare cosine similarity vs. keyword overlap vs. LLM-based deduplication on accuracy and efficiency.

## Strengths (Updated)

1. **Rigorous aggregation algorithm**: Explicit equations with worked examples enable reproduction and extension by other researchers.

2. **Validated collective intelligence**: Emergent patterns match human panel identification (75% precision, 82% recall), demonstrating true collective intelligence not artifacts.

3. **Ablations demonstrate necessity**: Three-tier detects 2.7× more patterns than flat (16 vs. 6) with 31% fewer cycles (2.1 vs. 3.4/paper), convincingly showing the architecture's value.

4. **Confidence-based quality control**: Equation 4 combines frequency and agreement into principled confidence scores, enabling adaptive human-AI collaboration.

5. **Production validation**: The operational discussion (Section 5.6) with real anomaly examples demonstrates this works in practice, not just theory.

## Questions for Authors

1. Have you experimented with different similarity thresholds (0.70, 0.80, 0.90)? How sensitive is pattern detection to this parameter?

2. For the 2 false positive emergent patterns, what were they? Can you characterize what makes a pattern spurious vs. real?

3. Does reviewer diversity (expertise spread) correlate with emergent pattern count? Do more diverse panels find more patterns?

4. Have you considered iterative aggregation (reviewers see others' reviews and update their own)? How would this affect convergence?

5. The confidence correlation (r=0.71 with human agreement) is good but not perfect. What contributes to the remaining variance? Domain difficulty? Reviewer quality? Pattern type?

## Recommendations for Camera-Ready

- **Compare aggregation methods**: Ablate semantic clustering vs. keyword matching vs. LLM deduplication to justify the approach.

- **Add weighted aggregation discussion**: Even if not implemented, discuss how reviewer weighting (by quality, domain match) could improve future versions.

- **Expand on strategic behavior**: How do you detect gaming, collusion, or prompt injection attacks on reviewer personas?

- **Report round-to-round reliability**: Does inter-rater agreement change across rounds (Round 1 vs. Round 2)? This assesses temporal stability.

- **Cite recent collective intelligence work**: Add references to recent work on hybrid human-AI collective intelligence (Nagar & Malone 2011, Valentine et al. 2017).

---

**Overall verdict**: This is now exemplary work on multi-level aggregation and collective intelligence in AI systems. The detailed algorithm, emergent pattern validation, and ablation studies demonstrate both technical rigor and practical value. This should be a strong accept for ICSE/FSE and a model for AI-assisted research methodology.

**Recommendation**: Strong Accept for publication.

---

> **AI Simulation Disclosure**: This review was generated by an AI system (Claude, Anthropic)
> simulating the perspective of Michael Bernstein based on his published work on crowdsourcing,
> human computation, and collective intelligence systems. Michael Bernstein did not write this
> review and has no involvement with this work. This is a synthetic artifact for testing the
> hierarchical review system described in the paper.
