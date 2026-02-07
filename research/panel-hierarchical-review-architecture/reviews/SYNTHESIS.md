# Review Synthesis — Hierarchical Review Architecture

**Paper**: panel-hierarchical-review-architecture
**Round**: 1
**Date**: 2026-02-07
**Reviewers**: 5

---

## Overview

| Metric | Value |
|--------|-------|
| Average Score | 2.6/4 |
| Score Range | 2-3/4 |
| Consensus | Strong (σ = 0.49) |
| Overall Verdict | Revise and Resubmit (Major Revisions) |

## Score Distribution

| Reviewer | Affiliation | Score | Verdict |
|----------|-------------|-------|---------|
| Percy Liang | Stanford | 2/4 | Weak Accept |
| Ben Shneiderman | UMD | 3/4 | Accept |
| Ece Kamar | Microsoft Research | 3/4 | Accept |
| Shreya Shankar | UC Berkeley | 2/4 | Weak Accept |
| Michael Bernstein | Stanford | 3/4 | Accept |

---

## Priority 1: Blocking Issues

Issues that must be addressed before resubmission. Raised by 3+ reviewers or flagged as major by any reviewer.

### P1.1: Evaluation Lacks Ground Truth and Validation

**Raised by**: Percy Liang (M1), Ben Shneiderman (implicit), Ece Kamar (implicit), Michael Bernstein (M3)

**Description**: The evaluation demonstrates the system produces hierarchical reviews with emergent patterns (37% PP1, 52% B1), but provides no evidence these patterns are correct, useful, or better than alternatives. Critical missing validations:

- **No human baseline**: How do human expert panels perform this task? Do they identify the same cross-cutting concerns?
- **No ground truth**: For the 14 synthetic papers evaluated, what patterns *should* emerge? How do we know the system isn't hallucinating spurious correlations?
- **No outcome validation**: Did papers that addressed PP1/B1 items actually improve? Were submission outcomes better?
- **No comparative evaluation**: How does three-tier compare to two-tier, flat aggregation, or traditional review?
- **"Emergent patterns" not validated**: The claim that 37%/52% of priorities are emergent (invisible at lower tiers) needs validation against human expert judgment

**Impact**: Without validation, the empirical results are descriptive statistics about system behavior, not evidence of effectiveness. For ICSE/FSE, the evaluation is insufficient to demonstrate the contribution is a validated research result vs. a system description.

**Recommended action** (Percy Liang, Michael Bernstein):
1. Add human baseline comparison on a subset of papers (minimum 5-10 papers)
2. Validate emergent patterns: show human panels identify the same patterns, measure false positive rate
3. Add outcome analysis: correlation between addressing PP1/B1 items and paper quality improvement
4. Include user study with researchers using the system
5. Compare against alternatives (two-tier, flat aggregation) with ablation studies

### P1.2: No Human Oversight Mechanisms for AI-Generated Classifications

**Raised by**: Ben Shneiderman (M1), Ece Kamar (implicit), Shreya Shankar (implicit)

**Description**: The system automatically classifies issues as P1/P2/P3, PP1/PP2/PP3, B1/B2/B3 based on frequency and severity, but AI reviewers can be systematically wrong. All reviewers might miss the same critical issue or all flag the same spurious concern. No mechanism exists for:

- Humans to override priority classifications when they disagree
- Authors to challenge emergent patterns that don't exist
- Domain experts to inject knowledge the AI lacks
- Detecting when low-confidence classifications need human review

A single misclassification at the paper level can cascade through the hierarchy, affecting multiple papers via PP/B items.

**Impact**: Without oversight, the system risks amplifying AI errors. This violates human-centered AI principles of preserving meaningful human control.

**Recommended action** (Ben Shneiderman, Ece Kamar):
1. Add confidence-based deferral: compute confidence scores, escalate low-confidence classifications to human review
2. Implement human override mechanisms: authors can contest P1 with justification, panel chair approves PP1 items
3. Require human validation for emergent patterns above certain criticality
4. Add transparency: show users the evidence/reasoning behind each classification with confidence indicators

### P1.3: Aggregation Algorithm Is Unspecified

**Raised by**: Michael Bernstein (M1), Percy Liang (implicit), Ece Kamar (implicit)

**Description**: The paper says reviews are "consolidated" into synthesis and "emergent patterns" are identified at higher tiers, but doesn't describe *how*. Key missing details:

