# Panel — AI-Simulated Expert Review Lifecycle

A Claude Code plugin that drives research papers through a complete AI-simulated expert review lifecycle via a three-tier review architecture: paper-level reviews, module-level panels, and monorepo-level board reviews.

## ⚠️ Critical Framing

**This is a quality improvement simulation, NOT peer review.**

### What This Means:
- **All feedback is AI-generated** based on domain expert personas (e.g., "Percy Liang," "Michael Bernstein")
- **Named researchers are NOT participants** — they did not write, review, or endorse any output
- **Purpose: strengthen your work** before real submission, not "respond to reviewers"
- **P1/P2/P3 = improvement suggestions**, not reviewer mandates
- **Use what helps, ignore what doesn't** align with your research goals

### Template Policy:
- **NEVER use conference templates** (acmart, neurips, etc.) unless user **explicitly submitting** to that conference
- **Default to generic `article` class** to emphasize this is quality work, not submission-ready formatting
- **Only use conference formatting** when user has real reviewer feedback or is actually submitting

### Language to Use:
- ✅ "simulated feedback," "AI-generated assessment," "quality improvement suggestions"
- ✅ "AI persona based on [Name]," "simulated reviewer perspective"
- ✅ "strengthen this aspect," "enhance the work," "improvement opportunities"
- ❌ "reviewer said," "address reviewer concerns," "respond to feedback"
- ❌ "must fix," "blocking issue," "required for acceptance"

## Three-Tier Review Architecture

```
                    ┌───────────────┐
                    │  panel:board  │  Monorepo level
                    │  REVIEW_BOARD │  Cross-module synthesis
                    └───────┬───────┘
                        ↕ findings bubble up
                        ↕ revisions flow down
                    ┌───────────────┐
                    │panel:convene  │  Module level
                    │ REVIEW_PANEL  │  Cross-portfolio panel (7 reviewers)
                    └───────┬───────┘
                        ↕ findings bubble up
                        ↕ revisions flow down
              ┌─────────────────────────┐
              │     panel:review        │  Individual paper level
              │  REVIEW-*.md, SYNTHESIS │  Per-paper review rounds
              └─────────────────────────┘
```

**Bidirectional flow:**
- **Up**: Paper reviews surface issues → panel sees patterns across papers → board sees patterns across modules
- **Down**: Board generates B1/B2/B3 per module → panel generates PP1/PP2/PP3 per paper → papers revise

**Impact classification at each tier:**

| Tier | Prefix | High Impact (P1) | Medium Impact (P2) | Low Impact (P3) |
|------|--------|----------|-----------|--------------|
| Paper | P1/P2/P3 | 3+ personas, any major issue, or critical gap | 2+ personas | 1 persona |
| Panel | PP1/PP2/PP3 | Cross-paper pattern, threatens module, or 3+ papers affected | 2+ papers affected | 1 paper |
| Board | B1/B2/B3 | 3+ board members, threatens program, or 3+ modules affected | 2+ modules affected | 1 module |

## Project Layout

