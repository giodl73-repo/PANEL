# Revision Plan — panel-synthesis-methods

**Round**: 1
**Date**: 2026-02-05
**Based on**: reviews/SYNTHESIS.md

---

## P1 Items (Must Address)

### P1.1: Deduplication Method Insufficiently Specified
**Action**: Add new subsection "Deduplication: Technical Specification" to Section 3 (Synthesis Pipeline). Include:
- Exact similarity function (embedding-based, rule-based, or LLM-prompted)
- Encoder/model used and dimensionality
- Merge threshold value and how it was selected
- Parameter sensitivity analysis showing precision/recall at different thresholds
**Files**: sections/03-synthesis-pipeline.tex

### P1.2: Circular Evaluation — No External Ground Truth
**Action**: Add new subsection "External Validation" to Section 5 (Evaluation). Include:
- Small-scale validation on human-written reviews from PeerRead or ICLR OpenReview (10-20 reviews)
- Compare synthesis quality metrics (coverage, attribution, P1 classification) on human vs. AI-generated reviews
- Explicit acknowledgment of circularity with prospective validation protocol for venue submissions
**Files**: sections/05-evaluation.tex

### P1.3: No Baseline Comparisons
**Action**: Add new subsection "Baseline Comparisons" to Section 5. Include:
- Baseline 1: naive frequency-based aggregation (sort issues by mention count, no deduplication)
- Baseline 2: Dawid-Skene or GLAD crowd aggregation applied to reviewer issue data
- Compare all three on coverage, attribution accuracy, and P1 classification quality
**Files**: sections/05-evaluation.tex

### P1.4: No User Study of Author Behavior
**Action**: Add new subsection "Author Experience Study" to Section 5. Include:
- Structured author reflection on using synthesis documents vs. reading reviews individually
- Qualitative analysis of revision behavior: did P1 ordering match author intuition?
- Report agreement rate between author priority ranking and automated P1/P2/P3 classification
**Files**: sections/05-evaluation.tex

### P1.5: Threshold Sensitivity Not Analyzed
**Action**: Add new subsection "Classification Sensitivity" to Section 4 (Priority Classification). Include:
- Sensitivity curve: P1 score impact as reviewer count threshold varies from 1 to N-1
- Analysis for panel sizes 5, 7, and 9
- Show that threshold=3 is robust (not a lucky choice) or propose adaptive alternative
**Files**: sections/04-priority-classification.tex

### P1.6: Pipeline Reliability and Failure Modes
**Action**: Add new subsection "Failure Mode Analysis" to Section 5. Include:
- Identify 3-5 cases where synthesis was poor or misleading
- Characterize failure patterns (e.g., vague input reviews, edge-case topics)
- Sensitivity analysis: how synthesis quality degrades as input review quality varies
- Report failure rate across 33+ cycles
**Files**: sections/05-evaluation.tex

## P2 Items (Should Address)

### P2.1: Engage with Crowd Aggregation Literature
**Action**: Add subsection "Crowd Aggregation and Answer Quality" to Section 2 (Related Work). Position synthesis pipeline relative to Dawid-Skene, GLAD, spectral methods, and structured crowd workflows.
**Files**: sections/02-related-work.tex

### P2.2: LLM-Specific Biases May Inflate Consensus
**Action**: Add analysis to Section 6 (Discussion). Report issue-type frequency distribution across all reviewers, test whether certain issues appear disproportionately, discuss independence assumption.
**Files**: sections/06-discussion.tex

### P2.3: Missing Operational Metrics
**Action**: Add metrics table to Section 5. Report synthesis document length (avg/range), end-to-end pipeline latency, and compute cost per synthesis.
**Files**: sections/05-evaluation.tex

---

*Revision plan generated from Round 1 synthesis*
