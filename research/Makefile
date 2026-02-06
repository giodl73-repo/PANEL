# Master Makefile for Panel Research Papers
# Compiles all LaTeX research documents

PAPERS = panel-review-methodology panel-reviewer-calibration panel-revision-dynamics panel-portfolio-assessment panel-synthesis-methods

.PHONY: all clean dist help check-latex $(PAPERS)

# Default target
all: check-latex $(PAPERS)
	@echo ""
	@echo "All panel research papers built successfully!"

# Check LaTeX installation
check-latex:
	@echo "Checking LaTeX installation..."
	@which latexmk > /dev/null 2>&1 || (echo "ERROR: latexmk not found. Please install a LaTeX distribution." && exit 1)
	@echo "LaTeX installation found."
	@echo ""

# Individual paper targets
panel-review-methodology:
	@echo "Building Review Methodology paper..."
	cd panel-review-methodology && $(MAKE) pdf
	@echo ""

panel-reviewer-calibration:
	@echo "Building Reviewer Calibration paper..."
	cd panel-reviewer-calibration && $(MAKE) pdf
	@echo ""

panel-revision-dynamics:
	@echo "Building Revision Dynamics paper..."
	cd panel-revision-dynamics && $(MAKE) pdf
	@echo ""

panel-portfolio-assessment:
	@echo "Building Portfolio Assessment paper..."
	cd panel-portfolio-assessment && $(MAKE) pdf
	@echo ""

panel-synthesis-methods:
	@echo "Building Synthesis Methods paper..."
	cd panel-synthesis-methods && $(MAKE) pdf
	@echo ""

# Copy compiled PDFs to docs/
dist: all
	@echo "Copying papers to docs/..."
	@mkdir -p docs
	@for dir in $(PAPERS); do \
		cd $$dir && $(MAKE) dist && cd ..; \
	done
	@echo ""
	@echo "Distribution complete!"
	@echo "Papers available in docs/"

# Clean all build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@for dir in $(PAPERS); do \
		cd $$dir && $(MAKE) clean && cd ..; \
	done
	@rm -f docs/*.pdf
	@echo "Clean complete!"

# List papers and status
list:
	@echo "Panel Research Papers:"
	@echo ""
	@echo "  #  Directory                        PDF Status"
	@echo "  -- -------------------------------- ----------"
	@echo "  1  panel-review-methodology          $$([ -f panel-review-methodology/main.pdf ] && echo 'OK' || echo 'MISSING')"
	@echo "  2  panel-reviewer-calibration        $$([ -f panel-reviewer-calibration/main.pdf ] && echo 'OK' || echo 'MISSING')"
	@echo "  3  panel-revision-dynamics            $$([ -f panel-revision-dynamics/main.pdf ] && echo 'OK' || echo 'MISSING')"
	@echo "  4  panel-portfolio-assessment         $$([ -f panel-portfolio-assessment/main.pdf ] && echo 'OK' || echo 'MISSING')"
	@echo "  5  panel-synthesis-methods             $$([ -f panel-synthesis-methods/main.pdf ] && echo 'OK' || echo 'MISSING')"

# Help
help:
	@echo "Panel Research Papers - Build System"
	@echo ""
	@echo "Available targets:"
	@echo "  make all                           - Build all papers (default)"
	@echo "  make panel-review-methodology      - Build Review Methodology paper"
	@echo "  make panel-reviewer-calibration    - Build Reviewer Calibration paper"
	@echo "  make panel-revision-dynamics       - Build Revision Dynamics paper"
	@echo "  make panel-portfolio-assessment    - Build Portfolio Assessment paper"
	@echo "  make panel-synthesis-methods       - Build Synthesis Methods paper"
	@echo "  make dist                          - Build and copy PDFs to docs/"
	@echo "  make list                          - Show paper status"
	@echo "  make clean                         - Remove all build artifacts"
	@echo "  make help                          - Show this help message"