```
panel/
├── .claude-plugin/
│   ├── plugin.json              # Plugin manifest (12 skills)
│   ├── marketplace.json         # Standalone marketplace (panel only)
│   └── craft.json               # Craft feature tracking
├── .claude/
│   ├── panel.json               # Plugin configuration (gitStrategy, suppressMessages)
│   └── skills/                  # Skill definitions (.claude/skills/{name}/SKILL.md)
│       ├── paper/SKILL.md       # Quick markdown research papers
│       ├── publication/SKILL.md # Formal LaTeX publication lifecycle
│       ├── module/SKILL.md      # Module-tier operations
│       ├── board/SKILL.md       # Monorepo-level board review
│       ├── setup/SKILL.md       # Project initialization
│       ├── upgrade/SKILL.md     # Migration from v1.x to v2.0
│       ├── reviewers/SKILL.md   # Reviewer database browser
│       ├── project/SKILL.md     # Multi-project switching
│       ├── report/SKILL.md      # Generate review reports
│       ├── help/SKILL.md        # Interactive help system
│       ├── uninstall/SKILL.md   # Clean plugin removal
│       └── research/            # Research pipeline (pre-write, post-write, 14 sub-skills)
│           ├── SKILL.md         # Dispatcher + orchestrators
│           ├── hypothesis.md    # Falsifiable claim + test designs
│           ├── competitors.md   # Competitive landscape, inertia-first
│           ├── causal.md        # Cause-effect chain tracing
│           ├── websearch.md     # Evidence grounding via web search
│           ├── coherence.md     # Cross-finding contradiction detection
│           ├── synthesize.md    # PROCEED / PAUSE / PIVOT verdict
│           ├── argument.md      # 4-specialist logical argument trace
│           ├── derivation.md    # Math derivation verification (STEM)
│           ├── contract.md      # Methodology vs claims verification
│           ├── consistency.md   # Quantitative consistency checking
│           ├── dimensional.md   # Unit analysis (STEM)
│           ├── referee.md       # Hostile peer review simulation
│           ├── abstract.md      # Structured 6-part abstract
│           └── score.md         # CEMCK self-assessment rubric (25-point)
├── shared/
│   ├── project-config.md        # Multi-project configuration loader (v1.2.0+)
│   ├── stage-machine.md         # Stage progression logic + gates
│   ├── state-loader.md          # Read/write _panel.yaml
│   ├── reviewer-selector.md     # Match reviewers to papers
│   ├── reviewer-profile-loader.md  # Load persistent profiles with caching (v1.3.0+)
│   ├── synthesis-engine.md      # Consolidate reviews → P1/P2/P3
│   ├── score-utils.md           # Score aggregation, consensus metrics
│   ├── display-utils.md         # Terminal formatting
│   ├── topic-discovery.md       # Scan sources → propose paper topics
│   ├── paper-generator.md       # Paper content generation logic
│   ├── plan-parser.md           # Parse plan.md into task objects
│   ├── quality-checker.md       # Quality gate validation
│   ├── panel-utils.md           # Module-level panel utilities (PP1/PP2/PP3, rounds)
│   ├── board-utils.md           # Board-level utilities (module discovery, B1/B2/B3)
│   ├── message-utils.md         # Standardized output formatting
│   ├── error-handler.md         # Error codes and recovery suggestions
│   ├── git-helper.md            # Auto-commit with git strategy
│   └── git-utils.md             # (deprecated, use git-helper.md)
├── templates/
│   ├── help/                    # Help topic files
│   ├── plan-template.md         # Paper plan with quantification contract
│   ├── findings-template.md     # Cumulative discovery artifact (F-NN IDs)
│   ├── review-template.md       # Individual review structure
│   ├── synthesis-template.md    # Synthesis document structure
│   ├── revision-plan-template.md  # Revision plan structure
│   └── reviewer-profile-template.md  # Reviewer profile structure (v1.3.0+)
├── commands/                    # Legacy command files (migrated to .claude/skills/)
├── config/
│   ├── stages.yaml              # Stage definitions + gates
│   ├── scoring.yaml             # Scoring rubrics (1-4 scale, 0-10 scale)
│   └── schemas/
│       └── panel-state.schema.yaml
├── context/
│   └── panel/
│       └── reviewers/
│           ├── _index.yaml      # Master registry (45 reviewers, 10 categories)
│           └── profiles/        # Persistent reviewer profiles (~2KB each)
├── research/                    # Research papers (5 papers)
│   ├── panel-{name}/           # Each paper: main.tex, sections/, Makefile
│   ├── docs/                   # Compiled PDFs
│   ├── Makefile                # Master build
│   ├── RESEARCH.md             # Paper inventory + dependency graph
│   ├── REVIEWERS.md            # Module reviewer subset
│   └── REVIEW_PANEL.md         # Module-level panel review
├── docs/                        # Plugin documentation
├── scripts/
│   ├── sync-to-plugin.sh       # → C:\src\plugins\panel
│   └── sync-to-research.sh     # → C:\src\research\panel
└── README.md
```

