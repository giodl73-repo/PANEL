# panel:paper setup

## `setup <name> [venue]`

Initialize one or more paper directories. Each gets `_panel.yaml`, `sections/`,
`reviews/`, `Makefile`, `REVISION-PLAN.md`. Prompts for venue if not supplied.

**Bulk**: `panel:paper setup name-1 name-2 name-3 "ACL 2026"` — batch-initialize.
**From MODULE.md**: if MODULE.md exists, seeds `plan.md` with track context.

```javascript
for (const name of targetNames) {
    await setupPaper(name, venue, researchDir, pluginRoot, projectConfig);
}
```

See the setup skill's paper.md for the per-paper setup logic.
