#!/usr/bin/env bash
# create-mock-monorepo.sh — Generate a mock monorepo with Sesame Street reviewers
# Usage: ./create-mock-monorepo.sh [--path <dir>] [--clean]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${SCRIPT_DIR}/fixtures/mock-monorepo"
CLEAN=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --path) TARGET="$2"; shift 2 ;;
    --clean) CLEAN=true; shift ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

if $CLEAN && [[ -d "$TARGET" ]]; then
  echo "Cleaning $TARGET..."
  rm -rf "$TARGET"
fi

echo "Creating mock monorepo at: $TARGET"
mkdir -p "$TARGET"

# ═══════════════════════════════════════════════════════════════════════════════
# HELPER FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════════

make_paper_dir() {
  local module="$1" paper="$2"
  mkdir -p "$TARGET/$module/$paper/sections"
  mkdir -p "$TARGET/$module/$paper/reviews"
}

write_main_tex() {
  local dir="$1" title="$2" topic="$3"
  cat > "$dir/main.tex" << LATEX
\\documentclass[11pt,letterpaper]{article}
\\usepackage[margin=1in]{geometry}
\\usepackage{graphicx}
\\usepackage{booktabs}
\\usepackage{enumitem}
\\usepackage{xcolor}
\\usepackage{hyperref}
\\usepackage{amsmath}

\\begin{document}

\\begin{center}
{\\LARGE\\bfseries ${title}\\par}
\\vspace{0.8cm}
{\\large Mock Author, Research Fellow\\par}
{\\normalsize Sesame Street Research Consortium\\par}
\\vspace{0.3cm}
{\\normalsize February 2026\\par}
\\vspace{0.8cm}
\\end{center}

\\begin{abstract}
\\noindent
This paper presents a comprehensive study of ${topic}. Lorem cookie ipsum dolor sit amet, chocolate chip adipiscing elit. Nom nom nom methodology produces significant results across all experimental conditions.
\\end{abstract}

\\vspace{0.5cm}

\\input{sections/01-introduction}

\\end{document}
LATEX
}

write_section() {
  local dir="$1" num="$2" name="$3" content="$4"
  cat > "$dir/sections/${num}-${name}.tex" << LATEX
\\section{$(echo "$name" | sed 's/-/ /g; s/\b\(.\)/\u\1/g')}

${content}
LATEX
}

write_makefile() {
  local dir="$1" name="$2"
  cat > "$dir/Makefile" << 'MKEOF'
OUTPUT = main.pdf
DIST_DIR = ../docs
DIST_FILE = $(DIST_DIR)/PAPER_NAME.pdf

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
MKEOF
  sed -i "s/PAPER_NAME/${name}/g" "$dir/Makefile"
}

# Format reviewer name for filenames: "Cookie Monster" → "COOKIE-MONSTER"
reviewer_filename() {
  echo "$1" | tr '[:lower:]' '[:upper:]' | tr ' ' '-' | sed 's/\.//g'
}

# ═══════════════════════════════════════════════════════════════════════════════
# REVIEW GENERATOR
# ═══════════════════════════════════════════════════════════════════════════════

write_review() {
  local file="$1" paper_title="$2" reviewer="$3" affiliation="$4"
  local expertise="$5" score="$6" verdict="$7" round="$8"
  local personality="$9" major_issue="${10}" minor_issue="${11}"

  local score_label
  case $score in
    1) score_label="Reject" ;;
    2) score_label="Major Revisions Required" ;;
    3) score_label="Accept with Minor Revisions" ;;
    4) score_label="Strong Accept" ;;
  esac

  cat > "$file" << REVIEW
# Review: ${paper_title}

**Reviewer**: ${reviewer} (${affiliation})
**Expertise**: ${expertise}
**Round**: ${round}
**Date**: 2026-01-15

---

## Overall Assessment

${personality}

## Score

**Score**: ${score}/4 — ${score_label}

## Major Issues (Blocking)

### M1: ${major_issue}

This needs to be addressed before the paper can advance. The current treatment is insufficient for the target venue.

## Minor Issues

### m1: ${minor_issue}

This would strengthen the paper but is not blocking.

## Strengths

1. The topic is well-motivated and timely.
2. The experimental setup is creative and appropriate.
3. Writing is generally clear and accessible.

## Questions for Authors

1. Have the authors considered alternative approaches to the core methodology?
2. How would results change with a larger sample size?

## Recommendations

- Address M1 before resubmission.
- Consider expanding the related work section.

---

**Verdict**: ${verdict}

**Confidence**: Medium — Reviewer has relevant expertise but limited experience with this specific sub-area.
REVIEW
}

# ═══════════════════════════════════════════════════════════════════════════════
# SYNTHESIS GENERATOR
# ═══════════════════════════════════════════════════════════════════════════════

write_synthesis() {
  local file="$1" paper_title="$2" paper_name="$3" round="$4"
  local avg_score="$5" score_range="$6" consensus="$7" overall_verdict="$8"
  shift 8
  # Remaining args: reviewer_lines (name|affiliation|score|verdict separated by newlines)
  local reviewer_data="$*"

  local sigma
  case $consensus in
    Strong) sigma="0.45" ;;
    Moderate) sigma="0.82" ;;
    Weak) sigma="1.10" ;;
  esac
  local sigma_char=$'\xcf\x83'  # UTF-8 sigma

  # Build reviewer table
  local reviewer_table=""
  IFS='|' read -ra reviewers <<< "$reviewer_data"
  for r in "${reviewers[@]}"; do
    IFS=';' read -r rname raff rscore rverdict <<< "$r"
    reviewer_table="${reviewer_table}| ${rname} | ${raff} | ${rscore}/4 | ${rverdict} |
"
  done

  cat > "$file" << SYNTH
# Review Synthesis — ${paper_title}

**Paper**: ${paper_name}
**Round**: ${round}
**Date**: 2026-01-20
**Reviewers**: 5

---

## Overview

| Metric | Value |
|--------|-------|
| Average Score | ${avg_score}/4 |
| Score Range | ${score_range}/4 |
| Consensus | ${consensus} (${sigma_char} = ${sigma}) |
| Overall Verdict | ${overall_verdict} |