- **Priority classification logic**: How do you decide if an issue is P1 vs. P2? What if 2 reviewers say major and 3 say minor?
- **Synthesis generation**: Is synthesis concatenation or intelligent merging? How are redundant issues deduplicated? How are conflicts reconciled?
- **Emergent pattern detection**: How does the panel identify "cross-paper patterns"? Keyword matching? Semantic clustering? LLM analysis?
- **Reviewer weighting**: Are all reviewers weighted equally? What if one gives outlier scores or low-quality feedback?

In crowdsourcing research, aggregation quality is critical — naive approaches often fail. Without knowing the algorithm, we can't assess validity.

**Impact**: The core technical contribution (multi-tier synthesis) is underspecified. Readers can't reproduce, validate, or improve the approach.

**Recommended action** (Michael Bernstein, Percy Liang):
1. Add detailed aggregation section describing:
   - Algorithm for priority classification (P1/P2/P3)
   - How synthesis merges/deduplicates/reconciles reviews
   - How emergent patterns are detected at panel/board tiers
2. Provide worked examples showing raw reviews → synthesis for specific papers
3. Compare multiple aggregation strategies (majority vote, weighted voting, consensus-building)
4. Implement reviewer quality scoring and weighted aggregation

### P1.4: Missing Ablation Studies on Architecture Design

**Raised by**: Percy Liang (M2), Michael Bernstein (implicit)

**Description**: The paper claims the three-tier hierarchy is necessary for scaling, but provides no evidence that the specific design choices matter. What would change with:

- Two tiers instead of three (just paper + panel, or paper + board)?
- Flat aggregation with tag-based grouping instead of hierarchy?
- Different priority thresholds (e.g., PP1 = 3+ papers instead of "cross-paper pattern")?
- Bottom-up only (no downward revision propagation)?

The architecture is well-motivated conceptually, but without ablations we don't know which components contribute to the stated benefits.

**Impact**: Cannot determine if the full architecture is necessary or if simpler alternatives would work as well.

**Recommended action** (Percy Liang):
1. Add ablation experiments comparing:
   - Three-tier vs. two-tier vs. flat aggregation
   - Priority threshold variations
   - Bidirectional vs. unidirectional flow
2. Show the full architecture performs measurably better on human agreement, revision efficiency, or outcome quality

### P1.5: No Observability, Testing, or Debugging Infrastructure

**Raised by**: Shreya Shankar (M1, M2, M3)

**Description**: The paper treats this as a research contribution without sufficient attention to operational concerns critical for software engineering venues:

- **Observability**: No metrics, dashboards, or anomaly detection to monitor review quality. How do you detect when a reviewer gives low-quality feedback? When synthesis misclassifies priorities? When reviewer personas drift over time?
- **Testing**: No unit tests, integration tests, regression tests, or golden datasets. How do you ensure changes don't break functionality?
- **Debugging**: When something goes wrong (spurious P1, missed issue, bad emergent pattern), how do you trace it? No logging, provenance tracking, or inspection tools described.
- **Reliability**: No discussion of error handling (API failures, malformed output, stage gate deadlock, state corruption).

Without these, the system is a research prototype, not a production-ready tool.

**Impact**: For ICSE/FSE, which cares about software engineering practices, insufficient attention to operational rigor weakens the contribution.

**Recommended action** (Shreya Shankar):
1. Add observability section: define key metrics (review quality, consensus, priority distribution), describe dashboards/alerts, implement quality checks
2. Add testing section: unit tests for each stage, integration tests for full pipeline, golden dataset for regression testing
3. Add debugging infrastructure: structured logging, provenance tracking (which reviews contributed to each P1/PP1/B1), inspection commands
4. Address reliability: error handling, retry logic, output validation, state consistency checks

---

## Priority 2: Important Issues

Issues raised by 2+ reviewers that significantly strengthen the paper but aren't blocking.

### P2.1: Scalability Claims Not Supported by Evidence

**Raised by**: Percy Liang (M3), Shreya Shankar (implicit), Ece Kamar (m4)

**Description**: The abstract and introduction claim the architecture "addresses scaling challenges," but evaluation uses only 14 papers across 3 modules — too small to validate scalability. Missing:

- Evaluation at larger scale (50+ papers, 10+ modules)
- Complexity analysis (how does synthesis cost scale?)
- Performance metrics (time to generate reviews at each tier)
- Analysis of whether human oversight scales (at 100 papers, can humans review all PP1 items?)

**Recommended action**: Either (1) scale evaluation to 50+ papers, or (2) remove scalability claims and focus on hierarchical synthesis benefits at small scale. Add complexity/performance analysis.

### P2.2: No Learning from Human Feedback

