#!/bin/bash
# profile-structure-check.sh
# Validates that all reviewer profiles have required sections and structure

PROFILES_DIR="context/panel/reviewers/profiles"
REQUIRED_SECTIONS=(
    "Research Background"
    "Key Publications"
    "Evaluation Lens"
    "Review Criteria"
    "Characteristic Concerns"
    "Voice & Tone"
    "AI Simulation"
)

echo "=== Profile Structure Validation ==="
echo

TOTAL=0
PASS=0
FAIL=0

for profile in "$PROFILES_DIR"/*.md; do
    if [ ! -f "$profile" ]; then
        continue
    fi

    TOTAL=$((TOTAL + 1))
    filename=$(basename "$profile")

    # Check YAML frontmatter
    if ! grep -q "^---$" "$profile"; then
        echo "✗ $filename: Missing YAML frontmatter"
        FAIL=$((FAIL + 1))
        continue
    fi

    # Check required sections
    ALL_PRESENT=true
    for section in "${REQUIRED_SECTIONS[@]}"; do
        if ! grep -q "## $section" "$profile"; then
            echo "✗ $filename: Missing section: $section"
            ALL_PRESENT=false
        fi
    done

    # Check size (1.8-2.2KB target)
    SIZE=$(wc -c < "$profile")
    if [ "$SIZE" -lt 1800 ] || [ "$SIZE" -gt 2500 ]; then
        echo "⚠ $filename: Size ${SIZE}B outside target range (1800-2500B)"
    fi

    if [ "$ALL_PRESENT" = true ]; then
        echo "✓ $filename"
        PASS=$((PASS + 1))
    else
        FAIL=$((FAIL + 1))
    fi
done

echo
echo "=== Summary ==="
echo "Total: $TOTAL"
echo "Pass:  $PASS"
echo "Fail:  $FAIL"

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi
