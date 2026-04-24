# Review: Hierarchical Review Architecture: Scaling Expert Feedback Through Three-Tier Synthesis

**Reviewer**: Percy Liang (Stanford)
**Expertise**: HELM, benchmarks, foundations, evaluation methodology
**Round**: 1
**Date**: 2026-02-07

---

## Overall Assessment

This paper addresses a real scaling challenge in AI-simulated review systems: how to coordinate feedback across multiple papers and organizational tiers. The three-tier architecture (paper → panel → board) with bidirectional flow is sensible, and the P1/P2/P3 priority escalation scheme provides clear structure. The empirical finding that 37% of PP1 and 52% of B1 priorities represent emergent patterns is interesting and suggests the hierarchy adds value beyond flat aggregation.

However, I have significant concerns about evaluation methodology. The paper evaluates the architecture on 14 papers across 3 modules, but these are *synthetic papers generated specifically for this system*. There's no ground truth for what the "correct" emergent patterns should be, no comparison to human expert panels, and no validation that the identified cross-cutting concerns are actually the ones that matter. The evaluation essentially shows the system does what it was designed to do (surface patterns across papers), but not whether those patterns are *useful* or *correct*.

The paper would be much stronger with: (1) evaluation on real research portfolios with known outcomes, (2) comparison to human panel reviews, (3) ablation studies showing the tier structure matters vs. flat aggregation, (4) analysis of failure modes and calibration issues.

## Score

**Score**: 2/4 — Weak Accept

The architecture is sound and the problem is real, but the evaluation is insufficient for a venue like ICSE/FSE. This feels more like a system description than a validated research contribution.

## Major Issues (Blocking)

### M1: Evaluation Lacks Ground Truth and Validation

The evaluation section shows the system produces hierarchical reviews with emergent patterns, but provides no evidence these patterns are *correct* or *useful*. Key missing validations:

- **No human baseline**: How do human expert panels perform the same task? Do they identify the same cross-cutting concerns?
- **No ground truth**: For synthetic papers, what patterns *should* emerge? How do we know the system isn't hallucinating spurious correlations?
- **No outcome validation**: Did papers that addressed PP1/B1 items actually improve? Were submission outcomes better?
- **No calibration study**: Are the priority classifications (P1 vs P2, PP1 vs PP2) consistent with how humans would prioritize?

Without these validations, the empirical results (37% emergent PP1, 52% emergent B1) are just descriptive statistics about system behavior, not evidence of effectiveness.

**Recommended action**: Add at least one of: (1) comparison to human panel reviews on a subset of papers, (2) evaluation on real research portfolios with known quality metrics, (3) user study with researchers using the system, or (4) retrospective analysis showing correlation between panel/board priorities and actual paper outcomes.

### M2: Missing Ablation Studies on Architecture Design

The paper claims the three-tier hierarchy is necessary for scaling, but provides no evidence that the specific design choices matter. What would change if you used:

- **Two tiers instead of three** (just paper + panel, or paper + board)?
- **Flat aggregation** with tag-based grouping instead of hierarchical synthesis?
- **Different priority thresholds** (e.g., PP1 = 3+ papers instead of "cross-paper pattern")?
- **Bottom-up only** (no downward revision propagation)?

The architecture may be well-motivated, but without ablations we don't know which components contribute to the stated benefits.

**Recommended action**: Add ablation experiments comparing: (1) three-tier vs. two-tier vs. flat, (2) priority thresholds, (3) bidirectional vs. unidirectional flow. Show that the full architecture performs measurably better on some metric (human agreement, revision efficiency, outcome quality).

### M3: Scalability Claims Not Supported by Evidence

The abstract and introduction claim the architecture "addresses scaling challenges" and shows emergent patterns are "invisible at lower tiers." But the evaluation uses 14 papers across 3 modules — this is tiny. How does the system scale to:

- 100+ papers in 10+ modules?
- Heterogeneous paper types (not all from the same program)?
- Evolving portfolios where papers arrive incrementally?

The current evaluation is too small to validate scalability claims. Also missing: complexity analysis (how does synthesis cost scale with papers/modules?), performance metrics (time to generate reviews at each tier), and stress testing (what happens with 50 papers in one module?).

