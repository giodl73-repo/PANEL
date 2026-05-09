# panel:module design

## `design [name]`

Design a new module or inspect/update an existing one. Interactive flow:

1. **New module**: theme -> tracks -> paper-to-track assignments -> quantification
   contracts -> series arc paragraphs -> MODULE.md -> per-paper plan.md files
2. **Existing module** (`MODULE.md` found): show current design, offer to add tracks
   or update contracts

**Three Properties** (from gravity:downward-signal 9.37/10 benchmark):
- **Causal Chain**: each paper in a track is unintelligible without the prior
- **No Weak Links**: every paper designed to score >= 8.0
- **Actionable Numbers**: every finding has a specific quantified result

**Modes**:
```
panel:module design                 # design current module
panel:module design my-module       # design named module
panel:module design --status        # show current design
panel:module design --assign p t    # assign paper to track
panel:module design --track name    # add a track
panel:module design --check         # validate coverage
```

Full logic in the design handler below.

---

## Design Handler (full)

When `panel:module design` runs on a new module:

### Step 1 — Theme
Ask: "What is the research theme? 2-3 sentences on what questions this module answers."

### Step 2 — Track count
1 track (focused chain) / 2 tracks (parallel) / 3 tracks (multi-perspective) / draft for me

### Step 3 — Track design
For each track: name, theme, planned paper chain.
Write chain sentence: "Paper A establishes X -> Paper B requires X -> reveals Y -> Paper C operationalizes Y as Z"
If incoherent: redesign.

### Step 4 — Paper-to-track assignment
For each planned paper: which tracks? (multiSelect)
Orphan warning if none selected.

### Step 5 — Quantification contracts
Per paper: primary number, experiment design, decision it changes, null fallback.
Gate: no paper may skip its contract.

### Step 6 — Series arc paragraphs
One LaTeX paragraph per track (with actual numbers from contracts).
Module arc paragraph spanning all tracks.
Cannot be written until contracts are complete.

### Step 7 — Write MODULE.md + per-paper plan.md files

### Step 8 — Self-score against three properties
Report estimated panel score. Flag papers scoring <= 6 on the rubric.
