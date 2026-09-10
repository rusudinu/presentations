# Authoring rules for lecture and lab decks

Every deck under `src/admd/` and `src/mec/` is written against these rules. Each deck lives in its own folder, `src/<course>/lectures/lectureNN/lectureNN.tex` or `src/<course>/labs/labNN/labNN.tex`, so its build files stay next to it. Students never look there: `make` in `src/<course>/` publishes the PDFs to `<course>/` at the top of the repository. Read this file fully before
writing a slide. The macro reference is in `README.md` in this folder; the two decks in
`examples/` show every building block in use.

## 1. Voice and language

- Simple, direct, professional English. Short sentences. One idea per sentence.
- Explain like a good engineer explains to a colleague. No slogans, no jokes, no rhetorical
  questions, no "let's dive in", no exclamation marks.
- **No em-dashes anywhere** (not in slides, code comments, or speaker notes). Use a colon for an
  explanation, a period to split two sentences, commas for an aside. En-dashes only inside numeric
  ranges such as `8–16 GB`.
- American English in prose (color, behavior, optimize). Identifiers and commands keep their real
  spelling.
- Expand an acronym the first time it appears in a deck.
- Say only what you are confident is true in 2026. Prefer stable API and package names. Do not
  quote version numbers, benchmark figures, or dates unless the source material or
  `template/FACTS.md` gives them. When you must estimate,
  say "roughly" and keep the number round.
- Do not invent product features, package APIs, or command-line flags. If a code snippet cannot
  be verified from the sources, keep it minimal and generic.

## 2. What a lecture deck contains

A lecture is two hours. Target **30 to 38 slides** counting title, dividers, recap and closing.

1. `\titleframe`
2. `\objectivesframe{...}` with exactly four `\cell`s: what the student can do after the lecture.
3. Three to five sections, each opened with `\divider{Part N · Name}{One-line title}[Optional subtitle]`.
4. Content slides. Every content slide has an `eyebrow=` that names its section.
5. A recap slide (`eyebrow=Recap`) with three numbered points, then a further-reading slide or block
   with two to four links.
6. `\closingframe{...}{...}`.

Every content slide has a speaker note: `\note{...}` with two to four sentences that say what to
say out loud, what to ask the room, or which pitfall to point at. Notes follow the same language
rules.

## 3. What a lab deck contains

A lab is two hours, every second week. Target **12 to 18 slides**.

1. `\titleframe`
2. "What this lab is for" (`eyebrow=Today`): a two-cell `grid` with the two skills practiced, then
   `\taskmeta{Time}{2 hours}{Submit}{...}`.
3. Setup: where the code goes, the branch name, packages to add, the command to run first.
4. Tasks (`eyebrow=Task I`, `Task II`, ...): `steps` with one requirement per step, on the right a
   `checklist` under `\kv{Done when}{}` with two to four acceptance criteria that a grader can check.
5. Reference slides where needed: the one code shape the task needs, with a `hint` that names the
   intended widget or package.
6. Troubleshooting (`eyebrow=Troubleshooting`): three to five `\trouble{error}{fix}` rows with the
   exact error text students will see.
7. `\closingframe{...}{...}` that restates what to push and where.

Labs are graded from the student's repository. One submission channel, stated on the meta row and
on the closing slide: a branch named `lab-N` in the student's course repository, pushed before the
next lab.

## 4. Fitting the slide

The slide is 160 × 90 mm. The theme leaves roughly 60 mm of height under the title block.

- Title: at most 55 characters, so it fits on one line. Sentence case. No trailing period.
- Eyebrow: one to three words.
- Body text: at most about 90 words per slide. Prefer a `grid`, a table, or two `columns` over a
  wall of text.
- Code blocks: at most 14 lines. Full-width lines at most 78 characters; inside a
  `0.55\textwidth` column at most 42 characters. Cut comments before cutting code.
- A slide with a code block and a takeaway fits only when the block is at most 9 lines.
- Use `\begin{takeaway}{Bold lead.} explanation \end{takeaway}` on the slides that carry a rule
  worth remembering. Not on every slide.
- Tables: five to seven rows, at most five columns, wrapped in `{\usebeamerfont{small} ... }`
  when they have more than four columns. Use `p{...}` for a long last column.
- Body copy has no bullet glyphs by design. `itemize` items render as spaced paragraphs. Use
  `enumerate` only for ordered steps.

## 5. LaTeX rules

- The preamble is fixed. Copy it from `examples/lecture-example.tex` or `examples/lab-example.tex`
  and change only the metadata:
  ```latex
  \documentclass[10pt,aspectratio=169,t]{beamer}
  \usetheme{upbminimal}            % \usetheme[lab]{upbminimal} for labs
  \course{...} \decklabel{Lecture N} \title{...} \subtitle{...}
  \author{Dinu-Ștefan Rusu} \institute{FILS, Universitatea Politehnica București} \date{...}
  ```
- A frame that contains any code environment (`dart`, `kotlin`, `golang`, `shell`, `yaml`,
  `codeblock`) must be declared `[fragile]`.
- In normal text and inside `\code{...}`, escape `_ & % # $ { }` as `\_ \& \% \# \$ \{ \}`.
  Inside code environments nothing is escaped.
- `\code{...}` cannot break across lines. Keep it under about 30 characters; put longer commands
  in a `shell` block.
- Use `[embedded]` on frames about microcontrollers, sensors, BLE, MQTT and other device-side
  topics. Nowhere else.
- Do not load extra packages, change fonts, colors, margins, or use `\vspace` with a negative
  value. `\vskip 2mm` between blocks is fine.
- Icons come from `fontawesome5`: `\faBug`, `\faLayerGroup`, `\faToggleOn`, `\faIcon{share-alt}`,
  `\faCode`, `\faDatabase`, `\faWifi`, `\faBluetooth` (brand icon, use `\faBluetoothB`),
  `\faMicrochip`, `\faBolt`, `\faLock`, `\faCloud`, `\faMobile`, `\faServer`, `\faClock`,
  `\faBatteryHalf`, `\faSatelliteDish`. If a name fails to compile, pick another.

## 6. Quality gate

Run, from anywhere:

```bash
python3 /Users/dinu/dev/upb/presentations/template/qa.py src/<course>/lectures/lectureNN/lectureNN.tex
```

It compiles the deck, reports every problem, and writes `preview/<deck>-sheetN.png` next to the
deck. Commit only the `.tex`; the PDF under `admd/` or `mec/` is rebuilt and committed by the GitHub
workflow after the push. A deck is done only when qa.py prints `RESULT CLEAN` **and** every contact sheet has been
looked at and shows no title wrapped to two lines, no text touching the footer, no code wrapping
mid-statement, and no slide with an empty half. Fix, re-run, look again.