## Score Distribution

| Reviewer | Affiliation | Score | Verdict |
|----------|-------------|-------|---------|
${reviewer_table}
---

## Priority 1: Blocking Issues

### P1.1: Methodological gaps in core approach
**Raised by**: 3+ reviewers
**Description**: Multiple reviewers identified gaps in the central methodology that undermine the paper's claims.
**Impact**: Without addressing this, the contribution is not convincingly demonstrated.
**Recommended action**: Strengthen methodology section with additional controls and justification.

### P1.2: Missing comparison with baseline approaches
**Raised by**: 3 reviewers
**Description**: The paper lacks comparison against established baselines in the field.
**Impact**: Cannot assess relative contribution without baselines.
**Recommended action**: Add at least two baseline comparisons.

---

## Priority 2: Important Improvements

### P2.1: Related work coverage
**Raised by**: 2 reviewers
**Description**: Several relevant works are missing from the literature review.
**Recommended action**: Expand related work to cover recent developments.

### P2.2: Clarity of presentation
**Raised by**: 2 reviewers
**Description**: Some sections could be more clearly written.
**Recommended action**: Revise for clarity, especially methodology and results.

---

## Priority 3: Minor Suggestions

### P3.1: Figure quality
**Raised by**: 1 reviewer
**Suggestion**: Improve resolution and labeling of figures.

### P3.2: Additional analysis
**Raised by**: 1 reviewer
**Suggestion**: Include sensitivity analysis for key parameters.

---

## Areas of Strength

1. Novel and engaging topic — cited by 5 reviewers
2. Creative experimental design — cited by 4 reviewers
3. Clear writing style — cited by 3 reviewers

## Areas of Disagreement

1. Scope — Some reviewers want broader coverage, others prefer focused depth

---

## Recommended Next Steps

1. **Address methodology gaps** — Addresses P1.1 — Estimated effort: 3 days
2. **Add baseline comparisons** — Addresses P1.2 — Estimated effort: 4 days
3. **Expand related work** — Addresses P2.1 — Estimated effort: 2 days

**Total estimated revision time**: 2 weeks

---

*Generated by panel synthesis engine*
SYNTH
}

# ═══════════════════════════════════════════════════════════════════════════════
# REVISION PLAN GENERATOR
# ═══════════════════════════════════════════════════════════════════════════════

write_revision_plan() {
  local file="$1" paper_title="$2" paper_name="$3" round="$4"
  local completed="$5"  # "true" or "false"

  local check="[ ]"
  local p1_status=""
  if [[ "$completed" == "true" ]]; then
    check="[x]"
    p1_status=" ✅"
  fi

  cat > "$file" << REVPLAN
# Revision Plan: ${paper_title}

**Paper**: ${paper_name}
**Round**: ${round} → $((round + 1))
**Date**: 2026-01-25
**Source**: reviews/SYNTHESIS.md

---

## Summary

Reviewers identified methodological gaps and missing baselines as blocking issues. This revision plan addresses all P1 items and key P2 improvements.

---

## P1: Must Complete (Blocking)

### P1.1: Methodological gaps in core approach${p1_status}
**Source**: P1.1 in SYNTHESIS.md
**Raised by**: 3+ reviewers
**Action**:
- ${check} Strengthen methodology section with additional controls
- ${check} Add justification for design choices
**Target section**: sections/01-introduction.tex

### P1.2: Missing comparison with baseline approaches${p1_status}
**Source**: P1.2 in SYNTHESIS.md
**Raised by**: 3 reviewers
**Action**:
- ${check} Implement two baseline comparisons
- ${check} Add results table comparing approaches
**Target section**: sections/01-introduction.tex

---

## P2: Should Complete (Important)

### P2.1: Related work coverage
**Source**: P2.1 in SYNTHESIS.md
**Raised by**: 2 reviewers
**Action**:
- ${check} Expand related work section
**Target section**: sections/01-introduction.tex

---

## P3: Nice to Have

### P3.1: Figure quality
- ${check} Improve figure resolution and labeling

---

## Quality Gates

- ${check} All P1 items addressed
- ${check} Paper rebuilds without errors
- ${check} Claims supported by evidence

---

*Begin revision work. Address P1 items first, then P2.*
REVPLAN
}

# ═══════════════════════════════════════════════════════════════════════════════
# PANEL YAML GENERATOR
# ═══════════════════════════════════════════════════════════════════════════════

