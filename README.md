# Panel

**AI-Powered Research Quality Improvement**

A Claude Code plugin that simulates expert feedback to help you strengthen your research papers before submission. This is NOT a substitute for peer review—it's a tool for quality improvement.

**Review roles:** This repo uses
[ROLES](https://github.com/giodl73-repo/ROLES), the `.roles` convention for
repository-local review panels.

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

## Reviewers

Panel ships with a registry of 45 simulated reviewer personas across 10 categories — Systems & Infrastructure, Compilers & PL Theory, AI Agents & Orchestration, Prompting & LLM Capabilities, Human-AI Interaction, ML Systems & Efficiency, ML Research / Learning, Software Engineering & DevOps, NLP & Information Retrieval, and Security & Safety. Each persona is loaded as a persistent **profile** (research background, evaluation lens, characteristic concerns, voice) and cached across review rounds for consistency.

Browse them:

```bash
panel:reviewers --detailed                  # all reviewers with summaries
panel:reviewers show "Percy Liang"          # one full profile
panel:reviewers --category ml-research      # filter by category
panel:reviewers --venue NeurIPS             # filter by venue
```

Reviews use profiles automatically — no configuration needed. Implementation details (resolution chain, cache behavior, token economics) are in the [appendix](#appendix-profile-system).

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

## Maintenance ownership

- **Active owner:** the `giodl73-repo/PANEL` repository maintainer.
- **2026-08-16 reduction:** removed ten tracked LaTeX intermediate files
  (150.5 KiB) that the existing publication `make clean` targets already
  classify as disposable build state.
- **Boundary:** publication sources and final PDFs remain tracked evidence;
  `.aux`, `.bbl`, `.blg`, `.log`, `.fls`, `.fdb_latexmk`, and related
  intermediates remain ignored and must not be recommitted.

## Syncing

```bash
# Sync plugin to plugins directory
./scripts/sync-to-plugin.sh

# Sync research to research monorepo
./scripts/sync-to-research.sh
```

## Appendix: profile system

Each profile is ~2KB and contains seven sections: research background, key publications, evaluation lens, review criteria, characteristic concerns, voice & tone, and an AI-simulation disclosure footer. Profiles are loaded once per session and cached, then reused across rounds and modules.

**Resolution chain** — when `panel:review` asks for a reviewer:

1. Cache hit → return cached profile (<1ms)
2. Exact match → load from `context/panel/reviewers/profiles/{name}.md`
3. Slug match → convert "Percy Liang" → `percy-liang.md`
4. Database fallback → extract from `REVIEWER-DATABASE.md`

**Token economics** (A/B tested, n=5 papers):

| Metric | Baseline (Database) | Profiles | Savings |
|--------|---------------------|----------|---------|
| Per paper (5 reviewers) | 37,500 tokens | 24,500 tokens | 34.7% |
| Module (7 reviewers × 5 papers) | 262,500 tokens | 164,500 tokens | 37.3% |
| Per reviewer (cached) | 7,500 tokens | 4,500 tokens | 40% |

Cache hits are 15× faster than file loads (<1ms vs 12ms). Typical cache hit rate is 50% on round 2 and 100% for module-level panel reviews. Full registry is indexed in `context/panel/reviewers/_index.yaml`.

## License

[MIT](LICENSE) — © 2026 Gio Della-Libera.
