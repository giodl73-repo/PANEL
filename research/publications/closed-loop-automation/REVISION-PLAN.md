# Revision Plan: From Reviews to Revisions: Closed-Loop Automation of Academic Paper Improvement

**Paper**: panel-closed-loop-automation
**Round**: 1 → 2
**Date**: 2026-02-07
**Source**: reviews/SYNTHESIS.md

---

## Summary

The synthesis reveals strong consensus (4 of 5 reviewers rated 2.0/4, requiring major revisions) that the paper needs reframing from automation-centric to human-centered. The technical contribution is solid (78% P1 completion, 94% acceptance), but the paper misses critical opportunities to: (1) examine what is lost when revision becomes algorithmic, (2) compare quality to manual/crowd baselines, (3) enable learning from author feedback, and (4) specify operational aspects (debugging, observability). The revision strategy prioritizes adding human-centered analysis (P1.1), quality comparisons (P1.2), learning mechanisms (P1.3), and operational details (P1.4).

## Expert Reviewers

| # | Reviewer | Affiliation | Score | Verdict |
|---|---------|-------------|-------|---------|
| 1 | Ben Shneiderman | UMD | 2.0/4 | Major Revisions Required |
| 2 | Michael Bernstein | Stanford | 2.0/4 | Major Revisions Required |
| 3 | Saleema Amershi | Microsoft Research | 2.0/4 | Major Revisions Required |
| 4 | Shreya Shankar | UC Berkeley | 2.0/4 | Major Revisions Required |
| 5 | Noah Shinn | Princeton | 3.0/4 | Accept with Minor Revisions |

---

## P1: Must Complete (Blocking)

### P1.1: Missing Human-Centered Analysis and Framing

**Source**: P1.1 in SYNTHESIS.md
**Raised by**: Shneiderman (M1), Bernstein (M1, m3), Amershi (M1, M3)

**Action**:
- [ ] Add subsection in Discussion (Section 5): "Human Agency in Automated Revision"
  - Address: When should authors resist automation and engage manually?
  - Address: What revision tasks are appropriately automated vs. requiring deep authorial engagement?
  - Address: How does the system preserve meaningful human control (HCAI principle)?
  - Discuss: 94% acceptance rate — appropriate trust or passive deference?
- [ ] Reframe the contribution throughout the paper
  - Change abstract/intro framing from "we automated X%" to "we mapped the boundary between automatable and human-essential revision tasks"
  - Emphasize implications for HCAI design, not just efficiency gains
- [ ] Add qualitative author experience data
  - Collect 5-7 brief quotes from authors on: satisfaction, trust, sense of control
  - Add to Results (new subsection 4.X: "Author Experience") or Discussion
- [ ] Revise venue framing (especially in Introduction)
  - Align with CHI/CSCW values: "We investigate the design space of AI-assisted revision, identifying where automation can safely augment authorial agency"

**Target sections**:
- sections/01-introduction.tex (reframe contribution, lines 45-53)
- sections/05-discussion.tex (add new subsection ~1.5 pages)
- sections/04-results.tex (add subsection 4.7: "Author Experience" ~0.5 page)

**Estimated effort**: 3-4 days

---

### P1.2: No Comparison to Manual Revision Quality or Alternative Workflows

**Source**: P1.2 in SYNTHESIS.md
**Raised by**: Shneiderman (M2), Bernstein (M1), Shankar (m2)

**Action**:
- [ ] Add quality comparison study (manual vs. automated revision)
  - Option A: Blind expert ratings on 4-6 papers (3 manual, 3 automated) using dimensions: clarity, coherence, argumentation quality, depth of engagement
  - Option B: Compare Round 2 reviewer scores for papers in the dataset that were revised manually (if any exist) vs. automated
  - Add results to new subsection 4.X: "Comparison to Manual Revision Quality"
- [ ] Add comparison to crowd-based alternatives
  - Research and cite cost/time for: professional editors ($500-$1000/paper, 24-48hr), crowd proofreading (Upwork, Scribbr), hybrid workflows
  - Add to Related Work (Section 2) or Discussion (Section 5)
  - Justify when/why closed-loop automation is preferable
- [ ] Add cost analysis
  - Calculate dollar cost per paper (API calls to Claude for reviews + synthesis + planning)
  - Compare to crowd baselines
  - Add to Discussion subsection "Cost-Benefit Analysis"

**Target sections**:
- sections/04-results.tex (new subsection 4.8: "Quality Comparison" ~1 page)
- sections/02-related-work.tex (add paragraph on crowd-based revision ~0.5 page)
- sections/05-discussion.tex (add subsection "Cost-Benefit Analysis" ~0.75 page)

**Estimated effort**: 5-7 days (includes running blind rating study)

---

### P1.3: Insufficient Treatment of Learning and Adaptation

**Source**: P1.3 in SYNTHESIS.md
**Raised by**: Amershi (M1, M2), Shinn (M1, M2)

**Action**:
- [ ] Add subsection in Methodology (Section 3): "Learning from Author Feedback" (or in Future Work if not implemented)
  - Describe how system could learn from modified/rejected edits (4% + 2% = training data)
  - Propose author preference model (formal vs. informal tone, concise vs. detailed)
  - Specify features: edit type, reviewer, paper section, acceptance/rejection
  - If not implemented: provide detailed architecture design for future work
