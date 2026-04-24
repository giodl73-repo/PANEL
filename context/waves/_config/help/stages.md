---
format_version: "4.0"
---

# Waves Stages

## Stage Overview

| Stage | Purpose | Review | Blocking |
|-------|---------|--------|----------|
| Planning | Plan approval | 4-step multi-agent | Yes |
| Design | Architecture | 4-step multi-agent | Yes |
| Execution | Implementation | 4-step multi-agent | No |
| Validation | User testing | 2-step with manual | Yes |
| Documentation | Final docs | 1-step quality | Yes |

---

## Planning Stage

**Purpose**: Get wave plan approved before any work begins.

**Review Steps**:
1. Strategic (PM, TPM, Designer) - parallel
2. Director Synthesis - sequential
3. Technical (TPM-assigned) - parallel
4. Manager Synthesis - final decision

**TPM Assigns**:
- Design quality gate reviewer
- Technical reviewers

**Pulse Stage**: N/A (no pulses in planning)

---

## Design Stage

**Purpose**: Create architecture and design decisions.

**Review Steps**:
1. Quality Gate (TPM-assigned) - sequential
2. Strategic (PM) - parallel
3. Technical (TPM-assigned) - parallel
4. Manager Synthesis - final decision

**Pulse Stage**: `stage: design`

**Deliverables**: Schemas, interfaces, specifications

---

## Execution Stage

**Purpose**: Implement according to designs.

**Review Steps**:
1. Domain (Frontend, Backend, Testing) - parallel
2. Manager Synthesis - sequential
3. Strategic (PM) - parallel
4. Director Synthesis - final decision

**Pulse Stage**: `stage: execution`

**Non-Blocking**: Can create follow-up pulses

---

## Validation Stage

**Purpose**: User testing and approval.

**Review Steps**:
1. User Approval (manual) - sequential
2. Doc Planning (TPM, Doc Manager) - sequential

**Pulse Stage**: `stage: validation`

**Manual Step**: Requires interactive user approval

---

## Documentation Stage

**Purpose**: Final documentation updates.

**Review Steps**:
1. Quality Review (Documentation Manager) - sequential

**Pulse Stage**: `stage: documentation`

**Final Gate**: Blocks wave completion

---

## Pulse Stage Assignment

In pulse frontmatter:
```yaml
stage: design       # Runs during Design stage
stage: execution    # Runs during Execution stage
stage: validation   # Runs during Validation stage
stage: documentation # Runs during Documentation stage
```

---

## Running Specific Stages

```bash
/waves:run ^14 --stage planning     # Planning only
/waves:run ^14 --stage design       # Design only
/waves:run ^14 --stage execution    # Execution only
/waves:run ^14                      # All stages
```

---

## See Also

- `/waves:help reviews` - Review process details
- `/waves:help workflows` - Stage-based workflows