write_panel_yaml() {
  local file="$1" paper="$2" title="$3" venue="$4" stage="$5" round="$6"
  shift 6
  # Remaining: reviewer specs as "name;affiliation;expertise;score;verdict" separated by |
  local reviewer_data="$*"

  # Build reviewer YAML
  local reviewers_yaml=""
  IFS='|' read -ra revs <<< "$reviewer_data"
  for r in "${revs[@]}"; do
    IFS=';' read -r rname raff rexp rscore rverdict <<< "$r"
    reviewers_yaml="${reviewers_yaml}  - name: ${rname}
    affiliation: ${raff}
    expertise: ${rexp}
    score: ${rscore}
    verdict: \"${rverdict}\"
"
  done

  # Build review file list
  local reviews_yaml="reviews:"
  if [[ "$stage" != "draft" ]]; then
    reviews_yaml="${reviews_yaml}
  round1:"
    for r in "${revs[@]}"; do
      IFS=';' read -r rname _ _ _ _ <<< "$r"
      local fname
      fname=$(reviewer_filename "$rname")
      reviews_yaml="${reviews_yaml}
    - reviews/REVIEW-${fname}.md"
    done
    if [[ "$stage" != "panel" ]]; then
      reviews_yaml="${reviews_yaml}
  round1_synthesis: reviews/SYNTHESIS.md"
    fi
  fi

  if (( round >= 2 )); then
    reviews_yaml="${reviews_yaml}
  round2:"
    for r in "${revs[@]}"; do
      IFS=';' read -r rname _ _ _ _ <<< "$r"
      local fname
      fname=$(reviewer_filename "$rname")
      reviews_yaml="${reviews_yaml}
    - reviews/ROUND2-REVIEW-${fname}.md"
    done
    reviews_yaml="${reviews_yaml}
  round2_synthesis: reviews/ROUND2-SYNTHESIS.md"
  fi

  # P1 items
  local p1_yaml=""
  if [[ "$stage" == "revision" || "$stage" == "recheck" || "$stage" == "ready" ]]; then
    local addressed="false"
    if [[ "$stage" == "recheck" || "$stage" == "ready" ]]; then
      addressed="true"
    fi
    p1_yaml="p1_items:
  - id: P1.1
    title: \"Methodological gaps in core approach\"
    raised_by: [Reviewer A, Reviewer B, Reviewer C]
    addressed: ${addressed}
    resolution: \"Strengthened methodology section\"
  - id: P1.2
    title: \"Missing comparison with baseline approaches\"
    raised_by: [Reviewer A, Reviewer B]
    addressed: ${addressed}
    resolution: \"Added baseline comparisons\""
  fi

  # Build history
  local history="history:"
  history="${history}
  - stage: draft
    date: \"2025-12-01\"
    note: \"Paper created\""
  if [[ "$stage" != "draft" ]]; then
    history="${history}
  - stage: panel
    date: \"2025-12-15\"
    note: \"Reviewers assigned and reviews generated\""
  fi
  if [[ "$stage" == "synthesis" || "$stage" == "revision" || "$stage" == "recheck" || "$stage" == "ready" ]]; then
    history="${history}
  - stage: synthesis
    date: \"2026-01-01\"
    note: \"Reviews consolidated\""
  fi
  if [[ "$stage" == "revision" || "$stage" == "recheck" || "$stage" == "ready" ]]; then
    history="${history}
  - stage: revision
    date: \"2026-01-10\"
    note: \"Revision work started\""
  fi
  if [[ "$stage" == "recheck" || "$stage" == "ready" ]]; then
    history="${history}
  - stage: recheck
    date: \"2026-01-20\"
    note: \"Round 2 reviews requested\""
  fi
  if [[ "$stage" == "ready" ]]; then
    history="${history}
  - stage: ready
    date: \"2026-01-30\"
    note: \"Panel review complete\""
  fi

  cat > "$file" << YAML
paper: ${paper}
title: "${title}"
venue: "${venue}"
stage: ${stage}
round: ${round}
reviewers:
${reviewers_yaml}${reviews_yaml}
${p1_yaml}
${history}
YAML
}

# ═══════════════════════════════════════════════════════════════════════════════
# MODULE HELPER: generate all files for one paper
# ═══════════════════════════════════════════════════════════════════════════════

generate_paper() {
  local module="$1" paper="$2" title="$3" topic="$4" venue="$5"
  local stage="$6" round="$7"
  shift 7
  # Remaining: reviewer specs "name;affiliation;expertise;score;verdict" separated by |
  local reviewer_data="$*"

  local dir="$TARGET/$module/$paper"
  make_paper_dir "$module" "$paper"

  # main.tex
  write_main_tex "$dir" "$title" "$topic"

  # Section stub
  write_section "$dir" "01" "introduction" "This paper investigates ${topic}. We present novel findings that advance the state of the art in this exciting field. Our approach combines rigorous methodology with creative experimental design."

  # Makefile
  write_makefile "$dir" "$paper"

  # _panel.yaml
  write_panel_yaml "$dir/_panel.yaml" "$paper" "$title" "$venue" "$stage" "$round" "$reviewer_data"

  # Generate reviews if past draft
  if [[ "$stage" != "draft" ]]; then
    IFS='|' read -ra revs <<< "$reviewer_data"
    for r in "${revs[@]}"; do
      IFS=';' read -r rname raff rexp rscore rverdict <<< "$r"
      local fname
      fname=$(reviewer_filename "$rname")
      # Personality quip per character
      local personality
      personality=$(get_personality "$rname" "$title")
      local major_issue="Methodology needs strengthening"
      local minor_issue="Could use more examples"

      write_review "$dir/reviews/REVIEW-${fname}.md" \
        "$title" "$rname" "$raff" "$rexp" "$rscore" "$rverdict" "1" \
        "$personality" "$major_issue" "$minor_issue"
    done
  fi

  # Synthesis if past panel
  if [[ "$stage" == "synthesis" || "$stage" == "revision" || "$stage" == "recheck" || "$stage" == "ready" ]]; then
    local avg_score score_range consensus overall_verdict
    avg_score=$(compute_avg "$reviewer_data")
    score_range=$(compute_range "$reviewer_data")
    consensus="Moderate"
    # Compare avg_score >= 3.0 using integer part
    local avg_int="${avg_score%%.*}"
    if (( avg_int >= 3 )); then
      consensus="Strong"
    fi
    overall_verdict="Revise and Resubmit"
    if [[ "$stage" == "ready" ]]; then
      overall_verdict="Accept with Minor Revisions"
      consensus="Strong"
    fi

    local synth_reviewers=""
    IFS='|' read -ra revs <<< "$reviewer_data"
    for r in "${revs[@]}"; do
      IFS=';' read -r rname raff _ rscore rverdict <<< "$r"
      synth_reviewers="${synth_reviewers}${rname};${raff};${rscore};${rverdict}|"
    done
    synth_reviewers="${synth_reviewers%|}"

    write_synthesis "$dir/reviews/SYNTHESIS.md" "$title" "$paper" "1" \
      "$avg_score" "$score_range" "$consensus" "$overall_verdict" "$synth_reviewers"
  fi

  # Revision plan if past synthesis
  if [[ "$stage" == "revision" || "$stage" == "recheck" || "$stage" == "ready" ]]; then
    local completed="false"
    if [[ "$stage" == "recheck" || "$stage" == "ready" ]]; then
      completed="true"
    fi
    write_revision_plan "$dir/REVISION-PLAN.md" "$title" "$paper" "$round" "$completed"
  fi

  # Round 2 reviews if round >= 2
  if (( round >= 2 )); then
    IFS='|' read -ra revs <<< "$reviewer_data"
    for r in "${revs[@]}"; do
      IFS=';' read -r rname raff rexp rscore rverdict <<< "$r"
      local fname
      fname=$(reviewer_filename "$rname")
      # Bump scores up by 1 for round 2 (cap at 4)
      local r2score=$((rscore < 4 ? rscore + 1 : 4))
      local r2verdict
      case $r2score in
        1) r2verdict="Reject" ;;
        2) r2verdict="Major Revisions Required" ;;
        3) r2verdict="Accept with Minor Revisions" ;;
        4) r2verdict="Strong Accept" ;;
      esac
      local personality
      personality=$(get_personality "$rname" "$title")
      write_review "$dir/reviews/ROUND2-REVIEW-${fname}.md" \
        "$title" "$rname" "$raff" "$rexp" "$r2score" "$r2verdict" "2" \
        "$personality" "Minor remaining methodology concerns" "Formatting nit"
    done

    # Round 2 synthesis
    local r2_avg r2_range
    r2_avg=$(compute_avg_bumped "$reviewer_data")
    r2_range=$(compute_range_bumped "$reviewer_data")
    local r2_verdict="Accept with Minor Revisions"
    if [[ "$stage" == "ready" ]]; then
      r2_verdict="Accept"
    fi

    local synth_r2=""
    IFS='|' read -ra revs <<< "$reviewer_data"
    for r in "${revs[@]}"; do
      IFS=';' read -r rname raff _ rscore _ <<< "$r"
      local r2s=$((rscore < 4 ? rscore + 1 : 4))
      local r2v
      case $r2s in
        3) r2v="Accept with Minor Revisions" ;;
        4) r2v="Strong Accept" ;;
        *) r2v="Major Revisions Required" ;;
      esac
      synth_r2="${synth_r2}${rname};${raff};${r2s};${r2v}|"
    done
    synth_r2="${synth_r2%|}"

    write_synthesis "$dir/reviews/ROUND2-SYNTHESIS.md" "$title" "$paper" "2" \
      "$r2_avg" "$r2_range" "Strong" "$r2_verdict" "$synth_r2"
  fi

  echo "  ✓ ${paper} (${stage}, round ${round})"
}

