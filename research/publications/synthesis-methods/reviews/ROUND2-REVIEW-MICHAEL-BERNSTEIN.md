# Review: From Reviews to Revisions — Automated Synthesis (Round 2)

**Reviewer**: Michael Bernstein (Stanford University)
**Expertise**: Crowdsourcing, human computation, social computing
**Round**: 2
**Date**: 2026-02-05

---

## Overall Assessment

The revised paper addresses my two primary concerns: the lack of baselines and the absence of a user study. The crowd aggregation literature is now appropriately cited (Dawid-Skene, GLAD, spectral methods, structured workflows), and the baseline comparison contextualizes the pipeline's contribution. The user study, while small (5 authors), provides the human validation I considered essential.

The new crowd aggregation subsection in §2 positions the work correctly within the broader literature. The key insight — that review synthesis requires deduplication before aggregation, unlike classical crowd aggregation where labels are already categorical — is well-articulated and represents a genuine contribution to the framing.

The user study findings are encouraging: 3/5 authors discovered overlooked P1 issues, and 4/5 agreed with the automated classification. The 30–45 minute time savings claim is plausible for a 5-reviewer panel. The honestly reported limitation (2/5 authors noted missing tonal nuance) is appropriate.

My remaining concern is that the Dawid-Skene baseline is "inspired by" rather than a faithful implementation. For a crowd aggregation paper citing Dawid-Skene, a more rigorous implementation and comparison would strengthen the contribution. However, I recognize this is a methods paper, not a crowd aggregation paper, and the baselines serve their purpose.

## Score

**Score**: 3/4 — Accept

## Major Issues (Blocking)

None.

## Minor Issues

### m1: Dawid-Skene Implementation Fidelity
The "severity-weighted voting" baseline is described as "Dawid-Skene-inspired" but the details suggest a simplified version. Clarify exactly which elements of Dawid-Skene are used and which are approximated.

### m2: User Study Generalizability
The 5 authors include the paper's own author. Self-assessment creates a potential bias. Report results both including and excluding the paper author.

### m3: Structured Crowd Workflow Comparison
The related work cites structured crowd workflows but the pipeline isn't compared against one. Even a qualitative comparison (how does the three-stage pipeline map to find-fix-verify?) would strengthen the positioning.

## Strengths

1. **User study fills the critical gap**: 5 authors is small but the findings (overlooked issues, time savings, tonal limitations) are credible and useful.
2. **Crowd aggregation positioning**: The paper now correctly identifies its contribution relative to established methods. The deduplication-before-aggregation insight is well-framed.
3. **Baseline comparison is fair**: Frequency-based and severity-weighted alternatives are reasonable baselines that isolate the pipeline's advantage.
4. **Bias analysis is important**: Identifying that AI reviews overweight generalization/reproducibility is a finding other researchers should know about.

## Questions for Authors

1. Would a find-fix-verify workflow (Bernstein et al. 2010) be applicable here — e.g., find issues, fix duplicates, verify classification?
2. Did the 2 authors who noted missing tonal nuance have specific examples?

## Recommendations

- Clarify Dawid-Skene implementation details
- Report user study results with and without the paper author
- Add qualitative mapping to find-fix-verify or another structured crowd workflow

---

**Verdict**: Accept with Minor Revisions

**Confidence**: High — The user study and baseline comparison address my core concerns.
