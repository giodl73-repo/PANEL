# Makefile for oscar-trash-lab research papers

PAPERS = panel-grouch-sentiment panel-recycling-optimization panel-trash-aesthetics panel-trash-can-architecture panel-worm-composting 

.PHONY: all clean dist help $(PAPERS)

all: $(PAPERS)
	@echo "All oscar-trash-lab papers built successfully!"

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
