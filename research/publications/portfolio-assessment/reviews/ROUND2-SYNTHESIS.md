# Review Synthesis — Cross-Portfolio Expert Panels

**Paper**: panel-portfolio-assessment
**Round**: 2
**Date**: 2026-02-05
**Reviewers**: 5

---

## Overview

| Metric | Value |
|--------|-------|
| Average Score | 3.0/4 |
| Score Range | 3-3/4 |
| Consensus | Strong (σ = 0.00) |
| Overall Verdict | Accept with Minor Revisions |

## Score Distribution

| Reviewer | Affiliation | Score | Verdict |
|----------|-------------|-------|---------|
| Percy Liang | Stanford | 3/4 | Accept with Minor Revisions |
| Michael Bernstein | Stanford | 3/4 | Accept with Minor Revisions |
| Ben Shneiderman | UMD | 3/4 | Accept with Minor Revisions |
| Shreya Shankar | Berkeley | 3/4 | Accept with Minor Revisions |
| Ludwig Schmidt | UW | 3/4 | Accept with Minor Revisions |

---

## Round 1 → Round 2 Score Changes

| Reviewer | Round 1 | Round 2 | Change |
|----------|---------|---------|--------|
| Percy Liang | 3/4 | 3/4 | — |
| Michael Bernstein | 2/4 | 3/4 | +1 |
| Ben Shneiderman | 2/4 | 3/4 | +1 |
| Shreya Shankar | 2/4 | 3/4 | +1 |
| Ludwig Schmidt | 3/4 | 3/4 | — |

All three reviewers who required major revisions upgraded their scores. The two who were already at Accept maintained their scores.

---

## P1 Item Resolution

All 4 P1 items from Round 1 have been resolved:

| P1 Item | Status | Reviewer Assessment |
|---------|--------|-------------------|
| P1.1: Calibration/validation | **Resolved** | Calibration protocol (Sec 6.4) with 4-step design; epistemic framing appropriate (5/5 agree) |
| P1.2: Uncertainty quantification | **Resolved** | Bootstrap CIs, sensitivity analysis, test-retest reliability (ICC=0.87) thoroughly addresses concern (5/5 agree) |
| P1.3: Baseline comparison | **Resolved** | ρ=0.83 with aggregated individual scores; 3 unique portfolio outputs identified (5/5 agree) |
| P1.4: Human-in-the-loop design | **Resolved** | Three-tier appeals mechanism, automatable vs. human-essential stages, "AI drafts, human decides" model (5/5 agree) |

---

## Remaining Issues (All Minor)

No blocking issues remain. The following minor suggestions were raised:

### m1: Bootstrap CI on ICC Estimate
**Raised by**: Ludwig Schmidt
**Suggestion**: Report confidence interval on ICC(2,7) = 0.87, which is based on only two runs.

### m2: Tier-Boundary Confidence Intervals
**Raised by**: Percy Liang
**Suggestion**: Add CIs on tier-boundary scores, not just individual paper scores.

### m3: Scalability Analysis
**Raised by**: Shreya Shankar
**Suggestion**: Note practical upper bounds on program size given context window constraints.

### m4: Failure Mode Ablation
**Raised by**: Michael Bernstein
**Suggestion**: Leave-one-reviewer-out ablation would empirically quantify composition sensitivity.

### m5: Appeals Adjudication
**Raised by**: Ben Shneiderman
**Suggestion**: Specify who adjudicates appeals and extend mechanism to portfolio-level disputes.

### m6: Kendall's Tau for Baseline
**Raised by**: Ludwig Schmidt
**Suggestion**: Report Kendall's tau distance for baseline comparison to complement Spearman ρ.

### m7: Conviction Weight Justification
**Raised by**: Michael Bernstein
**Suggestion**: Provide principled basis for the conviction weight scale (high=3, medium=2, low=1).

### m8: Krippendorff's Alpha Context
**Raised by**: Percy Liang
**Suggestion**: Compare α=0.41 to typical inter-reviewer agreement rates at target venues.

---

## Areas of Strength

Aspects that reviewers agreed were improved or strong:

1. **Uncertainty quantification** — cited by 5/5 reviewers. Bootstrap CIs, sensitivity analysis, and test-retest reliability provide the statistical rigor previously missing.
2. **Baseline comparison** — cited by 5/5 reviewers. Clearly establishes the unique value of portfolio panels vs. simple aggregation.
3. **Human-in-the-loop design** — cited by 4/5 reviewers (especially Shneiderman, Bernstein). Three-tier appeals mechanism and hybrid deployment model are practical contributions.
4. **Calibration protocol** — cited by 4/5 reviewers. Four-step protocol is concrete and actionable.
5. **Expanded related work** — cited by 3/5 reviewers. Engagement with grant panels, judgment aggregation, and crowdsourcing literatures properly positions the contribution.
6. **Operationalization** — cited by 3/5 reviewers. Concrete runtime, cost, and reproducibility details.

## Areas of Consensus

All 5 reviewers agree on:
- The paper has adequately addressed all Round 1 P1 issues
- The paper is suitable for publication at JCDL / Scientometrics with minor revisions
- The calibration section strikes the right epistemic tone
- The baseline comparison is convincing

## Minor Disagreements

- **Depth of failure mode analysis**: Bernstein wants empirical ablation; others find the current discussion adequate
- **Scalability importance**: Shankar emphasizes this more than other reviewers
- **Appeals mechanism scope**: Shneiderman wants broader coverage; others find the current scope sufficient

---

## Recommended Next Steps

1. **Address minor reviewer suggestions** — 8 minor items, none blocking. Estimated effort: 2-3 days.
2. **Prepare for submission** — Paper is at Accept quality for JCDL / Scientometrics.

**Total estimated final revision time**: 2-3 days for minor polishing.

---

## Gate Check

| Criterion | Value | Threshold | Status |
|-----------|-------|-----------|--------|
| Average score | 3.0/4 | ≥ 2.5/4 | **PASS** |
| Minimum individual score | 3/4 | ≥ 2/4 | **PASS** |
| Number of reviewers | 5 | ≥ 5 | **PASS** |

**All gates pass. Paper is eligible to advance to `ready` stage.**

---

*Generated by panel synthesis engine — see shared/synthesis-engine.md*
