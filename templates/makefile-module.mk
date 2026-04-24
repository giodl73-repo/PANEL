# Module-level Makefile
# Placed at: {researchPath}/Makefile
# Delegates to publications/, puts all PDFs in docs/

DOCS_DIR := docs

.PHONY: all pdf dist clean list

all: pdf

pdf:
	@if [ -d publications ]; then $(MAKE) -C publications pdf; fi

dist:
	@mkdir -p $(DOCS_DIR)
	@if [ -d publications ]; then \
		$(MAKE) -C publications dist DOCS_DIR=../$(DOCS_DIR); \
	fi
	@echo ""
	@echo "All PDFs in $(DOCS_DIR)/"

clean:
	@if [ -d publications ]; then $(MAKE) -C publications clean; fi
	@rm -f $(DOCS_DIR)/*.pdf

list:
	@echo "Module publications:"
	@if [ -d publications ]; then $(MAKE) -C publications list; fi
	@echo ""
	@echo "Docs: $(DOCS_DIR)/"
	@ls -1 $(DOCS_DIR)/*.pdf 2>/dev/null | sed 's|$(DOCS_DIR)/||' || echo "  (none built yet)"
