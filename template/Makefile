LATEXMK = latexmk -xelatex -interaction=nonstopmode -halt-on-error
DECKS   = examples/lecture-example examples/lab-example
export TEXINPUTS := $(CURDIR)//:

all: $(addsuffix .pdf,$(DECKS))

%.pdf: %.tex beamerthemeupbminimal.sty
	$(LATEXMK) -cd $<

# render every page to preview/<deck>-NN.png for a visual QA pass
preview: all
	mkdir -p preview
	for d in $(DECKS); do pdftoppm -png -r 60 $$d.pdf preview/$$(basename $$d); done

clean:
	latexmk -C $(addsuffix .tex,$(DECKS))
	rm -rf preview

.PHONY: all preview clean
