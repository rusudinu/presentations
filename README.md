# Mobile courses at FILS: slides, labs, and code

Teaching material for two university courses on building software for phones and small devices,
taught at the Faculty of Engineering in Foreign Languages (FILS), Politehnica University of Bucharest,
by Dinu-Ștefan Rusu. Everything here is free to read and reuse for learning.

| Course | When | What you learn |
|---|---|---|
| **Application Development for Mobile Devices** (ADMD) | year III, semester I | How to build a real app with Flutter and Dart: widgets, state management with BLoC, networking, Firebase, authentication, routing, AI features, testing, and shipping to the stores |
| **Mobile and Embedded Computing** (MEC) | year III, semester II | What runs under and around the app: runtimes and concurrency, microcontrollers with TinyGo, MQTT and Bluetooth Low Energy, sensors, background execution and battery, offline-first sync, gRPC, native code, and rendering performance |

ADMD comes first; MEC builds on it and its team project extends the app built in the ADMD labs.

## If you are a student

- **Slides:** open [`admd/`](admd/) or [`mec/`](mec/). Each folder has a README that lists every lecture
  and lab with its title, and the PDFs are named by number (`ADMD-Lecture-05.pdf`, `MEC-Lab-03.pdf`).
- **Code examples:** [`admd/examples/`](admd/examples/) is a Flutter project with one folder per lecture;
  [`mec/examples/`](mec/examples/) holds the concurrency demos. The Go servers and TinyGo programs used
  in the MEC labs are printed in full on the lab slides.
- **Labs** are graded from your own GitHub repository, one branch per lab. The rules are in Lab 1 of each course.
- Questions go to the Microsoft Teams channel of the course.

## If you found this from a talk or want to reuse it

The decks on AI in the app (ADMD Lectures 12 and 13) grow out of conference talks on RAG, MCP and
tool calling; the notebooks and demos behind those talks are in [`demos/`](demos/).

The slides are plain LaTeX on a small Beamer theme that you are welcome to take:
[`template/`](template/) has the theme, an authoring guide, two example decks, and a QA script that
compiles a deck and flags text that runs off the slide. Sources for every deck are under
[`src/`](src/), one folder per deck.

```bash
cd src/admd && make          # builds every ADMD deck and publishes the PDFs to admd/
python3 template/qa.py src/mec/lectures/lecture05/lecture05.tex   # check one deck
```

## Layout

```
admd/            student-facing: ADMD PDFs, index, and the Flutter example project
mec/             student-facing: MEC PDFs, index, and the concurrency demos
src/admd/        LaTeX sources, one folder per deck, plus the course brief (README.md) and Makefile
src/mec/         same for MEC, plus the exam template
src/reference/   reading material the decks were written from
template/        Beamer theme, AUTHORING.md, FACTS.md (verified technical facts), qa.py, index.py, examples
demos/           notebooks and notes from the RAG and MCP conference talks
```

## Contributing

Found an error on a slide or in an example? Open an issue or a pull request. Slides follow the rules
in `template/AUTHORING.md`: simple, direct language, no version numbers unless verified, and every
lecture slide has a speaker note.

Licensed for teaching and learning. If you reuse the slides, keep the attribution.
