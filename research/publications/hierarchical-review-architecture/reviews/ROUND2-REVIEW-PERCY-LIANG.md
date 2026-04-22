# Round 2 Review: Hierarchical Review Architecture: Scaling Expert Feedback Through Three-Tier Synthesis

**Reviewer**: Percy Liang (Stanford)
**Expertise**: HELM, benchmarks, foundations, evaluation methodology
**Round**: 2
**Date**: 2026-02-07

---

## Overall Assessment

The authors have made substantial revisions addressing my Round 1 concerns. The most significant improvement is the addition of a validation study (Section 4.6) with human baseline comparison, showing 73% agreement (Cohen's κ = 0.69) and validating emergent patterns at 75% precision / 82% recall. This transforms the paper from a system description into a validated research contribution.

The ablation studies (Section 4.7) demonstrate that the three-tier architecture outperforms two-tier and flat alternatives on both emergent pattern detection and review cycle efficiency. The comparison is rigorous: three-tier achieves 81% precision vs. 50-90% for two-tier variants, and requires 2.1 cycles/paper vs. 3.4 for flat aggregation. This convincingly shows the full architecture is necessary, not over-engineered.

The detailed aggregation algorithm (Section 3.6) with explicit equations and worked examples addresses my concern about reproducibility. The confidence scoring formula and semantic clustering approach are now well-specified. The human oversight mechanisms (Section 3.7) with confidence-based deferral prevent the system from amplifying AI errors.

My remaining concerns are minor. The validation set is still small (8 papers), and longer-term evaluation (> 4 months) would strengthen claims about system reliability. But for a venue like ICSE/FSE, the current evaluation is sufficient.

**Previous score**: 2/4 (Weak Accept)
**Updated score**: 3/4 (Accept)

## Changes from Round 1

### ✓ P1.1: Evaluation Validation — FULLY ADDRESSED

The validation study (Section 4.6) is excellent. Key strengths:
- **Human baseline**: 5 human reviewers per paper, 73% agreement with AI classifications
- **Emergent pattern validation**: 75% precision (9/12 AI patterns confirmed by humans), 82% recall (9/11 human patterns detected by AI)
- **Outcome validation**: +0.8 score improvement for papers addressing P1 items, demonstrating priorities correlate with quality
- **Failure analysis**: The 2 false positive emergent patterns and 2 missed patterns are discussed transparently

This level of validation is appropriate for a systems venue. While I'd still prefer evaluation on real research portfolios with known outcomes (not synthetic papers), the human baseline comparison provides sufficient ground truth.

**Round 1 concern**: "No evidence emergent patterns are correct or useful"
**Resolution**: Validated against human panels with good precision/recall. ✓

### ✓ P1.4: Ablation Studies — FULLY ADDRESSED

The ablation studies (Section 4.7) are thorough:
- **Three-tier vs. two-tier**: Shows three-tier balances precision (81%) and recall (16 patterns detected), while two-tier variants sacrifice one for the other
- **Hierarchical vs. flat**: Demonstrates 31% reduction in review cycles (2.1 vs. 3.4) and 2.7× more emergent patterns (16 vs. 6)
- **Bidirectional vs. unidirectional**: Shows downward propagation improves B1 resolution from 54% to 89%

These comparisons convincingly demonstrate the architecture's design choices are justified by empirical benefits.

**Round 1 concern**: "No evidence the three-tier structure is necessary"
**Resolution**: Ablations show three-tier outperforms alternatives on multiple metrics. ✓

### ✓ M3: Scalability Evidence — PARTIALLY ADDRESSED

The authors added scalability analysis (Section 5.6) with cost projections (50 papers: $12.25, 100 papers: $24.05) and discussion of human oversight scalability (600 reviews at 500 papers may exceed capacity). They also appropriately temper scalability claims, noting evaluation is limited to 14 papers and "scaling" means portfolio-level, not arbitrarily large systems.

This is intellectually honest. However, I'd still prefer to see evaluation at 30-50 papers to validate the architecture beyond small portfolios.

**Round 1 concern**: "14 papers too small to validate scalability"
**Resolution**: Claims appropriately scoped, projections provided, but no larger-scale empirical validation. Partially addressed.

### ✓ m1: Priority Classification Criteria — ADDRESSED

Section 3.6 now provides explicit decision rules with equations. For example, P1 classification uses frequency (≥3 reviewers), severity (any reviewer with score=1), and confidence thresholds (>0.85 confidence + avg<2.0). This operationalizes what was previously vague.

**Round 1 concern**: "Definitions like PP1 = 'cross-paper pattern' aren't operationalized"
**Resolution**: Explicit formulas and thresholds provided. ✓

## Minor Remaining Issues

### m1: Validation Set Size

The validation study uses 8 papers. While this demonstrates the approach works, a larger validation set (20-30 papers) would strengthen generalizability claims. The authors acknowledge this in Section 5.7 ("validation set is small"), which is appropriate.

**Suggestion**: In future work, validate on a larger corpus to establish confidence intervals for agreement rates and emergent pattern precision/recall.

### m2: Longitudinal Effects Unknown

The 4-month evaluation period (Jan-Apr 2026) is relatively short. Longer-term effects like reviewer drift, author learning curves, and potential system gaming are unknown. The authors acknowledge this limitation (Section 5.7), which is appropriate.

**Suggestion**: Report on the system after 12-18 months of use to assess long-term reliability and adaptation.

### m3: Missing Cost-Benefit Analysis

The cost analysis (Section 5.6) reports absolute costs ($4.33 for 14 papers) but doesn't compare to human expert panel costs. How much does it cost to recruit and compensate 5 human reviewers per paper? The time savings (54 minutes automated vs. hours/days for humans) suggest significant ROI, but quantifying this would strengthen the practical impact claim.

**Suggestion**: Add a paragraph comparing automated review cost ($0.20/paper) to estimated human reviewer compensation (e.g., $50/hour × 2 hours = $100/paper for expert reviewers).

## Strengths (Updated)

1. **Rigorous validation**: The human baseline study and emergent pattern validation provide strong evidence the system produces correct, useful outputs.

2. **Comprehensive ablations**: The comparisons to two-tier, flat, and unidirectional variants convincingly demonstrate the full architecture's necessity.

3. **Reproducible algorithm**: The detailed aggregation equations and semantic clustering thresholds enable reproduction and extension by other researchers.

4. **Intellectual honesty**: The authors appropriately scope claims ("scaling" means portfolio-level, not arbitrary scale) and acknowledge limitations (small validation set, short time period).

5. **Practical deployment**: The cost ($4.33 for 14 papers), latency (54 minutes), and observability infrastructure demonstrate the system is production-ready, not just a research prototype.

## Questions for Authors

1. Have you considered open-sourcing the reviewer personas and aggregation code to enable community validation and extension?

2. For the 2 false positive emergent patterns (17%), what were they? Can you characterize failure modes to guide future improvements?

3. The confidence score formula (Equation 4) uses frequency × agreement. Have you experimented with other weighting schemes (e.g., log-frequency, squared agreement)?

4. How does the system handle papers that span multiple domains? Do you select reviewers from each domain or focus on the primary contribution?

## Recommendations for Camera-Ready

- **Add related work on benchmark design**: Your validation methodology (human baseline, precision/recall on emergent patterns) resembles benchmark evaluation. Cite work on benchmark construction (e.g., Bowman et al. on NLI benchmarks, Rajpurkar et al. on SQuAD).

- **Clarify external validity**: Explicitly state the system was evaluated on AI/systems research papers. Applicability to other domains (biology, social science) requires empirical validation.

- **Report confidence intervals**: For the 73% agreement and 75%/82% precision/recall, provide confidence intervals to quantify uncertainty.

---

**Overall verdict**: This is now strong systems work with rigorous evaluation for ICSE/FSE. The validation study, ablations, and detailed algorithm specification address my major concerns. With minor polish, this is an accept.

**Recommendation**: Accept for publication.

---

> **AI Simulation Disclosure**: This review was generated by an AI system (Claude, Anthropic)
> simulating the perspective of Percy Liang based on his published work on benchmarks, evaluation
> methodology, and foundation models (HELM, P3, etc.). Percy Liang did not write this review and
> has no involvement with this work. This is a synthetic artifact for testing the hierarchical
> review system described in the paper.
