# PANEL Invariants

These invariants describe guarantees that PANEL's review lifecycle and public
contract must preserve.

## PANEL-I-01: Disclosure Appears Where Simulated Reviews Are Consumed

**Status:** VERIFIED

**Claim:** Public docs, review templates, synthesis artifacts, and generated
review outputs must disclose that feedback is AI-generated and that named
researchers did not participate.

**Why it matters:** Without visible disclosure, PANEL can mislead authors,
readers, or downstream customers about authority and endorsement.

**Enforcement:** README framing, CLAUDE language rules, review templates, and
the AI-disclosure probe preserve the boundary.

**Evidence:** `README.md`, `CLAUDE.md`, `templates/review-template.md`,
`context/probe/test-plan.json`.

## PANEL-I-02: Stage Advancement Is Gate-Backed

**Status:** VERIFIED

**Claim:** Draft, panel, synthesis, revision, recheck, ready, submit, and
accepted stages must advance only when the documented gate evidence exists.

**Why it matters:** Automation must not let `panel:go` skip reviewer assignment,
synthesis, P1 handling, module review, submission confirmation, or acceptance
confirmation.

**Enforcement:** Stage-machine gates, lifecycle role review, and probe fixtures
define the transition contract.

**Evidence:** `README.md`, `CLAUDE.md`,
`context/probe/tests/l1/l1-stage-machine-gates.probe.yaml`,
`context/probe/tests/l3/l3-full-paper-lifecycle.probe.yaml`.

## PANEL-I-03: State Is Re-Entrant And Scoped

**Status:** VERIFIED

**Claim:** Commands read and write committed `_panel.yaml` state, preserve
history, and scope auto-commit behavior to touched files.

**Why it matters:** PANEL's value depends on being able to stop, resume, audit,
and sync paper work without corrupting unrelated repository state.

**Enforcement:** State-loader tests, scoped git-helper expectations, and
project configuration keep state durable and commits bounded.

**Evidence:** `README.md`, `CLAUDE.md`, `.claude/panel.json`,
`context/probe/tests/l1/l1-state-loader-read.probe.yaml`,
`context/probe/tests/l1/l1-state-loader-write.probe.yaml`,
`context/probe/tests/l1/l1-git-utils-commit.probe.yaml`.

## PANEL-I-04: Synthesis Preserves Review Evidence

**Status:** VERIFIED

**Claim:** P1/P2/P3, PP1/PP2/PP3, and B1/B2/B3 synthesis must trace back to
review evidence and preserve paper-level nuance when findings bubble between
paper, module, and board tiers.

**Why it matters:** Cross-paper or cross-module summaries are only useful if they
do not flatten disagreements or invent new criticism.

**Enforcement:** Synthesis-engine, convene, and board probe scenarios require
paper findings to bubble up without losing priority structure.

**Evidence:** `CLAUDE.md`, `.roles/methodology/synthesis-priority-editor.md`,
`context/probe/tests/l2/l2-convene-mock.probe.yaml`,
`context/probe/tests/l2/l2-board-mock.probe.yaml`.

## PANEL-I-05: Plugin Provenance Is Recorded For Adopters

**Status:** PARTIAL

**Claim:** Adopters must record the PANEL repository, plugin version, and
immutable revision when relying on PANEL behavior.

**Why it matters:** Cross-repo users need to know which skill contract produced
their review state and which local details are not portable.

**Enforcement:** README portfolio reuse contract and plugin manifest versioning
define the adoption evidence expected from downstream repos.

**Evidence:** `README.md`, `.claude-plugin/plugin.json`, `.claude/panel.json`.
