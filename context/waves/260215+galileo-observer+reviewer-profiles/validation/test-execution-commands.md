# Test Execution Commands — Profile System V4

**Wave**: 260215+galileo-observer+reviewer-profiles
**Purpose**: Runnable commands for executing end-to-end tests
**Date**: 2026-02-15

---

## Prerequisites

Before running tests:

```bash
# 1. Ensure panel plugin is installed
claude-code plugins list | grep panel

# 2. Verify test fixtures exist
ls test/fixtures/profiles/

# 3. Check profile loader is accessible
ls shared/reviewer-profile-loader.md

# 4. Ensure at least one test paper exists
ls research/panel-review-methodology/
```

---

## Scenario 1: Paper-Level Review

### Test 1.1: Profile Loading

```bash
# Start fresh - clear any existing reviews
rm -rf research/panel-review-methodology/reviews/

# Reset paper stage to draft
# (Edit _panel.yaml: set stage: draft, round: 0)

# Run review until panel stage
panel:review --paper panel-review-methodology --until panel

# Verify profile references in state
cat research/panel-review-methodology/_panel.yaml | grep -A5 reviewers

# Expected output:
# reviewers:
#   - name: Ben Shneiderman
#     profile_ref: ben-shneiderman
#     score: null
```

### Test 1.2: Review Generation

```bash
# Continue to synthesis
panel:review --paper panel-review-methodology --until synthesis

# Inspect reviews
ls research/panel-review-methodology/reviews/REVIEW-*.md

# Check for profile-informed content
grep -i "human agency" research/panel-review-methodology/reviews/REVIEW-BEN-SHNEIDERMAN.md
grep -i "crowd" research/panel-review-methodology/reviews/REVIEW-MICHAEL-BERNSTEIN.md

# Verify voice/tone characteristics
head -20 research/panel-review-methodology/reviews/REVIEW-BEN-SHNEIDERMAN.md
```

### Test 1.3: Synthesis Attribution

```bash
# Open synthesis
cat research/panel-review-methodology/reviews/SYNTHESIS.md

# Check for expertise columns in score table
grep -A10 "Score Distribution" research/panel-review-methodology/reviews/SYNTHESIS.md

# Verify P1 item attribution includes categories
grep "\[HCI\]" research/panel-review-methodology/reviews/SYNTHESIS.md
```

### Test 1.4: Disclosure Check

```bash
# Verify AI Simulation Disclosure in all review files
grep -l "AI Simulation" research/panel-review-methodology/reviews/REVIEW-*.md | wc -l
# Expected: 5 (one per reviewer)

# Check synthesis
grep "AI Simulation" research/panel-review-methodology/reviews/SYNTHESIS.md

# Check revisions file
grep "AI Simulation" research/panel-review-methodology/revisions.md
```

---

## Scenario 2: Module-Level Panel

### Test 2.1: Profile Loading at Session Start

```bash
# Run panel review
panel:module review

# Monitor console output for cache hits
# Expected:
# Loading profiles for 7-member panel...
# ✓ Percy Liang loaded (12ms)
# ...
# Cache stats: 21 hits, 0 misses (100% hit rate)
```

### Test 2.2: Panel Assessments

```bash
# Check panel review document
cat research/REVIEW_PANEL.md | head -50

# Verify panel member expertise in assessments
grep -i "evaluation" research/REVIEW_PANEL.md
grep -i "benchmarking" research/REVIEW_PANEL.md

# Check PP items
grep "PP1" research/REVIEW_PANEL.md
```

### Test 2.3: Round Tracking

```bash
# After revisions, run round 2
panel:module review

# Verify round directory structure
ls research/panel-reviews/
# Expected: round-1/ and round-2/

# Check round 1 snapshot preserved
ls research/panel-reviews/round-1/REVIEW_PANEL.md

# Verify canonical file updated
cat research/REVIEW_PANEL.md | grep "Round 2"
```

---

## Scenario 3: Cache Efficiency

### Test 3.1: Cold Start (Cache Miss)

```bash
# Clear profile cache (restart Claude Code or clear cache dir)
# On Windows: taskkill /F /IM claude-code.exe && claude-code
# On Unix: pkill claude-code && claude-code

# Time profile loading
time panel:review --paper panel-review-methodology --until panel

# Check console output for load times
# Expected: ~12ms per profile, ~60ms total
```

