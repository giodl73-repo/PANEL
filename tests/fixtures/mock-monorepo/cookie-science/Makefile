# Makefile for cookie-science research papers

PAPERS = panel-chip-distribution panel-crumb-analysis panel-dunk-methodology panel-optimal-cookie-consumption panel-sharing-economics 

.PHONY: all clean dist help $(PAPERS)

all: $(PAPERS)
	@echo "All cookie-science papers built successfully!"

$(PAPERS):
	@echo "Building $@..."
	cd $@ && $(MAKE) pdf

dist: all
	@echo "Copying papers to docs/..."
	@mkdir -p docs
	@for dir in $(PAPERS); do \
		cd $$dir && $(MAKE) dist && cd ..; \
	done

clean:
	@echo "Cleaning build artifacts..."
	@for dir in $(PAPERS); do \
		cd $$dir && $(MAKE) clean && cd ..; \
	done
	@rm -f docs/*.pdf

help:
	@echo "Available targets: all, clean, dist, help"
	@echo "Papers: $(PAPERS)"
