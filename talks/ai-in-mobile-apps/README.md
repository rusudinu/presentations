# AI in mobile apps: on-device ML, LLMs, RAG and MCP

A talk for developers on putting AI into a mobile app: what runs on the device with ML Kit, how to
call a hosted or local language model from an app, how retrieval-augmented generation works down
to the vector index, how tools and the Model Context Protocol let a model act, and how to secure the
whole workflow. It merges two earlier talks (ML Kit and Vertex AI, given at ONIA, and Vector Search)
and the DevTalks round-table demos.

- **Slides:** [ai-in-mobile-apps.pdf](ai-in-mobile-apps.pdf)
- **Demos:** [demos/](demos/), three notebooks that run against a local model in LM Studio

## Running the demos

1. Install [LM Studio](https://lmstudio.ai), download a chat model and an embedding model, and start
   its local server (see `demos/documents/shared/lm_studio.md` and `shared/qwen_models.md` for the
   models used).
2. `make setup` in `demos/` builds a uv-managed `.venv` with Jupyter and the notebook
   dependencies, so the `%pip install` first cells become no-ops. Then `make lab` opens Jupyter,
   `make rag`, `make mcp` and `make agent` open one notebook, and `make check` verifies that
   LM Studio is answering and lists the models it has loaded. `make help` lists every target.
3. Open the notebooks in order:
   - `01_rag.ipynb`: index the documents, embed a question, retrieve, answer with citations.
   - `02_mcp.ipynb`: define a small MCP server and let the model call its tools.
   - `03_agent.ipynb`: the two combined, with retrieval, web search and page fetching as tools.

Each notebook also installs its own dependencies in the first cell and declares its settings as plain
constants in the second one. Set `RUN_LM_STUDIO_DEMO = False` there to run only the offline cells.

The sample documents the demos index are in `demos/documents/`.
