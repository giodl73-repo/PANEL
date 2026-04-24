---
format_version: "4.0"
---

# Wave Templates: Authoring Guide

Create custom templates for your team's workflows.

## Template Location

Templates are stored in `templates/scenarios/`:

```
templates/
└── scenarios/
    ├── feature.yaml      # Built-in templates
    ├── refactor.yaml
    ├── foundation.yaml
    ├── bugfix.yaml
    └── my-custom.yaml    # Your custom templates
```

---

## Template Structure

Templates are YAML files with this structure:

```yaml
# templates/scenarios/my-template.yaml

# === METADATA ===
name: "My Custom Workflow"
slug: my-custom
version: "1.0"
description: "Template for [specific workflow]"
tags: [custom, team-specific]

# === TIME ESTIMATES ===
estimated_hours:
  min: 10
  max: 20

# === ROLES ===
roles:
  - architect
  - backend
  - frontend

# === VARIABLES ===
variables:
  required:
    - name: waveName
      description: "Name of the wave"
    - name: customField
      description: "Custom required field"
  optional:
    - name: additionalContext
      description: "Optional context"
      default: ""

# === STAGES ===
stages:
  design:
    pulses:
      - slug_suffix: planning
        title: "{{waveName}} Planning"
        role: architect
        estimated_hours: 2
        description: "Plan the implementation approach"
        tasks:
          - "Define scope and boundaries"
          - "Identify dependencies"
          - "Create technical design"
        dependencies: []

  execution:
    pulses:
      - slug_suffix: implementation
        title: "{{waveName}} Implementation"
        role: backend
        estimated_hours: 8
        description: "Implement the core functionality"
        tasks:
          - "Implement core logic"
          - "Add unit tests"
          - "Handle edge cases"
        dependencies: [~planning]

  validation:
    pulses:
      - slug_suffix: testing
        title: "Testing"
        role: testing
        estimated_hours: 4
        dependencies: [~implementation]

  documentation:
    pulses:
      - slug_suffix: docs
        title: "Documentation"
        role: documentation
        estimated_hours: 2
        dependencies: [~testing]
```

---

## Field Reference

### Metadata Fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Human-readable template name |
| `slug` | Yes | URL-safe identifier (lowercase, hyphens) |
| `version` | Yes | Semantic version (e.g., "1.0", "2.1.0") |
| `description` | No | Brief description of the template |
| `tags` | No | Array of tags for categorization |

### Time Estimates

```yaml
estimated_hours:
  min: 10    # Minimum hours (optimistic)
  max: 20    # Maximum hours (pessimistic)
```

### Roles

List all roles used in the template:

```yaml
roles:
  - architect
  - backend
  - frontend
  - testing
  - documentation
```

**Standard Roles**: `architect`, `backend`, `frontend`, `testing`, `documentation`, `devops`, `security`, `designer`

### Variables

Variables are interpolated in pulse titles, descriptions, and tasks:

```yaml
variables:
  required:
    - name: waveName
      description: "Name of the wave"
    - name: featureDescription
      description: "Brief description of the feature"
  optional:
    - name: additionalNotes
      description: "Additional notes"
      default: "None provided"
```

**Built-in Variables** (always available):
- `{{waveName}}` - User-provided wave name
- `{{waveSlug}}` - Auto-generated URL-safe slug
- `{{date}}` - Current date (YYYY-MM-DD)
- `{{project}}` - Project slug from config

### Stages

Templates support 4 stages that map to V4 wave structure:

| Stage | Purpose |
|-------|---------|
| `design` | Planning, requirements, technical design |
| `execution` | Implementation, coding, testing |
| `validation` | QA, review, verification |
| `documentation` | User docs, technical docs, release notes |

### Pulse Definitions

Each pulse within a stage:

```yaml
- slug_suffix: backend-api
  title: "{{waveName}} Backend API"
  role: backend
  estimated_hours: 8
  description: "Implement the backend API endpoints"
  phase: 1                    # Optional: parallel execution group
  tasks:
    - "Create API endpoints"
    - "Add input validation"
    - "Write unit tests"
  dependencies:
    - ~requirements           # References another pulse
    - ~architecture
  conditions:                 # Optional: conditional inclusion
    - variable: includeApi
      equals: true
```

**Pulse Fields**:

| Field | Required | Description |
|-------|----------|-------------|
| `slug_suffix` | Yes | Appended to wave slug for pulse slug |
| `title` | Yes | Pulse title (supports variables) |
| `role` | Yes | Assigned role |
| `estimated_hours` | Yes | Time estimate |
| `description` | No | Detailed description |
| `phase` | No | Parallel execution group (default: 1) |
| `tasks` | No | Array of task items |
| `dependencies` | No | Array of pulse references (`~slug_suffix`) |
| `conditions` | No | Conditional inclusion rules |

---

## Dependencies

Dependencies reference other pulses using the `~` prefix:

```yaml
dependencies:
  - ~requirements      # Must complete before this pulse
  - ~architecture
```

**Rules**:
- Dependencies must reference pulses in earlier or same stage
- Circular dependencies are not allowed
- Cross-stage dependencies are allowed (execution depends on design)

### Dependency Resolution