- [ ] Add subsection in Methodology (Section 3): "Reflection and Strategy Adjustment"
  - Describe what system learns from Round N feedback
  - How it adjusts revision strategy for Round N+1
  - Whether it maintains memory of past edits and reviewer reception
  - If not implemented: add detailed proposal to Future Work
- [ ] Analyze author feedback patterns
  - Categorize 28 modified/rejected edits (P2.1 overlaps with this)
  - Look for patterns: do authors consistently prefer certain phrasing? reject certain edit types?
  - Add findings to Results section or Discussion

**Target sections**:
- sections/03-methodology.tex (add subsection 3.7: "Learning from Author Feedback" ~1 page OR move to Future Work in Discussion)
- sections/03-methodology.tex (add subsection 3.8: "Reflection Across Rounds" ~0.75 page OR move to Future Work)
- sections/05-discussion.tex (subsection "Future Work: Self-Improving Revision Agents" ~1 page if not implemented)

**Estimated effort**: 4-5 days

---

### P1.4: Underspecified Operational Aspects and Failure Modes

**Source**: P1.4 in SYNTHESIS.md
**Raised by**: Shankar (M1, M2, M3), Shneiderman (M3)

**Action**:
- [ ] Add subsection in Methodology (Section 3): "Failure Detection and Debugging"
  - Describe failure detection pipeline: compilation errors, semantic checks, validation tests
  - Describe debugging tools for authors: diff view, selective rollback, edit provenance tracking
  - Provide walkthrough of debugging a real failure case (one of the 3 compilation failures from Table 6)
- [ ] Add subsection in Methodology (Section 3): "Observability and Metrics"
  - What metrics are logged: edit-level (applied/skipped/rolled back), paper-level (completion rate), corpus-level (trends)
  - How metrics are tracked: logs, dashboards, monitoring
  - How authors access metrics (e.g., "Your paper: 12 edits applied, 10 accepted, 2 pending")
- [ ] Add subsection in Results or Discussion: "Error Propagation and Edit Dependencies"
  - Analyze whether edits are independent or have cascading dependencies
  - Describe how rollback handles dependent edits
  - Report frequency of dependency-related failures in 9% compilation error cases
- [ ] Expand Discussion subsection: "Limitations and Risks"
  - Add: Over-reliance on automation, homogenization of writing, loss of tacit learning, adversarial gaming

**Target sections**:
- sections/03-methodology.tex (add subsections 3.9-3.10: "Failure Detection" + "Observability" ~1.5 pages)
- sections/05-discussion.tex (add subsection "Error Propagation" ~0.75 page)
- sections/05-discussion.tex (expand "Limitations and Risks" from ~0.5 page to ~1 page)

**Estimated effort**: 3-4 days

---

## P2: Should Complete (Important)

### P2.1: Missing Error Analysis of Modified/Rejected Edits

**Source**: P2.1 in SYNTHESIS.md
**Raised by**: Bernstein (M2), Amershi (m1)

**Action**:
- [ ] Categorize 28 modified/rejected edits (4% + 2% of 466 = 28 edits)
  - Categories: factual errors, style mismatches, domain terminology, localization failures
  - Look for patterns: Which edit types are rejected most? Which paper sections?
- [ ] Add findings to Results (subsection 4.X: "Error Analysis of Rejected Edits" ~0.75 page)
  - Include table showing category distribution
  - Discuss implications for future improvements

**Target section**: sections/04-results.tex (new subsection 4.9: "Error Analysis" ~0.75 page)

**Estimated effort**: 2-3 days

---

### P2.2: No Discussion of Mixed-Initiative or Alternative Interaction Models

**Source**: P2.2 in SYNTHESIS.md
**Raised by**: Bernstein (M3), Amershi (M3)

**Action**:
- [ ] Add subsection in Discussion: "Interaction Models: Batch vs. Mixed-Initiative"
  - Compare current batch model to alternatives:
    - Stepwise approval (system proposes edits one-by-one)
    - Mixed-initiative (system flags high-confidence vs. low-confidence edits)
    - Explanatory interface (show which reviewer, what concern for each edit)
  - Discuss trade-offs: efficiency vs. control, automation vs. learning
  - Justify why batch was chosen for this system

**Target section**: sections/05-discussion.tex (new subsection ~1 page)

**Estimated effort**: 1-2 days

---

### P2.3: Lack of Confidence Scores on Edits

**Source**: P2.3 in SYNTHESIS.md
**Raised by**: Amershi (m2), Shankar (m3)

**Action**:
- [ ] Add to Future Work in Discussion
  - Propose confidence scoring mechanism: based on reviewer consensus, edit type, localization difficulty
  - Discuss benefits: authors can batch-approve high-confidence edits, carefully review low-confidence
- [ ] (Optional) If time permits: implement confidence scoring and report results

**Target section**: sections/05-discussion.tex (Future Work subsection, add ~0.5 page)

**Estimated effort**: 0.5 day (as Future Work only)

