# Batch & Parallel Operations

**Purpose**: Enable batch processing of papers with parallel agent execution for authoring and reviewing at scale.

**Craft Pattern**: Master/Worker architecture - one orchestrator agent spawns multiple worker agents that execute in parallel.

---

## Use Cases

### 1. Auto-Setup from plan.md Files

**Scenario**: You have multiple directories with plan.md files but no _panel.yaml yet.

```
research/
├── paper-auth-methods/
│   └── plan.md              ← Has plan, needs setup
├── paper-distributed-systems/
│   └── plan.md              ← Has plan, needs setup
└── paper-ml-optimization/
    └── plan.md              ← Has plan, needs setup
```

**Command**:
```bash
panel:setup --scan
# OR
panel:setup --discover
```

**Behavior**:
- Scan all directories in research/
- Find any with plan.md but no _panel.yaml
- Show list of discovered papers
- Ask: "Setup all 3 papers?"
- Initialize each paper sequentially

### 2. Batch Authoring

**Scenario**: Multiple papers have plan.md and are ready to be written.

**Command**:
```bash
panel:author --all
# OR
panel:author --batch 1 2 3        # Specific papers by number
panel:author --batch auth ml      # Specific papers by slug
```

**Behavior**:
- Discover all papers with plan.md
- Filter to papers that haven't started authoring (writing_completed != true)
- Spawn **parallel agents** (one per paper)
- Each agent runs panel:author independently
- Master agent aggregates results

### 3. Batch Reviewing

**Scenario**: Multiple papers are at draft stage and ready for review.

**Command**:
```bash
panel:review --all
# OR
panel:review --batch 1 2 3        # Specific papers
```

**Behavior**:
- Discover all papers at stage: draft
- Spawn **parallel agents** (one per paper)
- Each agent runs full review cycle
- Master agent monitors progress

---

## Architecture

### Master/Worker Pattern

```
Master Agent (Orchestrator)
├── Discover eligible papers
├── Show plan to user
├── Spawn worker agents in parallel
├── Monitor progress
└── Aggregate results

Worker Agent 1: panel:author --paper 01
Worker Agent 2: panel:author --paper 02
Worker Agent 3: panel:author --paper 03
  ↓ (all run in parallel)
Results aggregated by master
```

### Parallelization via Task Tool

```javascript
// Master orchestrator
const papers = discoverEligiblePapers();

// Spawn parallel agents
const agents = papers.map(paper => {
    return Task({
        subagent_type: 'general-purpose',
        description: `Author paper ${paper.slug}`,
        prompt: `Run panel:author --paper ${paper.order} to completion.`,
        run_in_background: true  // Non-blocking
    });
});

// Wait for all to complete
const results = await Promise.all(agents.map(a => TaskOutput(a.id)));

// Report aggregated results
reportBatchResults(results);
```

---

## Command Specifications

### panel:setup --scan

**Purpose**: Discover and setup papers with plan.md files.

**Behavior**:

1. **Discovery Phase**:
   ```javascript
   const dirs = fs.readdirSync('research/');
   const withPlan = dirs.filter(dir => {
       const planPath = `research/${dir}/plan.md`;
       const yamlPath = `research/${dir}/_panel.yaml`;
       return fs.existsSync(planPath) && !fs.existsSync(yamlPath);
   });
   ```

2. **Show Discovery**:
   ```
   📄 Panel: Setup Scan
   ═══════════════════════════════════════

   Found 3 papers with plan.md (not yet setup):
     • paper-auth-methods
     • paper-distributed-systems
     • paper-ml-optimization
   ```

3. **Ask User**:
   ```javascript
   AskUserQuestion({
       question: "Setup all 3 papers?",
       header: "Batch Setup",
       options: [
           { label: "Yes, setup all (Recommended)", description: "Initialize all discovered papers" },
           { label: "Select specific papers", description: "Choose which to setup" },
           { label: "Skip", description: "Don't setup any" }
       ]
   });
   ```

4. **Execute Setup**:
   - For each paper, run per-paper setup (Level 2)
   - Extract venue from plan.md if specified
   - Generate _panel.yaml with UUID
   - Update RESEARCH.md with all new papers

5. **Report**:
   ```
   ✓ Setup complete: 3 papers initialized

   Next step: panel:author --all
   ```

---

### panel:author --all

**Purpose**: Author all papers with plan.md in parallel.

**Arguments**:
- `--all` — Process all eligible papers
- `--batch <refs>` — Process specific papers (e.g., "1 2 3" or "auth ml")
- `--sequential` — Run one at a time (default: parallel)
- `--dry-run` — Show what would be processed

**Behavior**:

1. **Discovery Phase**:
   ```javascript
   const papers = loadPaperIndex();
   const eligible = papers.filter(p => {
       const planPath = `research/${p.directory}/plan.md`;
       const panelYaml = readYAML(`research/${p.directory}/_panel.yaml`);
       return fs.existsSync(planPath) && !panelYaml.writing_completed;
   });
   ```

