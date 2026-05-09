# Research Protocol: Web Search

Grounds the paper's claims in publicly available evidence. Searches for supporting data, contradicting evidence, and relevant prior work not yet cited.

## Protocol

### Step 1 — Identify Claims Requiring Grounding

From plan.md and FINDINGS.md, extract claims that need external evidence:

```
CLAIMS TO GROUND:
G-01: [Claim from the paper]
  Current evidence: [What the paper cites, or "None"]
  Search needed: [What kind of evidence would strengthen or weaken this?]

G-02: ...
```

Priority order:
1. Claims with no evidence cited
2. Claims central to the paper's argument (on the critical path)
3. Quantitative claims (specific numbers, percentages, rates)
4. Claims about prior work or state of the field

### Step 2 — Search Execution

For each claim, run targeted searches. Focus on:

- **Peer-reviewed sources**: journal papers, conference proceedings
- **Institutional sources**: university pages, government data, established organizations
- **Pre-prints**: arXiv, SSRN, bioRxiv (note pre-print status)
- **Datasets**: public datasets, benchmarks, surveys

Avoid: blog posts, social media, Wikipedia (except as starting points for finding primary sources).

For each search result:

```
G-01 RESULTS:
  Source 1: [Title, authors, year, venue]
    URL: [link]
    Key finding: [One sentence — what this source says relevant to the claim]
    Supports/Contradicts/Extends: [relationship to the paper's claim]

  Source 2: ...
```

### Step 3 — Evidence Assessment

For each grounded claim:

```
G-01 ASSESSMENT:
  Claim: [restated]
  Evidence found: [STRONG / MODERATE / WEAK / CONTRADICTORY / NONE]
  Best source: [citation]
  Key number: [specific quantitative finding, if available]
  [NEED] tags: [What data is still missing?]
```

### Step 4 — Gap Report

```
Claims fully grounded: [N] of [total]
Claims partially grounded: [N]
Claims contradicted by evidence: [N] — FLAG THESE
Claims with no evidence found: [N]

New citations to add: [N]
[NEED] tags generated: [N]
```

## Output

Append findings to `FINDINGS.md` under heading `## From: websearch`

Each finding gets an F-NN ID:
```
F-NN: [One-sentence finding — what evidence was found or missing]
  Source: websearch protocol
  URL: [source link if applicable]
  Relevance: [Which section needs this citation]
  Impact: [HIGH / MEDIUM / LOW]
```
