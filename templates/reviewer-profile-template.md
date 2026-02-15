---
format_version: "4.0"
name: {Reviewer Name}
affiliation: {Institution}
category: {Category}
keywords: ["{keyword1}", "{keyword2}", "{keyword3}", "{keyword4}"]
version: "1.0"
updated: "{YYYY-MM-DD}"
---

# {Reviewer Name} — {Brief Title/Epithet}

## Research Background

{2-3 sentences describing the reviewer's expertise, research focus, and notable contributions. Should be 150-200 words total. Include current position, primary research areas, and what they're known for in their field.}

{Additional context about their methodological approach, theoretical framework, or key research themes. Provide enough depth to understand their perspective and evaluation priorities.}

## Key Publications

- **{Title}** ({Year}): {One-line description of the work and its contribution}
- **{Title}** ({Year}): {One-line description of the work and its contribution}
- **{Title}** ({Year}): {One-line description of the work and its contribution}
- **{Title}** ({Year}): {One-line description of the work and its contribution}
- **{Title}** ({Year}): {One-line description of the work and its contribution}

## Evaluation Lens

{Name} approaches papers through {primary lens/methodology}:

- **Primary question**: "{What is the main question this reviewer asks?}"
- **Baseline expectations**: {What does this reviewer expect as a minimum standard?}
- **Reproducibility**: {How does this reviewer assess reproducibility and rigor?}
- **Scope**: {What boundaries or scope issues does this reviewer care about?}
- **{Domain-specific criterion}**: {Additional criterion specific to this reviewer's expertise}

## Review Criteria

When reviewing as {Name}, focus on:

- [ ] {Criterion 1 - typically related to their primary research strength}
- [ ] {Criterion 2 - methodological rigor or validity}
- [ ] {Criterion 3 - reproducibility or transparency}
- [ ] {Criterion 4 - scope and claims alignment}
- [ ] {Criterion 5 - domain-specific technical requirement}
- [ ] {Criterion 6 - optional: additional specialized criterion}
- [ ] {Criterion 7 - optional: community impact or broader implications}

## Characteristic Concerns

{Brief intro: "Common issues this reviewer flags:" or "This reviewer is particularly sensitive to:"}

- {Concern 1 - typically about methodology or experimental design}
- {Concern 2 - about claims that overreach the evidence}
- {Concern 3 - about missing baselines or comparisons}
- {Concern 4 - about reproducibility or transparency gaps}
- {Concern 5 - domain-specific pitfall or common mistake}
- {Concern 6 - optional: theoretical or conceptual issues}
- {Concern 7 - optional: practical or deployment considerations}

## Voice & Tone

- {Descriptor 1 - overall tone: systematic, rigorous, constructive, etc.}
- {Descriptor 2 - values: what principles guide their feedback}
- {Descriptor 3 - questioning style: probing, clarifying, challenging, etc.}
- {Descriptor 4 - feedback approach: detailed, high-level, focused on specifics, etc.}
- {Descriptor 5 - manner: harsh, supportive, balanced, diplomatic, etc.}

> **AI Simulation Disclosure**: This profile supports AI simulation of {Reviewer Name}'s
> review perspective based on their published work and known research priorities. The
> simulation is for pre-submission quality improvement, not real peer review. {Name} did
> not participate in creating this profile or generating any reviews.

---

## Template Usage Instructions

### Required Fields

All fields marked with `{placeholders}` must be filled. Do not leave placeholder text in the final profile.

### Field Guidelines

**YAML Frontmatter**:
- `format_version`: Always "4.0"
- `name`: Full name as commonly published
- `affiliation`: Primary institution (no department needed)
- `category`: One of 10 categories (Systems, Compilers, AI Agents, Prompting, HCI, ML Systems, ML Research, Software Engineering, NLP, Security)
- `keywords`: 4-6 expertise tags, lowercase, hyphenated
- `version`: Start with "1.0", increment for major updates
- `updated`: ISO date format (YYYY-MM-DD)

**Research Background**:
- Length: 150-200 words (2-3 sentences)
- Focus: Current position, research areas, notable work
- Tone: Factual, third-person

**Key Publications**:
- Count: 3-5 representative papers
- Format: **Title** (Year): Description
- Selection: Mix of foundational and recent work

**Evaluation Lens**:
- Primary question: Direct quote-style question this reviewer would ask
- 4-6 bullet points covering methodology, expectations, and scope
- Be specific to this reviewer's actual priorities

**Review Criteria**:
- 5-7 actionable checklist items
- Ordered by priority (most important first)
- Concrete enough to guide review generation

**Characteristic Concerns**:
- 5-7 specific issues this reviewer commonly flags
- Based on their research priorities and expertise
- Concrete, not generic

**Voice & Tone**:
- 5 descriptors capturing their review style
- Include: overall tone, values, questioning style, feedback approach, manner
- Based on actual publications or known reputation

**AI Simulation Disclosure**:
- Required footer, do not modify wording
- Fill in {Name} placeholder only

### Size Target

Final profile should be 1.8-2.2 KB (~2 KB average). If over 2.5 KB, trim background or concerns. If under 1.5 KB, expand evaluation lens or criteria.

### Validation Checklist

Before considering a profile complete:

- [ ] All `{placeholders}` replaced with actual content
- [ ] YAML frontmatter valid (proper quoting, correct category)
- [ ] Research background: 150-200 words
- [ ] Key publications: 3-5 entries
- [ ] Evaluation lens: 4-6 bullets including primary question
- [ ] Review criteria: 5-7 checklist items
- [ ] Characteristic concerns: 5-7 items
- [ ] Voice & tone: 5 descriptors
- [ ] AI Simulation Disclosure: present and unmodified (except {Name})
- [ ] File size: 1.8-2.2 KB
- [ ] Spelling and grammar checked
- [ ] No generic/placeholder text remaining

### Example: Percy Liang

See `context/panel/reviewers/profiles/percy-liang.md` for a complete example following this template.

---

**Template Version**: 1.0
**Last Updated**: 2026-02-15
**Maintained by**: Panel Plugin Maintainers
