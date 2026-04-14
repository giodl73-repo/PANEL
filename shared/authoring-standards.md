# Authoring Standards — Shared Writing Protocol

Common authoring standards used by `panel:paper author` and `panel:publication author`. Both paper types follow the same intellectual workflow; the output format differs (markdown vs LaTeX).

## Authoring Workflow

The authoring workflow is the same regardless of output format:

```
plan.md → load track context → write sections → inject track arcs → compile → update state
```

### Step 1 — Load Plan

Read `plan.md` from the paper directory. Extract:

- **Research question**: the core contribution
- **Core claim**: falsifiable, one-sentence (from Quantification Contract)
- **Primary number**: the key quantitative result to deliver
- **Methodology**: how evidence will be generated
- **Sections**: planned structure
- **Experiments/figures/tables**: deliverables

If plan.md has a Quantification Contract (v2.3.0+), extract:
- **Falsification condition**: what would disprove the claim
- **Null fallback**: what to conclude if the hypothesis fails
- **Decision it changes**: what practical decision the result informs

### Step 2 — Load Track Context

If `MODULE.md` exists in the research directory:

1. Find which tracks this paper belongs to
2. Extract arc paragraphs for each track
3. Extract the paper's position in each track chain
4. Identify predecessor papers (for cross-referencing)

If no MODULE.md or no track assignment: warn but continue. Track context is recommended but not required.

### Step 3 — Write Sections

Write sections in this order (adapting to the venue's expected structure):

| Section | Key Content | Quality Bar |
|---------|------------|-------------|
| **Introduction** | Motivation, problem statement, contributions list | Reader knows why this matters in 2 paragraphs |
| **Related Work** | Position against competitors, cite missing baselines | Every claim about prior work has a citation |
| **Methodology** | Approach, data, technique, reproducibility | Someone could replicate this from the description |
| **Evaluation** | Study design, metrics, procedures | Metrics match the claims being made |
| **Results** | Findings with specific numbers | Primary number from plan.md is delivered |
| **Discussion** | Implications, limitations, threats to validity | Limitations are honest, not performative |
| **Conclusion** | Summary and future work | No new claims introduced |

### Step 4 — Track Arc Injection

If track context was loaded, inject track arc paragraphs into the Introduction after the contributions list:

**For markdown papers:**
```markdown
> **Research program context**: This paper is part of Track [name] in the
> [module] research program. [Arc paragraph from MODULE.md]
```

**For LaTeX publications:**
```latex
% --- Research program context ---
% Track [name]: [arc paragraph from MODULE.md]
```

### Step 5 — Compile and Update State

- **Markdown papers**: no compilation needed
- **LaTeX publications**: run `make pdf`, check for errors
- Update `_panel.yaml`: set `writing_completed: true`

## Writing Quality Standards

These apply to ALL papers and publications:

### Content Standards

1. **Falsifiability**: Every claim should be falsifiable. If a statement can't be tested or disproved, rewrite it.
2. **Specificity**: Use specific numbers, not vague qualifiers. "Improves accuracy by 12%" not "significantly improves accuracy."
3. **Honesty**: Use `[NEED: data]`, `[NEED: compute]`, `[NEED: source]` tags for missing evidence rather than making unsupported claims.
4. **Citation discipline**: Every claim about prior work needs a citation. Every quantitative claim needs a source.
5. **Null awareness**: State what would happen if the hypothesis were wrong. Show you've considered it.

### Structural Standards

1. **One claim per paper**: The paper has one central claim, stated in one sentence. Everything else supports it.
2. **Section independence**: Each section should be readable on its own (with reasonable context from the Introduction).
3. **Figure/table justification**: Every figure and table must be referenced in the text. No decorative visuals.
4. **Contribution list**: The Introduction must end with a numbered list of contributions.

### [NEED] Tag Convention

Use honest placeholders when data is missing:

| Tag | Meaning | Example |
|-----|---------|---------|
| `[NEED: data]` | Specific data point not yet available | `[NEED: data] exact user count for Q4 2025` |
| `[NEED: compute]` | Computation not yet run | `[NEED: compute] Monte Carlo simulation with N=10000` |
| `[NEED: source]` | Citation not yet found | `[NEED: source] original study on X by Y et al.` |
| `[NEED: citation]` | Placeholder citation | `[NEED: citation] prior work establishing baseline` |
| `[NEED: figure]` | Figure not yet created | `[NEED: figure] scatter plot of X vs Y` |

Papers with unfilled [NEED] tags score lower on the Evidence dimension of the CEMCK rubric but are preferred over unsupported claims.

## Venue-Specific Adjustments

| Venue Type | Adjustments |
|-----------|-------------|
| **CS Systems** (CHI, UIST, CSCW) | Lead with user/design problem; evaluation includes user study |
| **ML** (NeurIPS, ICML, ICLR) | Formal problem statement; SOTA comparisons required; ablations expected |
| **NLP** (ACL, EMNLP) | Mention datasets/languages; benchmark improvements with specific numbers |
| **Biomedical** (Nature, PNAS) | Clinical/biological significance first; use field conventions |
| **Social Science** (Psych Science) | Behavioral phenomenon first; sample size and effect size in abstract |
| **Software Eng** (ICSE, FSE) | Industrial relevance; evaluation on real-world codebases |

## Dependencies

- `shared/plan-parser.md` — Parse plan.md into structured task objects
- `shared/module-utils.md` — MODULE.md parsing, track arc extraction
- `shared/quality-checker.md` — Pre-submission quality validation
- `templates/plan-template.md` — Plan structure with quantification contract
