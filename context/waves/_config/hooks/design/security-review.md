# Hook: Security Review

**Stage**: design
**Type**: checklist
**Required**: false

## Description

Lightweight security checklist for design phase. Identifies potential security issues before execution.

## Checklist

- [ ] All user inputs have validation rules defined
- [ ] Maximum length limits specified for text inputs
- [ ] Variable whitelist defined (only expected variables allowed)
- [ ] Path construction doesn't use raw user input
- [ ] No hardcoded secrets or credentials
- [ ] Trust boundaries identified

## On Failure

This hook is advisory. Review identified security considerations but can proceed if needed. Document any deferred security items for execution phase.
