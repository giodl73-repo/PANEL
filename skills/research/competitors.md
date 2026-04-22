# Research Protocol: Competitors

Competitive landscape analysis with inertia-first framing. Identifies what the paper is competing against — including the status quo — and maps the whitespace.

## Protocol

### Step 1 — The Primary Competitor: Inertia

Before naming specific competitors, assess the **status quo**:

```
STATUS QUO: [What do people currently do instead of what this paper proposes?]
SWITCHING COST: [HIGH / MEDIUM / LOW] — what does adopting this work require?
WORKAROUND QUALITY: [How well does the current approach actually work?]
INERTIA VERDICT: [Is inertia the real competitor, or is there genuine demand for change?]
```

If the workaround quality is HIGH and switching cost is HIGH, the paper faces a steep adoption barrier regardless of technical merit. Flag this as a finding.

### Step 2 — Named Competitors

Identify 3-5 competing approaches (papers, methods, systems, frameworks):

```
COMPETITOR 1: [Name / citation]
  Approach: [How it addresses the same problem]
  Feature overlap: [HIGH / MEDIUM / LOW]
  Key strength: [What it does better than this paper's approach]
  Key weakness: [Where it falls short]
  Threat level: [HIGH / MEDIUM / LOW]

COMPETITOR 2: ...
```

### Step 3 — The Whitespace

What does this paper offer that NO competitor provides?

```
WHITESPACE: [The unique contribution — must be specific and verifiable]
DEFENSIBILITY: [Is this whitespace durable, or will competitors close the gap?]
NOVELTY TYPE: [New method / New data / New framing / New application / New result]
```

### Step 4 — Table Stakes

What must the paper include just to be taken seriously in this field?

```
TABLE STAKES:
1. [Baseline comparison that reviewers will expect]
2. [Dataset or benchmark that is standard in this area]
3. [Methodology that is considered minimum for this venue]
```

Missing table stakes items become [NEED] tags in the plan.

### Step 5 — Competitive Matrix

Summarize in a table:

```
| Approach | Problem Coverage | Method Rigor | Data Quality | Novelty |
|----------|-----------------|-------------|-------------|---------|
| This paper | ... | ... | ... | ... |
| Competitor 1 | ... | ... | ... | ... |
| Competitor 2 | ... | ... | ... | ... |
| Status quo | ... | ... | ... | ... |
```

## Output

Append findings to `FINDINGS.md` under heading `## From: competitors`

Each finding gets an F-NN ID (continuing from previous findings):
```
F-NN: [One-sentence finding]
  Source: competitors protocol
  Relevance: [Which section — usually Related Work or Introduction]
  Impact: [HIGH / MEDIUM / LOW]
```
