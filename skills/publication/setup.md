# panel:publication setup

### `setup <name> [venue]`

Initialize a new LaTeX publication directory.

```
panel:publication setup token-efficiency "EMNLP 2026"
panel:publication setup token-efficiency    # prompts for venue
```

Creates:
- `{publicationsDir}/{slug}/main.tex` — LaTeX skeleton
- `{publicationsDir}/{slug}/sections/` — 6 section files
- `{publicationsDir}/{slug}/reviews/`
- `{publicationsDir}/{slug}/Makefile` — from `templates/makefile-publication.mk` (`dist` → `../../docs/`)
- `{publicationsDir}/{slug}/_panel.yaml`
- `{publicationsDir}/{slug}/REVISION-PLAN.md`
- `{publicationsDir}/Makefile` — from `templates/makefile-publications.mk` (if not present)
- `{researchDir}/Makefile` — from `templates/makefile-module.mk` (if not present)
- `{researchDir}/docs/` — created if missing

**From MODULE.md**: if the module has a track assignment for this publication slug,
seeds `plan.md` with track context and arc paragraphs.

**Batch**: `panel:publication setup alpha beta gamma "CHI 2026"`
