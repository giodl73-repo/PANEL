# Research Protocol: Dimensional

Dimensional analysis for STEM papers. Verifies that units are consistent across all equations — LHS units must equal RHS units. Catches a class of errors that algebraic checking misses.

**Paper type**: STEM only. Skip for non-mathematical papers.

## Protocol

### Step 1 — Build Unit Registry

Extract all physical quantities and their units from the paper:

```
UNIT REGISTRY:
U-01: [symbol] — [quantity name] — [SI units]
U-02: [symbol] — [quantity name] — [SI units]
...
```

Include every symbol used in any equation, with its declared or implied units.

### Step 2 — Equation-by-Equation Check

For each equation in the paper:

```
EQUATION E-01: [equation]
  LHS units: [derived from unit registry]
  RHS units: [derived from unit registry]
  Match: [YES / NO / CONDITIONAL]

  If NO:
    LHS: [units]
    RHS: [units]
    Discrepancy: [what's wrong]
    Severity: [P1 / P2 / P3]
```

### Step 3 — Special Checks

**Exponential/logarithm arguments must be dimensionless:**
```
EXP/LOG CHECK:
  exp([argument]) in E-03:
    Argument units: [must be dimensionless]
    Status: [PASS / FAIL]
```

**Additions/subtractions must have matching units:**
```
ADDITION CHECK:
  [term1] + [term2] in E-05:
    Term 1 units: [units]
    Term 2 units: [units]
    Match: [YES / NO]
```

**Equality/comparison operands must have matching units:**
```
COMPARISON CHECK:
  [quantity1] > [quantity2] in Section 4:
    LHS units: [units]
    RHS units: [units]
    Match: [YES / NO]
```

### Step 4 — Dimensional Summary

```
═══════════════════════════════════════════════════════
DIMENSIONAL CHECK: [paper topic]
═══════════════════════════════════════════════════════

Symbols registered: [N]
Equations checked: [N]

Dimensional errors: [N]
  P1 (dimensionally wrong): [N]
  P2 (hidden unit assumption): [N]
  P3 (notational ambiguity): [N]

Special checks:
  Exp/log arguments: [N] checked, [N] violations
  Addition terms: [N] checked, [N] violations
  Comparisons: [N] checked, [N] violations

VERDICT: [PASS / FAIL]
═══════════════════════════════════════════════════════
```

## Output

Append findings to `FINDINGS.md` under heading `## From: dimensional`

Each error gets an F-NN ID:
```
F-NN: Dimensional error in E-[NN] — [description]
  Source: dimensional protocol
  Severity: [P1 / P2 / P3]
  Relevance: [Section containing the equation]
  Impact: [HIGH if P1, MEDIUM if P2, LOW if P3]
```
