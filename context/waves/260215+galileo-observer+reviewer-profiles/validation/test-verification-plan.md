# End-to-End Test Verification Plan — Profile System

**Wave**: 260215+galileo-observer+reviewer-profiles (Galileo, observer)
**Phase**: V4 End-to-End Testing
**Date**: 2026-02-15

---

## Overview

This document provides a comprehensive checklist for verifying the profile system integration across all three tiers (paper, module, board) and confirming token efficiency gains.

---

## Test Scenarios

### Scenario 1: Paper-Level Review (panel:review)

**Setup**:
- Select test paper: `panel-review-methodology` (CHI 2026)
- Expected reviewers: Ben Shneiderman, Michael Bernstein, Saleema Amershi, Jeffrey Heer, Ece Kamar
- Ensure test fixtures exist in `test/fixtures/profiles/`

**Verification Steps**:

#### 1.1 Profile Loading
- [ ] Run `panel:review --paper panel-review-methodology --until panel`
- [ ] Verify 5 reviewer profiles loaded from cache/file/database
- [ ] Check console output for profile resolution messages
- [ ] Confirm `_panel.yaml` contains `profile_ref` for each reviewer

**Expected Output**:
```yaml
reviewers:
  - name: Ben Shneiderman
    profile_ref: ben-shneiderman
    score: null
  - name: Michael Bernstein
    profile_ref: michael-bernstein
    score: null
```

#### 1.2 Review Generation with Profile Context
- [ ] Advance to synthesis: `panel:review --paper panel-review-methodology --until synthesis`
- [ ] Open each `reviews/REVIEW-{NAME}.md` file
- [ ] Verify reviews reference reviewer's research background
- [ ] Check for evaluation lens characteristics (e.g., "human agency" for Shneiderman)
- [ ] Confirm voice/tone matches profile (e.g., methodical for Liang, human-centered for Shneiderman)

**Quality Check**:
```markdown
# Example from REVIEW-BEN-SHNEIDERMAN.md
As a researcher focused on human-centered AI and meaningful human control...

## Evaluation Lens
- Does this preserve user agency?
- What are the empowerment vs. automation trade-offs?
```

#### 1.3 Synthesis with Profile Attribution
- [ ] Open `reviews/SYNTHESIS.md`
- [ ] Verify "Score Distribution" table includes Affiliation + Expertise columns
- [ ] Check P1/P2/P3 items show reviewer expertise in attribution (e.g., "[HCI]")
- [ ] Confirm context notes explain reviewer evaluation lens

**Expected Format**:
```markdown
## Score Distribution
| Reviewer | Affiliation | Expertise | Score | Verdict |
|----------|-------------|-----------|-------|---------|
| Ben Shneiderman | UMD | HCAI, human agency | 3/4 | Revise |

### P1.1: [Issue Title] (raised by: Ben Shneiderman [HCI], Michael Bernstein [HCI], Ece Kamar [HCI])
*Context*: Ben Shneiderman's evaluation lens focuses on preserving meaningful human control.
```

#### 1.4 AI Simulation Disclosure
- [ ] Verify every `REVIEW-*.md` has disclosure footer
- [ ] Check `SYNTHESIS.md` has disclosure footer
- [ ] Confirm `REVISION-PLAN.md` (now `revisions.md`) has disclosure if it references personas

---

### Scenario 2: Module-Level Panel (panel:module review)

**Setup**:
- Run on module with 3+ papers
- Expected: 7-member cross-portfolio panel
- Papers: panel-review-methodology, panel-reviewer-profiles, panel-revision-dynamics

**Verification Steps**:

#### 2.1 Profile Loading at Session Start
- [ ] Run `panel:module review`
- [ ] Verify 7 panel profiles loaded at session start (console output)
- [ ] Check profiles cached for reuse across all papers
- [ ] Confirm cache hit rate reported after reviewing all papers

**Expected Cache Pattern**:
```
Loading profiles for 7-member panel...
✓ Percy Liang loaded (12ms)
✓ Ben Shneiderman loaded (11ms)
...
Cache stats: 21 hits, 0 misses (100% hit rate)
```