---

### P2.4: Limited Generalization Claims Without Evidence

**Source**: P2.4 in SYNTHESIS.md
**Raised by**: Bernstein (m3)

**Action**:
- [ ] Revise or remove generalization claim (lines 52-53 in Introduction)
  - Option A: Remove claim entirely
  - Option B: Add paragraph in Discussion discussing LaTeX-specific properties (structured syntax, compilation validation) and how these may/may not hold for other domains

**Target sections**:
- sections/01-introduction.tex (revise lines 52-53)
- sections/05-discussion.tex (add ~0.5 page if choosing Option B)

**Estimated effort**: 0.5 day

---

## P3: Nice to Have

### P3.1: Add Cost and Latency Analysis

**Source**: P3.1 in SYNTHESIS.md
**Raised by**: Shankar (m2)

**Action**:
- [ ] Report system latency (how long synthesis → planning → execution takes)
- [ ] Report dollar cost (API calls to Claude per paper)
- [ ] Add to Results or Discussion

**Target section**: sections/05-discussion.tex (~0.25 page)

**Estimated effort**: 0.5 day

---

### P3.2: Discuss Data Provenance and Traceability

**Source**: P3.2 in SYNTHESIS.md
**Raised by**: Shankar (m3), Bernstein (m2)

**Action**:
- [ ] Describe edit provenance tracking (which reviewer → which concern → which edit)
- [ ] Add to Implementation or Discussion

**Target section**: sections/03-methodology.tex or sections/05-discussion.tex (~0.25 page)

**Estimated effort**: 0.5 day

---

### P3.3: Add Comparison to Self-Improving Agent Architectures

**Source**: P3.3 in SYNTHESIS.md
**Raised by**: Shinn (m3)

**Action**:
- [ ] Add 1-2 paragraphs to Related Work discussing: Reflexion, ReAct with reflection, LATS
- [ ] Position this paper relative to those methods

**Target section**: sections/02-related-work.tex (~0.5 page)

**Estimated effort**: 0.5 day

---

### P3.4: Clarify Meta-Cognitive Prompting and Memory Usage

**Source**: P3.4 in SYNTHESIS.md
**Raised by**: Shinn (m1, m2)

**Action**:
- [ ] Clarify in Methodology whether system uses meta-cognitive prompts ("Reviewer A flagged X in round 1 and 2 — what additional changes needed?")
- [ ] Explain how `_panel.yaml` state informs future revision strategy

**Target section**: sections/03-methodology.tex (Phase 2: Revision Planning, add ~0.25 page)

**Estimated effort**: 0.5 day

---

## Revision Timeline

| Days | Focus | Deliverable |
|------|-------|-------------|
| 1-4 | **P1.1** — Add human-centered analysis + reframe contribution | New Discussion subsection (~1.5 pages), revised Introduction framing, author experience data in Results |
| 5-11 | **P1.2** — Quality comparison study + crowd workflow analysis | New Results subsection (~1 page), expanded Related Work (~0.5 page), cost-benefit analysis in Discussion (~0.75 page) |
| 12-16 | **P1.3** — Learning/reflection mechanisms design | New Methodology subsections or detailed Future Work (~2-3 pages) |
| 17-20 | **P1.4** — Operational aspects (debugging, observability, error propagation) | New Methodology subsections (~1.5 pages), expanded Discussion (~1 page) |
| 21-23 | **P2.1-P2.2** — Error analysis + interaction models | New Results subsection (~0.75 page), new Discussion subsection (~1 page) |
| 24-25 | **P2.3-P2.4** — Confidence scores + generalization claims | Updates to Introduction + Discussion (~0.75 page) |
| 26 | **P3** items — Cost/latency, provenance, self-improving agents, meta-cognitive prompts | Various additions (~1.5 pages total) |
| 27-28 | Polish, rebuild, internal review | Ready for round 2 reviews |

**Total estimated time**: 4 weeks

---

## Quality Gates

- [ ] All P1 items addressed (P1.1, P1.2, P1.3, P1.4)
- [ ] Paper rebuilds without LaTeX errors
- [ ] All new claims supported by evidence or citations
- [ ] Paper length within venue limits (CHI: 10 pages + references)
- [ ] All reviewer questions answered in text or Discussion
- [ ] Framing aligns with CHI/CSCW human-centered computing values

---

## Notes for Authors

**Priority**: Focus on P1 items first — these are blocking for acceptance. P1.1 (human-centered framing) and P1.2 (quality comparison) are highest priority as they address the core mismatch with venue expectations.

**Effort vs. Impact**: P1.2 (quality comparison study) is expensive (5-7 days) but critical — consider whether existing data can substitute for new blind rating study. P1.3 and P1.4 can be addressed in Future Work if implementing full solutions is too costly.

**Reviewer Alignment**: Noah Shinn (3.0/4) is more sympathetic to the technical contribution and sees reflection/learning as addressable in future work. The other four reviewers (2.0/4) require human-centered analysis and quality evidence for acceptance. Revisions should prioritize the concerns of the majority.

---

*Begin revision work. Address P1 items first, then P2. Target round 2 submission in 4 weeks.*