2. **Show Plan**:
   ```
   📄 Panel: Batch Authoring
   ═══════════════════════════════════════

   Eligible papers: 3

     01 — review-methodology
          plan.md: ✓ (12 sections, 3 experiments)

     02 — reviewer-calibration
          plan.md: ✓ (8 sections, 2 experiments)

     04 — synthesis-methods
          plan.md: ✓ (10 sections, 1 experiment)

   Estimated time: ~2-4 hours (parallel execution)
   ```

3. **Ask User**:
   ```javascript
   AskUserQuestion({
       question: "Start batch authoring for 3 papers?",
       header: "Parallel Authoring",
       options: [
           { label: "Yes, parallel (Recommended)", description: "All papers at once" },
           { label: "Yes, sequential", description: "One at a time" },
           { label: "Select papers", description: "Choose which to author" },
           { label: "Skip", description: "Cancel" }
       ]
   });
   ```

4. **Spawn Parallel Agents** (if parallel mode):
   ```javascript
   const agents = [];

   for (const paper of eligible) {
       const agent = await Task({
           subagent_type: 'general-purpose',
           description: `Author ${paper.slug}`,
           prompt: `
               Run panel:author for paper ${paper.order} (${paper.slug}).

               Context:
               - Paper directory: research/${paper.directory}
               - Plan file: research/${paper.directory}/plan.md
               - Target venue: ${paper.venue}

               Execute the full authoring workflow:
               1. Parse plan.md
               2. Create task list
               3. Write all sections
               4. Run experiments
               5. Generate figures
               6. Run quality checks
               7. Mark paper as complete

               Work autonomously until the paper is complete or blocked.
           `,
           run_in_background: true
       });

       agents.push({ paper, agentId: agent.id });
   }
   ```

5. **Monitor Progress**:
   ```
   ═══════════════════════════════════════
   Batch Authoring Progress
   ═══════════════════════════════════════

   01 — review-methodology     [██████░░░░] 60% (6/10 tasks)
   02 — reviewer-calibration   [████░░░░░░] 40% (3/8 tasks)
   04 — synthesis-methods      [████████░░] 80% (8/10 tasks)

   Refreshing every 30s... (Press Ctrl+C to stop monitoring)
   ```

6. **Aggregate Results**:
   ```javascript
   const results = await Promise.all(
       agents.map(a => TaskOutput({ task_id: a.agentId }))
   );

   const completed = results.filter(r => r.status === 'completed');
   const failed = results.filter(r => r.status === 'failed');
   ```

7. **Report**:
   ```
   ═══════════════════════════════════════
   ✓ Batch Authoring Complete
   ═══════════════════════════════════════

   Completed: 3 papers
   Failed: 0 papers

   Papers ready for review:
     ✓ 01 — review-methodology (7,200 words, 42 refs)
     ✓ 02 — reviewer-calibration (6,800 words, 38 refs)
     ✓ 04 — synthesis-methods (8,100 words, 51 refs)

   Next step: panel:review --all
   ```

---

### panel:review --all

**Purpose**: Review all papers at draft stage in parallel.

**Arguments**:
- `--all` — Process all eligible papers
- `--batch <refs>` — Process specific papers
- `--sequential` — Run one at a time (default: parallel)
- `--dry-run` — Show what would be processed

**Behavior**:

1. **Discovery Phase**:
   ```javascript
   const papers = loadPaperIndex();
   const eligible = papers.filter(p => {
       const panelYaml = readYAML(`research/${p.directory}/_panel.yaml`);
       return panelYaml.stage === 'draft' || panelYaml.stage === 'recheck';
   });
   ```

2. **Show Plan**:
   ```
   📄 Panel: Batch Reviewing
   ═══════════════════════════════════════

   Eligible papers: 3

     01 — review-methodology    (stage: draft, 7,200 words)
     02 — reviewer-calibration  (stage: draft, 6,800 words)
     04 — synthesis-methods     (stage: draft, 8,100 words)

   Estimated time: ~1-2 hours per paper (parallel execution)
   ```

3. **Ask User**:
   ```javascript
   AskUserQuestion({
       question: "Start batch review for 3 papers?",
       header: "Parallel Review",
       options: [
           { label: "Yes, parallel (Recommended)", description: "All papers at once" },
           { label: "Yes, sequential", description: "One at a time" },
           { label: "Select papers", description: "Choose which to review" }
       ]
   });
   ```

4. **Spawn Parallel Agents**:
   ```javascript
   const agents = [];

   for (const paper of eligible) {
       const agent = await Task({
           subagent_type: 'general-purpose',
           description: `Review ${paper.slug}`,
           prompt: `
               Run panel:review for paper ${paper.order} (${paper.slug}).

               Execute the full review cycle:
               1. Assemble reviewer panel (5+ reviewers)
               2. Generate individual reviews
               3. Create synthesis with P1/P2/P3 items
               4. Move to revision stage if passing

               Work autonomously until reviews are complete.
           `,
           run_in_background: true
       });

       agents.push({ paper, agentId: agent.id });
   }
   ```

