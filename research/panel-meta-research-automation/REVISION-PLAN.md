# Revision Plan: Meta-Research Automation

**Paper**: panel-meta-research-automation
**Round**: 1 → 2
**Date**: 2026-02-07
**Source**: reviews/SYNTHESIS.md

---

## Summary

Round 1 synthesis identifies 5 blocking issues (P1), 4 important improvements (P2), and 12 minor suggestions (P3). Average score: 2.4/4 (weak accept range). All reviewers agree the core contribution is solid (self-referential validation, end-to-end automation) but the evaluation needs strengthening: insufficient sample size (N=5), no failure mode analysis, no ground truth comparison, no content accuracy validation, and no cross-project validation.

**Revision strategy**: Focus on strengthening the evaluation (P1.1-P1.5) by expanding sample size, adding failure mode analysis, comparing to ground truth/baselines, validating content accuracy, and testing on external projects. Then address methodology details (P2.1-P2.4) and human-AI workflow clarification.

---

## Expert Reviewers

| # | Reviewer | Affiliation | Score | Verdict |
|---|---------|-------------|-------|---------|
| 1 | Shreya Shankar | Berkeley | 2/4 | Weak Accept |
| 2 | Percy Liang | Stanford | 2/4 | Weak Accept |
| 3 | Sarah Bird | Microsoft | 2/4 | Weak Accept |
| 4 | Sumit Gulwani | Microsoft Research | 3/4 | Accept |
| 5 | Michael Bernstein | Stanford | 3/4 | Accept |

---

## P1: Must Complete (Blocking)

### P1.1: Insufficient Evaluation — Sample Size Too Small (N=5)
**Source**: P1.1 in SYNTHESIS.md
**Raised by**: Shreya Shankar, Percy Liang, Sarah Bird
**Action**:
- [ ] Expand evaluation to 15-20 papers across multiple projects (waves, boost, merit, external codebases) OR
- [ ] Reframe paper as "feasibility study" with preliminary results and explicitly call for future validation
- [ ] Add confidence intervals to all quantitative metrics (87% ± 26% precision)
- [ ] Report statistical power analysis (sample size needed to detect meaningful differences)
**Target section**: sections/04-results.tex (new subsection 4.1 "Evaluation Design")
**Estimated effort**: 2-3 weeks (Option A) or 2-3 days (Option B)

### P1.2: No Failure Mode Analysis or Robustness Evaluation
**Source**: P1.2 in SYNTHESIS.md
**Raised by**: Shreya Shankar (M1), Sarah Bird (M1)
**Action**:
- [ ] Add Section 4.4 "Failure Modes and Recovery" with:
  - Failure taxonomy (syntax errors, structural errors, content inaccuracies, citation errors)
  - Detection mechanisms (compilation logs, validation scripts, human review checkpoints)
  - Recovery strategies (auto-fix for syntax, retry with different prompt, flag for human review)
  - Honest reporting of manual intervention (if any was required for the 5 papers)
- [ ] Report actual failure rates (how many generation attempts per successful paper)
**Target section**: sections/04-results.tex (new subsection 4.4)
**Estimated effort**: 3-4 days

### P1.3: No Ground Truth or Baseline Comparison
**Source**: P1.3 in SYNTHESIS.md
**Raised by**: Percy Liang (M1, M4), Shreya Shankar (M2), Michael Bernstein (m1)
**Action**:
- [ ] Add Section 4.6 "Ground Truth Comparison":
  - Manually author 1-2 papers from the same artifacts (baseline)
  - Compare factual accuracy, coverage (% of relevant commits cited), correctness of quantitative claims
  - Report differences: what does human-authored paper include that automated paper misses? vice versa?
- [ ] Add Section 4.7 "Baseline Comparison":
  - Compare to manual authoring (time: 20-40 hours vs. 2-5 hours?)
  - Compare to template-based generation (quality, flexibility)
  - Ablation study: remove topic discovery or evidence extraction, measure impact
**Target section**: sections/04-results.tex (new subsections 4.6, 4.7)
**Estimated effort**: 1-2 weeks

### P1.4: Missing Content Accuracy Validation
**Source**: P1.4 in SYNTHESIS.md
**Raised by**: Sarah Bird (M2), Percy Liang (implicit)
**Action**:
- [ ] Add Section 4.4 "Content Accuracy Validation":
  - Fact-checking protocol: Cross-reference all quantitative claims with source artifacts
  - Sample 20% of claims (out of 23×5 = 115 claims), manually verify correctness
  - Report error rate (hallucinated numbers, misattributed contributions, incorrect causal claims)
  - Correction mechanisms: Flag low-confidence claims, require human verification
