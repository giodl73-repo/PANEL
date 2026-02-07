# Cookie Science Lab — Research Papers

**Module**: Cookie Science Lab
**Papers**: 5
**Author**: Cookie Monster et al.

---

## Paper Inventory

| # | Directory | Title | Venue Target | Stage | Round |
|---|-----------|-------|-------------|-------|-------|
| 1 | [panel-optimal-cookie-consumption](panel-optimal-cookie-consumption/) | Optimal Cookie Consumption Under Resource Constraints | NomNom 2026 | ready | 2 |
| 2 | [panel-chip-distribution](panel-chip-distribution/) | Statistical Analysis of Chocolate Chip Placement | ICBD 2026 | ready | 2 |
| 3 | [panel-sharing-economics](panel-sharing-economics/) | Game-Theoretic Models of Cookie Division | AAMAS 2026 | recheck | 2 |
| 4 | [panel-dunk-methodology](panel-dunk-methodology/) | Controlled Study of Milk Immersion Timing | JSS 2026 | ready | 2 |
| 5 | [panel-crumb-analysis](panel-crumb-analysis/) | Cookie Quality Assessment via Crumb Patterns | CVPR 2026 | recheck | 1 |

---

## Paper Dependency Graph

```
[1] Optimal Cookie Consumption (foundational)
     |
     +──→ [2] Chip Distribution
     |
     +──→ [3] Sharing Economics
     |
     +──→ [4] Dunk Methodology
              |
              +──→ [5] Crumb Analysis
```

---

## Review Status

| Paper | Stage | Round | Score | Verdict |
|-------|-------|-------|-------|---------|
| #1 Optimal Cookie Consumption | ready | 2 | 3.2/4 | Accept |
| #2 Chip Distribution | ready | 2 | 3.4/4 | Accept |
| #3 Sharing Economics | recheck | 2 | 2.6/4 | Revise |
| #4 Dunk Methodology | ready | 2 | 3.2/4 | Accept |
| #5 Crumb Analysis | recheck | 1 | 3.0/4 | Revise |

---

## Build

```bash
make all          # Build all papers
make dist         # Copy PDFs to docs/
make clean        # Remove build artifacts
```

---

*Cookie Science Lab research module — established 2025-12-01*
