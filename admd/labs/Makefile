# Builds every .tex deck in this folder with the shared theme in ../../template.
TEMPLATE := $(abspath ../../template)
export TEXINPUTS := $(TEMPLATE)//:
LATEXMK  = latexmk -xelatex -interaction=nonstopmode -halt-on-error
SRC     := $(wildcard *.tex)
PDF     := $(SRC:.tex=.pdf)

all: $(PDF)

%.pdf: %.tex $(TEMPLATE)/beamerthemeupbminimal.sty
	$(LATEXMK) $<

# compile, lint and render contact sheets for every deck
qa:
	@for f in $(SRC); do python3 $(TEMPLATE)/qa.py $$f | grep -E '^(==|PROBLEM|RESULT)'; done

clean:
	latexmk -C $(SRC)
	rm -rf preview

.PHONY: all qa clean
