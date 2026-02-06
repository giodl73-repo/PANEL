# Panel Research Papers

**Module**: Panel (AI-Simulated Expert Review Methodology)
**Papers**: 5
**Author**: Gio Della-Libera

---

## Paper Inventory

| # | Directory | Title | PDF | Venue Target | Score | Tier |
|---|-----------|-------|-----|-------------|-------|------|
| 1 | [panel-review-methodology](panel-review-methodology/) | AI-Simulated Expert Review: A Methodology for Pre-Submission Paper Assessment | [PDF](docs/panel-review-methodology.pdf) | CHI / CSCW | — | — |
| 2 | [panel-reviewer-calibration](panel-reviewer-calibration/) | Calibrating AI Reviewer Personas: Domain Expertise Simulation Without Fine-Tuning | [PDF](docs/panel-reviewer-calibration.pdf) | EMNLP / ACL | — | — |
| 3 | [panel-revision-dynamics](panel-revision-dynamics/) | Multi-Round Revision Dynamics: Measuring Paper Quality Improvement Through Iterative AI Review | [PDF](docs/panel-revision-dynamics.pdf) | NeurIPS D&B | — | — |
| 4 | [panel-portfolio-assessment](panel-portfolio-assessment/) | Cross-Portfolio Expert Panels: Holistic Assessment of Multi-Paper Research Programs | [PDF](docs/panel-portfolio-assessment.pdf) | JCDL / Scientometrics | — | — |
| 5 | [panel-synthesis-methods](panel-synthesis-methods/) | From Reviews to Revisions: Automated Synthesis and Priority Classification of Expert Feedback | [PDF](docs/panel-synthesis-methods.pdf) | AAAI / IJCAI | — | — |

---

## Paper Dependency Graph

```
[1] Review Methodology (foundational)
     |
     +──→ [2] Reviewer Calibration
     |
     +──→ [3] Revision Dynamics
     |         |
     |         v
     +──→ [4] Portfolio Assessment
     |
     +──→ [5] Synthesis Methods
```

### Dependency Table

| Paper | Depends On | Depended On By |
|-------|-----------|----------------|
| #1 Review Methodology | — (foundational) | #2, #3, #4, #5 |
| #2 Reviewer Calibration | #1 | — |
| #3 Revision Dynamics | #1 | #4 |
| #4 Portfolio Assessment | #1, #3 | — |
| #5 Synthesis Methods | #1 | — |

---

## Paper Summaries

### Paper 1: AI-Simulated Expert Review (Foundational)

**Core contribution**: The 8-stage review lifecycle methodology with evidence from 14 papers across merit, waves, and basecamp modules. Describes the complete process: reviewer persona construction, structured review generation, synthesis with P1/P2/P3 classification, iterative revision, and cross-portfolio panel assessment.

**Key evidence**: 14 papers, 186+ reviews, 33+ review cycles, score improvement from 5.6/10 to 7.4/10 (+32%).

### Paper 2: Reviewer Calibration

**Core contribution**: How reviewer personas are constructed from real expert profiles (45+ researchers, 10 categories) and calibrated to produce distinct, expertise-consistent feedback without fine-tuning.

**Key evidence**: Pairwise Spearman correlations showing 3 distinct blocs (ρ = 0.05 to 0.80), key-question prompting as strongest calibration signal.

### Paper 3: Revision Dynamics

**Core contribution**: Empirical study of score trajectories across review rounds. P1 items account for 72% of score improvement, 85% of papers reach threshold within 2 rounds, diminishing returns after round 2.

**Key evidence**: 14 papers × 2-4 rounds, logarithmic improvement curve, P1/P2/P3 impact decomposition.

### Paper 4: Portfolio Assessment

**Core contribution**: Cross-portfolio panel methodology — 7 reviewers ranking paper collections, identifying themes invisible at the individual paper level.

**Key evidence**: 13 papers across 2 modules, 6 cross-cutting themes identified, structured disagreement analysis (3 reviewer blocs).

### Paper 5: Synthesis Methods

**Core contribution**: The automated synthesis pipeline — issue extraction, cross-reviewer deduplication, P1/P2/P3 priority classification.

**Key evidence**: 33+ review cycles, 91% deduplication precision, 94% issue coverage, P1 captures 72% of improvement.

---

## Cross-Module Context

The panel module documents the review methodology used across the research monorepo:

| Module | Papers | Review Cycles | Evidence Used In |
|--------|--------|--------------|-----------------|
| Merit | 9 | 18+ | Papers #1, #2, #3, #4, #5 |
| Waves | 4 | 8+ | Papers #1, #2, #3, #4, #5 |
| Basecamp | 1 | 4 | Papers #1, #3 |
| **Total** | **14** | **30+** | |

---

## Review Status

| Paper | Stage | Round | Reviewers | Score | Verdict |
|-------|-------|-------|-----------|-------|---------|
| #1 Review Methodology | draft | 0 | — | — | — |
| #2 Reviewer Calibration | draft | 0 | — | — | — |
| #3 Revision Dynamics | draft | 0 | — | — | — |
| #4 Portfolio Assessment | draft | 0 | — | — | — |
| #5 Synthesis Methods | draft | 0 | — | — | — |

---

## Build

```bash
make all          # Build all papers
make dist         # Copy PDFs to docs/
make clean        # Remove build artifacts

# Single paper
make -C panel-review-methodology pdf
```

---

*Panel research module — established February 2026*
*Papers: 5 (all in draft stage)*
