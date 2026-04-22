# panel:paper promote

## `promote <name>`

Graduate a markdown paper to a formal LaTeX publication in `publicationsPath`.

```
panel:paper promote my-quick-research
panel:paper promote my-quick-research --venue "CHI 2026"
```

**What it does:**
1. Reads the paper's markdown content and `_panel.yaml`
2. Creates a new publication directory in `publicationsPath/`
3. Converts markdown content → LaTeX skeleton (main.tex + sections/)
4. Copies `_panel.yaml` with `type: publication`, `promoted_from: <paper-slug>`
5. Creates `plan.md` seeded from the paper's existing content
6. Updates MODULE.md: replaces paper with publication in track assignments
7. Marks original paper as `promoted` in its `_panel.yaml`

**Result:** The publication starts at `draft` stage, ready for `panel:publication author`
to fill in the formal LaTeX sections using the markdown paper as source material.

```
✓ Promoted: my-quick-research → publications/panel-my-quick-research/
  Track assignments carried over: [A, C]
  Next: panel:publication author panel-my-quick-research
```
