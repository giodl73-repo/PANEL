---
format_version: "4.0"
---

# Wave Manager - Editor Patterns

**Last Updated**: 2026-01-29
**Focus**: Technical writing, content condensing, clarity optimization

---

## Overview

Editorial patterns for condensing technical documentation to meet page/length targets while preserving meaning, clarity, and technical accuracy. Essential for fitting content into constrained formats like PDFs, slides, or documentation with page limits.

---

## Core Principles

### The 3 C's of Technical Editing

1. **Concise**: Remove unnecessary words without losing meaning
2. **Clear**: Maintain readability and comprehension
3. **Complete**: Preserve all critical information

### Target-Driven Editing

Always edit with a specific goal:
- Target page count (e.g., "fit in 20 pages")
- Target word count (e.g., "500 words max")
- Target reading time (e.g., "5-minute read")
- Visual constraint (e.g., "fit in one slide")

---

## Condensing Strategies

### Strategy 1: Remove Filler Words

Identify and eliminate words that don't add meaning:

```
❌ VERBOSE: "In order to achieve the goal of implementing this feature"
✅ CONCISE: "To implement this feature"

❌ VERBOSE: "It is important to note that this system utilizes"
✅ CONCISE: "This system uses"

❌ VERBOSE: "Due to the fact that we need to ensure compatibility"
✅ CONCISE: "To ensure compatibility"
```

**Common filler patterns to cut:**
- "in order to" → "to"
- "due to the fact that" → "because"
- "at this point in time" → "now"
- "for the purpose of" → "to"
- "it is important to note that" → (delete entirely)
- "it should be noted that" → (delete entirely)

### Strategy 2: Convert Sentences to Phrases

Transform full sentences into concise phrases for tables, lists, and headers:

```
❌ VERBOSE: "This is a major development initiative that includes clear goals, success metrics, multiple phases, and role assignments for parallel work"
✅ CONCISE: "Development initiative with goals, metrics, phases, and role assignments"

❌ VERBOSE: "FastAPI framework with Python programming language, PostgreSQL databases, and REST API endpoints"
✅ CONCISE: "FastAPI, Python, databases, APIs"

❌ VERBOSE: "React framework with TypeScript language and user interface components"
✅ CONCISE: "React, TypeScript, UI components"
```

**Pattern:**
- Remove helping verbs ("is", "has", "includes")
- Use commas instead of conjunctions
- Prefer nouns over noun phrases

### Strategy 3: Use Standard Abbreviations

Technical audiences understand standard abbreviations:

```
✅ API (Application Programming Interface)
✅ DB (Database)
✅ UI/UX (User Interface/Experience)
✅ QA (Quality Assurance)
✅ PM (Product Manager)
✅ TPM (Technical Program Manager)
✅ FE/BE (Frontend/Backend)
✅ E2E (End-to-End)
```

**Rule:** Use abbreviations that are:
- Industry standard
- Defined once in the document
- Clear in context

### Strategy 4: Consolidate Similar Items

Group related concepts instead of listing individually:

```
❌ VERBOSE:
- React components
- TypeScript interfaces
- Vite configuration
- ESLint rules
- Prettier settings

✅ CONCISE:
- React/TypeScript setup (components, interfaces, config)
- Code quality tools (ESLint, Prettier)
```

### Strategy 5: Parallel Structure for Lists

Use consistent grammatical structure to reduce word count:

```
❌ VERBOSE:
- You should identify the problem or opportunity
- It's important to define what success looks like
- Breaking work into smaller phases is necessary
- Make sure to assign phases to appropriate roles

✅ CONCISE:
- Identify problem/opportunity
- Define success criteria
- Break work into phases
- Assign phases to roles
```

**Pattern:** Use imperatives (command form) for action items.

### Strategy 6: Combine Redundant Points

Merge overlapping concepts:

```
❌ VERBOSE:
- Multi-phase features
- Features requiring 3+ weeks of work
- Complex features with multiple components

✅ CONCISE:
- Multi-phase features requiring 3+ weeks of work
```

---

## Condensing by Content Type

### Headers and Titles

```
❌ "A Comprehensive Guide to Understanding the Wave System Lifecycle"
✅ "Wave System Lifecycle"

❌ "Best Practices and Recommendations for Effective Wave Planning"
✅ "Wave Planning Best Practices"
```

