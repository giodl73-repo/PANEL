# Profile Quality Check — Reviewer Profile Validation

**Wave**: 260215+galileo-observer+reviewer-profiles (Galileo, observer)
**Phase**: V5 Profile Quality Check
**Date**: 2026-02-15

---

## Overview

This document defines quality criteria for reviewer profiles and provides validation tools to ensure all 45 profiles meet completeness, consistency, and quality standards before operational rollout.

---

## Quality Criteria

### 1. Structural Completeness

Every profile MUST contain all 7 required sections:

| Section | Required | Purpose |
|---------|----------|---------|
| **YAML Frontmatter** | Yes | Metadata (name, affiliation, category, keywords) |
| **Research Background** | Yes | 2-3 paragraphs on expertise and research focus |
| **Key Publications** | Yes | 3-5 seminal papers or projects |
| **Evaluation Lens** | Yes | Characteristic questions and focus areas |
| **Review Criteria** | Yes | Checklist items for evaluating papers |
| **Characteristic Concerns** | Yes | Common issues this reviewer raises |
| **Voice & Tone** | Yes | Writing style descriptors |
| **AI Simulation Disclosure** | Yes | Footer explaining AI persona |

**Size Target**: 1.8-2.2KB per profile (~500-600 words)

### 2. Content Quality

#### Research Background
- [ ] Accurately reflects reviewer's actual expertise
- [ ] References real institutions and research groups
- [ ] Mentions specific contributions to the field
- [ ] Avoids generic or vague descriptions
- [ ] 2-3 substantive paragraphs (150-200 words)

**Good Example**:
```markdown
## Research Background
Professor at Stanford, founder of Center for Research on Foundation Models (CRFM).
Known for HELM (Holistic Evaluation of Language Models), systematic benchmarking,
and transparency in AI evaluation. Research focuses on large-scale evaluation
frameworks, watermarking for AI-generated text, and reproducibility in ML research.
```

**Bad Example** (too generic):
```markdown
## Research Background
Expert in machine learning with focus on evaluation. Works at a top university.
Has published many papers on benchmarking and testing.
```

#### Key Publications
- [ ] Lists 3-5 real publications
- [ ] Includes titles and brief descriptions
- [ ] Covers representative work across career
- [ ] Prioritizes seminal/high-impact papers
- [ ] Includes years for temporal context

**Good Example**:
```markdown
## Key Publications
- **HELM** (2022): Holistic evaluation framework with 42 scenarios across 7 metrics
- **Watermarking LLMs** (2023): Statistical detection of AI-generated text
- **Semantic Parsing** (2013): Foundational work on learning from demonstrations
```

#### Evaluation Lens
- [ ] Defines characteristic questions this reviewer asks
- [ ] Reflects actual review philosophy
- [ ] Specific enough to guide review generation
- [ ] Aligns with research background
- [ ] 3-5 key focus areas

**Good Example**:
```markdown
## Evaluation Lens
Percy approaches papers through rigorous empirical evaluation:
- **Primary question**: "How was this evaluated comprehensively?"
- **Baseline expectations**: Comparisons to strong baselines, multiple metrics
- **Reproducibility**: Clear protocols, data availability, ablation studies
- **Scope**: Does evaluation match claims? Missing failure modes?
```

#### Review Criteria
- [ ] Actionable checklist items
- [ ] Domain-specific when relevant
- [ ] Covers both technical and presentation aspects
- [ ] 5-8 items
- [ ] Phrased as verifiable statements

**Good Example**:
```markdown
## Review Criteria
When reviewing as Percy Liang, focus on:
- [ ] Comprehensive evaluation across scenarios
- [ ] Transparent limitations and failure analysis
- [ ] Reproducibility: data, code, protocols
- [ ] Proper baselines and statistical significance
- [ ] Claims aligned with evidence
```

#### Characteristic Concerns
- [ ] Reflects actual reviewer priorities
- [ ] Specific issues they commonly raise
- [ ] Phrased as critique patterns
- [ ] 4-6 concerns
- [ ] Avoids generic criticisms

**Good Example**:
```markdown
## Characteristic Concerns
- Narrow evaluation that misses edge cases
- Overgeneralized claims from limited benchmarks
- Missing ablations for key design choices
- Proprietary/closed evaluation setups
- Cherry-picked metrics that favor the approach
```

