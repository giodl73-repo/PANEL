#!/bin/bash
# profile-coverage-report.sh
# Reports category coverage across all 10 reviewer categories

INDEX_FILE="context/panel/reviewers/_index.yaml"
PROFILES_DIR="context/panel/reviewers/profiles"

echo "=== Category Coverage Report ==="
echo

# Extract categories from index
CATEGORIES=$(grep "^  [a-z-]*:$" "$INDEX_FILE" | sed 's/://g' | xargs)

TOTAL_EXPECTED=0
TOTAL_ACTUAL=0

for category in $CATEGORIES; do
    # Count expected reviewers
    EXPECTED=$(grep -A100 "^  $category:" "$INDEX_FILE" | grep "slug:" | wc -l)
    TOTAL_EXPECTED=$((TOTAL_EXPECTED + EXPECTED))

    # Count actual profiles
    ACTUAL=0
    for slug in $(grep -A100 "^  $category:" "$INDEX_FILE" | grep "slug:" | awk '{print $2}'); do
        if [ -f "$PROFILES_DIR/${slug}.md" ]; then
            ACTUAL=$((ACTUAL + 1))
        fi
    done
    TOTAL_ACTUAL=$((TOTAL_ACTUAL + ACTUAL))

    # Status
    if [ "$ACTUAL" -eq "$EXPECTED" ]; then
        STATUS="✓"
    else
        STATUS="⚠"
    fi

    printf "%-35s %2d/%2d %s\n" "$category" "$ACTUAL" "$EXPECTED" "$STATUS"
done

echo
printf "%-35s %2d/%2d\n" "Total" "$TOTAL_ACTUAL" "$TOTAL_EXPECTED"

if [ "$TOTAL_ACTUAL" -lt "$TOTAL_EXPECTED" ]; then
    echo
    echo "Missing profiles. Run: ls context/panel/reviewers/profiles/ | wc -l"
    exit 1
fi
