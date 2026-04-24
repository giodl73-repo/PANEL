# Review Synthesis — From Reviews to Revisions: Automated Synthesis and Priority Classification of Expert Feedback

**Paper**: panel-synthesis-methods
**Round**: 1
**Date**: 2026-02-05
**Reviewers**: 5

---

## Overview

| Metric | Value |
|--------|-------|
| Average Score | 2.4/4 |
| Score Range | 2–3/4 |
| Consensus | Moderate (σ = 0.55) |
| Overall Verdict | Major Revisions Required |

## Score Distribution

| Reviewer | Affiliation | Score | Verdict |
|----------|-------------|-------|---------|
| Percy Liang | Stanford | 2/4 | Major Revisions Required |
| Denny Zhou | Google DeepMind | 3/4 | Accept with Minor Revisions |
| Michael Bernstein | Stanford | 2/4 | Major Revisions Required |
| Danqi Chen | Princeton | 3/4 | Accept with Minor Revisions |
| Shreya Shankar | Berkeley | 2/4 | Major Revisions Required |

---

## Priority 1: Blocking Issues

Issues that must be addressed before resubmission. Raised by 3+ reviewers or flagged as major by any reviewer.

### P1.1: Deduplication Method Insufficiently Specified
**Raised by**: Percy Liang (m1), Denny Zhou (m1), Danqi Chen (M1)
**Description**: The semantic similarity method used for cross-reviewer deduplication is never fully specified. The paper mentions "semantic similarity" and a "merge threshold" but provides no details on the specific method (embedding-based, rule-based, or LLM-prompted), the threshold value, or parameters. For 3 reviewers this is the single most critical gap. Danqi Chen elevated it to a major blocking issue, noting that the 91%/78% precision/recall figures are meaningful only if the method is reproducible.
**Impact**: Without this detail, the paper's core technical contribution is not reproducible. The deduplication stage is the primary NLP contribution and it deserves a full technical description.
**Recommended action**: Fully specify the deduplication method including: similarity function, threshold value, encoder/model used, and parameter sensitivity analysis.

### P1.2: Circular Evaluation — No External Ground Truth
**Raised by**: Percy Liang (M1)
**Description**: The system generates reviews, synthesizes them, then evaluates synthesis quality against those same generated reviews. The 72% score improvement metric is measured within rounds of the same system. This creates circular validation with no independent ground truth. The priority classification may be tuned to the same review generation process.
**Impact**: Threatens the validity of the paper's primary empirical claim. Without external validation, readers cannot know if the synthesis works on human-written reviews.
**Recommended action**: Validate on human-written reviews from a public dataset (e.g., PeerRead, ICLR OpenReview). Even a small comparison (10-20 reviews) would break the circularity.

### P1.3: No Baseline Comparisons
**Raised by**: Percy Liang (M2), Michael Bernstein (M2)
**Description**: The paper claims the synthesis pipeline is effective but compares to nothing. Percy Liang asks about naive alternatives (sequential reading, frequency sorting). Michael Bernstein asks about crowd aggregation methods (Dawid-Skene, GLAD). Without baselines, the value of the three-stage pipeline over simpler alternatives is unquantified.
**Impact**: The contribution cannot be assessed without baselines. The pipeline may be no better than simpler approaches.
**Recommended action**: Add at least 2 baselines: (1) naive frequency-based aggregation, (2) a standard crowd aggregation method. Compare on coverage, attribution accuracy, and P1 classification quality.

### P1.4: No User Study of Author Behavior
**Raised by**: Michael Bernstein (M1)
**Description**: The paper evaluates synthesis technically but never studies whether authors find the output useful. A synthesis document that is correct but that authors ignore has no practical value. The human side of the pipeline is entirely unaddressed.
**Impact**: Without user validation, the paper presents a system without evidence of its practical utility.
**Recommended action**: Conduct a small qualitative study (3-5 authors) comparing revision behavior with and without synthesis documents.

### P1.5: Threshold Sensitivity Not Analyzed
**Raised by**: Denny Zhou (M1)
**Description**: The P1 classification uses "3+ reviewers" as the threshold but provides no sensitivity analysis. Why 3 and not 2 or 4? How does the 72% score impact change as the threshold varies? The classification rules are presented as calibrated but without systematic justification.
**Impact**: The classification rules may be fragile or arbitrary. A sensitivity curve would demonstrate robustness.
**Recommended action**: Include a sensitivity analysis showing P1 score impact as the reviewer count threshold varies from 1 to N-1.

### P1.6: Pipeline Reliability and Failure Modes
**Raised by**: Shreya Shankar (M1, M2)
**Description**: 186+ reviews processed but no analysis of when the pipeline fails. What is the failure rate? How often is the synthesis misleading or incomplete? Additionally, synthesis quality depends on input review quality, but no sensitivity analysis exists for varying review quality.
**Impact**: Without reliability analysis, the system cannot be trusted for practical deployment.
**Recommended action**: Add failure mode analysis: identify cases where synthesis was poor, characterize failure patterns, and analyze sensitivity to input review quality variation.

---

## Priority 2: Important Improvements

