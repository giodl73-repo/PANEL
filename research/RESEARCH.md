# Panel Research Papers

**Module**: Panel (AI-Simulated Expert Review Methodology)
**Papers**: 10
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
| 6 | [panel-hierarchical-review-architecture](panel-hierarchical-review-architecture/) | Hierarchical Review Architecture: Scaling Expert Feedback Through Three-Tier Synthesis | [PDF](docs/panel-hierarchical-review-architecture.pdf) | ICSE / FSE / OOPSLA | — | — |
| 7 | [panel-closed-loop-automation](panel-closed-loop-automation/) | From Reviews to Revisions: Closed-Loop Automation of Academic Paper Improvement | [PDF](docs/panel-closed-loop-automation.pdf) | CHI / CSCW / HCOMP | — | — |
| 8 | [panel-meta-research-automation](panel-meta-research-automation/) | Meta-Research Automation: Generating Research Papers from Development Artifacts | [PDF](docs/panel-meta-research-automation.pdf) | MSR / ICSE-NIER / Empirical SE | — | — |
| 9 | [panel-research-quality-impact](panel-research-quality-impact/) | Panel-Driven Research Quality Impact: Comparing Traditional and AI-Simulated Expert Review | [PDF](docs/panel-research-quality-impact.pdf) | CSCW / CHI | — | — |
| 10 | [panel-reviewer-profiles](panel-reviewer-profiles/) | Token-Efficient Persona Simulation: Persistent Profiles for AI-Simulated Expert Reviews | [PDF](docs/panel-reviewer-profiles.pdf) | EMNLP Demo | — | — |

---

## Paper Dependency Graph

```
[1] Review Methodology (foundational)
     |
     +──→ [2] Reviewer Calibration
     |
     +──→ [3] Revision Dynamics
     |         |
     |         +──→ [7] Closed-Loop Automation
     |         |
     |         +──→ [9] Research Quality Impact
     |         |
     |         v
     +──→ [4] Portfolio Assessment
     |         |
     |         v
     +──→ [6] Hierarchical Review Architecture
     |
     +──→ [5] Synthesis Methods
                |
                v
           [8] Meta-Research Automation
```

### Dependency Table

| Paper | Depends On | Depended On By |
|-------|-----------|----------------|
| #1 Review Methodology | — (foundational) | #2, #3, #4, #5, #6 |
| #2 Reviewer Calibration | #1 | — |
| #3 Revision Dynamics | #1 | #4, #7, #9 |
| #4 Portfolio Assessment | #1, #3 | #6 |
| #5 Synthesis Methods | #1 | #8 |
| #6 Hierarchical Review Architecture | #1, #4 | — |
| #7 Closed-Loop Automation | #1, #3 | — |
| #8 Meta-Research Automation | #5 | — (self-referential) |
| #9 Research Quality Impact | #1, #3 | — |

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

### Paper 6: Hierarchical Review Architecture

**Core contribution**: Three-tier review architecture (paper/panel/board) with bidirectional flow and priority escalation (P1→PP1→B1). Enables cross-cutting pattern detection and strategic coordination across multi-module research programs.

**Key evidence**: 14 papers across 3 modules, 37% of PP1 and 52% of B1 priorities are emergent patterns not visible at lower tiers, 31% reduction in review cycles through hierarchical synthesis.

### Paper 7: Closed-Loop Automation

**Core contribution**: End-to-end automation bridging review generation and revision implementation. System parses REVISION-PLAN.md and applies edits directly to LaTeX source using structured code transformation.

**Key evidence**: 78% P1 completion rate (automated), 64% reduction in author revision time, 94% edit acceptance rate, 91% LaTeX compilation success on first attempt.

### Paper 8: Meta-Research Automation

**Core contribution**: Generating research papers from development artifacts (commits, waves, design docs). Three-phase pipeline: topic discovery → evidence extraction → paper generation.

**Key evidence**: 90% topic discovery precision, 100% LaTeX compilation success, 6000+ words per generated paper, 8.2/10 readability, self-referential validation (this paper documents the system that generated it).

### Paper 9: Research Quality Impact

**Core contribution**: Empirical comparison of traditional Claude-assisted research (user-directed) vs. panel-driven methodology using papers from the apportionment project. Shows +127% quality improvement across 10 dimensions through four mechanisms: systematic questioning, embracing negative results, standards elevation, and iteration forcing.

**Key evidence**: Within-project natural experiment (3 traditional papers vs. 1 panel-driven paper), comparative analysis across 10 quality dimensions, process tracing through git history and session notes, role dynamics characterization (user as director vs. facilitator), breakthrough innovation trajectory analysis (edge-weighting and 42% threshold emerged through panel-driven failure exploration).

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
| #6 Hierarchical Review Architecture | draft | 0 | — | — | — |
| #7 Closed-Loop Automation | draft | 0 | — | — | — |
| #8 Meta-Research Automation | draft | 0 | — | — | — |
| #9 Research Quality Impact | draft | 0 | — | — | — |
| #10 Reviewer Profiles | draft | 0 | — | — | — |

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
*Papers: 10 (all in draft stage)*
*Last updated: February 15, 2026 — added paper #10 (Reviewer Profiles)*
