# Research Protocol: Argument

Traces logical argument chains step-by-step using a 4-specialist model. Identifies logical form, tests assumptions against evidence, and catches common argument faults.

## Protocol

### Step 1 — Extract Claim Map

From plan.md (pre-write) or paper sections (post-write), extract every claim with dependencies:

```
CLAIM MAP:
C-01: [Top-level claim — the paper's thesis]
  Depends on: C-02, C-03
  Critical path: YES

C-02: [Supporting claim 1]
  Depends on: C-04
  Critical path: YES

C-03: [Supporting claim 2]
  Depends on: C-05, C-06
  Critical path: NO

C-04: [Evidence or assumption underlying C-02]
  Depends on: [none — base assumption]
  Critical path: YES
```

Mark **critical path** claims — those where failure would break the top-level claim.

### Step 2 — Four-Specialist Trace

For each claim on the critical path, run through four specialists:

**LOGICIAN** — Names the logical form:
```
C-01: [Claim]
  Logical form: [modus ponens / abduction / causal inference / analogy / 
                  induction / deduction / reductio / statistical inference]
  Structure: If [P], then [Q]. [P]. Therefore [Q].
```

**ADVOCATE** — States the minimum assumptions required for the argument to be valid:
```
C-01: Minimum assumptions:
  A-01: [Assumption 1 — must be true for the argument to hold]
  A-02: [Assumption 2]
  Unstated assumptions: [Any hidden premises?]
```

**EMPIRICAL REVIEWER** — Tests whether evidence actually supports the assumptions:
```
C-01: Evidence check:
  A-01: [SUPPORTED / UNSUPPORTED / PARTIALLY SUPPORTED]
    Evidence: [What supports or undermines this assumption?]
  A-02: [SUPPORTED / UNSUPPORTED / PARTIALLY SUPPORTED]
    Evidence: [What supports or undermines this assumption?]
```

**CHAIR** — Synthesizes a verdict:
```
C-01: VERDICT: [SOUND / WEAK / BROKEN]
  Reason: [One sentence explaining the verdict]
  Fault class: [None / DEF-DRIFT / UNSUPPORTED-GEN / CIRCULAR-DEP / INVALID-FORM]
```

### Step 3 — Fault Classes

| Fault | Description | Example |
|-------|-------------|---------|
| **DEF-DRIFT** | A term is used with different meanings in different claims | "Complexity" means computational complexity in C-02 but organizational complexity in C-05 |
| **UNSUPPORTED-GEN** | A generalization is made without sufficient evidence | "All X exhibit Y" based on 3 observations |
| **CIRCULAR-DEP** | Claim A depends on B which depends on A | C-02 assumes C-03 which assumes C-02 |
| **INVALID-FORM** | The logical structure itself is flawed | Affirming the consequent, undistributed middle |

### Step 4 — Critical Path Audit

```
CRITICAL PATH SUMMARY:
  Claims on critical path: [N]
  SOUND: [N]
  WEAK: [N] — paper can proceed but should strengthen these
  BROKEN: [N] — must fix before writing/submission

  Faults detected:
    DEF-DRIFT: [N]
    UNSUPPORTED-GEN: [N]
    CIRCULAR-DEP: [N]
    INVALID-FORM: [N]
```

### Step 5 — Severity Classification

```
P1 (breaks central conclusion): [list]
P2 (weakens key section): [list]
P3 (precision issue): [list]
```

## Output

Append findings to `FINDINGS.md` under heading `## From: argument`

Each fault gets an F-NN ID:
```
F-NN: [Fault class] in [claim ID] — [one-sentence description]
  Source: argument protocol
  Severity: [P1 / P2 / P3]
  Relevance: [Which section contains this argument]
  Impact: [HIGH / MEDIUM / LOW]
```
