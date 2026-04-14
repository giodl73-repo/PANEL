---
name: research
description: "Research pipeline for academic papers. Sub-commands: pre-write (6-phase discovery pipeline), post-write (8-phase validation pipeline), plus 14 individual research skills (hypothesis, competitors, causal, websearch, coherence, synthesize, argument, derivation, contract, consistency, dimensional, referee, abstract, score). Run individually or chained via the orchestrators."
---

You are running `/panel:research` for: **{{args}}**

Parse the first argument as the sub-command and the rest as the topic:

```
SUB-COMMAND: [first word — e.g., "pre-write", "hypothesis", "score"]
TOPIC: [remaining words — the paper name/slug]
```

If no sub-command is given, show the help summary and stop.

---

## SUB-COMMAND DISPATCH

### Orchestrators

| Sub-command | Description |
|-------------|-------------|
| `pre-write <topic>` | Full 6-phase pre-writing pipeline |
| `post-write <topic>` | Full 8-phase post-writing validation |

### Discover Phase (pre-write components)

| Sub-command | Description |
|-------------|-------------|
| `hypothesis <topic>` | Falsifiable claim + confidence + test designs |
| `competitors <topic>` | Competitive landscape, inertia-first |
| `causal <topic>` | Cause-effect chain tracing |
| `websearch <topic>` | Evidence grounding via web search |
| `coherence <topic>` | Cross-finding contradiction detection |
| `synthesize <topic>` | PROCEED / PAUSE / PIVOT verdict |

### Simulate Phase (argument & math verification)

| Sub-command | Description |
|-------------|-------------|
| `argument <topic>` | 4-specialist logical trace |
| `derivation <topic>` | Math derivation verification (STEM) |

### Validate Phase (post-write components)

| Sub-command | Description |
|-------------|-------------|
| `consistency <topic>` | Catches numerical contradictions |
| `dimensional <topic>` | Unit analysis (STEM) |
| `referee <topic>` | 3 hostile journal-specific referees |
| `contract <topic>` | Methodology vs claims verification |

### Specify Phase (output generation)

| Sub-command | Description |
|-------------|-------------|
| `abstract <topic>` | 6-part structured abstract |
| `score <topic>` | CEMCK self-assessment rubric (25-point) |

---

## LOCATING THE PAPER

Resolve the topic to a paper directory. Search in order:

1. Exact match: `research/*/publications/{{topic}}/` or `research/{{topic}}/`
2. Glob match: `research/*/publications/panel-{{topic}}/`
3. Glob match: `research/**/{{topic}}/plan.md` (find by plan.md presence)
4. If using multi-project config (`.claude/panel.json`), search within the active project's `publicationsPath` or `researchPath`

If the paper is found, read `plan.md` and `_panel.yaml` (if they exist).

If the paper is NOT found, report the error and suggest: `panel:setup {{topic}}` to create it.

---

## ORCHESTRATOR: pre-write

**Purpose**: Run the full pre-writing discovery pipeline. Produces FINDINGS.md and a readiness verdict before any writing begins.

### Phase 1 — Read the Plan

Read `plan.md` from the paper directory. Extract:

```
Paper: {{topic}}
Type: [MATH-HEAVY / EMPIRICAL / HISTORICAL / THEORETICAL]
Journal: [venue from plan.md]
Primary number: [key quantitative claim]
Falsification: [what would disprove the claim]
Math-heavy skills: [YES/NO — derivation + dimensional needed?]
```

**Paper type classification:**
- MATH-HEAVY: plan.md contains ODE, dR/dt, formula, derivation, integral, dimensional, spectral, electromagnetic, proof, theorem
- EMPIRICAL: plan.md contains experiment, study, participants, dataset, benchmark, evaluation, measurement
- HISTORICAL: plan.md contains historical, archaeological, archival, primary source, textual analysis
- THEORETICAL: anything else (frameworks, models, conceptual analysis)

### Phase 2 — Discovery Sequence

Run each sub-skill in order. After each, append findings to FINDINGS.md.

Follow the protocol in the corresponding `*.md` file for each:

1. **hypothesis** — `hypothesis.md`
2. **competitors** — `competitors.md`
3. **causal** — `causal.md`
4. **websearch** — `websearch.md` (For HISTORICAL papers, websearch focuses on primary source verification and archival evidence)
5. If EMPIRICAL: enhanced websearch focused on datasets, benchmarks, and baseline comparisons
6. If MATH-HEAVY: **derivation** — `derivation.md`
7. **argument** — `argument.md`

After each skill, summarize the top 1-2 findings before proceeding.

### Phase 3 — Coherence + Synthesize

8. **coherence** — `coherence.md`

Print the verdict: `COHERENCE: [N] blocking, [M] advisory`

9. **synthesize** — `synthesize.md`

- If **PROCEED**: continue to Phase 4.
- If **PAUSE**: present blocking items. Wait for user to confirm resolution. Re-run coherence to verify blocks are cleared.
- If **PIVOT**: stop. Present the pivot recommendation.

### Phase 4 — Update Plan if Needed

