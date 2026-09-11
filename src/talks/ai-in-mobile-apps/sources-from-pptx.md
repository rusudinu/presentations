

# DECK: onia/ML Kit and Vertex AI.pptx

## slide 1
- ML Kit & VertexAI
- Dinu-Ștefan RUSU
- Founder and Senior Engineer @ CodingShadows
- Building for next-gen mobile experiences
## slide 2
- 2
- Dinu-Ștefan RUSU
- rusudinu.ro | codingshadows.com
## slide 3
- 3
- Agenda
- On-device Image processing and data extraction / Integrating conversational workflows into an existing application / Integrating existing applications into LLMs (MCP Servers)
## slide 4
- 4
- On-device Image processing
## slide 5
- 5
- On-device Image processing
## slide 6
- 6
- On-device Image processing
## slide 7
- 7
- On-device Image processing
## slide 8
- 8
- What now?
## slide 9
- 9
- On-device Image processing
## slide 10
- 10
- On-device Image processing
## slide 11
- 11
- On-device Image processing
## slide 12
- 12
- On-device Image processing
## slide 13
- 13
- On-device Image processing
## slide 14
- 14
- Cloud image processing
## slide 15
- 15
- Recap
## slide 16
- 16
- Recap
## slide 17
- 17
- Integrating conversational workflows into an existing application
## slide 18
- 18
- Integrating conversational workflows into an existing application
## slide 19
- 19
## slide 20
- 20
## slide 21
- 21
- Enriching context
## slide 22
- 22
## slide 23
- 23
## slide 24
- 24
- RAG Demo
## slide 25
- 25
- Integrating existing applications into LLMs (as MCP Servers)
## slide 26
- 26
- Integrating existing applications into LLMs (as MCP Servers)
## slide 27
- 27
- Integrating existing applications into LLMs (as MCP Servers)
## slide 28
- 28
- Recap
## slide 29
- 29
- MCP Demo With LMStudio
## slide 30
- 30
- Securing cloudLLM workflows
## slide 31
- 31
- Request processingand token set-up
## slide 32
- 32
- Reasoning, Validation, Human in the Loop
## slide 33
- 33
- Output guardrails
## slide 34
- rusudinu.rocodingshadows.com
- Questions
- See you at
- ©


# DECK: rag/Vector-Search.pptx

## slide 1
- 1
- Retrieval Augmented Generation (RAG)
## slide 2
- Vector Embeddings
- Embeddings are high-dimensional dense vectors (arrays of floating-point numbers) that represent data. / In this vector space, objects with similar meanings are positioned closer together. / [0.12, -0.45, 0.88, ... 0.05] / Example: The vector for "King" minus "Man" plus "Woman" results in a vector closest to "Queen".
## slide 3
- How Vector Search Works
- 1. Ingestion: Source data (text, images) is passed through an Embedding Model to generate vectors. / 2. Indexing: Vectors are stored in Elasticsearch. / 3. Query Time: The user's query is vectorized using the same model. / 4. Similarity: Elasticsearch calculates the distance (Cosine, Euclidean, Dot Product) to find the nearest neighbors.
## slide 4
- Distance Metrics
## slide 5
- Search Methods: Exact vs. Approximate
## slide 6
- Hybrid Search: Best of Both Worlds
## slide 7
- LMStudio
- Desktop application for Windows, macOS, and Linux that allows users to discover, download, and run large language models (LLMs) locally
## slide 8
- LMStudio – Downloading a model
## slide 9
- LMStudio – Starting the server
## slide 10
- LMStudio – Selecting embedding models
## slide 11
- Creating an index
## slide 12
- Indexing documents
## slide 13
- Searching text
## slide 14
- Generating embeddings
## slide 15
- Libraries used
- The openai library is used to generate vector embeddings from text. It connects to an OpenAI-compatible API (likely a local one, such as LMStudio) to create these embeddings. / The elasticsearch library is used to store and search these vector embeddings. It acts as a vector database, allowing the application to perform semantic searches to find the most relevant documents for a given query.
## slide 16
- Initial dataset
## slide 17
- Embedding dataset
## slide 18
- Elasticsearch Model
## slide 19
- Index visualization
## slide 20
- One document’s values
## slide 21
- Querying the embeddings
## slide 22
- 22
- Diagrams
## slide 23
- 23
## slide 24
- 24


# NOTEBOOK: demos/01_rag.ipynb

# 01 — Classic RAG with local models

**Learning goal:** see the complete retrieve-then-generate pipeline: configure a profile, ingest its documents into in-memory Chroma, inspect nearest passages, build a grounded prompt, and ask a local chat model.

