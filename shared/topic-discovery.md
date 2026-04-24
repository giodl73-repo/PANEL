# Topic Discovery — Scan Sources and Propose Paper Topics

Shared utility for discovering potential research paper topics from external sources (roadmap, waves, commits). Returns structured proposals for the import pipeline.

## Proposal Schema

Each discovery function returns an array of proposals:

```yaml
- title: "Structured Expertise Injection: A Pattern Language for LLM Systems"
  slug: "panel-structured-expertise-injection"    # Auto-generated from title
  venue: "CACM / IEEE Software"
  abstract_sketch: "2-3 sentence abstract outline"
  priority: "P3"                                   # Source priority level
  evidence:                                        # Source-specific evidence items
    - type: "roadmap_action"
      description: "Draft outline: Structured Expertise Injection..."
      status: "not_started"
    - type: "roadmap_action"
      description: "Extract common architecture from both modules"
      status: "not_started"
  source: "roadmap"                                # "roadmap" | "waves" | "commits"
  source_ref: "Priority 3"                         # Location in source document
  related_papers: []                               # Existing papers that overlap
```

## Slug Generation

Convert title to directory-safe slug:

1. Lowercase the title
2. Remove subtitle after colon (e.g., "Structured Expertise Injection: A Pattern Language..." → "structured expertise injection")
3. Replace spaces with hyphens
4. Remove non-alphanumeric characters (except hyphens)
5. Collapse multiple hyphens
6. Prepend `panel-` if not present
7. Truncate to 50 characters at a word boundary

Examples:
- "Structured Expertise Injection: A Pattern Language for LLM Systems" → `panel-structured-expertise-injection`
- "Closing the Loop: Learning from Human Decisions in AI-Assisted Workflows" → `panel-closing-the-loop`
- "Cross-Domain Replication Study" → `panel-cross-domain-replication-study`

## Functions

### discover_from_roadmap(roadmap_path)

```
Input:  path to ROADMAP.md (default: C:\src\research\ROADMAP.md)
Output: array of proposals
```

**Parse logic**:

1. Read ROADMAP.md as markdown
2. Identify Priority sections (`## Priority N: ...`) that contain:
   - **Status**: "Not started" (skip "complete" or "in progress" priorities)
   - **Target venue**: Extract from the section metadata
   - A paper title in the Actions list (look for "Draft outline:", "Draft joint paper:", or quoted paper titles)
3. For each qualifying priority, extract:
   - `title` — From the paper title in the actions or priority heading
   - `venue` — From "Target venue:" metadata
   - `abstract_sketch` — From the priority description paragraph (first 2-3 sentences)
   - `priority` — "P{N}" from the priority number
   - `evidence` — Each unchecked `- [ ]` action item becomes an evidence entry of type `roadmap_action`
   - `source_ref` — "Priority {N}: {title}"
4. Also check the **Submission Timeline** for papers marked "(NEW)" that aren't covered by a priority section
5. Cross-check each proposal's slug against existing paper directories in `research/` — if a match exists, mark as `duplicate: true`

**Expected output from current ROADMAP.md**:

| # | Title | Venue | Priority | Source |
|---|-------|-------|----------|--------|
| 1 | Structured Expertise Injection: A Pattern Language for LLM Systems | CACM / IEEE Software | P3 | Priority 3 |
| 2 | Closing the Loop: Learning from Human Decisions in AI-Assisted Workflows | CHI / CSCW 2026 | P4 | Priority 4 |
| 3 | Cross-Domain Replication Study | OSDI / SOSP | P5 (capstone) | Phase 4 timeline |

### discover_from_waves(waves_dir, project)

```
Input:  waves directory (default: C:\src\waves), project name (optional)
Output: array of proposals
```

**Parse logic**:

1. Locate the wave index file:
   - If `project` specified: `{waves_dir}/{project}/.waves/wave-index.yaml`
   - If not: scan `{waves_dir}/*/.waves/wave-index.yaml` for all projects
2. For each project's wave index, load completed waves (status: "completed")
3. For each completed wave:
   - Extract wave title, discipline, pulse count, deliverables
   - Read pulse summaries for themes and patterns
4. Cluster related waves by:
   - Same discipline (e.g., multiple "architect" waves)
   - Overlapping themes in pulse titles
   - Sequential wave numbers suggesting a progression
5. For each cluster of 3+ related waves:
   - Generate a paper title from the dominant theme
   - Select venue based on discipline (architect → ICSE/FSE, researcher → NeurIPS, etc.)
   - Collect pulse deliverables as evidence items (type: `wave_pulse`)
   - Score by: novelty (0-1), evidence_depth (pulse count), venue_fit (0-1)
6. Filter proposals to score ≥ 0.5 on all dimensions
7. Cross-check against existing papers in `research/`

### discover_from_commits(repo_path, options)

```
Input:  repository path (default: current repo), options { since, count }
Output: array of proposals
Options:
  since:  date string (default: 6 months ago)
  count:  max commits to analyze (default: 500)
```

**Parse logic**:

1. Run `git log --format='%H|%s|%ad' --date=short` on the target repo
2. Parse commit messages and group by:
   - **Prefix pattern**: Extract `[panel]`, `[waves]`, `[merit]` etc. from commit messages
   - **Directory touched**: Use `git log --name-only` to identify primary directories
3. For each prefix group with 10+ commits:
   - Extract common themes from commit messages (word frequency after removing stop words)
   - Identify the time span and density of activity
   - Determine the primary domain from directory paths
4. For each qualifying cluster:
   - Generate a paper title from the dominant theme
   - Select venue based on domain
   - Collect representative commit messages as evidence items (type: `commit_ref`, with hash and message)
   - Score by: commit_density (commits/week), distinct_areas (directories touched), evidence_depth
5. Filter proposals with fewer than 10 commits
6. Cross-check against existing papers in `research/`

## Duplicate Detection

Cross-check proposals against existing papers:

1. Load existing paper directories from `research/panel-*/`
2. For each proposal, check:
   - **Exact slug match**: `research/{proposal.slug}/` exists → definite duplicate
   - **Title similarity**: Compare proposal title words against existing paper titles — if >60% word overlap → likely duplicate, mark as `related` with the existing paper name
3. Annotate proposals:
   - `duplicate: true` — Skip (exact match exists)
   - `related: ["panel-existing-paper"]` — Warn but allow (may be complementary)

## Dependencies

- shared/state-loader.md — discover_papers() for existing paper list
- shared/display-utils.md — table() for proposal display
