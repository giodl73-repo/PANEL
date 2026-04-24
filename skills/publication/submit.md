# panel:publication submit

### `submit <name>`

Mark a publication as submitted to its target venue.

```
panel:publication submit token-efficiency
panel:publication submit token-efficiency --venue "EMNLP 2026" --date 2026-06-15
```

Updates `_panel.yaml`: `stage: submit`, records submission date and venue.
