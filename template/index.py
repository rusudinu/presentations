#!/usr/bin/env python3
"""Write the student-facing index (README.md) of a course's published PDFs.

    python3 template/index.py <course src dir> <pdf out dir> <PREFIX>

Reads \\title{}, \\subtitle{} and \\date{} from lectures/*/*.tex and labs/*/*.tex and lists
each deck with its published file name.
"""
import glob, os, re, sys


def meta(tex):
    s = open(tex, encoding="utf-8").read()
    def g(k):
        m = re.search(r"\\" + k + r"\{(.*)\}", s)
        return re.sub(r"\\[&_%#]", lambda x: x.group(0)[1:], m.group(1)).strip() if m else ""
    return g("title"), g("subtitle"), g("date"), g("course")


def main():
    src, out, prefix = sys.argv[1:4]
    lines = []
    course = ""
    for kind, label in (("lectures", "Lecture"), ("labs", "Lab")):
        rows = []
        for tex in sorted(glob.glob(os.path.join(src, kind, "*", "*.tex"))):
            n = re.search(r"(\d+)\.tex$", tex).group(1)
            title, subtitle, date, course = meta(tex)
            fname = f"{prefix}-{label}-{n}.pdf"
            when = f" ({date})" if kind == "labs" and date else ""
            rows.append(f"| {label} {n} | [{title}]({fname}) | {subtitle}{when} |")
        if rows:
            lines += [f"## {label}s", "", "| | Deck | About |", "|---|---|---|"] + rows + [""]
    text = f"# {course}\n\nSlides for every lecture and lab. Open the PDF; the file name is the deck number.\n\n" + "\n".join(lines)
    os.makedirs(out, exist_ok=True)
    open(os.path.join(out, "README.md"), "w", encoding="utf-8").write(text)
    print(f"index: {out}/README.md")


if __name__ == "__main__":
    main()