### Test 3.2: Warm Start (Cache Hit)

```bash
# Run round 2 immediately (profiles should be cached)
time panel:review --paper panel-review-methodology --round 2 --until synthesis

# Check console output for cache hits
# Expected: <1ms per profile, <5ms total
```

### Test 3.3: Database Fallback

```bash
# Backup a profile
mv context/panel/reviewers/profiles/percy-liang.md /tmp/percy-liang.md.bak

# Run review (should fallback to database)
panel:review --paper panel-reviewer-profiles --until panel

# Check console output
# Expected: "Loaded Percy Liang from database (87ms)"

# Restore profile
mv /tmp/percy-liang.md.bak context/panel/reviewers/profiles/percy-liang.md
```

---

## Scenario 4: Token Savings (Instrumentation Required)

**Note**: This requires modifying `commands/review.md` to add token counting. Below is a pseudo-code approach:

### Test 4.1: Baseline (Database Mode)

```javascript
// In commands/review.md, panel_handler stage:

// Before review generation:
const baselineTokens = {
  paper: estimateTokens(paperContent),  // ~4000
  reviewerContext: estimateTokens(REVIEWER_DATABASE),  // ~3000
  other: 500
};

// Log: "Baseline tokens per reviewer: ~7500"
```

### Test 4.2: Profile Mode

```javascript
// After profile loading:
const profileTokens = {
  paper: estimateTokens(paperContent),  // ~4000
  reviewerContext: estimateTokens(profile),  // ~2000 (first), ~0 (cached)
  other: 500
};

// Log: "Profile tokens first reviewer: ~6500"
// Log: "Profile tokens remaining reviewers: ~4500 (cached)"
```

### Test 4.3: Calculate Reduction

```bash
# Manual calculation from logs:
# Baseline: 5 reviewers × 7500 = 37,500 tokens
# Profiles: 6500 + (4 × 4500) = 24,500 tokens
# Reduction: (37500 - 24500) / 37500 = 34.7%

# Expected: 30-40% reduction
```

**Alternative**: Use Claude Code's built-in token counting if available:

```bash
# Check if token stats are available in response
grep "tokens" ~/.claude/logs/panel-review-*.log
```

---

## Scenario 5: Review File Inspection

### Test 5.1: File Structure

```bash
# Verify all expected files exist
test -f research/panel-review-methodology/_panel.yaml && echo "✓ _panel.yaml"
test -d research/panel-review-methodology/reviews && echo "✓ reviews/"
test -f research/panel-review-methodology/reviews/SYNTHESIS.md && echo "✓ SYNTHESIS.md"
test -f research/panel-review-methodology/revisions.md && echo "✓ revisions.md"

# Count review files (should be 5)
ls research/panel-review-methodology/reviews/REVIEW-*.md | wc -l
```

### Test 5.2: Profile References

```bash
# Extract profile references from _panel.yaml
grep "profile_ref:" research/panel-review-methodology/_panel.yaml

# Verify profiles exist
for ref in $(grep "profile_ref:" research/panel-review-methodology/_panel.yaml | awk '{print $2}'); do
  if [ -f "context/panel/reviewers/profiles/${ref}.md" ]; then
    echo "✓ Profile exists: ${ref}"
  else
    echo "✗ Missing profile: ${ref}"
  fi
done
```

### Test 5.3: Content Quality

```bash
# Check for persona-specific language (not generic)
# Ben Shneiderman (HCAI focus)
grep -i "human\|agency\|control" research/panel-review-methodology/reviews/REVIEW-BEN-SHNEIDERMAN.md

# Michael Bernstein (crowdsourcing focus)
grep -i "crowd\|workflow\|collective" research/panel-review-methodology/reviews/REVIEW-MICHAEL-BERNSTEIN.md

# Percy Liang (evaluation focus)
grep -i "benchmark\|evaluation\|metric" research/panel-reviewer-profiles/reviews/REVIEW-PERCY-LIANG.md

# If no matches, review is too generic (FAIL)
```

### Test 5.4: Consistency Across Rounds

