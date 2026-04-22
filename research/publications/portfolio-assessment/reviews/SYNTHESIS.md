# Review Synthesis — Cross-Portfolio Expert Panels

**Paper**: panel-portfolio-assessment
**Round**: 1
**Date**: 2026-02-05
**Reviewers**: 5

---

## Overview

| Metric | Value |
|--------|-------|
| Average Score | 2.4/4 |
| Score Range | 2-3/4 |
| Consensus | Moderate (σ = 0.49) |
| Overall Verdict | Major Revisions Required |

## Score Distribution

| Reviewer | Affiliation | Score | Verdict |
|----------|-------------|-------|---------|
| Percy Liang | Stanford | 3/4 | Accept with Minor Revisions |
| Michael Bernstein | Stanford | 2/4 | Major Revisions Required |
| Ben Shneiderman | UMD | 2/4 | Major Revisions Required |
| Shreya Shankar | Berkeley | 2/4 | Major Revisions Required |
| Ludwig Schmidt | UW | 3/4 | Accept with Minor Revisions |

---

## Priority 1: Blocking Issues

Issues that must be addressed before resubmission. Raised by 3+ reviewers or flagged as major by any reviewer.

### P1.1: No Calibration or Validation Against Real Expert Panels
**Raised by**: Percy Liang, Ben Shneiderman, Ludwig Schmidt
**Description**: The paper presents AI-simulated panel results without any comparison to human expert panels. The structured disagreement patterns (reviewer blocs with ρ = 0.05-0.30 between blocs) may reflect prompt engineering rather than genuine disciplinary perspectives. Without calibration, the epistemic status of all findings is uncertain.
**Impact**: Undermines the core contribution—if simulated disagreement doesn't correspond to real disciplinary differences, the methodology's value proposition collapses.
**Recommended action**: (a) Conduct a small-scale human calibration study with 2-3 real experts. (b) Add explicit discussion of what AI-simulated disagreement represents versus genuine expert disagreement. (c) Frame findings with appropriate epistemic humility.

### P1.2: Missing Uncertainty Quantification and Robustness Analysis
**Raised by**: Ludwig Schmidt, Percy Liang, Shreya Shankar
**Description**: Rankings are presented as point estimates without confidence intervals. With 7 reviewers and score variance σ = 0.50-1.03, adjacent papers are within one standard error. Tier classifications may be noise artifacts. No test-retest reliability, no sensitivity analysis on tier thresholds.
**Impact**: Rankings and tier classifications—the paper's primary outputs—may not be statistically meaningful.
**Recommended action**: (a) Add bootstrap confidence intervals on all rankings. (b) Include sensitivity analysis for tier thresholds. (c) Show full score distributions (box/violin plots). (d) Report test-retest reliability.

### P1.3: No Comparison Against Simpler Baselines
**Raised by**: Michael Bernstein, Percy Liang, Shreya Shankar
**Description**: The paper doesn't compare portfolio-level panel assessment against simpler alternatives: averaging individual paper review scores, simpler aggregation methods (median, trimmed mean), or automated bibliometric approaches. Without baselines, it's unclear whether the added complexity of cross-portfolio panels is justified.
**Impact**: Cannot assess the marginal value of the methodology over simpler alternatives.
**Recommended action**: (a) Compute rankings from aggregated individual review scores as a baseline. (b) Compare panel rankings against this baseline. (c) Identify which insights (themes, strategic recommendations) are unique to the portfolio-level process.

### P1.4: Human-in-the-Loop Design Missing
**Raised by**: Ben Shneiderman, Michael Bernstein
**Description**: The methodology is fully automated with no specification of where human judgment enters. For JCDL/Scientometrics—venues concerned with research practice—this is a significant gap. No appeals mechanism, no contestation process, no quality assurance for panel outputs.
**Impact**: A research assessment methodology that removes human agency from assessment contradicts the paper's own finding (Theme 5: Human Dimensions Deficit).
**Recommended action**: (a) Add a section on human-in-the-loop panel design. (b) Specify where human judgment is essential vs. automatable. (c) Design an appeals/contestation mechanism. (d) Consider a hybrid AI-generates/human-validates approach.

---

## Priority 2: Important Improvements

Issues that would significantly strengthen the paper. Raised by 2+ reviewers.

### P2.1: Deeper Engagement with Related Assessment Literature
**Raised by**: Percy Liang, Michael Bernstein
**Description**: The related work section is thin, covering only three areas briefly. Missing engagement with: grant panel processes (NIH study sections), UK REF methodology, judgment aggregation literature (Dawid-Skene, GLAD), crowdsourcing quality control, and scientometrics on research group evaluation.
**Recommended action**: Expand related work to 2-3 pages engaging with these literatures. Position the contribution relative to established assessment methodologies.