# ═══════════════════════════════════════════════════════════════════════════════
# PERSONALITY QUIPS
# ═══════════════════════════════════════════════════════════════════════════════

get_personality() {
  local reviewer="$1" title="$2"
  case "$reviewer" in
    "Cookie Monster")
      echo "Me have strong feelings about this paper. Authors make good points, but me notice significant gap: where are the cookies? Me mean, the methodology is sound, but every experiment should include cookie-based validation. Om nom nom." ;;
    "Swedish Chef")
      echo "Zee peper is a guud stert, bork bork bork! Zee methudoology is sveety like a guud soofflé, boot it needs more time-a in zee oovee. Zee reesoults ere undercooked in pleces." ;;
    "Prairie Dawn")
      echo "I have carefully organized my thoughts on this paper. While the content shows promise, the structure could be improved significantly. A proper pageant — I mean, paper — requires meticulous organization." ;;
    "Grover")
      echo "Oh! This paper is so exciting! Your humble reviewer Grover has read every word — EVERY word — and I am both NEAR to understanding the contribution and FAR from being fully convinced. It is exhausting but worthwhile work!" ;;
    "Big Bird")
      echo "I really liked reading this paper! It reminds me of looking at things from way up high on Nest — you can see the big picture really well. But some of the details are hard to see from up here. Maybe we need to look closer?" ;;
    "Mr. Snuffleupagus")
      echo "Oh dear, oh dear. The results are interesting, but will anyone believe them? As someone who has extensive experience with unverifiable claims, I urge the authors to strengthen their evidence. Not everyone can see what we see." ;;
    "Elmo")
      echo "Elmo read this paper! Elmo thinks the authors did a really good job explaining things. But Elmo has a question — can the authors explain the methodology part again? Elmo wants to make sure Elmo understands." ;;
    "Dr. Bunsen Honeydew")
      echo "Welcome to Muppet Labs, where the future is being made today! This paper shows tremendous promise. Our own experiments here at Muppet Labs have yielded similar results, though admittedly with more explosions. What could possibly go wrong?" ;;
    "Count von Count")
      echo "ONE contribution! TWO contributions! Ah ah ah! Let me count the strengths of this paper. ONE clear methodology! TWO interesting results! THREE promising implications! Ah ah ah! The counting is wonderful!" ;;
    "Bert")
      echo "I have reviewed this paper with the same rigor I apply to my pigeon classification studies and paperclip collection taxonomy. The categorization of results is adequate but could be more systematic. Everything must be properly categorized." ;;
    "Telly Monster")
      echo "Oh no, oh no! What if the numbers are WRONG?! I've been worrying about the statistical analysis all night! The triangles — I mean, the confidence intervals — look okay, but WHAT IF THEY'RE NOT?! We need more validation!" ;;
    "Oscar the Grouch")
      echo "I HATE this paper! And I hate having to review it! The methodology is garbage — which normally I'd appreciate, but in this case it's the BAD kind of garbage. Heh heh heh. Now get lost!" ;;
    "Scooter")
      echo "Okay, Chief says I need to review this paper, and it's going on RIGHT NOW! The logistics section is well-planned, but who's going to clean up after the experiments? Someone needs to think about the practical implications!" ;;
    "Statler")
      echo "I've seen better papers used as napkins at the Muppet Theater. The methodology is weak, the results are questionable, and frankly, I've had more enlightening experiences napping through the show." ;;
    "Waldorf")
      echo "You know, this paper reminds me of the Muppet Show — it tries hard, but the results are always a disaster! Ho ho ho! But seriously, the experimental design needs work. Lots of work." ;;
    "Miss Piggy")
      echo "Moi has graciously taken time from her very busy schedule to review this paper. The writing shows potential, much like moi showed potential before becoming a STAR. However, the presentation lacks... glamour. Moi demands better figures. Hi-YAH!" ;;
    "Fozzie Bear")
      echo "Hey hey hey! This paper walks into a conference and says, 'I've got novel results!' Wocka wocka! But seriously folks, the contribution is solid, though the related work section could use better jokes — I mean, citations." ;;
    "Ernie")
      echo "Hehehehe! You know what's funny, Bert? This paper! Not funny ha-ha, but funny interesting. Have the authors tried the fun approach? Sometimes you just need a rubber duck to see the problem differently. Khehehehe!" ;;
    "Rosita")
      echo "This paper is very interesting! But Rosita wonders — does this work in two languages? The methodology should be tested across different cultural contexts. Cross-cultural validation is essential, amigos!" ;;
    "Abby Cadabby")
      echo "Ooh, this is like magic! Well, not REAL magic — that would require a wand and proper spell-casting methodology. But the transformation from hypothesis to results is quite enchanting! Can we transform the methodology section though?" ;;
    "Guy Smiley")
      echo "WELCOME to the GREATEST paper review of ALL TIME! *confetti* Can we make this MORE EXCITING?! The results are good but the PRESENTATION needs MORE ENERGY! MORE PIZZAZZ! This paper needs to be a WINNER!" ;;
    "Zoe")
      echo "Ooh! Can we dance about these results? I mean, the data practically dances on its own! The methodology has good rhythm, but the conclusions section needs more... movement. Let's choreograph a better discussion!" ;;
    "Animal")
      echo "PAPER! PAPER! READ READ READ! *calms down* ...methodology adequate. DRUM DRUM DRUM! Results need MORE DATA! MORE! MORE!" ;;
    "Kermit the Frog")
      echo "Hi ho, this is Kermit the Frog here with a review. It's not easy being a reviewer — you have to balance encouragement with critique. This paper has real potential, but it needs some work. Can we all just agree on a revision plan?" ;;
    *)
      echo "This paper presents interesting findings. The methodology is generally sound but could be strengthened. The contribution is relevant to the target venue." ;;
  esac
}