```bash
# Compare round 1 and round 2 reviews
diff research/panel-review-methodology/reviews/REVIEW-BEN-SHNEIDERMAN.md \
     research/panel-review-methodology/reviews/ROUND2-REVIEW-BEN-SHNEIDERMAN.md

# Extract P1 items from each round
grep "P1\." research/panel-review-methodology/reviews/SYNTHESIS.md > /tmp/round1-p1.txt
grep "P1\." research/panel-review-methodology/reviews/ROUND2-SYNTHESIS.md > /tmp/round2-p1.txt

# Visual inspection for consistency
# (No automated cosine similarity tool available in bash)
```

---

## Automated Test Runner

Create a test runner script:

```bash
#!/bin/bash
# test-runner.sh

echo "=== Profile System V4 Tests ==="
echo

# Scenario 1: Paper-Level Review
echo "Scenario 1: Paper-Level Review"
echo "-------------------------------"

echo "Test 1.1: Profile Loading"
panel:review --paper panel-review-methodology --until panel
if [ $? -eq 0 ]; then
  echo "✓ PASS: Profile loading"
else
  echo "✗ FAIL: Profile loading"
fi

echo
echo "Test 1.2: Review Generation"
panel:review --paper panel-review-methodology --until synthesis
if [ $(ls research/panel-review-methodology/reviews/REVIEW-*.md 2>/dev/null | wc -l) -eq 5 ]; then
  echo "✓ PASS: Review generation (5 files)"
else
  echo "✗ FAIL: Review generation"
fi

echo
echo "Test 1.3: Synthesis Attribution"
if grep -q "\[HCI\]" research/panel-review-methodology/reviews/SYNTHESIS.md; then
  echo "✓ PASS: Synthesis attribution"
else
  echo "✗ FAIL: Synthesis attribution"
fi

echo
echo "Test 1.4: AI Simulation Disclosure"
DISCLOSURE_COUNT=$(grep -l "AI Simulation" research/panel-review-methodology/reviews/REVIEW-*.md | wc -l)
if [ "$DISCLOSURE_COUNT" -eq 5 ]; then
  echo "✓ PASS: Disclosure in all reviews ($DISCLOSURE_COUNT/5)"
else
  echo "✗ FAIL: Disclosure missing ($DISCLOSURE_COUNT/5)"
fi

echo
echo "=== Test Summary ==="
echo "See test-verification-plan.md for detailed results"
```

Make executable:
```bash
chmod +x test-runner.sh
```

Run:
```bash
./test-runner.sh
```

---

## Troubleshooting

### Issue: Profile not found

```bash
# Check if profile exists
ls context/panel/reviewers/profiles/percy-liang.md

# If missing, check master registry
grep "percy-liang" context/panel/reviewers/_index.yaml

# Verify slug match logic
# Expected: "Percy Liang" → "percy-liang"
```

### Issue: Cache not working

```bash
# Check if caching is enabled in profile loader
grep "cache" shared/reviewer-profile-loader.md

# Verify cache directory exists
ls ~/.claude/cache/panel-profiles/ 2>/dev/null

# Clear cache and retry
rm -rf ~/.claude/cache/panel-profiles/
```

### Issue: Token counting unavailable

```bash
# Check Claude Code logs
ls ~/.claude/logs/

# Look for usage stats
grep -r "usage\|tokens" ~/.claude/logs/ | tail -20

# Alternative: Manual estimation
# Use: https://platform.openai.com/tokenizer
# Paste profile content, count tokens
```

### Issue: Reviews too generic

```bash
# Verify profile content has characteristic voice
cat context/panel/reviewers/profiles/ben-shneiderman.md

# Check if profile loader is actually called
grep "loadReviewerProfile" commands/review.md

# Ensure profile context is passed to review generation
grep "profile" commands/review.md
```

---

## Next Steps

After running all tests:

1. **Document results** in `test-execution-report.md` (use template from test-verification-plan.md)
2. **Log issues** if any tests fail
3. **Proceed to V5** (Profile Quality Check) if all tests pass
4. **Fix and re-run** if tests fail

---

## References

- Test verification plan: `validation/test-verification-plan.md`
- Experimental protocol: `validation/experimental-protocol.md`
- Profile loader: `shared/reviewer-profile-loader.md`
- Commands: `commands/review.md`, `commands/convene.md`
