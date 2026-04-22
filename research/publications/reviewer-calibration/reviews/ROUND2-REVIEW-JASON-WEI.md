# Review: Calibrating AI Reviewer Personas (Round 2)

**Reviewer**: Jason Wei (OpenAI)
**Expertise**: Prompting strategies, emergent abilities, LLM capabilities
**Round**: 2
**Date**: 2026-02-05

---

## Overall Assessment

I was already positive on this paper in Round 1 (3/4), and the revisions have made it stronger. The four-method comparison directly addresses the technical novelty concern by showing that structured profiles significantly outperform name-only prompting ($|\rho|$ drops from 0.72 to 0.42), and that retrieval augmentation provides only marginal improvement. This is a useful finding for the prompting community — it suggests that concise, structured persona specifications capture most of the useful calibration signal.

The progressive ablation showing key-question injection as the dominant mechanism is the paper's strongest contribution. The step-by-step contribution (+0.08, +0.12, +0.15, +0.02) clearly shows what matters and what doesn't in persona construction.

The failure analysis is well-done. The domain-mismatch pattern — personas reviewing outside their area revert to generic feedback — is both intuitive and important to document empirically. The prompt template and generation parameters are now fully specified, addressing my reproducibility concern.

## Score

**Score**: 3/4 — Accept

## Minor Issues

### m1: Temperature Sensitivity
The paper reports using temperature 1.0 but doesn't test other values. A brief note on whether lower temperatures reduce distinctness or higher temperatures increase noise would be useful.

## Strengths

1. **Progressive ablation is the standout result**: Clear, quantified contributions of each profile field.
2. **Retrieval-augmented comparison is informative**: Showing marginal benefit is as useful as showing large benefit.
3. **Full prompt template provided**: Good for reproducibility.
4. **Failure analysis adds practical value**: Domain-mismatch pattern is actionable.

---

**Verdict**: Accept with Minor Revisions

**Confidence**: High — Prompting methodology and persona construction are central to my research.
