# Synthesis Engine — Consolidate Reviews into SYNTHESIS.md

Shared utility for consolidating individual reviews into a unified synthesis document with priority classification.

## Input

- Individual review files: `reviews/REVIEW-{NAME}.md` or `reviews/ROUND{N}-REVIEW-{NAME}.md`
- Each review contains: overall assessment, score (1-4), major issues, minor issues, recommendations
- Optional: Reviewer profiles from `_panel.yaml.reviewers[].profile_ref` (loaded via shared/reviewer-profile-loader.md)
- Profile context enriches issue attribution with reviewer expertise and evaluation lens

## Output

- `reviews/SYNTHESIS.md` or `reviews/ROUND{N}-SYNTHESIS.md`
- Contains: consolidated findings with P1/P2/P3 classification
- Includes reviewer profile summaries when available (affiliation, expertise area)

## Priority Classification

| Priority | Label | Criteria | Action Required |
|----------|-------|----------|-----------------|
| **P1** | High Impact | Raised by 3+ reviewers OR any reviewer marks as "major issue" OR threatens validity | Address before next round |
| **P2** | Important | Raised by 2+ reviewers OR substantive improvement opportunity | Should address; strengthens paper |
| **P3** | Nice-to-have | Raised by 1 reviewer, minor suggestion | Address if time permits |

## Synthesis Algorithm

### consolidate_reviews(review_files)

```
Input:  array of review file paths
Output: synthesis document structure
```

1. **Parse reviews**: Extract structured fields from each review file
2. **Load profiles**: If profile_ref exists in _panel.yaml for each reviewer, load via shared/reviewer-profile-loader.md
3. **Extract issues**: Collect all major issues, minor issues, and recommendations
4. **Deduplicate**: Group similar issues across reviewers (fuzzy matching on theme)
5. **Count mentions**: Track which reviewers raised each issue
6. **Profile attribution**: When attributing issues, include reviewer expertise context (e.g., "systems expert notes...", "HCI researcher raises...")
7. **Classify priority**: Apply P1/P2/P3 rules based on mention count and severity
8. **Score summary**: Aggregate scores using shared/score-utils.md
9. **Generate consensus narrative**: Identify areas of agreement and disagreement, note reviewer specialization patterns
10. **Produce SYNTHESIS.md**: Using templates/synthesis-template.md with profile summaries

## Synthesis Document Structure

```markdown
# Review Synthesis — [Paper Title]

## Overview
- Reviewers: N
- Average score: X/4
- Consensus: Strong/Moderate/Weak (σ = X.XX)
- Verdict: [Accept/Revise/Major Revisions]

## Score Distribution
| Reviewer | Affiliation | Expertise | Score | Verdict |
|----------|-------------|-----------|-------|---------|
| Percy Liang | Stanford | ML Research, Evaluation | 3/4 | Revise |
| ...

## Priority 1: High Impact Issues
### P1.1: [Issue Title] (raised by: Percy Liang [ML Research], Reviewer B, C)
*Context*: Percy Liang's evaluation lens focuses on comprehensive benchmarking and reproducibility.

### P1.2: ...

## Priority 2: Important Improvements
### P2.1: [Issue Title] (raised by: Reviewer A, B)

## Priority 3: Minor Suggestions
### P3.1: [Issue Title] (raised by: Reviewer A)

## Areas of Strength
[What reviewers agreed was done well]

## Recommended Next Steps
[Prioritized action items]
```

## Re-synthesis (Round N)

For subsequent rounds, synthesis also includes:
- Delta from previous round (score changes, resolved issues)
- Remaining concerns (carried forward from previous synthesis)
- New issues identified in latest round