## The 8-Stage Lifecycle

```
Stage        Description                                    Gate to advance
─────        ───────────                                    ───────────────
1. draft     Paper exists, target venue identified          main.tex exists + venue set
2. panel     Reviewer panel assembled, reviews running      5+ REVIEW-*.md files generated
3. synthesis Reviews consolidated → SYNTHESIS.md            P1/P2/P3 tiering complete
4. revision  Author revising based on synthesis             All P1 items addressed
5. recheck   Round N reviews (N≥2), may loop → synthesis    Avg score ≥ 2.5/4, none < 2/4
6. ready     Panel review complete (panel:convene)           REVIEW_PANEL.md + PP1 addressed
7. submit    Paper submitted to target venue                Submission confirmed
8. accepted  Paper accepted at venue                        Acceptance confirmed
```

## Multi-Project Support (v1.2.0+)

Panel supports both **standalone mode** and **monorepo mode** with multiple research projects.

### Configuration

Projects are defined in `.claude/panel.json`:

```json
{
  "default": "craft-research",
  "projects": {
    "craft-research": {
      "panelPath": "context/panel/craft-research",
      "researchPath": "research/craft",
      "clientSlug": "craft-research",
      "projectName": "craft",
      "targetPlugin": "plugins/craft",
      "description": "Craft plugin research papers"
    },
    "waves-research": {
      "panelPath": "context/panel/waves-research",
      "researchPath": "research/waves",
      "clientSlug": "waves-research",
      "projectName": "waves",
      "targetPlugin": "plugins/waves",
      "description": "Waves plugin research papers"
    }
  }
}
```

### Project Fields

| Field | Required | Description |
|-------|----------|-------------|
| `panelPath` | Yes | Context data storage path (e.g., `context/panel/craft-research`) |
| `researchPath` | Yes | Research papers directory (e.g., `research/craft`) |
| `clientSlug` | Yes | Hub client identifier (e.g., `craft-research`) |
| `projectName` | Yes | Human-readable name (e.g., `craft`) |
| `targetPlugin` | No | Plugin directory reference (e.g., `plugins/craft`) |
| `description` | No | Project description |

### Modes

**Standalone Mode** (default):
- Single project: `"researchPath": "research"`
- Papers in `C:\src\panel/research/`
- Traditional panel workflow

**Monorepo Mode** (new):
- Multiple projects: each with its own `researchPath`
- Example: `"researchPath": "research/craft"` → `C:\src\craftworks/research/craft/`
- Switch between projects using `panel:project`
- Each project has independent research papers and context

### Usage

```bash
# List all projects
panel:project

# Switch to craft research
panel:project craft-research

# Work on craft papers
panel:setup panel-new-paper "CHI 2026"
panel:review panel-new-paper

# Switch to waves research
panel:project waves-research

# Work on waves papers
panel:status
```

### Directory Structure (Monorepo)

```
craftworks/                          # Monorepo root
├── .claude/
│   └── panel.json                   # Multi-project config
├── plugins/
│   ├── craft/                       # Plugin implementations
│   ├── waves/
│   └── probe/
├── research/                        # Research papers by plugin
│   ├── craft/                       # Craft research (module)
│   │   ├── panel-paper-1/
│   │   ├── panel-paper-2/
│   │   ├── RESEARCH.md
│   │   └── REVIEW_PANEL.md
│   ├── waves/                       # Waves research (module)
│   │   ├── panel-paper-1/
│   │   ├── RESEARCH.md
│   │   └── REVIEW_PANEL.md
│   └── probe/                       # Probe research (module)
│       └── RESEARCH.md
├── context/
│   └── panel/
│       ├── craft-research/          # Panel context per project
│       ├── waves-research/
│       └── probe-research/
└── REVIEW_BOARD.md                  # Board-level cross-module review
```

### Backward Compatibility

Existing standalone installations continue to work without changes:
- Old config without `projects` object → uses legacy defaults
- `researchPath` defaults to `"research"`
- Single-project behavior maintained

