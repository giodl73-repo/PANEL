# Migrator

Migrate panel projects between versions with auto-awesome upgrade paths.

## Migration Functions

### migrateV10ToV12()

Migrate from v1.0 (legacy) to v1.2 (UUIDs + slugs).

**Changes**:
- Add `uuid` field to all _panel.yaml files
- Add `slug` field (derived from directory name)
- Backward compatible (no breaking changes)

**Parameters**:
- `researchDir` (string) - Path to research directory

**Returns**: `object` - Migration result with changes array

**Implementation**:
```javascript
const fs = require('fs');
const path = require('path');
const { readYAML, writeYAML } = require('./yaml-parser.md');
const { generateUniqueUUID } = require('./uuid-generator.md');
const { findPaperDirectories } = require('./version-detector.md');

async function migrateV10ToV12(researchDir) {
    const papers = findPaperDirectories(researchDir);
    const changes = [];
    const uuids = [];

    for (const paperDir of papers) {
        const panelYamlPath = path.join(paperDir, '_panel.yaml');

        if (!fs.existsSync(panelYamlPath)) {
            changes.push(`⚠ Skipped ${path.basename(paperDir)}: no _panel.yaml found`);
            continue;
        }

        const panelYaml = readYAML(panelYamlPath);

        // Generate unique UUID
        const existingPapers = uuids.map(u => ({ uuid: u }));
        const uuid = generateUniqueUUID(existingPapers);
        uuids.push(uuid);

        // Add UUID
        panelYaml.uuid = uuid;

        // Add slug (derive from directory name)
        const dirName = path.basename(paperDir);
        const slug = dirName.replace(/^panel-/, '');
        panelYaml.slug = slug;

        // Write back
        writeYAML(panelYamlPath, panelYaml);

        changes.push(`✓ ${dirName}: added UUID ${uuid}, slug ${slug}`);
    }

    return {
        version: 'v1.2',
        success: true,
        changes,
        summary: `Added UUIDs and slugs to ${papers.length} papers`
    };
}
```

### migrateV12ToV13()

Migrate from v1.2 (UUIDs) to v1.3 (paper-index.yaml).

**Changes**:
- Create `_config/` directory
- Create `_config/paper-index.yaml`
- Index all papers with sequential order
- Still uses old directory names

**Parameters**:
- `researchDir` (string) - Path to research directory
- `moduleName` (string) - Module name (optional, derived from directory)

**Returns**: `object` - Migration result

