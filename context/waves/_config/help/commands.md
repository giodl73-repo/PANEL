---
format_version: "4.0"
---

# Waves Commands Reference

## Primary Workflow (Wave 19+)

The primary workflow uses just two commands:

```bash
/waves:start                    # Create new wave with planning
/waves:run                      # Full lifecycle to completion
```

The run command handles: stage progression, reviews, completion, and postmortem.

---

## Core Commands

### /waves:setup
Initialize waves in a project.

```bash
/waves:setup                    # Interactive setup wizard
/waves:setup --add-project      # Add project to existing installation
```

### /waves:start
Create a new wave.

```bash
/waves:start                    # Interactive wave creation
/waves:start "Feature Name"     # Create with name
```

### /waves:run (Unified Orchestrator)
Execute wave lifecycle from current stage to completion.

```bash
# Full lifecycle (recommended)
/waves:run                      # Run active wave through all stages
/waves:run ^14                  # Run wave 14 through all stages

# Fine-grained control
/waves:run --until execution    # Stop after execution review
/waves:run --stage design       # Run design stage only
/waves:run --dry-run            # Preview what would happen
/waves:run --resume             # Resume interrupted run

# Pulse mode
/waves:run ~1                   # Run pulse 1 of active wave
/waves:run ~setup               # Run pulse by slug

# Skip options
/waves:run --no-review          # Skip stage reviews (fast mode)
/waves:run --no-complete        # Don't auto-complete
/waves:run --no-postmortem      # Skip postmortem generation
/waves:run --confirm            # Pause before completion
```


---

## Navigation Commands

### /waves:status
Quick overview of current state.

```bash
/waves:status                   # Show active project and wave
```

Output:
```
───────────────────────────────────────────────
 Project: waves | Wave: ^14+command-expansion
───────────────────────────────────────────────
Status: In Design (3/10 pulses complete)
Next: ~4 help-system
Blocked: None
```

### /waves:show
Detailed view of wave or pulse.

```bash
/waves:show ^14                 # Full wave details
/waves:show ~1                  # Full pulse details
/waves:show                     # Show active wave
```

### /waves:switch
Change active context.

```bash
/waves:switch                   # Interactive selection
/waves:switch ^14               # Switch to wave 14
/waves:switch --project myproj  # Switch project
```

### /waves:help
Interactive help system.

```bash
/waves:help                     # Interactive topic menu
/waves:help concepts            # Show concepts
/waves:help commands            # Show this page
/waves:help --quick             # Quick reference card
```

---

## Validation Commands

### /waves:validate
Validate metadata and fix issues.

```bash
/waves:validate                 # Validate all waves
/waves:validate ^14             # Validate wave 14
/waves:validate --fix           # Preview and apply fixes (with confirmation)
/waves:validate --fix --force   # Apply fixes without confirmation
/waves:validate --strict        # Treat warnings as errors
```

---

## Advanced Commands

### /waves:import
Import commits as pulses.

```bash
/waves:import                   # Interactive import
/waves:import --commits 5       # Import last 5 commits
```

### /waves:postmortem
Generate wave retrospective.

```bash
/waves:postmortem ^14           # Analyze completed wave
```

### /waves:optimize
Optimize wave documentation.

```bash
/waves:optimize ^14             # Optimize wave 14 docs
```

### /waves:prompt
Generate AI prompts from wave context.

```bash
/waves:prompt ^14               # Generate implementation prompts
```

### /waves:act-as
Apply discipline for role-based work.

```bash
/waves:act-as backend           # Apply backend discipline
/waves:act-as skills            # Apply skills discipline
```

---

## Command Flags

### Common Flags

| Flag | Description |
|------|-------------|
| `--project` | Specify project (default: auto-detect) |
| `--stage` | Specify stage (planning, design, execution, validation, documentation) |
| `--iteration` | Review iteration number |
| `--fix` | Apply fixes (for validate) |
| `--force` | Skip confirmation prompts |
| `--quick` | Show condensed output |

---

## Reference Syntax

### Wave References (^)
```
^14                    # Order number
^command-expansion     # Slug
^04ab85                # UUID (6 chars)
```

### Pulse References (~)
```
~1                     # Order (within active wave)
~setup                 # Slug
~dfadb0                # UUID (6 chars)
```

---

## See Also

- `/waves:help workflows` - Common workflow patterns
- `/waves:help concepts` - Core concepts explained
- `/waves:help troubleshooting` - Common errors and fixes
