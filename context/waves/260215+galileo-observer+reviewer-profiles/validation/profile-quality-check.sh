#!/bin/bash
# profile-quality-check.sh
# Checks content quality indicators for all profiles

PROFILES_DIR="context/panel/reviewers/profiles"

echo "=== Profile Content Quality Check ==="
echo

WARNINGS=0

for profile in "$PROFILES_DIR"/*.md; do
    if [ ! -f "$profile" ]; then
        continue
    fi

    filename=$(basename "$profile")

    # Check Research Background length (150-200 words target)
    BG_WORDS=$(sed -n '/## Research Background/,/## Key Publications/p' "$profile" | wc -w)
    if [ "$BG_WORDS" -lt 100 ] || [ "$BG_WORDS" -gt 300 ]; then
        echo "⚠ $filename: Research Background ${BG_WORDS} words (target: 150-200)"
        WARNINGS=$((WARNINGS + 1))
    fi

    # Check for generic phrases (red flags)
    if grep -qi "expert in\|works at a\|has published many" "$profile"; then
        echo "⚠ $filename: Contains generic phrases"
        WARNINGS=$((WARNINGS + 1))
    fi

    # Check Key Publications count (3-5 target)
    PUBS=$(grep -c "^- \*\*" "$profile" || echo 0)
    if [ "$PUBS" -lt 3 ] || [ "$PUBS" -gt 6 ]; then
        echo "⚠ $filename: ${PUBS} publications (target: 3-5)"
        WARNINGS=$((WARNINGS + 1))
    fi

    # Check Review Criteria count (5-8 target)
    CRITERIA=$(sed -n '/## Review Criteria/,/## Characteristic Concerns/p' "$profile" | grep -c "^- \[ \]" || echo 0)
    if [ "$CRITERIA" -lt 4 ] || [ "$CRITERIA" -gt 9 ]; then
        echo "⚠ $filename: ${CRITERIA} criteria (target: 5-8)"
        WARNINGS=$((WARNINGS + 1))
    fi

    # Check for AI Simulation Disclosure
    if ! grep -q "AI Simulation Disclosure" "$profile"; then
        echo "✗ $filename: Missing AI Simulation Disclosure"
        WARNINGS=$((WARNINGS + 1))
    fi
done

echo
if [ "$WARNINGS" -eq 0 ]; then
    echo "✓ All quality checks passed"
else
    echo "⚠ $WARNINGS warnings found - review manually"
    exit 1
fi
