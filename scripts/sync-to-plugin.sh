#!/bin/bash
#
# Sync plugin files from panel repo to plugins monorepo
#
# Usage:
#   ./scripts/sync-to-plugin.sh              # Normal sync (local only)
#   ./scripts/sync-to-plugin.sh --push       # Sync and push to remote
#   ./scripts/sync-to-plugin.sh --dry-run    # Preview what would happen
#   ./scripts/sync-to-plugin.sh --message "Custom commit message"
#

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$(dirname "$SCRIPT_DIR")"
PLUGINS_REPO="https://github.com/giodl_microsoft/plugins.git"
PLUGINS_DIR="${SOURCE_DIR}/../plugins"
PLUGIN_DIR="${PLUGINS_DIR}/panel"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Parse arguments
PUSH_CHANGES=false
DRY_RUN=false
CUSTOM_MESSAGE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --push)
            PUSH_CHANGES=true
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --message|-m)
            CUSTOM_MESSAGE="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--push] [--dry-run] [--message \"msg\"]"
            exit 1
            ;;
    esac
done

echo ""
echo -e "${BLUE}=== Panel Plugin Sync ===${NC}"
echo "Source: $SOURCE_DIR"
echo "Target: $PLUGIN_DIR"
echo ""

if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}DRY RUN MODE - No changes will be made${NC}"
    echo ""
fi

# Clone or update plugins monorepo
if [ -d "$PLUGINS_DIR/.git" ]; then
    echo -e "${GREEN}Found existing plugins repo${NC}"
    if [ "$DRY_RUN" = false ]; then
        cd "$PLUGINS_DIR"
        git fetch origin 2>/dev/null || true
        git checkout main 2>/dev/null || git checkout master 2>/dev/null || git checkout -b main
        git pull origin main 2>/dev/null || git pull origin master 2>/dev/null || true
    fi
else
    echo -e "${YELLOW}Cloning plugins repo...${NC}"
    if [ "$DRY_RUN" = false ]; then
        git clone "$PLUGINS_REPO" "$PLUGINS_DIR" 2>/dev/null || {
            echo -e "${YELLOW}Repo doesn't exist yet, creating new repo...${NC}"
            mkdir -p "$PLUGINS_DIR"
            cd "$PLUGINS_DIR"
            git init
            git checkout -b main
            git remote add origin "$PLUGINS_REPO"
        }
    else
        echo "  Would clone: $PLUGINS_REPO"
    fi
fi

# Ensure panel directory exists
if [ "$DRY_RUN" = false ]; then
    mkdir -p "$PLUGIN_DIR"
fi

# Files to sync
echo ""
echo "Files to sync:"
echo "  - .claude-plugin/"
echo "  - skills/"
echo "  - shared/"
echo "  - templates/"
echo "  - config/"
echo "  - docs/"
echo "  - CLAUDE.md"
echo "  - README.md"

if [ "$DRY_RUN" = true ]; then
    echo ""
    echo -e "${YELLOW}DRY RUN - Would sync the above files${NC}"
    echo ""
    exit 0
fi

# Clean existing plugin files (preserve .git)
echo ""
echo "Cleaning existing panel/ files..."
if [ -d "$PLUGIN_DIR" ]; then
    find "$PLUGIN_DIR" -mindepth 1 -maxdepth 1 -exec rm -rf {} +
fi

# Copy plugin files (excluding research/, scripts/, .git/, .vscode/, *.pdf)
echo "Copying plugin files..."
cd "$SOURCE_DIR"

# .claude-plugin/
if [ -d ".claude-plugin" ]; then
    cp -r .claude-plugin "$PLUGIN_DIR/"
    echo "  ✓ .claude-plugin/"
fi

# skills/
if [ -d "skills" ]; then
    cp -r skills "$PLUGIN_DIR/"
    echo "  ✓ skills/"
fi

# shared/
if [ -d "shared" ]; then
    cp -r shared "$PLUGIN_DIR/"
    echo "  ✓ shared/"
fi

# templates/
if [ -d "templates" ]; then
    cp -r templates "$PLUGIN_DIR/"
    echo "  ✓ templates/"
fi

# config/
if [ -d "config" ]; then
    cp -r config "$PLUGIN_DIR/"
    echo "  ✓ config/"
fi

# docs/
if [ -d "docs" ]; then
    mkdir -p "$PLUGIN_DIR/docs"
    # Copy markdown docs only (no PDFs)
    cp docs/*.md "$PLUGIN_DIR/docs/" 2>/dev/null || true
    MD_COUNT=$(ls "$PLUGIN_DIR/docs/"*.md 2>/dev/null | wc -l)
    echo "  ✓ docs/ ($MD_COUNT docs)"
fi

# CLAUDE.md
if [ -f "CLAUDE.md" ]; then
    cp CLAUDE.md "$PLUGIN_DIR/"
    echo "  ✓ CLAUDE.md"
fi

# README.md
if [ -f "README.md" ]; then
    cp README.md "$PLUGIN_DIR/"
    echo "  ✓ README.md"
fi

# Show what changed (from monorepo root)
cd "$PLUGINS_DIR"
echo ""
echo "Changes:"
git status --short

# Build commit message
SOURCE_COMMIT="$(cd "$SOURCE_DIR" && git rev-parse --short HEAD)"
SYNC_DATE="$(date -u +"%Y-%m-%d %H:%M:%S UTC")"

if [ -n "$CUSTOM_MESSAGE" ]; then
    COMMIT_MSG="[panel] $CUSTOM_MESSAGE

Source commit: $SOURCE_COMMIT
Synced: $SYNC_DATE"
else
    COMMIT_MSG="[panel] Sync from panel repo

Source commit: $SOURCE_COMMIT
Synced: $SYNC_DATE"
fi

# Commit changes (from monorepo root)
echo ""
git add -A
if git diff --cached --quiet; then
    echo -e "${YELLOW}No changes to commit - already in sync${NC}"
else
    git commit -m "$COMMIT_MSG"
    echo -e "${GREEN}✓ Changes committed${NC}"

    if [ "$PUSH_CHANGES" = true ]; then
        echo ""
        echo "Pushing to remote..."
        git push -u origin main 2>/dev/null || git push -u origin master 2>/dev/null || {
            echo -e "${RED}Push failed. You may need to set up the remote:${NC}"
            echo "  cd $PLUGINS_DIR"
            echo "  git remote add origin $PLUGINS_REPO"
            echo "  git push -u origin main"
            exit 1
        }
        echo -e "${GREEN}✓ Pushed to remote${NC}"
    else
        echo ""
        echo -e "${YELLOW}Committed locally. Run with --push to push to remote.${NC}"
    fi
fi

echo ""
echo -e "${GREEN}=== Sync complete ===${NC}"
echo "Plugin directory: $PLUGIN_DIR"
echo ""
