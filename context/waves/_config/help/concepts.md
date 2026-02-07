---
format_version: "4.0"
---

# Waves Core Concepts

## What is Waves?

Waves is an AI-powered project management system that organizes software development work into **waves** (projects/features) and **pulses** (tasks). Each wave moves through defined stages with reviews at each transition.

---

## Waves

A **wave** is a collection of related work - typically a feature, project, or initiative.

```
Wave 14: Command Expansion
├── Status: In Design
├── UUID: 04ab85
├── Pulses: 10
└── Stages: Design → Execution → Validation → Documentation
```

### Wave Properties
- **Order**: Sequential number (14)
- **Slug**: URL-friendly name (command-expansion)
- **UUID**: 6-character hex identifier (04ab85)
- **Status**: Current stage (Planning, In Design, In Execution, etc.)

### Reference Syntax
```
^14                    # By order
^command-expansion     # By slug
^04ab85                # By UUID
```

---

## Pulses

A **pulse** is an atomic unit of work within a wave - a specific task with defined deliverables.

```
Pulse 1: Directory Reorganization
├── Stage: design
├── Role: Skills
├── Status: Completed
├── Dependencies: None
└── Estimated: 5h
```

### Pulse Properties
- **Order**: Position within wave (1, 2, 3...)
- **Slug**: Descriptive name (directory-reorganization)
- **UUID**: 6-character hex identifier
- **Stage**: Which wave stage (design, execution, validation, documentation)
- **Role**: Discipline responsible (Skills, Backend, Frontend)
- **Dependencies**: Other pulses that must complete first

### Reference Syntax
```
~1                           # By order (within active wave)
~directory-reorganization    # By slug
~dfadb0                      # By UUID
```

---

## Stages

Waves progress through **stages**, each with a blocking review:

| Stage | Purpose | Review |
|-------|---------|--------|
| **Planning** | Wave plan approval | Blocking |
| **Design** | Architecture decisions | Blocking |
| **Execution** | Implementation work | Non-blocking |
| **Validation** | User testing | Blocking |
| **Documentation** | Final docs | Blocking |

### Stage Flow
```
Planning ──review──► Design ──review──► Execution ──review──► Validation ──review──► Documentation ──review──► Complete
```

---

## Disciplines

A **discipline** is role-specific guidance that defines how a particular role should approach work.

### Available Disciplines
- `skills` - Plugin/command development
- `backend` - API and server development
- `frontend` - UI development
- `designer` - UX/UI design
- `architect` - System architecture
- `reviewer` - Code review
- `pm` - Product management
- `tpm` - Technical program management

### Using Disciplines
```
/waves:act-as backend    # Apply backend discipline to current work
```

Disciplines are stored in:
- Project: `_config/disciplines/{name}.md`
- Plugin fallback: `templates/disciplines/{name}.md`

---

## Reviews

Each stage transition requires a **review** - a multi-agent process that validates the work.

### Review Steps (Planning Example)
1. **Strategic** (parallel): PM, TPM, Designer
2. **Director Synthesis** (sequential): Director
3. **Technical** (parallel): TPM-assigned reviewers
4. **Manager Synthesis** (sequential): Final decision

### Review Decisions
- **APPROVE**: Proceed to next stage
- **REVISE**: Address issues, re-review
- **NO-GO**: Major issues, halt immediately

---

## Active Wave

The **active wave** is your current working context. Commands use it as default when no reference is provided.

```
/waves:switch ^14    # Set wave 14 as active
/waves:status        # Shows active wave status
/waves:run ~1        # Runs pulse 1 of active wave
```

Active wave is stored per-project in `_config/wave-index.yaml`.

---

## See Also

- `/waves:help commands` - All available commands
- `/waves:help workflows` - Common workflow patterns
- `/waves:help stages` - Detailed stage information
