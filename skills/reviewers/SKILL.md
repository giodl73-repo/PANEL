---
name: panel:reviewers
description: Browse, search, filter reviewer database by category/venue/expertise
user-invocable: true
---

# panel:reviewers — Reviewer Database Browser

Browse, search, and filter the expert reviewer database.

## Arguments

### Filtering (default list mode)
- `--category <cat>` — Filter by category (systems, compilers, agents, prompting, human-ai, ml-systems, ml-research, se-devops, nlp-ir, security)
- `--venue <venue>` — Filter by recommended venue (MLSys, NeurIPS, CHI, PLDI, OSDI, etc.)
- `--tag <tag>` — Filter by expertise tag (distributed-systems, agents, prompting, etc.)
- `--search <query>` — Free-text search across names, affiliations, expertise
- `--available` — Show only reviewers not assigned to current paper
- `--detailed` — Show detailed list with profile summaries (research background, key publications)

### Profile operations
- `show <name>` — Display full reviewer profile (all sections from context/panel/reviewers/profiles/<slug>.md)
- `edit <name>` — Open reviewer profile for customization
- `list <name>` — Alias for `show <name>`

## Behavior

### List Mode (default)

1. **Load database**: Read REVIEWER-DATABASE.md from the project root or plugin config.
2. **Apply filters**: Category, venue, tag, search query.
3. **Cross-reference**: Check `_panel.yaml` files to show assignment status.
4. **Display**: Render filtered reviewer list using shared/display-utils.md.

If `--detailed` flag provided:
- Load profiles via shared/reviewer-profile-loader.md for each filtered reviewer
- Show archetype badge and orientation.frame (for OLE profiles)
- Show 2-3 sentence research background summary (for legacy profiles)
- Note profile format (OLE | legacy | database only)

### Show Mode (`show <name>`)

1. **Resolve name**: Convert to R-N ID or slug (e.g., "Percy Liang" → "R-1", or legacy "percy-liang")
2. **Load profile**: Use loadReviewerProfile() from shared/reviewer-profile-loader.md
3. **Display profile** (format-aware):

   **OLE format** (`profile.format === 'ole'`):
   - Archetype badge (structural / craft / experiential)
   - Orientation: frame (worldview) and serves (audience)
   - Lens: verify questions (numbered checklist) and simplify principles
   - Expertise: depth areas and relevance statement
   - Collaborates with: linked reviewer R-N IDs
   - Key Question (from markdown body)
   - Venue Affinity + Paper Type Fit (from markdown body)

   **Legacy format** (`profile.format === 'legacy'`):
   - Research background (2-3 paragraphs)
   - Key publications (3-5 papers)
   - Evaluation lens (characteristic questions, focus areas)
   - Review criteria (checklist items)
   - Characteristic concerns (common issues they raise)
   - Voice & tone (writing style descriptors)
   - AI Simulation Disclosure footer

4. **Show metadata**: Profile format (OLE/legacy), version, word count
5. **Cross-reference**: Papers where this reviewer is assigned

### Edit Mode (`edit <name>`)

1. **Resolve profile path**: Find profile file in context/panel/reviewers/profiles/
2. **Open in editor**: Use $EDITOR or fall back to system default
3. **Validate on save**: Check required sections present, size within 1.8-2.2KB target
4. **Suggest regeneration**: If major changes, offer to update profile cache via clearProfileCache()

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
- shared/reviewer-profile-loader.md — Load reviewer profiles, cache management
- shared/display-utils.md — Terminal formatting
- context/panel/reviewers/_index.yaml — Master reviewer registry
