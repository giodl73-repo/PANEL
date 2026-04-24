# Review: Cross-Portfolio Expert Panels: Holistic Assessment of Multi-Paper Research Programs

**Reviewer**: Shreya Shankar (Berkeley)
**Expertise**: ML ops, observability, pipelines
**Round**: 1
**Date**: 2026-02-05

---

## Overall Assessment

This paper presents a methodology for portfolio-level research assessment using structured expert panels. From an operational perspective, the contribution is interesting: it proposes a concrete pipeline (compose panel → assess individually → aggregate → synthesize) for a task that is currently ad-hoc at best. The cross-cutting theme identification is the paper's strongest contribution—surfacing convergent architecture patterns across independently-developed modules is exactly the kind of insight that operational tooling should provide.

My main concern is that the paper presents the methodology but provides almost no information about how to debug, test, or validate it in practice. When I review systems papers, I always ask: how do you know this is working correctly? For a scoring and ranking system, this means: how do you detect when the panel produces unreliable results? What are the failure modes? What observability do you have into the assessment process? The paper presents final scores and rankings without any discussion of the pipeline's reliability characteristics.

The paper would be much stronger if it treated the panel methodology as a system to be tested and monitored, not just described. What's the test suite for a portfolio assessment pipeline?

## Score

**Score**: 2/4 — Weak Accept

## Major Issues (Blocking)

### M1: No Discussion of Failure Modes or Reliability
The paper presents a scoring and ranking pipeline but never discusses how it fails. Key missing questions: (a) What happens when a reviewer persona produces inconsistent assessments? (b) How do you detect score drift across rounds? (c) What's the test-retest reliability? (d) Are there known biases in the scoring (e.g., position effects—do papers assessed first get different scores?). For JCDL/Scientometrics, where assessment methodology is the core topic, this is a significant gap.

### M2: Operationalization Gap
The methodology is described at protocol level but lacks operational detail needed for replication. How long does one panel assessment take? What are the compute costs? How do you version-control the panel composition and assessment parameters? If this is meant to be a reusable methodology, these practical details matter.

## Minor Issues

### m1: No Data Pipeline Description
The paper mentions 13 papers across 2 modules but doesn't describe how paper content is fed to reviewers. Is it full text? Abstracts only? Section-by-section? This affects assessment quality.

### m2: Score Aggregation Method Unspecified
The paper uses "average of 7 reviewer scores" for rankings but doesn't discuss whether this is the right aggregation. Median is more robust to outliers. Trimmed means handle reviewer miscalibration. The choice should be justified.

### m3: Missing Reproducibility Information
For a methodology paper, reproducibility is critical. What parameters control the panel process? How sensitive is the output to these parameters? Can another team replicate these results?

## Strengths

1. **Concrete pipeline**: The methodology is described as a clear sequence of steps that could be implemented as an actual system, not just a conceptual framework.
2. **Cross-cutting themes**: The 6 themes, particularly the convergent architecture discovery, demonstrate portfolio-level value that is impossible to derive from individual reviews.
3. **Agreement analysis**: The Spearman correlation analysis of reviewer blocs provides useful structure for interpreting disagreement.

## Questions for Authors

1. How do you test the panel methodology? If you ran it 10 times on the same portfolio, what would the variance in rankings and themes look like?
2. What monitoring would you put in place for an ongoing portfolio assessment system? What metrics would you track?
3. Have you considered A/B testing different panel compositions or assessment protocols to optimize the methodology?

## Recommendations

- Add a reliability analysis section with test-retest results and sensitivity analysis
- Include operational details: runtime, cost, parameter sensitivity
- Discuss failure modes explicitly and how to detect/mitigate them
- Consider framing the methodology as a testable system with defined quality metrics

---

**Verdict**: Major Revisions Required

**Confidence**: Medium — My expertise is in ML ops and system reliability, which is relevant to the operational aspects of this methodology but less directly to the scientometrics content. I'm confident about the systems gaps but less so about whether the venue would weight them as heavily as I do.
