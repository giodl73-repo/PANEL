# Revision Plan — panel-reviewer-calibration (Round 1)

**Date**: 2026-02-05
**Average Score**: 2.4/4 (Major Revisions Required)
**Target**: Address all P1 items, key P2 items

---

## P1 Items (Blocking — Must Address)

### P1.1: No Ground Truth or Validation Against Human Reviews
**Status**: NOT ADDRESSED
**Action items**:
- [ ] Collect published inter-reviewer agreement statistics from EMNLP/ACL (e.g., from ARR reports)
- [ ] Compare AI panel score distributions against real venue statistics
- [ ] If feasible: obtain real OpenReview reviews for 2-3 papers and compare patterns
- [ ] At minimum: expand evaluation corpus to include papers from other authors/domains
**Sections affected**: Section 4 (Calibration Analysis), Section 6 (Discussion)

### P1.2: Insufficient Statistical Methodology
**Status**: NOT ADDRESSED
**Action items**:
- [ ] Add Krippendorff's alpha and/or ICC to Section 5 alongside Spearman's rho
- [ ] Report confidence intervals for all pairwise correlations
- [ ] Add random baseline for JS divergence (permutation test or null model)
- [ ] Document clustering methodology: distance metric, linkage criterion, cluster count justification (silhouette scores)
- [ ] Add significance tests for key comparisons
**Sections affected**: Section 4.2 (Bloc Formation), Section 5 (Distinctness Metrics)

### P1.3: Limited Technical Novelty — No Comparison with Alternative Approaches
**Status**: NOT ADDRESSED
**Action items**:
- [ ] Implement and evaluate at least one alternative: retrieval-augmented persona construction (using reviewer's actual papers) OR automatic prompt optimization (using calibration quality indicators as objective)
- [ ] Compare: baseline (no persona) → structured profile → structured profile + alternative → full method
- [ ] Frame as a contribution: either the comparison itself is informative, or the best method becomes the new contribution
**Sections affected**: Section 3 (Persona Construction), new Section 5 or expanded Section 4

### P1.4: Missing Error Analysis of Calibration Failures
**Status**: NOT ADDRESSED
**Action items**:
- [ ] Identify all persona-paper combinations where calibration quality indicators failed
- [ ] Categorize failures by: expertise category, paper topic, which indicator(s) failed
- [ ] Analyze patterns: are failures concentrated in specific categories or on specific papers?
- [ ] Report failure breakdown in a table
**Sections affected**: New subsection in Section 4 or Section 5

---

## P2 Items (Important — Should Address)

### P2.1: Progressive Profile Field Ablation
**Action items**:
- [ ] Run ablation: name → +affiliation → +expertise → +key question → +venue
- [ ] Measure distinctness (rho, JS divergence) at each step
- [ ] Report as table/figure showing marginal contribution of each field

### P2.2: Distinctness vs. Quality Assessment
**Action items**:
- [ ] Develop review quality rubric (are major issues valid? actionable? paper-specific?)
- [ ] Rate a sample of reviews on quality
- [ ] Show correlation (or independence) between distinctness and quality

### P2.3: Full Prompt Template in Appendix
**Action items**:
- [ ] Add appendix with verbatim prompt template
- [ ] Include generation hyperparameters (temperature, top-p, max tokens, model)

---

## P3 Items (Nice-to-Have — Address if Time Permits)

| ID | Item | Effort |
|----|------|--------|
| P3.1 | Report generation hyperparameters | Low |
| P3.2 | Venue alignment analysis | Medium |
| P3.3 | Justify panel composition thresholds | Low |
| P3.4 | Key question specificity scale | Medium |
| P3.5 | Panel size saturation analysis | Medium |
| P3.6 | Prompt robustness / sensitivity | Medium |
| P3.7 | Add missing related work citations | Low |
| P3.8 | Category coverage analysis | Medium |

---

## Revision Sequence

1. **Statistical methodology** (P1.2) — foundational, affects all quantitative claims
2. **Error analysis** (P1.4) — straightforward, high information value
3. **Alternative approach comparison** (P1.3) — highest effort, highest impact
4. **External validation** (P1.1) — depends on data availability
5. **Progressive ablation** (P2.1) — natural extension of existing experiments
6. **Quality assessment** (P2.2) — new evaluation dimension
7. **Reproducibility appendix** (P2.3) — low effort, high value

---

*Generated from Round 1 synthesis — see reviews/SYNTHESIS.md*
