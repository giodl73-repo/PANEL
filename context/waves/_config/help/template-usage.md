---
format_version: "4.0"
---

# Wave Templates: Usage Guide

Create waves faster using pre-configured templates based on proven patterns from 43+ production waves.

## Quick Start

```bash
# Interactive wizard (recommended for first-time users)
/waves:start

# Direct template selection
/waves:start --template feature

# Preview template before creating
/waves:start --template refactor --preview
```

## Available Templates

| Template | Use Case | Pulses | Hours |
|----------|----------|--------|-------|
| `feature` | New feature development | 9 | 24-48h |
| `refactor` | Architecture changes, code restructuring | 8 | 16-40h |
| `foundation` | Initial project setup, greenfield | 12 | 32-60h |
| `bugfix` | Bug investigation and resolution | 7 | 4-16h |

---

## Interactive Wizard

The wizard guides you through 5 steps:

### Step 1: Mode Selection
Choose between **Template** (recommended) or **Manual** mode.

```
How would you like to create your wave?

  [T] From Template - Start with pre-configured template
  [M] Manual Setup  - Configure everything from scratch

Navigation: [Enter] Select | [Esc] Cancel
```

### Step 2: Category Selection
Templates are organized by purpose:

| Category | Templates |
|----------|-----------|
| **NEW WORK** | feature, foundation |
| **MAINTENANCE** | refactor, bugfix |

### Step 3: Template Selection
Select from available templates with preview:

```
┌─ feature ─────────────────────────────────────────────┐
│ Full-Stack Feature Development                        │
│                                                       │
│ Stages: 4 (design → execution → validation → docs)    │
│ Pulses: 9 total                                       │
│ Hours:  24-48h estimated                              │
│ Roles:  architect, backend, frontend, testing, docs   │
└───────────────────────────────────────────────────────┘
```

### Step 4: Customization
Provide wave-specific details:

- **Wave Name**: Required - becomes the wave title
- **Description**: Optional - additional context
- **Roles**: Optional - modify default role assignments

### Step 5: Confirmation
Review the final structure before creation:

```
Wave Summary:
  Name:      User Authentication
  Template:  feature
  Pulses:    9
  Stages:    design (2), execution (3), validation (2), docs (2)

[C] Create Wave | [B] Back | [Esc] Cancel
```

---

## Direct Template Selection

Skip the wizard with `--template`:

```bash
# Create feature wave directly
/waves:start --template feature

# You'll only be prompted for:
# - Wave name
# - Any required template variables
```

### Preview Mode

See template structure before committing:

```bash
/waves:start --template bugfix --preview
```

Output:
```yaml
Template: bugfix
Name: Bug Investigation & Fix
Version: 1.0

Stages:
  design:
    - investigate: Reproduce and analyze bug (2h)
    - root-cause: Identify root cause (2h)
  execution:
    - implement-fix: Implement the fix (4h)
    - unit-tests: Add regression tests (2h)
  validation:
    - qa-verification: QA verification (2h)
  documentation:
    - update-docs: Update relevant documentation (1h)

Roles: backend, testing, documentation
Total: 7 pulses, 4-16h estimated
```

---

## Template Variables

Templates use variables for customization:

| Variable | Description | Required |
|----------|-------------|----------|
| `{{waveName}}` | Wave title (user-provided) | Yes |
| `{{waveSlug}}` | URL-safe slug (auto-generated) | Auto |
| `{{date}}` | Current date (YYYY-MM-DD) | Auto |
| `{{project}}` | Project slug from config | Auto |

### Template-Specific Variables

Some templates require additional variables:

**feature**:
- `featureDescription` - Brief description of the feature

**bugfix**:
- `bugDescription` - Description of the bug being fixed
- `bugId` - Optional bug/issue tracker ID

---

## UUID Collision Handling

Each wave and pulse gets a unique 6-character UUID. If a collision is detected:

```
⚠️  UUID Collision Detected

Wave UUID 'a1b2c3' already exists in project.

Options:
  [A] Auto-resolve - Add numeric suffix (a1b2c3-1)
  [R] Regenerate   - Generate new random UUID
  [C] Cancel       - Abort wave creation

Select option:
```

Use `--auto-resolve` to automatically handle collisions:

```bash
/waves:start --template feature --auto-resolve
```

---

## Generated Structure

Template creates complete V4 wave structure:

```
waves/
└── 17+user-authentication/
    ├── _meta.yaml           # Wave metadata with pulse references
    ├── wave.md              # Wave overview
    ├── pulses/
    │   ├── 01+requirements.md
    │   ├── 02+architecture.md
    │   ├── 03+backend-api.md
    │   ├── 04+frontend-ui.md
    │   └── ...
    ├── roles/
    │   ├── architect.md
    │   ├── backend.md
    │   └── frontend.md
    ├── design/
    ├── execution/
    ├── validation/
    └── documentation/
```

---

## Tips

### Choosing the Right Template

| Scenario | Template |
|----------|----------|
| Building a new user-facing feature | `feature` |
| Improving existing code structure | `refactor` |
| Starting a new project or major component | `foundation` |
| Fixing a reported bug | `bugfix` |

### Customizing After Creation

Templates create a starting point. After creation:

1. Edit `wave.md` to refine goals and success metrics
2. Modify pulse files to adjust tasks and time estimates
3. Add or remove pulses as needed
4. Adjust role assignments in `_meta.yaml`

### Multiple Templates

Create variations by running the wizard multiple times:

```bash
# Create main feature wave
/waves:start --template feature
# Wave name: "User Authentication"

# Create related bugfix wave
/waves:start --template bugfix
# Wave name: "Fix OAuth Token Refresh"
```

---

## Troubleshooting

### "Template not found"

Ensure the template name is valid:
- `feature`, `refactor`, `foundation`, `bugfix`

Check templates exist:
```bash
ls templates/scenarios/
```

### "Invalid wave name"

Wave names must:
- Start with a letter
- Contain only letters, numbers, spaces, and hyphens
- Be 3-50 characters long

### "UUID collision"

Use `--auto-resolve` or choose a different wave name.

### "Missing required variable"

Some templates require specific variables. The wizard prompts for these automatically. With `--template`, you may need to provide them:

```bash
# Feature template requires featureDescription
/waves:start --template feature
# → Will prompt for featureDescription
```

---

## See Also

- [Template Authoring Guide](template-authoring.md) - Create custom templates
- [Troubleshooting Guide](troubleshooting.md) - Common issues and solutions
- `/waves:run` - Execute waves and pulses
- `/waves:complete` - Finalize waves and pulses
