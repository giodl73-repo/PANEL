# Version Detector

Detect the current panel model version in a project and provide upgrade paths.

## Version History

- **v1.0**: Legacy format (`panel-{name}/` directories, no UUIDs)
- **v1.2**: UUIDs + slugs added to _panel.yaml (backward compatible)
- **v1.3**: PAPER-INDEX.yaml created (transitional)
- **v2.0**: Numbered directories (`{NN}+{slug}/`) - BREAKING

## Functions

### detectPanelVersion()

Detect the current panel version in a project.

**Parameters**:
- `researchDir` (string) - Path to research directory (e.g., "C:/src/panel/research")

**Returns**: `string|null` - Version identifier or null if not set up

**Implementation**:
```javascript
const fs = require('fs');
const path = require('path');
const { readYAML } = require('./yaml-parser.md');

function detectPanelVersion(researchDir) {
    // Check if panel is set up at all
    if (!fs.existsSync(researchDir)) {
        return null; // Not set up
    }

    // Check for paper-index.yaml (v1.3+)
    const paperIndexPath = path.join(researchDir, '_config', 'paper-index.yaml');
    if (fs.existsSync(paperIndexPath)) {
        try {
            const paperIndex = readYAML(paperIndexPath);

            if (!paperIndex.papers || paperIndex.papers.length === 0) {
                return 'v1.3'; // Has index but no papers yet
            }

            // Check directory format of first paper
            const firstPaper = paperIndex.papers[0];
            if (firstPaper.directory && firstPaper.directory.match(/^\d{2}\+/)) {
                return 'v2.0'; // Numbered directories
            } else {
                return 'v1.3'; // Has paper-index but old directory format
            }
        } catch (e) {
            // Invalid paper-index, treat as v1.0
            return 'v1.0';
        }
    }

    // Check for UUIDs in _panel.yaml (v1.2)
    const papers = findPaperDirectories(researchDir);
    if (papers.length > 0) {
        const firstPaperDir = papers[0];
        const panelYamlPath = path.join(firstPaperDir, '_panel.yaml');

        if (fs.existsSync(panelYamlPath)) {
            try {
                const panelYaml = readYAML(panelYamlPath);
                if (panelYaml.uuid) {
                    return 'v1.2'; // Has UUIDs but no paper-index
                }
            } catch (e) {
                // Continue to v1.0
            }
        }
    }

    // Legacy format (v1.0/v1.1)
    return papers.length > 0 ? 'v1.0' : null;
}

function findPaperDirectories(researchDir) {
    if (!fs.existsSync(researchDir)) {
        return [];
    }

    const entries = fs.readdirSync(researchDir, { withFileTypes: true });
    return entries
        .filter(entry => entry.isDirectory())
        .filter(entry => {
            // Match panel-* directories or NN+slug directories
            return entry.name.startsWith('panel-') ||
                   entry.name.match(/^\d{2}\+/);
        })
        .map(entry => path.join(researchDir, entry.name));
}
```

### getUpgradePaths()

Get available upgrade paths from current version.

**Parameters**:
- `currentVersion` (string) - Current version (e.g., 'v1.0')

**Returns**: `array` - Available target versions

**Implementation**:
```javascript
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

### getVersionDescription()

Get human-readable description of a version.

**Parameters**:
- `version` (string) - Version identifier

**Returns**: `string` - Description

**Implementation**:
```javascript
function getVersionDescription(version) {
    const descriptions = {
        'v1.0': 'Legacy format (panel-{name}/ directories, no UUIDs)',
        'v1.2': 'UUIDs + slugs in _panel.yaml (backward compatible)',
        'v1.3': 'Paper index file (PAPER-INDEX.yaml)',
        'v2.0': 'Numbered directories ({NN}+{slug}/)'
    };

    return descriptions[version] || 'Unknown version';
}
```

### isUpgradeRecommended()

Check if an upgrade is recommended.

**Parameters**:
- `currentVersion` (string) - Current version

**Returns**: `boolean` - true if upgrade recommended

**Implementation**:
```javascript
function isUpgradeRecommended(currentVersion) {
    // Always recommend upgrading to latest (v2.0)
    return currentVersion !== 'v2.0';
}
```

## Usage

```javascript
// @import ../shared/version-detector.md

const researchDir = 'C:/src/panel/research';

// Detect version
const version = detectPanelVersion(researchDir);
if (version === null) {
    console.log('Panel not set up');
} else {
    console.log(`Current version: ${version}`);
    console.log(getVersionDescription(version));

    // Check for upgrades
    const upgrades = getUpgradePaths(version);
    if (upgrades.length > 0) {
        console.log('Available upgrades:', upgrades);
    }
}
```

## Module Exports

```javascript
module.exports = {
    detectPanelVersion,
    getUpgradePaths,
    getVersionDescription,
    isUpgradeRecommended,
    findPaperDirectories
};
```
