# Wave 7: Token-Efficient Reviewer Profiles

**Scientist**: Galileo Galilei (observer)
**Theme**: *"Measure what is measurable, and make measurable what is not so."*
**Created**: February 15, 2026
**UUID**: `0db0c43f`

---

## Mission

Implement persistent reviewer profiles to reduce token costs by 60-75% in AI-simulated expert reviews. Following craft's discipline pattern, create structured markdown profiles that are loaded once and reused across review rounds and papers.

## Approach

**Phase 0: Research Paper FIRST** — Write and validate the design through panel review before implementation. This ensures the architecture is sound and the experimental protocol is rigorous.

**Phases 1-5**: Infrastructure → Generation → Integration → Management → Validation

## Key Deliverables

1. **Research Paper**: `research/panel-reviewer-profiles/` — Empirical validation of token efficiency
2. **45 Reviewer Profiles**: `context/panel/reviewers/profiles/*.md` — Persistent persona contexts
3. **Profile Loader**: `shared/reviewer-profile-loader.md` — Resolution chain with caching
4. **Enhanced Commands**: Updated `panel:review`, `panel:convene`, `panel:reviewers`
5. **Experimental Results**: A/B comparison demonstrating 60-75% token reduction

## Galileo's Observation

This wave exemplifies systematic measurement and empirical validation. Before building, we observe and document. Before deploying, we measure and verify. The research paper isn't an afterthought—it's the blueprint that guides implementation and validates the hypothesis.

**Measurement Focus**:
- Token usage: baseline vs. profiles (quantified reduction)
- Quality preservation: P1 alignment across conditions
- Consistency: Round 1 ↔ Round 2 correlation
- Statistical rigor: p-values, effect sizes, confidence intervals

Through careful observation and controlled experimentation, we make token efficiency measurable—and thus, improvable.

---

## Quick Links

- **Stage Plan**: `planning/stage-plan.md`
- **Research Paper**: `../../research/panel-reviewer-profiles/` (to be created)
- **Wave Status**: In Progress (Stage: Planning)
- **Next Action**: Execute P1 (Research Paper Design)

---

*Galileo's heraldry: Systematic measurement, empirical observation, mathematical precision*
