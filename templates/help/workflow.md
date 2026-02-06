# Help: Typical Workflow

## Getting Started

```bash
# 1. Initialize panel in your research project
panel:setup

# 2. Set venue for each paper (edit _panel.yaml)
# 3. Run the review lifecycle
panel:go --paper my-paper

# 4. Check status
panel:status
```

## Full Lifecycle Walkthrough

### Step 1: Setup
Run `panel:setup` in your research project root. This creates `_panel.yaml` files for each paper and copies the reviewer database.

### Step 2: Set Venues
Edit each paper's `_panel.yaml` to set the `venue` field (e.g., "CHI 2026", "NeurIPS D&B").

### Step 3: First Review Cycle
Run `panel:go` to start the lifecycle. The plugin will:
1. Select 5 reviewers matched to your paper's topic and venue
2. Generate individual reviews with scores and detailed feedback
3. Consolidate into a synthesis with P1/P2/P3 classification

### Step 4: Interpret Results
Run `panel:show --paper my-paper` to see detailed results. Focus on:
- P1 items (blocking — must address)
- Score distribution (where do reviewers agree/disagree?)
- Areas of strength (what to preserve)

### Step 5: Revise
Address P1 items first. The revision plan (`REVISION-PLAN.md`) tracks progress. Mark items as addressed in `_panel.yaml`.

### Step 6: Recheck
Run `panel:go` again. The plugin picks up from revision stage, generates round 2 reviews, and checks if scores meet thresholds.

### Step 7: Iterate
If scores don't pass (avg < 2.5/4 or any < 2/4), the plugin loops back to synthesis for another round. Repeat until ready.

### Step 8: Submission
Once all reviewers accept, `panel:venue` recommends submission strategy. Confirm submission when ready.

## Tips

- Run `panel:go --until synthesis` to stop after the first review round
- Use `panel:go --dry-run` to preview what would happen
- Check `panel:status` regularly for a portfolio overview
- Use `panel:report --portfolio` for a shareable summary
