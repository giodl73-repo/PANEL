# Research Protocol: Referee

Simulates hostile peer review from 3 journal-specific referee archetypes. Produces continuous issue IDs across all three reports and a likely editorial decision.

## Protocol

### Step 1 — Select Referee Archetypes

Based on the paper's target venue, select 3 referee archetypes:

**Computer Science (CHI, UIST, CSCW):**
- Referee 1: The Methodologist — demands rigorous evaluation, statistical tests, effect sizes
- Referee 2: The Novelty Critic — questions whether the contribution is incremental
- Referee 3: The Systems Thinker — asks about scalability, generalizability, real-world deployment

**Machine Learning (NeurIPS, ICML, ICLR):**
- Referee 1: The Theorist — demands formal guarantees, convergence proofs, complexity analysis
- Referee 2: The Empiricist — wants more baselines, ablations, statistical significance
- Referee 3: The Reproducibility Advocate — asks about code, data, hyperparameter sensitivity

**NLP (ACL, EMNLP, NAACL):**
- Referee 1: The Linguist — questions linguistic validity and language-specific assumptions
- Referee 2: The Benchmark Skeptic — demands diverse evaluation beyond standard benchmarks
- Referee 3: The Ethics Reviewer — probes bias, fairness, potential for misuse

**Biomedical / Life Sciences (Nature, PNAS, Cell):**
- Referee 1: The Statistician — questions sample size, multiple comparisons, effect sizes
- Referee 2: The Domain Expert — checks biological plausibility and mechanism
- Referee 3: The Reproducibility Reviewer — demands protocols, reagent details, raw data

**Social Science (Psychological Science, JPSP, JEP):**
- Referee 1: The Methodologist — demands pre-registration, power analysis, replication plan
- Referee 2: The Theorist — questions theoretical framing and construct validity
- Referee 3: The Generalizability Critic — challenges WEIRD sampling and ecological validity

**General / Interdisciplinary:**
- Referee 1: The Skeptic — challenges core claims and methodology
- Referee 2: The Related Work Expert — identifies missing citations and positioning gaps
- Referee 3: The Clarity Advocate — flags unclear writing, missing definitions, logical gaps

If the target venue does not match any category above, use the General/Interdisciplinary archetypes, adjusted for the venue's known review criteria.

### Step 2 — Generate Referee Reports

Each referee produces a structured report with continuous issue IDs:

```
═══ REFEREE 1: [Archetype Name] ═══
Expertise: [area]
Overall assessment: [ACCEPT / MINOR REVISION / MAJOR REVISION / REJECT]

SUMMARY:
[2-3 sentences — overall impression]

STRENGTHS:
S-01: [Specific strength]
S-02: [Specific strength]

ISSUES:
I-01: [Specific issue] — Severity: [P1 / P2]
  Section: [where this appears]
  Required action: [what must change]

I-02: [Specific issue] — Severity: [P1 / P2]
  Section: [where this appears]
  Required action: [what must change]

I-03: [Minor issue] — Severity: P3
  Section: [where]

QUESTIONS FOR AUTHORS:
Q-01: [Question the referee would ask]
```

Issue IDs are **continuous across all three reports** (Referee 1 uses I-01 through I-NN, Referee 2 continues from I-NN+1, etc.).

### Step 3 — Severity Rules

- **P1**: Would cause rejection on its own. Must be fixed.
- **P2**: Weakens the paper significantly. Should be fixed.
- **P3**: Minor issue. Nice to fix but not required.

### Step 4 — Editorial Decision

```
═══════════════════════════════════════════════════════
REFEREE SIMULATION: [paper topic]
Target venue: [venue]
═══════════════════════════════════════════════════════

Referee 1 ([archetype]): [ACCEPT / MINOR / MAJOR / REJECT]
Referee 2 ([archetype]): [ACCEPT / MINOR / MAJOR / REJECT]
Referee 3 ([archetype]): [ACCEPT / MINOR / MAJOR / REJECT]

Total issues: [N]
  P1 (blocking): [N]
  P2 (significant): [N]
  P3 (minor): [N]

LIKELY DECISION: [ACCEPT / MINOR REVISION / MAJOR REVISION / REJECT]

P1 blockers:
  I-NN: [one-line summary]
  I-NN: [one-line summary]

Strongest referee: [who and why — which archetype found the most issues]
═══════════════════════════════════════════════════════
```

## Output

Append findings to `FINDINGS.md` under heading `## From: referee`

Each P1/P2 issue gets an F-NN ID:
```
F-NN: Referee I-[NN] ([P1/P2]) — [one-sentence description]
  Source: referee protocol ([archetype name])
  Relevance: [Section]
  Impact: [HIGH if P1, MEDIUM if P2]
```
