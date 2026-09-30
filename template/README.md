# LaTeX slide template for the mobile courses

A Beamer theme for **Application Development for Mobile Devices** and **Mobile and Embedded
Computing**, set like a technical manual. It is written for two readers: the back row of a lecture
hall looking at a projector, and a student reading the PDF next to an IDE.

- A running head with the section name over a strong rule, then the title. No uppercase labels.
- A white cover that ends in a title block, the way an engineering drawing does.
- Chapter openers: the part number large, the part title, and the lecture's contents with page
  numbers (PDF links).
- Booktabs tables, a ruled sign-off form for acceptance criteria, square corners throughout.
- One accent (cobalt `2449B0`), orange `A84300` for embedded topics only, red `C4122F` for
  warnings only. Every text color passes WCAG AA (4.5:1) on white and on the code panel.
- Atkinson Hyperlegible Next for text and Atkinson Hyperlegible Mono for code, drawn by the Braille
  Institute so that similar characters (`Il1`, `O0`) stay distinct for low-vision readers.

```
template/
  beamerthemeupbminimal.sty   the theme (fonts, colors, layouts, code, lab tools)
  examples/lecture-example.tex   a lecture deck that uses every building block
  examples/lab-example.tex       a lab handout that uses the lab tools
  Makefile                    make · make preview · make clean
  qa.py                       compile + checks + contact sheet for one deck
  AUTHORING.md                the rules every deck follows
```

## Build

Requires a TeX Live recent enough to ship Atkinson Hyperlegible Next and Mono (the decks are built with TeX Live 2026) and XeLaTeX or LuaLaTeX.

```bash
make                 # both example PDFs
make preview         # plus one PNG per page in preview/ for a visual QA pass
latexmk -xelatex my-lecture.tex
```

**Who publishes the PDFs.** `make` in `src/<course>/` only builds the decks next to their sources
(ignored by git). The GitHub workflow builds the changed decks in a fixed TeX Live container and
commits the results into `admd/` and `mec/` when the bytes differ, so the committed PDFs always come
from one environment. Do not commit locally built PDFs: two TeX Live snapshots round glyph positions
slightly differently, and the CI would rewrite them anyway.

The fonts come from TeX Live itself. Nothing depends on the operating system, so a deck builds to
the same bytes on a Mac and on the GitHub runner. The Makefiles also pin the PDF timestamp to the
commit time of the deck folder, which is what lets the CI skip a commit when nothing changed.

## Starting a deck

```latex
\documentclass[10pt,aspectratio=169,t]{beamer}
\usetheme{upbminimal}            % or \usetheme[lab]{upbminimal}
\course[MEC]{Mobile and Embedded Computing}   % the short name goes in the cover's title block
\decklabel{Lecture 3}            % cover header and footer; "Lab 2" for labs
\title{Embedded fundamentals}
\subtitle{MCUs, bare metal vs RTOS, and TinyGo}
\author{Dinu-Ștefan Rusu}
% \materials{github.com/owner/repo}   optional: a "Slides and code" field on the cover
% \authorlabel{Speaker}               optional: the cover's author label, "Lecturer" by default
\begin{document}
\titleframe
...
\closingframe{Questions?}{dinu\_stefan.rusu@upb.ro}
\end{document}
```

Theme option: `lab` (the cover leaves out `\date`, which labs keep for the course index).

## Building blocks

| Block | Use |
|---|---|
| `\titleframe` | The cover: course and deck over a rule, title, subtitle, and a title block with lecturer, course (when `\course` has a short name), and optional `\date`, `\institute` and `\materials`. |
| `\divider{Part N · Name}{Title}[Topics]` | Chapter opener: the part number large, the title, the topics, and the lecture's contents with page numbers. Also a PDF bookmark. |
| `\closingframe{Title}{supporting line}` | Closing slide. |
| `\begin{frame}[eyebrow=Debugging]{Title}` | Content slide. The eyebrow is the running head above the rule. |
| `\begin{frame}[embedded,eyebrow=Embedded]{...}` | Same, with the orange accent for that slide only. |
| `\begin{frame}[eyebrow=Task II,time=30 min]{...}` | A lab task with its time budget in the running head. |
| `\objectivesframe{\cell[icon]{Title}{text} ...}` | The "what you should leave with" slide, four cells. |
| `\begin{grid}[3] \cell[\faBug]{Title}{text} ... \end{grid}` | Grid of 2 or 3 columns. The icon sits inline before the title. Icons come from `fontawesome5`. |
| `\bignum{16.7 ms}{per frame at 60 Hz}` | A large accent number with a caption, inside a `grid`. |
| `\begin{takeaway}{Lead.} explanation \end{takeaway}` | One takeaway below a rule, pinned to the bottom of the slide. |
| `\begin{flow}[3] \stage{Title}{text} \edge[label] \stage{...}{...} ... \end{flow}` | A left-to-right pipeline of 2 to 4 stages; `[n]` is the number of stages. |
| `\lead{Semibold line}{supporting line}` · `\muted{...}` · `\kv{label}{value}` | Small text primitives. |
| `\code{inline}` | Inline code on the panel color. |
| `\begin{dart} ... \end{dart}` | Code block. Also `kotlin`, `golang`, `shell`, `yaml`, and `codeblock[language=...]`. The frame must be `[fragile]`. Highlight part of a line with `(*@\hl{...}@*)`. A line too long for the panel wraps with a gray ↪, which `qa.py` reports. |
| `\begin{hint}[Label] ... \end{hint}` · `\begin{warning}` | Square notes with a run-in label; a warning is red. |
| `\thead{Header}` inside a `tabular` with `booktabs` rules | Table header. `\toprule` and `\bottomrule` print in ink, `\midrule` as a hairline. |
| `\begin{columns}[T] \begin{column}{0.55\textwidth} ...` | Two columns, plain beamer. |
| `\link{url}{text}` | Accent-colored link. |

Lab tools (any deck, but meant for `[lab]`):

| Block | Use |
|---|---|
| `\taskmeta{Time}{2 hours}{Submit}{branch lab-3}` | Two label/value pairs in one row. |
| `\begin{steps} \item ... \end{steps}` | Numbered steps, one requirement per step. |
| `\begin{checklist} \item ... \end{checklist}` | Acceptance criteria as a ruled form with checkboxes. |
| `\trouble{error text}{what to do}` | One row of a troubleshooting table. |

Speaker notes go in `\note{...}` inside a frame. To print them, add
`\setbeameroption{show notes on second screen=right}` in the preamble.

## Writing rules

`AUTHORING.md` has the full rules: no em-dashes, plain technical prose, one idea per slide,
American English in prose, real spelling inside code, every slide title on one line.

## QA before shipping

```bash
python3 template/qa.py src/<course>/lectures/lectureNN/lectureNN.tex
```

It compiles the deck and reports slides that run into the footer, code lines that wrap or run
past their panel, em-dashes, long titles and frames with code that are not `[fragile]`. Then look at
every contact sheet it writes for a wrapped title or a slide with an empty half.
