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

## Review order

1. Use Simulation Disclosure Steward for any public text, reviewer naming, or output disclaimer.
2. Use Lifecycle Integrity Auditor for command flow, stage transitions, and re-entrancy.
3. Use Persona Calibration Reviewer for profile data, reviewer categories, and venue matching.
4. Use Synthesis Priority Editor for review consolidation, scoring, and P1/P2/P3 logic.
