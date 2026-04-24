#!/bin/bash
# run-all-validation.sh
# Master validation runner for profile quality check V5

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║         Profile Quality Validation Suite V5                  ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo

# Change to panel root directory
cd "$(dirname "$0")/../../../.." || exit 1

# Track results
STRUCTURE_PASS=0
COVERAGE_PASS=0
QUALITY_PASS=0
CONSISTENCY_PASS=0

# Test 1: Structure Check
echo "┌─ Test 1: Profile Structure ─────────────────────────────────┐"
if bash context/waves/260215+galileo-observer+reviewer-profiles/validation/profile-structure-check.sh; then
    STRUCTURE_PASS=1
    echo "└─ PASS ──────────────────────────────────────────────────────┘"
else
    echo "└─ FAIL ──────────────────────────────────────────────────────┘"
fi
echo

# Test 2: Category Coverage
echo "┌─ Test 2: Category Coverage ─────────────────────────────────┐"
if bash context/waves/260215+galileo-observer+reviewer-profiles/validation/profile-coverage-report.sh; then
    COVERAGE_PASS=1
    echo "└─ PASS ──────────────────────────────────────────────────────┘"
else
    echo "└─ FAIL ──────────────────────────────────────────────────────┘"
fi
echo

# Test 3: Content Quality
echo "┌─ Test 3: Content Quality ───────────────────────────────────┐"
if bash context/waves/260215+galileo-observer+reviewer-profiles/validation/profile-quality-check.sh; then
    QUALITY_PASS=1
    echo "└─ PASS ──────────────────────────────────────────────────────┘"
else
    echo "└─ FAIL ──────────────────────────────────────────────────────┘"
fi
echo

# Test 4: Consistency
echo "┌─ Test 4: Cross-Profile Consistency ─────────────────────────┐"
if bash context/waves/260215+galileo-observer+reviewer-profiles/validation/profile-consistency-check.sh; then
    CONSISTENCY_PASS=1
    echo "└─ PASS ──────────────────────────────────────────────────────┘"
else
    echo "└─ FAIL ──────────────────────────────────────────────────────┘"
fi
echo

# Summary
TOTAL_PASS=$((STRUCTURE_PASS + COVERAGE_PASS + QUALITY_PASS + CONSISTENCY_PASS))

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                    Validation Summary                        ║"
echo "╠═══════════════════════════════════════════════════════════════╣"
printf "║  Structure:      %-44s ║\n" "$([ $STRUCTURE_PASS -eq 1 ] && echo '✓ PASS' || echo '✗ FAIL')"
printf "║  Coverage:       %-44s ║\n" "$([ $COVERAGE_PASS -eq 1 ] && echo '✓ PASS' || echo '✗ FAIL')"
printf "║  Quality:        %-44s ║\n" "$([ $QUALITY_PASS -eq 1 ] && echo '✓ PASS' || echo '✗ FAIL')"
printf "║  Consistency:    %-44s ║\n" "$([ $CONSISTENCY_PASS -eq 1 ] && echo '✓ PASS' || echo '✗ FAIL')"
echo "╠═══════════════════════════════════════════════════════════════╣"
printf "║  Overall:        %-44s ║\n" "$TOTAL_PASS/4 tests passed"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo

# Exit with appropriate code
if [ "$TOTAL_PASS" -eq 4 ]; then
    echo "✓ All validation checks passed - profiles ready for rollout"
    exit 0
else
    echo "✗ Some validation checks failed - review and fix issues"
    exit 1
fi