# ═══════════════════════════════════════════════════════════════════════════════
# SCORE COMPUTATION HELPERS
# ═══════════════════════════════════════════════════════════════════════════════

# Pure bash decimal division: outputs X.Y format
div_decimal() {
  local num="$1" den="$2"
  local whole=$((num / den))
  local rem=$((num % den))
  local frac=$(( (rem * 10) / den ))
  echo "${whole}.${frac}"
}

compute_avg() {
  local data="$1"
  local sum=0 count=0
  IFS='|' read -ra revs <<< "$data"
  for r in "${revs[@]}"; do
    IFS=';' read -r _ _ _ rscore _ <<< "$r"
    sum=$((sum + rscore))
    count=$((count + 1))
  done
  div_decimal "$sum" "$count"
}

compute_range() {
  local data="$1"
  local min=4 max=1
  IFS='|' read -ra revs <<< "$data"
  for r in "${revs[@]}"; do
    IFS=';' read -r _ _ _ rscore _ <<< "$r"
    (( rscore < min )) && min=$rscore
    (( rscore > max )) && max=$rscore
  done
  echo "${min}-${max}"
}

compute_avg_bumped() {
  local data="$1"
  local sum=0 count=0
  IFS='|' read -ra revs <<< "$data"
  for r in "${revs[@]}"; do
    IFS=';' read -r _ _ _ rscore _ <<< "$r"
    local bumped=$((rscore < 4 ? rscore + 1 : 4))
    sum=$((sum + bumped))
    count=$((count + 1))
  done
  div_decimal "$sum" "$count"
}

compute_range_bumped() {
  local data="$1"
  local min=4 max=1
  IFS='|' read -ra revs <<< "$data"
  for r in "${revs[@]}"; do
    IFS=';' read -r _ _ _ rscore _ <<< "$r"
    local bumped=$((rscore < 4 ? rscore + 1 : 4))
    (( bumped < min )) && min=$bumped
    (( bumped > max )) && max=$bumped
  done
  echo "${min}-${max}"
}

# ═══════════════════════════════════════════════════════════════════════════════
# MODULE 1: COOKIE SCIENCE LAB (most advanced — recheck/ready)
# ═══════════════════════════════════════════════════════════════════════════════

generate_cookie_science() {
  local mod="cookie-science"
  echo "Generating module: ${mod}..."
  mkdir -p "$TARGET/$mod/docs"

  # Reviewers for this module
  local R1="Cookie Monster;Sesame Street Food Lab;Binge consumption;3;Accept with Minor Revisions"
  local R2="Swedish Chef;Muppet Culinary Institute;Experimental cooking;3;Accept with Minor Revisions"
  local R3="Count von Count;Castle Counting Institute;Enumeration;3;Accept with Minor Revisions"
  local R4="Prairie Dawn;Sesame Street Pageant Academy;Procedural organization;2;Major Revisions Required"
  local R5="Bert;Sesame Street Classification Bureau;Taxonomy;3;Accept with Minor Revisions"
  local REVS="${R1}|${R2}|${R3}|${R4}|${R5}"

  # Paper 1: optimal-cookie-consumption — ready, round 2
  generate_paper "$mod" "panel-optimal-cookie-consumption" \
    "Optimal Cookie Consumption Under Resource Constraints" \
    "resource-constrained cookie eating strategies" \
    "NomNom 2026" "ready" "2" "$REVS"

  # Paper 2: chip-distribution — ready, round 2
  local R1b="Cookie Monster;Sesame Street Food Lab;Binge consumption;4;Strong Accept"
  local R3b="Count von Count;Castle Counting Institute;Enumeration;4;Strong Accept"
  local REVSb="${R1b}|${R2}|${R3b}|${R4}|${R5}"
  generate_paper "$mod" "panel-chip-distribution" \
    "Statistical Analysis of Chocolate Chip Placement in Cookie Matrices" \
    "chocolate chip spatial distribution and statistical patterns" \
    "ICBD 2026" "ready" "2" "$REVSb"

  # Paper 3: sharing-economics — recheck, round 2
  local R1c="Cookie Monster;Sesame Street Food Lab;Binge consumption;2;Major Revisions Required"
  local REVSc="${R1c}|${R2}|${R3}|${R4}|${R5}"
  generate_paper "$mod" "panel-sharing-economics" \
    "Game-Theoretic Models of Cookie Division Among Competing Agents" \
    "game-theoretic models of cookie sharing and division" \
    "AAMAS 2026" "recheck" "2" "$REVSc"

  # Paper 4: dunk-methodology — ready, round 2
  generate_paper "$mod" "panel-dunk-methodology" \
    "A Controlled Study of Milk Immersion Timing for Optimal Cookie Texture" \
    "milk immersion timing and cookie texture optimization" \
    "JSS 2026" "ready" "2" "$REVS"

  # Paper 5: crumb-analysis — recheck, round 1
  local R4e="Prairie Dawn;Sesame Street Pageant Academy;Procedural organization;3;Accept with Minor Revisions"
  local REVSe="${R1}|${R2}|${R3}|${R4e}|${R5}"
  generate_paper "$mod" "panel-crumb-analysis" \
    "Cookie Quality Assessment via Crumb Pattern Analysis" \
    "cookie quality metrics derived from crumb fragmentation patterns" \
    "CVPR 2026" "recheck" "1" "$REVSe"

  # Module-level files
  write_cookie_research "$mod"
  write_module_reviewers "$mod" "Cookie Science Lab" \
    "Cookie Monster" "Swedish Chef" "Count von Count" "Prairie Dawn" "Bert"
  cp "$SCRIPT_DIR/mock-reviewers.md" "$TARGET/$mod/REVIEWER-DATABASE.md"
  write_module_makefile "$mod"
  write_cookie_panel_review "$mod"
}

