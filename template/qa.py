#!/usr/bin/env python3
"""QA one Beamer deck built on the upbminimal theme.

    python3 template/qa.py src/<course>/lectures/lectureNN/lectureNN.tex [--no-render]

Compiles with xelatex (template on TEXINPUTS), then reports:
  * compile errors
  * overfull vertical boxes (content ran into the footer) and wide overfull hboxes
  * em-dashes, stray en-dashes, frames with code but without [fragile], long titles
Renders every page at 60 dpi into preview/ next to the deck, plus contact sheets
preview/<deck>-sheet1.png ... so the pages can be inspected visually.
Exit code 1 when anything must be fixed.
"""
import os, re, subprocess, sys, glob

TEMPLATE = os.path.dirname(os.path.abspath(__file__))
CODE_ENVS = ("dart", "kotlin", "golang", "shell", "yaml", "codeblock")


def main():
    if len(sys.argv) < 2:
        print(__doc__); sys.exit(2)
    tex = os.path.abspath(sys.argv[1]); render = "--no-render" not in sys.argv
    d, base = os.path.dirname(tex), os.path.splitext(os.path.basename(tex))[0]
    problems, warnings = [], []

    # ---------------------------------------------------------------- source
    src = open(tex, encoding="utf-8").read()
    for i, l in enumerate(src.split("\n"), 1):
        body = "" if l.lstrip().startswith("%") else l.split("%")[0]
        if "\u2014" in body:
            problems.append(f"line {i}: em-dash. Use a colon, a period or a comma.")
        for m in re.finditer("\u2013", body):
            a = body[max(0, m.start() - 1):m.start()]; b = body[m.end():m.end() + 1]
            if not (a.isdigit() and b.isdigit()):
                warnings.append(f"line {i}: en-dash outside a numeric range.")
        if re.search(r"\w -- \w", body):
            warnings.append(f"line {i}: '--' used as a dash.")
    is_lab = "[lab]" in src
    body_only = re.sub(r"\\begin\{(dart|kotlin|golang|shell|yaml|codeblock)\}.*?\\end\{\1\}", "", src, flags=re.S)
    for i, l in enumerate(body_only.split("\n"), 1):
        if l.lstrip().startswith("%"): continue
        if re.search(r"\b(Flutter|Dart|Android|iOS|Go|Kotlin|Xcode) \d+(\.\d+)+", l):
            warnings.append(f"version number in prose: '{l.strip()[:70]}'")
        if re.search(r"[A-Za-z]!(\s|$|\})", l):
            warnings.append(f"exclamation mark in prose: '{l.strip()[:70]}'")
        if re.search(r"\b[Ll]et'?s\b|\bdive in\b", l):
            warnings.append(f"chatty phrase: '{l.strip()[:70]}'")
    missing_notes = 0
    for m in re.finditer(r"\\begin\{frame\}(\[[^\]]*\])?(\{([^}]*)\})?(.*?)\\end\{frame\}", src, re.S):
        opts, title, fbody = (m.group(1) or ""), (m.group(3) or ""), m.group(4)
        ln = src[:m.start()].count("\n") + 1
        if any(f"\\begin{{{e}}}" in fbody for e in CODE_ENVS) and "fragile" not in opts:
            problems.append(f"line {ln}: frame has a code block but is not [fragile].")
        plain = re.sub(r"\\[a-zA-Z]+|[{}]", "", title)
        if len(plain) > 58:
            warnings.append(f"line {ln}: title is {len(plain)} chars and will wrap: '{plain}'")
        if title.strip() == "" and "plain" not in opts:
            warnings.append(f"line {ln}: frame without a title.")
        if not is_lab and "\\note{" not in fbody and "plain" not in opts:
            missing_notes += 1
    if missing_notes:
        warnings.append(f"{missing_notes} content frame(s) without a \\note{{}} speaker note.")
    nframes = (len(re.findall(r"\\begin\{frame\}", src)) + src.count("\\titleframe")
               + src.count("\\divider{") + src.count("\\closingframe{") + src.count("\\objectivesframe{"))

    # ---------------------------------------------------------------- compile
    env = dict(os.environ, TEXINPUTS=f"{TEMPLATE}//:" + os.environ.get("TEXINPUTS", ""))
    r = subprocess.run(["latexmk", "-xelatex", "-interaction=nonstopmode", "-halt-on-error", "-cd", tex],
                       env=env, capture_output=True, text=True)
    log_path = os.path.join(d, base + ".log")
    log = open(log_path, encoding="utf-8", errors="replace").read() if os.path.exists(log_path) else ""
    if r.returncode != 0:
        errs = re.findall(r"^!.*(?:\n.*){0,3}", log, re.M)
        problems.append("compile failed:\n" + "\n".join(errs[:5]))
    for m in re.finditer(r"Overfull \\vbox \(([\d.]+)pt too high\) detected at line (\d+)", log):
        problems.append(f"line {m.group(2)}: slide is {float(m.group(1)):.0f}pt too tall and runs into the footer. "
                        "Cut text, shorten code, or split the slide.")
    for m in re.finditer(r"Overfull \\hbox \(([\d.]+)pt too wide\) in paragraph at lines (\d+)--(\d+)", log):
        if float(m.group(1)) > 3:
            problems.append(f"line {m.group(2)}: text or table is {float(m.group(1)):.0f}pt too wide.")

    # ---------------------------------------------------------------- render
    pdf = os.path.join(d, base + ".pdf"); sheets = []; npages = 0
    if render and os.path.exists(pdf) and r.returncode == 0:
        prev = os.path.join(d, "preview"); os.makedirs(prev, exist_ok=True)
        for f in glob.glob(os.path.join(prev, base + "-*.png")):
            os.remove(f)
        subprocess.run(["pdftoppm", "-png", "-r", "60", pdf, os.path.join(prev, base)], check=True)
        pages = sorted(glob.glob(os.path.join(prev, base + "-[0-9]*.png"))); npages = len(pages)
        try:
            from PIL import Image
            cols, per = 4, 16
            for s in range(0, len(pages), per):
                ims = [Image.open(p) for p in pages[s:s + per]]
                w, h = ims[0].size; rows = (len(ims) + cols - 1) // cols
                sheet = Image.new("RGB", (cols * w + (cols + 1) * 8, rows * h + (rows + 1) * 8), (120, 120, 120))
                for i, im in enumerate(ims):
                    sheet.paste(im, (8 + (i % cols) * (w + 8), 8 + (i // cols) * (h + 8)))
                out = os.path.join(prev, f"{base}-sheet{s // per + 1}.png"); sheet.save(out); sheets.append(out)
        except ImportError:
            warnings.append("PIL not available: no contact sheet, look at the page PNGs instead.")

    # ---------------------------------------------------------------- report
    print(f"== {base}: {npages} pages, {nframes} frames in source")
    for p in problems:
        print("PROBLEM ", p)
    for w in warnings:
        print("warning ", w)
    for s in sheets:
        print("sheet   ", s)
    print("RESULT  ", "CLEAN" if not problems else f"{len(problems)} problem(s) to fix")
    sys.exit(1 if problems else 0)


if __name__ == "__main__":
    main()
