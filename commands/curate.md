---
name: panel:curate
description: Curate a research module toward 9.0+ panel score. Diagnoses track health against the three structural properties, identifies weak links and orphan papers, and writes a CURATION.md plan with per-track surgery options.
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - AskUserQuestion
---

# panel:curate — Module Curation Toward 9.0+

Curate a research module to reach 9.0+. Creates CURATION.md in the module's
research directory. Reference benchmark: gravity:downward-signal scored 9.37/10.

## Plugin Root + Config

```javascript
// @import ../shared/project-config.md
// @import ../shared/module-utils.md

const projectConfig = loadProjectConfig();
const researchDir = path.join(process.cwd(), projectConfig.researchPath);
```

## Arguments

- `<module-name>` — Module slug to curate (default: current project)
- `--level <A|B|C|D>` — Skip diagnosis, go straight to a curation level
- `--track <name>` — Curate a specific track only
- `--apply` — Apply CURATION.md immediately after writing (asks confirmation)

---

## The Three Properties

**Property 1 — CAUSAL CHAIN**: Papers in each track form a logical sequence. Reviewers see a program, not a collection.

**Property 2 — NO WEAK LINKS**: Every paper scores ≥ 8.0. One paper at 6.5 drags a track from A- to B+. Fix the weakest link first.

**Property 3 — ACTIONABLE NUMBERS**: Every key finding has a specific quantified number that changes a decision.

---

## Step 1 — Load Module State

```javascript
const moduleFile = path.join(researchDir, 'MODULE.md');
const panelReview = path.join(researchDir, 'REVIEW_PANEL.md');
const revisionPlan = path.join(researchDir, 'PANEL-REVISION-PLAN.md');

const module = parseModule(moduleFile);        // tracks, paper assignments
const panel = parsePanelReview(panelReview);   // module score, track scores, PP items
```

For each paper: read `_panel.yaml` (stage, round, avg_score) and `reviews/SYNTHESIS.md` (P1/P2 items, individual scores).

Identify:
- Current module score and tier
- Track scores (from REVIEW_PANEL.md track section)
- Papers ranked lowest to highest score
- Unaddressed PP1 items
- Orphan papers (no track in MODULE.md)
- Broken chain links (paper in track has no connection to prior)

---

## Step 2 — Diagnose Against Three Properties

### Diagnosis 1 — Causal Chain (per track)

For each track, ask: "Can I write the chain sentence?":
```
"Paper A establishes [X] → Paper B's question requires [X] → Paper B reveals [Y]
→ Paper C operationalizes [Y] as [Z]"
```

Grade each track:
- **Strong**: chain sentence works, cross-citations present in text
- **Partial**: chain logic exists in design but cross-citations missing in writing
- **Weak**: papers are independent — same theme, no causal dependency
- **Broken**: a paper in the chain is missing or at wrong stage

Grade each paper's chain connection:
- **Connected**: explicitly cites prior paper's finding with a number
- **Isolated**: stands alone — no mention of how it builds on the prior
- **Misplaced**: belongs to a different track or chain position

### Diagnosis 2 — Weak Links (per track)

List papers scoring < 7.5. For each weak paper, classify the weakness:
- **Methodological**: needs primary data or experiment (vignette insufficient)
- **Theoretical**: mechanism underspecified, grounding thin
- **Structural**: doesn't fit the track logic — wrong paper for this position
- **Numerical**: key finding stated as mechanism without measurement

Structural misfits → consider removal or merger, not revision.

### Diagnosis 3 — Actionable Numbers

For each paper, check the key finding. Does it have:
- A specific percentage or ratio?
- A specific time or threshold?
- A specific effect size or correlation?
- A specific count or rate?

Papers phrased as "X tends to Y" without a number → flag for quantification surgery.

### Diagnosis 4 — Track Coverage (new vs gravity)

Check MODULE.md track assignments:
- **Orphan papers**: papers with no track — what track could they join?
- **Single-paper tracks**: tracks with only one paper — need another paper or merge with adjacent track
- **Cross-cutting gaps**: papers that *should* serve two tracks but don't

---

## Step 3 — Present Curation Options

```
question: "Diagnosis complete. Here are the curation levels:

A. Series arc + PP1 fixes (~1-2 sessions, +0.8 to +1.2)
   Add track series arc paragraphs to all paper introductions.
   Fix unaddressed PP1 items.
   Assign orphan papers to tracks.

B. Weak link surgery (~2-3 sessions, +1.5 to +2.0)
   Everything in A, plus:
   Targeted rewrites of papers scoring < 7.5.
   Add quantified findings where missing.
   Add cross-citations linking chain papers.

C. Full curation (~4-5 sessions, +2.0 to +3.0)
   Everything in B, plus:
   Merge overlapping papers, remove structural misfits.
   Reorder papers within tracks for causal flow.
   Add missing experiments/studies for papers without numbers.
   Redesign single-paper tracks.

D. Merger/restructure (~3 sessions after build, +2.5 to +4.0)
   Combine weak papers into super-papers with \part{} structure.
   A 6.2 + 7.0 paper merged correctly produces ~8.0+.
   Use when: 3+ papers scoring < 7.0, or papers thematically overlapping
   but narratively isolated.

Which level for [module-name]?"
```

