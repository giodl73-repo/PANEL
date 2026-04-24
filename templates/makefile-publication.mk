# Per-publication Makefile
# Placed at: {researchPath}/publications/{slug}/Makefile
# PDF lands at: {researchPath}/docs/{module}-{slug}.pdf
#
# The module prefix on the output PDF lets a global docs/ directory collect
# PDFs from multiple modules without filename collisions.
#
# {{MODULE}} is substituted by panel:publication setup from the active project's
# projectName (.claude/panel.json). Override by editing this line if needed.

MODULE    := {{MODULE}}
SLUG      := $(notdir $(CURDIR))
OUTPUT    := main.pdf
DOCS_DIR  := ../../docs
DIST_FILE := $(DOCS_DIR)/$(MODULE)-$(SLUG).pdf

.PHONY: all pdf dist clean watch

all: pdf

pdf: main.tex $(wildcard sections/*.tex) $(wildcard *.bib)
	latexmk -pdf -interaction=nonstopmode -halt-on-error main.tex

dist: pdf
	@mkdir -p $(DOCS_DIR)
	cp $(OUTPUT) $(DIST_FILE)
	@echo "  → $(DIST_FILE)"

clean:
	latexmk -C
	@rm -f *.aux *.log *.out *.toc *.fls *.fdb_latexmk *.synctex.gz *.bbl *.blg

watch:
	latexmk -pdf -pvc -interaction=nonstopmode main.tex
