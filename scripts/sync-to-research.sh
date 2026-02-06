#!/bin/bash
# Sync panel research papers to C:\src\research\panel
# Run from panel project root: ./scripts/sync-to-research.sh

set -e

SRC="$(cd "$(dirname "$0")/.." && pwd)/research"
DEST="/c/src/research/panel"

echo "Syncing panel research to monorepo..."
echo "  From: $SRC"
echo "  To:   $DEST"

mkdir -p "$DEST"

# Sync research directory
rsync -av --delete \
    --exclude='*.aux' \
    --exclude='*.log' \
    --exclude='*.out' \
    --exclude='*.toc' \
    --exclude='*.fls' \
    --exclude='*.fdb_latexmk' \
    --exclude='*.synctex.gz' \
    "$SRC/" "$DEST/"

echo ""
echo "Sync complete. Research at: $DEST"
echo ""
echo "Remember to update C:\\src\\research files:"
echo "  - README.md (add Panel section)"
echo "  - REVIEW_BOARD.md (add Panel to Module Registry)"
echo "  - CLAUDE.md (add panel to layout)"
