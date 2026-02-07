---
format_version: "4.0"
---

# Waves Quick Reference

## Reference Syntax
```
^14              Wave by order number
^command-expansion  Wave by slug
^04ab85          Wave by UUID (6 chars)

~1               Pulse by order (within active wave)
~setup           Pulse by slug
~dfadb0          Pulse by UUID
```

## Essential Commands
```
/waves:setup     Initialize waves in project
/waves:start     Create new wave
/waves:run ^14   Execute wave (starts with planning review)
/waves:run ~1    Execute single pulse
/waves:status    Quick overview
/waves:show ^14  Detailed wave view
/waves:switch    Change active project/wave
/waves:edit ^14  Modify wave properties
/waves:cancel ^14  Cancel wave (creates backup)
/waves:archive ^14 Archive completed wave
/waves:sync      Git sync with conflict resolution
/waves:help      This help system
```

## Wave Lifecycle
```
Planning → Design → Execution → Validation → Documentation
    ↓         ↓         ↓           ↓            ↓
 Review    Review    Review     Review       Review
(blocking) (blocking) (non-block) (blocking)  (blocking)
```

## Stage Commands
```
/waves:run ^14 --stage planning     # Planning review only
/waves:run ^14 --stage design       # Design stage only
/waves:review ^14 --stage design    # Run design review
```

## Pulse Stages (in frontmatter)
```yaml
stage: design        # Runs during Design stage
stage: execution     # Runs during Execution stage
stage: validation    # Runs during Validation stage
stage: documentation # Runs during Documentation stage
```

## Directory Structure
```
context/waves/
├── _config/
│   ├── wave-index.yaml    # Wave registry + active wave
│   ├── settings.yaml      # Project settings
│   ├── sync-state.yaml    # Git sync tracking
│   ├── disciplines/       # Role definitions
│   └── roles/             # Composite roles
├── _archive/              # Archived completed waves
│   ├── index.yaml         # Archive registry
│   └── 2026-Q1/           # Quarterly organization
├── _cancelled/            # Cancelled wave backups
│   └── {timestamp}-{slug}/
└── 14+command-expansion/  # Wave directory
    ├── wave.md            # Wave overview
    ├── _meta.yaml         # Wave metadata
    └── pulses/            # Pulse files
```

## Settings Locations
```
~/.claude/waves-settings.yaml   # Installation (user)
_config/settings.yaml           # Project (overrides)
```

## Environment Variables (CI/CD)
```
WAVES_PROJECT=myproject
WAVES_ACTIVE_WAVE=04ab85
WAVES_NON_INTERACTIVE=1
```

## Common Workflows

**Start new feature:**
```
/waves:start → /waves:run ^N → /waves:complete ^N
```

**Resume work:**
```
/waves:status → /waves:switch ^N → /waves:run ~pulse
```

**Review iteration:**
```
/waves:review ^N --stage design --iteration 2
```

**Cancel wave (creates backup):**
```
/waves:cancel ^N --reason "Requirements changed"
# Recover: copy from _cancelled/{timestamp}-{slug}/
```

**Archive completed wave:**
```
/waves:archive ^N
# Moves to _archive/2026-Q1/{wave-dir}/
```

**Sync with git:**
```
/waves:sync --pull            # Pull changes
/waves:sync --push            # Push changes
/waves:sync --both            # Bidirectional
/waves:sync --fail-on-conflict  # CI/CD mode
```

**Apply composite role:**
```
/waves:act-as portal-shell-developer
```
