---
format_version: "4.0"
---

# Waves Troubleshooting

## Common Errors

### "Waves not configured"

**Cause**: No `.claude/waves.json` found.

**Fix**:
```bash
/waves:setup
```

---

### "No active project"

**Cause**: waves.json exists but no default project set.

**Fix**:
```bash
/waves:switch --project myproject
# Or set environment variable
export WAVES_PROJECT=myproject
```

---

### "No active wave"

**Cause**: No wave set as active.

**Fix**:
```bash
/waves:switch ^14
# Or set environment variable
export WAVES_ACTIVE_WAVE=04ab85
```

---

### "Wave not found: ^99"

**Cause**: Referenced wave doesn't exist.

**Fix**:
```bash
# List available waves
/waves:status
# Use correct reference
/waves:show ^14
```

---

### "Pulse blocked by dependencies"

**Cause**: Pulse depends on incomplete pulses.

**Fix**:
```bash
# Check what's blocking
/waves:show ~blocked-pulse

# Complete dependencies first
/waves:run ~dependency-pulse
/waves:complete ~dependency-pulse
```

---

### "Review iteration required"

**Cause**: Review returned REVISE, need to address issues.

**Fix**:
```bash
# 1. Check review feedback
cat {waveDir}/{stage}/reviews/

# 2. Address issues

# 3. Re-run with iteration
/waves:review ^14 --stage design --iteration 2
```

---

### "Migration failed"

**Cause**: Error during directory migration to _config/.

**Fix**:
```bash
# Check for backup
ls context/waves/.migration-backup-*

# Rollback if needed
# (Manual: restore from backup directory)

# Re-run command
/waves:status
```

---

### "Context resolution exceeded max depth"

**Cause**: Auto-setup loop (setup fails repeatedly).

**Fix**:
```bash
# 1. Check waves.json manually
cat .claude/waves.json

# 2. Fix any syntax errors

# 3. Ensure wavesPath exists
ls context/waves/
```

---

### "Invalid YAML in settings"

**Cause**: Syntax error in settings file.

**Fix**:
```bash
# Check installation settings
cat ~/.claude/waves-settings.yaml

# Check project settings
cat context/waves/_config/settings.yaml

# Fix YAML syntax (indentation, quotes, etc.)
```

---

### "Cancel backup failed"

**Cause**: Unable to create backup in `_cancelled/` directory.

**Fix**:
```bash
# Check directory permissions
ls -la context/waves/

# Manually create _cancelled directory
mkdir -p context/waves/_cancelled

# Retry cancel
/waves:cancel ^14
```

---

### "Archive verification failed"

**Cause**: Copy-verify-delete pattern detected mismatch.

**Fix**:
```bash
# Check if partial copy exists in _archive
ls context/waves/_archive/2026-Q1/

# Clean up partial archive if exists
rm -rf context/waves/_archive/2026-Q1/14+partial-wave

# Retry archive
/waves:archive ^14
```

---

### "Sync conflict detected"

**Cause**: Local and remote waves have diverged.

**Fix**:
```bash
# View conflict details
/waves:sync --pull

# Option 1: Force local (discard remote)
/waves:sync --pull --force

# Option 2: Force remote (discard local)
/waves:sync --push --force

# Option 3: Manual merge
# Edit the conflicting files, then:
/waves:sync --push
```

---

### "Recover cancelled wave"

**Process**: Cancelled waves are backed up to `_cancelled/`.

**Steps**:
```bash
# List cancelled backups
ls context/waves/_cancelled/

# Copy back to waves directory
cp -r context/waves/_cancelled/2026-02-02T10-30-00-my-wave/ \
      context/waves/14+my-wave/

# Update wave status
/waves:edit ^14 --status "in-progress"
```

---

## Template Issues

### "Template not found"

**Cause**: Invalid template name or template file missing.

**Fix**:
```bash
# List available templates
ls templates/scenarios/

# Valid built-in templates: feature, refactor, foundation, bugfix
/waves:start --template feature
```

---

### "Invalid wave name"

**Cause**: Wave name doesn't meet requirements.

**Requirements**:
- Start with a letter
- 3-50 characters long
- Only letters, numbers, spaces, and hyphens

**Fix**:
```bash
# Bad: "123-feature" (starts with number)
# Bad: "My Feature!!!" (special characters)
# Good: "User Authentication"
# Good: "Fix Login Bug"
```

---

### "UUID collision detected"

**Cause**: Generated UUID matches existing wave/pulse.

**Fix**:
```bash
# Option 1: Auto-resolve (adds numeric suffix)
/waves:start --template feature --auto-resolve

# Option 2: Choose different wave name
# Different names generate different UUIDs

# Option 3: Let wizard guide you
/waves:start
# Select option when prompted
```

---

### "Missing required variable"

**Cause**: Template requires a variable that wasn't provided.

**Fix**:
```bash
# Use interactive wizard (prompts for all variables)
/waves:start

# Or check template requirements
/waves:start --template feature --preview
# Look for "Variables: required" section
```

---

### "Template validation failed"

**Cause**: Custom template doesn't match schema.

**Common Issues**:
| Error | Fix |
|-------|-----|
| Missing `name` | Add `name: "Template Name"` |
| Invalid `slug` | Use lowercase with hyphens only |
| Invalid role | Use standard role or add to `roles` list |
| Circular dependency | Reorder pulse dependencies |

**Validate Template**:
```bash
# Check template structure
cat templates/scenarios/my-template.yaml

# Compare against schema
cat config/schemas/template.schema.yaml
```

---

### "Wizard navigation not working"

**Cause**: Terminal doesn't support keyboard navigation.

**Fix**:
```bash
# Use direct template selection instead
/waves:start --template feature

# Or use numbered options in wizard
# Type number and press Enter
```

---

### "Template preview shows wrong structure"

**Cause**: Template file modified but cached version displayed.

**Fix**:
```bash
# Force reload by using --preview again
/waves:start --template feature --preview

# If still wrong, check the YAML file directly
cat templates/scenarios/feature.yaml
```

---

### "Pulses created in wrong order"

**Cause**: Dependencies not properly defined in template.

**Fix**:
```bash
# Check template dependencies
cat templates/scenarios/feature.yaml | grep -A5 dependencies

# Dependencies should reference earlier pulses:
# dependencies: [~requirements]  # Correct
# dependencies: [requirements]   # Wrong - missing ~
```

---

## Validation Issues

### Run Validation
```bash
/waves:validate ^14
```

### Preview and Apply Fixes
```bash
/waves:validate ^14 --fix      # Shows preview, then asks for confirmation
/waves:validate ^14 --fix --force  # Skip confirmation (for scripts)
```

---

## Getting Help

```bash
/waves:help                    # Interactive help
/waves:help concepts           # Core concepts
/waves:help commands           # All commands
/waves:help --quick            # Quick reference
```

---

## Reporting Issues

If you encounter a bug:
1. Note the exact command and error message
2. Check `context/waves/` structure
3. Report at: https://github.com/anthropics/claude-code/issues
