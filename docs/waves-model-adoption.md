# Waves Model Adoption for Panel

**Status**: Specification
**Date**: 2026-02-08
**Purpose**: Adopt waves numbering and reference system for papers

---

## Overview

Switch panel from `panel-{name}` format to waves-style `{NN}+{slug}` format with UUID-based references and a single source of truth for paper metadata.

**Key Benefits**:
- Consistent numbering across all papers
- Flexible reference formats (number, slug, UUID, or combo)
- Single source of truth for paper metadata (PAPER-INDEX.yaml)
- Aligns with waves plugin patterns (familiar to users)

---

## Current State vs. Target State

### Current (panel v1.x)

```
research/
├── panel-review-methodology/       # No clear ordering
├── panel-reviewer-calibration/
├── panel-revision-dynamics/
├── panel-synthesis-methods/
└── RESEARCH.md                    # Manual tracking, no UUIDs
```

**Issues**:
- No ordering between papers
- Directory names are verbose (`panel-` prefix redundant in research/)
- No UUIDs (can't reference papers reliably across repos)
- Paper metadata scattered (some in _panel.yaml, some in RESEARCH.md)

### Target (panel v2.0)

```
research/
├── _config/
│   └── paper-index.yaml           # Single source of truth
├── 01+review-methodology/          # Clear ordering
├── 02+reviewer-calibration/
├── 03+revision-dynamics/
├── 04+synthesis-methods/
└── RESEARCH.md                     # Generated from paper-index.yaml
```

**Benefits**:
- Clear ordering (01, 02, 03...)
- Shorter directory names (no `panel-` prefix)
- UUID for each paper (reliable cross-repo references)
- All metadata in one place (paper-index.yaml)

---

## Paper Index Structure

### PAPER-INDEX.yaml

```yaml
format_version: "4.0"
module: panel
last_updated: "2026-02-08T00:00:00Z"
active: null

papers:
  - uuid: "a1b2c3"
    slug: review-methodology
    title: "Simulated Expert Review Methodology for Research Quality"
    order: 1
    directory: 01+review-methodology
    venue: CHI 2026
    stage: ready
    status: completed
    created: "2026-01-15"
    completed: "2026-02-01"

  - uuid: "d4e5f6"
    slug: reviewer-calibration
    title: "Calibrating AI Reviewers Against Human Expert Standards"
    order: 2
    directory: 02+reviewer-calibration
    venue: EMNLP 2026
    stage: revision
    status: in-progress
    created: "2026-01-20"

  - uuid: "g7h8i9"
    slug: revision-dynamics
    title: "Revision Dynamics in AI-Simulated Review Cycles"
    order: 3
    directory: 03+revision-dynamics
    venue: NeurIPS D&B 2026
    stage: panel
    status: in-progress
    created: "2026-01-25"
```

**Fields**:
- `uuid`: 6-character hex UUID (auto-generated, immutable)
- `slug`: URL-friendly name (lowercase-with-dashes, cannot start with number)
- `title`: Full paper title
- `order`: Numerical position (1, 2, 3..., can have gaps)
- `directory`: Physical directory name (must be `{order:02d}+{slug}`)
- `venue`: Target venue (e.g., "CHI 2026")
- `stage`: Current review stage (draft, panel, synthesis, revision, recheck, ready, submit, accepted)
- `status`: Overall status (in-progress, completed, cancelled)
- `created`: Creation date (YYYY-MM-DD)
- `completed`: Completion date (optional, YYYY-MM-DD)

---

## Reference Formats

Since there's only one entity type (papers), **no prefix is needed** (unlike waves which uses `^` for waves and `~` for pulses).

### Supported Formats

| Format | Example | Resolution |
|--------|---------|------------|
| **Number only** | `1`, `14` | Paper #1, Paper #14 by order |
| **Slug only** | `review-methodology` | Match by slug |
| **UUID only** | `a1b2c3` | Match by 6-char UUID |
| **Number+slug** | `01+review-methodology` | Validate order matches slug |
| **UUID+slug** | `a1b2c3+review-methodology` | Validate UUID matches slug |

**Slug constraints** (enables unambiguous parsing):
- Cannot start with a number (would look like order)
- Cannot be exactly 6 hex characters (would look like UUID)

### Examples

```bash
# All of these reference the same paper:
panel:review --paper 1
panel:review --paper review-methodology
panel:review --paper a1b2c3
panel:review --paper 01+review-methodology
panel:review --paper a1b2c3+review-methodology

# Different papers:
panel:status 1                    # Paper #1
panel:status 14                   # Paper #14
panel:status synthesis-methods    # By slug
panel:status g7h8i9              # By UUID
```

---

## Reference Resolution Algorithm

### Parse Reference

```javascript
/**
 * Parse a paper reference into components.
 *
 * @param {string} ref - Reference string (e.g., "1", "review-methodology", "a1b2c3+review-methodology")
 * @returns {Object} { primary, slug, format }
 * @throws {Error} If reference is invalid or ambiguous
 */
function parsePaperReference(ref) {
    // Check for + delimiter
    const plusIndex = ref.indexOf('+');
    let primary, slug;

    if (plusIndex > 0) {
        primary = ref.slice(0, plusIndex);
        slug = ref.slice(plusIndex + 1);
    } else {
        primary = ref;
        slug = null;
    }

    // Determine format of primary
    let format;
    if (/^\d+$/.test(primary)) {
        // All digits = order
        format = 'order';
    } else if (/^[a-f0-9]{6}$/i.test(primary)) {
        // Exactly 6 hex chars = UUID
        format = 'uuid';
    } else if (/^\d/.test(primary)) {
        // Starts with digit but not all digits = INVALID SLUG
        throw new Error(`Invalid reference: "${ref}". Slugs cannot start with a number.`);
    } else {
        // Everything else = slug
        format = 'slug';
        slug = primary; // For plain slug format
        primary = null;
    }

    return { primary, slug, format };
}
```

### Resolve Reference

```javascript
/**
 * Resolve a paper reference to a paper object.
 *
 * @param {string} ref - Reference string
 * @param {Array} papers - Array of paper objects from paper-index.yaml
 * @returns {Object} Matched paper object
 * @throws {Error} If paper not found or validation fails
 */
function resolvePaperReference(ref, papers) {
    const { primary, slug, format } = parsePaperReference(ref);

    let matches = [];

    if (format === 'order') {
        const order = parseInt(primary, 10);
        matches = papers.filter(p => p.order === order);
    } else if (format === 'uuid') {
        matches = papers.filter(p => p.uuid === primary);
    } else if (format === 'slug') {
        matches = papers.filter(p => p.slug === slug);
    }

    if (matches.length === 0) {
        throw new Error(`Paper not found: ${ref}`);
    }

    if (matches.length > 1) {
        throw new Error(`Ambiguous reference: ${ref} matches multiple papers`);
    }

    const paper = matches[0];

    // Validate slug if provided
    if (slug && paper.slug !== slug) {
        throw new Error(`Slug mismatch: ${ref} (expected ${paper.slug}, got ${slug})`);
    }

    return paper;
}
```

---

## Migration Path

### Phase 1: Add UUID Support (v1.2 - backward compatible)

1. **Add `uuid` field to _panel.yaml**:
   ```yaml
   uuid: a1b2c3
   slug: review-methodology
   title: "Paper Title"
   venue: CHI 2026
   # ... rest of existing fields
   ```

2. **Generate UUIDs for existing papers**:
   - Use same algorithm as waves: 6-char hex UUID
   - Update all existing _panel.yaml files
   - Commit: "[panel] Add UUIDs to existing papers"

3. **Add `slug` field to _panel.yaml**:
   - Derive from directory name: `panel-review-methodology` → `review-methodology`
   - Update all _panel.yaml files

4. **Update reference resolution**:
   - Create `shared/paper-resolver.md` (based on waves reference-resolver.md)
   - Update all commands to accept UUID/slug references
   - Keep backward compatibility with `panel-{name}` format

### Phase 2: Create PAPER-INDEX.yaml (v1.3 - transitional)

1. **Generate paper-index.yaml from existing papers**:
   ```bash
   panel:migrate --generate-index
   ```

2. **Structure**:
   ```yaml
   format_version: "4.0"
   module: panel
   papers:
     - uuid: a1b2c3
       slug: review-methodology
       order: 1
       directory: panel-review-methodology  # OLD format still
       # ... metadata
   ```

3. **Update commands to read from paper-index.yaml**:
   - Primary source: paper-index.yaml
   - Fallback: scan directories + _panel.yaml files
   - This ensures backward compatibility

### Phase 3: Renumber Directories (v2.0 - BREAKING)

1. **Rename directories**:
   ```bash
   # Before
   panel-review-methodology/
   panel-reviewer-calibration/

   # After
   01+review-methodology/
   02+reviewer-calibration/
   ```

2. **Update paper-index.yaml**:
   ```yaml
   papers:
     - uuid: a1b2c3
       slug: review-methodology
       order: 1
       directory: 01+review-methodology  # NEW format
   ```

3. **Migration command**:
   ```bash
   panel:migrate --renumber
   ```

4. **Update all references in**:
   - Git history (commit messages)
   - README.md
   - RESEARCH.md
   - CLAUDE.md
   - Any cross-references between papers

---

## UUID Generation

### Algorithm (from waves)

```javascript
/**
 * Generate a 6-character hex UUID for a paper.
 * Uses Node's crypto module for randomness.
 *
 * @returns {string} 6-character hex UUID (e.g., "a1b2c3")
 */
function generatePaperUUID() {
    const crypto = require('crypto');
    const bytes = crypto.randomBytes(3); // 3 bytes = 6 hex chars
    return bytes.toString('hex');
}
```

### Collision Handling

- 6 hex chars = 16,777,216 possible values
- For <1000 papers, collision probability is negligible
- If collision detected: regenerate UUID
- Store all UUIDs in paper-index.yaml to detect collisions

---

## Command Updates

### Commands That Accept Paper References

All of these should accept any reference format:

```bash
# Before (v1.x)
panel:review --paper panel-review-methodology
panel:status --paper panel-review-methodology
panel:show --paper panel-review-methodology

# After (v2.0) - all of these work:
panel:review --paper 1
panel:review --paper review-methodology
panel:review --paper a1b2c3
panel:review --paper 01+review-methodology

panel:status 1                    # Positional arg
panel:show review-methodology     # Positional arg
```

### Auto-Detection from CWD

When in a paper directory, auto-detect paper:

```bash
# Before (v1.x)
cd research/panel-review-methodology
panel:review

# After (v2.0)
cd research/01+review-methodology
panel:review                      # Auto-detects from directory name
```

---

## Shared Utility: paper-resolver.md

Create `shared/paper-resolver.md` based on waves `reference-resolver.md`:

```markdown
# Paper Resolver

Shared logic for resolving paper references.

## Functions

- `parsePaperReference(ref)` — Parse reference string
- `resolvePaperReference(ref, papers)` — Resolve to paper object
- `loadPaperIndex(moduleDir)` — Load paper-index.yaml
- `findPaperByDirectory(dir, papers)` — Find paper by directory name
- `validatePaperReference(ref, paper)` — Validate slug/UUID matches

## Usage

\`\`\`javascript
// @import ../shared/paper-resolver.md

const papers = loadPaperIndex('research');
const paper = resolvePaperReference('14', papers);
console.log(paper.title);
\`\`\`
```

---

## RESEARCH.md Generation

RESEARCH.md becomes **generated** from paper-index.yaml:

```markdown
# Panel Research Papers

**Module**: panel
**Last Updated**: 2026-02-08

## Papers (5)

### 01 — Review Methodology
**Title**: Simulated Expert Review Methodology for Research Quality
**Venue**: CHI 2026
**Stage**: ready
**Status**: completed
**UUID**: a1b2c3

[View Paper](01+review-methodology/) • [PDF](docs/01+review-methodology.pdf)

---

### 02 — Reviewer Calibration
**Title**: Calibrating AI Reviewers Against Human Expert Standards
**Venue**: EMNLP 2026
**Stage**: revision
**Status**: in-progress
**UUID**: d4e5f6

[View Paper](02+reviewer-calibration/)

---

## Dependency Graph

```
01+review-methodology (foundation)
  ├── 02+reviewer-calibration (extends calibration)
  └── 03+revision-dynamics (extends revision process)

04+synthesis-methods (independent)
05+portfolio-assessment (requires 01-04)
```
```

**Generation command**:
```bash
panel:generate-research-md
```

---

## Migration Checklist

### Phase 1: UUID Support (v1.2)

- [ ] Add `generatePaperUUID()` to shared/uuid-generator.md
- [ ] Add `uuid` field to _panel.yaml schema
- [ ] Add `slug` field to _panel.yaml schema
- [ ] Generate UUIDs for all existing papers
- [ ] Update all _panel.yaml files
- [ ] Test: verify all papers have UUIDs

### Phase 2: Paper Index (v1.3)

- [ ] Create paper-index.yaml schema
- [ ] Create shared/paper-resolver.md
- [ ] Generate paper-index.yaml from existing papers
- [ ] Update all commands to use paper-resolver
- [ ] Test: verify all reference formats work
- [ ] Add migration command: panel:migrate --generate-index

### Phase 3: Renumber (v2.0)

- [ ] Create migration command: panel:migrate --renumber
- [ ] Rename all paper directories (panel-{name} → {NN}+{slug})
- [ ] Update paper-index.yaml with new directories
- [ ] Update RESEARCH.md generation
- [ ] Update CLAUDE.md with new structure
- [ ] Update README.md
- [ ] Test: verify all commands work with new structure
- [ ] Update documentation
- [ ] Ship v2.0

---

## Benefits Summary

### For Users

- **Shorter references**: `14` instead of `panel-hierarchical-review-architecture`
- **Flexible formats**: Use number, slug, or UUID depending on context
- **Clear ordering**: Papers have explicit order (01, 02, 03...)
- **Stable references**: UUIDs work across repos and time

### For Development

- **Single source of truth**: All paper metadata in paper-index.yaml
- **Consistent patterns**: Aligns with waves plugin (familiar code)
- **Easier cross-repo references**: UUIDs work in commit messages, issues, docs
- **Generated documentation**: RESEARCH.md auto-generated from index

### For Cross-Plugin Integration

- **Nexus events**: Papers can be referenced by UUID in events
- **Waves tracking**: Link wave pulses to specific papers by UUID
- **Probe testing**: Reference papers consistently in test fixtures

---

## Open Questions

1. **Order gaps**: Allow gaps in ordering (1, 2, 5, 7...) or require continuous (1, 2, 3, 4...)?
   - **Recommendation**: Allow gaps (like waves) for flexibility

2. **Reordering**: How to reorder papers?
   - **Recommendation**: panel:reorder command that updates order field + renames directories

3. **Multiple modules**: Support multiple paper modules per repo?
   - **Recommendation**: Yes, each module has its own paper-index.yaml

4. **Active paper**: Track "active" paper like waves tracks active wave?
   - **Recommendation**: Yes, useful for commands that default to current paper

---

## Setup Auto-Upgrade

`panel:setup` should detect existing installations and offer upgrades.

### Version Detection

```javascript
/**
 * Detect the current panel model version in a project.
 *
 * @param {string} projectDir - Project root directory
 * @returns {string} Version identifier or null if not set up
 */
function detectPanelVersion(projectDir) {
    const researchDir = `${projectDir}/research`;

    // Check if panel is set up at all
    if (!fs.existsSync(researchDir)) {
        return null; // Not set up
    }

    // Check for paper-index.yaml (v1.3+)
    const paperIndexPath = `${researchDir}/_config/paper-index.yaml`;
    if (fs.existsSync(paperIndexPath)) {
        const paperIndex = readYAML(paperIndexPath);

        // Check directory format
        const firstPaper = paperIndex.papers[0];
        if (firstPaper.directory.match(/^\d{2}\+/)) {
            return 'v2.0'; // Numbered directories
        } else {
            return 'v1.3'; // Has paper-index but old directory format
        }
    }

    // Check for UUIDs in _panel.yaml (v1.2)
    const papers = findPaperDirectories(researchDir);
    if (papers.length > 0) {
        const firstPanelYaml = readYAML(`${papers[0]}/_panel.yaml`);
        if (firstPanelYaml.uuid) {
            return 'v1.2'; // Has UUIDs but no paper-index
        }
    }

    // Legacy format (v1.0/v1.1)
    return 'v1.0';
}
```

### Upgrade Paths

```javascript
/**
 * Get available upgrade paths from current version.
 *
 * @param {string} currentVersion - Current version (e.g., 'v1.0')
 * @returns {Array} Available upgrade paths
 */
function getUpgradePaths(currentVersion) {
    const paths = {
        'v1.0': ['v1.2', 'v1.3', 'v2.0'],
        'v1.2': ['v1.3', 'v2.0'],
        'v1.3': ['v2.0'],
        'v2.0': [] // Already latest
    };

    return paths[currentVersion] || [];
}
```

### Setup Behavior with Upgrade Detection

```markdown
## panel:setup Upgrade Flow

When `panel:setup` is run in an existing project:

1. **Detect current version**:
   ```
   Detected panel v1.0 (legacy format)
   Latest: v2.0 (numbered directories with UUIDs)
   ```

2. **Show available upgrades**:
   ```
   Available upgrades:
     1. v1.2 — Add UUIDs + slugs (backward compatible)
     2. v1.3 — Add paper-index.yaml (transitional)
     3. v2.0 — Renumber directories (BREAKING)
   ```

3. **Ask user via AskUserQuestion**:
   ```javascript
   question: "Upgrade panel to latest version (v2.0)?"
   header: "Panel Upgrade"
   options: [
     {
       label: "Yes, upgrade to v2.0 (Recommended)",
       description: "Full upgrade: UUIDs + paper-index + renumbered directories"
     },
     {
       label: "Partial upgrade to v1.3",
       description: "Add UUIDs and paper-index, keep directory names"
     },
     {
       label: "Minimal upgrade to v1.2",
       description: "Only add UUIDs and slugs to _panel.yaml"
     },
     {
       label: "Skip upgrade",
       description: "Continue with current version"
     }
   ]
   ```

4. **Execute upgrade**:
   - Run appropriate migration steps
   - Commit changes with `[panel] Upgrade to v{X.Y}`
   - Show summary of what changed

5. **Handle already-latest**:
   ```
   ✓ Panel is already at v2.0 (latest)

   Run panel:setup <paper-name> to add a new paper.
   ```
```

### Migration Commands

Create dedicated migration commands:

```bash
# Detect current version
panel:migrate --detect

# Upgrade to specific version
panel:migrate --to v1.2
panel:migrate --to v1.3
panel:migrate --to v2.0

# Upgrade to latest (auto-detect path)
panel:migrate --latest

# Dry run (show what would change)
panel:migrate --to v2.0 --dry-run
```

### Migration Steps by Version

#### v1.0 → v1.2: Add UUIDs

```javascript
async function migrateV10ToV12(researchDir) {
    const papers = findPaperDirectories(researchDir);

    for (const paperDir of papers) {
        const panelYaml = readYAML(`${paperDir}/_panel.yaml`);

        // Add UUID
        panelYaml.uuid = generatePaperUUID();

        // Add slug (derive from directory name)
        const dirName = path.basename(paperDir);
        panelYaml.slug = dirName.replace(/^panel-/, '');

        // Write back
        writeYAML(`${paperDir}/_panel.yaml`, panelYaml);
    }

    return {
        version: 'v1.2',
        changes: [
            `Added UUIDs to ${papers.length} papers`,
            `Added slugs to ${papers.length} papers`
        ]
    };
}
```

#### v1.2 → v1.3: Create paper-index.yaml

```javascript
async function migrateV12ToV13(researchDir) {
    // Create _config directory
    const configDir = `${researchDir}/_config`;
    fs.mkdirSync(configDir, { recursive: true });

    // Scan all papers
    const papers = findPaperDirectories(researchDir);
    const paperIndex = {
        format_version: '4.0',
        module: path.basename(path.dirname(researchDir)),
        last_updated: new Date().toISOString(),
        active: null,
        papers: []
    };

    // Build index from _panel.yaml files
    for (let i = 0; i < papers.length; i++) {
        const paperDir = papers[i];
        const panelYaml = readYAML(`${paperDir}/_panel.yaml`);

        paperIndex.papers.push({
            uuid: panelYaml.uuid,
            slug: panelYaml.slug,
            title: panelYaml.title || 'Untitled',
            order: i + 1, // Assign sequential order
            directory: path.basename(paperDir),
            venue: panelYaml.venue || 'TBD',
            stage: panelYaml.stage || 'draft',
            status: panelYaml.writing_completed ? 'completed' : 'in-progress',
            created: panelYaml.created || new Date().toISOString().split('T')[0]
        });
    }

    // Write paper-index.yaml
    writeYAML(`${configDir}/paper-index.yaml`, paperIndex);

    return {
        version: 'v1.3',
        changes: [
            'Created _config/paper-index.yaml',
            `Indexed ${papers.length} papers`,
            'Papers assigned sequential order (1, 2, 3...)'
        ]
    };
}
```

#### v1.3 → v2.0: Renumber Directories

```javascript
async function migrateV13ToV20(researchDir) {
    const paperIndexPath = `${researchDir}/_config/paper-index.yaml`;
    const paperIndex = readYAML(paperIndexPath);

    const renames = [];

    for (const paper of paperIndex.papers) {
        const oldDir = `${researchDir}/${paper.directory}`;
        const newDir = `${researchDir}/${String(paper.order).padStart(2, '0')}+${paper.slug}`;

        if (oldDir !== newDir) {
            // Rename directory
            fs.renameSync(oldDir, newDir);

            // Update paper-index
            paper.directory = path.basename(newDir);

            renames.push({
                from: path.basename(oldDir),
                to: path.basename(newDir)
            });
        }
    }

    // Write updated paper-index
    writeYAML(paperIndexPath, paperIndex);

    return {
        version: 'v2.0',
        changes: [
            `Renamed ${renames.length} directories to numbered format`,
            'Updated paper-index.yaml with new directory names'
        ],
        renames
    };
}
```

### Setup Integration

Update `commands/setup.md` to include version detection:

```markdown
## Execution Flow

1. **Detect existing setup**:
   - Check if research/ exists
   - If yes: detect version via detectPanelVersion()
   - If no: proceed with fresh setup

2. **If version detected**:
   - Show current version and latest version
   - Offer upgrade via AskUserQuestion
   - If accepted: run migration steps
   - If declined: proceed with current version

3. **If fresh setup**:
   - Use latest model (v2.0) by default
   - Create research/ with _config/paper-index.yaml
   - Initialize with v2.0 structure
```

### Example Upgrade Session

```bash
$ panel:setup

📄 Panel Setup
═══════════════════════════════════════

✓ Detected existing panel installation
  Current: v1.0 (legacy format)
  Latest:  v2.0 (numbered directories with UUIDs)

Available upgrades:
  • v1.2 — Add UUIDs + slugs (backward compatible)
  • v1.3 — Add paper-index.yaml (transitional)
  • v2.0 — Renumber directories (BREAKING)

Upgrade panel to latest version (v2.0)?
  [1] Yes, upgrade to v2.0 (Recommended)
  [2] Partial upgrade to v1.3
  [3] Minimal upgrade to v1.2
  [4] Skip upgrade

> 1

═══════════════════════════════════════
Upgrading panel: v1.0 → v2.0
═══════════════════════════════════════

Phase 1: v1.0 → v1.2
  ✓ Added UUIDs to 5 papers
  ✓ Added slugs to 5 papers

Phase 2: v1.2 → v1.3
  ✓ Created _config/paper-index.yaml
  ✓ Indexed 5 papers
  ✓ Assigned sequential order

Phase 3: v1.3 → v2.0
  ✓ Renamed 5 directories:
    • panel-review-methodology → 01+review-methodology
    • panel-reviewer-calibration → 02+reviewer-calibration
    • panel-revision-dynamics → 03+revision-dynamics
    • panel-synthesis-methods → 04+synthesis-methods
    • panel-portfolio-assessment → 05+portfolio-assessment
  ✓ Updated paper-index.yaml

═══════════════════════════════════════
✓ Upgrade complete: panel v2.0
═══════════════════════════════════════

Changes committed:
  [panel] Upgrade to v2.0

Next steps:
  • Test: panel:status (verify all papers recognized)
  • Update: any scripts/docs referencing old names
  • Ship: git push to sync changes
```

---

## See Also

- Waves reference-resolver.md: waves\shared\reference-resolver.md
- Waves wave-index.yaml: waves\context\waves\_config\wave-index.yaml
- Waves CLAUDE.md: waves\CLAUDE.md (lines 35-48 for reference syntax)
