---
layout: page
title: "EE-545 Project 02: Backpropagation Glyph Classification"
description: "Backpropagation-trained MLP (MATLAB patternnet) for 12×10 glyph classification across letters, fonts, and letter+font pairs; robustness to bit-flip and replacement noise."
img: /assets/img/ee545/project-02/cover.png
importance: 2
category: coursework
related_publications: false
date: 2025-11-17
---

## Overview

This project implements a **multi-layer perceptron (MLP)** trained via **backpropagation** to classify small **binary glyph bitmaps**.  
The dataset consists of **21 total samples** (**7 letters × 3 fonts**), where each glyph is a **12×10** character grid flattened into a **120-dimensional** feature vector.

**Course:** EE-545 – Neural Networks / Deep Learning  
**Project:** 02 (dated **2025-11-17**)  
**Tools:** MATLAB (Deep Learning / Neural Network Toolbox), custom MATLAB utilities for preprocessing + evaluation  
**Focus:** Backprop training + robustness evaluation under controlled input corruption

---

## Dataset

Each glyph is stored as a 12×10 grid of `'#'` / `'.'` characters.  
For training, the grids are converted to a flattened vector:

- `'#' → +1` (ink / foreground)
- `'.' → -1` (background)

This yields a bipolar feature vector **x ∈ {−1,+1}¹²⁰** per glyph.

<div class="row justify-content-sm-center">
  <div class="col-sm-12 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee545/project-02/glyphs_dataset_grid.png" title="Glyph dataset (7 letters × 3 fonts)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
7 letters (A, B, C, D, E, J, K) shown in 3 fonts. Each glyph is a 12×10 binary pattern.
</div>

---

## Classification tasks

The project is organized into three task definitions (matching the typical EE-545 “modes” pattern):

| Task | Objective | # Classes | Output meaning |
|---|---:|---:|---|
| **Task 1** | Letter classification (font-invariant) | 7 | A / B / C / D / E / J / K |
| **Task 2** | Font classification (letter-invariant) | 3 | Font 1 / Font 2 / Font 3 |
| **Task 3** | Joint classification | 21 | (Letter, Font) pair |

---

## Model

All tasks use a standard **feedforward MLP**:

- **Input layer:** 120 features (flattened 12×10 glyph)
- **Hidden layers:** `tansig` nonlinearity  
  - Task 1: `[64, 32]`  
  - Task 2: `[32]`  
  - Task 3: `[64, 32]`
- **Output layer:** `softmax` (task-dependent dimension)

<div class="row justify-content-sm-center">
  <div class="col-sm-10 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee545/project-02/mlp_architecture.png" title="MLP architecture" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
A compact MLP is sufficient because the dataset is small and strongly structured. Output dimensionality depends on the task.
</div>

---

## Backpropagation (what is being optimized)

For a feedforward network with layers \(l = 1,\dots,L\):

\[
\mathbf{z}^{(l)} = \mathbf{W}^{(l)}\mathbf{a}^{(l-1)} + \mathbf{b}^{(l)}, \quad
\mathbf{a}^{(l)} = f\left(\mathbf{z}^{(l)}\right)
\]

Given a loss \(\mathcal{L}(\mathbf{a}^{(L)}, \mathbf{y})\), backpropagation computes error signals:

\[
\boldsymbol{\delta}^{(L)} = \frac{\partial \mathcal{L}}{\partial \mathbf{z}^{(L)}}, \quad
\boldsymbol{\delta}^{(l)} = \left(\mathbf{W}^{(l+1)\top}\boldsymbol{\delta}^{(l+1)}\right) \odot f'\left(\mathbf{z}^{(l)}\right)
\]

and gradients:

\[
\frac{\partial \mathcal{L}}{\partial \mathbf{W}^{(l)}} = \boldsymbol{\delta}^{(l)}\mathbf{a}^{(l-1)\top}, \quad
\frac{\partial \mathcal{L}}{\partial \mathbf{b}^{(l)}} = \boldsymbol{\delta}^{(l)}
\]

In MATLAB, `patternnet(...,'trainscg')` uses **scaled conjugate gradient (SCG)**, which is still driven by backpropagated gradients, but updates weights using a conjugate-gradient style step selection.

---

## Robustness experiments

To evaluate robustness, inputs are corrupted using two synthetic noise models:

1. **Bit-flip noise:** randomly flip \(k\) pixels (`0↔1` or `−1↔+1`)
2. **Replacement noise:** randomly select \(r\) pixels and force them to **ink** (`1` / `'#'`)

<div class="row justify-content-sm-center">
  <div class="col-sm-10 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee545/project-02/noise_models_example.png" title="Noise models" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
Example of corruption models used during robustness testing. Bit-flip noise toggles pixels, while replacement noise only adds ink.
</div>

---

## Results

### Clean classification accuracy

On the clean dataset, all three tasks reached **100% accuracy** on the available glyph set (21/21 correct), reflecting that the classes are separable with a modest MLP.

### Noise robustness

Below are the robustness curves for each task (accuracy as corruption level increases).

#### Task 1 — Letters

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee545/project-02/Task1_FlippedK.png" title="Task 1 bit-flip noise" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee545/project-02/Task1_NoiseReplace.png" title="Task 1 replacement noise" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

Key observation: **Task 1** is the most sensitive to corruption (as expected, since it must ignore font differences and focus on shape).  
Worst-case accuracy observed in these runs was **~95.2%** (20/21 correct) at the highest tested corruption levels.

#### Task 2 — Fonts

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee545/project-02/Task2_FlippedK.png" title="Task 2 bit-flip noise" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee545/project-02/Task2_NoiseReplace.png" title="Task 2 replacement noise" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

Key observation: **Task 2** remained at **100%** across the tested corruption range (0–10 flips / replacements), suggesting the font “style” cues are highly redundant in the 120-pixel representation.

#### Task 3 — Letter + Font

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee545/project-02/Task3_FlippedK.png" title="Task 3 bit-flip noise" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee545/project-02/Task3_NoiseReplace.png" title="Task 3 replacement noise" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

Key observation: **Task 3** also remained at **100%** across the tested corruption range.  
Because each (letter,font) pair is its own class, the network can use both letter identity and font cues jointly.

---

## Implementation notes

- The glyph data is loaded from `glyphs.mat` and converted to 120×21 feature matrices.
- Targets are generated per task (letter-only, font-only, letter+font).
- Training uses `patternnet` with `trainscg` and deterministic seeding (`rng(545)`).

---

## Reproducibility

If you keep the same dataset file names/paths, you can regenerate the plots by running the MATLAB driver script used for the final figures:

- `EE_545_Project_02_Placzek_v2_fixed.m`

This script:
1. Loads and visualizes glyphs,
2. Trains three networks (Tasks 1–3),
3. Runs noise robustness sweeps,
4. Exports plots into `results/plots/`.

---

## Assets for this page

Place the provided images into:

```
assets/img/ee545/project-02/
```

This page expects the following key files (included in the ZIP):
- `cover.png`
- `glyphs_dataset_grid.png`
- `mlp_architecture.png`
- `noise_models_example.png`
- `Task1_*.png`, `Task2_*.png`, `Task3_*.png`
