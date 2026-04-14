# panel:module curate

## `curate [modules]`

Diagnose module against three properties and write CURATION.md.

**Single**: `panel:module curate`
**Level override**: `panel:module curate --level B`
**Specific track**: `panel:module curate --track methodology`

**Curation levels:**
- **A** — Series arc + PP1 fixes (+0.8 to +1.2)
- **B** — Weak link surgery (+1.5 to +2.0)
- **C** — Full curation (+2.0 to +3.0)
- **D** — Merger/restructure (+2.5 to +4.0)

Full diagnosis logic in `commands/curate.md`.
