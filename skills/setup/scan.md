# Batch Scan Mode (--scan / --discover)

Runs when `--scan` or `--discover` flag is provided. Auto-discovers papers with plan.md and sets them up.

## Step 1: Discover Papers

```javascript
// @import ../shared/project-config.md
// @import ../shared/batch-utils.md

const projectConfig = loadProjectConfig();
const researchDir = path.join(process.cwd(), projectConfig.researchPath);
const needSetup = discoverPapersNeedingSetup(researchDir);
```

## Step 2: Show Discovery

```javascript
msg('Paper Discovery', 'header');
msg(`Found ${needSetup.length} paper${needSetup.length === 1 ? '' : 's'} with plan.md (not yet setup):`, 'info');

for (const paper of needSetup) {
    msg(`• ${paper.directory}`, 'item');
}
```

## Step 3: Ask User

```javascript
AskUserQuestion({
    question: `Setup all ${needSetup.length} paper${needSetup.length === 1 ? '' : 's'}?`,
    header: 'Batch Setup',
    options: [
        {
            label: 'Yes, setup all (Recommended)',
            description: 'Initialize all discovered papers with UUIDs'
        },
        {
            label: 'Select specific papers',
            description: 'Choose which papers to setup'
        },
        {
            label: 'Skip',
            description: "Don't setup any papers"
        }
    ]
});
```

## Step 4: Execute Setup

For each selected paper:

1. **Extract venue from plan.md** (if specified):
   ```javascript
   const planContent = await Read(paper.planPath);
   const venueMatch = planContent.match(/Venue:\s*([^\n]+)/i);
   const venue = venueMatch ? venueMatch[1].trim() : 'TBD';
   ```

2. **Generate UUID**:
   ```javascript
   const existingPapers = await loadPaperIndex(researchDir);
   const uuid = generateUniqueUUID(existingPapers.papers || []);
   ```

3. **Create _panel.yaml**:
   ```javascript
   const slug = paper.directory.replace(/^panel-/, '');

   const panelYaml = {
       uuid,
       slug,
       title: 'Untitled', // User can update later
       venue,
       stage: 'draft',
       content_mode: 'full', // Default, will be detected on first review
       created: new Date().toISOString().split('T')[0]
   };

   writeYAML(`${paper.fullPath}/_panel.yaml`, panelYaml);
   ```

4. **Create directory structure** (if missing):
   ```bash
   mkdir -p ${paper.fullPath}/sections
   mkdir -p ${paper.fullPath}/figures
   mkdir -p ${paper.fullPath}/reviews
   ```

## Step 5: Update RESEARCH.md

Add all new papers to RESEARCH.md in batch.

## Step 6: Report

```javascript
msg('Batch Setup Complete', 'success');
msg(`Initialized ${needSetup.length} papers with UUIDs`, 'info');

msgSep();
msg('Next steps:', 'info');
msg('1. Update titles in each _panel.yaml', 'item');
msg('2. Run: panel:author --all', 'item');
```

## Step 7: Auto-Commit

```javascript
await gitCommitIfEnabled(
    `[panel] Batch setup: ${needSetup.length} papers\n\nDiscovered and initialized from plan.md files.`,
    [researchDir]
);
```
