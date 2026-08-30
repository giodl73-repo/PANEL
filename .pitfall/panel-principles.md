# PANEL Principles

These principles capture durable decision rules for PANEL's AI-simulated
research quality workflow.

## PANEL-P-01: Simulation Is Advisory, Not Peer Review

**Status:** ACTIVE

**Statement:** PANEL output strengthens drafts through AI-generated perspective
diversity, but it never becomes real peer review, venue acceptance, factual
certification, or endorsement by named researchers.

**Rationale:** The product is most useful when authors trust the feedback while
readers can still see that it is synthetic and non-authoritative.

**Decision rule:** Any public, generated, or customer-facing review text must
describe outputs as AI-generated quality-improvement feedback and must not claim
real reviewer participation, acceptance prediction, or endorsement.

**Evidence:** `README.md`, `CLAUDE.md`,
`.roles/parliament/simulation-disclosure-steward.md`.

## PANEL-P-02: Lifecycle State Must Preserve Why A Gate Passed

**Status:** ACTIVE

**Statement:** `_panel.yaml`, review files, synthesis, revision plans, module
panels, and board reviews must preserve the evidence behind stage transitions
instead of only recording the latest stage label.

**Rationale:** Re-entrant automation is only safe when the next command can
resume from explicit state and explain why a paper is ready or blocked.

**Decision rule:** A command may advance or resume only when the documented gate
evidence exists in durable state or committed artifacts.

**Evidence:** `README.md`, `CLAUDE.md`,
`.roles/parliament/lifecycle-integrity-auditor.md`,
`context/probe/test-plan.json`.

## PANEL-P-03: Persona Diversity Serves Method, Not Impersonation

**Status:** ACTIVE

**Statement:** Reviewer personas are selected for lenses, concerns, and venue
fit; their names must remain labels for simulated perspectives, not claims of
participation.

**Rationale:** Named personas are powerful review scaffolds, but the ethical
boundary is the difference between a useful lens and implied endorsement.

**Decision rule:** Add or route personas only when they provide a distinct
evidence lens, explicit routing condition, and visible simulation disclosure.

**Evidence:** `README.md`, `CLAUDE.md`, `.roles/ROLE.md`,
`.roles/methodology/persona-calibration-reviewer.md`.

## PANEL-P-04: Priorities Are Revision Signals

**Status:** ACTIVE

**Statement:** P1/P2/P3, PP1/PP2/PP3, B1/B2/B3, scores, verdicts, and venue
recommendations guide revision priority but do not bind the author or predict
acceptance.

**Rationale:** PANEL should make improvement work easier to choose without
turning simulated consensus into reviewer mandates.

**Decision rule:** Priority and score language must preserve evidence,
disagreement, author choice, and non-acceptance framing.

**Evidence:** `README.md`, `CLAUDE.md`,
`.roles/methodology/synthesis-priority-editor.md`,
`context/probe/tests/l1/l1-synthesis-engine-consolidation.probe.yaml`.

## PANEL-P-05: Portfolio Reuse Is Versioned Plugin Behavior

**Status:** ACTIVE

**Statement:** The reusable contract is the versioned Claude Code plugin,
documented `panel:*` skills, and committed lifecycle state; local install paths,
research layouts, generated reviews, and adopter-specific context are not shared
APIs.

**Rationale:** PANEL is already reused by BISECT, so downstream adoption needs a
stable provenance boundary instead of copying implementation-local state.

**Decision rule:** Downstream repos must record repository, plugin version, and
immutable revision before relying on PANEL behavior as portfolio evidence.

**Evidence:** `README.md`, `.claude-plugin/plugin.json`,
`.claude/panel.json`.