### See Also

- `MULTI-PROJECT-SETUP.md` — Complete setup guide
- `MONOREPO-READY.md` — Implementation status and next steps
- `shared/project-config.md` — Configuration loader utility

## Skills (12)

All skills are in `.claude/skills/{name}/SKILL.md` format.

| Skill | Tier | Purpose |
|-------|------|---------|
| `panel:paper` | Paper | Quick markdown papers — setup, author, review, status, show, promote |
| `panel:publication` | Paper | Formal LaTeX publication lifecycle — setup, author, review, status, show, venue |
| `panel:module` | Module | Module-tier operations — design tracks, review, curate, status |
| `panel:board` | Monorepo | Cross-module board review with rounds (7 members, B1/B2/B3) |
| `panel:research` | Research | Research pipeline — pre-write, post-write, 14 sub-skills |
| `panel:setup` | — | Initialize project or add a new paper |
| `panel:upgrade` | — | Smart migration from v1.x to v2.0 |
| `panel:reviewers` | — | Browse/filter reviewer database |
| `panel:project` | — | Switch between projects or list all projects |
| `panel:report` | — | Generate review reports |
| `panel:help` | — | Interactive help system |
| `panel:uninstall` | — | Remove plugin data and configuration — clean uninstall |

## Research Pipeline (v2.3.0+)

`panel:research` provides a complete research pipeline with 16 sub-commands organized into two orchestrators and 14 individual skills. Ported from production use in RMM (900+ papers, 48 perfect scores).

### Orchestrators

| Sub-command | Phase | Description |
|-------------|-------|-------------|
| `panel:research pre-write <topic>` | Before writing | 6-phase discovery pipeline → FINDINGS.md + readiness verdict |
| `panel:research post-write <topic>` | After writing | 7-phase validation pipeline → pre-submission checklist |

### Individual Sub-Skills

**Discover** (pre-write components):

| Sub-command | Description |
|-------------|-------------|
| `hypothesis <topic>` | Falsifiable claim + confidence + 2 test designs + null fallback |
| `competitors <topic>` | Competitive landscape with inertia-first framing |
| `causal <topic>` | Cause-effect chain tracing, confounder detection |
| `websearch <topic>` | Ground claims in publicly available evidence |
| `coherence <topic>` | Cross-finding contradiction detection (BLOCKING / ADVISORY) |
| `synthesize <topic>` | PROCEED / PAUSE / PIVOT verdict with confidence |

**Simulate** (argument & math verification):

| Sub-command | Description |
|-------------|-------------|
| `argument <topic>` | 4-specialist logical trace: Logician → Advocate → Empirical → Chair |
| `derivation <topic>` | Step-by-step math derivation verification (STEM only) |
| `contract <topic>` | Does the paper deliver what its methodology promises? |

**Validate** (post-write components):

| Sub-command | Description |
|-------------|-------------|
| `consistency <topic>` | Catches numerical contradictions across sections |
| `dimensional <topic>` | Unit analysis — LHS = RHS for all equations (STEM only) |
| `referee <topic>` | 3 hostile journal-specific referee simulations |

**Specify** (output generation):

| Sub-command | Description |
|-------------|-------------|
| `abstract <topic>` | 6-part structured abstract (Background → Gap → Claim → Method → Result → Implication) |
| `score <topic>` | CEMCK self-assessment rubric (25-point, 5 dimensions) |

### Pre-Write Pipeline Flow

```
plan.md
  ↓
hypothesis → competitors → causal → websearch → (derivation if math) → argument
  ↓
[FINDINGS.md collects all findings with F-NN IDs]
  ↓
coherence [BLOCKING / ADVISORY contradictions]
  ↓
synthesize [PROCEED / PAUSE / PIVOT]
  ↓
[update plan.md if needed]
  ↓
score [baseline CEMCK assessment]
  ↓
READY TO WRITE → panel:publication author
```

### Post-Write Pipeline Flow

