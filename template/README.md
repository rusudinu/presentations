# LaTeX slide template for the mobile courses

A minimal, keynote-style Beamer theme for **Application Development for Mobile Devices** and
**Mobile and Embedded Computing**. It mirrors the design system of the existing pptx generator
(`slides/assets/template.js` in the old course, now removed): Helvetica Neue and Menlo, near-monochrome
ink/gray/hairline palette, blue as the single accent, orange reserved for embedded topics, black
title, divider and closing slides, no bullet glyphs, an eyebrow label and one-line title on every slide.

```
latex-template/
  beamerthemeupbminimal.sty   the theme (fonts, colors, layouts, code, lab tools)
  examples/lecture-example.tex   a lecture deck that uses every building block
  examples/lab-example.tex       a lab handout that uses the lab tools
  Makefile                    make · make preview · make clean
  qa.py                       compile + checks + contact sheet for one deck
  AUTHORING.md                the rules every deck follows
```

## Build

Requires TeX Live (2024 or newer) and XeLaTeX or LuaLaTeX. pdflatex also works, with Helvetica and
Bera Mono substituted.

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

Fonts come from TeX Live itself: TeX Gyre Heros (a Helvetica clone) for text and DejaVu Sans Mono
(what Menlo is based on) for code. Nothing depends on the operating system, so a deck builds to the
same bytes on a Mac and on the GitHub runner. The Makefiles also pin the PDF timestamp to the commit
time of the deck folder, which is what lets the CI skip a commit when nothing changed.

## Starting a deck

```latex
\documentclass[10pt,aspectratio=169,t]{beamer}
\usetheme{upbminimal}            % or \usetheme[lab]{upbminimal}
\course{Mobile and Embedded Computing}
\decklabel{Lecture 3}            % footer and corner label; "Lab 2" for labs
\title{Embedded fundamentals}
\subtitle{MCUs, bare metal vs RTOS, and TinyGo}
\author{Dinu-Ștefan Rusu}
\institute{FILS, Universitatea Politehnica București}
\date{Spring 2027}
\begin{document}
\titleframe
...
\closingframe{Questions?}{dinu\_stefan.rusu@upb.ro}
\end{document}
```

Theme options: `lab` (footer and tools for handouts), `noprogress` (hide the progress line at the
bottom edge).

## Building blocks

| Block | Use |
|---|---|
| `\titleframe` | Black title slide from `\title`, `\subtitle`, `\author`, `\institute`, `\date`. |
| `\divider{Eyebrow}{Title}[Subtitle]` | Black section slide. Also creates a PDF bookmark. |
| `\closingframe{Title}{gray line}` | Black closing slide. |
| `\begin{frame}[eyebrow=Debugging]{Title}` | Content slide. The eyebrow is the letterspaced label above the title. |
| `\begin{frame}[embedded,eyebrow=Embedded]{...}` | Same, with the orange accent for that slide only. |
| `\objectivesframe{\cell[icon]{Title}{text} ...}` | The "what you should leave with" slide, four cells. |
| `\begin{grid}[3] \cell[\faBug]{Title}{text} ... \end{grid}` | Icon grid, 2 or 3 columns. Icons come from `fontawesome5` (`\faBug`, `\faIcon{share-alt}`). |
| `\bignum{16.7 ms}{per frame at 60 Hz}` | A large accent number with a caption, inside a `grid`. |
| `\begin{takeaway}{Bold lead.} gray explanation \end{takeaway}` | One takeaway, pinned to the bottom of the slide. |
| `\lead{Bold line}{gray line}` · `\muted{...}` · `\kv{label}{value}` | Small text primitives. |
| `\code{inline}` | Inline code on the panel color. |
| `\begin{dart} ... \end{dart}` | Code block. Also `kotlin`, `golang`, `shell`, `yaml`, and `codeblock[language=...]`. The frame must be `[fragile]`. Highlight a line with `(*@\hl{...}@*)`. |
| `\begin{hint}[Label] ... \end{hint}` · `\begin{warning}` | Panel boxes with an icon. |
| `\thead{Header}` inside a `tabular` with `booktabs` rules | Table header in the eyebrow style. Hairlines are pre-colored. |
| `\begin{columns}[T] \begin{column}{0.55\textwidth} ...` | Two columns, plain beamer. |
| `\link{url}{text}` | Blue link. |

Lab tools (any deck, but meant for `[lab]`):

| Block | Use |
|---|---|
| `\taskmeta{Time}{2 hours}{Submit}{branch lab-3}` | Two label/value pairs in one row. |
| `\begin{steps} \item ... \end{steps}` | Numbered steps, one requirement per step. |
| `\begin{checklist} \item ... \end{checklist}` | Acceptance criteria with checkbox glyphs. |
| `\trouble{error text}{what to do}` | One row of a troubleshooting table. |

Speaker notes go in `\note{...}` inside a frame. To print them, add
`\setbeameroption{show notes on second screen=right}` in the preamble.

## Writing rules

The house style from `slides/assets/EDITPASS.md` applies: no em-dashes, plain technical prose, one
idea per slide, American English in prose, real spelling inside code. Every slide title must fit on
one line at 17pt. Body copy is unbulleted; use `\begin{enumerate}` only for ordered steps.

## QA before shipping

```bash
make preview
grep -c 'Overfull \\vbox' my-lecture.log     # must print 0: the slide ran into the footer
```

Then look at every PNG for a wrapped title, a takeaway touching the footer, or code that wraps.
The Makefile's `preview` target renders at 60 dpi, which is enough to spot layout faults.
