# Research Protocol: Contract

Verifies that the paper delivers what its methodology promises. Compares the plan's quantification contract against the actual paper content. Catches overclaiming and underdeveloping.

## Protocol

### Step 1 — Extract the Contract

From plan.md, extract the paper's commitments:

```
CONTRACT:
  Primary number: [The key quantitative claim the paper must deliver]
  Methodology: [How the paper generates evidence]
  Claims: [List of specific claims the methodology is designed to support]
  Scope: [What the paper explicitly covers]
  Out of scope: [What the paper explicitly excludes]
```

### Step 2 — Check Deliverables

For each commitment, verify against the written sections:

```
DELIVERABLE CHECK:

D-01: Primary number — [stated value/result]
  Promised: [from plan.md]
  Delivered: [from paper sections — quote the specific result]
  Status: [DELIVERED / PARTIAL / MISSING / OVERCLAIMED]

D-02: [Claim 1]
  Promised: [from plan.md]
  Delivered: [from paper sections]
  Status: [DELIVERED / PARTIAL / MISSING / OVERCLAIMED]
```

Status definitions:
- **DELIVERED**: The paper provides exactly what was promised, supported by methodology
- **PARTIAL**: Some evidence provided but gaps remain (generates [NEED] tags)
- **MISSING**: The claim appears but no supporting evidence exists
- **OVERCLAIMED**: The paper claims more than the methodology can support

### Step 3 — Overclaim Detection

For each OVERCLAIMED item:

```
OVERCLAIM OC-01:
  Claim: [What the paper says]
  Evidence: [What the methodology actually provides]
  Gap: [The specific overreach]
  Fix: [Weaken the claim / Add evidence / Move to future work]
```

### Step 4 — Scope Creep Check

Does the paper claim anything outside its stated scope?

```
SCOPE CHECK:
  In-scope claims: [N] (all within methodology's reach: [YES/NO])
  Out-of-scope claims: [N]
  Scope creep items:
    SC-01: [Claim that exceeds the stated scope]
    SC-02: ...
```

### Step 5 — Contract Verdict

```
═══════════════════════════════════════════════════════
CONTRACT CHECK: [paper topic]
═══════════════════════════════════════════════════════

Deliverables: [N]
  DELIVERED: [N]
  PARTIAL: [N]
  MISSING: [N]
  OVERCLAIMED: [N]

Scope creep items: [N]

VERDICT: [PASS / FAIL]
  [If FAIL: list the specific items that need fixing]
═══════════════════════════════════════════════════════
```

## Output

Append findings to `FINDINGS.md` under heading `## From: contract`

Each issue gets an F-NN ID:
```
F-NN: [OVERCLAIMED/MISSING/PARTIAL] — [one-sentence description]
  Source: contract protocol
  Relevance: [Section where this appears]
  Impact: [HIGH if overclaimed, MEDIUM if missing, LOW if partial]
```
