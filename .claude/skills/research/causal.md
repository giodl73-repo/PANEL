# Research Protocol: Causal

Traces cause-effect chains in the paper's argument. Validates that claimed causal relationships are supported and identifies where causal steps are skipped.

## Protocol

### Step 1 — Extract Causal Claims

Read the plan.md and any existing sections. List every causal claim (X causes/leads to/produces/enables Y):

```
CAUSAL CHAIN:
C-01: [X] → [Y] (claimed in: [section/plan reference])
  Evidence class: [Experimental / Observational / Theoretical / Assumed]
  Strength: [STRONG / MODERATE / WEAK / UNSUPPORTED]

C-02: [Y] → [Z] (claimed in: [section/plan reference])
  Evidence class: ...
  Strength: ...
```

### Step 2 — Check for Skipped Steps

For each causal link, ask: is there a missing intermediate step?

```
SKIPPED STEPS:
C-01 → C-02: [Is Y→Z actually mediated by an unstated W?]
  Missing link: [Description of the gap, or "None — chain is complete"]
  Severity: [BLOCKING / ADVISORY]
```

A BLOCKING skip means the argument doesn't hold without the missing link.
An ADVISORY skip means the argument is weaker but survivable.

### Step 3 — Check Confounders

For each causal claim, identify plausible confounders:

```
CONFOUNDERS:
C-01: [X] → [Y]
  Confounder 1: [Z could cause both X and Y independently]
  Confounder 2: [W could mediate the relationship]
  Addressed in paper: [YES / NO / PARTIALLY]
```

### Step 4 — Directionality Check

For observational claims, verify the causal direction is justified:

```
DIRECTIONALITY:
C-01: [X] → [Y]
  Could Y → X instead? [YES / NO / UNCLEAR]
  Evidence for stated direction: [What supports X→Y over Y→X?]
```

### Step 5 — Chain Summary

```
Total causal claims: [N]
Well-supported: [N] (experimental or strong observational)
Moderate: [N] (observational with controls)
Weak: [N] (theoretical or assumed)
Unsupported: [N] (no evidence cited)

BLOCKING gaps: [N]
ADVISORY gaps: [N]
```

## Output

Append findings to `FINDINGS.md` under heading `## From: causal`

Each finding gets an F-NN ID:
```
F-NN: [One-sentence finding about a causal gap or confounder]
  Source: causal protocol
  Relevance: [Which section this affects]
  Impact: [HIGH / MEDIUM / LOW]
```
