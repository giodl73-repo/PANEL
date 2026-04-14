# Research Protocol: Derivation

Step-by-step mathematical derivation verification. Traces algebraic manipulations, catches sign errors, missing terms, unjustified approximations, and dimensional inconsistencies.

**Paper type**: STEM only. Skip for non-mathematical papers.

## Protocol

### Step 1 — Extract Derivations

From plan.md or paper sections, identify every mathematical derivation:

```
DERIVATION REGISTRY:
D-01: [Starting equation] → [Final result] (Section: [ref])
  Purpose: [What this derivation shows]
  Steps: [estimated number]

D-02: ...
```

### Step 2 — Step-by-Step Trace

For each derivation, trace every algebraic step:

```
D-01 TRACE:

Step 1: [equation]
  Type: DEFINITION — substituting [symbol] = [expression]
  Valid: YES

Step 2: [equation]
  Type: EXACT — algebraic identity / factoring / expansion
  Valid: YES

Step 3: [equation]
  Type: APPROX — [state the approximation and when it holds]
  Valid: CONDITIONAL — requires [condition, e.g., "x << 1"]
  Validity range: [When does this approximation break down?]

Step 4: [equation]
  Type: PHYSICAL — invoking [physical law / assumption]
  Valid: YES — [cite the principle]
```

Step types:
- **EXACT**: Algebraic identity, no information lost
- **APPROX**: Approximation with stated validity conditions
- **DEFINITION**: Symbol substitution or definition introduction
- **PHYSICAL**: Invoking a physical law or empirical relationship

### Step 3 — Error Detection

For each step, check:

```
ERROR CHECK:
  Sign errors: [Any sign flips that aren't justified?]
  Missing terms: [Any terms dropped without explanation?]
  Unstated approximations: [Any steps that silently assume something?]
  Dimensional consistency: [Do units match on both sides?]
```

### Step 4 — Derivation Fault Register

```
FAULTS:
DF-01: Step [N] in D-01 — [description of error]
  Type: [sign error / missing term / unstated approximation / dimensional mismatch]
  Severity: [P1 — result is wrong / P2 — result is approximate but unstated / P3 — notation issue]

DF-02: ...
```

### Step 5 — Summary

```
═══════════════════════════════════════════════════════
DERIVATION CHECK: [paper topic]
═══════════════════════════════════════════════════════

Derivations traced: [N]
Total steps: [N]
  EXACT: [N]
  APPROX: [N] (all conditions stated: [YES/NO])
  DEFINITION: [N]
  PHYSICAL: [N]

Faults found: [N]
  P1 (result wrong): [N]
  P2 (unstated approximation): [N]
  P3 (notation): [N]

VERDICT: [CLEAN / HAS ERRORS]
═══════════════════════════════════════════════════════
```

## Output

Append findings to `FINDINGS.md` under heading `## From: derivation`

Each fault gets an F-NN ID:
```
F-NN: Derivation fault in D-[NN] step [N] — [description]
  Source: derivation protocol
  Severity: [P1 / P2 / P3]
  Relevance: [Section containing the derivation]
  Impact: [HIGH if P1, MEDIUM if P2, LOW if P3]
```