- [ ] Discuss risks: hallucinated numbers, out-of-context quotes, correlation ≠ causation errors
**Target section**: sections/04-results.tex (expand 4.4)
**Estimated effort**: 3-4 days

### P1.5: No Cross-Project Validation
**Source**: P1.5 in SYNTHESIS.md
**Raised by**: Shreya Shankar (M2), Percy Liang (M2)
**Action**:
- [ ] Add Section 4.5 "Cross-Project Validation":
  - Generate papers for 2-3 external projects: waves plugin, boost plugin, merit plugin
  - Compare success/failure rates across projects
  - Analyze what project characteristics affect success (wave structure? commit conventions? design docs?)
  - Report generalization findings: does the approach work outside panel ecosystem?
**Target section**: sections/04-results.tex (new subsection 4.5)
**Estimated effort**: 1-2 weeks

---

## P2: Should Complete (Important)

### P2.1: Insufficient Detail on Evidence Extraction Methodology
**Source**: P2.1 in SYNTHESIS.md
**Raised by**: Shreya Shankar (M3), Percy Liang (implicit)
**Action**:
- [ ] Expand Section 3.2 "Evidence Extraction" with:
  - Embedding model specification (e.g., sentence-transformers/all-MiniLM-L6-v2)
  - Threshold tuning methodology: precision/recall curve, justify threshold 0.7
  - Precision/recall analysis for evidence extraction
  - Error analysis: examples of false positives (irrelevant artifacts) and false negatives (missed artifacts)
**Target section**: sections/03-methodology.tex (expand 3.2)
**Estimated effort**: 2-3 days

