# Paper Plan: Token-Efficient Reviewer Simulation via Persistent Role Profiles

## Research Question

Can pre-built persistent reviewer profiles reduce token consumption in AI-simulated
peer review while maintaining review quality? We propose storing structured reviewer
personas as role files and loading them on-demand rather than reconstructing context
from scratch each invocation.

## Target Venue

- Conference/journal: EMNLP 2026
- Deadline: June 15, 2026
- Page limit: 8 pages + references
- Expected contribution type: System, Empirical Study

## Sections

- Introduction: motivation (LLM review costs), problem (repeated persona construction), contribution (persistent profiles)
- Related Work: LLM-as-reviewer systems, persona simulation, context efficiency
- Methodology: OLE profile format, role registry, resolution chain, session caching
- Evaluation: token counts A vs B, review quality metrics (ROUGE, human ratings), cache hit rates
- Results: 32% token reduction, quality parity at p<0.05
- Discussion: trade-offs, profile staleness, extension model
- Conclusion: summary and future directions

## Experiments

- [ ] Token counting: measure baseline (full DB) vs profiles across 5 papers × 5 reviewers
- [ ] Quality comparison: ROUGE-L between baseline and profile-generated reviews
- [ ] Cache hit rate: measure across 2-round review cycles

## Figures

- [ ] Token usage comparison (grouped bar chart)
- [ ] Cache hit rate over rounds (line chart)
- [ ] Resolution chain diagram (TikZ)

## Tables

- [ ] Per-reviewer token breakdown (baseline vs profile vs cached)
- [ ] Review quality metrics (ROUGE-L, BERTScore, human ratings)

## Quality Checkpoints

- [ ] Word count: 6000-7500 words
- [ ] References: 30+ citations
- [ ] All experiments completed
- [ ] All figures generated
- [ ] Statistical significance reported

## Notes

Smoke test fixture — intentionally minimal. No real experiments or scripts.
