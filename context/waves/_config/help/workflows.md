---
format_version: "4.0"
---

# Waves Workflow Patterns

## Workflow 1: Start a New Feature

```bash
# 1. Create the wave
/waves:start "User Authentication"

# 2. Plan pulses and stages
# (Edit the generated wave.md and create pulse files)

# 3. Run from planning
/waves:run ^N

# This will:
#   - Run Planning Review (blocking)
#   - If approved, run Design stage
#   - Run Design Review (blocking)
#   - If approved, run Execution stage
#   - Run Execution Review (non-blocking)
#   - Continue to Validation and Documentation

# 4. Complete the wave
/waves:complete ^N
```

---

## Workflow 2: Resume Work on Existing Wave

```bash
# 1. Check current status
/waves:status

# 2. Switch to the wave if needed
/waves:switch ^14

# 3. See what's next
/waves:show

# 4. Run the next pulse
/waves:run ~next-pulse

# 5. Or run the entire remaining wave
/waves:run ^14
```

---

## Workflow 3: Handle Review Feedback

```bash
# 1. Review says REVISE
/waves:review ^14 --stage design
# Output: "REVISION REQUIRED - 3 issues"

# 2. Address the issues
# (Make changes to design documents)

# 3. Re-run review with iteration
/waves:review ^14 --stage design --iteration 2

# 4. If approved, continue
/waves:run ^14 --stage execution
```

---

## Workflow 4: Work on Single Pulse

```bash
# 1. Check pulse details
/waves:show ~setup

# 2. Run just that pulse
/waves:run ~setup

# 3. Mark complete when done
/waves:complete ~setup
```

---

## Workflow 5: Multi-Project Setup

```bash
# 1. Set up first project
/waves:setup

# 2. Add another project
/waves:setup --add-project

# 3. Switch between projects
/waves:switch --project frontend-app
/waves:switch --project backend-api

# 4. Check which project is active
/waves:status
```

---

## Workflow 6: CI/CD Integration

```bash
# Set environment variables
export WAVES_PROJECT=myproject
export WAVES_ACTIVE_WAVE=04ab85
export WAVES_NON_INTERACTIVE=1

# Run validation
/waves:validate ^14

# Check status programmatically
/waves:status --json
```

---

## Workflow 7: Import Existing Commits

```bash
# 1. Start a wave for the work
/waves:start "Refactoring Sprint"

# 2. Import recent commits as pulses
/waves:import --commits 10

# 3. Review and organize imported pulses
/waves:show ^N
```

---

## Workflow 8: Role-Based Work

```bash
# 1. Apply discipline
/waves:act-as backend

# 2. Work on backend pulses
/waves:run ~api-endpoints

# 3. Switch roles
/waves:act-as frontend
/waves:run ~dashboard-ui
```

---

## Common Patterns

### Check Before Starting
```bash
/waves:status           # What's active?
/waves:show             # What's the current state?
/waves:help --quick     # Quick reference
```

### After Completing Work
```bash
/waves:complete ~pulse  # Mark pulse done
/waves:status           # Check progress
/waves:show             # See updated state
```

### When Stuck
```bash
/waves:help troubleshooting    # Common errors
/waves:validate                # Check for issues
/waves:show ~blocked-pulse     # See dependencies
```

---

## See Also

- `/waves:help commands` - All command details
- `/waves:help stages` - Stage-specific information
- `/waves:help troubleshooting` - Error resolution
