# panel:paper author

## `author [targets]`

Write papers from `plan.md`. Reads MODULE.md for track arc paragraphs if present.

**Single**: `panel:paper author my-paper`
**All eligible**: `panel:paper author` — all papers with plan.md but no main.tex
**Selection**: `panel:paper author 1 3` — papers 1 and 3 from status list
**By track**: `panel:paper author --track methodology`

**Bulk mode**: runs sequentially (papers in a module often share context).
Override with `--parallel` for independent papers.

```javascript
const papers = await resolveTargets(args, researchDir, 'author');
msg(`Authoring ${papers.length} paper(s)`, 'header');

for (const paper of papers) {
    msg(`→ ${paper.slug}`, 'stage');
    await authorPaper(paper, researchDir, pluginRoot, projectConfig);
}
```

For each paper, `authorPaper()` follows the shared authoring protocol:
- Load plan.md, _panel.yaml
- Load track arc paragraphs from MODULE.md
- Warn if paper has no track assignment
- Run writing tasks sequentially (sections, experiments, figures)
- Inject track arc into Introduction
- Update _panel.yaml

See `shared/authoring-standards.md` for the full writing protocol, quality standards, [NEED] tag convention, and venue-specific adjustments.
