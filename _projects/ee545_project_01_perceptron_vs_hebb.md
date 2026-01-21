---
layout: page
title: "EE-545 Project 01 — Perceptron vs Hebb (E vs F)"
description: "Binary classification of 5×5 letter glyphs under missing & mistaken pixel noise (Hebbian learning vs perceptron)."
date: 2025-10-24
img: /assets/img/ee545/project-01/teaser.png
importance: 1
category: coursework
tags: [EE-545, neural-networks, perceptron, hebbian-learning, robustness, monte-carlo]
---

## Overview

**Course:** EE-545 — Neural Networks / Deep Learning  
**Project:** 01 (dated 2025-10-24)  
**Task:** Train a **Hebb network** and a **Perceptron** to recognize the 5×5 letter **E** (positive class) vs **F** (negative class), then quantify robustness under two noise models:

- **Missing pixels:** randomly flip *active* pixels (+1) to inactive (-1)
- **Mistaken pixels:** randomly flip arbitrary pixels (+1 ↔ -1), including a worst-case setting where flips are forced to hit the *discriminative* pixels (where E and F differ)

The key takeaway is that—with only two prototypes—both learning rules converge to the same sparse separator that depends only on the pixels where **E and F differ** (6 total). That structure explains the robustness trends seen below.

---

## Problem setup

Each glyph is encoded with the bipolar mapping:

- `# → +1`
- `. → -1`

Then the 5×5 matrix is **flattened in row-major order** to form a 25‑D vector \(\mathbf{x} \in \{-1,+1\}^{25}\).  
We assign labels:

- \(y=+1\) for **E**
- \(y=-1\) for **F** (i.e., “not E”)

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee545/project-01/glyphs_E_F_diff.png" title="Project 01 glyphs and discriminative pixels" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  5×5 prototypes for E and F (bipolar encoding) plus the <em>discriminative pixel mask</em> (locations where E ≠ F).
</div>

---

## Learning rules

### Hebbian classifier (supervised Hebb rule)

Using bipolar targets \(y\in\{-1,+1\}\), the (supervised) Hebb update for sample \(i\) is:

\[
\mathbf{w} \leftarrow \mathbf{w} + y^{(i)}\mathbf{x}^{(i)}, \qquad
b \leftarrow b + y^{(i)}.
\]

Prediction uses a sign activation with a tie-break toward \(+1\):

\[
\hat{y} = \operatorname{sign}(\mathbf{w}^\top\mathbf{x}+b), \quad
\hat{y}=+1 \text{ if the margin is } 0.
\]

### Perceptron (MATLAB Deep Learning Toolbox)

A single-layer perceptron is trained on the same inputs. Targets are mapped to \(\{0,1\}\) for the toolbox and then mapped back to \(\{-1,+1\}\) for evaluation. Training is run with a fixed learning rate and deterministic RNG seeding.

---

## A useful analytic shortcut (why both methods look similar)

With only two training prototypes \(\mathbf{x}_E\) and \(\mathbf{x}_F\), the Hebb solution becomes:

\[
\mathbf{w} = \mathbf{x}_E - \mathbf{x}_F, \qquad b = (+1) + (-1) = 0.
\]

In this dataset, **all 6 differing pixels are +1 in E and −1 in F**, so \(\mathbf{w}\) is sparse: it is nonzero *only* on those 6 locations.

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee545/project-01/weights_hebb_vs_perceptron.png" title="Hebb vs perceptron weight maps" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  Learned weights reshaped back to 5×5. Nonzero weights land only on the 6 discriminative pixels (E ≠ F), which explains much of the robustness behavior.
</div>

Because the decision depends only on those 6 pixels, flipping *any other pixel* has no effect on the classification score \(\mathbf{w}^\top\mathbf{x}\).

---

## Robustness experiments

### 1) Missing pixels (+1 → −1 only)

For each \(k\), we randomly select \(k\) active pixels (value +1) and flip them to −1, then measure accuracy over many trials.

