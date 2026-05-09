# Research Protocol: Synthesize

Cross-finding synthesis producing a PROCEED / PAUSE / PIVOT verdict. Requires 2+ prior research sub-skills to have run. Synthesizes all findings into a decision about whether the paper should move to writing.

## Prerequisites

At least 2 discovery sub-skills must have produced findings in FINDINGS.md. Coherence check should have run (but is not strictly required).

## Protocol

### Step 1 — Signal Inventory

Read FINDINGS.md. Catalog findings by source and impact:

```
SIGNAL INVENTORY:
  Sources: [list of sub-skills that produced findings]
  Total findings: [N]
  HIGH impact: [N]
  MEDIUM impact: [N]
  LOW impact: [N]
  BLOCKING (from coherence): [N]
```

### Step 2 — Agreement Map

Identify where multiple sources agree:

```
AGREEMENTS:
A-01: [Topic where 2+ sources converge]
  Sources: F-XX (hypothesis), F-YY (websearch)
  Strength: [STRONG / MODERATE] — based on number of sources and evidence quality

A-02: ...
```

### Step 3 — Conflict Map

Identify where sources disagree (draw from coherence if available, or detect independently):

```
CONFLICTS:
X-01: [Topic where sources disagree]
  Sources: F-XX vs F-YY
  Resolved: [YES / NO / PARTIALLY]
  Impact on paper: [Would this conflict undermine the core argument?]

X-02: ...
```

### Step 4 — Cross-Signal Insights

Findings that only emerge from combining multiple sources:

```
INSIGHTS:
I-01: [Insight from combining findings across sources]
  Derived from: F-XX + F-YY + F-ZZ
  Implication: [What this means for the paper]

I-02: ...
```

### Step 5 — Decision Verdict

```
═══════════════════════════════════════════════════════
SYNTHESIS: [paper topic]
═══════════════════════════════════════════════════════

Signals: [N] sources, [N] findings
Agreements: [N] (strongest: [topic])
Conflicts: [N] ([N] resolved, [N] unresolved)
Cross-signal insights: [N]

VERDICT: [PROCEED / PAUSE / PIVOT]
CONFIDENCE: [0-100]

RATIONALE:
[2-3 sentences explaining the verdict]
```

**PROCEED** (confidence 60+): Core argument is sound. Findings support the hypothesis. No unresolved blocking conflicts. Ready to write.

**PAUSE** (confidence 30-59): Promising but gaps remain. Specific items must be resolved before writing:
```
PAUSE ITEMS:
1. [What must be resolved — specific and actionable]
2. [What must be resolved]
```

**PIVOT** (confidence <30): Fundamental problem detected. The hypothesis may be wrong, the evidence contradicts the claim, or the competitive landscape makes the contribution marginal.
```
PIVOT RECOMMENDATION:
  Problem: [What's fundamentally wrong]
  Alternative: [Suggested new direction, if any]
```

### Step 6 — Plan Update Recommendations

If PROCEED, recommend any updates to plan.md based on findings:

```
PLAN UPDATES:
1. [Add anchor case X based on websearch finding F-NN]
2. [Strengthen methodology Y based on competitor analysis F-NN]
3. [Add [NEED] tag for data Z identified in causal analysis]
```

## Output

Append findings to `FINDINGS.md` under heading `## From: synthesize`

The verdict itself gets an F-NN ID:
```
F-NN: VERDICT [PROCEED/PAUSE/PIVOT] — confidence [N]/100
  Source: synthesize protocol
  Relevance: Entire paper
  Impact: HIGH
```