**Rule:** Titles should be 3-6 words. Remove adjectives and "guide to" phrases.

### Descriptions (Tables, Definitions)

```
❌ "This is a comprehensive list of all the activities that should be performed during this phase"
✅ "Phase activities"

❌ "A specialized expert agent who focuses on backend development using FastAPI"
✅ "FastAPI backend specialist"
```

**Rule:** Aim for 3-8 words in table cells.

### Instructions and Steps

```
❌ "You should navigate to the backend directory by using the cd command"
✅ "Navigate to backend directory: cd apps/tcm-backend"

❌ "It is necessary to make sure that you run the migration after you have made any changes to the database models"
✅ "Run migration after model changes"
```

**Rule:** Use imperative mood. Include essential technical details.

### Examples and Code Comments

```
❌ "Here is an example that demonstrates how to implement this pattern"
✅ "Example implementation:"

❌ "This code snippet shows the proper way to handle errors"
✅ "Error handling example:"
```

**Rule:** Let code speak for itself. Minimal explanatory text.

---

## Page Targeting Workflow

### Step 1: Measure Current State

```bash
# For LaTeX
pdflatex main.tex
# Check page count in PDF viewer
# Current: 45 pages, Target: 30 pages

# Need to reduce by: 33% (15 pages)
```

### Step 2: Identify High-Impact Targets

Prioritize edits by impact:

1. **Tables** - Convert to lists (can save 50-70% space)
2. **Verbose paragraphs** - Apply condensing strategies (save 30-40%)
3. **Redundant sections** - Merge or eliminate (save 100%)
4. **Examples** - Keep only essential ones (variable savings)

### Step 3: Apply Strategies in Order

```
1. Convert wide/complex tables to bulleted lists
2. Remove filler words from all paragraphs
3. Shorten table entries and descriptions
4. Consolidate redundant points
5. Use abbreviations consistently
6. Tighten headings and titles
```

### Step 4: Measure and Iterate

```bash
# Recompile and check
pdflatex main.tex
# Current: 35 pages (saved 10 pages, need 5 more)

# Continue with next strategy
```

---

## Before/After Examples from Real Work

### Example 1: Table to List Conversion

**Before (Table - 8 lines):**
```latex
\begin{tabular}{ll}
\toprule
\textbf{Use Case} & \textbf{Description} \\
\midrule
Multi-phase features & Features that require 3+ weeks \\
Multi-role projects & Projects with specialized roles \\
Architectural changes & Structural modifications \\
\bottomrule
\end{tabular}
```

**After (List - 5 lines):**
```latex
\textbf{Use Waves For:}
\begin{itemize}
    \item Multi-phase features requiring 3+ weeks of work
    \item Multi-role projects with specialized roles (Frontend, Backend, QA)
    \item Architectural changes requiring structural modifications
\end{itemize}
```

**Savings:** 37% reduction in lines, better readability

### Example 2: Verbose Description Condensing

**Before:**
```
This is a major development initiative that includes clear goals and
objectives, measurable success metrics, multiple phases of work that
build upon each other, role assignments that enable parallel work,
explicit dependencies between different components, a clear timeline
for execution, and a formal review and approval process
```

**After:**
```
Development initiative with goals, metrics, phases, role assignments,
dependencies, timeline, and review approval
```

**Savings:** 68% reduction (41 words → 13 words)

### Example 3: Multi-Column Table Simplification

**Before (4-column table):**
```
\begin{tabular}{llll}
Role & Primary & Secondary & Tools \\
Full-Stack & Frontend & Backend & React, FastAPI \\
Portal & Frontend & Design & React, Figma \\
\end{tabular}
```

**After (Bulleted list):**
```
\begin{itemize}
    \item \textbf{Full-Stack}: Frontend (React, TS) + Backend (FastAPI)
    \item \textbf{Portal}: Frontend (React) + Design (Layout, components)
\end{itemize}
```

**Savings:** More readable, 30% less horizontal space

---

## Quality Checks

After condensing, verify:

✅ **Meaning preserved** - Core message unchanged
✅ **Technical accuracy** - All facts correct
✅ **Grammar valid** - No sentence fragments (unless intentional)
✅ **Clarity maintained** - Still easy to understand
✅ **Consistency** - Parallel structure, terminology
✅ **Target achieved** - Page count, word count, etc.

