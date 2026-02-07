# Grover's Adventure Academy — Research Papers

**Module**: Grover's Adventure Academy
**Papers**: 5
**Author**: Grover et al.

---

## Paper Inventory

| # | Directory | Title | Venue Target | Stage | Round |
|---|-----------|-------|-------------|-------|-------|
| 1 | [panel-near-far-metrics](panel-near-far-metrics/) | Unified Distance Metrics for Monster Navigation | IROS 2026 | revision | 1 |
| 2 | [panel-super-grover-flight](panel-super-grover-flight/) | Cape-Assisted Aerial Locomotion Dynamics | AIAA 2026 | synthesis | 1 |
| 3 | [panel-monster-anxiety](panel-monster-anxiety/) | Anticipatory Anxiety in Sequential Media | CHI 2026 | recheck | 1 |
| 4 | [panel-helping-dynamics](panel-helping-dynamics/) | Measuring Prosocial Behavior in Furry Populations | CSCW 2026 | revision | 1 |
| 5 | [panel-waiter-dilemma](panel-waiter-dilemma/) | Balancing Multiple Plates Under Uncertainty | AAMAS 2026 | synthesis | 1 |

---

## Paper Dependency Graph

```
[1] Near-Far Metrics (foundational)
     |
     +──→ [2] Super Grover Flight
     |
     +──→ [3] Monster Anxiety
     |
     +──→ [4] Helping Dynamics
              |
              +──→ [5] Waiter Dilemma
```

---

## Review Status

| Paper | Stage | Round | Score | Verdict |
|-------|-------|-------|-------|---------|
| #1 Near-Far Metrics | revision | 1 | 2.6/4 | Revise |
| #2 Super Grover Flight | synthesis | 1 | 2.4/4 | Major Revisions |
| #3 Monster Anxiety | recheck | 1 | 2.8/4 | Revise |
| #4 Helping Dynamics | revision | 1 | 2.6/4 | Revise |
| #5 Waiter Dilemma | synthesis | 1 | 2.4/4 | Major Revisions |

---

## Build

```bash
make all          # Build all papers
make dist         # Copy PDFs to docs/
make clean        # Remove build artifacts
```

---

*Grover's Adventure Academy research module — established 2025-12-01*
