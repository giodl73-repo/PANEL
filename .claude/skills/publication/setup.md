# panel:publication setup

### `setup <name> [venue]`

Initialize a new LaTeX publication directory.

```
panel:publication setup token-efficiency "EMNLP 2026"
panel:publication setup token-efficiency    # prompts for venue
```

**Slug rule**: the publication directory name is a bare slug — do NOT prefix it with the
module name (e.g. `review-methodology`, not `panel-review-methodology`). The module is
the parent directory. The generated PDF *is* module-prefixed (`panel-review-methodology.pdf`)
so a shared global `docs/` across modules avoids collisions.

Creates:
- `{publicationsDir}/{slug}/main.tex` — LaTeX skeleton
- `{publicationsDir}/{slug}/sections/` — 6 section files
- `{publicationsDir}/{slug}/reviews/`
- `{publicationsDir}/{slug}/Makefile` — from `templates/makefile-publication.mk`
  with `{{MODULE}}` substituted from the active project's `projectName`
  (`.claude/panel.json`). `dist` produces `../../docs/{module}-{slug}.pdf`.
- `{publicationsDir}/{slug}/_panel.yaml`
- `{publicationsDir}/{slug}/REVISION-PLAN.md`
- `{publicationsDir}/Makefile` — from `templates/makefile-publications.mk` (if not present)
- `{researchDir}/Makefile` — from `templates/makefile-module.mk` (if not present)
- `{researchDir}/docs/` — created if missing

**From MODULE.md**: if the module has a track assignment for this publication slug,
seeds `plan.md` with track context and arc paragraphs.

**Batch**: `panel:publication setup alpha beta gamma "CHI 2026"`