---

## Common Pitfalls

❌ **Removing too much context**
```
BAD: "Use waves"  (Missing: when? why?)
GOOD: "Use waves for multi-phase features requiring 3+ weeks"
```

❌ **Creating ambiguity**
```
BAD: "Run tests"  (Which tests? When?)
GOOD: "Run unit tests after model changes"
```

❌ **Inconsistent abbreviations**
```
BAD: Using "FE", "Frontend", and "front-end" in same document
GOOD: Pick one ("Frontend") and use consistently
```

❌ **Sacrificing readability for length**
```
BAD: "Init wave w/ plnng doc, mtrcs, phss, deps"
GOOD: "Initialize wave with planning document, metrics, phases, dependencies"
```

---

## Tools and Techniques

### Word Count Tools

```bash
# LaTeX word count
texcount main.tex

# Markdown word count
wc -w document.md

# Count with structure
texcount -inc -total main.tex
```

### Automated Checks

```bash
# Find verbose patterns
grep -r "in order to\|due to the fact\|it is important" *.tex

# Find long lines (potential for condensing)
awk 'length > 120' document.md
```

### Manual Review Checklist

- [ ] Every sentence starts strong (no "It is", "There are")
- [ ] No redundant adjectives ("very important" → "critical")
- [ ] Active voice preferred ("system processes" vs "is processed by")
- [ ] Specific numbers/metrics included where relevant
- [ ] Parallel structure in lists
- [ ] Consistent terminology

---

## Editorial Style Preferences

### For Technical Documentation

**Prefer:**
- Active voice
- Present tense
- Imperative mood for instructions
- Bullet points over paragraphs
- Code examples over lengthy explanations
- Specific over general

**Avoid:**
- Passive voice ("is created by" → "creates")
- Future tense ("will create" → "creates")
- Superlatives ("extremely", "very", "highly")
- Marketing language ("revolutionary", "cutting-edge")
- Weasel words ("might", "could", "possibly")

### Tone Guidelines

✅ **Authoritative**: "Use this pattern for API endpoints"
❌ **Uncertain**: "You might want to consider using this pattern"

✅ **Direct**: "Include error handling"
❌ **Wordy**: "It is recommended that you should probably include some form of error handling"

✅ **Precise**: "Reduce response time by 50%"
❌ **Vague**: "Significantly improve performance"

---

## Integration with Other Disciplines

### Works with Typesetting

- Editor condenses content → Typesetter formats into LaTeX tables/lists
- Page target from typesetting → Editor strategies to achieve it

### Works with Documentation

- Editor ensures clarity → Documentation maintains accuracy
- Both focus on user comprehension

### Works with Skills/PM

- Editor makes skill prompts concise → Skills discipline optimizes for AI
- PM metrics inform condensing priorities (what matters most)

---

## Quick Reference

### Condensing Checklist

1. **Remove filler words** ("in order to" → "to")
2. **Convert sentences to phrases** (for tables/lists)
3. **Use standard abbreviations** (API, DB, UI, QA)
4. **Consolidate similar items** (group related concepts)
5. **Parallel structure** (consistent grammar in lists)
6. **Combine redundant points** (merge overlapping ideas)

### Before Publishing

- [ ] Target page/word count achieved
- [ ] Meaning and accuracy preserved
- [ ] Clarity maintained or improved
- [ ] Consistent terminology throughout
- [ ] Grammar and style correct
- [ ] All technical details accurate

---

## Measuring Success

**Good condensing achieves:**
- 30-50% reduction in length
- Equal or better clarity
- 100% preserved technical accuracy
- Improved scanability
- Maintained professional tone

**Example metrics:**
```
Before: 45 pages, 12,000 words, avg 8 words/sentence
After:  30 pages,  7,500 words, avg 6 words/sentence
Savings: 33% pages, 37% words, 25% avg sentence length
Quality: All technical content preserved, readability improved
```

---

**Key Learnings:**
1. Start with high-impact edits (tables → lists)
2. Preserve meaning while removing fluff
3. Use abbreviations and parallel structure
4. Target-driven editing (know your goal)
5. Always verify technical accuracy after editing

---

**Last Updated**: 2026-01-29
**Version**: 1.0
**Status**: Active