- Pattern **E** has 16 active pixels, so \(k\in[0,16]\)
- Pattern **F** has 10 active pixels, so \(k\in[0,10]\)

### 2) Mistaken pixels (+1 ↔ −1)

For each \(k\), we randomly flip \(k\) pixels anywhere in the 5×5 grid.  
We report two settings:

- **Any-pixel mistakes:** flips can land anywhere
- **Differing-only mistakes (worst-case):** flips are forced to hit *only* discriminative pixels

### Statistics

Monte Carlo sweeps were run with:

- **Missing pixels:** 4000 trials per \(k\) per pattern
- **Mistakes:** 6000 trials per \(k\) per pattern

Uncertainty is summarized with **Wilson score confidence intervals** (95%).

---

## Results

### Missing pixels

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee545/project-01/missing_pixels_accuracy_comparison.png" title="Missing pixels accuracy comparison" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  Accuracy vs. number of missing pixels <em>k</em> (with 95% Wilson intervals). Pattern F remains perfectly classified because missing-pixel flips cannot hit the discriminative set (those pixels are −1 in F).
</div>

**Threshold summary (strict = always correct; prob = 95% Wilson lower bound ≥ 0.95):**

| Pattern | Hebb k_strict | Hebb k_prob95 | Perceptron k_strict | Perceptron k_prob95 |
|---|---:|---:|---:|---:|
| E (+1) | 3 | 5 | 3 | 5 |
| F (−1) | 10 | 10 | 10 | 10 |

### Mistaken pixels (any location)

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee545/project-01/mistake_any_accuracy_comparison.png" title="Mistaken pixels (any location) accuracy comparison" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  Accuracy vs. number of mistaken pixels <em>k</em> when flips can land anywhere. Performance degrades primarily when flips hit the discriminative pixels.
</div>

A more detailed view (for the perceptron) shows that **conditional accuracy is 1.0 whenever no discriminative pixel is touched**:

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee545/project-01/mistake_any_conditional_perceptron.png" title="Conditional accuracy given discriminative-pixel hits" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  Overall accuracy vs. conditional accuracy. Since learned weights are nonzero only on discriminative pixels, flips outside that set do not change the decision.
</div>

**Threshold summary (prob = 95% Wilson lower bound ≥ 0.80):**

| Scenario | Hebb k_strict | Hebb k_prob80 | Perceptron k_strict | Perceptron k_prob80 |
|---|---:|---:|---:|---:|
| Any-pixel mistakes (E) | 3 | 10 | 3 | 10 |
| Any-pixel mistakes (F) | 2 | 6 | 2 | 7 |

### Mistaken pixels (forced to discriminative locations)

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee545/project-01/mistake_differing_accuracy_comparison.png" title="Mistaken pixels (discriminative pixels only) accuracy comparison" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  Worst-case perturbations: when every mistake hits a discriminative pixel, accuracy collapses immediately after the strict bound (E tolerates ≤3; F tolerates ≤2).
</div>

---

## Key takeaways

- **Both models memorize the prototypes** and (in this dataset) converge to the **same sparse decision rule**: only 6 pixels matter.
- **Pattern F is perfectly robust to “missing pixels”** because that noise model only flips +1→−1, and the discriminative pixels in F are already −1.
- Most degradation under “mistaken pixels” is explained by the probability of flipping at least one discriminative pixel.

---

## Reproducibility notes

The original implementation and artifacts for this project were produced via scripted runs (deterministic RNG seeding), with outputs exported to CSV and plotted automatically. If you are publishing the accompanying code repository, the following files are typical entry points:

- `EE545_Project_01_Hebb.m` — Hebb training + robustness sweeps
- `EE545_Project_01_Perceptron.m` — Perceptron training + robustness sweeps
- `+ee545proj01/runAnalysis.m` — shared experiment driver (missing/mistake Monte Carlo)

