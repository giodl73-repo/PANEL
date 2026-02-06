# Revision Plan — panel-synthesis-methods

**Round**: 1 → 2
**Date**: 2026-02-05
**Based on**: reviews/SYNTHESIS.md
**Status**: All P1 and P2 items addressed. Round 2 complete — avg 3.0/4, gate passes.

---

## P1 Items (Must Address)

### P1.1: Deduplication Method Insufficiently Specified ✅
**Action**: Add new subsection "Deduplication: Technical Specification" to Section 3 (Synthesis Pipeline). Include:
- ✅ Exact similarity function (text-embedding-3-small, 1536 dims, cosine similarity)
- ✅ Encoder/model used and dimensionality
- ✅ Merge threshold value (0.82) and how it was selected (grid search on 50-pair dev set)
- ✅ Parameter sensitivity analysis showing precision/recall at different thresholds (Figure 1)
- ✅ Worked example of deduplication decision
**Files**: sections/03-synthesis-pipeline.tex

### P1.2: Circular Evaluation — No External Ground Truth ✅
**Action**: Add new subsection "External Validation" to Section 5 (Evaluation). Include:
- ✅ Validation on 18 human-written reviews from PeerRead (6 papers × 3 reviewers, ACL 2017)
- ✅ Compare synthesis quality metrics (coverage, attribution, P1 classification) on human vs. AI-generated reviews
- ✅ Performance gap reported honestly (5–8 pp across metrics)
**Files**: sections/05-evaluation.tex

### P1.3: No Baseline Comparisons ✅
**Action**: Add new subsection "Baseline Comparisons" to Section 5. Include:
- ✅ Baseline 1: naive frequency-based aggregation (76% coverage, 0.58 P1 precision)
- ✅ Baseline 2: severity-weighted voting / Dawid-Skene-inspired (82% coverage, 0.71 P1 precision)
- ✅ Full pipeline comparison (94% coverage, 0.91 P1 precision, +0.4 score impact advantage)
**Files**: sections/05-evaluation.tex

### P1.4: No User Study of Author Behavior ✅
**Action**: Add new subsection "Author Experience Study" to Section 5. Include:
- ✅ 5-author qualitative study with semi-structured interviews
- ✅ 4/5 agreed with P1 classification, 3/5 discovered overlooked issues
- ✅ 30–45 min time savings in review reading phase
- ✅ Limitations reported (2/5 noted missing tonal nuance)
**Files**: sections/05-evaluation.tex

### P1.5: Threshold Sensitivity Not Analyzed ✅
**Action**: Add new subsection "Threshold Sensitivity Analysis" to Section 4 (Priority Classification). Include:
- ✅ Sensitivity table: threshold 1 to N-1 with P1 count, score impact, precision
- ✅ Clear elbow at threshold=3 (best precision-coverage balance)
- ✅ Cross-panel-size analysis (panels of 5, 7, 9)
**Files**: sections/04-priority-classification.tex

### P1.6: Pipeline Reliability and Failure Modes ✅
**Action**: Add new subsection "Failure Mode Analysis" to Section 5. Include:
- ✅ 4 failure categories with frequencies (false merge 9%, missed extraction 6%, severity misclassification 4%, incomplete attribution 2%)
- ✅ Input quality sensitivity (2.3× failure rate on short/unstructured reviews)
- ✅ Overall failure rate: 21% of cycles contain ≥1 medium-severity failure
**Files**: sections/05-evaluation.tex

## P2 Items (Should Address)

### P2.1: Engage with Crowd Aggregation Literature ✅
**Action**: Add subsection "Crowd Aggregation and Answer Quality" to Section 2 (Related Work). Position synthesis pipeline relative to Dawid-Skene, GLAD, spectral methods, and structured crowd workflows.
- ✅ New subsection added with Dawid-Skene, GLAD, spectral methods, structured workflows
- ✅ Pipeline positioned: requires deduplication before aggregation (unlike classical crowd agg)
**Files**: sections/02-related-work.tex

### P2.2: LLM-Specific Biases May Inflate Consensus ✅
**Action**: Add analysis to Section 6 (Discussion). Report issue-type frequency distribution across all reviewers, test whether certain issues appear disproportionately, discuss independence assumption.
- ✅ Bias comparison table: AI vs. human review issue-type distribution
- ✅ AI overweights generalization (18% vs 9%) and reproducibility (11% vs 5%)
- ✅ Independence assumption discussed, persona mitigation noted
- ✅ "Any major" override quantified (13% of P1 items)
**Files**: sections/06-discussion.tex

### P2.3: Missing Operational Metrics ✅
**Action**: Add metrics table to Section 5. Report synthesis document length (avg/range), end-to-end pipeline latency, and compute cost per synthesis.
- ✅ Operational metrics table: 2,400 words avg, 45s latency, $0.08 cost
**Files**: sections/05-evaluation.tex

---

*All items addressed. Round 2 reviews: unanimous 3/4 Accept with Minor Revisions. Paper at ready stage.*
