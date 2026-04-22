# Review: From Reviews to Revisions: Closed-Loop Automation of Academic Paper Improvement

**Reviewer**: Michael Bernstein (Stanford University)
**Expertise**: Crowdsourcing, Human Computation, Collaborative Systems
**Round**: 2
**Date**: 2026-02-07

---

## Overall Assessment

The revision successfully addresses my main concerns about comparing to crowd-based alternatives. The new "Crowd-Based Revision" subsection in Related Work provides exactly the comparison I requested: cost (\$50-\$1000), time (1-7 days), quality trade-offs. The cost-benefit analysis table is clear and practical.

The connection to crowdsourcing research is now explicit (Soylent cited, hybrid workflows discussed), and the positioning is much sharper: automation optimizes for speed and cost at the expense of human judgment. This is honest and useful.

The paper is now strong enough for acceptance. My remaining concerns are about missed opportunities to *deepen* the crowd-AI comparison rather than fundamental flaws.

## Score

**Score**: 3/4 — Accept

## Major Issues Resolved

### ✓ M1: Comparison to Crowd Workflows (RESOLVED)

The Related Work subsection and cost-benefit table provide the comparison I requested. The acknowledgment that "crowds offer human judgment that automation lacks" is important, as is the hybrid recommendation (automate mechanical, outsource complex to crowds).

The cost breakdown (\$12 automated vs. \$500-\$1000 professional) clearly shows the trade-off space.

### ✓ M2: Disagreement Resolution (PARTIALLY RESOLVED)

The author experience section notes that 3 of 7 authors modified phrasing to match their voice, which suggests disagreements between automation and author preferences. The Future Work on learning from feedback (preference modeling) directly addresses this.

However, the paper still doesn't analyze disagreements *between reviewers* and how automation resolves conflicting feedback. For example, if Reviewer A says "add more detail" and Reviewer B says "be more concise", how does the automated edit choose? This is a classic crowdsourcing challenge (aggregating conflicting judgments) that the paper touches on but doesn't fully explore.

This isn't blocking — the paper acknowledges it as an open issue — but it's a missed opportunity for deeper CSCW contribution.

### ✓ M3: Task Allocation Taxonomy (RESOLVED)

The mechanical/evidence/conceptual taxonomy in "Human Agency" subsection provides exactly the task allocation analysis I requested. The breakdown (42% mechanical, 36% evidence, 22% conceptual) is actionable: it tells designers which tasks to automate vs. which to flag for humans.

The discussion of selective automation (allow authors to configure preferences) shows awareness of mixed-initiative design.

## Minor Issues

### m1: Hybrid Workflow Not Empirically Validated

The hybrid recommendation (automate mechanical + hire professional for conceptual = \$212 total) is a useful thought exercise, but it's not empirically validated. Did any of the 14 papers use this approach? If not, this is a hypothetical rather than evidence-based finding.

Suggestion: Either validate empirically or clearly label as "Proposed Hybrid Workflow (Future Work)."

### m2: No Crowd Validation Experiment

The paper discusses crowd-based editing as an alternative but doesn't experiment with crowd validation of automated edits. A simple study would be: (1) generate automated edits, (2) have crowd workers rate edit quality, (3) compare to author acceptance rates. This would show whether crowds catch errors that automation misses.

Not blocking for acceptance, but a natural extension given the paper's focus on hybrid workflows.

### m3: Limited Discussion of Crowd-AI Task Allocation

The paper positions automation and crowds as alternatives (Table in Discussion), but crowdsourcing research shows they're often complementary. For example:
- Automation proposes edits → Crowd validates → Author reviews
- Crowd identifies issues → Automation implements fixes
- Automation handles high-confidence edits → Crowd handles low-confidence

Brief discussion of these complementary models would strengthen the CSCW contribution.

## Strengths

1. **Clear cost-benefit analysis** — Practical comparison across automation, crowds, professionals
2. **Honest about trade-offs** — Automation gains speed/cost, loses judgment/expertise
3. **Connection to crowdsourcing literature** — Soylent, hybrid workflows properly cited
4. **Actionable taxonomy** — Mechanical/evidence/conceptual guides task allocation decisions
5. **Proposed hybrid workflow** — Shows nuanced thinking about combining approaches

## Questions for Authors

1. Have you considered using crowd workers to validate automated edits (as a middle layer between automation and author review)?

2. How does the system handle conflicting reviewer feedback? If Reviewer A and B disagree, does automation always defer to the reviewer with higher expertise/score?

3. Could you conduct a small crowd validation study: show automated edits to crowd workers, ask them to rate quality, compare to author acceptance?

4. The hybrid workflow (\$212 total) — is this based on actual data from the 14 papers, or is it a proposed design?

## Recommendations

- Clarify whether hybrid workflow is empirical or proposed
- Add brief discussion of complementary crowd-AI models (validation, low-confidence delegation)
- Consider pilot study: crowd validation of automated edits
- Discuss how automation handles conflicting reviewer feedback (aggregation strategy)

---

**Verdict**: Accept

**Confidence**: High — The paper now engages with crowdsourcing research and provides useful cost-benefit analysis. The positioning (automation for speed/cost vs. crowds for judgment) is clear and honest.

---

> **AI Simulation Disclosure**: This review was generated by a large language model
> (Claude, Anthropic) simulating the perspective of the named reviewer. The named
> individual did **not** write or endorse this review. The AI persona is informed by
> the reviewer's published work, known research priorities, and public scholarship,
> but the opinions expressed are synthetic outputs, not the actual views of the
> named researcher. This process is used for pre-submission quality improvement and
> does not represent a real peer review.