**Recommended action**: Either (1) scale the evaluation to 50+ papers to demonstrate the architecture works at larger scale, or (2) remove scalability claims and focus on the benefits of hierarchical synthesis even at small scale. Add complexity analysis and performance measurements.

## Minor Issues

### m1: Priority Classification Criteria Are Vague

The paper states PP1 = "cross-paper pattern or threatens module" but doesn't operationalize this. How many papers must show the pattern? What does "threatens module" mean quantitatively? The B1/B2/B3 definitions have the same issue.

**Suggestion**: Provide explicit decision rules. For example: "PP1 if raised in 3+ papers OR flagged as critical by domain expert OR affects module's core claim."

### m2: No Discussion of Reviewer Diversity

The paper mentions selecting reviewers by expertise but doesn't discuss diversity in perspective, institution, or seniority. Does the system ensure panels aren't echo chambers? Is there a mechanism to include dissenting views?

**Suggestion**: Add a subsection on panel composition strategy and how diversity is ensured.

### m3: Missing Related Work on Meta-Review Systems

The paper cites work on peer review and AI systems but misses literature on meta-review, editorial decision-making, and multi-level quality assessment (e.g., conference program committees, journal editorial boards, grant review panels).

**Suggestion**: Add related work on: (1) meta-review synthesis methods, (2) editorial decision models, (3) hierarchical quality assessment in grant review.

### m4: Unclear How PP/B Items Flow Down to Papers

The paper mentions PP1 items "flow down" to papers and P1 items must be addressed before advancing, but the mechanics are unclear. Does the paper-level system automatically inherit PP1 items? Are they tracked separately? What happens if a paper addresses P1 but not PP1?

**Suggestion**: Add a detailed example showing how a PP1 item from the panel review gets incorporated into a specific paper's revision plan.

## Strengths

1. **Clear architecture design**: The three-tier structure with explicit priority escalation (P1/P2/P3 → PP1/PP2/PP3 → B1/B2/B3) is well-motivated and clearly described.

2. **Bidirectional flow is novel**: Most hierarchical systems are bottom-up aggregation only. The downward propagation of strategic decisions is a useful addition.

3. **Operational feasibility**: The system has been implemented and used on real paper reviews, showing it's practical not just theoretical.

4. **Good attention to detail**: The paper tracks state carefully (_panel.yaml), has stage gates, and includes round management. This suggests the authors have thought through the implementation.

## Questions for Authors

1. Have you validated the emergent patterns against human expert judgment? Can you provide examples where the panel/board identified an issue that individual reviewers missed *and* that issue turned out to be important?

2. What happens when reviewers disagree on priority classification? Is there a consensus mechanism or voting system?

3. How sensitive is the system to reviewer selection? If you swap 2 of the 5 reviewers, do the P1/PP1/B1 priorities change significantly?

4. Can you provide cost analysis? How much does it cost (in API calls or compute) to review one paper at all three tiers?

5. What are failure modes? When does the hierarchy produce worse results than flat review?

## Recommendations

- **Add validation study**: Compare to human panels on a subset of papers. Show correlation between identified priorities and actual revision impact.
- **Add ablations**: Demonstrate the three-tier structure outperforms two-tier or flat alternatives.
- **Scale the evaluation**: Test on 50+ papers to support scalability claims, or narrow the claims to focus on hierarchical synthesis benefits.
- **Include calibration analysis**: Show that P1/PP1/B1 classifications are consistent and meaningful.
- **Add failure analysis**: Discuss when the system fails, what biases it might have, and how to detect/correct errors.

---

**Overall verdict**: This is interesting systems work on an understudied problem, but the evaluation needs strengthening before publication at a top venue. The architecture is sound, but we need evidence it produces better outcomes than alternatives.

---

> **AI Simulation Disclosure**: This review was generated by an AI system (Claude, Anthropic)
> simulating the perspective of Percy Liang based on his published work on benchmarks, evaluation
> methodology, and foundation models (HELM, P3, etc.). Percy Liang did not write this review and
> has no involvement with this work. This is a synthetic artifact for testing the hierarchical
> review system described in the paper.
