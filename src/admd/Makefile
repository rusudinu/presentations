# Builds every deck under lectures/*/ and labs/*/ with the shared theme in ../../template,
# then publishes the PDFs for students into ../../admd as ADMD-Lecture-NN.pdf / ADMD-Lab-NN.pdf.
TEMPLATE := $(abspath ../../template)
OUT      := $(abspath ../../admd)
PREFIX   := ADMD
export TEXINPUTS := $(TEMPLATE)//:
LATEXMK  = latexmk -cd -xelatex -interaction=nonstopmode -halt-on-error
SRC     := $(wildcard lectures/*/*.tex labs/*/*.tex)
PDF     := $(SRC:.tex=.pdf)

# `make` only builds. Publishing into ../../admd is done by the GitHub workflow, so that the
# committed PDFs always come from one reproducible environment. `make publish` still works locally.
all: $(PDF)

# SOURCE_DATE_EPOCH = the commit time of the deck folder, so an unchanged deck rebuilds to identical bytes.
%.pdf: %.tex $(TEMPLATE)/beamerthemeupbminimal.sty
	@epoch=$$(git log -1 --format=%ct -- $(<D) 2>/dev/null); \
	SOURCE_DATE_EPOCH=$${epoch:-$$(date +%s)} SOURCE_DATE_EPOCH_TEX_PRIMITIVES=1 $(LATEXMK) $<

# copy the built PDFs to the student folder under their public names, and refresh its index
publish:
	@mkdir -p $(OUT)
	@for f in lectures/lecture*/lecture*.pdf; do [ -f "$$f" ] || continue; n=$${f##*/lecture}; t="$(OUT)/$(PREFIX)-Lecture-$${n%.pdf}.pdf"; cmp -s "$$f" "$$t" || { cp "$$f" "$$t"; echo "published $$t"; }; done
	@for f in labs/lab*/lab*.pdf; do [ -f "$$f" ] || continue; n=$${f##*/lab}; t="$(OUT)/$(PREFIX)-Lab-$${n%.pdf}.pdf"; cmp -s "$$f" "$$t" || { cp "$$f" "$$t"; echo "published $$t"; }; done
	@python3 $(TEMPLATE)/index.py . $(OUT) $(PREFIX)

# compile, lint and render contact sheets for every deck
qa:
	@for f in $(SRC); do python3 $(TEMPLATE)/qa.py $$f | grep -E '^(==|PROBLEM|RESULT)'; done

clean:
	@for f in $(SRC); do latexmk -cd -C $$f >/dev/null 2>&1; rm -rf $$(dirname $$f)/preview; done

.PHONY: all publish qa clean
