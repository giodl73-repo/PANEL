# Makefile for panel-reviewer-profiles

MAIN = main
SECTIONS = $(wildcard sections/*.tex)
FIGURES = $(wildcard figures/*)
BIB = ../references.bib

.PHONY: pdf clean watch

pdf: $(MAIN).pdf

$(MAIN).pdf: $(MAIN).tex $(SECTIONS) $(BIB)
	pdflatex $(MAIN)
	bibtex $(MAIN)
	pdflatex $(MAIN)
	pdflatex $(MAIN)

watch:
	while true; do \
		inotifywait -e modify $(MAIN).tex $(SECTIONS); \
		$(MAKE) pdf; \
	done

clean:
	rm -f *.aux *.bbl *.blg *.log *.out *.toc *.pdf
	rm -f sections/*.aux
