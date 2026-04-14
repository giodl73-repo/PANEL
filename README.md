# Panel

**AI-Powered Research Quality Improvement**

A Claude Code plugin that simulates expert feedback to help you strengthen your research papers before submission. This is NOT a substitute for peer review—it's a tool for quality improvement.

> **What This Is**: AI-generated feedback based on domain expert personas to help identify weaknesses and improve your work.
>
> **What This Is NOT**: Real peer review, real reviewer opinions, or a replacement for actual conference submission.

## Quick Start

```bash
# Initialize in your research project
panel:setup

# Run the review lifecycle
panel:go --paper my-paper

# Check status
panel:status
```

## Commands

| Command | Purpose |
|---------|---------|
| `panel:go` | Stage-driven lifecycle — moves paper through all 8 stages |
| `panel:status` | Overview of all papers: stage, round, score, next action |
| `panel:show` | Detailed view of one paper — reviews, synthesis, scores |
| `panel:reviewers` | Browse, search, filter reviewer database |
| `panel:setup` | Initialize panel in a project |
| `panel:import` | Import existing review process from REVIEW-*.md files |
| `panel:report` | Generate review reports (per-paper, portfolio) |
| `panel:help` | Interactive help (stages, reviewers, scoring, workflow) |
| `panel:venue` | Venue recommendation + submission strategy |

## The 8-Stage Lifecycle

```
1. draft      → Paper exists, venue identified
2. panel      → 5+ reviewers assigned, individual reviews generated
3. synthesis  → Reviews consolidated → SYNTHESIS.md with P1/P2/P3 tiering
4. revision   → Author revises based on synthesis (P1 items addressed)
5. recheck    → Round N reviews; loops to synthesis if scores insufficient
6. ready      → All reviewers Accept; cross-portfolio panel complete
7. submit     → Paper submitted to target venue
8. accepted   → Paper accepted at venue
```

Re-entrancy: `panel:go` reads `_panel.yaml` to determine current stage, picks up where it left off.

## Research Papers

6 papers documenting the methodology:

| # | Paper | Title | Venue |
|---|-------|-------|-------|
| 1 | [panel-review-methodology](research/panel-review-methodology/) | AI-Simulated Expert Review: A Methodology for Pre-Submission Paper Assessment | CHI / CSCW |
| 2 | [panel-reviewer-calibration](research/panel-reviewer-calibration/) | Calibrating AI Reviewer Personas: Domain Expertise Simulation Without Fine-Tuning | EMNLP / ACL |
| 3 | [panel-revision-dynamics](research/panel-revision-dynamics/) | Multi-Round Revision Dynamics: Measuring Paper Quality Improvement Through Iterative AI Review | NeurIPS D&B |
| 4 | [panel-portfolio-assessment](research/panel-portfolio-assessment/) | Cross-Portfolio Expert Panels: Holistic Assessment of Multi-Paper Research Programs | JCDL / Scientometrics |
| 5 | [panel-synthesis-methods](research/panel-synthesis-methods/) | From Reviews to Revisions: Automated Synthesis and Priority Classification of Expert Feedback | AAAI / IJCAI |
| 6 | [panel-reviewer-profiles](research/panel-reviewer-profiles/) | Token-Efficient Persona Simulation: Persistent Profiles for AI-Simulated Expert Reviews | EMNLP Demo / ACL Systems |

## How to Use This Plugin

### ✅ DO Use For:
- **Quality improvement** — identify weaknesses before real submission
- **Perspective diversity** — see your work through different domain lenses
- **Iterative refinement** — strengthen arguments, methodology, and presentation
- **Self-assessment** — calibrate whether work is ready for submission

### ❌ DO NOT Use For:
- **"Responding to reviewers"** — these are not real reviewers, don't write rebuttals
- **Conference submission readiness** — AI feedback ≠ actual acceptance likelihood
- **Citation as peer review** — never claim "reviewed by [persona name]"
- **Bypassing actual peer review** — always submit to real venues for real feedback

### 💡 Best Practice:
Treat suggestions like insights from a smart colleague, not mandates from reviewers. Use what strengthens your work, ignore what doesn't align with your research goals.

## Reviewer Profile System (v1.3.0+)

Panel uses **persistent reviewer profiles** for efficient persona simulation with dramatically reduced token costs.

### Why Profiles?

**Problem**: Loading the full reviewer database (11.5KB, ~3000 tokens) for each reviewer on every review wastes tokens and slows down review generation.

**Solution**: Persistent profiles (~2KB each) loaded once and cached for reuse across rounds and papers.

**Benefits**:
- **60-75% token reduction** for reviewer context (validated via A/B testing)
- **15× faster** on cache hits (<1ms vs 12ms file loads)
- **Consistent personas** across review rounds
- **Richer context** with research background, evaluation lens, characteristic concerns

### Quick Start

**Browse reviewer profiles**:
```bash
# List all reviewers with summaries
panel:reviewers --detailed

# Show full profile for one reviewer
panel:reviewers show "Percy Liang"

# Filter by category
panel:reviewers --category ml-research

# Filter by venue
panel:reviewers --venue NeurIPS
```