# ═══════════════════════════════════════════════════════════════════════════════
# MODULE 2: GROVER'S ADVENTURE ACADEMY (mid-progress — synthesis/revision)
# ═══════════════════════════════════════════════════════════════════════════════

generate_grover_adventures() {
  local mod="grover-adventures"
  echo "Generating module: ${mod}..."
  mkdir -p "$TARGET/$mod/docs"

  local R1="Grover;Sesame Street Adventure Academy;Near-far classification;3;Accept with Minor Revisions"
  local R2="Big Bird;Sesame Street Ornithology Dept;Aerial observation;2;Major Revisions Required"
  local R3="Mr. Snuffleupagus;Imaginary Studies Institute;Unverifiable phenomena;2;Major Revisions Required"
  local R4="Elmo;Sesame Street Child Dev Center;Third-person self-reference;3;Accept with Minor Revisions"
  local R5="Dr. Bunsen Honeydew;Muppet Labs;Experimental design;3;Accept with Minor Revisions"
  local REVS="${R1}|${R2}|${R3}|${R4}|${R5}"

  # Paper 1: near-far-metrics — revision, round 1
  generate_paper "$mod" "panel-near-far-metrics" \
    "Unified Distance Metrics for Monster Navigation in Urban Environments" \
    "unified distance metrics for near-far monster navigation" \
    "IROS 2026" "revision" "1" "$REVS"

  # Paper 2: super-grover-flight — synthesis, round 1
  local R1b="Grover;Sesame Street Adventure Academy;Near-far classification;2;Major Revisions Required"
  local REVSb="${R1b}|${R2}|${R3}|${R4}|${R5}"
  generate_paper "$mod" "panel-super-grover-flight" \
    "Cape-Assisted Aerial Locomotion: Dynamics of Heroic Flight Attempts" \
    "cape-assisted aerial locomotion and heroic flight dynamics" \
    "AIAA 2026" "synthesis" "1" "$REVSb"

  # Paper 3: monster-anxiety — recheck, round 1
  local R3c="Mr. Snuffleupagus;Imaginary Studies Institute;Unverifiable phenomena;3;Accept with Minor Revisions"
  local REVSc="${R1}|${R2}|${R3c}|${R4}|${R5}"
  generate_paper "$mod" "panel-monster-anxiety" \
    "Anticipatory Anxiety in Sequential Media: A Monster-Centric Study" \
    "anticipatory anxiety in sequential media consumption by monsters" \
    "CHI 2026" "recheck" "1" "$REVSc"

  # Paper 4: helping-dynamics — revision, round 1
  generate_paper "$mod" "panel-helping-dynamics" \
    "Measuring Prosocial Behavior in Furry Populations" \
    "prosocial behavior measurement in furry monster populations" \
    "CSCW 2026" "revision" "1" "$REVS"

  # Paper 5: waiter-dilemma — synthesis, round 1
  local R5e="Dr. Bunsen Honeydew;Muppet Labs;Experimental design;2;Major Revisions Required"
  local REVSe="${R1}|${R2}|${R3}|${R4}|${R5e}"
  generate_paper "$mod" "panel-waiter-dilemma" \
    "Balancing Multiple Plates Under Uncertainty: The Waiter Dilemma" \
    "multi-plate balancing under uncertainty conditions" \
    "AAMAS 2026" "synthesis" "1" "$REVSe"

  # Module-level files
  write_grover_research "$mod"
  write_module_reviewers "$mod" "Grover's Adventure Academy" \
    "Grover" "Big Bird" "Mr. Snuffleupagus" "Elmo" "Dr. Bunsen Honeydew"
  cp "$SCRIPT_DIR/mock-reviewers.md" "$TARGET/$mod/REVIEWER-DATABASE.md"
  write_module_makefile "$mod"
  write_placeholder_panel "$mod" "Grover's Adventure Academy"
}

# ═══════════════════════════════════════════════════════════════════════════════
# MODULE 3: OSCAR'S TRASH INNOVATION CENTER (early — draft/panel)
# ═══════════════════════════════════════════════════════════════════════════════