Issues that would significantly strengthen the paper. Raised by 2+ reviewers.

### P2.1: Engage with Crowd Aggregation Literature
**Raised by**: Michael Bernstein (M2), Percy Liang (implicit in M2)
**Description**: Multi-reviewer synthesis is a crowd aggregation problem. The paper does not engage with Dawid-Skene, GLAD, spectral methods, or structured crowd workflows. The related work section is thin on this highly relevant literature.
**Recommended action**: Add a related work subsection on crowd aggregation, position the contribution relative to established methods, and compare at least one method as a baseline.

### P2.2: LLM-Specific Biases May Inflate Consensus
**Raised by**: Percy Liang (m3), Michael Bernstein (m1)
**Description**: Since reviews are AI-generated, they may share systematic biases (e.g., always flagging "generalization concerns"). The deduplication step might conflate genuine consensus with LLM-generated uniformity. Different reviewer "types" may not produce truly independent assessments.
**Recommended action**: Analyze whether certain issue types are flagged disproportionately across all reviewers. Discuss the independence assumption and its limitations in AI-generated review contexts.

### P2.3: Missing Operational Metrics
**Raised by**: Michael Bernstein (m3), Shreya Shankar (m4)
**Description**: No reporting of synthesis document length, pipeline latency, or compute cost. For practical adoption, these operational characteristics matter.
**Recommended action**: Report average synthesis document length, end-to-end latency, and compute resources required.

---

## Priority 3: Minor Suggestions

Suggestions from individual reviewers. Address if time permits.

### P3.1: No Error Bars on Aggregate Statistics
**Raised by**: Percy Liang (m2)
**Suggestion**: Add confidence intervals to all aggregate statistics, especially the priority distribution table (Table 3). With 33 cycles, variance matters.

### P3.2: Missing Ablation Studies
**Raised by**: Denny Zhou (m3)
**Suggestion**: Evaluate pipeline stages individually: full pipeline vs. no deduplication vs. no severity signal. This would clarify each stage's contribution.

### P3.3: Impact of Deduplication Recall on P1 Classification
**Raised by**: Danqi Chen (m3)
**Suggestion**: 78% deduplication recall means some duplicates remain separate, potentially underclassifying P1 items. Measure the downstream impact.

### P3.4: Template-Dependent Extraction Limits Generalizability
**Raised by**: Danqi Chen (m1)
**Suggestion**: Discuss whether the extraction stage generalizes to free-form reviews without structured section headings.

### P3.5: Conflict Resolution Mechanism
**Raised by**: Michael Bernstein (m2)
**Suggestion**: Consider tie-breaking reviews for conflicts rather than passing all disagreements to the author.

### P3.6: Adaptive Thresholds by Panel Size
**Raised by**: Denny Zhou (m4)
**Suggestion**: Larger panels (9 reviewers) may warrant higher thresholds than smaller panels (5 reviewers). Consider adaptive rules.

### P3.7: Error Analysis by Issue Type
**Raised by**: Danqi Chen (m4)
**Suggestion**: Analyze which issue types are hardest to deduplicate (e.g., methodology vs. framing issues).

### P3.8: "Any Major" Override Quantification
**Raised by**: Denny Zhou (m2)
**Suggestion**: Report what percentage of P1 items were elevated solely by the "any major" override (fewer than 3 reviewers but flagged major).

---

## Areas of Strength

Aspects that reviewers agreed were done well:

1. **Clear pipeline design** — The three-stage decomposition is intuitive and well-described (cited by 5 reviewers)
2. **Practical utility** — The paper solves a real, recognized problem in multi-reviewer assessment (cited by 4 reviewers)
3. **P1/P2/P3 framework** — The bug triage analogy is effective and accessible (cited by 3 reviewers)
4. **Honest limitations** — The paper proactively identifies key concerns (cited by 2 reviewers)
5. **Deduplication precision** — 91% precision with "err toward under-merging" is well-reasoned (cited by 2 reviewers)

## Areas of Disagreement

Points where reviewers diverged:

1. **Evaluation sufficiency** — Denny Zhou and Danqi Chen find the evaluation adequate for the contribution (score 3/4), while Percy Liang, Michael Bernstein, and Shreya Shankar see fundamental evaluation gaps (score 2/4). The split is between reviewers who evaluate the pipeline on technical merit vs. those requiring external validation.

---

## Recommended Next Steps

1. **Specify deduplication method fully** — Addresses P1.1 — Core reproducibility gap
2. **Add external validation** — Addresses P1.2, P1.3 — Use PeerRead or ICLR OpenReview data + add baselines
3. **Conduct small user study** — Addresses P1.4 — 3-5 authors comparing revision with/without synthesis
4. **Add threshold sensitivity analysis** — Addresses P1.5 — Sweep reviewer count threshold, plot score impact
5. **Add failure mode analysis** — Addresses P1.6 — Identify and characterize pipeline failure cases
6. **Expand related work** — Addresses P2.1 — Crowd aggregation literature
7. **Add operational metrics** — Addresses P2.3 — Latency, cost, document length

---

*Generated by panel synthesis engine — see shared/synthesis-engine.md*