**Implementation**:
```javascript
async function migrateV12ToV13(researchDir, moduleName = null) {
    // Create _config directory
    const configDir = path.join(researchDir, '_config');
    if (!fs.existsSync(configDir)) {
        fs.mkdirSync(configDir, { recursive: true });
    }

    // Derive module name from parent directory if not provided
    if (!moduleName) {
        moduleName = path.basename(path.dirname(researchDir));
    }

    // Scan all papers
    const paperDirs = findPaperDirectories(researchDir);
    const paperIndex = {
        format_version: '4.0',
        module: moduleName,
        last_updated: new Date().toISOString(),
        active: null,
        papers: []
    };

    const changes = [];

    // Build index from _panel.yaml files
    for (let i = 0; i < paperDirs.length; i++) {
        const paperDir = paperDirs[i];
        const panelYamlPath = path.join(paperDir, '_panel.yaml');

        if (!fs.existsSync(panelYamlPath)) {
            continue;
        }

        const panelYaml = readYAML(panelYamlPath);
        const dirName = path.basename(paperDir);

        paperIndex.papers.push({
            uuid: panelYaml.uuid || generateUniqueUUID(paperIndex.papers),
            slug: panelYaml.slug || dirName.replace(/^panel-/, ''),
            title: panelYaml.title || 'Untitled',
            order: i + 1, // Assign sequential order
            directory: dirName,
            venue: panelYaml.venue || 'TBD',
            stage: panelYaml.stage || 'draft',
            status: panelYaml.writing_completed ? 'completed' : 'in-progress',
            created: panelYaml.created || new Date().toISOString().split('T')[0]
        });

        changes.push(`✓ Indexed ${dirName} as #${i + 1}`);
    }

    // Write paper-index.yaml
    const paperIndexPath = path.join(configDir, 'paper-index.yaml');
    writeYAML(paperIndexPath, paperIndex);

    changes.push(`✓ Created ${paperIndexPath}`);

    return {
        version: 'v1.3',
        success: true,
        changes,
        summary: `Created paper-index.yaml with ${paperIndex.papers.length} papers`
    };
}
```

### migrateV13ToV20()

Migrate from v1.3 (paper-index) to v2.0 (numbered directories).

**Changes**:
- Rename directories to `{NN}+{slug}` format
- Update paper-index.yaml with new directory names
- BREAKING: directory names change

**Parameters**:
- `researchDir` (string) - Path to research directory

**Returns**: `object` - Migration result with rename list

**Implementation**:
```javascript
async function migrateV13ToV20(researchDir) {
    const paperIndexPath = path.join(researchDir, '_config', 'paper-index.yaml');

    if (!fs.existsSync(paperIndexPath)) {
        throw new Error('paper-index.yaml not found. Run v1.2 → v1.3 migration first.');
    }

    const paperIndex = readYAML(paperIndexPath);
    const renames = [];
    const changes = [];

    for (const paper of paperIndex.papers) {
        const oldDir = path.join(researchDir, paper.directory);
        const newDirName = `${String(paper.order).padStart(2, '0')}+${paper.slug}`;
        const newDir = path.join(researchDir, newDirName);

        if (oldDir !== newDir && fs.existsSync(oldDir)) {
            // Rename directory
            fs.renameSync(oldDir, newDir);

            // Update paper-index
            paper.directory = newDirName;

            renames.push({
                from: path.basename(oldDir),
                to: newDirName
            });

            changes.push(`✓ Renamed ${path.basename(oldDir)} → ${newDirName}`);
        } else if (!fs.existsSync(oldDir)) {
            changes.push(`⚠ Skipped ${paper.directory}: directory not found`);
        }
    }

    // Write updated paper-index
    paperIndex.last_updated = new Date().toISOString();
    writeYAML(paperIndexPath, paperIndex);

    return {
        version: 'v2.0',
        success: true,
        changes,
        renames,
        summary: `Renamed ${renames.length} directories to numbered format`
    };
}
```

### migrateToLatest()

Auto-migrate from current version to latest (v2.0).

**Parameters**:
- `researchDir` (string) - Path to research directory
- `currentVersion` (string) - Current version
- `options` (object) - Options
  - `dryRun` (boolean) - Preview changes without applying

**Returns**: `object` - Migration result with all phases

**Implementation**:
```javascript
const { detectPanelVersion, getUpgradePaths } = require('./version-detector.md');

async function migrateToLatest(researchDir, currentVersion, options = {}) {
    const { dryRun = false } = options;
    const results = [];

    // Determine migration path
    const path = [];
    let version = currentVersion;

    while (version !== 'v2.0') {
        if (version === 'v1.0') {
            path.push({ from: 'v1.0', to: 'v1.2', fn: migrateV10ToV12 });
            version = 'v1.2';
        } else if (version === 'v1.2') {
            path.push({ from: 'v1.2', to: 'v1.3', fn: migrateV12ToV13 });
            version = 'v1.3';
        } else if (version === 'v1.3') {
            path.push({ from: 'v1.3', to: 'v2.0', fn: migrateV13ToV20 });
            version = 'v2.0';
        } else {
            throw new Error(`Unknown version: ${version}`);
        }
    }

    if (dryRun) {
        return {
            dryRun: true,
            path: path.map(p => `${p.from} → ${p.to}`),
            message: 'Dry run: no changes applied'
        };
    }

    // Execute migration path
    for (const step of path) {
        const result = await step.fn(researchDir);
        results.push(result);
    }

    return {
        success: true,
        finalVersion: 'v2.0',
        phases: results,
        summary: `Upgraded from ${currentVersion} to v2.0`
    };
}
```

## Module Exports

```javascript
module.exports = {
    migrateV10ToV12,
    migrateV12ToV13,
    migrateV13ToV20,
    migrateToLatest
};
```
