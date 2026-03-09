---
name: panel:module
description: Design a research module with tracks and causal chains before writing any paper. Establishes theme, tracks, quantification contracts, and series arc paragraphs. Use before panel:author.
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - AskUserQuestion
---

# panel:module — Module Architecture Design

Design a research module architected for 9.0+ panel score from the start.
Every paper must belong to at least one track. Every track must be a causal chain.
No paper is written until the tracks, contracts, and arc paragraphs are locked.

Reference: The Downward Signal series (gravity research) scored 9.37/10. Its secret:
causal chain, no weak links, actionable numbers — all defined *before* writing paper 1.

## Plugin Root + Config

```javascript
// @import ../shared/project-config.md

const projectConfig = loadProjectConfig();
const researchDir = path.join(process.cwd(), projectConfig.researchPath);
const pluginRoot = projectConfig.pluginRoot;
```

## Arguments

- `<module-name>` — Module slug (e.g., "reviewer-simulation")
- `--status` — Show current MODULE.md track assignments and coverage
- `--assign <paper> <track>` — Assign an existing paper to a track
- `--track <name>` — Add a new track to an existing module
- `--check` — Validate all papers have ≥1 track, all tracks have ≥2 papers

---

## The Three Properties (from gravity:curate benchmark)

Every module must satisfy all three before any paper is written:

**Property 1 — CAUSAL CHAIN**
Papers within a track form a logical sequence where each is unintelligible without
the prior and constrains the next. Reviewers see a *program*, not a collection.
Test: "Paper A establishes X → Paper B's question requires X → Paper B reveals Y → Paper C operationalizes Y as Z"

**Property 2 — NO WEAK LINKS**
Every paper must be designed to score ≥ 8.0. A paper without primary data or a
quantified finding cannot score ≥ 8.0. If a planned paper can't produce a number,
redesign it before writing.

**Property 3 — ACTIONABLE NUMBERS**
Every key finding must have a specific quantified result that changes a decision.
The number must be specified in the design phase — not discovered during writing.

---

## Track Model

A module has 1–4 tracks. Each track is an independent causal chain within the module.

```
Track A: [theme]     paper-1 → paper-3 → paper-5   (3 papers, full chain)
Track B: [theme]     paper-2 → paper-4              (2 papers, minimum viable chain)
Track C: [theme]     paper-1 → paper-4 → paper-6   (cross-cutting — paper-1 and paper-4 serve two chains)
```

**Rules:**
- Every paper belongs to ≥1 track (orphan papers are a warning)
- Each track needs ≥2 papers to form a chain
- Cross-cutting papers earn their place in multiple chains
- A single-paper "track" is not a track — it's an orphan

---

## Execution Flow

### Mode: Design new module (`panel:module <name>`)

#### Step 0 — Load context

```javascript
const moduleName = args[0];
const moduleDir = path.join(researchDir, moduleName);
const moduleFile = path.join(moduleDir, 'MODULE.md');

// Check if MODULE.md already exists
if (exists(moduleFile)) {
    msg(`MODULE.md already exists. Use --status to review or --track to add a track.`, 'info');
    return showModuleStatus(moduleFile);
}
```

Ask:
```
question: "What is the research theme for this module? Give me 2-3 sentences on what
           research questions it should answer — the problem space, not the paper list."
header: "Module Theme"
```

#### Step 1 — Track design

Present the track model. Ask the user to propose tracks, or offer to draft them:

```
question: "How many research tracks should this module have?"
header: "Track Count"
options:
  - label: "1 track — single focused chain (2-5 papers)"
    description: "Linear causal chain, simplest to execute, easiest to score high"
  - label: "2 tracks — parallel chains (4-8 papers)"
    description: "Two independent causal arguments that reinforce each other"
  - label: "3 tracks — multi-perspective module (5-10 papers)"
    description: "Three angles on the same theme — methodology, empirical, theoretical"
  - label: "Let me draft the tracks first"
    description: "I'll propose tracks based on the theme you described"
```

If "draft tracks": propose 2-3 tracks based on the theme using AskUserQuestion to confirm.

For each track, collect:
```
- Track name (short slug, e.g., "methodology", "empirical", "theory")
- Track theme (1 sentence: what causal question does this chain answer?)
- Planned papers (slugs, can be TBD): paper-1 → paper-2 → paper-3
```

**Chain validation** — after all tracks defined, write the chain sentence for each:
```
Track A: "We first establish [P1 finding], which reveals [P2 question],
          showing [P2 finding], which allows us to [P3 action]."
```
If any sentence is incoherent, flag it and ask user to redesign that track.

#### Step 2 — Paper-to-track assignment

For each paper in the module (or planned paper), confirm track assignment:

```javascript
for (const paper of plannedPapers) {
    AskUserQuestion({
        question: `Which tracks does "${paper}" belong to?`,
        options: tracks.map(t => ({ label: t.name, description: t.theme })),
        multiSelect: true
    });
}
```

Papers with no track selected → warning: "This paper is an orphan. Either assign it
to a track or explain why it belongs in this module."

#### Step 3 — Quantification contracts

For each paper, specify before writing:

```
Paper: [slug]
Tracks: [A, C]
Primary number: [specific metric — e.g., "43% vs 7% approval rate"]
Experiment/study: [vignette / user study / benchmark / regression — specific design]
Decision this number changes: [who decides what differently because of this]
If null result: [what the null finding means — this must still be publishable]
```

**Quantification gate**: A paper that cannot specify a primary number is not ready.
It needs one of:
- A redesigned experiment that will produce a number
- A merger with an adjacent paper in the same track
- Removal from the module

Present contracts to user. Ask: "Does each paper have a number? Any too speculative to commit?"

#### Step 4 — Series arc paragraphs

Write one series arc paragraph per track. This paragraph goes verbatim (adapted per
paper) into every paper's introduction that belongs to this track.

```latex
\textbf{This paper is part of the [Module Name] — [Track Name] series.}
[Paper-1 title] establishes [finding-1 with number].
[Paper-2 title] shows that [finding-2 with number].
This paper [Paper-N's specific role in the chain].
```

This paragraph **cannot be written** until quantification contracts are filled,
because it must include the specific numbers from each paper.

Also write a **module arc** — one paragraph spanning all tracks:
```latex
\textbf{[Module Name] research program.}
The [Track-A] series establishes [Track-A chain summary].
The [Track-B] series shows [Track-B chain summary].
Together, these tracks address [the overarching module theme].
```

#### Step 5 — Write MODULE.md

Create `${researchDir}/MODULE.md`:

```markdown
# Module: [Module Name]

**Theme**: [2-3 sentence research question]
**Created**: [date]
**Target venues**: [list]

---

## Tracks

### Track A: [name]
**Theme**: [1 sentence causal question]
**Chain**: paper-slug-1 → paper-slug-2 → paper-slug-3
**Causal logic**:
- paper-slug-1 establishes [X]
- paper-slug-2 builds on [X] to reveal [Y]
- paper-slug-3 operationalizes [Y] as [Z]

**Series arc paragraph** (inject into every Track A paper's introduction):
> [LaTeX paragraph — includes actual numbers from contracts]

---

### Track B: [name]
[same structure]

---

## Papers

| Paper | Tracks | Primary Number | Status | Venue |
|-------|--------|----------------|--------|-------|
| paper-slug-1 | A, C | [number] | planned | [venue] |
| paper-slug-2 | A | [number] | planned | [venue] |

---

## Quantification Contracts

### paper-slug-1
- **Primary number**: [specific metric]
- **Experiment**: [design]
- **Decision this changes**: [who decides what]
- **Null fallback**: [what null means]

[repeat per paper]

---

## Module Arc

[LaTeX paragraph spanning all tracks — goes in every paper's introduction]

---

## Self-Score (Three Properties)

| Property | Status | Notes |
|----------|--------|-------|
| Causal Chain | Strong / Partial / Weak | [per track] |
| No Weak Links | N papers at risk | [which ones] |
| Actionable Numbers | N/M papers have numbers | [gaps] |

**Estimated panel score**: [N]/10

---

## Track Coverage

| Track | Papers | Chain complete? | Numbers? | Est. score |
|-------|--------|----------------|----------|-----------|

---

*Generated by panel:module. Update as papers are written and reviewed.*
```

