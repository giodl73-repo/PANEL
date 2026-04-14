# Research Protocol: Hypothesis

Commits a falsifiable hypothesis before investigation begins. Forces clarity on what the paper claims, what would disprove it, and how to test it.

## Protocol

### Step 1 — State the Hypothesis

From the paper's plan.md, extract or construct:

```
CLAIM: [One-sentence falsifiable claim]
FALSIFICATION: [Specific observable that would disprove the claim]
CONFIDENCE: [0-100] — how confident are you before investigation?
HYPOTHESIS CLASS: [Behavioral / Technical / Empirical / Theoretical / Causal]
```

Rules:
- The claim must be **one sentence**
- The claim must be **falsifiable** — there must exist an observable outcome that would disprove it
- If the claim cannot be falsified, it is not a hypothesis — rewrite it
- Confidence is a prior, not a target — honest uncertainty is better than false precision

### Step 2 — State the Prior

What existing evidence or reasoning supports this confidence level?

```
PRIOR EVIDENCE:
1. [Evidence or reasoning that supports the claim]
2. [Evidence or reasoning that weakens the claim]
3. [Key unknown that could shift confidence significantly]
```

### Step 3 — Design Falsification Tests

Design at least 2 tests that could falsify the claim:

```
TEST 1: [Description]
  Observable: [What you would measure or observe]
  Falsifies if: [Specific threshold or outcome that disproves the claim]
  Feasibility: [Can this test actually be run? Data availability?]

TEST 2: [Description]
  Observable: [What you would measure or observe]
  Falsifies if: [Specific threshold or outcome that disproves the claim]
  Feasibility: [Can this test actually be run? Data availability?]
```

### Step 4 — Define the Null Fallback

What would you conclude if the hypothesis is falsified?

```
NULL FALLBACK: [What the paper would conclude if the main hypothesis fails]
ALTERNATIVE: [Is there a weaker version of the claim that might survive?]
```

### Step 5 — Investigation Sequence

Based on the hypothesis class, recommend which research sub-skills to run next:

| Class | Recommended Sequence |
|-------|---------------------|
| Empirical | competitors → causal → websearch → consistency |
| Theoretical | competitors → argument → (derivation if math) → coherence |
| Behavioral | competitors → causal → websearch → referee |
| Technical | competitors → causal → contract → consistency |
| Causal | causal → websearch → argument → coherence |

## Output

Append findings to `FINDINGS.md` under heading `## From: hypothesis`

Each finding gets an F-NN ID:
```
F-01: [One-sentence finding]
  Source: hypothesis protocol
  Relevance: [Which section of the paper this affects]
  Impact: [HIGH / MEDIUM / LOW]
```
