# panel:paper review

## `review [targets]`

Run the review lifecycle. Advances each paper through its current stage gate.

**Single**: `panel:paper review my-paper`
**All eligible**: `panel:paper review`
**Until stage**: `panel:paper review --until ready`
**One round only**: `panel:paper review --round` (default: advance one stage)

```javascript
const papers = await resolveTargets(args, researchDir, 'review');
const until = args['--until'] || null;

msg(`Reviewing ${papers.length} paper(s)`, 'header');

for (const paper of papers) {
    msg(`→ ${paper.slug} [${paper.state.stage}]`, 'stage');
    await reviewPaper(paper, researchDir, pluginRoot, projectConfig, { until });
}
```

**Stage handlers** (from `commands/review.md`):

| Current stage | Gate | Action |
|--------------|------|--------|
| `draft` | main.tex + venue | Select 5 reviewers, load profiles, assign |
| `panel` | 5+ reviews exist | Generate `REVIEW-{NAME}.md` per reviewer using `buildReviewerContext()` |
| `synthesis` | SYNTHESIS.md | Consolidate reviews → P1/P2/P3 |
| `revision` | P1 items addressed | Create REVISION-PLAN.md, offer to apply |
| `recheck` | avg >= 2.5, min >= 2 | Round N review cycle |
| `ready` | panel complete | Await `panel:module review` |

**Bulk behavior**: each paper advances independently. A paper that fails its gate
is reported but doesn't block other papers.
