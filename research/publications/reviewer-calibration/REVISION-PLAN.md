# Revision Plan — panel-reviewer-calibration (Round 1 → Round 2)

**Date**: 2026-02-05
**Round 1 Average Score**: 2.4/4 (Major Revisions Required)
**Round 2 Average Score**: 3.2/4 (Accept with Minor Revisions)
**Target**: Address all P1 items, key P2 items

---

## P1 Items (Blocking — Must Address)

### P1.1: No Ground Truth or Validation Against Human Reviews
**Status**: ADDRESSED
**What was done**:
- [x] Collected published inter-reviewer agreement statistics from EMNLP/ACL (ARR reports, Shah et al. 2022, Stelmakh et al. 2021)
- [x] Compared AI panel score distributions against real venue statistics (Table 4 in Section 4.5)
- [x] Showed distributional alignment: mean scores, variance, pairwise agreement ranges all comparable
- [ ] ~~Obtain real OpenReview reviews~~ — deferred to future work (requires venue submission)
- [ ] ~~Expand corpus to other authors~~ — deferred to future work
**Sections modified**: Section 4 (new subsection 4.5: External Validation Against Venue Statistics)

### P1.2: Insufficient Statistical Methodology
**Status**: ADDRESSED
**What was done**:
- [x] Added Krippendorff's alpha (0.41, 95% CI: [0.34, 0.48]) and ICC (0.38, 95% CI: [0.30, 0.46])
- [x] Reported confidence intervals via bootstrap resampling (n=1000)
- [x] Added random baseline for JS divergence (permutation null model, p < 0.001 for within-bloc)
- [x] Documented clustering methodology: Ward's linkage, 1-|ρ| distance, silhouette analysis (0.71 for 3 clusters)
- [x] Added significance context for key comparisons
**Sections modified**: Section 5 (new subsection: Inter-Rater Reliability)

### P1.3: Limited Technical Novelty — No Comparison with Alternative Approaches
**Status**: ADDRESSED
**What was done**:
- [x] Four-method comparison: no persona → name+affiliation → full structured profile → retrieval-augmented
- [x] Progressive ablation: name → +affiliation → +expertise → +key question → +venue
- [x] Key finding: structured profiles capture 92% of retrieval-augmented benefit; key-question is dominant mechanism (+0.15 JS div)
**Sections modified**: Section 5 (new subsection: Comparison with Alternative Approaches)

### P1.4: Missing Error Analysis of Calibration Failures
**Status**: ADDRESSED
**What was done**:
- [x] Identified all 5 failing personas (11% of 45+)
- [x] Categorized by: expertise category, which indicator failed, pattern
- [x] Two failure modes: domain mismatch (Security, Compilers) and profile under-specification (broad tags, no key question)
- [x] Practical implication: match expertise to paper content, not just panel diversity
**Sections modified**: Section 4 (new subsection 4.6: Calibration Failure Analysis)

---

## P2 Items (Important — Should Address)

### P2.1: Progressive Profile Field Ablation
**Status**: ADDRESSED
**What was done**:
- [x] Progressive ablation: name (|ρ|=0.81) → +affiliation (0.72) → +expertise (0.58) → +key question (0.42) → +venue (0.40)
- [x] Marginal contributions: affiliation +0.08, expertise +0.12, key question +0.15, venue +0.02
**Sections modified**: Section 5 (within Alternative Approaches subsection)

### P2.2: Distinctness vs. Quality Assessment
**Status**: ADDRESSED
**What was done**:
- [x] Quality rubric: valid, actionable, paper-specific (40-review sample)
- [x] High-distinctness reviewers: equally valid (78%), equally actionable (72%), more paper-specific (81% vs 65%)
**Sections modified**: Section 6 (new subsection: Distinctness vs. Quality)

### P2.3: Full Prompt Template in Appendix
**Status**: ADDRESSED
**What was done**:
- [x] Verbatim prompt template in Section 6 (Reproducibility subsection)
- [x] Model: Claude Sonnet 4.5, temperature 1.0, ~1200 tokens/review
**Sections modified**: Section 6 (new subsection: Reproducibility)

---

## P3 Items (Nice-to-Have)

| ID | Item | Status |
|----|------|--------|
| P3.1 | Report generation hyperparameters | ADDRESSED (in Reproducibility) |
| P3.2 | Venue alignment analysis | Deferred |
| P3.3 | Justify panel composition thresholds | Deferred |
| P3.4 | Key question specificity scale | Partially addressed (progressive ablation) |
| P3.5 | Panel size saturation analysis | Deferred |
| P3.6 | Prompt robustness / sensitivity | Deferred |
| P3.7 | Add missing related work citations | ADDRESSED (ChatEval, PandaLM, peer review lit) |
| P3.8 | Category coverage analysis | Partially addressed (failure analysis) |

---

## Round 2 Outcome

All 5 reviewers Accept (3/4 or 4/4). Average 3.2/4. Gate passed → **ready** stage.

**Remaining minor items** (for camera-ready):
- Temperature sensitivity analysis
- Cross-domain generalizability discussion
- Panel composition rule justification
- Expand method comparison to more papers

---

*Updated after Round 2 recheck — see reviews/ROUND2-SYNTHESIS.md*
