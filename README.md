# Course presentations

Lecture and lab decks for the two mobile courses at FILS, built from one shared LaTeX template.
Repository: https://github.com/rusudinu/presentations

```
admd/                         what students use: every published ADMD PDF, plus an index
  ADMD-Lecture-01.pdf … ADMD-Lecture-14.pdf, ADMD-Lab-01.pdf … ADMD-Lab-07.pdf, README.md
mec/                          same for MEC: MEC-Lecture-NN.pdf, MEC-Lab-NN.pdf, README.md
src/                          what the instructor edits
  admd/README.md              course brief: facts, grading, one section per lecture and lab
  admd/lectures/lectureNN/    one folder per deck: lectureNN.tex plus its build files
  admd/labs/labNN/            same for labs
  admd/Makefile               make · make qa · make clean
  mec/…                       same layout for Mobile and Embedded Computing
admd/examples/                the Flutter example project, one folder per lecture
mec/examples/                 the concurrency demos for MEC Lecture 2
template/                     the Beamer theme, authoring rules, FACTS.md, QA and index scripts, two examples
src/reference/                reading material the decks were written from
```

## Building and publishing

```bash
cd src/admd && make          # builds every deck and refreshes admd/
cd src/mec && make lectures/lecture05/lecture05.pdf && make publish   # one deck, then publish
```

`make qa` compiles, lints and renders contact sheets for every deck. To check one deck:

```bash
python3 template/qa.py src/mec/lectures/lecture05/lecture05.tex
```

Only the published copies in `admd/` and `mec/` are committed; the PDFs next to the sources are ignored.

## Writing a new deck

Read `template/AUTHORING.md` first, then copy the preamble from `template/examples/lecture-example.tex`
or `lab-example.tex` into a new folder under `src/<course>/lectures/` or `labs/`. The macro reference is
`template/README.md`. Slides are written in simple, professional English, without em-dashes, and every
lecture slide carries a speaker note.

## Order of the courses

ADMD (Application Development for Mobile Devices) runs first and teaches how to build the app: Dart,
widgets, state management with BLoC, networking, Firebase, authentication, routing, AI in the app,
testing, and release. MEC (Mobile and Embedded Computing) runs the following semester and teaches what
runs under and around the app: runtimes and concurrency, embedded programming with TinyGo, MQTT and
BLE, sensors, background execution, offline-first sync and CRDTs, backends and gRPC, platform channels
and FFI, rendering cost, and energy. The MEC team project extends the app built in the ADMD labs.
