# panel:publication author

### `author [targets]`

Write LaTeX sections from `plan.md`. Injects track arc paragraphs into Introduction.

```
panel:publication author                     # all draft publications with plan.md
panel:publication author token-efficiency    # single
panel:publication author 1 3                 # by index
panel:publication author --track methodology # by track
```

**For each publication:**
1. Load `plan.md` and `_panel.yaml`
2. Load track context from `MODULE.md` — arc paragraphs for each track
3. Warn if no track assignment
4. Write sections sequentially: introduction → related-work → methodology → evaluation → discussion → conclusion
5. **Introduction**: inject track arc paragraphs after contributions list
6. Run experiments/scripts listed in plan.md
7. Compile PDF (`make pdf`)
8. Update `_panel.yaml`: `content_mode: full`, `writing_completed: true`

**Track arc injection** (Introduction):
```latex
% --- Research program context ---
% Track methodology: [arc paragraph from MODULE.md]
% Track empirical: [arc paragraph, if publication belongs to this track too]
```