**Prerequisites:** Python 3, this notebook inside the `demos/` folder, and LM Studio with the configured chat and embedding models loaded. Run cells top to bottom. Set `PROFILE` to `"onia"` or `"devtalks"` before ingestion. The install, configuration, corpus, and prompt-builder cells work offline; cells marked **LM Studio** are opt-in and require the local server. `RUN_LM_STUDIO_DEMO` is intentionally `False` so a safe Run All performs no model calls.
```python
%pip install -q openai==2.53.0 chromadb==1.5.9
```
## 1. Configuration
Edit the constants here or override them with environment variables of the same name. Document discovery starts at `Path.cwd()` and accepts either the `demos/` directory, its parent, or a descendant.
```python
import os
from pathlib import Path

OPENAI_BASE_URL = os.getenv("OPENAI_BASE_URL", "http://127.0.0.1:1234/v1")
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY", "lm-studio")
CHAT_MODEL = os.getenv("CHAT_MODEL", "qwen/qwen3.5-9b")
EMBEDDING_MODEL = os.getenv("EMBEDDING_MODEL", "text-embedding-qwen3-embedding-4b")
PROFILE = os.getenv("PROFILE", "devtalks").lower()  # "onia" or "devtalks"
TOP_K = int(os.getenv("TOP_K", "3"))
RUN_LM_STUDIO_DEMO = False

if PROFILE not in {"onia", "devtalks"}:
    raise ValueError("PROFILE must be 'onia' or 'devtalks'.")
if TOP_K <= 0:
    raise ValueError("TOP_K must be a positive integer.")

def find_demo_root() -> Path:
    cwd = Path.cwd().resolve()
    candidates = [cwd, cwd / "demos", *cwd.parents]
    for candidate in candidates:
        if (candidate / "documents" / "shared" / "rag_overview.md").is_file():
            return candidate
    raise FileNotFoundError(
        "Could not find demos/documents from the current working directory. "
        "Launch Jupyter from the presentations root or the demos directory."
    )

DEMO_ROOT = find_demo_root()
DOCUMENTS_ROOT = DEMO_ROOT / "documents"
print(f"Profile: {PROFILE} | documents: {DOCUMENTS_ROOT}")
```
## 2. Select the profile-aware corpus
ONIA uses its classic-RAG model note; DevTalks uses the shared model note. Each profile combines shared RAG/LM Studio material with its own conference document.
```python
PROFILE_DOCUMENTS = {
    "onia": [
        "shared/lm_studio.md",
        "shared/rag_overview.md",
        "onia/qwen_models_classic_rag.md",
        "onia/onia_conference.md",
    ],
    "devtalks": [
        "shared/lm_studio.md",
        "shared/rag_overview.md",
        "shared/qwen_models.md",
        "devtalks/devtalks_conference.md",
    ],
}

document_paths = [DOCUMENTS_ROOT / relative for relative in PROFILE_DOCUMENTS[PROFILE]]
missing = [path for path in document_paths if not path.is_file()]
if missing:
    raise FileNotFoundError(f"Missing demo documents: {missing}")
documents = [(path.relative_to(DOCUMENTS_ROOT).as_posix(), path.read_text(encoding="utf-8")) for path in document_paths]
print("Corpus:")
for source, text in documents:
    print(f"  {source}: {len(text)} characters")
```
## 3. Connection and model check — **requires LM Studio**
Enable the guard to contact the local OpenAI-compatible endpoint and verify that both configured models are advertised.
```python
from openai import OpenAI

openai_client = OpenAI(base_url=OPENAI_BASE_URL, api_key=OPENAI_API_KEY)

if RUN_LM_STUDIO_DEMO:
    available_models = sorted(model.id for model in openai_client.models.list().data)
    print("Available models:", available_models)
    for required_model in (CHAT_MODEL, EMBEDDING_MODEL):
        if required_model not in available_models:
            raise RuntimeError(f"Load {required_model!r} in LM Studio before continuing.")
else:
    print("Skipped. Set RUN_LM_STUDIO_DEMO=True to check the local server.")
```
## 4. Ingest into in-memory Chroma — **requires LM Studio embeddings**
Chroma calls the embedding adapter for both stored documents and later queries, keeping vectors in the same space. The collection disappears with the kernel.
```python
import chromadb
from chromadb.api.types import Documents, EmbeddingFunction, Embeddings

class OpenAIEmbeddingFunction(EmbeddingFunction[Documents]):
    def __init__(self, client: OpenAI, model: str) -> None:
        self.client = client
        self.model = model

    def __call__(self, input: Documents) -> Embeddings:
        response = self.client.embeddings.create(model=self.model, input=list(input))
        return [item.embedding for item in response.data]

collection = None
if RUN_LM_STUDIO_DEMO:
    chroma_client = chromadb.EphemeralClient()
    embedder = OpenAIEmbeddingFunction(openai_client, EMBEDDING_MODEL)
    collection = chroma_client.get_or_create_collection(
        name=f"notebook_rag_{PROFILE}", embedding_function=embedder
    )
    collection.add(
        ids=[f"doc-{index}" for index in range(len(documents))],
        documents=[text for _, text in documents],
        metadatas=[{"source": source} for source, _ in documents],
    )
    print(f"Indexed {collection.count()} documents.")
else:
    print("Skipped ingestion.")
```
## 5. Retrieve and inspect — **requires LM Studio embeddings**
Change the question for the selected profile. Distances are shown so the retrieval step stays visible rather than becoming hidden prompt plumbing.
```python
QUESTION = (
    "What is ONIA and which models support this RAG demo?"
    if PROFILE == "onia"
    else "What is DevTalks and which models support this RAG demo?"
)
hits = []
if RUN_LM_STUDIO_DEMO:
    result = collection.query(query_texts=[QUESTION], n_results=min(TOP_K, collection.count()))
    hits = [
        {"text": text, "source": metadata["source"], "distance": distance}
        for text, metadata, distance in zip(
            result["documents"][0], result["metadatas"][0], result["distances"][0]
        )
    ]
    for rank, hit in enumerate(hits, 1):
        preview = hit["text"].replace("\n", " ")[:120]
        print(f"{rank}. {hit['source']} | distance={hit['distance']:.4f} | {preview}…")
else:
    print("Skipped retrieval.")
```
## 6. Build the grounded prompt
The instruction limits generation to retrieved evidence and asks for filename citations. This function itself is offline; the preview appears after retrieval.
```python
def grounded_messages(question: str, retrieved_hits: list[dict]) -> list[dict]:
    context = "\n\n".join(
        f"[source: {hit['source']}]\n{hit['text']}" for hit in retrieved_hits
    )
    return [
        {
            "role": "system",
            "content": (
                "Answer only from the supplied context. If it does not contain the answer, "
                "say you do not know. Cite supporting source filenames."
            ),
        },
        {"role": "user", "content": f"Context:\n{context}\n\nQuestion: {question}"},
    ]

messages = grounded_messages(QUESTION, hits) if hits else []
print(messages[1]["content"][:800] if messages else "Prompt awaits retrieved passages.")
```
## 7. Generate the answer — **requires LM Studio chat**
The final call uses the retrieved context assembled above.
```python
if RUN_LM_STUDIO_DEMO:
    response = openai_client.chat.completions.create(
        model=CHAT_MODEL, messages=messages, temperature=0.2
    )
    print(response.choices[0].message.content or "")
else:
    print("Skipped generation. Set RUN_LM_STUDIO_DEMO=True and rerun cells 3–7.")
```