### P2.2: Panel Process Analysis and Failure Modes
**Raised by**: Michael Bernstein, Shreya Shankar
**Description**: The paper treats the panel as a straightforward aggregation mechanism without discussing process effects (ordering, anchoring, composition sensitivity) or failure modes (inconsistent personas, score drift, position effects).
**Recommended action**: (a) Add a failure mode analysis. (b) Discuss ordering and anchoring effects. (c) Include an ablation study varying panel composition.

### P2.3: Operationalization Details
**Raised by**: Shreya Shankar, Michael Bernstein
**Description**: The methodology lacks operational details for replication: runtime, compute costs, parameter sensitivity, data pipeline, version control of assessment parameters. The strategic priority ranking method (Section 5.3) is unspecified.
**Recommended action**: Add an operationalization section with practical replication details. Specify the strategic priority ranking method.

---

## Priority 3: Minor Suggestions

Suggestions from individual reviewers. Address if time permits.

### P3.1: Inconsistent Paper Count
**Raised by**: Percy Liang
**Suggestion**: Introduction says "13 papers total" but Discussion mentions "14 papers, 2 modules." Resolve the inconsistency.

### P3.2: Panel Size Justification
**Raised by**: Michael Bernstein
**Suggestion**: Justify the choice of 7 reviewers with reference to the optimal jury size literature.

### P3.3: Consensus Metric Relationship to Standard Measures
**Raised by**: Ludwig Schmidt
**Suggestion**: Relate the σ-based consensus metric to established agreement measures (Krippendorff's alpha, Fleiss' kappa).

### P3.4: Theme Identification Method
**Raised by**: Ludwig Schmidt
**Suggestion**: Describe the process for extracting cross-cutting themes. Is it qualitative coding, reviewer mention counting, or another method?

### P3.5: Score Aggregation Method Justification
**Raised by**: Shreya Shankar
**Suggestion**: Justify using mean over median or trimmed mean for score aggregation.

### P3.6: Cross-Module Board Composition Asymmetry
**Raised by**: Michael Bernstein
**Suggestion**: Discuss how asymmetric familiarity (3 reviewers on both panels, 4 on one) affects scoring patterns.

---

## Areas of Strength

Aspects that reviewers agreed were done well:

1. **Cross-cutting theme identification** — cited by 5/5 reviewers. Themes 1 (convergent architecture) and 2 (mutual validation) are unanimously recognized as genuinely valuable portfolio-level insights impossible from individual reviews.
2. **Structured disagreement analysis** — cited by 4/5 reviewers. The reviewer bloc analysis with Spearman correlations is a productive framing that provides richer information than score aggregation.
3. **Clear, replicable protocol** — cited by 3/5 reviewers. The 5-step assessment protocol is concrete enough for other groups to adopt.
4. **Honest limitations** — cited by 2/5 reviewers. Direct acknowledgment of AI-simulation limitations is appreciated.

## Areas of Disagreement

Points where reviewers diverged:

1. **Severity of AI-simulation limitation** — Liang and Schmidt see it as addressable with calibration studies; Shneiderman sees it as fundamentally undermining the contribution; Shankar focuses on operational reliability regardless of simulation source.
2. **Value of rankings vs. themes** — Bernstein questions whether the ranking function justifies portfolio panels (themes might be sufficient); Schmidt and Liang see rankings as the primary contribution needing better statistics; Shneiderman is more concerned with the assessment process than its outputs.
3. **Target audience** — Liang and Schmidt orient toward evaluation methodology researchers; Bernstein toward crowdsourcing/collective intelligence; Shneiderman toward research practice and policy; Shankar toward systems practitioners.

---

## Recommended Next Steps

1. **Add uncertainty quantification** — Addresses P1.2. Bootstrap CIs, sensitivity analysis, score distributions. Estimated effort: 3-5 days.
2. **Conduct baseline comparison** — Addresses P1.3. Aggregate individual review scores, compare to panel rankings. Estimated effort: 2-3 days.
3. **Write human-in-the-loop section** — Addresses P1.4. Hybrid design, appeals mechanism, human oversight points. Estimated effort: 2-3 days.
4. **Expand related work** — Addresses P2.1. Grant panels, judgment aggregation, scientometrics literature. Estimated effort: 3-4 days.
5. **Add calibration discussion** — Addresses P1.1. Epistemic status of simulated disagreement, future calibration study design. Estimated effort: 2-3 days.
6. **Operationalization section** — Addresses P2.2, P2.3. Failure modes, runtime, reproducibility. Estimated effort: 2-3 days.

**Total estimated revision time**: 3-4 weeks

---

*Generated by panel synthesis engine — see shared/synthesis-engine.md*
