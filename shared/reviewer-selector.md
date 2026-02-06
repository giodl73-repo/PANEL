# Reviewer Selector — Match Reviewers to Papers

Shared utility for selecting appropriate reviewers from the database based on paper characteristics.

## Reviewer Database

Source: `REVIEWER-DATABASE.md` in the project root (copied during `panel:setup`).

The database contains 45+ expert reviewers organized by category:
- Systems & Infrastructure
- Compilers & PL Theory
- AI Agents & Orchestration
- Prompting & LLM Capabilities
- Human-AI Interaction
- ML Systems & Efficiency
- ML Research / Learning
- Software Engineering & DevOps
- NLP & Information Retrieval
- Security & Safety

## Selection Algorithm

### select_panel(paper_info, count=5)

```
Input:  { title, abstract, venue, keywords }
Output: array of { name, affiliation, expertise, rationale }
```

1. **Venue matching**: Use conference-specific selection guides from the database
2. **Category matching**: Map paper topic to reviewer categories
3. **Diversity constraints**:
   - At least 1 industry practitioner
   - At least 1 academic researcher
   - At least 2 different categories represented
   - No more than 2 reviewers from same institution
4. **Expertise complementarity**: Select reviewers with different focus areas (e.g., systems + HCI + evaluation)
5. **Availability**: Skip reviewers already assigned to other papers in the same round (if multi-paper module)

## Panel Composition Guidelines

| Panel Size | Composition |
|-----------|-------------|
| 5 (standard) | 2-3 domain experts + 1 methodology expert + 1 practitioner |
| 7 (cross-portfolio) | 3 domain experts + 2 methodology + 1 practitioner + 1 HCI |
| 9 (extended) | Full coverage across all relevant categories |

## Filtering

### filter_reviewers(criteria)

```
Input:  { category?, venue?, tag?, search?, exclude_names? }
Output: array of matching reviewer records
```

## Cross-Portfolio Panel Selection

For module-level panels (REVIEW_PANEL.md), select reviewers who:
- Have reviewed 2+ papers in the module (continuity)
- Represent different perspectives (systems, agents, HCI, evaluation)
- Include at least 1 reviewer from each paper's individual panel
