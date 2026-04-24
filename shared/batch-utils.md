# Batch Utilities

Discover and filter papers for batch operations (authoring, reviewing, setup).

## Discovery Functions

### discoverPapersWithPlan()

Find all directories with plan.md files (whether setup or not).

**Parameters**:
- `researchDir` (string) - Path to research directory

**Returns**: `array` - Array of objects with paper info

**Implementation**:
```javascript
const fs = require('fs');
const path = require('path');
const { readYAML } = require('./yaml-parser.md');

function discoverPapersWithPlan(researchDir) {
    if (!fs.existsSync(researchDir)) {
        return [];
    }

    const entries = fs.readdirSync(researchDir, { withFileTypes: true });
    const results = [];

    for (const entry of entries) {
        if (!entry.isDirectory()) continue;

        // Skip system directories
        if (entry.name.startsWith('_') || entry.name === 'docs') {
            continue;
        }

        const paperDir = path.join(researchDir, entry.name);
        const planPath = path.join(paperDir, 'plan.md');
        const panelYamlPath = path.join(paperDir, '_panel.yaml');

        if (fs.existsSync(planPath)) {
            let panelYaml = null;
            let isSetup = false;

            if (fs.existsSync(panelYamlPath)) {
                try {
                    panelYaml = readYAML(panelYamlPath);
                    isSetup = true;
                } catch (e) {
                    // Invalid yaml, treat as not setup
                }
            }

            results.push({
                directory: entry.name,
                fullPath: paperDir,
                planPath,
                isSetup,
                panelYaml
            });
        }
    }

    return results;
}
```

### discoverPapersNeedingSetup()

Find directories with plan.md but no _panel.yaml (need setup).

**Parameters**:
- `researchDir` (string) - Path to research directory

**Returns**: `array` - Array of paper directories needing setup

**Implementation**:
```javascript
function discoverPapersNeedingSetup(researchDir) {
    const withPlan = discoverPapersWithPlan(researchDir);
    return withPlan.filter(p => !p.isSetup);
}
```

### discoverEligibleForAuthoring()

Find papers ready for authoring (have plan.md, are setup, not yet written).

**Parameters**:
- `researchDir` (string) - Path to research directory

**Returns**: `array` - Array of papers eligible for authoring

**Implementation**:
```javascript
function discoverEligibleForAuthoring(researchDir) {
    const withPlan = discoverPapersWithPlan(researchDir);

    return withPlan.filter(p => {
        if (!p.isSetup) return false;
        if (!p.panelYaml) return false;

        // Not yet written
        return !p.panelYaml.writing_completed;
    }).map(p => ({
        ...p,
        uuid: p.panelYaml.uuid,
        slug: p.panelYaml.slug,
        order: p.panelYaml.order,
        title: p.panelYaml.title,
        venue: p.panelYaml.venue
    }));
}
```

### discoverEligibleForReview()

Find papers ready for review (at draft or recheck stage).

**Parameters**:
- `researchDir` (string) - Path to research directory

**Returns**: `array` - Array of papers eligible for review

**Implementation**:
```javascript
function discoverEligibleForReview(researchDir) {
    const papers = [];

    if (!fs.existsSync(researchDir)) {
        return papers;
    }

    const entries = fs.readdirSync(researchDir, { withFileTypes: true });

    for (const entry of entries) {
        if (!entry.isDirectory()) continue;
        if (entry.name.startsWith('_') || entry.name === 'docs') continue;

        const paperDir = path.join(researchDir, entry.name);
        const panelYamlPath = path.join(paperDir, '_panel.yaml');

        if (!fs.existsSync(panelYamlPath)) continue;

        try {
            const panelYaml = readYAML(panelYamlPath);

            // Ready for review if at draft or recheck stage
            if (panelYaml.stage === 'draft' || panelYaml.stage === 'recheck') {
                papers.push({
                    directory: entry.name,
                    fullPath: paperDir,
                    panelYaml,
                    uuid: panelYaml.uuid,
                    slug: panelYaml.slug,
                    order: panelYaml.order,
                    title: panelYaml.title,
                    venue: panelYaml.venue,
                    stage: panelYaml.stage
                });
            }
        } catch (e) {
            // Skip invalid yaml
        }
    }

    // Sort by order if available
    return papers.sort((a, b) => {
        const orderA = a.order || 999;
        const orderB = b.order || 999;
        return orderA - orderB;
    });
}
```

## Batch Execution Functions

### executeBatch()

Execute a command across multiple papers (sequential or parallel).

**Parameters**:
- `papers` (array) - Array of paper objects
- `command` (string) - Command to execute (e.g., 'author', 'review')
- `options` (object) - Execution options
  - `parallel` (boolean) - Run in parallel (default: true)
  - `maxConcurrent` (number) - Max parallel agents (default: 5)
  - `dryRun` (boolean) - Preview without executing

**Returns**: `object` - Batch execution results

