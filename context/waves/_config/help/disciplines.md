---
format_version: "4.0"
---

# Waves Disciplines

## What are Disciplines?

Disciplines are role-specific guidance files that define how each role should approach work - coding patterns, review criteria, quality standards.

---

## Available Disciplines

| Discipline | Focus Area |
|------------|------------|
| `skills` | Plugin/command development |
| `backend` | API, server, data |
| `frontend` | UI, components, state |
| `designer` | UX/UI design |
| `architect` | System architecture |
| `reviewer` | Code review |
| `pm` | Product management |
| `tpm` | Technical program management |
| `testing` | Test coverage, QA |
| `devops` | CI/CD, infrastructure |
| `security` | Security review |
| `documentation-manager` | Doc quality |

---

## Using Disciplines

### Apply to Current Work
```bash
/waves:act-as backend
```

### In Pulse Files
```yaml
role: Backend    # Discipline to use
```

### In Reviews
Reviewers automatically use their discipline for evaluation.

---

## Discipline Locations

**Project (custom)**:
```
context/waves/_config/disciplines/backend.md
```

**Plugin (fallback)**:
```
templates/disciplines/backend.md
```

Project disciplines override plugin defaults.

---

## Discipline Structure

```markdown
# Backend Discipline

## Seniority: Senior
## Framework: FastAPI

## Code Standards
- Use type hints everywhere
- Async by default
- ...

## Review Criteria
- Security considerations
- Performance implications
- ...

## Quality Gates
- All tests pass
- No security warnings
- ...
```

---

## Generating Disciplines

When a discipline doesn't exist, the system can generate one interactively:

```
Discipline 'mobile' not found.

Would you like to generate it?
  Seniority: [Junior/Mid/Senior/Staff]
  Framework: [React Native/Flutter/...]
  Strictness: [Relaxed/Standard/Strict]
```

---

## See Also

- `/waves:act-as` - Apply discipline
- `/waves:help concepts` - Core concepts
