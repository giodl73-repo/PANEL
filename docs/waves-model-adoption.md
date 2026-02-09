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

## See Also

- Waves reference-resolver.md: C:\src\waves\shared\reference-resolver.md
- Waves wave-index.yaml: C:\src\waves\context\waves\_config\wave-index.yaml
- Waves CLAUDE.md: C:\src\waves\CLAUDE.md (lines 35-48 for reference syntax)
