---
layout: page
title: "EE-545 Project 03 — RF Modulation Classification"
description: "Automatic RF modulation classification (AMC) using a baseline 1‑D CNN in MATLAB on synthetic I/Q frames with realistic channel impairments."
date: 2025-12-03
img: assets/img/ee545/project-03/hero.png
importance: 1
category: coursework
tags: [deep-learning, rf, signal-processing, matlab, classification]
toc:
  beginning: true
---

{% include figure.liquid path="assets/img/ee545/project-03/hero.png" class="img-fluid rounded z-depth-1" alt="EE-545 Project 03 hero image combining confusion matrix and accuracy vs SNR plots." %}

## Overview

This project implements an **automatic RF modulation classification (AMC)** pipeline for **EE-545 — Neural Networks / Deep Learning** (Project 03, **2025-12-03**). The goal is to classify short **complex baseband I/Q frames** into one of eight modulation types using a **lightweight baseline 1‑D CNN** built and evaluated in **MATLAB**.

The full workflow covers:

- **Synthetic waveform generation** for multiple modulations
- **Channel / RF impairments** (noise, fading, offsets, nonlinearity, etc.)
- **Frame-level dataset creation** (2×1024 real-valued input: I and Q)
- **Training and evaluation** (confusion matrix, accuracy-vs-SNR, per-class metrics)
- **Statistical validation** across multiple random seeds

{% include figure.liquid path="assets/img/ee545/project-03/pipeline_overview.png" class="img-fluid rounded z-depth-1" alt="End-to-end AMC pipeline overview from synthetic generation through evaluation." %}

## Project at a glance

- **Classes (8):** BPSK, QPSK, 8PSK, 16QAM, 64QAM, FSK, AM, FM  
- **Input per example:** 2×1024 (I/Q) real-valued sequence (normalized)  
- **Dataset SNR grid:** 0–20 dB (step 2 dB)  
- **Dataset size:** 4048 frames (46 frames / class / SNR)  
- **Split:** 80% train / 10% val / 10% test  
- **Model:** baseline 1‑D CNN (Conv‑BN‑ReLU‑Pool stacks → GAP → Dropout → FC → Softmax)  
- **Headline test accuracy (full demo):** **≈ 89.2%** overall

## Data and signal representation

### Modulation set

The classifier operates over the following eight modulation types:

| Family | Classes |
|---|---|
| PSK | BPSK, QPSK, 8PSK |
| QAM | 16QAM, 64QAM |
| FSK | FSK |
| Analog | AM, FM |

### I/Q framing

Each example is a **frame of 1024 complex samples** (baseband). For neural-network training, frames are converted into a **2×1024 real-valued sequence**:

- Channel 1: **I = Re{x[n]}**
- Channel 2: **Q = Im{x[n]}**

Frames are normalized to unit power prior to training.

### Channel and RF impairments

During dataset creation, each synthetic waveform is passed through a configurable impairment chain (examples include):

- additive noise (SNR control)
- fading (e.g., Rayleigh/Rician-style behavior)
- Doppler / time variation (configurable)
- carrier frequency offset (CFO) and timing offsets
- phase noise
- I/Q imbalance
- soft-limiter / power-amplifier nonlinearity

These impairments encourage the network to learn modulation-invariant structure that is robust to realistic distortions.

### Constellation intuition (illustrative)

The plot below shows example constellations at a representative SNR (generated separately for visualization). Even at moderate SNR, higher‑order QAM constellations exhibit much tighter decision boundaries than PSK, which helps explain the relative difficulty of separating **16QAM vs 64QAM** under impairments.

{% include figure.liquid path="assets/img/ee545/project-03/constellation_examples.png" class="img-fluid rounded z-depth-1" alt="Illustrative constellation examples for BPSK, QPSK, 16QAM, and 64QAM at 10 dB SNR." %}

## Model

### Baseline architecture

A compact **1‑D CNN** is used for frame-level classification. The implemented baseline uses four convolutional blocks (increasing channel depth), followed by global average pooling and a softmax classifier.

Key design choices:

- **1‑D convolution** over time (sequence length = 1024)
- **Batch normalization** for stable optimization
- **Max pooling** for temporal downsampling
- **Global average pooling (GAP)** to reduce parameters and encourage translation tolerance
- **Dropout** for regularization

