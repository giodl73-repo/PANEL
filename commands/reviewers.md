<command-name>panel:reviewers</command-name>

# panel:reviewers — Reviewer Database Browser

Browse, search, and filter the expert reviewer database.

## Arguments

- `--category <cat>` — Filter by category (systems, compilers, agents, prompting, human-ai, ml-systems, ml-research, se-devops, nlp-ir, security)
- `--venue <venue>` — Filter by recommended venue (MLSys, NeurIPS, CHI, PLDI, OSDI, etc.)
- `--tag <tag>` — Filter by expertise tag (distributed-systems, agents, prompting, etc.)
- `--search <query>` — Free-text search across names, affiliations, expertise
- `--available` — Show only reviewers not assigned to current paper

## Behavior

1. **Load database**: Read REVIEWER-DATABASE.md from the project root or plugin config.
2. **Apply filters**: Category, venue, tag, search query.
3. **Cross-reference**: Check `_panel.yaml` files to show assignment status.
4. **Display**: Render filtered reviewer list using shared/display-utils.md.

## Output Format

```
Reviewer Database — Category: Human-AI Interaction
═══════════════════════════════════════════════════════════════════════

 Name                Affiliation           Expertise                Key Question
 ─────────────────── ───────────────────── ──────────────────────── ─────────────────────────
 Ben Shneiderman     UMD                   HCAI, human agency       Does this preserve meaningful human control?
 Michael Bernstein   Stanford              Crowdsourcing            How does this compare to crowd workflows?
 Ece Kamar           Microsoft Research    Complementarity          Should blocking be confidence-based?
 Saleema Amershi     Microsoft Research    Interactive ML, HITL     Does the system learn from feedback?
 Krzysztof Gajos     Harvard               Adaptive interfaces      Does this adapt to user behavior?
 Jeffrey Heer        UW                    Visualization            How are decisions presented?

6 reviewers | Venues: CHI, UIST, CSCW
Tags: human-ai, crowdsourcing, interactive-ml, visualization
```

## Conference-Specific View

```bash
panel:reviewers --venue CHI
```

Shows recommended reviewers for CHI submissions with rationale.

## Dependencies

- shared/reviewer-selector.md — Database loading and filtering
- shared/display-utils.md — Terminal formatting
