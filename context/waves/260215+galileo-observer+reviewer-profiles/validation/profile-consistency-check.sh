#!/bin/bash
# profile-consistency-check.sh
# Checks consistency across profiles and with master registry

PROFILES_DIR="context/panel/reviewers/profiles"
INDEX_FILE="context/panel/reviewers/_index.yaml"

echo "=== Profile Consistency Check ==="
echo

ISSUES=0

# Check YAML frontmatter consistency
echo "Checking YAML frontmatter..."
for profile in "$PROFILES_DIR"/*.md; do
    if [ ! -f "$profile" ]; then
        continue
    fi

    filename=$(basename "$profile" .md)

    # Extract frontmatter
    NAME=$(sed -n '/^name:/p' "$profile" | sed 's/name: //')
    CATEGORY=$(sed -n '/^category:/p' "$profile" | sed 's/category: //')

    # Cross-reference with index
    if ! grep -q "slug: $filename" "$INDEX_FILE"; then
        echo "⚠ $filename: Not found in _index.yaml"
        ISSUES=$((ISSUES + 1))
    fi

    # Check category assignment
    if [ -n "$CATEGORY" ] && ! grep -A100 "^  $CATEGORY:" "$INDEX_FILE" | grep -q "slug: $filename"; then
        echo "⚠ $filename: Category mismatch with _index.yaml"
        ISSUES=$((ISSUES + 1))
    fi
done

echo
echo "Checking disclosure footer consistency..."
DISCLOSURE_COUNT=$(grep -l "AI Simulation Disclosure" "$PROFILES_DIR"/*.md 2>/dev/null | wc -l)
TOTAL_COUNT=$(ls "$PROFILES_DIR"/*.md 2>/dev/null | wc -l)

if [ "$DISCLOSURE_COUNT" -ne "$TOTAL_COUNT" ]; then
    echo "⚠ Disclosure present in $DISCLOSURE_COUNT/$TOTAL_COUNT profiles"
    ISSUES=$((ISSUES + 1))
else
    echo "✓ Disclosure present in all profiles"
fi

echo
if [ "$ISSUES" -eq 0 ]; then
    echo "✓ All consistency checks passed"
else
    echo "⚠ $ISSUES consistency issues found"
    exit 1
fi