#### Step 6 — Create paper plan.md files

For each planned paper, create `${researchDir}/${paper}/plan.md` from the module design:

```markdown
# Paper Plan: [Title]

## Research Question
[From quantification contract]

## Module Context
**Module**: [module name]
**Tracks**: [Track A, Track C]
**Role in chain**: [what this paper establishes and what it makes possible]
**Series arc** (inject into Introduction verbatim):
> [Track A arc paragraph]
> [Track C arc paragraph, if different]

## Target Venue
[From MODULE.md]

## Primary Number to Produce
[From quantification contract — this is the design target]

## Sections
[Standard section list for venue type]

## Experiments
- [ ] [From quantification contract experiment design]
```

#### Step 7 — Self-score against Three Properties

Before committing, score the module:

**Property 1** — can you write the chain sentence for each track?
**Property 2** — for each paper, estimate score: primary data (+2), number (+2), mechanism (+2), chain connection (+2), related work (+1), formal model (+1). Papers ≤ 6 need redesign.
**Property 3** — list all numbers. Every paper must have one.

If any property is Weak or any paper scores ≤ 6: fix before writing.

#### Step 8 — Report

```
Module: [name]
Tracks: [N tracks]
Papers: [N planned]

Track A: paper-1 → paper-2 → paper-3  [3 papers, chain: Strong]
Track B: paper-2 → paper-4            [2 papers, chain: Strong]
Track C: paper-1 → paper-4 → paper-5  [3 papers, chain: Partial — paper-5 needs number]

Paper coverage:
  ✓ paper-1: Track A, C  — number: [X]
  ✓ paper-2: Track A, B  — number: [Y]
  ✗ paper-5: Track C     — number: TBD (quantification contract incomplete)

Self-score:
  Property 1 (Causal Chain):      Strong (A), Strong (B), Partial (C)
  Property 2 (No Weak Links):     1 paper at risk (paper-5)
  Property 3 (Actionable Numbers): 4/5 papers have numbers

Estimated panel score: 7.2/10
To reach 9.0+: complete paper-5's quantification contract before writing

Next: panel:author --paper paper-1
```

---

### Mode: Status (`panel:module --status`)

Read `${researchDir}/MODULE.md` and display:
- Track definitions and chain completeness
- Paper-to-track coverage table (highlighting orphans)
- Quantification contract completion
- Papers written vs planned per track
- Estimated score per track

### Mode: Assign paper to track (`panel:module --assign <paper> <track>`)

Update `MODULE.md` paper table: add track to paper's track list.
Validate: is the paper now in the right position in the track chain? Warn if it
breaks causal order.

### Mode: Add track (`panel:module --track <name>`)

Interactive: collect track theme, chain order, assign existing papers.
Append track to MODULE.md.

### Mode: Check (`panel:module --check`)

Validate:
- Every paper in `researchDir` with `_panel.yaml` has ≥1 track in MODULE.md
- Every track has ≥2 papers
- Every paper has a quantification contract
- No track's chain is broken (papers exist in the stated order)

Output:
```
Module check — [name]
══════════════════════════════
✓ Track A: 3 papers, chain complete
✓ Track B: 2 papers, chain complete
⚠ Track C: paper-5 has no quantification contract
✗ paper-7: orphan — not assigned to any track
```

---

## Auto-Commit

After creating or updating MODULE.md:
```javascript
await gitCommitIfEnabled(
    `[panel] ${moduleName}: module architecture — ${tracks.length} tracks, ${papers.length} papers`,
    [moduleDir]
);
```

## Dependencies

- shared/project-config.md — researchPath, pluginRoot
- shared/module-utils.md — MODULE.md parsing, track operations
- shared/git-helper.md — auto-commit
- templates/module-template.md — MODULE.md template
