# Rusu Dinu's presentations

Slides, demos and code from my courses, conference talks and trainings.

## Students

- [Application Development for Mobile Devices (ADMD)](admd/)
- [Mobile and Embedded Computing (MEC)](mec/)

Each folder has an index of every lecture and lab, the PDFs, and the code examples.

## Talks

- [AI in mobile apps: on-device ML, LLMs, RAG and MCP](talks/ai-in-mobile-apps/), with the demos
- [GitHub and Flutter](talks/he/)

## Running everything

`make help` at the root of the repository lists every command: `make slides` builds all the decks,
`make setup` prepares every demo folder, and `make doctor` reports which tools this machine has.
Demo commands are forwarded to the folder that owns them, for example `make admd-list`,
`make mec-isolate_example`, `make he-demo-run` or `make ai-lab`. Every demo folder also has its own
Makefile, so `make help` works from inside it too.

## Everything else

The LaTeX sources of the course and talk decks are under `src/`, and the Beamer theme they use is in
`template/`, free to reuse. A GitHub workflow rebuilds the PDFs on every push.