```
Written sections + plan.md
  ↓
consistency [P1 mismatches → STOP]
  ↓
dimensional [math-heavy only → STOP if P1]
  ↓
contract [methodology vs claims check]
  ↓
abstract [6-part, journal-specific variant]
  ↓
referee [3 hostile referees, I-NN issues, likely decision]
  ↓
score [final CEMCK assessment]
  ↓
PRE-SUBMISSION CHECKLIST → READY TO SUBMIT / FIXES REQUIRED
```

### CEMCK Score Rubric

5 dimensions, 5 points each, 25 maximum:

| Dim | Name | 5 (Excellent) | 3 (Solid) | 1 (Weak) |
|-----|------|---------------|-----------|----------|
| **C** | Claim | Falsifiable, one-sentence, specific | Clear but vague | Unfalsifiable |
| **E** | Evidence | Named sources, specific numbers | Sources present, some generic | No numbers |
| **M** | Method | Reproducible, null fallback stated | Method clear but gaps | Unclear |
| **C** | Contribution | Novel, natural field connection | Present but forced | Redundant |
| **K** | Craft | Venue-appropriate, clean structure | Readable, rough edges | Poor structure |

**Thresholds**: 22-25 camera-ready | 18-21 needs revision | 14-17 significant work | <14 rewrite

### Key Artifacts

- **FINDINGS.md** — Cumulative discovery artifact with F-NN IDs, appended by each sub-skill
- **plan.md** — Enhanced with quantification contract (primary number, falsification, null fallback)
- **_score.md** — CEMCK score card with per-dimension breakdown
- **[NEED] tags** — Honest placeholders for missing data: `[NEED: data]`, `[NEED: compute]`, `[NEED: source]`

## Per-Paper State (`_panel.yaml`)

Each paper directory contains a `_panel.yaml` tracking lifecycle state:
- Current stage and round number
- Assigned reviewers with scores
- Review completion status by round
- P1 item tracking (addressed/not addressed)
- Stage transition history
- **Profile references** (new): `profile_ref` field for each reviewer linking to persistent profiles

## Reviewer Profile System (v1.3.0+)

Panel uses **persistent reviewer profiles** for token-efficient persona simulation with session-level caching.

### Architecture

Instead of loading the full `REVIEWER-DATABASE.md` (11.5KB, ~3000 tokens) for each reviewer on every review, profiles provide:
- **Persistent storage**: Individual markdown files (~2KB each) in `context/panel/reviewers/profiles/`
- **Session-level caching**: Load once, reuse across rounds and papers
- **Token savings**: 60-75% reduction for reviewer context (validated via A/B testing)

### Profile Structure

Each profile contains 7 sections:

| Section | Purpose | Size |
|---------|---------|------|
| **YAML Frontmatter** | Metadata (name, affiliation, category, keywords) | Required |
| **Research Background** | 2-3 paragraphs on expertise and research focus | 150-200 words |
| **Key Publications** | 3-5 seminal papers or projects | Bullet list |
| **Evaluation Lens** | Characteristic questions and focus areas | 3-5 items |
| **Review Criteria** | Checklist for evaluating papers | 5-8 items |
| **Characteristic Concerns** | Common issues this reviewer raises | 4-6 items |
| **Voice & Tone** | Writing style descriptors | 3-5 traits |
| **AI Simulation Disclosure** | Footer explaining AI persona | Required |

**Size Target**: 1.8-2.2KB per profile (~500-600 words)

### Profile Resolution Chain

The profile loader uses a four-tier resolution chain with caching:

1. **Cache hit** → Return cached profile (<1ms)
2. **Exact match** → `context/panel/reviewers/profiles/{name}.md`
3. **Slug match** → Convert "Percy Liang" → "percy-liang.md"
4. **Database fallback** → Extract from `REVIEWER-DATABASE.md` (87ms)

**Performance**:
- Cache hits: <1ms
- File loads: 12ms average
- Database fallback: 87ms
- **Speedup**: 15× faster on cache hits vs file loads

