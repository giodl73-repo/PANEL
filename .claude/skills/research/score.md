# Research Protocol: Score

Author-side quality self-assessment using a 5-dimension rubric (25-point scale). Independent of the panel review process — this is for the author to gauge readiness before or after review.

## The CEMCK Rubric

5 dimensions, 5 points each, 25 maximum:

| Dim | Name | 5 (Excellent) | 3 (Solid) | 1 (Weak) |
|-----|------|---------------|-----------|----------|
| **C** | **Claim** | Falsifiable, one-sentence, specific | Clear but could be sharper | Vague or unfalsifiable |
| **E** | **Evidence** | Named sources, specific numbers, honest [NEED] tags | Sources present but some generic | Vague sourcing, no numbers |
| **M** | **Method** | Appropriate, reproducible, null fallback stated | Method clear but gaps | Method unclear or missing |
| **C** | **Contribution** | Connection to field natural, cross-refs accurate, novel | Connection present but forced | No clear contribution or redundant |
| **K** | **Craft** | Venue-appropriate register, tables, clean structure | Readable but rough edges | Poor structure, wrong register |

### Thresholds

| Score | Status | Meaning |
|-------|--------|---------|
| 22-25 | Camera-ready | Publishable with minor polish |
| 18-21 | Solid | Needs targeted revision on weak dimensions |
| 14-17 | Adequate | Needs significant work on 2+ dimensions |
| <14 | Needs rewrite | Fundamental issues across multiple dimensions |

## Protocol

### Step 1 — Read the Paper

Read plan.md, all sections, and any existing FINDINGS.md. Note [NEED] tags.

### Step 2 — Score Each Dimension

For each dimension, provide a score with specific justification:

```
CLAIM: [1-5]
  Justification: [Why this score — cite specific text from the paper]
  To improve: [What would raise the score by 1 point]

EVIDENCE: [1-5]
  Justification: [Why this score]
  [NEED] tags found: [N]
  To improve: [What would raise the score]

METHOD: [1-5]
  Justification: [Why this score]
  Null fallback stated: [YES/NO]
  To improve: [What would raise the score]

CONTRIBUTION: [1-5]
  Justification: [Why this score]
  To improve: [What would raise the score]

CRAFT: [1-5]
  Justification: [Why this score]
  Venue appropriateness: [Good fit / Needs adjustment]
  To improve: [What would raise the score]
```

### Step 3 — Dimension Analysis

```
DIMENSION RANKING:
  Strongest: [dimension] ([score])
  Weakest: [dimension] ([score])
  Largest gap to next level: [dimension] ([current] → [target])
```

### Step 4 — [NEED] Tag Inventory

Count and categorize unfilled [NEED] tags:

```
[NEED] INVENTORY:
  [NEED: data] — [N] occurrences
  [NEED: compute] — [N] occurrences
  [NEED: source] — [N] occurrences
  [NEED: citation] — [N] occurrences
  Total: [N]

  Impact on score: Filling all [NEED] tags would likely raise score by [N] points
```

### Step 5 — Score Card

```
═══════════════════════════════════════════════════════
SCORE CARD: [paper topic]
═══════════════════════════════════════════════════════

  C (Claim):         [score]/5  [bar visualization: ████░]
  E (Evidence):      [score]/5  [bar visualization: ███░░]
  M (Method):        [score]/5  [bar visualization: ████░]
  C (Contribution):  [score]/5  [bar visualization: ██░░░]
  K (Craft):         [score]/5  [bar visualization: █████]
                     ─────────
  TOTAL:             [sum]/25

  STATUS: [Camera-ready / Solid / Adequate / Needs rewrite]

  Top 3 improvements (highest leverage):
  1. [Specific action that would gain the most points]
  2. [Next highest leverage action]
  3. [Third highest leverage action]

  [NEED] tags: [N] unfilled
═══════════════════════════════════════════════════════
```

## Output

Write the score card to the paper directory as `_score.md`.

Append a finding to `FINDINGS.md` under heading `## From: score`:
```
F-NN: Score [total]/25 — [status]. Weakest: [dimension] ([score]/5)
  Source: score protocol
  Relevance: Entire paper
  Impact: HIGH
```
