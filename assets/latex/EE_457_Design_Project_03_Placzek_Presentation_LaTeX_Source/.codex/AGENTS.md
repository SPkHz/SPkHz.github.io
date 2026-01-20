# Agent Instructions (mirror)
This file mirrors the active agent guidance for the repo. The canonical source is `../AGENTS.md`; read that first. Session prompt context lives in `../CONTEXT-3_33_AM-PROMPT.md`.

## Quick rules
- Always use Context7 for code generation, setup/config steps, or library/API docs; automatically resolve library IDs and fetch docs without being asked.
- Always use Exa when searching for solutions to code/LaTeX issues.
- Ask before making big LaTeX document changes.
- Do not add new skills; only sync existing ones if needed.

## Repository notes
- Main Beamer file: `../ee457_design_project_03_presentation.tex` (single source of truth).
- Images live in `../img/`; WNE reference assets are in `../WNE_LaTeX_Logos_Templates/` (do not modify originals).
- Default build: `xelatex -interaction=nonstopmode ee457_design_project_03_presentation.tex` (run twice after structural changes).
- Use 4-space indentation in LaTeX, semantic Beamer constructs, and keep section/subsection short titles for compact navigation.
- HFSS plots: one per slide, `\vspace*{-0.5cm}` + `\includegraphics[width=0.85\textwidth,keepaspectratio,clip,trim=0cm 0.25cm 0cm 3.1cm]{<image>}` with the plot title moved into the caption (include beam-widths when relevant).
- Final design plots belong in the Final Design Parameters section; appendices hold HFSS sweeps and MATLAB code.

## Git workflow reminder
Run `git fetch origin && git fetch origin --all --tags --prune` before edits; if behind, `git pull --ff-only origin main` before changing files.
