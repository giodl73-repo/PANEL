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

# LaTeX build artifacts to exclude
LATEX_EXCLUDE="*.aux *.log *.out *.toc *.fls *.fdb_latexmk *.synctex.gz"

if command -v rsync &>/dev/null; then
    rsync -av --delete \
        --exclude='*.aux' \
        --exclude='*.log' \
        --exclude='*.out' \
        --exclude='*.toc' \
        --exclude='*.fls' \
        --exclude='*.fdb_latexmk' \
        --exclude='*.synctex.gz' \
        "$SRC/" "$DEST/"
else
    SRC_WIN="$(cygpath -w "$SRC")"
    DEST_WIN="$(cygpath -w "$DEST")"
    MSYS_NO_PATHCONV=1 robocopy "$SRC_WIN" "$DEST_WIN" /MIR \
        /XF $LATEX_EXCLUDE \
        /NFL /NDL /NJH /NJS /NC /NS || RC=$?
    RC=${RC:-0}
    if [ $RC -ge 8 ]; then
        echo "ERROR: robocopy failed with exit code $RC"
        exit 1
    fi
fi

echo ""
echo "Sync complete. Research at: $DEST"
echo ""
echo "Remember to update C:\\src\\research files:"
echo "  - README.md (add Panel section)"
echo "  - REVIEW_BOARD.md (add Panel to Module Registry)"
echo "  - CLAUDE.md (add panel to layout)"
