# The three notebooks of the "AI in mobile apps" talk. `make setup` builds a uv-managed .venv
# holding Jupyter and the packages the notebooks' first cells install, so those cells become
# no-ops; `make lab` opens Jupyter in this folder; `make check` pings the local LM Studio server.

UV      ?= uv
VENV    := .venv
PY      := $(VENV)/bin/python
JUPYTER := $(VENV)/bin/jupyter

# same versions as the `%pip install` lines in the notebooks, kept in one place
PACKAGES := jupyterlab notebook openai==2.53.0 chromadb==1.5.9 "mcp[cli]==2.0.0" ddgs==9.14.4

# the constants block of every notebook; override on the command line if you moved the server
LM_STUDIO_URL ?= http://127.0.0.1:1234/v1

.DEFAULT_GOAL := help

help: ## list the targets
	@echo "AI in mobile apps, demos. Targets:"
	@awk 'BEGIN{FS=":.*##"} /^[a-zA-Z0-9_-]+:.*##/{printf "  %-10s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo "Variables: LM_STUDIO_URL=<url> for make check (default $(LM_STUDIO_URL))."

setup: $(PY) ## create .venv with uv and install Jupyter and the notebook dependencies
	@$(UV) pip install --quiet --python $(PY) $(PACKAGES)
	@$(PY) -c "import jupyterlab, openai, chromadb, mcp; print('venv ready:', '$(PY)')"

$(PY):
	@$(UV) venv $(VENV)

lab: setup ## open JupyterLab in this folder
	@$(JUPYTER) lab

notebook: setup ## open the classic Notebook interface in this folder
	@$(JUPYTER) notebook

rag: setup ## open 01_rag.ipynb
	@$(JUPYTER) lab 01_rag.ipynb

mcp: setup ## open 02_mcp.ipynb
	@$(JUPYTER) lab 02_mcp.ipynb

agent: setup ## open 03_agent.ipynb
	@$(JUPYTER) lab 03_agent.ipynb

# friendly failure: LM Studio is a desktop app, so "not running" is the common case, not a bug
check: ## check that LM Studio answers and list the models it has loaded
	@out=$$(curl -fsS --max-time 5 $(LM_STUDIO_URL)/models 2>/dev/null) || { \
	  echo "LM Studio is not answering at $(LM_STUDIO_URL)."; \
	  echo "Open LM Studio, load a chat and an embedding model (see documents/shared/lm_studio.md),"; \
	  echo "and start the local server from its Developer tab."; \
	  exit 1; }; \
	echo "LM Studio is up at $(LM_STUDIO_URL). Loaded models:"; \
	echo "$$out" | python3 -c "import json,sys; [print(' ', m['id']) for m in json.load(sys.stdin).get('data', [])]"

clean: ## remove the venv and the notebook checkpoints
	@rm -rf $(VENV) .ipynb_checkpoints */.ipynb_checkpoints

.PHONY: help setup lab notebook rag mcp agent check clean
