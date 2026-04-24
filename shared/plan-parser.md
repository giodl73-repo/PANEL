# Plan Parser — Parse plan.md into Task Objects

Shared utility for parsing a paper's `plan.md` file into structured task objects for the writing orchestration workflow.

## Functions

```javascript
// ═══════════════════════════════════════════════════════════════
// Plan Parser — Extract tasks and dependencies from plan.md
// ═══════════════════════════════════════════════════════════════

/**
 * Parse plan.md into structured data
 *
 * @param {string} planContent - Raw content of plan.md
 * @returns {Object} Parsed plan with sections, experiments, figures, etc.
 */
function parsePlan(planContent) {
    const plan = {
        title: '',
        researchQuestion: '',
        venue: {
            name: '',
            deadline: '',
            pageLimit: null,
            contributionType: ''
        },
        sections: [],
        experiments: [],
        figures: [],
        tables: [],
        analysisScripts: [],
        qualityCheckpoints: [],
        dependencies: []
    };

    // Extract title from first heading
    const titleMatch = planContent.match(/^#\s+Paper Plan:\s*(.+)$/m);
    if (titleMatch) {
        plan.title = titleMatch[1].trim();
    }

    // Extract research question
    const rqMatch = planContent.match(/##\s+Research Question\s*\n+([\s\S]*?)(?=\n##|$)/);
    if (rqMatch) {
        plan.researchQuestion = rqMatch[1].trim();
    }

    // Extract target venue
    const venueMatch = planContent.match(/##\s+Target Venue\s*\n+([\s\S]*?)(?=\n##|$)/);
    if (venueMatch) {
        const venueText = venueMatch[1];
        const nameMatch = venueText.match(/Conference\/journal:\s*(.+)/i);
        const deadlineMatch = venueText.match(/Deadline:\s*(.+)/i);
        const pageLimitMatch = venueText.match(/Page limit:\s*(\d+)/i);
        const contribMatch = venueText.match(/contribution type:\s*(.+)/i);

        if (nameMatch) plan.venue.name = nameMatch[1].trim();
        if (deadlineMatch) plan.venue.deadline = deadlineMatch[1].trim();
        if (pageLimitMatch) plan.venue.pageLimit = parseInt(pageLimitMatch[1]);
        if (contribMatch) plan.venue.contributionType = contribMatch[1].trim();
    }

    // Extract sections
    const sectionsMatch = planContent.match(/##\s+Sections\s*\n+([\s\S]*?)(?=\n##|$)/);
    if (sectionsMatch) {
        const sectionLines = sectionsMatch[1].split('\n').filter(l => l.trim().startsWith('-'));
        for (const line of sectionLines) {
            const match = line.match(/^-\s*([^:]+):\s*(.+)$/);
            if (match) {
                plan.sections.push({
                    name: match[1].trim(),
                    keyPoints: match[2].trim()
                });
            }
        }
    }

    // Extract experiments
    const expMatch = planContent.match(/##\s+Experiments\s*\n+([\s\S]*?)(?=\n##|$)/);
    if (expMatch) {
        const expLines = expMatch[1].split('\n').filter(l => l.trim().startsWith('-'));
        for (const line of expLines) {
            const match = line.match(/^-\s*\[[ x]\]\s*([^:]+):\s*(.+)$/);
            if (match) {
                const completed = line.includes('[x]');
                plan.experiments.push({
                    name: match[1].trim(),
                    script: match[2].trim(),
                    completed
                });
            }
        }
    }

    // Extract figures
    const figMatch = planContent.match(/##\s+Figures\s*\n+([\s\S]*?)(?=\n##|$)/);
    if (figMatch) {
        const figLines = figMatch[1].split('\n').filter(l => l.trim().startsWith('-'));
        for (const line of figLines) {
            const match = line.match(/^-\s*\[[ x]\]\s*(.+)$/);
            if (match) {
                const completed = line.includes('[x]');
                plan.figures.push({
                    description: match[1].trim(),
                    completed
                });
            }
        }
    }

    // Extract tables
    const tableMatch = planContent.match(/##\s+Tables\s*\n+([\s\S]*?)(?=\n##|$)/);
    if (tableMatch) {
        const tableLines = tableMatch[1].split('\n').filter(l => l.trim().startsWith('-'));
        for (const line of tableLines) {
            const match = line.match(/^-\s*\[[ x]\]\s*(.+)$/);
            if (match) {
                const completed = line.includes('[x]');
                plan.tables.push({
                    description: match[1].trim(),
                    completed
                });
            }
        }
    }

    // Extract analysis scripts
    const scriptMatch = planContent.match(/##\s+Analysis Scripts\s*\n+([\s\S]*?)(?=\n##|$)/);
    if (scriptMatch) {
        const scriptLines = scriptMatch[1].split('\n').filter(l => l.trim().startsWith('-'));
        for (const line of scriptLines) {
            const match = line.match(/^-\s*([^\s—]+)\s*[—-]\s*(.+)$/);
            if (match) {
                plan.analysisScripts.push({
                    path: match[1].trim(),
                    description: match[2].trim()
                });
            }
        }
    }

    // Extract quality checkpoints
    const qcMatch = planContent.match(/##\s+Quality Checkpoints\s*\n+([\s\S]*?)(?=\n##|$)/);
    if (qcMatch) {
        const qcLines = qcMatch[1].split('\n').filter(l => l.trim().startsWith('-'));
        for (const line of qcLines) {
            const match = line.match(/^-\s*\[[ x]\]\s*([^:]+):\s*(.+)$/);
            if (match) {
                const completed = line.includes('[x]');
                plan.qualityCheckpoints.push({
                    name: match[1].trim(),
                    target: match[2].trim(),
                    completed
                });
            }
        }
    }

    // Extract dependencies
    const depMatch = planContent.match(/##\s+Dependencies\s*\n+([\s\S]*?)(?=\n##|$)/);
    if (depMatch) {
        const depLines = depMatch[1].split('\n').filter(l => l.trim().startsWith('-'));
        for (const line of depLines) {
            const match = line.match(/^-\s*(.+?)\s+depends on:\s*(.+)$/i);
            if (match) {
                plan.dependencies.push({
                    task: match[1].trim(),
                    dependsOn: match[2].trim()
                });
            }
        }
    }

    return plan;
}

/**
 * Validate plan structure
 *
 * @param {Object} plan - Parsed plan object
 * @returns {Object} { valid: boolean, errors: string[], warnings: string[] }
 */
function validatePlan(plan) {
    const errors = [];
    const warnings = [];

    // Required fields
    if (!plan.title) {
        errors.push('Missing paper title');
    }
    if (!plan.researchQuestion) {
        errors.push('Missing research question');
    }
    if (!plan.venue.name) {
        errors.push('Missing target venue');
    }
    if (plan.sections.length === 0) {
        errors.push('No sections defined');
    }

    // Warnings
    if (plan.experiments.length === 0) {
        warnings.push('No experiments defined');
    }
    if (plan.figures.length === 0) {
        warnings.push('No figures planned');
    }
    if (plan.qualityCheckpoints.length === 0) {
        warnings.push('No quality checkpoints specified');
    }

    return {
        valid: errors.length === 0,
        errors,
        warnings
    };
}

/**
 * Convert plan to task list for TaskCreate
 *
 * @param {Object} plan - Parsed plan object
 * @param {string} paperName - Paper directory name
 * @returns {Array} Task objects for TaskCreate
 */
function planToTasks(plan, paperName) {
    const tasks = [];

    // Writing tasks - one per section
    for (let i = 0; i < plan.sections.length; i++) {
        const section = plan.sections[i];
        tasks.push({
            subject: `Write ${section.name}`,
            description: `Write section: ${section.name}\n\nKey points: ${section.keyPoints}`,
            activeForm: `Writing ${section.name}`,
            type: 'writing',
            section: section.name,
            sectionIndex: i + 1,
            metadata: { paperName, taskType: 'writing' }
        });
    }

    // Experiment tasks
    for (const exp of plan.experiments) {
        if (!exp.completed) {
            tasks.push({
                subject: `Run experiment: ${exp.name}`,
                description: `Execute experiment: ${exp.name}\n\nScript: ${exp.script}`,
                activeForm: `Running experiment: ${exp.name}`,
                type: 'experiment',
                script: exp.script,
                metadata: { paperName, taskType: 'experiment' }
            });
        }
    }

    // Figure tasks
    for (const fig of plan.figures) {
        if (!fig.completed) {
            tasks.push({
                subject: `Generate figure: ${fig.description}`,
                description: `Create figure: ${fig.description}`,
                activeForm: `Generating figure: ${fig.description}`,
                type: 'figure',
                metadata: { paperName, taskType: 'figure' }
            });
        }
    }

    // Analysis tasks
    for (const script of plan.analysisScripts) {
        tasks.push({
            subject: `Run analysis: ${script.description}`,
            description: `Execute analysis script: ${script.path}\n\n${script.description}`,
            activeForm: `Running analysis: ${script.description}`,
            type: 'analysis',
            script: script.path,
            metadata: { paperName, taskType: 'analysis' }
        });
    }

    return tasks;
}

/**
 * Check if script file exists
 *
 * @param {string} scriptPath - Path to script file
 * @param {string} paperDir - Paper directory base path
 * @returns {Promise<boolean>} True if file exists
 */
async function scriptExists(scriptPath, paperDir) {
    try {
        const fullPath = `${paperDir}/${scriptPath}`;
        await Read(fullPath);
        return true;
    } catch {
        return false;
    }
}
```

## Usage

```javascript
// @import ../shared/plan-parser.md

async function main(args) {
    const paperDir = 'research/panel-my-paper';

    // Parse plan
    const planContent = await Read(`${paperDir}/plan.md`);
    const plan = parsePlan(planContent);

    // Validate
    const validation = validatePlan(plan);
    if (!validation.valid) {
        for (const err of validation.errors) {
            msg(err, 'error');
        }
        return;
    }

    // Show warnings
    for (const warn of validation.warnings) {
        msg(warn, 'warning');
    }

    // Convert to tasks
    const tasks = planToTasks(plan, 'panel-my-paper');

    // Create tasks
    for (const task of tasks) {
        await TaskCreate(task);
    }
}
```

## Task Dependencies

Dependencies from plan.md are applied after task creation using TaskUpdate:

```javascript
// After creating all tasks
for (const dep of plan.dependencies) {
    // Find task IDs by matching subject
    const taskId = findTaskBySubject(dep.task);
    const blockerId = findTaskBySubject(dep.dependsOn);

    if (taskId && blockerId) {
        await TaskUpdate({
            taskId,
            addBlockedBy: [blockerId]
        });
    }
}
```
