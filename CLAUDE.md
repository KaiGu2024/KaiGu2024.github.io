# Personal Academic Website — CLAUDE.md

## Project Overview
Personal academic website for Kai Gu (PhD student in Marketing, Bocconi University).
Hosted on GitHub Pages at `kaigu.github.io`.

## Directory Structure
```
website/
├── CLAUDE.md           # This file
├── code/
│   └── cv.tex          # LaTeX CV source
├── output/             # LaTeX build artifacts (do not edit manually)
│   ├── cv.pdf
│   └── cv.{aux,log,out,synctex.gz}
└── docs/               # GitHub Pages root (the website)
    ├── index.html
    ├── css/style.css
    ├── js/main.js
    └── assets/
        ├── cv.pdf      # Copied from output/cv.pdf after recompile
        └── photo.jpg   # Profile photo (add when available)
```

## Compiling the CV

pdflatex has a PATH conflict with Anaconda. Always compile with a clean PATH:

```bash
MIKTEX="/c/Users/Lenovo/AppData/Local/Programs/MiKTeX/miktex/bin/x64"
WORK="E:/OneDrive - Università Commerciale Luigi Bocconi/personal materials/website"
PATH="$MIKTEX:/c/Windows/System32" "$MIKTEX/pdflatex.exe" \
  -output-directory="$WORK/output" "$WORK/code/cv.tex"
```

After recompiling, sync the PDF to the website:
```bash
cp output/cv.pdf docs/assets/cv.pdf
```

## Website

Single-page HTML/CSS/JS site. No build step — edit `docs/` files directly.

- **About section:** bio + photo + contact links (email, LinkedIn, CV)
- **Research section:** working papers with collapsible abstracts
- **CV section:** download button + embedded PDF iframe

### Adding a profile photo
1. Place `photo.jpg` in `docs/assets/`
2. In `docs/index.html`, remove the `<div class="photo-placeholder">KG</div>` line
3. Uncomment the `<img src="assets/photo.jpg" ...>` line below it

### Updating LinkedIn URL
In `docs/index.html`, replace `YOUR-LINKEDIN-HANDLE` with your actual LinkedIn profile handle.

### Adding a new paper
Copy an existing `.paper` div block in `docs/index.html` and update the title, authors, abstract, tags, and venue.

## GitHub Pages Setup
- Publishing source: `docs/` folder on `main` branch
- Settings → Pages → Source: Deploy from branch → `main` / `docs`

## VS Code LaTeX Preview
LaTeX Workshop is configured in VS Code settings to use MiKTeX pdflatex directly
(bypassing the latexmk default and the Anaconda PATH issue).
Output directory is set to `output/`.
