<command-name>panel:venue</command-name>

# panel:venue — Venue Recommendation & Submission Strategy

Recommends target venues based on paper content, review scores, and submission timelines.

## Arguments

- `--paper <name>` — Analyze a specific paper (default: auto-detect from cwd)
- `--score <N>` — Override current score for what-if analysis
- `--timeline` — Show submission deadlines and preparation timeline

## Behavior

1. **Load paper state**: Read `_panel.yaml` for current scores and stage.
2. **Analyze paper type**: Determine paper category from title, abstract, and review feedback.
3. **Match to venues**: Cross-reference with venue requirements and reviewer expertise tags.
4. **Estimate readiness**: Based on current score, remaining P1 items, and effort needed.
5. **Recommend strategy**: Primary venue + backup venues with rationale.

## Output Format

```
Venue Analysis — panel-review-methodology
═══════════════════════════════════════════════════════════════════════

Paper type:  Methodology / Human-AI Interaction
Current score: 2.8/4 (round 2)
Tier: B+ (projected: A- after P2 revisions)

Recommended Venues:

  Primary:  CHI 2026
    Fit:      Strong — methodology + human factors aligns with CHI scope
    Score:    Current 2.8/4 meets CHI acceptance threshold (~2.5/4)
    Deadline: September 2026
    Effort:   ~2 weeks to address remaining P2 items

  Backup 1: CSCW 2026
    Fit:      Good — collaborative aspects of review process
    Deadline: May 2026
    Note:     Tighter deadline; may need to skip some P2 items

  Backup 2: IUI 2026
    Fit:      Moderate — AI interface for review process
    Deadline: October 2026
    Note:     Reframe around the interactive review experience

Submission Strategy:
  1. Complete P2 revisions (2 weeks)
  2. Add competitive comparison section (1 week)
  3. Prepare supplementary materials
  4. Target CHI 2026 primary submission
```

## Venue Database

Built from the reviewer database venue mappings and conference knowledge:

| Category | Venues |
|----------|--------|
| Systems | MLSys, OSDI, SOSP, NSDI |
| ML/AI | NeurIPS, ICML, ICLR, AAAI, IJCAI |
| NLP | ACL, EMNLP, NAACL, TACL |
| HCI | CHI, UIST, CSCW, IUI |
| SE | ICSE, FSE, ASE, ISSTA |
| PL | PLDI, OOPSLA, POPL |
| Data | VLDB, SIGMOD, KDD |
| IR | SIGIR, WSDM, JCDL |

## Dependencies

- shared/state-loader.md — Read _panel.yaml
- shared/score-utils.md — Score analysis
- shared/display-utils.md — Terminal formatting
