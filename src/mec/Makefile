# Builds every deck under lectures/*/ and labs/*/ with the shared theme in ../../template,
# then publishes the PDFs for students into ../../mec as MEC-Lecture-NN.pdf / MEC-Lab-NN.pdf.
TEMPLATE := $(abspath ../../template)
OUT      := $(abspath ../../mec)
PREFIX   := MEC
export TEXINPUTS := $(TEMPLATE)//:
LATEXMK  = latexmk -cd -xelatex -interaction=nonstopmode -halt-on-error
SRC     := $(wildcard lectures/*/*.tex labs/*/*.tex)
PDF     := $(SRC:.tex=.pdf)

all: $(PDF) publish

%.pdf: %.tex $(TEMPLATE)/beamerthemeupbminimal.sty
	$(LATEXMK) $<

# copy the built PDFs to the student folder under their public names, and refresh its index
publish:
	@mkdir -p $(OUT)
	@for f in lectures/lecture*/lecture*.pdf; do n=$${f##*/lecture}; cp "$$f" "$(OUT)/$(PREFIX)-Lecture-$${n%.pdf}.pdf"; done
	@for f in labs/lab*/lab*.pdf; do n=$${f##*/lab}; cp "$$f" "$(OUT)/$(PREFIX)-Lab-$${n%.pdf}.pdf"; done
	@python3 $(TEMPLATE)/index.py . $(OUT) $(PREFIX)

# compile, lint and render contact sheets for every deck
qa:
	@for f in $(SRC); do python3 $(TEMPLATE)/qa.py $$f | grep -E '^(==|PROBLEM|RESULT)'; done

clean:
	@for f in $(SRC); do latexmk -cd -C $$f >/dev/null 2>&1; rm -rf $$(dirname $$f)/preview; done

.PHONY: all publish qa clean
