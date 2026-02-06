#!/bin/bash
# Sync panel plugin to C:\src\plugins\panel
# Run from panel project root: ./scripts/sync-to-plugin.sh

set -e

SRC="$(cd "$(dirname "$0")/.." && pwd)"
DEST="/c/src/plugins/panel"

echo "Syncing panel plugin..."
echo "  From: $SRC"
echo "  To:   $DEST"

mkdir -p "$DEST"

# Sync plugin files (exclude research papers, git, scripts)
rsync -av --delete \
    --exclude='.git/' \
    --exclude='research/' \
    --exclude='scripts/' \
    --exclude='*.pdf' \
    "$SRC/" "$DEST/"

echo ""
echo "Sync complete. Plugin at: $DEST"
