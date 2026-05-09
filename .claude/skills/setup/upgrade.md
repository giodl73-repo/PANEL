# Level 0 — Auto-Upgrade Flow (Existing Installation)

Runs when `researchDir` exists. Uses **auto-awesome** detection and upgrade.

## Step 1: Detect Version

```javascript
// @import ../shared/project-config.md
// @import ../shared/version-detector.md
// @import ../shared/migrator.md

const projectConfig = loadProjectConfig();
const researchDir = path.join(process.cwd(), projectConfig.researchPath);
const currentVersion = detectPanelVersion(researchDir);
```

## Step 2: Handle Based on Version

**If v2.0** (already latest):
```
✓ Panel is already at v2.0 (latest)

Run panel:setup <paper-name> to add a new paper.
```

**If < v2.0** (upgrade available):

Show current version and offer upgrade via AskUserQuestion:

```javascript
question: "Panel setup detected: upgrade to latest version (v2.0)?"
header: "Auto-Upgrade"
options: [
  {
    label: "Yes, upgrade to v2.0 (Recommended)",
    description: "Full upgrade: UUIDs + paper-index + numbered directories"
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

## Step 3: Execute Migration

Based on user choice:

**Full upgrade (v2.0)**:
```javascript
const result = await migrateToLatest(researchDir, currentVersion);

// Show progress for each phase
for (const phase of result.phases) {
    msg(`Phase: ${phase.version}`, 'header');
    for (const change of phase.changes) {
        msg(change, 'item');
    }
}

msg(`✓ Upgraded from ${currentVersion} to v2.0`, 'success');
```

**Partial upgrade (v1.3)**:
```javascript
// Migrate v1.0 → v1.2 → v1.3
if (currentVersion === 'v1.0') {
    await migrateV10ToV12(researchDir);
}
if (currentVersion === 'v1.0' || currentVersion === 'v1.2') {
    await migrateV12ToV13(researchDir);
}
```

**Minimal upgrade (v1.2)**:
```javascript
// Only v1.0 → v1.2
if (currentVersion === 'v1.0') {
    await migrateV10ToV12(researchDir);
}
```

## Step 4: Auto-Commit

If migration completed:
```javascript
await gitCommitIfEnabled(
    `[panel] Upgrade to ${targetVersion}\n\n${result.summary}`,
    [researchDir]
);
```

## Step 5: Show Summary

```
═══════════════════════════════════════
✓ Panel Upgrade Complete
═══════════════════════════════════════

From: v1.0 (legacy format)
To:   v2.0 (numbered directories)

Changes:
  ✓ Added UUIDs to 5 papers
  ✓ Created paper-index.yaml
  ✓ Renamed 5 directories to numbered format

Next steps:
  • Test: panel:status
  • Add paper: panel:setup <name>
  • Ship: git push
```