#### 2.2 Panel Assessments with Profile Context
- [ ] Open `REVIEW_PANEL.md`
- [ ] Verify panel member assessments reference their expertise
- [ ] Check PP1/PP2/PP3 items show cross-paper patterns
- [ ] Confirm panel member backgrounds summarized in overview section

#### 2.3 Round Tracking
- [ ] After revisions, run `panel:module review` again (round 2)
- [ ] Verify round directory created: `panel-reviews/round-2/`
- [ ] Check `REVIEW_PANEL.md` updated with round 2 content
- [ ] Confirm `panel-reviews/round-1/REVIEW_PANEL.md` preserved as snapshot

---

### Scenario 3: Cache Efficiency Analysis

**Setup**:
- Clear profile cache: restart Claude Code session or clear `.craftworks/cache/profiles/`
- Run full paper review with cache tracking enabled

**Verification Steps**:

#### 3.1 Cache Miss (Cold Start)
- [ ] Run `panel:review --paper panel-review-methodology --until synthesis`
- [ ] Capture profile load times (expect ~12ms per file load)
- [ ] Verify 5 profiles loaded from file (not cache)
- [ ] Total load time: ~60ms (5 × 12ms)

#### 3.2 Cache Hit (Warm Run)
- [ ] Run round 2: `panel:review --paper panel-review-methodology --round 2`
- [ ] Capture profile load times (expect <1ms per cache hit)
- [ ] Verify 5 profiles loaded from cache
- [ ] Total load time: <5ms (5 × <1ms)

**Performance Metrics**:
```
Round 1 (cold): 60ms total (12ms avg per profile)
Round 2 (warm): 4ms total (<1ms avg per profile)
Speedup: 15× faster
```

#### 3.3 Database Fallback
- [ ] Remove a profile file (e.g., `context/panel/reviewers/profiles/percy-liang.md`)
- [ ] Run review with that reviewer
- [ ] Verify graceful fallback to REVIEWER-DATABASE.md
- [ ] Confirm fallback load time ~87ms (slower)
- [ ] Restore profile file after test

---

### Scenario 4: Token Savings Verification

**Setup**:
- Instrument review generation with token counters
- Compare baseline (database) vs profile system

**Verification Steps**:

#### 4.1 Baseline Token Count (Database Mode)
- [ ] Temporarily disable profile loader in `commands/review.md`
- [ ] Run review with REVIEWER-DATABASE.md loaded for each reviewer
- [ ] Capture total input tokens per reviewer:
  - Paper content: ~4,000 tokens
  - Reviewer context (database): ~3,000 tokens
  - Other context: ~500 tokens
  - **Total per reviewer: ~7,500 tokens**
- [ ] For 5 reviewers: **37,500 tokens total**

#### 4.2 Profile Token Count (Profile Mode)
- [ ] Re-enable profile loader
- [ ] Run same review with profiles
- [ ] Capture total input tokens per reviewer:
  - Paper content: ~4,000 tokens
  - Reviewer context (profile): ~2,000 tokens (cached after first)
  - Other context: ~500 tokens
  - **First reviewer: ~6,500 tokens**
  - **Remaining 4 reviewers: ~4,500 tokens each** (cached profile)
- [ ] Total: 6,500 + (4 × 4,500) = **24,500 tokens**

#### 4.3 Token Reduction Calculation
```
Baseline:  37,500 tokens
Profiles:  24,500 tokens
Savings:   13,000 tokens (34.7% reduction)

Per-reviewer savings:
- First reviewer: 1,000 tokens (13%)
- Remaining 4: 3,000 tokens each (40%)
- Average: 2,600 tokens per reviewer (34.7%)
```

**Expected Result**: 30-40% token reduction for reviewer context, matching hypothesis.

---

### Scenario 5: Review File Inspection

**Setup**:
- Complete full review lifecycle for one paper
- Inspect all generated files for consistency

**Verification Steps**:

#### 5.1 File Structure
- [ ] Verify `_panel.yaml` has `profile_ref` for all reviewers
- [ ] Check `reviews/REVIEW-*.md` files exist (5 files)
- [ ] Confirm `reviews/SYNTHESIS.md` exists
- [ ] Verify `revisions.md` exists (renamed from REVISION-PLAN.md)

#### 5.2 Profile References
- [ ] Open `_panel.yaml`
- [ ] Verify each reviewer has valid `profile_ref`
- [ ] Cross-reference with `context/panel/reviewers/profiles/` directory
- [ ] Confirm profiles exist for all referenced slugs

#### 5.3 Content Quality
- [ ] Open each `REVIEW-*.md` file
- [ ] Check for persona-specific language (not generic)
- [ ] Verify evaluation lens reflected in critique
- [ ] Confirm recommendations align with reviewer's research focus

#### 5.4 Consistency Across Rounds
- [ ] Run round 2 review
- [ ] Compare `REVIEW-*.md` files from round 1 and round 2
- [ ] Verify same reviewers used
- [ ] Check for consistent voice/tone across rounds
- [ ] Measure cosine similarity of P1 items (target: ≥0.70)

---

## Test Execution Report Template

```markdown
# Test Execution Report — Profile System V4

**Date**: [YYYY-MM-DD]
**Tester**: [Name]
**Environment**: Claude Code v[X.Y.Z], Panel v[X.Y.Z]

## Summary

- Total scenarios: 5
- Passed: X/5
- Failed: Y/5
- Coverage: [paper/module/board tiers]

## Results

### Scenario 1: Paper-Level Review
- Status: [PASS/FAIL]
- Profile loading: [PASS/FAIL]
- Review generation: [PASS/FAIL]
- Synthesis attribution: [PASS/FAIL]
- AI Simulation Disclosure: [PASS/FAIL]
- Notes: ...

### Scenario 2: Module-Level Panel
- Status: [PASS/FAIL]
- Session-level caching: [PASS/FAIL]
- Panel assessments: [PASS/FAIL]
- Round tracking: [PASS/FAIL]
- Notes: ...

### Scenario 3: Cache Efficiency
- Status: [PASS/FAIL]
- Cold start: [X]ms (target: ~60ms)
- Warm start: [X]ms (target: <5ms)
- Speedup: [X]× (target: ≥10×)
- Database fallback: [PASS/FAIL]
- Notes: ...

### Scenario 4: Token Savings
- Status: [PASS/FAIL]
- Baseline tokens: [X]
- Profile tokens: [X]
- Reduction: [X]% (target: ≥30%)
- Notes: ...

### Scenario 5: Review File Inspection
- Status: [PASS/FAIL]
- File structure: [PASS/FAIL]
- Profile references: [PASS/FAIL]
- Content quality: [PASS/FAIL]
- Consistency: [PASS/FAIL]
- Notes: ...

## Issues Found

1. [Issue description]
   - Severity: [High/Medium/Low]
   - Component: [profile-loader/review/synthesis]
   - Reproduction: ...
   - Fix: ...

## Recommendations

1. [Recommendation 1]
2. [Recommendation 2]

## Sign-off

- Tester: [Name] [Date]
- Reviewer: [Name] [Date]
```

---

## Acceptance Criteria

Profile system is ready for production if:
- [ ] All 5 scenarios pass
- [ ] Token reduction ≥30% for reviewer context
- [ ] Cache hit rate ≥90% on round 2
- [ ] No profile loading errors
- [ ] AI Simulation Disclosure present in all review documents
- [ ] Profile references valid in all `_panel.yaml` files
- [ ] Review quality maintained (manual inspection shows persona-specific critiques)

---

## Next Steps After V4

1. **If all tests pass**: Proceed to V5 (Profile Quality Check)
2. **If tests fail**: Create bug reports, fix issues, re-run V4
3. **If token savings <30%**: Investigate profile size, caching logic
4. **If quality degraded**: Review profile content, update templates

---

## References

- Experimental protocol: `validation/experimental-protocol.md`
- Test paper selection: `validation/test-papers.md`
- Profile loader: `shared/reviewer-profile-loader.md`
- Integration points: `commands/review.md`, `commands/convene.md`
