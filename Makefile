# The one entry point of the repository: builds the slide decks under src/ and forwards every
# demo command to the Makefile of that demo folder. `make help` lists everything.

SLIDES := src/admd src/mec src/talks
LM_STUDIO_URL ?= http://127.0.0.1:1234/v1

DEMOS  := admd/examples mec/examples talks/he/demo talks/he/demo2 talks/ai-in-mobile-apps/demos

.DEFAULT_GOAL := help

help: ## list the targets
	@echo "Rusu Dinu's presentations. Targets:"
	@awk 'BEGIN{FS=":.*##"} /^[a-zA-Z0-9_-]+:.*##/{printf "  %-14s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo "Demo forwarding, <target> is any target of that folder's Makefile:"
	@echo "  admd-<target>     admd/examples       (e.g. make admd-list, make admd-lecture07)"
	@echo "  mec-<target>      mec/examples        (e.g. make mec-isolate_example)"
	@echo "  he-demo-<target>  talks/he/demo       (e.g. make he-demo-run)"
	@echo "  he-demo2-<target> talks/he/demo2"
	@echo "  ai-<target>       talks/ai-in-mobile-apps/demos (e.g. make ai-check, make ai-lab)"
	@echo "Run 'make <prefix>-help' for a folder's own targets."

slides: slides-admd slides-mec slides-talks ## build every deck under src/

slides-admd: ## build the ADMD lecture and lab decks
	@$(MAKE) -C src/admd

slides-mec: ## build the MEC lecture and lab decks
	@$(MAKE) -C src/mec

slides-talks: ## build the talk decks
	@$(MAKE) -C src/talks

qa: ## compile, lint and render contact sheets for every deck
	@for d in $(SLIDES); do $(MAKE) -C $$d qa; done

setup: ## set up every demo folder (pub get, uv venv)
	@for d in $(DEMOS); do echo "== $$d"; $(MAKE) -C $$d setup || exit 1; done

doctor: ## report which tools this machine has, with a check or a cross
	@printf "  %-10s" flutter;     if command -v flutter >/dev/null 2>&1; then echo "✓ $$(flutter --version 2>/dev/null | head -1)"; else echo "✗ not found, see https://docs.flutter.dev/install"; fi
	@printf "  %-10s" dart;        if command -v dart    >/dev/null 2>&1; then echo "✓ $$(dart --version 2>&1 | head -1)";           else echo "✗ not found, it ships with Flutter"; fi
	@printf "  %-10s" uv;          if command -v uv      >/dev/null 2>&1; then echo "✓ $$(uv --version 2>/dev/null)";                else echo "✗ not found, brew install uv"; fi
	@printf "  %-10s" latexmk;     if command -v latexmk >/dev/null 2>&1; then echo "✓ $$(latexmk -v 2>/dev/null | head -1)";        else echo "✗ not found, install MacTeX or TeX Live"; fi
	@printf "  %-10s" ollama;      if command -v ollama  >/dev/null 2>&1; then echo "✓ $$(ollama --version 2>/dev/null | grep -o 'version is.*' | head -1)"; else echo "✗ not found, brew install ollama (optional)"; fi
	@printf "  %-10s" "LM Studio"; if curl -fsS --max-time 3 $(LM_STUDIO_URL)/models >/dev/null 2>&1; then echo "✓ serving at $(LM_STUDIO_URL)"; else echo "✗ not answering at $(LM_STUDIO_URL), only needed for make ai-*"; fi

clean: ## clean the deck build artefacts and every demo folder
	@for d in $(SLIDES); do $(MAKE) -C $$d clean; done
	@for d in $(DEMOS); do $(MAKE) -C $$d clean; done

# forward "make <prefix>-<target>" to "make -C <folder> <target>"
admd-%:
	@$(MAKE) -C admd/examples $*

mec-%:
	@$(MAKE) -C mec/examples $*

he-demo-%:
	@$(MAKE) -C talks/he/demo $*

he-demo2-%:
	@$(MAKE) -C talks/he/demo2 $*

ai-%:
	@$(MAKE) -C talks/ai-in-mobile-apps/demos $*

.PHONY: help slides slides-admd slides-mec slides-talks qa setup doctor clean