# NOTEBOOK: demos/02_mcp.ipynb

# 02 — MCP in one notebook process

**Learning goal:** define MCP tools, discover and call them through the real MCP protocol over an in-memory transport, then optionally let a local model choose tools.

**Prerequisites:** Python 3 and this notebook inside `demos/`. Run cells top to bottom. `PROFILE` remains a shared suite switch (`"onia"` or `"devtalks"`) although this protocol-only notebook uses the same tools for both. The direct MCP cells need neither LM Studio nor internet and run by default. Only the final agent cell requires LM Studio; it is guarded by `RUN_LM_STUDIO_DEMO=False`. Re-running definitions is safe because `make_mcp_server()` creates a fresh server each time.
```python
%pip install -q openai==2.53.0 "mcp[cli]==2.0.0"
```
## 1. Shared configuration
Constants are editable and environment variables override them. The document-root check catches a notebook launched from an unrelated working directory even though this example does not read the corpus.
```python
import os
from pathlib import Path

OPENAI_BASE_URL = os.getenv("OPENAI_BASE_URL", "http://127.0.0.1:1234/v1")
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY", "lm-studio")
CHAT_MODEL = os.getenv("CHAT_MODEL", "qwen/qwen3.5-9b")
EMBEDDING_MODEL = os.getenv("EMBEDDING_MODEL", "text-embedding-qwen3-embedding-4b")
PROFILE = os.getenv("PROFILE", "devtalks").lower()
TOP_K = int(os.getenv("TOP_K", "3"))
RUN_DIRECT_MCP_DEMO = True
RUN_LM_STUDIO_DEMO = False

if PROFILE not in {"onia", "devtalks"}:
    raise ValueError("PROFILE must be 'onia' or 'devtalks'.")
if TOP_K <= 0:
    raise ValueError("TOP_K must be a positive integer.")

def find_demo_root() -> Path:
    cwd = Path.cwd().resolve()
    for candidate in [cwd, cwd / "demos", *cwd.parents]:
        if (candidate / "documents" / "shared" / "mcp_overview.md").is_file():
            return candidate
    raise FileNotFoundError(
        "Could not find demos/documents. Launch Jupyter from the presentations root or demos directory."
    )

DEMO_ROOT = find_demo_root()
print(f"Profile: {PROFILE} | demo root: {DEMO_ROOT}")
```
## 2. Define a fresh MCP server and two tools
The factory prevents duplicate tool registration when this cell is re-run. `current_time` accepts standard IANA timezone names.
```python
from datetime import datetime
from zoneinfo import ZoneInfo, ZoneInfoNotFoundError

from mcp.server import MCPServer

def make_mcp_server() -> MCPServer:
    server = MCPServer("notebook-mcp-demo")

    @server.tool()
    def add(a: int, b: int) -> int:
        """Return the sum of two integers."""
        return a + b

    @server.tool()
    def current_time(timezone: str = "UTC") -> str:
        """Return the current wall-clock time in an IANA timezone."""
        try:
            tz = ZoneInfo(timezone)
        except ZoneInfoNotFoundError:
            return f"Unknown timezone: {timezone!r}"
        return datetime.now(tz).isoformat(timespec="seconds")

    return server

mcp_server = make_mcp_server()
print("Fresh MCPServer created.")
```
## 3. Discover and call tools through MCP — **offline**
This is not a direct Python function call: `ClientSession` initializes an MCP connection, asks the server for its schemas, and sends tool-call requests through `InMemoryTransport`. Jupyter supports the top-level `await` used here.
```python
from typing import Any

from mcp import ClientSession
from mcp.client._memory import InMemoryTransport

def tool_result_text(result: Any) -> str:
    return "\n".join(
        getattr(block, "text", str(block)) for block in result.content
    ).strip()

if RUN_DIRECT_MCP_DEMO:
    async with InMemoryTransport(mcp_server, raise_exceptions=True) as (read, write):
        async with ClientSession(read, write) as session:
            await session.initialize()
            advertised = await session.list_tools()
            print("Advertised tools:")
            for tool in advertised.tools:
                print(f"  {tool.name}: {tool.description}")
            sum_result = await session.call_tool("add", {"a": 17, "b": 25})
            time_result = await session.call_tool(
                "current_time", {"timezone": "Europe/Bucharest"}
            )
            print("add =>", tool_result_text(sum_result))
            print("current_time =>", tool_result_text(time_result))
else:
    print("Direct MCP demonstration skipped.")
```
## 4. Optional model-driven tool loop — **requires LM Studio**
The client translates MCP tool descriptors into OpenAI-compatible function schemas. The model chooses a tool; the client executes it through MCP and returns the result for a final answer. No internet is needed.
```python
import json
from openai import OpenAI

def openai_tool_schemas(mcp_tools: Any) -> list[dict]:
    return [
        {
            "type": "function",
            "function": {
                "name": tool.name,
                "description": tool.description or "",
                "parameters": tool.inputSchema or {"type": "object"},
            },
        }
        for tool in mcp_tools.tools
    ]

QUESTION = "What is 17 plus 25, and what time is it in Europe/Bucharest?"

if RUN_LM_STUDIO_DEMO:
    llm = OpenAI(base_url=OPENAI_BASE_URL, api_key=OPENAI_API_KEY)
    agent_server = make_mcp_server()
    async with InMemoryTransport(agent_server, raise_exceptions=True) as (read, write):
        async with ClientSession(read, write) as session:
            await session.initialize()
            schemas = openai_tool_schemas(await session.list_tools())
            messages = [
                {"role": "system", "content": "Use MCP tools when helpful; answer concisely."},
                {"role": "user", "content": QUESTION},
            ]
            for step in range(5):
                response = llm.chat.completions.create(
                    model=CHAT_MODEL, messages=messages, tools=schemas,
                    tool_choice="auto", temperature=0.2,
                )
                message = response.choices[0].message
                calls = message.tool_calls or []
                if not calls:
                    print(message.content or "")
                    break
                messages.append({
                    "role": "assistant",
                    "content": message.content or "",
                    "tool_calls": [call.model_dump() for call in calls],
                })
                for call in calls:
                    arguments = json.loads(call.function.arguments or "{}")
                    result = await session.call_tool(call.function.name, arguments)
                    text = tool_result_text(result)
                    print(f"tool: {call.function.name}({arguments}) -> {text}")
                    messages.append({"role": "tool", "tool_call_id": call.id, "content": text})
            else:
                print("Stopped after five tool-selection steps.")
else:
    print("Skipped model-driven agent. Set RUN_LM_STUDIO_DEMO=True to enable it.")
```


