# Module-level Makefile — panel research
# Discovers all publications dynamically
# PDFs land in docs/

PUBS     := $(sort $(dir $(wildcard panel-*/main.tex)))
DOCS_DIR := docs

.PHONY: all pdf dist clean list

all: pdf

pdf: $(PUBS)

$(PUBS):
	@echo "Building $(patsubst %/,%,$@)..."
	$(MAKE) -C $@ pdf

dist:
	@mkdir -p $(DOCS_DIR)
	@echo "Building all → $(DOCS_DIR)/"
	@for dir in $(PUBS); do \
		$(MAKE) -C $$dir dist || exit 1; \
	done
	@echo ""
	@echo "Done. PDFs in $(DOCS_DIR)/"

clean:
	@for dir in $(PUBS); do \
		$(MAKE) -C $$dir clean; \
	done
	@rm -f $(DOCS_DIR)/*.pdf

list:
	@echo "Publications:"
	@echo ""
	@for dir in $(PUBS); do \
		slug=$$(basename $$dir); \
		status=$$([ -f $$dir/main.pdf ] && echo "✓" || echo "—"); \
		echo "  $$status  $$slug"; \
	done
	@echo ""
	@echo "Docs: $(DOCS_DIR)/"
