# Content Analyzer

Analyzes paper directory content and infers appropriate content mode for reviews.

## Purpose

Automatically detect whether a paper is at abstract, draft, or full stage based on actual content, preventing inappropriate reviews (e.g., critiquing missing methodology when only an abstract exists).

## Content Mode Definitions

| Mode | Content Level | Word Count | Review Focus | Max Stage |
|------|--------------|------------|--------------|-----------|
| `abstract` | Abstract/outline only | <500 words | Concept viability, novelty, scope | `synthesis` |
| `draft` | Incomplete paper | 500-3000 words | Structure, feasibility, approach | `revision` |
| `full` | Complete paper | 3000+ words | Publication readiness, rigor | `accepted` |

## Analysis Criteria

```yaml
Check for:
  - main.tex exists with \begin{abstract}
  - Section files (*.tex in sections/, src/, or inline)
  - Line counts and estimated word counts
  - Bibliography file existence (.bib)
  - Figures/tables directories
  - Total estimated content
```

## Word Count Estimation

- LaTeX comments and commands excluded
- Approximate: 8-10 words per line of actual content
- Count lines in:
  - Abstract section
  - All section files
  - Inline content in main.tex

## Inference Logic

```python
def infer_mode(analysis):
    word_count = analysis['word_count']
    section_count = analysis['section_count']
    section_words = analysis['section_words']

    # Abstract mode: minimal content
    if word_count < 500 or (section_count == 0 and word_count < 1000):
        return 'abstract'

    # Draft mode: some content but incomplete
    elif word_count < 3000 or (section_words < 2000):
        return 'draft'

    # Full mode: substantial content
    else:
        return 'full'
```

## Analysis Output Format

```yaml
content_analysis:
  main_tex_exists: true
  main_tex_lines: 65
  abstract_found: true
  abstract_words: ~250
  section_files:
    - introduction.tex (0 lines)
    - methodology.tex (0 lines)
  section_count: 2
  section_words: ~0
  bibliography_exists: false
  figures_dir_exists: false
  total_word_count: ~250
  inferred_mode: abstract
  confidence: high  # high | medium | low
```

## Implementation

### Function: analyze_paper_content(paper_dir)

```bash
analyze_paper_content() {
    local paper_dir=$1
    local main_tex="${paper_dir}/main.tex"

    # Initialize analysis
    local analysis=()

    # Check main.tex
    if [[ -f "$main_tex" ]]; then
        analysis[main_tex_exists]=true
        analysis[main_tex_lines]=$(wc -l < "$main_tex")

        # Check for abstract
        if grep -q "\\begin{abstract}" "$main_tex"; then
            analysis[abstract_found]=true
            # Extract and count abstract words (rough estimate)
            local abstract_lines=$(sed -n '/\\begin{abstract}/,/\\end{abstract}/p' "$main_tex" | wc -l)
            analysis[abstract_words]=$((abstract_lines * 8))
        fi
    fi

    # Check section files
    local section_dirs=("sections" "src")
    local section_count=0
    local section_words=0

    for dir in "${section_dirs[@]}"; do
        if [[ -d "${paper_dir}/${dir}" ]]; then
            while IFS= read -r section_file; do
                if [[ -f "$section_file" ]]; then
                    local lines=$(wc -l < "$section_file")
                    section_count=$((section_count + 1))
                    section_words=$((section_words + lines * 8))
                    analysis[section_files]+="$(basename "$section_file") ($lines lines), "
                fi
            done < <(find "${paper_dir}/${dir}" -name "*.tex")
        fi
    done

    analysis[section_count]=$section_count
    analysis[section_words]=$section_words

    # Check bibliography
    if [[ -f "${paper_dir}/references.bib" ]] || [[ -f "${paper_dir}/bibliography.bib" ]]; then
        analysis[bibliography_exists]=true
    fi

    # Check figures
    if [[ -d "${paper_dir}/figures" ]] || [[ -d "${paper_dir}/imgs" ]]; then
        analysis[figures_dir_exists]=true
    fi

    # Calculate total word count
    local total_words=$((${analysis[abstract_words]:-0} + section_words))
    analysis[total_word_count]=$total_words

    # Infer mode
    if (( total_words < 500 )) || (( section_count == 0 && total_words < 1000 )); then
        analysis[inferred_mode]="abstract"
        analysis[confidence]="high"
    elif (( total_words < 3000 )) || (( section_words < 2000 )); then
        analysis[inferred_mode]="draft"
        analysis[confidence]="medium"
    else
        analysis[inferred_mode]="full"
        analysis[confidence]="high"
    fi

    # Return as JSON-like string
    echo "${analysis[@]}"
}
```

## Display Format

```
📄 Content Analysis
   main.tex: ✓ 65 lines
   Abstract: ✓ ~250 words
   Sections: 0 files (empty directory)
   Bibliography: ✗ not found
   Total: ~250 words

⚙️ Inferred Content Mode: abstract (high confidence)
```

## Mode Descriptions for User Confirmation

### Abstract Mode
```
Expected review behavior:
• Focus on concept viability and novelty
• Evaluate research question significance
• Assess feasibility of proposed approach
• No critique of missing implementation details
• Terminal stage: synthesis (won't advance to submission)
```

### Draft Mode
```
Expected review behavior:
• Evaluate structure and organization
• Assess methodology feasibility
• Review preliminary results if available
• Identify gaps requiring completion
• Can advance to: revision (after addressing issues)
```

### Full Mode
```
Expected review behavior:
• Full publication readiness evaluation
• Rigorous methodology critique
• Complete results assessment
• Writing quality and clarity
• Can advance to: accepted (full lifecycle)
```

## Integration Points

### In commands/review.md

```bash
# Before starting review process
if [[ -z "${state[content_mode]}" ]]; then
    # Run content analysis
    analysis=$(analyze_paper_content "$paper_dir")

    # Show analysis and get confirmation
    show_content_analysis "$analysis"
    confirm_content_mode "$analysis"

    # Save confirmed mode to _panel.yaml
    state[content_mode]=$confirmed_mode
    state[content_mode_confirmed]=true
    state[content_analysis]="$analysis"
    save_state
fi
```

### In templates/review-template.md

Add section at top:
```markdown
---
**Content Mode: {MODE}**

{MODE_SPECIFIC_INSTRUCTIONS}
---
```

### In shared/stage-machine.md

Add mode-aware gate checks:
```bash
can_advance_from_synthesis() {
    local mode=${state[content_mode]:-full}

    if [[ "$mode" == "abstract" ]]; then
        echo "Terminal stage for abstract mode - use 'Concept Approved' verdict"
        return 1
    fi

    # Normal synthesis gate checks...
}
```

## Error Handling

- **No main.tex found**: Ask user if paper structure is non-standard
- **Ambiguous inference**: Show analysis, ask user to choose
- **User override**: Always allow manual mode selection
- **Mode mismatch**: Warn if content changes significantly (e.g., draft→full transition detected)

## Future Enhancements

- PDF analysis if available (page count, section detection)
- Git history analysis (commit frequency, file changes)
- Compare against venue typical paper length
- Machine learning-based content classification
