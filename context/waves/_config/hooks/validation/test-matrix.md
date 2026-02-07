# Test Matrix Validation

**Stage**: validation
**Type**: checklist
**Required**: true

Ensure comprehensive test coverage before wave completion.

## Checklist

- [ ] All high-priority test cases executed
- [ ] All medium-priority test cases executed
- [ ] Performance targets verified against actuals
- [ ] Edge cases covered (empty data, invalid input, boundary conditions)
- [ ] Cross-project functionality tested (if applicable)
- [ ] Error handling verified (graceful degradation)
- [ ] No critical or high-severity issues remain open

## Criteria

| Category | Requirement |
|----------|-------------|
| High priority tests | 100% pass |
| Medium priority tests | 95%+ pass |
| Performance | All targets met |
| Open issues | 0 critical/high |

## Notes

This hook blocks validation stage completion until all test matrix items are verified. See `design/validation-test-matrix.md` for the full test matrix definition.