#### Voice & Tone
- [ ] Captures distinctive writing style
- [ ] Uses descriptors (e.g., "methodical," "constructive")
- [ ] References communication approach
- [ ] 3-5 characteristics
- [ ] Consistent with published work

**Good Example**:
```markdown
## Voice & Tone
- Systematic, methodical, evidence-driven
- Values transparency and reproducibility
- Asks probing questions about eval coverage
- Constructive: suggests specific improvements
- Rigorous but not harsh
```

### 3. Category Coverage

All 10 reviewer categories MUST have adequate representation:

| Category | Target Reviewers | Actual | Status |
|----------|------------------|--------|--------|
| **Systems & Infrastructure** | 5 | ? | ⚠ Check |
| **Compilers & PL Theory** | 4 | ? | ⚠ Check |
| **AI Agents & Orchestration** | 6 | ? | ⚠ Check |
| **Prompting & LLM Capabilities** | 5 | ? | ⚠ Check |
| **Human-AI Interaction** | 7 | ? | ⚠ Check |
| **ML Systems & Efficiency** | 5 | ? | ⚠ Check |
| **ML Research / Learning** | 4 | ? | ⚠ Check |
| **Software Engineering & DevOps** | 3 | ? | ⚠ Check |
| **NLP & Information Retrieval** | 4 | ? | ⚠ Check |
| **Security & Safety** | 2 | ? | ⚠ Check |
| **Total** | **45** | **?** | **⚠ Check** |

### 4. Consistency Checks

#### Across Profiles
- [ ] Formatting consistent (same section headers)
- [ ] Size variance within acceptable range (1.5-2.5KB)
- [ ] All use same disclosure footer
- [ ] Keywords align with category assignments
- [ ] No duplicate content (copy-paste errors)

#### Within Profiles
- [ ] Evaluation lens matches research background
- [ ] Review criteria reflect characteristic concerns
- [ ] Voice/tone consistent with lens description
- [ ] Publications support claimed expertise

### 5. Ethical Compliance

- [ ] Every profile has AI Simulation Disclosure
- [ ] Disclosure accurately describes methodology
- [ ] Named researchers are real people (not fictional)
- [ ] Content based on published work (not fabricated)
- [ ] No sensitive or private information included

---

## Validation Tools

### Tool 1: Automated Structure Check

```bash
#!/bin/bash
# profile-structure-check.sh

PROFILES_DIR="context/panel/reviewers/profiles"
REQUIRED_SECTIONS=(
    "Research Background"
    "Key Publications"
    "Evaluation Lens"
    "Review Criteria"
    "Characteristic Concerns"
    "Voice & Tone"
    "AI Simulation"
)

echo "=== Profile Structure Validation ==="
echo

TOTAL=0
PASS=0
FAIL=0

for profile in "$PROFILES_DIR"/*.md; do
    if [ ! -f "$profile" ]; then
        continue
    fi

    TOTAL=$((TOTAL + 1))
    filename=$(basename "$profile")

    # Check YAML frontmatter
    if ! grep -q "^---$" "$profile"; then
        echo "✗ $filename: Missing YAML frontmatter"
        FAIL=$((FAIL + 1))
        continue
    fi

    # Check required sections
    ALL_PRESENT=true
    for section in "${REQUIRED_SECTIONS[@]}"; do
        if ! grep -q "## $section" "$profile"; then
            echo "✗ $filename: Missing section: $section"
            ALL_PRESENT=false
        fi
    done

    # Check size (1.8-2.2KB target)
    SIZE=$(wc -c < "$profile")
    if [ "$SIZE" -lt 1800 ] || [ "$SIZE" -gt 2500 ]; then
        echo "⚠ $filename: Size ${SIZE}B outside target range (1800-2500B)"
    fi

    if [ "$ALL_PRESENT" = true ]; then
        echo "✓ $filename"
        PASS=$((PASS + 1))
    else
        FAIL=$((FAIL + 1))
    fi
done

echo
echo "=== Summary ==="
echo "Total: $TOTAL"
echo "Pass:  $PASS"
echo "Fail:  $FAIL"

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi
```

Make executable and run:
```bash
chmod +x validation/profile-structure-check.sh
./validation/profile-structure-check.sh
```

### Tool 2: Category Coverage Report

