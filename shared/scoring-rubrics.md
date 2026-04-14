# Scoring Rubrics — Unified Scoring Reference

All scoring scales used across the panel plugin. Single source of truth referenced by review, module, board, and research skills.

## 1. Reviewer Score (4-Point Scale)

Used at the **paper level** for individual reviewer assessments.

| Score | Label | Meaning |
|-------|-------|---------|
| 4 | Strong Accept | Excellent contribution, clearly above venue threshold |
| 3 | Accept | Good contribution, minor issues only |
| 2 | Weak Accept | Acceptable with revisions, some concerns |
| 1 | Reject | Major flaws, not suitable for venue |

### Verdict Mapping

| Verdict Text | Numeric Score |
|-------------|---------------|
| Strong Accept | 4.0 |
| Accept | 3.0 |
| Accept with Minor Revisions | 2.5 |
| Weak Accept | 2.0 |
| Major Revisions Required | 1.5 |
| Reject | 1.0 |

Canonical source: `config/scoring.yaml`. This table is a human-readable mirror.

### Thresholds (Paper Level)

| Metric | Threshold | Meaning |
|--------|-----------|---------|
| Minimum average | >= 2.5/4 | Paper passes recheck |
| Minimum individual | >= 2/4 | No reviewer gives a reject |
| Minimum reviewers | 5 | Enough perspectives for synthesis |

### Consensus (Standard Deviation)

| Consensus Level | StdDev Range | Interpretation |
|----------------|-------------|----------------|
| Strong | < 0.5 | Reviewers agree closely |
| Moderate | 0.5 - 1.0 | General agreement with some divergence |
| Weak | 1.0 - 1.5 | Significant disagreement |
| None | >= 1.5 | Reviewers fundamentally disagree |

See `config/scoring.yaml` for the canonical YAML definitions.

---

## 2. Module Score (10-Point Scale)

Used at the **module level** for cross-portfolio panel assessments.

| Range | Tier | Label | Meaning |
|-------|------|-------|---------|
| 8.0 - 10.0 | A | Program Flagship | Exceptional quality, strong causal chains |
| 7.0 - 8.0 | A- | Strong | High quality, minor gaps |
| 6.5 - 7.0 | B+ | Solid | Good work, some weak links |
| 6.0 - 6.5 | B | Competent | Acceptable, needs strengthening |
| 5.0 - 6.0 | B- | Needs Work | Below bar, significant improvements needed |
| 0.0 - 5.0 | C | Not Ready | Fundamental issues, major rework |

### Three Properties (Module Quality)

Derived from the gravity:downward-signal 9.37/10 benchmark:

1. **Causal Chain**: Each paper in a track is unintelligible without the prior
2. **No Weak Links**: Every paper designed to score >= 8.0
3. **Actionable Numbers**: Every finding has a specific quantified result

### Module Impact Classification (PP1/PP2/PP3)

| Level | Criteria | Action |
|-------|----------|--------|
| **PP1** | Cross-paper pattern, threatens module integrity, or affects 3+ papers | Address before next round |
| **PP2** | 2+ papers affected | Should address |
| **PP3** | 1 paper, module-level refinement | Nice to have |

---

## 3. Board Score (10-Point Scale)

Same 10-point scale as module level, applied across all modules at the **board level**.

### Board Completion Criteria

1. All B1 items addressed across all modules
2. Program score >= 7.0/10 (Tier A- or above)
3. No module below 6.0/10
4. Board consensus: average Spearman's rho > 0.6

### Board Impact Classification (B1/B2/B3)

| Level | Criteria | Action |
|-------|----------|--------|
| **B1** | 3+ board members flag it, threatens program coherence, or affects 3+ modules | Address before next round |
| **B2** | 2+ modules affected | Should address |
| **B3** | 1 module, program-level refinement | Nice to have |

---

## 4. CEMCK Self-Assessment (25-Point Scale)

Used by `panel:research score` for **author-side quality assessment**. Independent of the reviewer-driven review process.

| Dim | Name | 5 (Excellent) | 3 (Solid) | 1 (Weak) |
|-----|------|---------------|-----------|----------|
| **C** | Claim | Falsifiable, one-sentence, specific | Clear but could be sharper | Vague or unfalsifiable |
| **E** | Evidence | Named sources, specific numbers, honest [NEED] tags | Sources present but some generic | Vague sourcing, no numbers |
| **M** | Method | Appropriate, reproducible, null fallback stated | Method clear but gaps | Method unclear or missing |
| **C** | Contribution | Connection to field natural, cross-refs accurate, novel | Connection present but forced | No clear contribution |
| **K** | Craft | Venue-appropriate register, tables, clean structure | Readable but rough edges | Poor structure, wrong register |

### CEMCK Thresholds

| Score | Status | Meaning |
|-------|--------|---------|
| 22-25 | Camera-ready | Publishable with minor polish |
| 18-21 | Solid | Needs targeted revision on weak dimensions |
| 14-17 | Adequate | Needs significant work on 2+ dimensions |
| <14 | Needs rewrite | Fundamental issues across multiple dimensions |

### CEMCK and [NEED] Tags

Papers with unfilled `[NEED]` tags score lower on Evidence (E) but are preferred over unsupported claims. Filling [NEED] tags is the single highest-leverage improvement for papers scoring 14-17.

### When to Use CEMCK vs 4-Point

| Scale | Who runs it | When | Purpose |
|-------|-------------|------|---------|
| **CEMCK (25pt)** | Author | Before/after writing | Self-assessment, readiness check |
| **4-point** | AI reviewer personas | During review rounds | External simulated peer review |
| **10-point** | Module/board panels | Cross-portfolio review | Program-level quality assessment |

CEMCK is complementary to the review process — it helps the author gauge readiness before entering the review lifecycle, and track improvement afterward.

---

## Score Relationships

```
CEMCK (25pt, author)  →  catches quality issues early
        ↓
4-point (reviewer)    →  simulated peer review
        ↓
10-point (module)     →  cross-portfolio assessment
        ↓
10-point (board)      →  program-level quality
```

Higher-tier scores aggregate lower-tier results:
- Module score reflects paper-level review scores and track quality
- Board score reflects module scores and cross-module coherence
- CEMCK is independent — author can run it at any time

## Dependencies

- `config/scoring.yaml` — Canonical YAML definitions for 4-point and 10-point scales
- `shared/score-utils.md` — Score aggregation, consensus metrics

## See Also

- `.claude/skills/research/score.md` — CEMCK self-assessment protocol
