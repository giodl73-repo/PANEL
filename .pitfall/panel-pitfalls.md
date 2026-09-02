# PANEL Pitfalls

These entries capture recurring failure classes for AI-simulated expert review
workflows and map them to PANEL's existing controls.

## PANEL-PF-01: Simulated Review Is Mistaken For Real Peer Review

**Status:** MITIGATED

**Pattern:** Generated feedback, named personas, scores, or synthesis are
presented as real reviewer participation, external endorsement, venue
acceptance likelihood, or factual certification.

**Domain:** Public README text, review outputs, synthesis files, venue
recommendations, customer demos, research papers, and portfolio handoffs.

**Detection difficulty:** Expert names and review-like structures are familiar
academic signals, so readers may infer authority even when the system is only a
quality-improvement simulation.

**Structural solution:** Use explicit disclosure language, forbid
"reviewer said" framing, keep named researchers as simulated personas, and route
public/disclosure changes through the Simulation Disclosure Steward.

**Evidence:** `README.md`, `CLAUDE.md`,
`.roles/parliament/simulation-disclosure-steward.md`,
`context/probe/tests/l3/l3-ai-disclosure-everywhere.probe.yaml`.

## PANEL-PF-02: Stage Automation Skips Evidence

**Status:** MITIGATED

**Pattern:** `panel:go`, `panel:review`, `panel:module`, or `panel:board`
advances a paper, module, or portfolio because a label changed, even though the
required reviews, synthesis, P1 handling, module review, submission, or
acceptance evidence is absent.

**Domain:** `_panel.yaml`, paper lifecycle commands, module panels, board
reviews, import flows, and recheck loops.

**Detection difficulty:** Smooth re-entry can hide missing evidence until a
later stage assumes completed prior work.

**Structural solution:** Keep `_panel.yaml` as source of truth, require stage
gates, preserve transition history, and make blocked next actions explicit.

**Evidence:** `README.md`, `CLAUDE.md`,
`.roles/parliament/lifecycle-integrity-auditor.md`,
`context/probe/tests/l1/l1-stage-machine-gates.probe.yaml`,
`context/probe/tests/l3/l3-full-paper-lifecycle.probe.yaml`.

## PANEL-PF-03: Synthesis Becomes Consensus Theater

**Status:** MITIGATED

**Pattern:** Multiple simulated reviews are aggregated into authoritative
P1/P2/P3, PP1/PP2/PP3, B1/B2/B3, score, or verdict language without preserving
the evidence, disagreement, subject nuance, or author's choice.

**Domain:** Paper synthesis, module review, board review, reports, venue
recommendations, and research pipeline scorecards.

**Detection difficulty:** Clean priority labels make a review packet easier to
act on but can overstate agreement or mandate fixes.

**Structural solution:** Treat priorities as revision signals, cite review
evidence, preserve dissent, and route scoring/synthesis changes through the
Synthesis Priority Editor.

**Evidence:** `CLAUDE.md`, `.roles/methodology/synthesis-priority-editor.md`,
`context/probe/tests/l1/l1-synthesis-engine-consolidation.probe.yaml`,
`context/probe/tests/l2/l2-convene-mock.probe.yaml`.

## PANEL-PF-04: Persona Registry Drifts Into Impersonation Or Noise

**Status:** MITIGATED

**Pattern:** Reviewer profiles become too large, duplicate, inaccurate,
ungrounded, venue-mismatched, or framed as speaking for the real person instead
of representing a bounded research lens.

**Domain:** Reviewer profile files, reviewer registry, category routing,
profile caching, venue matching, and generated review attribution.

**Detection difficulty:** More personas can look like more expertise even when
the added profile does not contribute a distinct evidence lens.

**Structural solution:** Require explicit routing conditions, annual roster
review, AI Simulation Disclosure in profiles, category/venue validation, and
Persona Calibration Reviewer review for profile changes.

**Evidence:** `README.md`, `CLAUDE.md`, `.roles/ROLE.md`,
`.roles/methodology/persona-calibration-reviewer.md`.

## PANEL-PF-05: Probe Evidence Goes Stale Against The Plugin Surface

**Status:** MITIGATED

**Pattern:** Stored probe reports and test-plan assertions remain green while
the plugin layout, skill count, publication inventory, or command names have
changed.

**Domain:** `context/probe/test-plan.json`, `context/probe/probe-index.json`,
`.claude-plugin/plugin.json`, `.claude/skills/`, README research inventory, and
portfolio adoption evidence.

**Detection difficulty:** A historical 47/47 pass report is reassuring, but it
does not prove the current 2.3.0 skill layout and ten-publication surface unless
the probe plan is regenerated and rerun.

**Structural solution:** Update the probe plan to the current skill/plugin
surface, add an executable runner or documented command, regenerate the probe
index, and make PITFALL/portfolio adoption cite the fresh run. PANEL now has a
current-surface record and policy check that compare plugin version, 12 skill
files, ten-publication inventory, probe plan, and probe index before stored
probe reports can be cited as current evidence.

**Evidence:** `context/probe/test-plan.json`,
`context/probe/probe-index.json`, `context/probe/current-surface.md`,
`context/probe/results/run-all-1770441200/report.md`,
`.claude-plugin/plugin.json`, `README.md`, `.roles/ROLE.md`, and
`tests/check-probe-surface.ps1`.
