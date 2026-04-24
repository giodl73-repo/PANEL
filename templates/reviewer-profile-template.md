---
name: {reviewer-slug}
version: "1.0"
archetype: {structural|craft|experiential}

orientation:
  frame: "{1-2 sentence worldview that captures how this reviewer reads papers. Should be a distinctive intellectual stance, not a generic statement about rigor.}"
  serves: "{Who benefits from this reviewer's perspective? Describe the audience in terms of what they need — e.g., 'Authors who need X' and 'Reviewers who need Y'.}"

lens:
  verify:
    - "{Question 1 - the reviewer's primary question, their signature concern}"
    - "{Question 2 - methodological rigor specific to their domain}"
    - "{Question 3 - reproducibility or evaluation standard}"
    - "{Question 4 - scope or claims alignment}"
    - "{Question 5 - domain-specific technical requirement}"
    - "{Question 6 - optional: additional specialized concern}"
  simplify:
    - "{Principle 1 - what to remove or consolidate}"
    - "{Principle 2 - what to replace with something cleaner}"
    - "{Principle 3 - what redundancy to eliminate}"
    - "{Principle 4 - optional: domain-specific simplification}"

expertise:
  depth: "{Comma-separated list of expertise areas: area1, area2, area3, area4, area5}"
  relevance: "{1-2 sentences explaining why this expertise matters for the papers being reviewed — what failure mode does this reviewer catch?}"

scope: local
collaborates_with:
  - {R-N}
  - {R-N}

artifacts:
  - type: review
    directory: reviews/
    format: markdown
    naming: "review-{reviewer-slug}-{subject}.md"

workflow:
  - step: read
    description: "{How this reviewer reads — what they focus on first}"
  - step: evaluate
    description: "{What they assess — their evaluation criteria and method}"
  - step: synthesize
    description: "{What they produce — emphasis areas and recommendation style}"
---

# {R-N}: {Reviewer Full Name}

**Affiliation**: {Institution}
**Category**: {Category Name}

## Expertise
- {Expertise area 1}
- {Expertise area 2}
- {Expertise area 3}
- {Expertise area 4}

## Key Question
{The single most important question this reviewer asks of every paper}

## Venue Affinity
- {Venue 1}
- {Venue 2}

## Paper Type Fit
- {Paper type 1}
- {Paper type 2}

---

## Template Usage Instructions

### OLE Format (Spec 93)

This template uses the OLE (Orientation/Lens/Expertise) frontmatter format, a 2x3 matrix:

| Tier | Inward (Judge) | Outward (Servant) |
|------|----------------|-------------------|
| **Orientation** | frame | serves |
| **Lens** | verify | simplify |
| **Expertise** | depth | relevance |

### Required Fields

All fields marked with `{placeholders}` must be filled. Do not leave placeholder text.

**Frontmatter (YAML)**:
- `name`: Reviewer slug (lowercase, hyphenated — e.g., `percy-liang`)
- `version`: Start with `"1.0"`, increment for major updates
- `archetype`: One of `structural` (formal/systems), `craft` (methodology/practice), `experiential` (user/interaction)
- `orientation.frame`: 1-2 sentence distinctive worldview (NOT generic "rigorous review")
- `orientation.serves`: Who benefits and what they need
- `lens.verify`: 5-7 questions this reviewer asks (ordered by priority)
- `lens.simplify`: 3-5 principles for what to cut or consolidate
- `expertise.depth`: Comma-separated expertise areas
- `expertise.relevance`: Why this expertise matters (what failure mode it catches)
- `collaborates_with`: R-N IDs of reviewers in the same category

**Markdown Body**:
- `# R-N: Full Name` heading
- Affiliation, Category (bold labels)
- Expertise bullet list (3-5 items)
- Key Question (single sentence)
- Venue Affinity (1-3 venues)
- Paper Type Fit (1-3 types)

### Archetype Selection Guide

| Archetype | Categories | Signal |
|-----------|-----------|--------|
| `structural` | compilers-pl, systems-infrastructure, ml-systems, security, data-systems | Formal methods, proofs, architecture, correctness |
| `craft` | ml-research, ai-agents, prompting-llm, software-engineering, nlp-ir | Methodology, practice, evaluation, tooling |
| `experiential` | hci | Users, interaction, design, experience |

### Validation Checklist

- [ ] All `{placeholders}` replaced with actual content
- [ ] YAML frontmatter valid (proper quoting, indentation)
- [ ] `orientation.frame` is distinctive (not generic)
- [ ] `lens.verify`: 5-7 questions
- [ ] `lens.simplify`: 3-5 principles
- [ ] `expertise.depth` has 4-7 comma-separated areas
- [ ] `collaborates_with` lists correct R-N IDs
- [ ] Markdown body has all 5 sections
- [ ] File size: 1.5-2.5 KB
- [ ] No generic/placeholder text remaining

### Example: Percy Liang (R-1)

See `context/panel/reviewers/profiles/R-1.md` for a complete example.

---

**Template Version**: 2.0
**Format**: OLE (Spec 93)
**Last Updated**: 2026-03-01
**Maintained by**: Panel Plugin Maintainers
