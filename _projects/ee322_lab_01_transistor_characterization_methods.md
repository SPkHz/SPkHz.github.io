---

layout: page
title: Transistor Characterization Techniques
description: Extracting NMOS SPICE parameters (VTn, KN, VA) from automated SMU sweeps + Python analysis.
img: /assets/img/ee322/lab-01/plot_exp1_id_vs_vds.png
category: coursework
importance: 9
related_publications: true
tags:
  - mosfet characterization
  - spice parameter extraction
  - vt
  - kn
  - va
  - smu sweeps
  - python analysis
  - curve fitting
---

This page documents **Lab 01 (2025-01-16)** for **EE-322 — Electrical Engineering Lab II**.

**Objective.** Characterize an NMOS transistor by extracting key Level-1/SPICE-style parameters:

- **Threshold voltage:** $V_{Tn}$
- **Transconductance parameter:** $K_N$ (square-law gain factor)
- **Early voltage:** $V_A$ (channel-length modulation)

The device under test is the **ALD1106** quad matched **N-channel enhancement-mode MOSFET array**. The body node ($V^-$) must be tied to the **lowest potential** for NMOS operation.

---

## Device and Bench Setup

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab-01/ald1106_pinout.png" title="ALD1106 pinout and internal schematic" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

### Instruments

- **Rohde & Schwarz NGU401 SMU** (source/measure)
- **Keithley programmable power supply** (fixed bias for $V_{GS}$ or $V_{DS}$)
- **Keithley DMM** (DC current measurement during the $I_D$–$V_{GS}$ sweep)
- **Python** scripts (SCPI control, live plotting, CSV logging)

---

## Experiment 1 — $I_D$ vs. $V_{DS}$ (Family of Curves)

**Goal.** Sweep $V_{DS}$ while stepping $V_{GS}$ to generate a family of output characteristics.

**Sweep plan**

- $V_{DS}$: 0 → 8 V in **0.1 V steps**
- $V_{GS}$: **1 V, 2 V, 3 V, 4 V** (set by the power supply)

**Measurement roles**

- SMU: sources $V_{DS}$ and measures $I_D$ (and the actual $V_{DS}$)
- Power supply: sets $V_{GS}$

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab-01/exp1_wiring.png" title="Experiment 1 wiring diagram" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

### Result — Output Characteristics

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab-01/plot_exp1_id_vs_vds.png" title="Measured ID–VDS curves (VGS stepped)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

---

## Experiment 2 — $I_D$ vs. $V_{GS}$ (Transfer Curves)

**Goal.** Sweep $V_{GS}$ while stepping $V_{DS}$ to generate a family of transfer curves.

**Sweep plan**

- $V_{GS}$: 0 → 4 V in **0.1 V steps**
- $V_{DS}$: **4 V, 5 V, 6 V** (set by the power supply)

> Correction note (graded-version cleanup): the acquisition script comment line that said “200 mV” is incorrect; the data here uses **0.1 V (100 mV)** steps.

**Measurement roles**

- SMU: sources $V_{GS}$ and reports the actual $V_{GS}$
- Power supply: sets $V_{DS}$
- DMM: measures $I_D$ (DC current)

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab-01/exp2_wiring.png" title="Experiment 2 wiring diagram" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

### Result — Transfer Characteristics

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab-01/plot_exp2_id_vs_vgs.png" title="Measured ID–VGS curves (VDS stepped)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

---

## Post‑Lab Analysis

The measured sweeps were logged to CSV and then processed in Python to:

1. Re-plot the two curve families ($I_D$–$V_{DS}$ and $I_D$–$V_{GS}$)
2. Fit **$\sqrt{I_D}$ vs. $V_{GS}$** to extract $K_N$ and $V_{Tn}$
3. Fit **$I_D$ vs. $V_{DS}$** in saturation to extract $V_A$

A compact CSV summary of the extracted parameters is included here:

- [Download: extracted_parameters.csv]({{ '/assets/img/ee322/lab-01/extracted_parameters.csv' | relative_url }})

---

## Parameter Extraction

### 1) Extracting $V_{Tn}$ and $K_N$ from $\sqrt{I_D}$ vs. $V_{GS}$

Assuming the NMOS is biased in saturation and follows the square-law model (ignoring mobility degradation and with channel-length modulation treated as a small perturbation):