{% include figure.liquid path="assets/img/ee545/project-03/arch_graph.png" class="img-fluid rounded z-depth-1" alt="Baseline 1-D CNN layer graph for AMC." %}

### Layer summary

The baseline network is constructed as:

1. `sequenceInputLayer(2, Normalization="zscore")`
2. 1‑D Conv (filters = *samplesPerSymbol*, channels: 32) → BN → ReLU → MaxPool
3. 1‑D Conv (channels: 48) → BN → ReLU → MaxPool
4. 1‑D Conv (channels: 64) → BN → ReLU → MaxPool
5. 1‑D Conv (channels: 96) → BN → ReLU
6. GAP → Dropout → Fully Connected (8) → Softmax → Classification output

## Training configuration

Default “full demo” settings:

- **Optimizer:** Adam  
- **Epochs:** 40  
- **Mini-batch size:** 128  
- **Initial learning rate:** 1e‑3  
- **Dropout:** 0.35  
- **Random seed:** 545 (for reproducibility)

Two operational modes are supported in the training script:

- **Quick mode:** smaller dataset + fewer epochs (fast smoke test)
- **Full mode:** full dataset + longer training for reported results

## Results

### Confusion matrix

The confusion matrix below highlights strong performance on **FSK/AM/FM** and clear confusions between **16QAM** and **64QAM**, which is a common failure mode for frame‑based AMC under realistic impairments.

{% include figure.liquid path="assets/img/ee545/project-03/confusion_matrix.png" class="img-fluid rounded z-depth-1" alt="Confusion matrix for baseline AMC classifier (full demo test set)." %}

### Accuracy vs SNR

Performance is tracked across the evaluation SNR grid. The **overall accuracy** is relatively stable in this run, but per‑class trends show that **higher‑order QAM** is substantially more sensitive to channel conditions than PSK and (in this configuration) the analog classes.

{% include figure.liquid path="assets/img/ee545/project-03/accuracy_vs_snr.png" class="img-fluid rounded z-depth-1" alt="Accuracy versus SNR plot for the baseline AMC classifier." %}

### Per-class F1-score

To balance precision and recall (especially under class confusion), per‑class F1 is summarized below.

{% include figure.liquid path="assets/img/ee545/project-03/f1_by_class.png" class="img-fluid rounded z-depth-1" alt="Per-class F1 score for the baseline AMC classifier." %}

Notable observations:

- **FSK / AM / FM:** 100% F1 in this evaluation split  
- **16QAM and 64QAM:** the main performance bottleneck (mutual confusion)

## Statistical validation

To evaluate run-to-run robustness, the baseline configuration was trained across **20 different random seeds** (same dataset configuration; fixed hyperparameters). Results are summarized below.

{% include figure.liquid path="assets/img/ee545/project-03/statistical_validation.png" class="img-fluid rounded z-depth-1" alt="Statistical validation across 20 seeds showing per-seed test accuracy distribution." %}

Summary (20 seeds):

- **Mean test accuracy:** 88.86%  
- **Std. dev.:** 1.00%  
- **Min / Max:** 86.72% / 90.46%

## Reproducibility

Key MATLAB entry points (relative to the repository root):

- `matlab/cpu_acm/runDemo.m` — end-to-end demo (dataset → train → evaluate)  
- `matlab/cpu_acm/generateAMCDataset.m` — synthetic dataset generator  
- `matlab/cpu_acm/createModClassCNN.m` — baseline CNN definition  
- `matlab/cpu_acm/trainModClassifier.m` — training loop + split management  
- `matlab/cpu_acm/evaluateModClassifier.m` — evaluation + plotting (confusion/SNR curves)

Example command-line run:

```bash
matlab -batch "run('matlab/cpu_acm/runDemo.m')"
```

## Takeaways and next steps

- **Class separability matters:** under impairments, **16QAM vs 64QAM** is the dominant confusion pair.
- **Architecture is intentionally compact:** the baseline 1‑D CNN is fast and reasonably accurate, but there is headroom for improvements via residual/attention or multi-branch feature extraction.
- **Data realism is a lever:** expanding channel models (e.g., wider CFO/timing ranges, multipath models, domain randomization) can improve robustness—at the cost of training complexity.

Potential extensions:

- train on a wider SNR range (including negative SNR)
- add richer multipath models and burst-level temporal structure
- evaluate alternative inputs (e.g., spectrograms or cyclostationary features)
- compare against hybrid CNN‑RNN/attention variants scaffolded in the codebase
