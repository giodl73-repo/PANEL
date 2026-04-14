# board misc — member + update

Small utility sub-commands for targeted board operations.

---

## `member <name>`

Regenerate one board member's assessment. Loads their profile,
builds OLE context, regenerates assessment, re-runs synthesis.
No new round.

```
panel:board member "Percy Liang"
```

---

## `update <section>`

Targeted refresh of a specific REVIEW_BOARD.md section without full re-review.

| Section | What it updates |
|---------|----------------|
| `registry` | Re-scan modules, update panel status |
| `board` | Re-select board members |
| `tracks` | Re-run cross-module track alignment |
| `synthesis` | Re-run synthesis from existing assessments |
| `rankings` | Recalculate module rankings |
| `themes` | Re-extract cross-module themes |
| `revisions` | Regenerate per-module revision plans |
| `all` | Full refresh (equivalent to `review`) |
