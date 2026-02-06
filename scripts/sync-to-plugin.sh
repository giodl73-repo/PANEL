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

# Use robocopy on Windows (MSYS/Git Bash), rsync elsewhere
if command -v rsync &>/dev/null; then
    rsync -av --delete \
        --exclude='.git/' \
        --exclude='research/' \
        --exclude='scripts/' \
        --exclude='*.pdf' \
        --exclude='.vscode/' \
        "$SRC/" "$DEST/"
else
    # robocopy: /MIR mirrors, /XD excludes dirs, /XF excludes files
    # robocopy returns 0-7 for success, 8+ for errors
    SRC_WIN="$(cygpath -w "$SRC")"
    DEST_WIN="$(cygpath -w "$DEST")"
    MSYS_NO_PATHCONV=1 robocopy "$SRC_WIN" "$DEST_WIN" /MIR \
        /XD .git research scripts .vscode \
        /XF "*.pdf" \
        /NFL /NDL /NJH /NJS /NC /NS || RC=$?
    RC=${RC:-0}
    if [ $RC -ge 8 ]; then
        echo "ERROR: robocopy failed with exit code $RC"
        exit 1
    fi
fi

echo ""
echo "Sync complete. Plugin at: $DEST"
