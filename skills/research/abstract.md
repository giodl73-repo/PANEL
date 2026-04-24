# Research Protocol: Abstract

Generates a structured 6-part academic abstract (150-250 words) with journal-specific variants. Uses a gap-first drafting approach and multi-pass refinement.

## Protocol

### Step 1 — Paper Type Declaration

```
PAPER TYPE: [Empirical / Theoretical / System / Survey / Mixed]
TARGET VENUE: [journal/conference name]
WORD TARGET: [150-250, or 300 for arXiv]
```

### Step 2 — Signal Acquisition

Read the paper's sections (or plan.md + FINDINGS.md if pre-submission). Extract:

```
SIGNALS:
  CLAIM: [The paper's central claim — one sentence]
  METHOD: [How the claim is supported — one sentence]
  RESULT: [The key quantitative or qualitative result — one sentence]
  GAP: [What existing work doesn't address — one sentence]
  BACKGROUND: [The broader context — one sentence]
  IMPLICATION: [Why this matters — one sentence]
```

### Step 3 — Gap-First Draft

Write the abstract in this order (gap-first, not background-first):

```
1. BACKGROUND (1-2 sentences): Establish the field and what is known
2. GAP (1 sentence): What is missing or problematic — this is the hook
3. CLAIM (1 sentence): What this paper does about it
4. METHOD (1-2 sentences): How — approach, data, technique
5. RESULT (1-2 sentences): What was found — be specific, use numbers
6. IMPLICATION (1 sentence): Why it matters — broader significance
```

Total: 150-250 words. Every sentence must earn its place.

### Step 4 — Boundary Quality Check

Check each transition between sections:

```
BOUNDARY CHECK:
  Background → Gap: [COUPLED / WEAK] — does the background naturally lead to the gap?
  Gap → Claim: [COUPLED / WEAK] — does the claim directly address the gap?
  Claim → Method: [COUPLED / WEAK] — does the method deliver on the claim?
  Method → Result: [COUPLED / WEAK] — does the result come from the method?
  Result → Implication: [COUPLED / WEAK] — does the implication follow from the result?
```

If any boundary is WEAK, revise the transition.

### Step 5 — Journal Variant (if venue specified)

Apply venue-specific adjustments:

| Venue Type | Adjustments |
|-----------|-------------|
| **CS Systems** (CHI, UIST) | Lead with user/design problem, mention evaluation participants |
| **ML** (NeurIPS, ICML) | Lead with problem formalization, state SOTA comparison numbers |
| **NLP** (ACL, EMNLP) | Mention languages/datasets, state benchmark improvements |
| **Biomedical** (Nature, PNAS) | Lead with clinical/biological significance, use field conventions |
| **Social Science** (Psych Science) | Lead with behavioral phenomenon, mention sample and effect size |
| **Interdisciplinary** | Minimize jargon, maximize accessibility |

### Step 6 — Five-Amendment Pass

Run five targeted amendments on the draft:

```
AMENDMENTS:
1. SELF-DIAGNOSIS: Does the abstract promise what the paper delivers? [YES/NO — fix]
2. GAP SHARPENING: Is the gap specific enough? Replace "little is known" with what specifically. [DONE/REVISED]
3. RESULT QUANTIFICATION: Does the result include a specific number? [YES/ADD ONE]
4. IMPLICATION TIGHTENING: Is the implication actionable, not vague? [YES/REVISED]
5. PROSE COHERENCE: Read aloud — any awkward transitions? [CLEAN/REVISED]
```

### Step 7 — Final Output

```
═══════════════════════════════════════════════════════
ABSTRACT: [paper topic]
═══════════════════════════════════════════════════════

[The abstract text — 150-250 words]

Word count: [N]
Target venue: [venue]
Sections: Background ([N] words) | Gap ([N]) | Claim ([N]) | 
          Method ([N]) | Result ([N]) | Implication ([N])
Boundary quality: [all COUPLED / N WEAK boundaries]
═══════════════════════════════════════════════════════
```

## Output

Write the abstract to the paper's directory as `abstract.md` (or update the abstract section in the main paper file).

Append a finding to `FINDINGS.md` under heading `## From: abstract`:
```
F-NN: Abstract generated — [N] words, [venue] variant
  Source: abstract protocol
  Relevance: Abstract section
  Impact: MEDIUM
```