**Reviews automatically use profiles** — no configuration needed. The system loads profiles during review generation and caches them for subsequent rounds.

### Profile Structure

Each profile (1.8-2.2KB) contains:
- **Research Background**: 2-3 paragraphs on expertise and contributions
- **Key Publications**: 3-5 seminal papers
- **Evaluation Lens**: Characteristic questions this reviewer asks
- **Review Criteria**: Checklist for evaluating papers
- **Characteristic Concerns**: Common issues they raise
- **Voice & Tone**: Writing style descriptors
- **AI Simulation Disclosure**: Explicit statement of AI persona methodology

### Token Savings

Experimental validation (A/B testing, n=5 papers):

| Metric | Baseline (Database) | Profiles | Savings |
|--------|---------------------|----------|---------|
| **Per paper (5 reviewers)** | 37,500 tokens | 24,500 tokens | **34.7%** |
| **Module (7 reviewers × 5 papers)** | 262,500 tokens | 164,500 tokens | **37.3%** |
| **Per reviewer (cached)** | 7,500 tokens | 4,500 tokens | **40%** |

**Typical cache hit rate**: 50% on round 2, 100% for module-level panel reviews.

### Master Registry

45 reviewers across 10 categories:
- Systems & Infrastructure (5)
- Compilers & PL Theory (4)
- AI Agents & Orchestration (6)
- Prompting & LLM Capabilities (5)
- Human-AI Interaction (7)
- ML Systems & Efficiency (5)
- ML Research / Learning (4)
- Software Engineering & DevOps (3)
- NLP & Information Retrieval (4)
- Security & Safety (2)

All indexed in `context/panel/reviewers/_index.yaml` for fast filtering and discovery.

### How It Works

**Four-tier resolution chain**:
1. **Cache hit** → Return cached profile (<1ms)
2. **Exact match** → Load from `context/panel/reviewers/profiles/{name}.md`
3. **Slug match** → Convert "Percy Liang" → "percy-liang.md"
4. **Database fallback** → Extract from `REVIEWER-DATABASE.md` (graceful degradation)

**Performance**:
- Cache hits: <1ms
- File loads: 12ms average
- Database fallback: 87ms
- **Speedup**: 15× faster on cache hits

### Integration

Profiles integrate seamlessly across all three tiers:

**Paper Level** (`panel:review`):
- Profiles loaded during panel assembly
- Cached for round 2+
- Full profile context passed to review generation

**Module Level** (`panel:module`):
- 7-member panel profiles loaded at session start
- Reused across all papers in module
- 100% cache hit rate after first paper

**Synthesis** (`SYNTHESIS.md`):
- Score distribution includes Affiliation + Expertise columns
- P1/P2/P3 items show reviewer category (e.g., "[ML Research]")
- Context notes explain reviewer evaluation lens

### See Also

- **Template**: `templates/reviewer-profile-template.md` — 7-section structure
- **Loader**: `shared/reviewer-profile-loader.md` — Implementation details
- **Validation**: Wave 7 (Galileo Observer) experimental protocol
- **Research**: `research/panel-reviewer-profiles/` — Token efficiency study

## AI Simulation Methodology

This system uses AI-generated personas based on real researchers to provide diverse perspectives on your work. **Critical clarifications:**

### What The Names Mean
- **Named researchers are AI personas, not participants.** Names like "Percy Liang" or "Michael Bernstein" refer to AI-generated feedback based on each researcher's published work and documented expertise. **The actual individuals did not participate, write, review, or endorse anything.**
- **Persona construction** uses public information: publication venues, known expertise areas, methodological preferences, and characteristic research concerns (e.g., "Where's the IR?" for a compilers researcher). The goal is perspective diversity, not impersonation.

### What The Output Means
- **All feedback is synthetic.** Every "review," synthesis, and assessment is AI-generated by Claude (Anthropic). Scores, verdicts, and suggestions are AI outputs, not human judgments.
- **Purpose: quality improvement.** This helps you identify weaknesses and strengthen your work before real submission. It does not replace or represent actual peer review.
- **Suggestions, not requirements.** Treat P1/P2/P3 classifications as "high/medium/low impact improvements," not "must-fix issues from reviewers."

### Templates & Formatting
- **No conference templates by default.** Papers use generic `article` class to emphasize this is quality work, not submission-ready formatting.
- **Use conference templates only when** you're actually submitting to that conference or responding to real reviewer feedback.

Every generated review file includes an AI Simulation Disclosure footer. The reviewer database (REVIEWER-DATABASE.md) contains the full disclosure at the top.

## Building Papers

```bash
cd research
make all          # Build all papers
make dist         # Copy PDFs to docs/
make clean        # Remove build artifacts
```

## Syncing

```bash
# Sync plugin to plugins directory
./scripts/sync-to-plugin.sh

# Sync research to research monorepo
./scripts/sync-to-research.sh
```