### P2.2: Missing Inter-Rater Reliability for Readability Scores
**Source**: P2.2 in SYNTHESIS.md
**Raised by**: Percy Liang (M3), Sarah Bird (implicit)
**Action**:
- [ ] Add Section 4.3 "Readability Evaluation Protocol":
  - Recruit 3+ independent raters (not paper authors)
  - Define rubric: clarity (1-10), flow (1-10), technical depth (1-10), coherence (1-10)
  - Report inter-rater reliability (ICC or Krippendorff's alpha)
  - If α < 0.6, acknowledge low reliability and interpret scores cautiously
**Target section**: sections/04-results.tex (new subsection 4.3)
**Estimated effort**: 1 week

### P2.3: Unclear Human-AI Division of Labor
**Source**: P2.3 in SYNTHESIS.md
**Raised by**: Michael Bernstein (M1), Sarah Bird (m1)
**Action**:
- [ ] Add Section 3.4 "Human-AI Division of Labor":
  - Task allocation table: Which tasks are automated (✓) vs. human (○)?
    - Topic discovery: Automated proposal + human selection
    - Evidence extraction: Automated + human review
    - Paper generation: Automated structure + content
    - Post-editing: Human review + revision
  - Workflow diagram showing human intervention points
  - Time analysis: Human time spent per task (topic selection: 10 min, post-editing: 2 hours)
**Target section**: sections/03-methodology.tex (new subsection 3.4)
**Estimated effort**: 2-3 days

### P2.4: Missing Ethics and Responsible Use Discussion
**Source**: P2.4 in SYNTHESIS.md
**Raised by**: Sarah Bird (M3), Percy Liang (implicit)
**Action**:
- [ ] Add Section 5.4 "Ethics and Responsible Use":
  - Authorship attribution: Generated papers should credit human authors + AI disclosure
  - Academic integrity: Check venue policies on AI-generated content
  - Misrepresentation risk mitigation: Require human review, fact-checking
  - Responsible use guidelines: Use for internal drafts, not final submissions without human review
- [ ] Discuss risks: hallucinated claims, misattributed contributions, credit and fairness
**Target section**: sections/05-discussion.tex (new subsection 5.4)
**Estimated effort**: 2-3 days

---

## P3: Nice to Have

### P3.1: Clarify Relationship to Program Synthesis
**Source**: P3.1 in SYNTHESIS.md
**Raised by**: Sumit Gulwani (M1)
- [ ] Add Section 2.1 "Relationship to Program Synthesis": Clarify this is RAG-based generation (retrieve artifacts, generate with LLM), not search-based synthesis (Sketch, FlashFill)

### P3.2: Missing Discussion of Multi-Solution Synthesis
**Source**: P3.2 in SYNTHESIS.md
**Raised by**: Sumit Gulwani (M2)
- [ ] Add Section 5.3 "Multi-Solution Synthesis": Same artifacts → multiple papers (different venues, narratives, structures). Discuss user control mechanisms.

### P3.3: Missing Comparison to Template-Based Generation
**Source**: P3.3 in SYNTHESIS.md
**Raised by**: Sumit Gulwani (m1)
- [ ] Add Section 4.7 "Comparison to Template-Based Generation": Compare quality, flexibility, time

### P3.4: Missing Discussion of Iterative Refinement
**Source**: P3.4 in SYNTHESIS.md
**Raised by**: Michael Bernstein (m2)
- [ ] Add Section 5.3 "Iterative Refinement": Section-level regeneration, feedback mechanisms

### P3.5: Missing Discussion of Human Post-Editing Requirements
**Source**: P3.5 in SYNTHESIS.md
**Raised by**: Shreya Shankar (m2), Sarah Bird (m1), Michael Bernstein (implicit)
- [ ] Add discussion in Section 5.2 (Limitations): Which sections need editing? Time spent?

### P3.6: Missing Comparison to Automated Documentation Tools
**Source**: P3.6 in SYNTHESIS.md
**Raised by**: Shreya Shankar (m1)
- [ ] Expand Section 2 (Related Work): Include automated documentation tools (Copilot, code2docs, readme generators)

### P3.7: Missing Discussion of Generalization to Other Domains
**Source**: P3.7 in SYNTHESIS.md
**Raised by**: Sumit Gulwani (m2)
- [ ] Add Section 5.4 "Generalization to Other Domains": Systems (OSDI), NLP (ACL), HCI (CHI)

### P3.8: Unclear Venue Target Matching Algorithm
**Source**: P3.8 in SYNTHESIS.md
**Raised by**: Shreya Shankar (m3)
- [ ] Add Section 3.1.1 "Venue Matching Algorithm": Explain how venues are matched (keyword? semantic similarity?)

### P3.9: No Discussion of Topic Discovery Precision Metric Details
**Source**: P3.9 in SYNTHESIS.md
**Raised by**: Percy Liang (m1)
- [ ] Add Section 4.2 "Topic Discovery Evaluation": Total topics, assessment protocol, precision calculation

### P3.10: Missing Error Analysis
**Source**: P3.10 in SYNTHESIS.md
**Raised by**: Percy Liang (m2)
- [ ] Add Section 4.8 "Error Analysis": False positive examples, low readability sections

### P3.11: No Discussion of Bias in Topic Discovery
**Source**: P3.11 in SYNTHESIS.md
**Raised by**: Sarah Bird (m2)
- [ ] Add discussion in Section 5.3 (Limitations): Subjectivity in "research-worthy", potential biases

### P3.12: Missing Discussion of Environmental Cost
**Source**: P3.12 in SYNTHESIS.md
**Raised by**: Sarah Bird (m3)
- [ ] Add brief discussion in Section 5.3 (Limitations): Compute cost, energy, carbon emissions

---

## Revision Timeline

**Option A: Comprehensive revision (addresses all P1 items with expanded evaluation)**

| Week | Focus | Deliverable |
|------|-------|-------------|
| 1-2 | P1.1 — Expand evaluation (15-20 papers, cross-project) | New evaluation dataset |
| 3 | P1.3 — Ground truth comparison (human-author 2 papers) | Baseline papers |
| 4 | P1.2, P1.4 — Failure modes + content accuracy validation | Sections 4.4 |
| 5 | P2.1-P2.4 — Methodology details + human-AI workflow | Sections 3.2, 3.4, 5.4 |
| 6 | P3 items + polish | Final cleanup |

**Option B: Feasibility study reframe (addresses P1 items without expanded evaluation)**

| Week | Focus | Deliverable |
|------|-------|-------------|
| 1 | P1.1 — Reframe as feasibility study, add confidence intervals | Updated introduction + results |
| 2 | P1.2, P1.4 — Failure modes + content accuracy | Section 4.4 |
| 3 | P1.3 — Ground truth comparison (1 paper) + baseline comparison | Sections 4.6, 4.7 |
| 4 | P2.1-P2.4 — Methodology + human-AI + ethics | Sections 3.2, 3.4, 5.4 |
| 5 | P3 items + polish | Final cleanup |

---

## Quality Gates

- [ ] All P1 items addressed (5 blocking issues resolved)
- [ ] Paper rebuilds without LaTeX errors
- [ ] All quantitative claims verified against source artifacts
- [ ] Within page limit (typically 10-12 pages for MSR/ICSE-NIER)
- [ ] All reviewer questions answered in text or footnotes
- [ ] AI disclosure footer present in all generated content

---

*Begin revision work. Address P1 items first (evaluation strengthening), then P2 (methodology details), then P3 if time permits.*
