# PANEL Role Index

PANEL is an AI-simulated research review plugin. Use these roles when changing
review lifecycles, persona profiles, synthesis rules, research claims, or public
disclosure language.

## Parliament

Governance roles decide whether a change is safe, honest, and coherent enough
to ship.

| File | Role | Primary tension |
|---|---|---|
| `parliament/simulation-disclosure-steward.md` | Simulation Disclosure Steward | Useful expert simulation vs. false peer-review implication |
| `parliament/lifecycle-integrity-auditor.md` | Lifecycle Integrity Auditor | Smooth automation vs. stage-gate accountability |

## Methodology

Methodology roles improve the quality of the simulated review process without
turning governance into a straitjacket.

| File | Role | Primary tension |
|---|---|---|
| `methodology/persona-calibration-reviewer.md` | Persona Calibration Reviewer | Diverse expert lenses vs. impersonation or overclaiming |
| `methodology/synthesis-priority-editor.md` | Synthesis Priority Editor | Actionable revision priorities vs. noisy reviewer aggregation |

## Panel reviewer personas

`panel-reviewer/` contains the simulated reviewer role set used by the plugin.
These are domain lenses, not governance roles, and they intentionally remain in
their own peer directory.

## Active panel and specialist routing

The two Parliament roles and two Methodology roles are the active core for every relevant
change. The files under `panel-reviewer/` are a specialist roster, not an always-on panel.

Select three to five reviewer personas that cover the affected subject, operator, and a credible
skeptical or counter-position. Record selected role paths, routing rationale, and relevant
limitations or conflicts in the review artifact. Add reviewers only when they contribute a
distinct evidence source or tension; panel size is not evidence of diversity.

Governance objections about ownership or disclosure block before methodology review. Persona
Calibration may reject an ungrounded reviewer, while Synthesis Priority may narrow a valid but
over-broad panel. Resolve that tension by retaining the smallest panel that still includes the
affected operator and a skeptical view, and preserve dissent in the synthesis.

Add a reviewer persona only with a distinct evidence domain, explicit review questions, and a
named routing condition. Review the roster annually: merge duplicates and retire personas with
no distinct scope or no selection across two review cycles. Preserve retired role history and
prior review attribution.

## PITFALL gates

| Gate | Roles | Blocks |
|---|---|---|
| `PANEL-PF-05` current probe surface | Lifecycle Integrity Auditor; Simulation Disclosure Steward; Persona Calibration Reviewer; Synthesis Priority Editor | Citing stored probe reports as current adoption evidence unless plugin version, skill files, publication inventory, probe plan, probe index, current-surface record, and historical-report boundary are checked with `tests/check-probe-surface.ps1`. |

## Review order

1. Use Simulation Disclosure Steward for any public text, reviewer naming, or output disclaimer.
2. Use Lifecycle Integrity Auditor for command flow, stage transitions, and re-entrancy.
3. Use Persona Calibration Reviewer for profile data, reviewer categories, and venue matching.
4. Use Synthesis Priority Editor for review consolidation, scoring, and P1/P2/P3 logic.