$$
I_D \approx \frac{K_N}{2}\,(V_{GS}-V_{Tn})^2
$$

Taking the square root gives a linear relationship:

$$
\sqrt{I_D} = \underbrace{\sqrt{\frac{K_N}{2}}}_{m}\,V_{GS} + \underbrace{\left(-\sqrt{\frac{K_N}{2}}\,V_{Tn}\right)}_{b}
$$

So from a line fit $\sqrt{I_D}=mV_{GS}+b$:

- $V_{Tn} = -b/m$
- $K_N = 2m^2$

**Fit region used:** $V_{GS} \ge 1.0\,\mathrm{V}$ (to avoid the near-threshold/subthreshold region).

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab-01/plot_sqrtid_vs_vgs_fit.png" title="sqrt(ID)–VGS with linear fits" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

**Per-curve results (by fixed $V_{DS}$):**

| Fixed $V_{DS}$ (V) | Extracted $V_{Tn}$ (V) | Extracted $K_N$ ($\mu$A/V$^2$) |
|---:|---:|---:|
| 4 | 0.5891 | 522.2 |
| 5 | 0.5884 | 528.6 |
| 6 | 0.5870 | 533.9 |

**Summary (mean ± 1σ across $V_{DS}=4,5,6$ V):**

| Parameter | Mean | Std. Dev. | Notes |
|---|---:|---:|---|
| $V_{Tn}$ | 0.5882 V | 0.0011 V | linear fit of $\sqrt{I_D}$ vs. $V_{GS}$ |
| $K_N$ | 528.2 $\mu$A/V$^2$ | 5.85 $\mu$A/V$^2$ | using $I_D = (K_N/2)(V_{GS}-V_{Tn})^2$ |

> Unit correction note: the lab handout table lists units for $K_N$ as “$\mu$A/V”, but the square-law parameter has units of **A/V$^2$** (or **$\mu$A/V$^2$**).

---

### 2) Extracting $V_A$ from $I_D$ vs. $V_{DS}$ (Saturation Region)

In saturation with channel-length modulation:

$$
I_D(V_{DS}) \approx I_{D,\text{sat}}\left(1+\frac{V_{DS}}{V_A}\right)
$$

Rewriting as a line in $V_{DS}$:

$$
I_D \approx aV_{DS}+c
\quad\Rightarrow\quad
V_A = \frac{c}{a}
$$

**Fit region used:** $V_{DS} \ge 4\,\mathrm{V}$ for every $V_{GS}$ curve (deep saturation for all curves).

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab-01/plot_early_voltage_extraction.png" title="Early voltage extraction (linear fits in saturation)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

**Extracted $V_A$ values (by fixed $V_{GS}$):**

| Fixed $V_{GS}$ (V) | $V_A$ (V) |
|---:|---:|
| 1 | 65.27 |
| 2 | 74.13 |
| 3 | 96.02 |
| 4 | 133.06 |

---

## Reproducibility Notes

- The acquisition scripts use **SCPI commands** to:
  - reset instruments,
  - set voltage/current compliance,
  - step the swept voltage,
  - query measured voltage and current,
  - log to a **wide CSV** with a column MultiIndex (one pair of columns per bias value).

- The analysis is straightforward in pandas:

```python
import pandas as pd
import numpy as np

# MultiIndex columns: (bias_label, field)
df_vds = pd.read_csv('NMOS_Parametric_Sweep.csv', header=[0, 1])
df_vgs = pd.read_csv('VGS_NMOS_Parametric_Sweep.csv', header=[0, 1])

# Example: pull one curve
vds = df_vds[('VGS=4.00V','VDS')].to_numpy(float)
id_a = df_vds[('VGS=4.00V','Current')].to_numpy(float)

# Example: linear fit (returns slope, intercept)
m, b = np.polyfit(vds, id_a, 1)
```

---

## Discussion

- The extracted $V_A$ values are **large** (tens to >100 V), which is consistent with **weak channel-length modulation** (small output conductance) in saturation.
- The $\sqrt{I_D}$ linear fits show very high linearity over the selected region, but the extracted $V_{Tn}$ can shift slightly depending on what portion of the curve is treated as “most linear.” A more advanced model would include:
  - mobility degradation at higher $V_{GS}$,
  - explicit channel-length modulation during the $V_{Tn}$/$K_N$ fit,
  - temperature drift (if applicable).
