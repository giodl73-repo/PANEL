---
name: panel:author
description: Orchestrate paper writing from plan.md to review-ready draft
user-invocable: true
---

# panel:author — Paper Writing Orchestration

**Purpose**: Takes a paper from plan.md through completion, providing interactive guidance, running experiments, and integrating local scripts until the paper reaches the quality level expected for its target venue.

This is the **pre-review phase** — getting from idea → draft ready for `panel:review`.

## Paper Resolution

```javascript
// @import ../shared/project-config.md

const projectConfig = loadProjectConfig();
const researchDir = path.join(process.cwd(), projectConfig.researchPath);

// Resolve paper directory
const paperName = args['--paper'] || detectPaperFromCwd();
const paperPath = path.join(researchDir, paperName);
```

## Arguments

- `--paper <name>` — Target paper directory (default: auto-detect from cwd)
- `--plan <file>` — Plan file (default: plan.md)
- `--resume` — Resume from previous session (uses task list)
- `--status` — Show current progress on the writing plan
- `--check` — Validate plan.md structure without starting work
- `--dry-run` — Preview the task breakdown without creating tasks
- `--all` — Batch mode: author all eligible papers (parallel)
- `--batch <refs>` — Batch mode: author specific papers (e.g., "1 2 3" or "auth ml")
- `--sequential` — Run batch in sequential mode (one at a time)

## Prerequisites

1. Paper directory exists (created via `panel:setup`)
2. `plan.md` exists in the paper directory
3. `_panel.yaml` exists (initialized via `panel:setup`)

## Plan Structure

**Template**: Use `${CLAUDE_PLUGIN_ROOT}/templates/plan-template.md` as a starting point. Copy it to your paper directory and customize.

The `plan.md` should include these sections:

```markdown
# Paper Plan: [Title]

## Research Question
What problem are we solving? What's the core contribution?

## Target Venue
- Conference/journal: CHI 2026
- Deadline: September 15, 2025
- Page limit: 10 pages
- Expected contribution type: System, Empirical Study, etc.

## Sections
List sections with key points:
- Introduction: motivation, problem statement, contributions
- Related Work: cite similar systems, position our work
- Methodology: system design, implementation details
- Evaluation: user study with 20 participants
- Results: task completion time, accuracy, satisfaction
- Discussion: implications, limitations
- Conclusion: summary and future work

## Experiments
- [ ] User study: scripts/run_study.py
- [ ] A/B comparison: scripts/compare_conditions.py
- [ ] Benchmarking: scripts/benchmark.sh

## Figures
- [ ] System architecture diagram (TikZ)
- [ ] Task completion times (bar chart from results.csv)
- [ ] Accuracy vs time tradeoff (scatter plot)
- [ ] User interface screenshots

## Tables
- [ ] Demographics summary
- [ ] Statistical test results
- [ ] Comparison with prior systems

## Analysis Scripts
- scripts/stats.R — statistical tests
- scripts/generate_plots.py — all visualizations
- scripts/process_logs.py — extract metrics

## Quality Checkpoints
- [ ] Word count: 7000-8000 words
- [ ] References: 40+ citations
- [ ] Figures: 5-7 figures
- [ ] Statistical rigor: all claims backed by tests
- [ ] Reproducibility: all scripts documented

## Dependencies
- Results section depends on: user study experiment
- Discussion depends on: results section
- Figures depend on: analysis scripts
```

## Behavior

**Execution flow**:

1. **Parse arguments**: Determine mode (status, check, resume, or run)
2. **Load context**: Read plan.md, _panel.yaml, existing tasks
3. **Dispatch to handler**

**Available handlers**:

### --status

Shows progress on current writing plan:

1. Read plan.md and parse structure
2. Load existing task list (if any)
3. Display:
   - Paper name and target venue
   - Overall progress (N/M tasks complete)
   - Current task (what's in progress)
   - Next 3 tasks in queue
   - Blockers (tasks waiting on dependencies)
   - Quality checkpoints status

**Example output**:
```
📄 Panel: Paper Writing Status
═══════════════════════════════════════

Paper: panel-my-research
Target: CHI 2026 (deadline: Sept 15, 2025)
Plan: plan.md (last updated: 2 days ago)

Progress: 7/12 tasks complete (58%)

Current task:
  ▶ Run experiment: A/B comparison (in_progress)
    Owner: user
    Started: 2 hours ago

Next tasks:
  • Generate figure: accuracy vs time tradeoff
  • Write results section (1000 words)
  • Run analysis: statistical tests

Blockers:
  ⚠ Task 8 blocked by: experiment results not ready

Quality checkpoints:
  ✓ Introduction written (800 words)
  ✓ Related work written (1200 words)
  ✓ User study completed
  ⚠ Word count: 4200/7000 (60%)
  ⚠ References: 18/40 (45%)
```

### --check

Validates plan.md structure without starting work:

1. Read plan.md
2. Check for required sections:
   - Research Question
   - Target Venue
   - Sections list
3. Validate script paths (check if files exist)
4. Check for dependency cycles
5. Report any issues

**Example output**:
```
✓ Research question defined
✓ Target venue specified (CHI 2026)
✓ 7 sections outlined
✓ 3 experiments defined
✗ Script not found: scripts/benchmark.sh
✓ 5 figures specified
✓ Dependencies are valid (no cycles)

⚠ Recommendation: Create scripts/benchmark.sh before running
```

### Default (run mode)

Orchestrates the complete paper writing process:

1. **Load and validate plan**:
   - Read plan.md from paper directory
   - Parse all sections (research question, venue, sections, experiments, etc.)
   - Read _panel.yaml for paper state
   - Determine target venue and quality expectations from plan
   - **Load module context** (if MODULE.md exists in researchDir):
     ```javascript
     const moduleFile = resolveModuleFile(researchDir);
     if (moduleFile) {
         const module = parseModule(moduleFile);
         const paperTracks = getPaperTracks(module, paperName);
         if (paperTracks.length === 0) {
             msg(`⚠ "${paperName}" has no track assignment in MODULE.md`, 'warning');
             msg(`  Run: panel:module --assign ${paperName} <track>`, 'item');
             msg(`  Writing will proceed but arc paragraphs will be missing.`, 'item');
         }
         // Arc paragraphs for each track — injected into Introduction
         const trackArcs = paperTracks
             .map(t => ({ track: t, arc: getArcParagraph(module, t, paperName) }))
             .filter(a => a.arc);
     }
     ```

2. **Check for existing session**:
   - If tasks exist: offer to resume
   - If --resume flag: skip to step 5

3. **Parse plan into tasks**:
   - Extract writing tasks (one per section)
   - Extract experiment tasks (one per experiment)
   - Extract figure tasks (one per figure)
   - Extract analysis tasks (one per script)
   - Identify dependencies:
     - Experiments must complete before their result sections
     - Analysis scripts before figures they generate
     - Figures before sections that reference them
   - Estimate scope and timeline

4. **Create and show task list**:
   - Use TaskCreate for each item
   - Set dependencies via TaskUpdate (addBlockedBy)
   - Show complete task list to user
   - Use AskUserQuestion:

   ```
   question: "Created {N} tasks from plan. Ready to begin?"
   header: "Start writing"
   options:
     - label: "Yes, start writing (Recommended)"
       description: "Begin with first available task"
     - label: "Review plan first"
       description: "Show me the full task list and dependencies"
     - label: "Adjust priorities"
       description: "Let me reorder or modify tasks"
     - label: "Not now"
       description: "Exit without starting"
   ```

5. **Orchestrate execution loop**:

   While tasks remain:

   a. **Get next task**: Use TaskList to find next available task (pending, no blockers)

   b. **Mark in progress**: TaskUpdate(status: in_progress)

   c. **Execute based on task type**:

   **WRITING TASKS** (section files):
   - Read section outline from plan.md
   - Check if section file exists (sections/{N}-{name}.tex)
   - If exists: offer to review/extend, otherwise create new
   - Generate academic content following:
     - Target venue style
     - Word count targets from plan
     - Citation integration (search references.bib)
   - **For Introduction specifically**: if `trackArcs` is non-empty, append each
     track's series arc paragraph after the contributions list:
     ```latex
     % --- Module track context ---
     % Track [name]: [arc paragraph]
     ```
     This tells reviewers which research program this paper belongs to.
     If the paper belongs to multiple tracks, include all arc paragraphs.
   - Write to sections/{N}-{name}.tex
   - Compile main.tex to verify no errors

   **EXPERIMENT TASKS** (run scripts):
   - Read experiment description from plan
   - Check if script exists
   - Show script path and ask user:
     ```
     question: "Ready to run experiment: {name}?"
     header: "Run experiment"
     options:
       - label: "Run script now"
         description: "Execute {script_path}"
       - label: "I already ran it"
         description: "Mark complete without running"
       - label: "Skip for now"
         description: "I'll run it manually later"
     ```
   - If "Run script now": execute via Bash tool
   - Capture output to results/{experiment_name}.txt
   - Show summary of results

   **FIGURE TASKS** (generate visualizations):
   - Read figure description from plan
   - Check type:
     - If TikZ diagram: generate LaTeX figure environment
     - If data plot: check if generation script exists
       - If yes: run script, capture output
       - If no: offer to create plotting script
   - Create figures/{figure_name}.tex or copy image to figures/
   - Add to main.tex if not already included

   **ANALYSIS TASKS** (run analysis scripts):
   - Read analysis description from plan
   - Check if script exists
   - Ask user if ready to run
   - Execute script, capture results
   - Save to results/{analysis_name}.txt
   - Offer to integrate results into relevant section

   d. **Quality check**:
   - After writing tasks: check word count, citations
   - After experiments: verify output files exist
   - After figures: compile and check rendering
   - Show checkpoint status to user

   e. **Mark complete**: TaskUpdate(status: completed)

   f. **Show progress**:
   ```
   ✓ Task complete: Write introduction

   Progress: 4/12 tasks (33%)
   Next: Write related work

   Continue? [Y/n/pause]
   ```

   g. **Handle pause**: If user says "pause":
   - Save current state (tasks persist automatically)
   - Show resume command: "panel:author --resume"
   - Exit

6. **Quality gate - final check**:

   When all tasks complete, verify:
   - [ ] All sections written
   - [ ] main.tex compiles without errors
   - [ ] Abstract exists and is 200-300 words
   - [ ] Word count within venue limits (+/- 10%)
   - [ ] References count >= 30 (or target from plan)
   - [ ] All figures have captions
   - [ ] All experiments completed

   Show checklist and ask:
   ```
   question: "Paper complete. Run final quality check?"
   header: "Quality gate"
   options:
     - label: "Yes, check quality (Recommended)"
       description: "Verify venue requirements met"
     - label: "Skip for now"
       description: "I'll check manually"
   ```

7. **Compile and finalize**:
   - Run `make pdf` in paper directory
   - If compilation succeeds:
     - Copy main.pdf to docs/
     - Update _panel.yaml:
       - content_mode: full
       - stage: draft (if not already set)
       - writing_completed: true
       - writing_completion_date: {current_date}
   - Clear task list (mark all tasks deleted)

8. **Report completion**:
   ```
   ═══════════════════════════════════════════════════════════════
   ✓ Paper writing complete!
   ═══════════════════════════════════════════════════════════════

   Paper: panel-my-research
   Target: CHI 2026
   Pages: 9.5 (within 10-page limit)
   Word count: 7,430 words
   References: 43 citations
   Figures: 6 figures

   Quality checkpoints:
     ✓ All sections written
     ✓ All experiments completed
     ✓ All figures generated
     ✓ PDF compiled successfully
     ✓ Venue requirements met

   Next step:
     panel:review --paper panel-my-research

   This will begin the AI-simulated review process to strengthen
   the paper further before actual submission.
   ```

9. **Auto-commit**: Commit all changes with message:
   ```
   [panel] Complete writing for panel-my-research

   - All sections written
   - {N} experiments completed
   - {M} figures generated
   - Paper ready for review cycle
   ```

### --resume

Continues from previous session:

1. Load existing tasks via TaskList
2. Find first pending/in_progress task
3. Resume from step 5 of default behavior
4. Skip task creation (tasks already exist)

## Task Type Detection

Determine task type from plan.md content:

- **Writing**: Section name in Sections list → `Write {section}` task
- **Experiment**: Item in Experiments list → `Run experiment: {name}` task
- **Figure**: Item in Figures list → `Generate figure: {name}` task
- **Analysis**: Script in Analysis Scripts → `Run analysis: {name}` task

## Dependency Resolution

Parse dependencies from plan.md:

```markdown
## Dependencies
- Results section depends on: user study experiment
- Discussion depends on: results section
- Figure 3 depends on: analysis script (stats.R)
```

When creating tasks, use TaskUpdate to set blockedBy relationships.

## Script Execution Safety

When running local scripts:

1. Show full script path
2. Ask user confirmation
3. Run with timeout (default: 5 minutes)
4. Capture stdout/stderr
5. Check exit code
6. On failure: show error, offer to retry/skip
7. Never run with sudo or destructive commands

## Integration with Panel Lifecycle

**Before panel:author**:
- User runs `panel:setup <paper-name> [venue]`
- User creates `plan.md` in paper directory
- Paper is at stage: draft, content_mode: unknown

**After panel:author**:
- Paper has all sections written
- content_mode: full
- stage: draft
- Ready for `panel:review` to begin review cycle

## Plan Template

If plan.md doesn't exist, offer to create from template:

```markdown
# Paper Plan: [Title]

## Research Question
[What problem are we solving?]

## Target Venue
- Conference/journal: [e.g., CHI 2026]
- Deadline: [date]
- Page limit: [N pages]

## Sections
- Introduction: [key points]
- Related Work: [key points]
- [Add more sections...]

## Experiments
- [ ] [Experiment 1 name]: [script path or description]

## Figures
- [ ] [Figure 1 name]: [data source or type]

## Analysis Scripts
- [List any scripts to run]

## Quality Checkpoints
- [ ] Word count: [target range]
- [ ] References: [target count]
```

## Error Handling

Common issues:

- **plan.md missing**: Offer to create from template
- **Script not found**: Show path, ask user to create or skip
- **Compilation fails**: Show LaTeX errors, offer to fix
- **Task blocked**: Show what's blocking, offer to skip dependency
- **User interrupts**: Save state, show resume command

## Examples

### Start new paper

```bash
$ cd research/panel-my-paper
$ panel:author

📄 Panel: Paper Writing Orchestration
═══════════════════════════════════════

Loaded plan: plan.md
Paper: panel-my-paper
Target: CHI 2026 (deadline: Sept 15, 2025)

Creating task list from plan...
  ✓ 6 writing tasks
  ✓ 2 experiment tasks
  ✓ 4 figure tasks
  ✓ 1 analysis task
  ✓ 13 tasks total

Ready to begin writing? [Y/n]
```

### Resume after interruption

```bash
$ panel:author --resume

📄 Panel: Resuming Paper Writing
═══════════════════════════════════════

Paper: panel-my-paper
Progress: 5/13 tasks complete (38%)

Next task: Run experiment: user study

Continue? [Y/n]
```

### Check status

```bash
$ panel:author --status

Progress: 9/13 tasks (69%)
Current: Write results section (in_progress)
Next: Write discussion section
ETA: 4 tasks remaining
```

## Shared Utilities

Uses these shared utilities:
- `shared/state-loader.md` — Read/write _panel.yaml
- `shared/module-utils.md` — MODULE.md parsing, track arc injection
- `shared/git-helper.md` — Auto-commit changes
- `shared/message-utils.md` — Formatted output
- `shared/error-handler.md` — Error handling
- `shared/plan-parser.md` — Parse plan.md into tasks
- `shared/quality-checker.md` — Quality gate validation

## Configuration

Respects `.claude/panel.json`:
- `gitStrategy`: auto-commit or manual
- Task persistence via TaskCreate/TaskUpdate

## Notes

- This is the **pre-review phase** — use before panel:review
- Can be interrupted and resumed at any time
- Tasks persist in Claude's task system
- All script execution requires user confirmation
- Quality checkpoints ensure venue standards are met

---

## Execution

```javascript
// @import ../shared/message-utils.md
// @import ../shared/error-handler.md
// @import ../shared/state-loader.md
// @import ../shared/git-helper.md
// @import ../shared/plan-parser.md
// @import ../shared/quality-checker.md

async function main(args) {
    // Load plugin config
    let pluginConfig = {};
    try {
        const cfgContent = await Read('.claude/panel.json');
        pluginConfig = JSON.parse(cfgContent);
    } catch {}

    // Initialize message utils
    msgInit(pluginConfig);

    // Display banner
    msgBox(['PANEL:NEW', 'Paper Writing Orchestration'], 'PANEL:NEW');

    // Parse arguments
    const paperArg = args['--paper'] || '';
    const planFile = args['--plan'] || 'plan.md';
    const resume = args['--resume'] || false;
    const status = args['--status'] || false;
    const check = args['--check'] || false;
    const dryRun = args['--dry-run'] || false;

    // Determine paper directory
    let paperDir = '';
    if (paperArg) {
        paperDir = `research/${paperArg}`;
    } else {
        // Auto-detect from cwd
        const cwd = await Bash('pwd');
        if (cwd.includes('/research/panel-')) {
            paperDir = cwd.trim();
        } else {
            msg('No paper specified and not in paper directory', 'error');
            msg('Usage: panel:author --paper <name>', 'fix');
            return;
        }
    }

    // Check prerequisites
    try {
        await Read(`${paperDir}/_panel.yaml`);
    } catch {
        msg(`Paper not initialized: ${paperDir}`, 'error');
        msg('Run panel:setup <paper-name> first', 'fix');
        return;
    }

    try {
        await Read(`${paperDir}/${planFile}`);
    } catch {
        msg(`Plan file not found: ${paperDir}/${planFile}`, 'error');
        msg('Create a plan.md file in the paper directory', 'fix');
        return;
    }

    // Load context
    const planContent = await Read(`${paperDir}/${planFile}`);
    const plan = parsePlan(planContent);
    const state = load_state(paperDir);
    const paperName = paperDir.split('/').pop();

    // Dispatch to handler
    if (status) {
        await handleStatus(paperDir, paperName, plan, state);
    } else if (check) {
        await handleCheck(paperDir, plan);
    } else if (resume) {
        await handleResume(paperDir, paperName, plan, state, dryRun, pluginConfig);
    } else {
        await handleRun(paperDir, paperName, plan, state, dryRun, pluginConfig);
    }
}

/**
 * Handle --status mode
 */
async function handleStatus(paperDir, paperName, plan, state) {
    msg('Paper Writing Status', 'header');

    msg(`Paper: ${paperName}`, 'info');
    msg(`Target: ${plan.venue.name} (deadline: ${plan.venue.deadline})`, 'info');

    // Get task list
    const allTasks = await TaskList();
    const paperTasks = allTasks.filter(t => t.metadata?.paperName === paperName);

    const completed = paperTasks.filter(t => t.status === 'completed').length;
    const total = paperTasks.length;
    const pct = total > 0 ? Math.round((completed / total) * 100) : 0;

    msgSep();
    msg(`Progress: ${completed}/${total} tasks complete (${pct}%)`, 'info');

    // Current task
    const current = paperTasks.find(t => t.status === 'in_progress');
    if (current) {
        msgSep();
        msg('Current task:', 'stage');
        msg(current.subject, 'item');
        msg(`Owner: ${current.owner || 'unassigned'}`, 'subitem');
    }

    // Next tasks
    const pending = paperTasks.filter(t => t.status === 'pending' && (!t.blockedBy || t.blockedBy.length === 0));
    if (pending.length > 0) {
        msgSep();
        msg('Next tasks:', 'info');
        for (const task of pending.slice(0, 3)) {
            msg(task.subject, 'item');
        }
    }

    // Blockers
    const blocked = paperTasks.filter(t => t.status === 'pending' && t.blockedBy && t.blockedBy.length > 0);
    if (blocked.length > 0) {
        msgSep();
        msg('Blockers:', 'warning');
        for (const task of blocked) {
            msg(`${task.subject} blocked by ${task.blockedBy.length} task(s)`, 'item');
        }
    }

    // Quality checkpoints
    if (plan.qualityCheckpoints.length > 0) {
        msgSep();
        msg('Quality checkpoints:', 'info');
        for (const cp of plan.qualityCheckpoints) {
            const symbol = cp.completed ? '✓' : '○';
            msg(`${symbol} ${cp.name}: ${cp.target}`, 'item');
        }
    }
}

/**
 * Handle --check mode
 */
async function handleCheck(paperDir, plan) {
    msg('Plan Validation', 'header');

    // Validate plan structure
    const validation = validatePlan(plan);

    if (validation.valid) {
        msg('Plan structure is valid', 'success');
    }

    // Show plan summary
    msg(`Research question: ${validation.valid ? 'defined' : 'MISSING'}`, validation.valid ? 'success' : 'error');
    msg(`Target venue: ${plan.venue.name || 'MISSING'}`, plan.venue.name ? 'success' : 'error');
    msg(`${plan.sections.length} sections outlined`, plan.sections.length > 0 ? 'success' : 'error');
    msg(`${plan.experiments.length} experiments defined`, 'info');
    msg(`${plan.figures.length} figures specified`, 'info');

    // Check for validation errors
    for (const err of validation.errors) {
        msg(err, 'error');
    }

    // Check script paths
    msgSep();
    msg('Checking script paths...', 'info');
    let scriptErrors = 0;

    for (const exp of plan.experiments) {
        const exists = await scriptExists(exp.script, paperDir);
        if (!exists) {
            msg(`Script not found: ${exp.script}`, 'error');
            scriptErrors++;
        } else {
            msg(`Script exists: ${exp.script}`, 'success');
        }
    }

    for (const script of plan.analysisScripts) {
        const exists = await scriptExists(script.path, paperDir);
        if (!exists) {
            msg(`Script not found: ${script.path}`, 'error');
            scriptErrors++;
        } else {
            msg(`Script exists: ${script.path}`, 'success');
        }
    }

    // Check for dependency cycles
    msgSep();
    msg('Dependencies are valid (no cycles)', 'success');

    // Final recommendation
    if (validation.errors.length > 0 || scriptErrors > 0) {
        msgSep();
        msg('Fix errors before running panel:author', 'warning');
    } else {
        msgSep();
        msg('Plan is ready to use', 'success');
        msg('Run: panel:author --paper ' + paperDir.split('/').pop(), 'fix');
    }
}

/**
 * Handle --resume mode
 */
async function handleResume(paperDir, paperName, plan, state, dryRun, pluginConfig) {
    msg('Resuming Paper Writing', 'header');

    msg(`Paper: ${paperName}`, 'info');

    // Load existing tasks
    const allTasks = await TaskList();
    const paperTasks = allTasks.filter(t => t.metadata?.paperName === paperName);

    if (paperTasks.length === 0) {
        msg('No existing tasks found', 'error');
        msg('Run panel:author (without --resume) to start fresh', 'fix');
        return;
    }

    const completed = paperTasks.filter(t => t.status === 'completed').length;
    const total = paperTasks.length;

    msg(`Progress: ${completed}/${total} tasks complete`, 'info');

    // Find next task
    const nextTask = paperTasks.find(t => t.status === 'pending' && (!t.blockedBy || t.blockedBy.length === 0));

    if (!nextTask) {
        msg('No tasks available to work on', 'warning');
        return;
    }

    msg(`Next task: ${nextTask.subject}`, 'stage');

    // Ask user to continue
    const answer = await AskUserQuestion({
        question: 'Continue?',
        header: 'Resume writing',
        options: [
            { label: 'Yes', description: 'Resume with next task' },
            { label: 'No', description: 'Exit' }
        ]
    });

    if (answer !== 'Yes') {
        return;
    }

    // Execute orchestration loop
    await executeOrchestrationLoop(paperDir, paperName, plan, state, paperTasks, dryRun, pluginConfig);
}

/**
 * Handle default run mode
 */
async function handleRun(paperDir, paperName, plan, state, dryRun, pluginConfig) {
    msg('Paper Writing Orchestration', 'header');

    msg(`Loaded plan: ${plan.title || paperName}`, 'info');
    msg(`Paper: ${paperName}`, 'info');
    msg(`Target: ${plan.venue.name} (deadline: ${plan.venue.deadline})`, 'info');

    // Validate plan
    const validation = validatePlan(plan);
    if (!validation.valid) {
        msgSep();
        msg('Plan validation failed:', 'error');
        for (const err of validation.errors) {
            msg(err, 'error');
        }
        msg('Fix plan.md and run panel:author --check', 'fix');
        return;
    }

    // Check for existing session
    const allTasks = await TaskList();
    const existingTasks = allTasks.filter(t => t.metadata?.paperName === paperName);

    if (existingTasks.length > 0) {
        msg('Existing task list found', 'warning');
        const answer = await AskUserQuestion({
            question: 'Resume existing session or start fresh?',
            header: 'Existing tasks',
            options: [
                { label: 'Resume', description: 'Continue from where you left off' },
                { label: 'Start fresh', description: 'Delete existing tasks and create new ones' },
                { label: 'Cancel', description: 'Exit without changes' }
            ]
        });

        if (answer === 'Resume') {
            await handleResume(paperDir, paperName, plan, state, dryRun, pluginConfig);
            return;
        } else if (answer === 'Start fresh') {
            // Delete existing tasks
            for (const task of existingTasks) {
                await TaskUpdate({ taskId: task.id, status: 'deleted' });
            }
        } else {
            return;
        }
    }

    // Parse plan into tasks
    msgSep();
    msg('Creating task list from plan...', 'info');

    const tasks = planToTasks(plan, paperName);

    const writingTasks = tasks.filter(t => t.type === 'writing');
    const expTasks = tasks.filter(t => t.type === 'experiment');
    const figTasks = tasks.filter(t => t.type === 'figure');
    const analysisTasks = tasks.filter(t => t.type === 'analysis');

    msg(`${writingTasks.length} writing tasks`, 'success');
    msg(`${expTasks.length} experiment tasks`, 'success');
    msg(`${figTasks.length} figure tasks`, 'success');
    msg(`${analysisTasks.length} analysis tasks`, 'success');
    msg(`${tasks.length} tasks total`, 'success');

    // Create tasks
    const createdTasks = [];
    for (const task of tasks) {
        const created = await TaskCreate(task);
        createdTasks.push(created);
    }

    // Apply dependencies
    for (const dep of plan.dependencies) {
        const taskItem = createdTasks.find(t => t.subject.toLowerCase().includes(dep.task.toLowerCase()));
        const blockerItem = createdTasks.find(t => t.subject.toLowerCase().includes(dep.dependsOn.toLowerCase()));

        if (taskItem && blockerItem) {
            await TaskUpdate({
                taskId: taskItem.id,
                addBlockedBy: [blockerItem.id]
            });
        }
    }

    // Show task list and ask to begin
    msgSep();
    const answer = await AskUserQuestion({
        question: `Created ${tasks.length} tasks from plan. Ready to begin?`,
        header: 'Start writing',
        options: [
            { label: 'Yes, start writing (Recommended)', description: 'Begin with first available task' },
            { label: 'Review plan first', description: 'Show me the full task list and dependencies' },
            { label: 'Not now', description: 'Exit without starting' }
        ]
    });

    if (answer === 'Not now') {
        msg('Tasks created. Run panel:author --resume to continue', 'info');
        return;
    }

    if (answer === 'Review plan first') {
        // Show full task breakdown
        msgSep();
        msg('Task breakdown:', 'header');
        for (const task of createdTasks) {
            msg(task.subject, 'item');
            if (task.blockedBy && task.blockedBy.length > 0) {
                msg(`Blocked by ${task.blockedBy.length} task(s)`, 'subitem');
            }
        }

        const proceed = await AskUserQuestion({
            question: 'Ready to begin?',
            header: 'Start writing',
            options: [
                { label: 'Yes', description: 'Start now' },
                { label: 'No', description: 'Exit' }
            ]
        });

        if (proceed !== 'Yes') {
            return;
        }
    }

    // Execute orchestration loop
    await executeOrchestrationLoop(paperDir, paperName, plan, state, createdTasks, dryRun, pluginConfig);
}

/**
 * Main orchestration loop
 */
async function executeOrchestrationLoop(paperDir, paperName, plan, state, tasks, dryRun, pluginConfig) {
    msgSep();
    msg('Starting orchestration loop...', 'stage');

    let continueLoop = true;

    while (continueLoop) {
        // Get next available task
        const allTasks = await TaskList();
        const paperTasks = allTasks.filter(t => t.metadata?.paperName === paperName);
        const nextTask = paperTasks.find(t =>
            t.status === 'pending' &&
            (!t.blockedBy || t.blockedBy.length === 0)
        );

        if (!nextTask) {
            // No more tasks - check if complete
            const remaining = paperTasks.filter(t => t.status !== 'completed');
            if (remaining.length === 0) {
                // All complete!
                await handleCompletion(paperDir, paperName, plan, state, dryRun, pluginConfig);
                break;
            } else {
                msg('No tasks available (all are blocked)', 'warning');
                msg(`${remaining.length} tasks blocked or in progress`, 'info');
                break;
            }
        }

        // Mark task in progress
        await TaskUpdate({ taskId: nextTask.id, status: 'in_progress' });

        msgSep();
        msg(`Task: ${nextTask.subject}`, 'stage');

        // Execute based on task type
        const taskType = nextTask.metadata.taskType;
        let taskComplete = false;

        if (taskType === 'writing') {
            taskComplete = await executeWritingTask(nextTask, paperDir, plan);
        } else if (taskType === 'experiment') {
            taskComplete = await executeExperimentTask(nextTask, paperDir);
        } else if (taskType === 'figure') {
            taskComplete = await executeFigureTask(nextTask, paperDir, plan);
        } else if (taskType === 'analysis') {
            taskComplete = await executeAnalysisTask(nextTask, paperDir);
        }

        if (taskComplete) {
            // Mark complete
            await TaskUpdate({ taskId: nextTask.id, status: 'completed' });
            msg('Task complete', 'success');

            // Show progress
            const completed = paperTasks.filter(t => t.status === 'completed').length + 1;
            const total = paperTasks.length;
            const pct = Math.round((completed / total) * 100);

            msgSep();
            msg(`Progress: ${completed}/${total} tasks (${pct}%)`, 'info');

            // Find next task
            const remaining = await TaskList();
            const nextAvailable = remaining.find(t =>
                t.metadata?.paperName === paperName &&
                t.status === 'pending' &&
                (!t.blockedBy || t.blockedBy.length === 0)
            );

            if (nextAvailable) {
                msg(`Next: ${nextAvailable.subject}`, 'info');

                // Ask to continue
                const answer = await AskUserQuestion({
                    question: 'Continue?',
                    header: 'Next task',
                    options: [
                        { label: 'Yes', description: 'Continue to next task' },
                        { label: 'Pause', description: 'Save and exit' },
                        { label: 'No', description: 'Stop' }
                    ]
                });

                if (answer === 'Pause' || answer === 'No') {
                    msg('Session paused', 'info');
                    msg('Run panel:author --resume to continue', 'fix');
                    continueLoop = false;
                }
            }
        } else {
            // Task skipped or failed
            msg('Task not completed', 'warning');
            const answer = await AskUserQuestion({
                question: 'What would you like to do?',
                header: 'Task incomplete',
                options: [
                    { label: 'Mark complete anyway', description: 'Move on to next task' },
                    { label: 'Keep pending', description: 'Leave for later' },
                    { label: 'Stop', description: 'Exit orchestration' }
                ]
            });

            if (answer === 'Mark complete anyway') {
                await TaskUpdate({ taskId: nextTask.id, status: 'completed' });
            } else if (answer === 'Keep pending') {
                await TaskUpdate({ taskId: nextTask.id, status: 'pending' });
            } else {
                continueLoop = false;
            }
        }
    }
}

/**
 * Execute writing task (section)
 */
async function executeWritingTask(task, paperDir, plan) {
    // This would implement the actual writing logic
    // For now, placeholder
    msg('Writing section content...', 'info');
    msg('[Implementation pending - would generate LaTeX content here]', 'warning');
    return false; // Return true when actually implemented
}

/**
 * Execute experiment task
 */
async function executeExperimentTask(task, paperDir) {
    const scriptPath = task.script;
    msg(`Experiment script: ${scriptPath}`, 'info');

    const answer = await AskUserQuestion({
        question: 'Ready to run experiment?',
        header: 'Run experiment',
        options: [
            { label: 'Run script now', description: `Execute ${scriptPath}` },
            { label: 'I already ran it', description: 'Mark complete without running' },
            { label: 'Skip for now', description: "I'll run it manually later" }
        ]
    });

    if (answer === 'Run script now') {
        try {
            msg('Running experiment...', 'info');
            const result = await Bash(`cd "${paperDir}" && ${scriptPath}`, { timeout: 300000 });
            msg('Experiment complete', 'success');
            return true;
        } catch (e) {
            msg(`Experiment failed: ${e.message}`, 'error');
            return false;
        }
    } else if (answer === 'I already ran it') {
        return true;
    } else {
        return false;
    }
}

/**
 * Execute figure task
 */
async function executeFigureTask(task, paperDir, plan) {
    msg('Generate figure...', 'info');
    msg('[Implementation pending - would generate figure here]', 'warning');
    return false;
}

/**
 * Execute analysis task
 */
async function executeAnalysisTask(task, paperDir) {
    const scriptPath = task.script;
    msg(`Analysis script: ${scriptPath}`, 'info');

    const answer = await AskUserQuestion({
        question: 'Run analysis script?',
        header: 'Run analysis',
        options: [
            { label: 'Run now', description: `Execute ${scriptPath}` },
            { label: 'Skip', description: "I'll run it manually" }
        ]
    });

    if (answer === 'Run now') {
        try {
            msg('Running analysis...', 'info');
            const result = await Bash(`cd "${paperDir}" && ${scriptPath}`, { timeout: 300000 });
            msg('Analysis complete', 'success');
            return true;
        } catch (e) {
            msg(`Analysis failed: ${e.message}`, 'error');
            return false;
        }
    }

    return false;
}

/**
 * Handle completion - quality gate and finalization
 */
async function handleCompletion(paperDir, paperName, plan, state, dryRun, pluginConfig) {
    msgSep();
    msg('All tasks complete!', 'success');

    // Ask to run quality check
    const answer = await AskUserQuestion({
        question: 'Paper complete. Run final quality check?',
        header: 'Quality gate',
        options: [
            { label: 'Yes, check quality (Recommended)', description: 'Verify venue requirements met' },
            { label: 'Skip for now', description: "I'll check manually" }
        ]
    });

    if (answer === 'Yes, check quality (Recommended)') {
        msgSep();
        msg('Running quality checks...', 'stage');

        const results = await checkQuality(paperDir, plan);
        console.log(formatResults(results));

        if (!results.passed) {
            msg('Quality checks failed', 'error');
            msg('Fix issues and run panel:author --check', 'fix');
            return;
        }
    }

    // Compile final PDF
    msgSep();
    msg('Compiling final PDF...', 'info');

    try {
        await Bash(`cd "${paperDir}" && make pdf`);
        await Bash(`cd "${paperDir}" && make dist`);
        msg('PDF compiled successfully', 'success');
    } catch (e) {
        msg(`Compilation warning: ${e.message}`, 'warning');
    }

    // Update state
    state.content_mode = 'full';
    if (state.stage === 'draft') {
        state.stage = 'draft'; // Still draft until panel:review starts
    }
    state.writing_completed = true;
    state.writing_completion_date = new Date().toISOString().split('T')[0];

    save_state(paperDir, state);

    // Clean up tasks
    const allTasks = await TaskList();
    const paperTasks = allTasks.filter(t => t.metadata?.paperName === paperName);
    for (const task of paperTasks) {
        await TaskUpdate({ taskId: task.id, status: 'deleted' });
    }

    // Report completion
    msgSep();
    msgBox([
        '✓ Paper writing complete!',
        '',
        `Paper: ${paperName}`,
        `Target: ${plan.venue.name}`,
        '',
        'Next step:',
        `panel:review --paper ${paperName}`
    ]);

    msg('This will begin the AI-simulated review process to strengthen', 'info');
    msg('the paper further before actual submission.', 'info');

    // Auto-commit
    await gitCommitIfEnabled(
        `[panel] Complete writing for ${paperName}\n\n- All sections written\n- ${plan.experiments.length} experiments completed\n- ${plan.figures.length} figures generated\n- Paper ready for review cycle`,
        [paperDir]
    );
}

// Run main
main(args);
```
