# Hook: Schema Validation

**Stage**: design
**Type**: checklist
**Required**: true

## Description

Validate template structures against schema before execution begins. Prevents schema-template mismatches from reaching execution/validation stages.

## Checklist

- [ ] All required fields present (name, slug, version, stages, roles, estimated_hours)
- [ ] Stage keys match valid names (design, execution, validation, documentation)
- [ ] All pulses have required fields (slug_suffix, title, role, estimated_hours)
- [ ] Every role in pulses exists in template `roles` array
- [ ] All dependencies use `~` prefix (e.g., `~requirements`)
- [ ] No circular dependencies
- [ ] Variable definitions include `type` field

## On Failure

This hook is required. Address all schema validation issues before proceeding to design review.

Common fixes:
- Add missing roles to `roles` array
- Add `~` prefix to dependency references
- Add `type: string` to variable definitions
