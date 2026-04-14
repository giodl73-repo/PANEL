# panel:module check

## `check [modules]`

Validate track coverage:
- Every paper has >=1 track
- Every track has >=2 papers
- Every paper has a quantification contract
- No broken chain links

```
panel:module check
══════════════════
✓ Track A: 3 papers, chain complete
⚠ Track B: paper-3 has no quantification contract
✗ Track C: chain broken (paper-5 not created yet)
✗ paper-7: orphan — not assigned to any track
```
