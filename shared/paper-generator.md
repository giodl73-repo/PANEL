# Paper Generator — Generate Full Paper Content

Shared utility for generating complete paper directories with LaTeX content. Creates the same structure as `panel:setup` per-paper mode but with substantive content instead of empty templates.

## CRITICAL: Template Policy

**NEVER use conference-specific templates or document classes** (e.g., `acmart`, `neurips_2024`, `aaai`, `acl`) unless:
1. User **explicitly states** they are submitting to a specific conference
2. User has received **actual feedback from real reviewers** and is preparing resubmission

**Default**: Use generic `article` class with clean, professional formatting. This emphasizes that papers are for quality improvement, not conference submission.

## Function

### generate_paper(proposal, options)

```
Input:
  proposal:  topic discovery proposal object (from shared/topic-discovery.md)
  options:
    project_dir:    path to project root (default: research/)
    author:         author name (default: "Gio Della-Libera")
    affiliation:    affiliation line (default: "Business & Industry Copilots Agents 365")
    date:           publication date (default: current month/year)
    existing_papers: array of existing paper names for cross-referencing

Output:
  Creates complete paper directory with all files
  Returns { dir, paper_name, files_created, panel_yaml_path }
```

## Directory Structure Created

```
research/{proposal.slug}/
├── main.tex              # Full document with preamble, abstract, section includes
├── sections/
│   ├── 01-introduction.tex
│   ├── 02-related-work.tex
│   ├── 03-methodology.tex
│   ├── 04-evaluation.tex
│   ├── 05-discussion.tex
│   └── 06-conclusion.tex
├── reviews/              # Empty directory for future reviews
├── Makefile              # Paper-level build targets
└── _panel.yaml           # Initialized state
```

## LaTeX Template

Uses the same preamble, color definitions, and formatting as existing papers (matching `panel-review-methodology/main.tex`):

### main.tex Template

```latex
\documentclass[11pt,letterpaper]{article}
\usepackage[margin=1in]{geometry}
\usepackage{graphicx}
\usepackage{booktabs}
\usepackage{enumitem}
\usepackage{xcolor}
\usepackage{listings}
\usepackage{hyperref}
\usepackage[table]{colortbl}
\usepackage{tikz}
\usetikzlibrary{positioning,shapes,arrows}
\usepackage{amsmath}

\definecolor{primaryblue}{RGB}{0,120,212}
\definecolor{textgray}{RGB}{50,50,50}
\definecolor{codebg}{RGB}{248,248,248}

\lstset{basicstyle=\ttfamily\small,backgroundcolor=\color{codebg},breaklines=true,frame=single,framerule=0pt}
\hypersetup{colorlinks=true,linkcolor=primaryblue,urlcolor=primaryblue,citecolor=primaryblue}

\begin{document}

\begin{center}
{\LARGE\bfseries {TITLE}\par}
\vspace{0.8cm}
{\large {AUTHOR}\par}
{\normalsize {AFFILIATION}\par}
\vspace{0.3cm}
{\normalsize {DATE}\par}
\vspace{0.8cm}
\end{center}

\begin{abstract}
\noindent
{ABSTRACT}
\end{abstract}

\vspace{0.5cm}

\input{sections/01-introduction}
\input{sections/02-related-work}
\input{sections/03-methodology}
\input{sections/04-evaluation}
\input{sections/05-discussion}
\input{sections/06-conclusion}

\end{document}
```

Replace `{TITLE}`, `{AUTHOR}`, `{AFFILIATION}`, `{DATE}`, and `{ABSTRACT}` with actual content from the proposal. For multi-line titles (containing a colon), split at the colon with `\\[0.3em]`.

### Makefile Template

```makefile
OUTPUT = main.pdf
DIST_DIR = ../docs
DIST_FILE = $(DIST_DIR)/{SLUG}.pdf

.PHONY: all pdf clean dist

all: pdf

pdf: main.tex sections/*.tex
	latexmk -pdf -interaction=nonstopmode main.tex

clean:
	latexmk -C
	rm -f *.aux *.log *.out *.toc *.fls *.fdb_latexmk *.synctex.gz

dist: pdf
	@mkdir -p $(DIST_DIR)
	cp $(OUTPUT) $(DIST_FILE)
	@echo "Copied to $(DIST_FILE)"
```

Replace `{SLUG}` with `proposal.slug`.

## Section Content Generation

Each section should contain **substantive content** that draws on the proposal's evidence, not just placeholder text. The content should be a complete first draft suitable for review.

### 01-introduction.tex

Generate based on the proposal's `abstract_sketch` and `evidence`:

1. **Opening paragraph**: State the problem/gap this paper addresses. Reference the broader research context.
2. **Motivation paragraph**: Why this matters now. Draw on evidence items to ground the motivation.
3. **Contributions list**: 3-4 specific contributions derived from the proposal's scope.
4. **Paper organization**: "The remainder of this paper is organized as follows..."

Use `\section{Introduction}` heading.

### 02-related-work.tex

Generate based on the proposal's `venue` and domain:

1. **Domain-specific subsection**: Prior work in the paper's primary domain (e.g., AI systems, HCI, NLP).
2. **Methodological subsection**: Prior work on the methodology used.
3. **Gap identification**: What the related work misses that this paper addresses.

Use `\section{Related Work}` heading with `\subsection{}` for each area.

### 03-methodology.tex

Generate based on the proposal's evidence and approach:

1. **Overview**: High-level description of the approach/methodology.
2. **Design principles**: 3-4 principles guiding the design.
3. **Architecture/Process**: Describe the system, framework, or process. Use evidence items from the proposal to provide concrete details.
4. **Implementation**: Key implementation details.

Use `\section{Methodology}` heading (or `\section{Approach}` if more appropriate).

### 04-evaluation.tex

Generate based on the proposal's evidence:

1. **Evaluation setup**: What was measured, how, and why.
2. **Data sources**: Describe the evidence base (waves, commits, review data, etc.).
3. **Results**: Present findings organized by research question or hypothesis. Reference evidence items.
4. **Metrics**: Use tables or enumerated results where appropriate.

Use `\section{Evaluation}` heading.

### 05-discussion.tex

1. **Key findings**: Summarize the most important results and their implications.
2. **Limitations**: Honest assessment (2-3 limitations).
3. **Implications for practice**: What practitioners should take away.
4. **Future work**: 2-3 concrete future directions.

Use `\section{Discussion}` heading.

### 06-conclusion.tex

1. **Summary**: 1 paragraph recapping the contribution.
2. **Key takeaways**: 2-3 bullet points.
3. **Closing statement**: Forward-looking final sentence.

Use `\section{Conclusion}` heading.

## _panel.yaml Generation

Create with populated fields (not empty like setup templates):

```yaml
paper: {proposal.slug}
title: "{proposal.title}"
venue: "{proposal.venue}"
stage: draft
round: 0
reviewers: []
reviews: {}
p1_items: []
history:
  - stage: draft
    date: {today}
    note: "Generated via panel:import --from {proposal.source}"
```

## RESEARCH.md Update

After generating a paper, append to the Paper Inventory table in `research/RESEARCH.md`:

1. Read current RESEARCH.md
2. Find the Paper Inventory table
3. Determine next paper number (count existing rows + 1)
4. Append row:
   ```
   | {N} | [{slug}]({slug}/) | {title} | [PDF](docs/{slug}.pdf) | {venue} | — | — |
   ```
5. Write updated RESEARCH.md

## Dependencies

- shared/state-loader.md — save_state() for _panel.yaml creation
- shared/display-utils.md — formatting for generation report