```
design:
  - ~requirements (no deps)
  - ~architecture (depends on ~requirements)

execution:
  - ~backend-api (depends on ~architecture)
  - ~frontend-ui (depends on ~architecture)
  - ~integration (depends on ~backend-api AND ~frontend-ui)
```

---

## Conditional Pulses

Include pulses conditionally based on variables:

```yaml
- slug_suffix: mobile-app
  title: "Mobile App Implementation"
  role: frontend
  conditions:
    - variable: includeMobile
      equals: true
```

During instantiation, if `includeMobile` is not `true`, this pulse is skipped.

**Condition Operators**:
- `equals` - Exact match
- `notEquals` - Not equal
- `exists` - Variable is defined

---

## Variable Interpolation

Use `{{variableName}}` in titles, descriptions, and tasks:

```yaml
- slug_suffix: api
  title: "{{waveName}} API Implementation"
  description: "Implement API for {{featureDescription}}"
  tasks:
    - "Create {{waveName}} endpoints"
    - "Add validation for {{featureDescription}}"
```

**Security Note**: Only whitelisted variables are interpolated. Arbitrary user input is sanitized.

---

## Template Validation

Templates are validated against `config/schemas/template.schema.yaml`:

```bash
# Validation happens automatically when loading templates
# Errors are reported with line numbers and suggestions
```

**Common Validation Errors**:

| Error | Cause | Fix |
|-------|-------|-----|
| Missing required field | `name`, `slug`, or `version` missing | Add the field |
| Invalid slug format | Uppercase or special characters | Use lowercase with hyphens |
| Invalid role | Role not in canonical list | Use standard role or add to roles list |
| Circular dependency | Pulse A depends on B, B depends on A | Reorder dependencies |
| Missing dependency | References non-existent pulse | Check `slug_suffix` spelling |

---

## Example: Custom API Template

```yaml
# templates/scenarios/api-feature.yaml

name: "API Feature Development"
slug: api-feature
version: "1.0"
description: "Template for backend API feature development"
tags: [api, backend, custom]

estimated_hours:
  min: 16
  max: 32

roles:
  - architect
  - backend
  - testing
  - documentation

variables:
  required:
    - name: waveName
      description: "Name of the API feature"
    - name: apiEndpoints
      description: "List of API endpoints to create"
  optional:
    - name: authRequired
      description: "Whether authentication is required"
      default: "true"

stages:
  design:
    pulses:
      - slug_suffix: api-design
        title: "{{waveName}} API Design"
        role: architect
        estimated_hours: 4
        tasks:
          - "Define API contract (OpenAPI spec)"
          - "Design data models"
          - "Document authentication requirements"

  execution:
    pulses:
      - slug_suffix: api-implementation
        title: "{{waveName}} API Implementation"
        role: backend
        estimated_hours: 12
        dependencies: [~api-design]
        tasks:
          - "Implement {{apiEndpoints}}"
          - "Add request validation"
          - "Implement error handling"
          - "Add authentication middleware"
        conditions:
          - variable: authRequired
            equals: "true"

      - slug_suffix: api-tests
        title: "API Unit Tests"
        role: backend
        estimated_hours: 4
        dependencies: [~api-implementation]
        tasks:
          - "Write unit tests for endpoints"
          - "Add integration tests"
          - "Test error scenarios"

  validation:
    pulses:
      - slug_suffix: api-qa
        title: "API QA Testing"
        role: testing
        estimated_hours: 4
        dependencies: [~api-tests]
        tasks:
          - "Manual API testing"
          - "Performance testing"
          - "Security review"

  documentation:
    pulses:
      - slug_suffix: api-docs
        title: "API Documentation"
        role: documentation
        estimated_hours: 4
        dependencies: [~api-qa]
        tasks:
          - "Update API reference docs"
          - "Add usage examples"
          - "Document breaking changes"
```

---

## Best Practices

### 1. Start Simple
Begin with 4-6 pulses covering the critical path. Add more as needed.

### 2. Use Realistic Time Estimates
Base estimates on historical data. Include buffer for unknowns.

### 3. Define Clear Dependencies
Explicit dependencies prevent work starting before prerequisites complete.

### 4. Use Meaningful Slugs
Slugs appear in file names and URLs. Make them descriptive:
- Good: `user-auth-backend`, `payment-integration`
- Bad: `pulse1`, `step2`

### 5. Include Tasks
Tasks provide clear acceptance criteria for each pulse.

### 6. Version Your Templates
Increment version when making changes. Helps track which template version created a wave.

### 7. Test Before Sharing
Create a test wave from your template to verify structure and variables.

---

## Sharing Templates

### Team Templates

Store team templates in your project's waves directory:

```
your-project/
└── context/
    └── waves/
        └── templates/
            └── team-workflow.yaml
```

### Plugin Templates

Contribute to the plugin's built-in templates:

1. Create template in `templates/scenarios/`
2. Test thoroughly
3. Submit PR to waves plugin repository

---

## See Also

- [Template Usage Guide](template-usage.md) - Using templates
- [Troubleshooting Guide](troubleshooting.md) - Common issues
- `config/schemas/template.schema.yaml` - Schema reference
- `shared/template-engine.md` - Engine implementation
