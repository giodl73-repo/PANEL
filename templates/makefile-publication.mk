# Per-publication Makefile
# Placed at: {researchPath}/publications/{slug}/Makefile
# PDF lands at: {researchPath}/docs/{slug}.pdf

SLUG     := $(notdir $(CURDIR))
OUTPUT   := main.pdf
DOCS_DIR := ../../docs
DIST_FILE := $(DOCS_DIR)/$(SLUG).pdf

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