If Phase 3 identified changes to plan.md (new data sources, scope changes, methodology adjustments), update plan.md.

Print the changes made.

### Phase 5 — Score

Run the **score** protocol (`score.md`) on the plan to get a baseline pre-write score.

### Phase 6 — Readiness Report

```
═══════════════════════════════════════════════════════
PRE-WRITE COMPLETE: {{topic}}
═══════════════════════════════════════════════════════

Skills run: [list]
Findings collected: [N] (in FINDINGS.md)
Blocking items resolved: [N]
Plan updates made: [N]
Pre-write score: [N]/25

VERDICT: READY TO WRITE
Next: Write the paper (panel:paper author or panel:publication author)

Top 3 things to get right in the paper:
1. [most important finding from pipeline]
2. [second most important]
3. [third most important]
═══════════════════════════════════════════════════════
```

---

## ORCHESTRATOR: post-write

**Purpose**: Run the full post-writing validation pipeline. Produces a pre-submission checklist and readiness verdict.

### Phase 1 — Read the Paper

Read `plan.md` and all section files from the paper directory. Extract:

```
Paper: {{topic}}
Journal: [venue]
Stage: [from _panel.yaml]
Math-heavy: [YES/NO]
```

### Phase 2 — Consistency Check (always)

Follow protocol in `consistency.md`.

```
CONSISTENCY: [PASS/FAIL] — [N] mismatches found
Critical: [list any P1 mismatches]
```

If P1 mismatches found, **STOP** and present them. Do not proceed until resolved.

### Phase 3 — Dimensional Check (MATH-HEAVY only)

Follow protocol in `dimensional.md`.

```
DIMENSIONAL: [PASS/FAIL] — [N] errors found
```

If P1 errors found, **STOP** and present them.

### Phase 4 — Contract Check (always)

Follow protocol in `contract.md`.

```
CONTRACT: [PASS/FAIL]
Mismatches: [list any items where claims exceed methodology]
```

### Phase 4b — Argument Check (always)

Follow protocol in `argument.md` — run against the written sections (not plan.md).

```
ARGUMENT: [N] claims on critical path
  SOUND: [N]
  WEAK: [N]
  BROKEN: [N] — must fix before submission
```

### Phase 5 — Abstract (always)

Follow protocol in `abstract.md`.

Print the merged abstract and word count.

### Phase 6 — Referee Simulation (always)

Follow protocol in `referee.md`.

```
REFEREE SIMULATION: [likely decision]
P1 blockers: [I-NN list]
Strongest referee: [who and why]
```

### Phase 7 — Pre-Submission Checklist

Run the **score** protocol (`score.md`) for a final assessment.

```
═══════════════════════════════════════════════════════
POST-WRITE COMPLETE: {{topic}}
═══════════════════════════════════════════════════════

Validation results:
  Consistency:  [PASS/FAIL — N mismatches]
  Dimensional:  [PASS/FAIL / SKIPPED (not math-heavy)]
  Contract:     [PASS/FAIL — N mismatches]
  Referee sim:  [likely decision]
  Score:        [N]/25

PRE-SUBMISSION CHECKLIST:
□ All P1 consistency mismatches resolved
□ All P1 dimensional errors resolved (if math paper)
□ Contract: all claims supported by methodology
□ Abstract within 250 words, 6-part structure
□ All BROKEN argument claims resolved
□ Referee P1 blockers addressed
□ Falsification condition stated with specific observable
□ Null hypothesis stated and distinguished from main claim
□ Primary number delivered (from plan.md quantification contract)
□ [NEED] tags: [N] remaining (0 required for submission)

VERDICT: [READY TO SUBMIT / FIXES REQUIRED]
Items requiring action: [N]
═══════════════════════════════════════════════════════
```

If FIXES REQUIRED, list each item with the section reference and the specific fix needed.

---

## RUNNING INDIVIDUAL SUB-SKILLS

When a specific sub-command is given (not pre-write or post-write), run ONLY that sub-skill:

1. Locate the paper directory (see "Locating the Paper" above)
2. Read plan.md and any existing FINDINGS.md
3. Follow the protocol in the corresponding `{sub-command}.md` file
4. Append findings to FINDINGS.md with continuing F-NN IDs
5. Print the sub-skill's summary/verdict

Individual sub-skills are useful for:
- Running a quick check on one dimension without the full pipeline
- Re-running a specific check after making revisions
- Exploring a specific aspect of the research before committing to the full pipeline

---

## FINDINGS.md FORMAT

All sub-skills append to a single cumulative FINDINGS.md in the paper directory:

```markdown
# Findings: [paper topic]

Generated by panel:research pipeline.
Last updated: [date]

## From: [sub-skill name]

F-01: [One-sentence finding]
  Source: [sub-skill] protocol
  Relevance: [Which section this affects]
  Impact: [HIGH / MEDIUM / LOW]

F-02: ...

## From: [next sub-skill]

F-03: ...
```

Finding IDs (F-NN) are continuous across all sub-skills. When appending new findings, continue from the last F-NN in the file.
