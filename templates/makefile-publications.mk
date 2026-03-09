# Publications directory Makefile
# Placed at: {researchPath}/publications/Makefile
# Discovers all publications dynamically — no hardcoded names
# PDFs land at: {researchPath}/docs/

PUBS     := $(sort $(dir $(wildcard */main.tex)))
DOCS_DIR := ../docs

.PHONY: all pdf dist clean list $(PUBS)

all: pdf

pdf: $(PUBS)

$(PUBS):
	@echo "Building $@..."
	$(MAKE) -C $@ pdf

dist:
	@mkdir -p $(DOCS_DIR)
	@echo "Building and distributing all publications → $(DOCS_DIR)/"
	@for dir in $(PUBS); do \
		$(MAKE) -C $$dir dist DOCS_DIR=../$(DOCS_DIR) || exit 1; \
	done
	@echo ""
	@echo "Done. PDFs in $(DOCS_DIR)/"

clean:
	@for dir in $(PUBS); do \
		$(MAKE) -C $$dir clean; \
	done

list:
	@echo "Publications:"
	@echo ""
	@for dir in $(PUBS); do \
		slug=$$(basename $$dir); \
		status=$$([ -f $$dir/main.pdf ] && echo "✓" || echo "—"); \
		echo "  $$status  $$slug"; \
	done
