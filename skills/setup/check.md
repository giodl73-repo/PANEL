# Check Mode

```
panel:setup --check
```

Validates existing setup without creating anything:

```javascript
// @import ../shared/project-config.md

const projectConfig = loadProjectConfig();
const researchDir = path.join(process.cwd(), projectConfig.researchPath);
```

## Validation Checks

- Plugin accessible via `CLAUDE_PLUGIN_ROOT`
- `researchDir` directory exists
- REVIEWER-DATABASE.md present
- All papers have `_panel.yaml`
- All papers have `REVISION-PLAN.md`
- Reviewer profiles accessible via `${pluginRoot}/.craft/roles/panel-reviewer/`
- Lists all papers with stage, venue, and readiness status

## Check Output

```
Panel Setup Check — C:\src\boost
═══════════════════════════════════════════════════════════════════════

Plugin: ${CLAUDE_PLUGIN_ROOT} ✓
Project: ${projectConfig.projectName}
Research Path: ${researchDir}

Infrastructure (${researchDir}):
  ✓ REVIEWER-DATABASE.md  (51 reviewers, 11 categories)
  ✓ RESEARCH.md           (2 papers listed)
  ✓ REVIEWERS.md          present
  ✓ REVIEW_PANEL.md       present
  ✓ references.bib        present (1200+ entries)
  ✓ Makefile              present

Reviewer Profiles (${pluginRoot}/.craft/roles/panel-reviewer/):
  ✓ _index.yaml           accessible (name → R-N registry)
  ✓ R-N.md profiles       51 profiles (OLE format)
  — .craft/roles/panel-reviewer/   (local extensions, optional)

Reviewer Panel:
  ✓ REVIEWERS.md          populated (12 reviewers, 7 panel members)
  — or —
  ⚠ REVIEWERS.md          template only (run panel:setup to populate)

Research Monorepo:
  ✓ scripts/sync-to-research.sh  present
  ✓ ../research/{module}/        exists ({N} papers)
  — or —
  — Not connected                (run panel:setup --connect)

Papers:
  ✓ panel-static-analysis       _panel.yaml ✓  venue: PLDI 2026     stage: draft
  ✓ panel-command-dsl            _panel.yaml ✓  venue: OOPSLA 2026   stage: draft

All 2 papers ready. Next: Create plan.md in each paper, then panel:author to write, or panel:review to start reviews.
```
