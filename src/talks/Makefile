# Builds every talk deck under src/talks/<talk>/<talk>.tex and publishes it to talks/<talk>/<talk>.pdf.
# Same conventions as the course Makefiles: TeX Live fonts, reproducible dates, CI publishes.
TEMPLATE := $(abspath ../../template)
OUT      := $(abspath ../../talks)
export TEXINPUTS := $(TEMPLATE)//:
LATEXMK  = latexmk -cd -xelatex -interaction=nonstopmode -halt-on-error
SRC     := $(wildcard */*.tex)
PDF     := $(SRC:.tex=.pdf)

all: $(PDF)

%.pdf: %.tex $(TEMPLATE)/beamerthemeupbminimal.sty
	@epoch=$$(git log -1 --format=%ct -- $(<D) 2>/dev/null); \
	SOURCE_DATE_EPOCH=$${epoch:-$$(date +%s)} SOURCE_DATE_EPOCH_TEX_PRIMITIVES=1 $(LATEXMK) $<

publish:
	@for f in */*.pdf; do [ -f "$$f" ] || continue; d=$${f%%/*}; t="$(OUT)/$$d/$$d.pdf"; mkdir -p "$(OUT)/$$d"; cmp -s "$$f" "$$t" || { cp "$$f" "$$t"; echo "published $$t"; }; done

qa:
	@for f in $(SRC); do python3 $(TEMPLATE)/qa.py $$f | grep -E '^(==|PROBLEM|RESULT)'; done

clean:
	@for f in $(SRC); do latexmk -cd -C $$f >/dev/null 2>&1; rm -rf $$(dirname $$f)/preview; done

.PHONY: all publish qa clean
