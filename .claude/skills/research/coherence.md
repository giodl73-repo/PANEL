# Research Protocol: Coherence

Cross-finding contradiction checker. Requires 2+ prior research sub-skills to have run (findings in FINDINGS.md). Surfaces contradictions between findings with severity classification.

## Prerequisites

At least 2 of the following must have produced findings:
- hypothesis, competitors, causal, websearch, argument, derivation

If fewer than 2 have run, STOP and report: "Coherence requires 2+ prior discovery signals. Run more sub-skills first."

## Protocol

### Step 1 — Inventory Findings

Read FINDINGS.md. Catalog all findings by source:

```
FINDING INVENTORY:
  From hypothesis: F-01, F-02, F-03
  From competitors: F-04, F-05, F-06, F-07
  From causal: F-08, F-09
  From websearch: F-10, F-11, F-12
  Total: [N] findings across [M] sources
```

### Step 2 — Detect Contradictions

Compare findings pairwise across sources. Look for three types:

**Rating Conflict**: Two sources give opposing assessments of the same thing.
```
CONFLICT RC-01:
  Finding A: F-04 (competitors) — "Status quo handles this adequately"
  Finding B: F-01 (hypothesis) — "Current approaches fail at X"
  Type: rating-conflict
  Severity: [BLOCKING / ADVISORY]
  Resolution: [What would resolve this — new evidence, reframing, or scope change?]
```

**Prediction Conflict**: Two findings predict incompatible outcomes.
```
CONFLICT PC-01:
  Finding A: F-08 (causal) — "X leads to Y under condition Z"
  Finding B: F-11 (websearch) — "Evidence shows X does not lead to Y"
  Type: prediction-conflict
  Severity: [BLOCKING / ADVISORY]
  Resolution: [What would resolve this?]
```

**Evidence Conflict**: Two sources cite contradictory data.
```
CONFLICT EC-01:
  Finding A: F-10 (websearch) — "Study reports effect size of 0.3"
  Finding B: F-12 (websearch) — "Meta-analysis reports effect size of 0.1"
  Type: evidence-conflict
  Severity: [BLOCKING / ADVISORY]
  Resolution: [What would resolve this?]
```

### Step 3 — Severity Classification

- **BLOCKING**: The contradiction undermines the paper's central claim or methodology. Cannot proceed to writing without resolution.
- **ADVISORY**: The contradiction affects a secondary point or can be addressed in the Discussion section. Can proceed but should be noted.

### Step 4 — Coherence Verdict

```
═══════════════════════════════════════════════════════
COHERENCE CHECK: [paper topic]
═══════════════════════════════════════════════════════

Findings analyzed: [N] across [M] sources
Contradictions found: [total]
  BLOCKING: [N]
  ADVISORY: [N]

BLOCKING items:
  RC-01: [one-line summary]
  PC-01: [one-line summary]

ADVISORY items:
  EC-01: [one-line summary]

VERDICT: [CLEAR / HAS BLOCKING / HAS ADVISORY ONLY]
═══════════════════════════════════════════════════════
```

## Output

Append findings to `FINDINGS.md` under heading `## From: coherence`

Each contradiction gets an F-NN ID:
```
F-NN: [BLOCKING/ADVISORY] — [One-sentence description of the contradiction]
  Source: coherence protocol
  Conflicting findings: F-XX vs F-YY
  Impact: [HIGH if BLOCKING, MEDIUM if ADVISORY]
```
