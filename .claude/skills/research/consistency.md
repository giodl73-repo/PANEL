# Research Protocol: Consistency

Catches quantitative inconsistencies across paper sections. Finds mismatched numbers, contradictory claims, equation disagreements, and boundary condition violations.

## Protocol

### Step 1 — Build Quantity Registry

Read all paper sections. Extract every quantitative claim into a registry:

```
QUANTITY REGISTRY:
Q-01: [quantity name] = [value] (Section: [ref], Line: [approx])
Q-02: [quantity name] = [value] (Section: [ref], Line: [approx])
Q-03: [same quantity] = [different value] (Section: [ref], Line: [approx])
...
```

Include:
- Percentages, rates, counts, effect sizes
- Equation parameters and their stated values
- Thresholds and cutoff values
- Sample sizes and dataset properties
- Any specific number that appears in the text

### Step 2 — Value Consistency Check

For each quantity that appears more than once, verify consistency:

```
VALUE CHECK:
Q-01 vs Q-03: [quantity name]
  Value 1: [X] (Section: [ref])
  Value 2: [Y] (Section: [ref])
  Match: [YES / NO / ROUNDING]
  Severity: [P1 / P2 / P3]
```

Severity:
- **P1** (reject condition): Different numbers for the same quantity in different sections — readers will notice
- **P2** (confusing): Rounding differences that could mislead (e.g., "7.4%" vs "about 7%")
- **P3** (minor): Acceptable rounding or context-dependent precision

### Step 3 — Equation Consistency

For papers with equations, verify:

```
EQUATION CHECK:
EQ-01 vs EQ-02:
  Algebraic equivalence: [YES / NO / CONDITIONAL]
  If NO: [Where they diverge]
  If CONDITIONAL: [Under what conditions they agree]
```

### Step 4 — Boundary and Limit Conditions

Check that quantities behave correctly at extremes:

```
BOUNDARY CHECK:
Q-01: [quantity]
  When [parameter] → 0: [expected behavior] vs [stated behavior]: [CONSISTENT / INCONSISTENT]
  When [parameter] → max: [expected behavior] vs [stated behavior]: [CONSISTENT / INCONSISTENT]
```

### Step 5 — Sign and Direction Consistency

Check that directional claims are consistent:

```
DIRECTION CHECK:
  "X increases with Y" (Section 3) vs "X decreases with Y" (Section 5): [CONFLICT / CONSISTENT]
  "Higher Z leads to better outcomes" (Abstract) vs "Z has no significant effect" (Results): [CONFLICT]
```

### Step 6 — Consistency Verdict

```
═══════════════════════════════════════════════════════
CONSISTENCY CHECK: [paper topic]
═══════════════════════════════════════════════════════

Quantities registered: [N]
Quantities appearing 2+ times: [N]

Mismatches found: [N]
  P1 (reject condition): [N]
  P2 (confusing): [N]
  P3 (minor): [N]

Equation conflicts: [N]
Boundary violations: [N]
Direction conflicts: [N]

VERDICT: [PASS / FAIL]
═══════════════════════════════════════════════════════
```

If any P1 mismatches exist, VERDICT is FAIL. Stop and present them before proceeding.

## Output

Append findings to `FINDINGS.md` under heading `## From: consistency`

Each mismatch gets an F-NN ID:
```
F-NN: [P1/P2/P3] Mismatch — [quantity]: [value1] vs [value2]
  Source: consistency protocol
  Locations: [Section X] vs [Section Y]
  Impact: [HIGH if P1, MEDIUM if P2, LOW if P3]
```