generate_oscar_trash_lab() {
  local mod="oscar-trash-lab"
  echo "Generating module: ${mod}..."
  mkdir -p "$TARGET/$mod/docs"

  local R1="Oscar the Grouch;Trash Can Research Institute;Contrarian analysis;2;Major Revisions Required"
  local R2="Scooter;Stage Management & Logistics Lab;Resource logistics;3;Accept with Minor Revisions"
  local R3="Statler;Balcony Peer Review Board;Negative criticism;1;Reject"
  local R4="Waldorf;Balcony Peer Review Board;Collaborative negativity;1;Reject"
  local R5="Miss Piggy;Assertiveness Research Center;Self-advocacy;2;Major Revisions Required"
  local REVS="${R1}|${R2}|${R3}|${R4}|${R5}"

  # Paper 1: grouch-sentiment — panel, round 1
  generate_paper "$mod" "panel-grouch-sentiment" \
    "Longitudinal Study of Contrarian Communication Patterns" \
    "contrarian communication and grouch sentiment analysis" \
    "EMNLP 2026" "panel" "1" "$REVS"

  # Paper 2: trash-can-architecture — draft, round 0
  generate_paper "$mod" "panel-trash-can-architecture" \
    "Sustainable Single-Occupancy Dwelling Design: The Trash Can Paradigm" \
    "sustainable single-occupancy dwelling design using trash cans" \
    "UbiComp 2026" "draft" "0" "$REVS"

  # Paper 3: worm-composting — panel, round 1
  local R2c="Scooter;Stage Management & Logistics Lab;Resource logistics;2;Major Revisions Required"
  local REVSc="${R1}|${R2c}|${R3}|${R4}|${R5}"
  generate_paper "$mod" "panel-worm-composting" \
    "Slimey's Contribution to Organic Waste Processing: A Vermiculture Study" \
    "worm-based organic waste processing and vermiculture optimization" \
    "EnvSci 2026" "panel" "1" "$REVSc"

  # Paper 4: recycling-optimization — draft, round 0
  generate_paper "$mod" "panel-recycling-optimization" \
    "Efficient Resource Recovery via the SCRAM Protocol" \
    "efficient resource recovery and recycling optimization" \
    "SIGMOD 2026" "draft" "0" "$REVS"

  # Paper 5: trash-aesthetics — synthesis, round 1
  local R3e="Statler;Balcony Peer Review Board;Negative criticism;2;Major Revisions Required"
  local R4e="Waldorf;Balcony Peer Review Board;Collaborative negativity;2;Major Revisions Required"
  local REVSe="${R1}|${R2}|${R3e}|${R4e}|${R5}"
  generate_paper "$mod" "panel-trash-aesthetics" \
    "Redefining Beauty Standards in Waste Management" \
    "aesthetic reframing of waste management practices" \
    "DIS 2026" "synthesis" "1" "$REVSe"

  # Module-level files
  write_oscar_research "$mod"
  write_module_reviewers "$mod" "Oscar's Trash Innovation Center" \
    "Oscar the Grouch" "Scooter" "Statler" "Waldorf" "Miss Piggy"
  cp "$SCRIPT_DIR/mock-reviewers.md" "$TARGET/$mod/REVIEWER-DATABASE.md"
  write_module_makefile "$mod"
  write_placeholder_panel "$mod" "Oscar's Trash Innovation Center"
}

# ═══════════════════════════════════════════════════════════════════════════════
# MODULE-LEVEL FILE GENERATORS
# ═══════════════════════════════════════════════════════════════════════════════

write_module_reviewers() {
  local mod="$1" modname="$2"
  shift 2
  local reviewers=("$@")

  local table=""
  local i=1
  for r in "${reviewers[@]}"; do
    table="${table}| ${i} | **${r}** | Assigned | Primary | Papers in module |
"
    i=$((i + 1))
  done

  cat > "$TARGET/$mod/REVIEWERS.md" << REVMD
# ${modname} — Expert Reviewer Subset

**Module**: ${modname}
**Papers**: 5
**Global database**: See [REVIEWER-DATABASE.md](REVIEWER-DATABASE.md)

---

## Module Reviewers

| # | Reviewer | Status | Role | Coverage |
|---|---------|--------|------|----------|
${table}
---

## Cross-Portfolio Panel (Planned)

7 reviewers to be selected for breadth across 5 papers.

---

*${modname} reviewer assignments — 2026-02-05*
REVMD
}