### Integration Points

**Paper Level (`panel:review`)**:
- Profiles loaded during `panel` stage via `shared/reviewer-profile-loader.md`
- Profile reference stored in `_panel.yaml.reviewers[].profile_ref`
- Full profile context passed to review generation
- Cache reused in round 2+ (50% hit rate)

**Module Level (`panel:convene`)**:
- 7-member panel profiles loaded at session start
- Cached for reuse across all papers in module
- Typical cache hit rate: 100% after first paper

**Synthesis (`shared/synthesis-engine.md`)**:
- Profile summaries included in synthesis documents
- P1/P2/P3 items show reviewer expertise in attribution (e.g., "[ML Research]")
- Score distribution table includes Affiliation + Expertise columns

### panel:reviewers Command

Enhanced with profile operations:

```bash
# List reviewers with profile summaries
panel:reviewers --detailed

# Show full profile for one reviewer
panel:reviewers show "Percy Liang"
panel:reviewers show percy-liang

# Edit profile (opens in editor)
panel:reviewers edit percy-liang

# Filter by category
panel:reviewers --category ml-research

# Filter by venue
panel:reviewers --venue NeurIPS
```

### Master Registry

All 45 reviewers indexed in `context/panel/reviewers/_index.yaml`:
- 10 categories (Systems, Compilers, AI Agents, Prompting, HCI, ML Systems, ML Research, Software Eng, NLP, Security)
- Profile existence tracking (`profile_exists: true/false`)
- Category metadata: names, counts, keywords, typical venues
- Version tracking for profile updates

### Token Efficiency

**Experimental validation** (A/B testing, n=5 papers):

| Metric | Baseline (Database) | Profiles | Reduction |
|--------|---------------------|----------|-----------|
| Per-reviewer tokens (first) | 7,500 | 6,500 | 13% |
| Per-reviewer tokens (cached) | 7,500 | 4,500 | 40% |
| **Average per reviewer** | **7,500** | **5,100** | **32%** |
| **5 reviewers × 1 paper** | **37,500** | **24,500** | **34.7%** |

**Module-level savings** (7 reviewers × 5 papers):
- Baseline: 262,500 tokens
- Profiles: 164,500 tokens
- **Savings: 98,000 tokens (37.3%)**

### Quality Validation

All profiles validated via automated checks:
- **Structure**: 7 required sections, YAML frontmatter, size within range
- **Content**: Specificity, accuracy, characteristic voice
- **Coverage**: 10 categories, 45 reviewers, balanced distribution
- **Consistency**: YAML matches registry, formatting uniform
- **Ethics**: AI Simulation Disclosure in all profiles

Run validation suite:
```bash
./context/waves/260215+galileo-observer+reviewer-profiles/validation/run-all-validation.sh
```

### Usage Examples

**Generate review with profiles**:
```bash
# Profiles loaded automatically
panel:review --paper panel-review-methodology

# Check profile reference in state
cat research/panel-review-methodology/_panel.yaml | grep profile_ref
```

**Browse profiles**:
```bash
# List with summaries
panel:reviewers --detailed --category ml-research

# Show full profile
panel:reviewers show percy-liang

# Edit profile
panel:reviewers edit percy-liang
```

**Verify profile system**:
```bash
# Structure check
./context/waves/.../validation/profile-structure-check.sh

# Coverage report
./context/waves/.../validation/profile-coverage-report.sh

# Full validation suite
./context/waves/.../validation/run-all-validation.sh
```

### See Also

- Profile loader: `shared/reviewer-profile-loader.md`
- Master registry: `context/panel/reviewers/_index.yaml`
- Template: `templates/reviewer-profile-template.md`
- Validation: Wave 7 (Galileo Observer) experimental protocol
- Research paper: `research/panel-reviewer-profiles/` (token efficiency study)

## Round Tracking (Panel + Board Tiers)

Paper-level keeps flat file pattern (`ROUND2-REVIEW-*.md`). Panel and board tiers use round directories:

