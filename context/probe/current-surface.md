# PANEL current probe surface

Date: 2026-09-02

This file is the current surface record for `PANEL-PF-05`. It keeps probe
evidence tied to the plugin layout that exists now instead of treating the
historical 47/47 report as current proof.

## Current plugin surface

- Plugin manifest: `.claude-plugin/plugin.json`
- Plugin version: `2.3.0`
- Skill directories: 12
- Skill files: `.claude/skills/*/SKILL.md`
- Research publication directories: 10
- Probe plan: `context/probe/test-plan.json`
- Probe index: `context/probe/probe-index.json`
- Current surface check: `tests/check-probe-surface.ps1`

## Skill inventory

| Skill | Path |
|---|---|
| board | `.claude/skills/board/SKILL.md` |
| help | `.claude/skills/help/SKILL.md` |
| module | `.claude/skills/module/SKILL.md` |
| paper | `.claude/skills/paper/SKILL.md` |
| project | `.claude/skills/project/SKILL.md` |
| publication | `.claude/skills/publication/SKILL.md` |
| report | `.claude/skills/report/SKILL.md` |
| research | `.claude/skills/research/SKILL.md` |
| reviewers | `.claude/skills/reviewers/SKILL.md` |
| setup | `.claude/skills/setup/SKILL.md` |
| uninstall | `.claude/skills/uninstall/SKILL.md` |
| upgrade | `.claude/skills/upgrade/SKILL.md` |

## Historical report boundary

`context/probe/results/run-all-1770441200/report.md` remains valid history for
the older `panel` v1.1.0 probe run. It is not current proof for the v2.3.0
plugin surface unless `tests/check-probe-surface.ps1` also passes.

## Current validation

```powershell
pwsh -NoProfile -File tests\check-probe-surface.ps1
```
