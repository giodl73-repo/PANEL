# Makefile for grover-adventures research papers

PAPERS = panel-helping-dynamics panel-monster-anxiety panel-near-far-metrics panel-super-grover-flight panel-waiter-dilemma 

.PHONY: all clean dist help $(PAPERS)

all: $(PAPERS)
	@echo "All grover-adventures papers built successfully!"

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