**Implementation**:
```javascript
async function executeBatch(papers, command, options = {}) {
    const {
        parallel = true,
        maxConcurrent = 5,
        dryRun = false
    } = options;

    if (dryRun) {
        return {
            dryRun: true,
            papers: papers.map(p => ({
                reference: p.order || p.slug || p.directory,
                command: `panel:${command} --paper ${p.order || p.slug}`
            })),
            mode: parallel ? 'parallel' : 'sequential'
        };
    }

    const results = [];

    if (parallel) {
        // Spawn parallel agents
        const agents = [];

        for (const paper of papers.slice(0, maxConcurrent)) {
            const ref = paper.order || paper.slug || paper.directory;

            const agent = await Task({
                subagent_type: 'general-purpose',
                description: `${command} ${paper.slug || paper.directory}`,
                prompt: `
                    Run panel:${command} --paper ${ref} to completion.

                    Paper: ${paper.title || paper.directory}
                    Directory: ${paper.directory}
                    ${paper.venue ? `Venue: ${paper.venue}` : ''}

                    Work autonomously until the ${command} process is complete or blocked.
                    Report results clearly.
                `,
                run_in_background: true
            });

            agents.push({
                paper,
                agentId: agent.id,
                reference: ref
            });
        }

        // Wait for all agents to complete
        for (const agent of agents) {
            try {
                const result = await TaskOutput({
                    task_id: agent.agentId,
                    block: true
                });

                results.push({
                    paper: agent.paper,
                    success: result.status === 'completed',
                    output: result.output
                });
            } catch (e) {
                results.push({
                    paper: agent.paper,
                    success: false,
                    error: e.message
                });
            }
        }
    } else {
        // Sequential execution
        for (const paper of papers) {
            const ref = paper.order || paper.slug || paper.directory;

            try {
                // Execute command directly (not via agent)
                // This would call the actual command implementation
                const result = await executeCommand(command, ref);

                results.push({
                    paper,
                    success: true,
                    result
                });
            } catch (e) {
                results.push({
                    paper,
                    success: false,
                    error: e.message
                });
            }
        }
    }

    return {
        success: results.every(r => r.success),
        results,
        summary: {
            total: papers.length,
            completed: results.filter(r => r.success).length,
            failed: results.filter(r => !r.success).length
        }
    };
}

// Helper function (would be implemented in commands)
async function executeCommand(command, paperRef) {
    // This is a placeholder - actual implementation would call
    // the command's main logic
    throw new Error('Not implemented - use Task tool for now');
}
```

## Display Functions

### formatBatchSummary()

Format batch operation results for display.

**Parameters**:
- `results` (object) - Batch execution results

**Returns**: `string` - Formatted summary

**Implementation**:
```javascript
function formatBatchSummary(results, command) {
    const lines = [];

    lines.push('═══════════════════════════════════════');
    lines.push(`${results.success ? '✓' : '⚠'} Batch ${command} Complete`);
    lines.push('═══════════════════════════════════════');
    lines.push('');

    lines.push(`Total: ${results.summary.total} papers`);
    lines.push(`Completed: ${results.summary.completed} papers`);

    if (results.summary.failed > 0) {
        lines.push(`Failed: ${results.summary.failed} papers`);
    }

    lines.push('');

    // Show per-paper results
    for (const result of results.results) {
        const paper = result.paper;
        const name = `${paper.order || '?'} — ${paper.slug || paper.directory}`;
        const status = result.success ? '✓' : '✗';

        lines.push(`${status} ${name}`);

        if (result.error) {
            lines.push(`  Error: ${result.error}`);
        }
    }

    return lines.join('\n');
}
```

### formatDiscoveryResults()

Format paper discovery results for display.

**Parameters**:
- `papers` (array) - Discovered papers
- `purpose` (string) - Purpose (e.g., 'setup', 'authoring', 'review')

**Returns**: `string` - Formatted results

**Implementation**:
```javascript
function formatDiscoveryResults(papers, purpose) {
    if (papers.length === 0) {
        return `No papers found eligible for ${purpose}.`;
    }

    const lines = [];

    lines.push(`Found ${papers.length} paper${papers.length === 1 ? '' : 's'} eligible for ${purpose}:`);
    lines.push('');

    for (const paper of papers) {
        const name = paper.slug || paper.directory;
        const order = paper.order ? `${String(paper.order).padStart(2, '0')} — ` : '  • ';

        lines.push(`${order}${name}`);

        if (paper.title) {
            lines.push(`    ${paper.title}`);
        }
        if (paper.venue) {
            lines.push(`    Venue: ${paper.venue}`);
        }
        if (paper.stage) {
            lines.push(`    Stage: ${paper.stage}`);
        }

        lines.push('');
    }

    return lines.join('\n');
}
```

## Module Exports

```javascript
module.exports = {
    discoverPapersWithPlan,
    discoverPapersNeedingSetup,
    discoverEligibleForAuthoring,
    discoverEligibleForReview,
    executeBatch,
    formatBatchSummary,
    formatDiscoveryResults
};
```