```bash
#!/bin/bash
# profile-coverage-report.sh

INDEX_FILE="context/panel/reviewers/_index.yaml"
PROFILES_DIR="context/panel/reviewers/profiles"

echo "=== Category Coverage Report ==="
echo

# Extract categories from index
CATEGORIES=$(grep "^  [a-z-]*:$" "$INDEX_FILE" | sed 's/://g' | xargs)

for category in $CATEGORIES; do
    # Count expected reviewers
    EXPECTED=$(grep -A100 "^  $category:" "$INDEX_FILE" | grep "slug:" | wc -l)

    # Count actual profiles
    ACTUAL=0
    for slug in $(grep -A100 "^  $category:" "$INDEX_FILE" | grep "slug:" | awk '{print $2}'); do
        if [ -f "$PROFILES_DIR/${slug}.md" ]; then
            ACTUAL=$((ACTUAL + 1))
        fi
    done

    # Status
    if [ "$ACTUAL" -eq "$EXPECTED" ]; then
        STATUS="✓"
    else
        STATUS="⚠"
    fi

    printf "%-35s %2d/%2d %s\n" "$category" "$ACTUAL" "$EXPECTED" "$STATUS"
done

echo
echo "Run: ls context/panel/reviewers/profiles/ | wc -l"
echo "To get total profile count"
```

### Tool 3: Content Quality Check

```bash
#!/bin/bash
# profile-quality-check.sh

PROFILES_DIR="context/panel/reviewers/profiles"

echo "=== Profile Content Quality Check ==="
echo

for profile in "$PROFILES_DIR"/*.md; do
    if [ ! -f "$profile" ]; then
        continue
    fi

    filename=$(basename "$profile")

    # Check Research Background length (150-200 words target)
    BG_WORDS=$(sed -n '/## Research Background/,/## Key Publications/p' "$profile" | wc -w)
    if [ "$BG_WORDS" -lt 100 ] || [ "$BG_WORDS" -gt 300 ]; then
        echo "⚠ $filename: Research Background ${BG_WORDS} words (target: 150-200)"
    fi

    # Check for generic phrases (red flags)
    if grep -qi "expert in\|works at a\|has published many" "$profile"; then
        echo "⚠ $filename: Contains generic phrases"
    fi

    # Check Key Publications count (3-5 target)
    PUBS=$(grep -c "^- \*\*" "$profile" || echo 0)
    if [ "$PUBS" -lt 3 ] || [ "$PUBS" -gt 6 ]; then
        echo "⚠ $filename: ${PUBS} publications (target: 3-5)"
    fi

    # Check Review Criteria count (5-8 target)
    CRITERIA=$(sed -n '/## Review Criteria/,/## Characteristic Concerns/p' "$profile" | grep -c "^- \[ \]" || echo 0)
    if [ "$CRITERIA" -lt 4 ] || [ "$CRITERIA" -gt 9 ]; then
        echo "⚠ $filename: ${CRITERIA} criteria (target: 5-8)"
    fi

    # Check for AI Simulation Disclosure
    if ! grep -q "AI Simulation Disclosure" "$profile"; then
        echo "✗ $filename: Missing AI Simulation Disclosure"
    fi
done

echo
echo "Review warnings manually for quality issues"
```

### Tool 4: Consistency Check

```bash
#!/bin/bash
# profile-consistency-check.sh

PROFILES_DIR="context/panel/reviewers/profiles"
INDEX_FILE="context/panel/reviewers/_index.yaml"

echo "=== Profile Consistency Check ==="
echo

# Check YAML frontmatter consistency
echo "Checking YAML frontmatter..."
for profile in "$PROFILES_DIR"/*.md; do
    if [ ! -f "$profile" ]; then
        continue
    fi

    filename=$(basename "$profile" .md)

    # Extract frontmatter
    NAME=$(sed -n '/^name:/p' "$profile" | sed 's/name: //')
    CATEGORY=$(sed -n '/^category:/p' "$profile" | sed 's/category: //')

    # Cross-reference with index
    if ! grep -q "slug: $filename" "$INDEX_FILE"; then
        echo "⚠ $filename: Not found in _index.yaml"
    fi

    # Check category assignment
    if ! grep -A100 "^  $CATEGORY:" "$INDEX_FILE" | grep -q "slug: $filename"; then
        echo "⚠ $filename: Category mismatch with _index.yaml"
    fi
done

echo
echo "Checking disclosure footer consistency..."
DISCLOSURE_COUNT=$(grep -l "AI Simulation Disclosure" "$PROFILES_DIR"/*.md | wc -l)
TOTAL_COUNT=$(ls "$PROFILES_DIR"/*.md 2>/dev/null | wc -l)

if [ "$DISCLOSURE_COUNT" -ne "$TOTAL_COUNT" ]; then
    echo "⚠ Disclosure present in $DISCLOSURE_COUNT/$TOTAL_COUNT profiles"
else
    echo "✓ Disclosure present in all profiles"
fi
```

