# Course presentations

Lecture and lab decks for the two mobile courses at FILS, built from one shared LaTeX template.

```
template/                     the Beamer theme, authoring rules, QA script, and two examples
admd/                         Application Development for Mobile Devices (year III, semester I)
  README.md                   course brief: facts, grading, one section per lecture and lab
  lectures/lecture01..14.tex  14 lectures, 2 h each
  labs/lab01..07.tex          7 labs, 2 h every second week
mec/                          Mobile and Embedded Computing (year III, semester II)
  README.md                   course brief, including the team project
  lectures/lecture01..14.tex  14 lectures
  labs/lab01..07.tex          7 labs
mobile-and-embedded-computing/  the previous course material (pptx generators, FACTS.md, Flutter examples)
```

## Building

Every course folder has a Makefile that points at `template/`:

```bash
cd admd/lectures && make        # every deck in the folder
cd mec/labs && make lab03.pdf   # one deck
```

To check a deck the way the authoring rules require (compile, lint, contact sheet):

```bash
python3 template/qa.py mec/lectures/lecture05.tex
```

## Writing a new deck

Read `template/AUTHORING.md` first, then copy the preamble from `template/examples/lecture-example.tex`
or `lab-example.tex`. The macro reference is `template/README.md`. Slides are written in simple,
professional English, without em-dashes, and every lecture slide carries a speaker note.

## Order of the courses

ADMD runs first and teaches how to build the app: Dart, widgets, state management with BLoC,
networking, Firebase, authentication, routing, AI in the app, testing, and release. MEC runs the
following semester and teaches what runs under and around the app: runtimes and concurrency,
embedded programming with TinyGo, MQTT and BLE, sensors, background execution, offline-first sync
and CRDTs, backends and gRPC, platform channels and FFI, rendering cost, and energy. The MEC team
project extends the app built in the ADMD labs.