**Raised by**: Ece Kamar (M2), Shreya Shankar (implicit)

**Description**: When humans make decisions (mark P1 as "won't fix," reject emergent pattern as spurious, downgrade priorities), the system doesn't learn from them. It makes the same mistakes repeatedly.

**Recommended action**: Add feedback loops: track human corrections, use them to calibrate future classifications, implement reviewer quality scoring based on how often feedback is acted upon.

### P2.3: No Mechanism for Handling Reviewer Quality Variation

**Raised by**: Michael Bernstein (M2), Shreya Shankar (m4)

**Description**: The system treats all reviewers equally, but agents vary in quality (inconsistent scoring, superficial feedback, domain mismatch). No quality control mechanisms like reviewer scoring, weighted aggregation, or filtering low-quality work.

**Recommended action**: Implement reviewer quality scoring (consistency, detail, agreement with others), weight reviewers in aggregation, flag low-quality reviews for regeneration, add conflict resolution for strong disagreements.

### P2.4: Priority Classification Criteria Are Vague

**Raised by**: Percy Liang (m1), Ben Shneiderman (implicit)

**Description**: Definitions like PP1 = "cross-paper pattern or threatens module" aren't operationalized. How many papers must show the pattern? What does "threatens module" mean quantitatively?

**Recommended action**: Provide explicit decision rules (e.g., "PP1 if raised in 3+ papers OR flagged as critical by domain expert OR affects module's core claim").

### P2.5: Insufficient Transparency and Explainability

**Raised by**: Ben Shneiderman (M2), Ece Kamar (implicit)

**Description**: The paper doesn't describe how the system explains priority classifications or emergent patterns to users. Missing: provenance tracking, pattern explanation, confidence indicators, ability to drill down from synthesis to individual reviews.

**Recommended action**: Add user interface design section showing how classifications are presented, how evidence is displayed, how users navigate between tiers (include mockups/screenshots).

### P2.6: Trust Calibration Not Addressed

**Raised by**: Ben Shneiderman (m1), Ece Kamar (implicit)

**Description**: No guidance on when users should trust vs. question the system's classifications. Without calibration mechanisms, users may over-trust incorrect classifications or under-trust correct ones.

**Recommended action**: Add confidence scoring for classifications, historical accuracy metrics, calibration studies showing agreement with human panels.

---

## Priority 3: Nice-to-Have Improvements

Issues raised by 1 reviewer that would improve the paper but aren't critical.

### P3.1: Revision Application Workflow Is Underspecified

**Raised by**: Ben Shneiderman (m2)

**Description**: The revision stage workflow is unclear. Does the system suggest LaTeX edits or just list issues? Can authors mark "won't fix"? How are revisions verified?

**Recommended action**: Add subsection on "Human-AI Collaboration During Revision" describing revision assistance, how authors communicate with the system, and verification.

### P3.2: No Discussion of System Failure Modes

**Raised by**: Ben Shneiderman (m3), Shreya Shankar (m1)

**Description**: What happens when the system fails? (Conflicting priorities, review quality variation, adversarial usage, drift over time)

**Recommended action**: Add "Limitations and Failure Modes" section with known failure cases, robustness mechanisms, degradation detection.

### P3.3: Reviewer Diversity Not Discussed

**Raised by**: Percy Liang (m2), Michael Bernstein (m2)

**Description**: No discussion of diversity in perspective, institution, seniority. How do you ensure panels aren't echo chambers?

**Recommended action**: Add subsection on panel composition strategy and diversity constraints (institution, expertise, perspective).

### P3.4: Missing Related Work on Meta-Review Systems

**Raised by**: Percy Liang (m3), Michael Bernstein (m3)

**Description**: Misses literature on meta-review, editorial decision-making, crowdsourcing aggregation, collective intelligence, multi-level governance.

**Recommended action**: Add related work on meta-review synthesis, quality control algorithms (Dawid-Skene, EM), collective intelligence (wisdom of crowds), hierarchical decision-making.

### P3.5: Cost and Performance Not Discussed

**Raised by**: Shreya Shankar (m2)

**Description**: How expensive is this? How long does each stage take? For production use, need cost per paper, latency per stage, throughput, optimization opportunities.

**Recommended action**: Add performance section reporting cost (e.g., "$5 per paper"), latency (e.g., "2 min for reviews, 30 sec for synthesis"), scalability analysis, optimization proposals.

### P3.6: Data Management and Versioning Are Unclear

**Raised by**: Shreya Shankar (m3)