---

## Step 3D — Level D: Merger Design

If Level D:

**3D.1 — Identify merger groups** by track position. Papers in the same track chain
position that are weak individually but share a causal frame are merger candidates.

**3D.2 — Design super-papers**:
```
Super-paper: [name]
\part{Part I: [Title]} — source: paper-A
\part{Part II: [Title]} — source: paper-B

Unified abstract: [one paragraph subsuming both papers' key findings and numbers]
Track assignments: [carries the track assignments of both source papers]
Chain position: [replaces both paper-A and paper-B in the track chain]
```

**3D.3 — Update track chain**: After merger, the track chain shrinks by one link.
Verify the chain sentence still works.

**3D.4 — Archive originals**: Move source papers to `_archived/` before building super-papers.

---

## Step 4 — Write CURATION.md

Create `${researchDir}/CURATION.md`:

```markdown
# Curation Plan: [Module Name]

**Current score**: [N]/10 ([tier])
**Target**: 9.0+ (A+)
**Level**: [A/B/C/D]
**Estimated sessions**: [N]
**Diagnosed**: [date]

---

## Track Health

| Track | Score | Chain | Weak links | Numbers | Status |
|-------|-------|-------|------------|---------|--------|
| Track A | 8.1 | Strong | none | 3/3 | ✓ Healthy |
| Track B | 6.8 | Partial | paper-3 (6.4) | 2/3 | ⚠ Needs work |
| Track C | — | Broken | — | — | ✗ Missing paper |

---

## Series Arc Surgery (Property 1)

**Gap**: [which tracks lack arc paragraphs in paper introductions]

**Proposed arc per track**:

### Track A arc
> [LaTeX paragraph to insert into every Track A paper's Introduction]

### Track B arc
> [LaTeX paragraph]

**Action**: Insert arc paragraphs into sections/01-introduction.tex for each paper.
**Cross-citation fixes**: [list papers that need to cite prior paper's specific number]

---

## Weak Link Surgery (Property 2)

| Paper | Track | Score | Weakness | Action |
|-------|-------|-------|----------|--------|
| paper-3 | B | 6.4 | No primary data | Add vignette study |
| paper-5 | C | 6.9 | Mechanism only | Add quantification |

### paper-3 (Track B, 6.4/10)
- **Core weakness**: Relies on secondary analysis — no primary measurement
- **Option A (fix)**: Add N=40 vignette study; primary number: [X%] vs [Y%]
- **Option B (merge)**: Merge with paper-4 into super-paper — both address [theme]
- **Option C (remove)**: Remove — Track B chain works as paper-2 → paper-4 directly
- **Recommendation**: B (merger produces cleaner chain)

---

## Quantification Surgery (Property 3)

| Paper | Current finding | Missing number | How to get it |
|-------|----------------|----------------|---------------|
| paper-5 | "X tends to increase" | Effect size | Regression on existing data |

---

## Track Coverage Surgery

**Orphan papers** (no track assigned):
- paper-7: theme overlaps Track B — recommend assigning to B, position 3
  Or remove if it doesn't fit the chain

**Single-paper tracks**: none

---

## PP1 Items (from convene)

| Item | Track | Action |
|------|-------|--------|
| PP1.1 Missing baselines | A | Add GPT-4 baseline to paper-1 results |
| PP1.2 Weak threat model | B | Add threats-to-validity subsection in paper-3 |

---

## Execution Order

1. [Highest impact, fastest — e.g., series arc insertion across all papers]
2. [Next — e.g., paper-3 merger design]
3. [Then — e.g., paper-5 quantification]
4. Re-run panel:convene after steps 1-3 to check score movement
5. [Continue if score < 9.0]

**Stop condition**: Re-run panel:convene after each batch. Stop when module ≥ 9.0.

---

## What to Preserve

[Findings the panel praised — do NOT change these]

---

*panel:curate. Run panel:convene after each batch to track score movement.*
```

---

## Step 5 — Apply Immediately (if `--apply`)

Ask confirmation, then:

**Levels A, B, C**:
1. Insert series arc paragraphs into all paper introductions (Edit tool)
2. Add cross-citations for chain papers (Edit sections)
3. Address unblocked PP1 items
4. Add quantification statements to weak conclusions
5. Update MODULE.md track assignments for orphans

**Level D**:
1. Move source papers to `_archived/` directory
2. Create super-paper directories with `\part{}` structure
3. Copy sections from source papers into super-paper structure
4. Update `_panel.yaml` for each super-paper: `sources: [paper-A, paper-B]`, stage: draft
5. Update MODULE.md: replace source papers with super-paper in track chains

After applying: remind user to run `panel:convene` to measure score movement.

---

## Auto-Commit

```javascript
await gitCommitIfEnabled(
    `[panel] ${moduleName}: curation plan (Level ${level}) — target 9.0+`,
    [researchDir]
);
```

## Dependencies

- shared/project-config.md — researchPath, pluginRoot
- shared/module-utils.md — parseModule(), track operations
- shared/state-loader.md — paper state loading
- shared/git-helper.md — auto-commit