---

## Manual Review Checklist

For a sample of 5 profiles (one from each major category), perform deep manual review:

### Profile: _______________

**Structural Completeness**: □ Pass □ Fail
- [ ] YAML frontmatter complete
- [ ] All 7 sections present
- [ ] Size within range (1.8-2.2KB)

**Content Quality**: □ Pass □ Fail
- [ ] Research background accurate and specific
- [ ] Publications real and relevant
- [ ] Evaluation lens reflects actual approach
- [ ] Review criteria actionable
- [ ] Concerns domain-specific
- [ ] Voice descriptors match published work

**Consistency**: □ Pass □ Fail
- [ ] Lens matches background
- [ ] Criteria reflect concerns
- [ ] Publications support claimed expertise

**Ethical Compliance**: □ Pass □ Fail
- [ ] AI Simulation Disclosure present
- [ ] Named researcher is real person
- [ ] Content based on published work

**Voice Distinctiveness**: □ Pass □ Fail
- [ ] Review reads differently from other personas
- [ ] Characteristic questions evident
- [ ] Writing style identifiable

**Notes**:
_______________________________________________________________
_______________________________________________________________

---

## Acceptance Criteria

Profile system is ready for operational rollout if:

- [ ] All 45 profiles structurally complete (automated check passes)
- [ ] Category coverage complete (10/10 categories at target levels)
- [ ] Manual review of 5 profiles passes all criteria
- [ ] No duplicate or generic content detected
- [ ] AI Simulation Disclosure in all profiles
- [ ] Consistency checks pass (YAML, index, category)
- [ ] Average size 1.8-2.2KB
- [ ] Voice distinctiveness confirmed in sample

---

## Profile Generation Workflow

When generating new profiles:

1. **Research Phase**
   - Read 3-5 recent papers by the researcher
   - Review their institutional profile
   - Check h-index and citation patterns
   - Identify seminal contributions

2. **Template Phase**
   - Start with `templates/reviewer-profile-template.md`
   - Fill in YAML frontmatter from `_index.yaml`
   - Draft Research Background (2-3 paragraphs)
   - List Key Publications (3-5 papers)

3. **Characterization Phase**
   - Define Evaluation Lens (characteristic questions)
   - Create Review Criteria checklist (5-8 items)
   - Document Characteristic Concerns (4-6 issues)
   - Describe Voice & Tone (3-5 descriptors)

4. **Validation Phase**
   - Run `profile-structure-check.sh`
   - Run `profile-quality-check.sh`
   - Verify size (1.8-2.2KB)
   - Confirm disclosure footer

5. **Integration Phase**
   - Update `_index.yaml` with `profile_exists: true`
   - Test profile loading via `panel:reviewers show <name>`
   - Verify profile appears in category listings
   - Commit with message: `[panel] Add reviewer profile: <name>`

---

## Remediation Actions

### Issue: Profile too short (<1.8KB)
**Fix**: Expand Research Background or add more publications

### Issue: Profile too long (>2.2KB)
**Fix**: Condense Background to 2-3 paragraphs, reduce publications to 3-5

### Issue: Generic content detected
**Fix**: Research specific contributions, add distinctive questions to Evaluation Lens

### Issue: Voice not distinctive
**Fix**: Review published papers for writing style, add specific phrasing patterns

### Issue: Missing disclosure
**Fix**: Append disclosure footer from template

### Issue: Category mismatch
**Fix**: Update `_index.yaml` or profile category field to match

---

## References

- Template: `templates/reviewer-profile-template.md`
- Example: `test/fixtures/profiles/cookie-monster.md` (Sesame Street, for testing)
- Master registry: `context/panel/reviewers/_index.yaml`
- Loader: `shared/reviewer-profile-loader.md`
- Database source: `templates/REVIEWER-DATABASE.md` (45 reviewers)