5. **Monitor Progress**:
   ```
   ═══════════════════════════════════════
   Batch Review Progress
   ═══════════════════════════════════════

   01 — review-methodology     Stage: panel    (3/5 reviews)
   02 — reviewer-calibration   Stage: panel    (4/5 reviews)
   04 — synthesis-methods      Stage: synthesis (complete)

   Refreshing every 60s...
   ```

6. **Report**:
   ```
   ═══════════════════════════════════════
   ✓ Batch Review Complete
   ═══════════════════════════════════════

   Completed: 3 papers

   Review summaries:

     01 — review-methodology
          Avg score: 3.2/4 (Strong Accept)
          P1 items: 2 | P2 items: 5 | P3 items: 8
          Stage: revision

     02 — reviewer-calibration
          Avg score: 2.8/4 (Weak Accept)
          P1 items: 4 | P2 items: 7 | P3 items: 6
          Stage: revision

     04 — synthesis-methods
          Avg score: 3.4/4 (Strong Accept)
          P1 items: 1 | P2 items: 3 | P3 items: 9
          Stage: revision

   Next step: Address P1 items in each paper
   ```

---

## Sequential vs Parallel Trade-offs

### Parallel Mode (Default)

**Pros**:
- Much faster (3 papers in ~2 hours instead of ~6 hours)
- Utilizes multiple agents efficiently
- Better for large batches (5+ papers)

**Cons**:
- Higher token usage (multiple concurrent agents)
- Can't interactively review each paper
- Harder to debug if issues occur

**When to use**:
- Large batches (3+ papers)
- Papers are independent
- Want maximum speed

### Sequential Mode

**Pros**:
- Lower token usage
- Can review/intervene between papers
- Easier debugging
- See progress step-by-step

**Cons**:
- Much slower (linear time)
- Underutilizes system

**When to use**:
- Small batches (1-2 papers)
- Want to review output between papers
- Testing/debugging

---

## Implementation Plan

### Phase 1: Add Batch Discovery

1. Create `shared/batch-utils.md`:
   - `discoverPapersWithPlan(researchDir)` — Find plan.md files
   - `discoverEligibleForAuthoring(papers)` — Filter ready for authoring
   - `discoverEligibleForReview(papers)` — Filter ready for review

2. Update `commands/setup.md`:
   - Add `--scan` flag
   - Implement batch setup logic

### Phase 2: Add Batch Authoring

1. Update `commands/author.md`:
   - Add `--all` and `--batch` flags
   - Add discovery logic
   - Add sequential execution
   - Test with 2-3 papers

### Phase 3: Add Parallel Execution

1. Update `commands/author.md`:
   - Add parallel agent spawning via Task tool
   - Add progress monitoring
   - Add result aggregation
   - Test with 3-5 papers

2. Update `commands/review.md`:
   - Same as author.md
   - Parallel review execution

### Phase 4: Add Batch Reviewing

1. Update `commands/review.md`:
   - Add `--all` and `--batch` flags
   - Implement parallel review
   - Test full workflow: setup → author → review (all in batch)

---

## Example Workflow

### End-to-End Batch Processing

```bash
# Step 1: Create plan.md files for 5 papers
cd research/
mkdir paper-auth-methods paper-distributed-systems paper-ml-optimization
# ... create plan.md in each ...

# Step 2: Auto-discover and setup all papers
panel:setup --scan
# Output: Found 3 papers, setup all? → Yes
# Result: 3 papers initialized with UUIDs

# Step 3: Batch author all papers (parallel)
panel:author --all
# Output: Found 3 papers ready for authoring
# Spawns 3 parallel agents
# Result: 3 papers completed (~2 hours)

# Step 4: Batch review all papers (parallel)
panel:review --all
# Output: Found 3 papers at draft stage
# Spawns 3 parallel agents
# Result: 3 papers reviewed with P1/P2/P3 items

# Step 5: Ship all papers
git add research/
git commit -m "[panel] Batch authored and reviewed 3 papers"
git push
./scripts/sync-to-research.sh --push
```

Total time: ~3-4 hours for 3 complete papers (vs ~9-12 hours sequential)

---

## Craft Patterns Applied

✅ **Master/Worker Architecture**: Single orchestrator, multiple workers
✅ **Parallel Agent Spawning**: Task tool with run_in_background
✅ **Progress Monitoring**: Non-blocking status checks via TaskOutput
✅ **Result Aggregation**: Collect and report all worker results
✅ **Error Handling**: Graceful failure reporting per paper
✅ **User Control**: Interactive prompts before batch operations
✅ **Dry Run Support**: Preview before execution

---

## Future Enhancements

1. **Resume Support**: If batch fails, resume from last completed paper
2. **Dependency-Aware**: Sequence papers that depend on each other
3. **Resource Limits**: Limit parallel agents (e.g., max 5 at once)
4. **Progress Persistence**: Save progress to allow pause/resume
5. **Notification**: Notify when batch completes (Slack, email)

---

## See Also

- Task tool documentation (for parallel agent spawning)
- panel:author command (single-paper authoring)
- panel:review command (single-paper review)
- Waves batch operations (similar patterns)