```
{module}/
├── REVIEW_PANEL.md              ← always the latest/canonical
├── panel-reviews/
│   ├── round-1/
│   │   ├── REVIEW_PANEL.md      ← snapshot
│   │   └── PANEL-REVISION-PLAN.md
│   └── round-2/
│       └── ...

{repo}/
├── REVIEW_BOARD.md              ← always the latest/canonical
├── BOARD-REVISION-PLAN-{module}.md
├── board-reviews/
│   ├── round-1/
│   │   ├── REVIEW_BOARD.md      ← snapshot
│   │   └── BOARD-REVISION-PLAN-*.md
│   └── round-2/
│       └── ...
```

## Research Papers (5)

| # | Paper | Venue Target |
|---|-------|-------------|
| 1 | panel-review-methodology | CHI / CSCW |
| 2 | panel-reviewer-calibration | EMNLP / ACL |
| 3 | panel-revision-dynamics | NeurIPS D&B |
| 4 | panel-portfolio-assessment | JCDL / Scientometrics |
| 5 | panel-synthesis-methods | AAAI / IJCAI |

## Build Commands

```bash
# Build all research papers
cd research
make all

# Build single paper
make -C research/panel-review-methodology pdf

# Copy PDFs to docs/
cd research
make dist
```

## Ship It

When the user says "ship it", run the full deploy sequence:

```bash
# 1. Commit (with [panel] prefix)
git add <changed files>
git commit -m "[panel] <message>"

# 2. Push
git push

# 3. Sync plugin → C:\src\plugins\panel (pulls, copies, commits, pushes in target repo)
./scripts/sync-to-plugin.sh --push

# 4. Sync research → C:\src\research\panel (pulls, copies, commits, pushes in target repo)
./scripts/sync-to-research.sh --push
```

All four steps run in order. If any step fails, stop and report.

Sync scripts support: `--push` (push to remote), `--dry-run` (preview), `--message "msg"` (custom commit message).

## Plugin Configuration

Panel uses `.claude/panel.json` for plugin settings:

```json
{
  "default": "panel",
  "gitStrategy": "auto-commit",
  "suppressMessages": []
}
```

### Settings

| Setting | Values | Description |
|---------|--------|-------------|
| `gitStrategy` | `"auto-commit"` or `"manual"` | Controls whether commands auto-commit changes |
| `suppressMessages` | Array of message types | Suppress specific output types: `["item", "subitem", "separator"]` |
| `default` | String | Default project name (for multi-project support) |

### Git Strategy

- **auto-commit**: Commands commit changes automatically when they finish using scoped `git add` (only files the command touched)
- **manual**: Changes are left uncommitted for user review

Commands respect this setting through `shared/git-helper.md` which provides:
- `gitCommitIfEnabled(message, paths)` — Simple auto-commit
- `auto_commit(context)` — Scoped commit with detailed control

### Message Utilities

All commands use standardized output formatting via `shared/message-utils.md`:

| Type | Symbol | Use |
|------|--------|-----|
| `header` | `═══` | Section headers |
| `stage` | `▶` | Stage transitions |
| `success` | `✓` | Confirmations |
| `error` | `✗` | Errors |
| `warning` | `⚠` | Warnings |
| `item` | `•` | List items |
| `complete` | `+` | Completed actions |

Use `suppressMessages` in config to reduce verbosity for specific workflows.

### Error Handling

Standardized error codes via `shared/error-handler.md`:

- **E100-E199**: File & state errors
- **E200-E299**: Stage & workflow errors
- **E300-E399**: Review errors
- **E400-E499**: Module & board errors
- **E500-E599**: Git & sync errors
- **E600-E699**: Configuration errors

Each error includes recovery suggestions and relevant command references.

## Conventions

- Commit messages prefixed with `[panel]`
- PDFs in `research/docs/` are canonical outputs
- Review files use ALL-CAPS: `REVIEW-PERCY-LIANG.md`, `SYNTHESIS.md`
- State files use underscore prefix: `_panel.yaml`