# NOTEBOOK: demos/03_mcp_rag.ipynb

# 03 — RAG as an MCP capability

**Learning goal:** put profile-aware retrieval behind genuine MCP tools, demonstrate protocol discovery without a model, then compare deterministic retrieve-then-answer with model-selected retrieval.

**Prerequisites:** Python 3 and this notebook inside `demos/`. Run cells top to bottom and choose `PROFILE="onia"` or `"devtalks"`. Installation, configuration, server creation, `list_tools`, and `list_sources` need neither LM Studio nor internet. Index construction is lazy: only `search_knowledge` contacts LM Studio for embeddings. The deterministic and agentic paths are separately opt-in, and both are disabled by default. Re-running factory cells creates fresh servers, avoiding duplicate registrations.
```python
%pip install -q openai==2.53.0 chromadb==1.5.9 "mcp[cli]==2.0.0"
```
## 1. Configuration and profile
Editable defaults can be overridden by environment variables. Document discovery begins at `Path.cwd()` and fails clearly when Jupyter starts outside the suite.
```python
import os
from pathlib import Path

OPENAI_BASE_URL = os.getenv("OPENAI_BASE_URL", "http://127.0.0.1:1234/v1")
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY", "lm-studio")
CHAT_MODEL = os.getenv("CHAT_MODEL", "qwen/qwen3.5-9b")
EMBEDDING_MODEL = os.getenv("EMBEDDING_MODEL", "text-embedding-qwen3-embedding-4b")
PROFILE = os.getenv("PROFILE", "devtalks").lower()
TOP_K = int(os.getenv("TOP_K", "3"))
RUN_DETERMINISTIC_DEMO = False  # embeddings + chat through LM Studio
RUN_AGENTIC_DEMO = False       # tool calling + embeddings + chat through LM Studio

if PROFILE not in {"onia", "devtalks"}:
    raise ValueError("PROFILE must be 'onia' or 'devtalks'.")
if TOP_K <= 0:
    raise ValueError("TOP_K must be a positive integer.")

def find_demo_root() -> Path:
    cwd = Path.cwd().resolve()
    for candidate in [cwd, cwd / "demos", *cwd.parents]:
        if (candidate / "documents" / "shared" / "mcp_plus_rag.md").is_file():
            return candidate
    raise FileNotFoundError(
        "Could not find demos/documents. Launch Jupyter from the presentations root or demos directory."
    )

DEMO_ROOT = find_demo_root()
DOCUMENTS_ROOT = DEMO_ROOT / "documents"
print(f"Profile: {PROFILE} | documents: {DOCUMENTS_ROOT}")
```
## 2. Build the selected corpus manifest — **offline**
The ONIA profile uses its MCP-RAG-specific model note. The DevTalks profile uses the broader shared model note. File contents are loaded only when the lazy index is first searched.
```python
PROFILE_DOCUMENTS = {
    "onia": [
        "shared/lm_studio.md",
        "shared/mcp_overview.md",
        "shared/mcp_plus_rag.md",
        "onia/qwen_models_mcp_rag.md",
        "onia/onia_conference.md",
    ],
    "devtalks": [
        "shared/lm_studio.md",
        "shared/mcp_overview.md",
        "shared/mcp_plus_rag.md",
        "shared/qwen_models.md",
        "devtalks/devtalks_conference.md",
    ],
}
selected_paths = [DOCUMENTS_ROOT / relative for relative in PROFILE_DOCUMENTS[PROFILE]]
missing = [path for path in selected_paths if not path.is_file()]
if missing:
    raise FileNotFoundError(f"Missing demo documents: {missing}")
for path in selected_paths:
    print(path.relative_to(DOCUMENTS_ROOT).as_posix())
```
## 3. Embedding adapter and lazy MCP server
`list_sources` reads only the manifest. `search_knowledge` triggers the one-time in-memory Chroma build and therefore requires LM Studio's embedding model. A fresh closure holds independent state on every factory call.
```python
from typing import Any

import chromadb
from chromadb.api.types import Documents, EmbeddingFunction, Embeddings
from mcp.server import MCPServer
from openai import OpenAI

class OpenAIEmbeddingFunction(EmbeddingFunction[Documents]):
    def __init__(self, client: OpenAI, model: str) -> None:
        self.client = client
        self.model = model

    def __call__(self, input: Documents) -> Embeddings:
        response = self.client.embeddings.create(model=self.model, input=list(input))
        return [item.embedding for item in response.data]

def make_rag_server() -> MCPServer:
    server = MCPServer(f"notebook-mcp-rag-{PROFILE}")
    state: dict[str, Any] = {"collection": None, "chroma_client": None}

    def ensure_index():
        if state["collection"] is not None:
            return state["collection"]
        llm = OpenAI(base_url=OPENAI_BASE_URL, api_key=OPENAI_API_KEY)
        embedder = OpenAIEmbeddingFunction(llm, EMBEDDING_MODEL)
        chroma_client = chromadb.EphemeralClient()
        collection = chroma_client.get_or_create_collection(
            name=f"notebook_mcp_rag_{PROFILE}", embedding_function=embedder
        )
        sources = [path.relative_to(DOCUMENTS_ROOT).as_posix() for path in selected_paths]
        collection.add(
            ids=[f"doc-{index}" for index in range(len(selected_paths))],
            documents=[path.read_text(encoding="utf-8") for path in selected_paths],
            metadatas=[{"source": source} for source in sources],
        )
        state.update(collection=collection, chroma_client=chroma_client)
        print(f"Lazy index built with {collection.count()} documents.")
        return collection

    @server.tool()
    def search_knowledge(query: str, k: int = TOP_K) -> str:
        """Search the selected local corpus and return source-labelled passages."""
        if k <= 0:
            return "k must be a positive integer."
        collection = ensure_index()
        result = collection.query(query_texts=[query], n_results=min(k, collection.count()))
        return "\n\n---\n\n".join(
            f"[source: {meta['source']}] (distance={distance:.4f})\n{text.strip()}"
            for text, meta, distance in zip(
                result["documents"][0], result["metadatas"][0], result["distances"][0]
            )
        )

    @server.tool()
    def list_sources() -> list[str]:
        """List source filenames in the selected profile without building the index."""
        return [path.relative_to(DOCUMENTS_ROOT).as_posix() for path in selected_paths]

    return server

rag_server = make_rag_server()
print("Fresh lazy MCP-RAG server created; no model calls made.")
```
## 4. MCP discovery — **offline, no LM Studio**
This genuine MCP exchange lists schemas and calls only `list_sources`; lazy retrieval remains untouched. Jupyter's top-level `await` keeps the protocol flow visible.
```python
from mcp import ClientSession
from mcp.client._memory import InMemoryTransport

def tool_result_text(result: Any) -> str:
    return "\n".join(getattr(block, "text", str(block)) for block in result.content).strip()

async with InMemoryTransport(rag_server, raise_exceptions=True) as (read, write):
    async with ClientSession(read, write) as session:
        await session.initialize()
        tools = await session.list_tools()
        print("Advertised:", [tool.name for tool in tools.tools])
        sources_result = await session.call_tool("list_sources", {})
        print("Sources via MCP:", tool_result_text(sources_result))
```
## 5. Deterministic retrieve-then-answer — **opt-in LM Studio**
This path always calls `search_knowledge` once and then gives its passages to the chat model. It is useful when reliable grounding matters more than model autonomy.
```python
QUESTION = (
    "What is ONIA, and how does MCP combine with RAG in this demo?"
    if PROFILE == "onia"
    else "What is DevTalks, and how does MCP combine with RAG in this demo?"
)

if RUN_DETERMINISTIC_DEMO:
    deterministic_server = make_rag_server()
    async with InMemoryTransport(deterministic_server, raise_exceptions=True) as (read, write):
        async with ClientSession(read, write) as session:
            await session.initialize()
            result = await session.call_tool("search_knowledge", {"query": QUESTION, "k": TOP_K})
            context = tool_result_text(result)
            print(context[:1200])
    llm = OpenAI(base_url=OPENAI_BASE_URL, api_key=OPENAI_API_KEY)
    response = llm.chat.completions.create(
        model=CHAT_MODEL,
        messages=[
            {"role": "system", "content": "Answer only from context; cite source filenames."},
            {"role": "user", "content": f"Context:\n{context}\n\nQuestion: {QUESTION}"},
        ],
        temperature=0.2,
    )
    print("\nAnswer:\n", response.choices[0].message.content or "")
else:
    print("Skipped deterministic path. Set RUN_DETERMINISTIC_DEMO=True to enable it.")
```
## 6. Agentic retrieval — **opt-in LM Studio**
Here MCP advertises the same tools to the model. The model decides when to search, while the system prompt requires grounded answers and filename citations.
```python
import json

def openai_tool_schemas(mcp_tools: Any) -> list[dict]:
    return [{
        "type": "function",
        "function": {
            "name": tool.name,
            "description": tool.description or "",
            "parameters": tool.inputSchema or {"type": "object"},
        },
    } for tool in mcp_tools.tools]

if RUN_AGENTIC_DEMO:
    llm = OpenAI(base_url=OPENAI_BASE_URL, api_key=OPENAI_API_KEY)
    agent_server = make_rag_server()
    async with InMemoryTransport(agent_server, raise_exceptions=True) as (read, write):
        async with ClientSession(read, write) as session:
            await session.initialize()
            schemas = openai_tool_schemas(await session.list_tools())
            messages = [
                {"role": "system", "content": (
                    "Consult search_knowledge for local-demo questions. Answer only from retrieved "
                    "passages, cite source filenames, and say when the corpus lacks the answer."
                )},
                {"role": "user", "content": QUESTION},
            ]
            for step in range(5):
                response = llm.chat.completions.create(
                    model=CHAT_MODEL, messages=messages, tools=schemas,
                    tool_choice="auto", temperature=0.2,
                )
                message = response.choices[0].message
                calls = message.tool_calls or []
                if not calls:
                    print(message.content or "")
                    break
                messages.append({"role": "assistant", "content": message.content or "",
                                 "tool_calls": [call.model_dump() for call in calls]})
                for call in calls:
                    arguments = json.loads(call.function.arguments or "{}")
                    result = await session.call_tool(call.function.name, arguments)
                    text = tool_result_text(result)
                    print(f"tool: {call.function.name}({arguments}) -> {text[:180]}…")
                    messages.append({"role": "tool", "tool_call_id": call.id, "content": text})
            else:
                print("Stopped after five tool-selection steps.")
else:
    print("Skipped agentic path. Set RUN_AGENTIC_DEMO=True to enable it.")
```


