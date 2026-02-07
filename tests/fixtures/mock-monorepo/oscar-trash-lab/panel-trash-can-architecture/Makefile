OUTPUT = main.pdf
DIST_DIR = ../docs
DIST_FILE = $(DIST_DIR)/panel-trash-can-architecture.pdf

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