write_module_makefile() {
  local mod="$1"
  # Get paper directories
  local papers
  papers=$(ls -d "$TARGET/$mod"/panel-* 2>/dev/null | xargs -I{} basename {} | tr '\n' ' ')

  cat > "$TARGET/$mod/Makefile" << MKEOF
# Makefile for ${mod} research papers

PAPERS = ${papers}

.PHONY: all clean dist help \$(PAPERS)

all: \$(PAPERS)
	@echo "All ${mod} papers built successfully!"

\$(PAPERS):
	@echo "Building \$@..."
	cd \$@ && \$(MAKE) pdf

dist: all
	@echo "Copying papers to docs/..."
	@mkdir -p docs
	@for dir in \$(PAPERS); do \\
		cd \$\$dir && \$(MAKE) dist && cd ..; \\
	done

clean:
	@echo "Cleaning build artifacts..."
	@for dir in \$(PAPERS); do \\
		cd \$\$dir && \$(MAKE) clean && cd ..; \\
	done
	@rm -f docs/*.pdf

help:
	@echo "Available targets: all, clean, dist, help"
	@echo "Papers: \$(PAPERS)"
MKEOF
}

write_cookie_research() {
  local mod="$1"
  cat > "$TARGET/$mod/RESEARCH.md" << 'RESMD'
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
RESMD
}

write_grover_research() {
  local mod="$1"
  cat > "$TARGET/$mod/RESEARCH.md" << 'RESMD'
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
RESMD
}

write_oscar_research() {
  local mod="$1"
  cat > "$TARGET/$mod/RESEARCH.md" << 'RESMD'
# Oscar's Trash Innovation Center — Research Papers

**Module**: Oscar's Trash Innovation Center
**Papers**: 5
**Author**: Oscar the Grouch et al.

---

## Paper Inventory

| # | Directory | Title | Venue Target | Stage | Round |
|---|-----------|-------|-------------|-------|-------|
| 1 | [panel-grouch-sentiment](panel-grouch-sentiment/) | Longitudinal Study of Contrarian Communication | EMNLP 2026 | panel | 1 |
| 2 | [panel-trash-can-architecture](panel-trash-can-architecture/) | Sustainable Single-Occupancy Dwelling Design | UbiComp 2026 | draft | 0 |
| 3 | [panel-worm-composting](panel-worm-composting/) | Slimey's Contribution to Organic Waste Processing | EnvSci 2026 | panel | 1 |
| 4 | [panel-recycling-optimization](panel-recycling-optimization/) | Efficient Resource Recovery via SCRAM Protocol | SIGMOD 2026 | draft | 0 |
| 5 | [panel-trash-aesthetics](panel-trash-aesthetics/) | Redefining Beauty Standards in Waste Management | DIS 2026 | synthesis | 1 |

---

## Paper Dependency Graph

```
[1] Grouch Sentiment (foundational)
     |
     +──→ [5] Trash Aesthetics
     |
[2] Trash Can Architecture
     |
     +──→ [4] Recycling Optimization
     |
     +──→ [3] Worm Composting
```

---

## Review Status

| Paper | Stage | Round | Score | Verdict |
|-------|-------|-------|-------|---------|
| #1 Grouch Sentiment | panel | 1 | — | In Review |
| #2 Trash Can Architecture | draft | 0 | — | — |
| #3 Worm Composting | panel | 1 | — | In Review |
| #4 Recycling Optimization | draft | 0 | — | — |
| #5 Trash Aesthetics | synthesis | 1 | 2.0/4 | Major Revisions |

---

## Build

```bash
make all          # Build all papers
make dist         # Copy PDFs to docs/
make clean        # Remove build artifacts
```

---

*Oscar's Trash Innovation Center research module — established 2025-12-01*
RESMD
}

write_cookie_panel_review() {
  local mod="$1"
  cat > "$TARGET/$mod/REVIEW_PANEL.md" << 'PANELMD'
# Cookie Science Lab — Cross-Portfolio Review Panel

**Module**: Cookie Science Lab
**Papers**: 5
**Panel size**: 7
**Round**: 1
**Status**: Complete

---

## Panel Members

| # | Reviewer | Affiliation | Role |
|---|---------|-------------|------|
| 1 | **Cookie Monster** | Sesame Street Food Lab | Domain Expert |
| 2 | **Swedish Chef** | Muppet Culinary Institute | Methods Specialist |
| 3 | **Count von Count** | Castle Counting Institute | Statistics |
| 4 | **Prairie Dawn** | Sesame Street Pageant Academy | Organization |
| 5 | **Bert** | Sesame Street Classification Bureau | Taxonomy |
| 6 | **Telly Monster** | Triangle Geometry Lab | Validation |
| 7 | **Ernie** | Rubber Duck Hydrodynamics Lab | Creative Methods |

---

## Portfolio Rankings

| Rank | Paper | Score | Recommendation |
|------|-------|-------|----------------|
| 1 | Chip Distribution | 3.4/4 | Accept |
| 2 | Optimal Cookie Consumption | 3.2/4 | Accept |
| 3 | Dunk Methodology | 3.2/4 | Accept |
| 4 | Crumb Analysis | 3.0/4 | Minor Revisions |
| 5 | Sharing Economics | 2.6/4 | Revisions Needed |

---

## PP1: Blocking Issues

### PP1.1: Inconsistent methodology across cookie papers
**Affected papers**: #1, #3, #5
**Description**: The five papers use different experimental frameworks for what are fundamentally similar cookie experiments. A unified methodology would strengthen the portfolio.
**Recommended action**: Establish shared experimental protocol across all cookie papers.

---

## PP2: Important Improvements

### PP2.1: Cross-referencing between papers
**Affected papers**: All
**Description**: Papers don't sufficiently reference each other despite clear dependencies.
**Recommended action**: Add cross-references to establish the portfolio as a cohesive body of work.

### PP2.2: Statistical rigor in crumb analysis
**Affected papers**: #5
**Description**: Crumb Analysis paper needs stronger statistical backing.
**Recommended action**: Apply Count von Count's enumeration framework from Chip Distribution.

---

## PP3: Minor Suggestions

### PP3.1: Unified terminology
**Affected papers**: #1, #4
**Description**: "Cookie consumption" vs "cookie eating" used inconsistently.
**Suggestion**: Standardize on "cookie consumption" throughout.

---

## Cross-Cutting Themes

1. **Cookie preservation vs consumption trade-off** — Papers #1 and #3 address this from different angles
2. **Quality metrics** — Papers #2 and #5 both develop quality measures that could be unified
3. **Milk as experimental variable** — Paper #4 introduces milk; others should consider this factor

---

*Panel review complete — 2026-01-30*
PANELMD
}

write_placeholder_panel() {
  local mod="$1" modname="$2"
  cat > "$TARGET/$mod/REVIEW_PANEL.md" << PANELMD
# ${modname} — Cross-Portfolio Review Panel

**Module**: ${modname}
**Papers**: 5
**Panel size**: 7
**Status**: Not yet conducted

---

## Panel Members

Panel review has not yet been conducted. Papers must reach \`ready\` stage before module-level panel review.

---

*Awaiting paper-level reviews to complete.*
PANELMD
}

# ═══════════════════════════════════════════════════════════════════════════════
# ROOT-LEVEL FILES
# ═══════════════════════════════════════════════════════════════════════════════

write_board_review() {
  cat > "$TARGET/REVIEW_BOARD.md" << 'BOARDMD'
# Mock Monorepo — Cross-Module Board Review

**Modules**: 3
**Board size**: 7
**Status**: Not yet conducted

---

## Modules

| # | Module | Papers | Status | Readiness |
|---|--------|--------|--------|-----------|
| 1 | cookie-science | 5 | Panel complete | Ready for board |
| 2 | grover-adventures | 5 | Reviews in progress | Not ready |
| 3 | oscar-trash-lab | 5 | Early stage | Not ready |

---

## Board Members

Board review has not yet been conducted. At least 2 modules must complete panel review before board convenes.

---

*Awaiting module-level panel reviews to complete.*
BOARDMD
}

# ═══════════════════════════════════════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════════════════════════════════════

generate_cookie_science
generate_grover_adventures
generate_oscar_trash_lab
write_board_review

# Summary
echo ""
echo "Mock monorepo created at: $TARGET"
echo ""
echo "Modules:"
echo "  cookie-science      — 5 papers (3 ready, 2 recheck)"
echo "  grover-adventures   — 5 papers (2 synthesis, 2 revision, 1 recheck)"
echo "  oscar-trash-lab     — 5 papers (2 draft, 2 panel, 1 synthesis)"
echo ""
echo "Total: 15 papers, 75+ review files, 25 mock reviewers"