# NOTEBOOK: demos/04_mcp_rag_web.ipynb

# 04 — MCP + local RAG + live web

**Learning goal:** extend the lazy MCP-RAG server with current-date grounding, live search, safe page fetching, and an agent policy that separates local knowledge from current web information.

**Prerequisites:** Python 3 and this notebook inside `demos/`. Run cells top to bottom and choose `PROFILE="onia"` or `"devtalks"`. Installation, configuration, tool registration, MCP discovery, `current_date`, and `list_sources` are offline. `search_knowledge` requires LM Studio embeddings; the agent requires LM Studio chat and may also require embeddings/internet according to its choices. `search_web` and `fetch_page` require internet. All live/model paths are opt-in and disabled by default. Each factory run creates a fresh server, so re-running cells does not duplicate tools.
```python
%pip install -q openai==2.53.0 chromadb==1.5.9 "mcp[cli]==2.0.0" ddgs==9.14.4
```
## 1. Configuration and profile
Edit constants or override them with same-named environment variables. Document resolution starts from `Path.cwd()` and reports how to fix a wrong launch directory.
```python
import os
from pathlib import Path

OPENAI_BASE_URL = os.getenv("OPENAI_BASE_URL", "http://127.0.0.1:1234/v1")
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY", "lm-studio")
CHAT_MODEL = os.getenv("CHAT_MODEL", "qwen/qwen3.5-9b")
EMBEDDING_MODEL = os.getenv("EMBEDDING_MODEL", "text-embedding-qwen3-embedding-4b")
PROFILE = os.getenv("PROFILE", "devtalks").lower()
TOP_K = int(os.getenv("TOP_K", "3"))
RUN_WEB_DEMO = False       # internet only
RUN_AGENTIC_DEMO = False  # LM Studio; tools may also use internet/embeddings

if PROFILE not in {"onia", "devtalks"}:
    raise ValueError("PROFILE must be 'onia' or 'devtalks'.")
if TOP_K <= 0:
    raise ValueError("TOP_K must be a positive integer.")

def find_demo_root() -> Path:
    cwd = Path.cwd().resolve()
    for candidate in [cwd, cwd / "demos", *cwd.parents]:
        if (candidate / "documents" / "shared" / "mcp_plus_rag.md").is_file():
            return candidate
    raise FileNotFoundError(
        "Could not find demos/documents. Launch Jupyter from the presentations root or demos directory."
    )

DEMO_ROOT = find_demo_root()
DOCUMENTS_ROOT = DEMO_ROOT / "documents"
print(f"Profile: {PROFILE} | documents: {DOCUMENTS_ROOT}")
```
## 2. Profile-aware local corpus — **offline**
The local side retains the same MCP-RAG profile split; web tools supplement rather than replace these curated documents.
```python
PROFILE_DOCUMENTS = {
    "onia": [
        "shared/lm_studio.md", "shared/mcp_overview.md",
        "shared/mcp_plus_rag.md", "onia/qwen_models_mcp_rag.md",
        "onia/onia_conference.md",
    ],
    "devtalks": [
        "shared/lm_studio.md", "shared/mcp_overview.md",
        "shared/mcp_plus_rag.md", "shared/qwen_models.md",
        "devtalks/devtalks_conference.md",
    ],
}
selected_paths = [DOCUMENTS_ROOT / relative for relative in PROFILE_DOCUMENTS[PROFILE]]
missing = [path for path in selected_paths if not path.is_file()]
if missing:
    raise FileNotFoundError(f"Missing demo documents: {missing}")
print("Local sources:", [path.relative_to(DOCUMENTS_ROOT).as_posix() for path in selected_paths])
```
## 3. Safe URL validation for page fetching
Before any fetch, the URL must use HTTP(S), contain no credentials, and resolve only to public addresses. Loopback, private, link-local, reserved, multicast, and unspecified targets are rejected to reduce server-side request forgery risk. DNS resolution occurs only when `fetch_page` is actually called.
```python
import ipaddress
import socket
from urllib.parse import urlparse

def validate_public_http_url(url: str) -> str:
    parsed = urlparse(url.strip())
    if parsed.scheme.lower() not in {"http", "https"}:
        raise ValueError("Only http:// and https:// URLs may be fetched.")
    if not parsed.hostname:
        raise ValueError("URL must include a hostname.")
    if parsed.username is not None or parsed.password is not None:
        raise ValueError("URLs containing credentials are not allowed.")
    try:
        port = parsed.port or (443 if parsed.scheme.lower() == "https" else 80)
        addresses = {
            info[4][0] for info in socket.getaddrinfo(parsed.hostname, port, type=socket.SOCK_STREAM)
        }
    except (socket.gaierror, ValueError) as exc:
        raise ValueError(f"Could not resolve a safe destination for {url!r}.") from exc
    if not addresses:
        raise ValueError("Hostname did not resolve to an address.")
    for address in addresses:
        ip = ipaddress.ip_address(address)
        if (ip.is_private or ip.is_loopback or ip.is_link_local or ip.is_reserved
                or ip.is_multicast or ip.is_unspecified):
            raise ValueError(f"Refusing non-public destination: {address}")
    return parsed.geturl()

print("URL validator ready; no network request made.")
```
## 4. Create the lazy MCP-RAG + web server
The local index is built only by `search_knowledge`. `search_web` returns snippets, while `fetch_page` validates and extracts a selected page. `current_date` grounds relative dates and `list_sources` exposes the local manifest without model calls.
```python
from datetime import datetime
from typing import Any
from zoneinfo import ZoneInfo, ZoneInfoNotFoundError

import chromadb
from chromadb.api.types import Documents, EmbeddingFunction, Embeddings
from ddgs import DDGS
from mcp.server import MCPServer
from openai import OpenAI

class OpenAIEmbeddingFunction(EmbeddingFunction[Documents]):
    def __init__(self, client: OpenAI, model: str) -> None:
        self.client = client
        self.model = model

    def __call__(self, input: Documents) -> Embeddings:
        response = self.client.embeddings.create(model=self.model, input=list(input))
        return [item.embedding for item in response.data]

def make_web_rag_server() -> MCPServer:
    server = MCPServer(f"notebook-mcp-rag-web-{PROFILE}")
    state: dict[str, Any] = {"collection": None, "chroma_client": None}

    def ensure_index():
        if state["collection"] is not None:
            return state["collection"]
        llm = OpenAI(base_url=OPENAI_BASE_URL, api_key=OPENAI_API_KEY)
        chroma_client = chromadb.EphemeralClient()
        collection = chroma_client.get_or_create_collection(
            name=f"notebook_mcp_rag_web_{PROFILE}",
            embedding_function=OpenAIEmbeddingFunction(llm, EMBEDDING_MODEL),
        )
        sources = [path.relative_to(DOCUMENTS_ROOT).as_posix() for path in selected_paths]
        collection.add(
            ids=[f"doc-{index}" for index in range(len(selected_paths))],
            documents=[path.read_text(encoding="utf-8") for path in selected_paths],
            metadatas=[{"source": source} for source in sources],
        )
        state.update(collection=collection, chroma_client=chroma_client)
        print(f"Lazy local index built with {collection.count()} documents.")
        return collection

    @server.tool()
    def search_knowledge(query: str, k: int = TOP_K) -> str:
        """Search the selected local demo corpus; use for stable, local information."""
        if k <= 0:
            return "k must be a positive integer."
        collection = ensure_index()
        result = collection.query(query_texts=[query], n_results=min(k, collection.count()))
        return "\n\n---\n\n".join(
            f"[source: {meta['source']}] (distance={distance:.4f})\n{text.strip()}"
            for text, meta, distance in zip(
                result["documents"][0], result["metadatas"][0], result["distances"][0]
            )
        )

    @server.tool()
    def search_web(query: str, k: int = 5) -> str:
        """Search the live web for current information and return result snippets and URLs."""
        if k <= 0:
            return "k must be a positive integer."
        try:
            results = DDGS().text(query, max_results=min(k, 10))
        except Exception as exc:
            return f"Web search failed: {exc}"
        if not results:
            return "No web results found."
        return "\n\n".join(
            f"{index}. {item.get('title', '').strip()}\nURL: {item.get('href', '').strip()}\n{item.get('body', '').strip()}"
            for index, item in enumerate(results, 1)
        )

    @server.tool()
    def fetch_page(url: str, max_chars: int = 6000) -> str:
        """Validate and fetch a public HTTP(S) page when a search snippet is insufficient."""
        if not 1 <= max_chars <= 20000:
            return "max_chars must be between 1 and 20000."
        try:
            safe_url = validate_public_http_url(url)
        except ValueError as exc:
            return f"URL rejected: {exc}"
        try:
            extracted = DDGS().extract(safe_url)
        except Exception as exc:
            return f"Failed to fetch {safe_url}: {exc}"
        content = extracted.get("content", "") if isinstance(extracted, dict) else str(extracted)
        if isinstance(content, bytes):
            content = content.decode("utf-8", errors="replace")
        content = content.strip()
        if not content:
            return f"No readable content extracted from {safe_url}."
        suffix = "\n\n[… truncated …]" if len(content) > max_chars else ""
        return f"Content of {safe_url}:\n\n{content[:max_chars].rstrip()}{suffix}"

    @server.tool()
    def current_date(timezone: str = "UTC") -> str:
        """Return today's date in an IANA timezone for relative-date questions."""
        try:
            now = datetime.now(ZoneInfo(timezone))
        except ZoneInfoNotFoundError:
            return f"Unknown timezone: {timezone!r}"
        return f"{now:%Y-%m-%d (%A)}"

    @server.tool()
    def list_sources() -> list[str]:
        """List local profile sources without building the vector index."""
        return [path.relative_to(DOCUMENTS_ROOT).as_posix() for path in selected_paths]

    return server

web_rag_server = make_web_rag_server()
print("Fresh server created; no model or web calls made.")
```
## 5. Discover tools through MCP — **offline**
The direct protocol demonstration lists all tools and safely calls only the date and source tools. Jupyter top-level `await` keeps the client/server exchange concise.
```python
from mcp import ClientSession
from mcp.client._memory import InMemoryTransport

def tool_result_text(result: Any) -> str:
    return "\n".join(getattr(block, "text", str(block)) for block in result.content).strip()

async with InMemoryTransport(web_rag_server, raise_exceptions=True) as (read, write):
    async with ClientSession(read, write) as session:
        await session.initialize()
        tools = await session.list_tools()
        print("Advertised:", [tool.name for tool in tools.tools])
        date_result = await session.call_tool("current_date", {"timezone": "Europe/Bucharest"})
        source_result = await session.call_tool("list_sources", {})
        print("Date:", tool_result_text(date_result))
        print("Sources:", tool_result_text(source_result))
```
## 6. Optional direct web exploration — **requires internet**
Enable `RUN_WEB_DEMO` to search. To demonstrate full-page extraction, copy a public HTTP(S) result URL into `WEB_PAGE_URL`; the fetch tool will validate it first. LM Studio is not used in this cell.
```python
WEB_QUERY = "latest official MCP specification news"
WEB_PAGE_URL = ""  # paste a public URL returned by search_web

if RUN_WEB_DEMO:
    direct_web_server = make_web_rag_server()
    async with InMemoryTransport(direct_web_server, raise_exceptions=True) as (read, write):
        async with ClientSession(read, write) as session:
            await session.initialize()
            search_result = await session.call_tool("search_web", {"query": WEB_QUERY, "k": 3})
            print(tool_result_text(search_result))
            if WEB_PAGE_URL:
                page_result = await session.call_tool("fetch_page", {"url": WEB_PAGE_URL})
                print("\nFetched page:\n", tool_result_text(page_result)[:2000])
else:
    print("Skipped live web calls. Set RUN_WEB_DEMO=True to enable them.")
```
## 7. Optional local/web agent — **requires LM Studio; may require internet**
The policy routes stable demo facts to local RAG and current facts to the web. It asks for the date before relative-date searches, fetches promising pages when snippets are insufficient, and requires filename or URL citations.
```python
import json

def openai_tool_schemas(mcp_tools: Any) -> list[dict]:
    return [{
        "type": "function",
        "function": {
            "name": tool.name, "description": tool.description or "",
            "parameters": tool.inputSchema or {"type": "object"},
        },
    } for tool in mcp_tools.tools]

QUESTION = (
    "What is ONIA according to the local corpus, and what is the latest news on its official site?"
    if PROFILE == "onia"
    else "What is DevTalks according to the local corpus, and what is the latest news on its official site?"
)

if RUN_AGENTIC_DEMO:
    llm = OpenAI(base_url=OPENAI_BASE_URL, api_key=OPENAI_API_KEY)
    agent_server = make_web_rag_server()
    async with InMemoryTransport(agent_server, raise_exceptions=True) as (read, write):
        async with ClientSession(read, write) as session:
            await session.initialize()
            schemas = openai_tool_schemas(await session.list_tools())
            messages = [
                {"role": "system", "content": (
                    "Use search_knowledge for stable facts about this demo and its local profile. "
                    "Use search_web for current information; call current_date first for relative dates. "
                    "Web results are snippets, so call fetch_page on a promising URL when needed. "
                    "Answer only from retrieved material. Cite local facts by filename and web facts by URL; "
                    "if evidence is missing, say so."
                )},
                {"role": "user", "content": QUESTION},
            ]
            for step in range(8):
                response = llm.chat.completions.create(
                    model=CHAT_MODEL, messages=messages, tools=schemas,
                    tool_choice="auto", temperature=0.2,
                )
                message = response.choices[0].message
                calls = message.tool_calls or []
                if not calls:
                    print(message.content or "")
                    break
                messages.append({"role": "assistant", "content": message.content or "",
                                 "tool_calls": [call.model_dump() for call in calls]})
                for call in calls:
                    arguments = json.loads(call.function.arguments or "{}")
                    result = await session.call_tool(call.function.name, arguments)
                    text = tool_result_text(result)
                    print(f"tool: {call.function.name}({arguments}) -> {text[:180]}…")
                    messages.append({"role": "tool", "tool_call_id": call.id, "content": text})
            else:
                print("Stopped after eight tool-selection steps.")
else:
    print("Skipped agent. Set RUN_AGENTIC_DEMO=True to enable model/tool calls.")
```