**Description**: How are artifacts (REVIEW-*.md, SYNTHESIS.md) managed? Are reviews immutable or versioned? Where stored (local, git, database)? How are multi-user conflicts prevented?

**Recommended action**: Add data management section describing storage backend, versioning strategy, synchronization mechanisms, archival policy.

### P3.7: Reviewer Persona Consistency Not Validated

**Raised by**: Shreya Shankar (m4)

**Description**: Do AI personas stay consistent within a round, across rounds, across papers?

**Recommended action**: Add persona consistency evaluation: test regeneration similarity (BLEU/ROUGE), round-to-round consistency, cross-paper consistency.

### P3.8: Accessibility and Inclusivity Not Considered

**Raised by**: Ben Shneiderman (m4)

**Description**: Long review documents may have cognitive load, visual accessibility, language, expertise level issues.

**Recommended action**: Add accessibility discussion (executive summaries, screen-reader friendly, non-English support, novice-friendly explanations).

### P3.9: No Discussion of When to Defer to Humans

**Raised by**: Ece Kamar (m2)

**Description**: Human gates are at fixed stages, but no dynamic deferral within stages (e.g., when scores are split, when emergent patterns are critical, when venues are high-stakes).

**Recommended action**: Add deferral policy section defining escalation criteria, tunable thresholds, examples of human-required issues.

### P3.10: Reviewer Selection Doesn't Optimize for Complementarity

**Raised by**: Ece Kamar (m3), Michael Bernstein (m2)

**Description**: Reviewer selection is by expertise match, but doesn't ensure complementary perspectives, diverse views, or conflict resolution mechanisms.

**Recommended action**: Extend reviewer selection to optimize for complementarity (diverse priorities, non-overlapping feedback, human meta-reviewers for conflicts).

### P3.11: No User Study or Deployment Evaluation

**Raised by**: Michael Bernstein (m4)

**Description**: Evaluation is on synthetic papers only. Missing user study (do researchers find it useful?), deployment outcomes (acceptance rates), comparison to alternatives.

**Recommended action**: Add user-facing evaluation: survey researchers, report acceptance rates, compare to traditional/two-tier review.

### P3.12: Consensus vs. Diversity Not Discussed

**Raised by**: Michael Bernstein (m1)

**Description**: Paper tracks consensus (score variance) but doesn't discuss when consensus vs. diversity is valuable, how dissenting views are handled, whether panel composition should optimize for diversity.

**Recommended action**: Analyze when high/low consensus correlates with quality, discuss how dissenting views are surfaced/suppressed, consider diversity optimization in panel composition.

---

## Summary of Recommendations

The paper presents a well-designed hierarchical architecture for coordinating AI-simulated reviews across three tiers (paper → panel → board) with bidirectional flow and explicit priority escalation. The problem is real and important, and the operational deployment demonstrates feasibility.

**However, the paper has significant gaps for a venue like ICSE/FSE:**

1. **Evaluation is insufficient**: No ground truth, no human baseline, no validation of emergent patterns, no comparison to alternatives, no outcome metrics. This is the most critical gap — the paper shows the system *works* but not that it works *better* than alternatives or produces *correct* results.

2. **Human-AI interaction is underspecified**: Limited mechanisms for human oversight, no transparency/explainability design, no trust calibration guidance, no learning from human feedback.

3. **Technical approach is underspecified**: Aggregation algorithm not detailed, no ablation studies, priority classification criteria vague.

4. **Operational concerns are insufficient**: For a software engineering venue, needs more attention to observability, testing, debugging, reliability.

**Strong Accept conditional on addressing P1 items.** With major revisions addressing validation, human oversight, aggregation details, ablations, and operational rigor, this could be an excellent contribution to research methodology and software engineering.

**Next steps for authors:**
1. Priority: Add validation study (human baseline, emergent pattern validation, outcome analysis)
2. Priority: Add human oversight mechanisms (confidence-based deferral, override capability)
3. Priority: Detail aggregation algorithm and provide worked examples
4. Priority: Add ablation studies comparing three-tier vs. alternatives
5. Important: Add observability/testing/debugging infrastructure
6. Important: Address scalability claims with larger evaluation or narrowed scope
7. Polish: Address P2/P3 items to strengthen the paper

---

> **AI Simulation Disclosure**: This synthesis was generated by an AI system (Claude, Anthropic)
> consolidating reviews from simulated expert personas. The named reviewers (Percy Liang, Ben
> Shneiderman, Ece Kamar, Shreya Shankar, Michael Bernstein) did not write these reviews and have
> no involvement with this work. This is a synthetic artifact for testing the hierarchical review
> system described in the paper.
