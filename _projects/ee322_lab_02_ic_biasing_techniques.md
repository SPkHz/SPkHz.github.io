---
layout: page
title: EE-322 Lab 02 - IC Biasing Techniques
description: MOSFET-resistor bias vs. beta-multiplier bias using ALD1106/ALD1105 (LTSpice + breadboard). Focus: operating point accuracy and power-supply sensitivity. (2025-01-28)
img: /assets/img/ee322/lab-01/lab02_cover.png
importance: 2
category: coursework
tags: [EE-322, analog, MOSFET, biasing, current-mirror, beta-multiplier, LTSpice]
toc:
  sidebar: left
related_publications: false
---

This page summarizes **Lab 02 (2025-01-28)** for **EE-322 - Electrical Engineering Lab II**.

**Topic:** Compare two IC biasing approaches:
1. **MOSFET-resistor bias** (simple, but typically supply-sensitive)
2. **Beta-multiplier bias** (feedback-based, typically more supply/process robust)

**Reference notebook/report:** `EE_322_Lab_02_Notebook_Placzek_Rdy_To_Print.pdf`

---

## Results snapshot

All comparisons below are for a target bias of **~500 µA** at **$V_{DD}=10\,\text{V}$**.

| Metric @ $V_{DD}=10\,\text{V}$ | Experiment 1 (MOSFET-R) | Experiment 2 (Beta multiplier) |
|---|---:|---:|
| Tuned resistor (measured) | 16.003 kΩ | 1.0361 kΩ |
| Bias current (measured) | 504.477 µA | 506.814 µA |
| Bias current error vs sim | +0.90% | +1.36% |

**Takeaway:** The **beta-multiplier** configuration exhibited stronger resistance to dynamic changes in **$V_{DD}$** in the sweep/derivative analysis.

---

## Goals

Bias networks establish a **repeatable operating point** (current/voltages) so analog stages behave predictably despite variations in **$V_{DD}$**, device parameters, and temperature.

In this lab, both bias circuits were:

- **Simulated in LTSpice**
- **Built and measured** using the **ALD1106/ALD1105** MOSFET array
- Swept across **$V_{DD}=0 \rightarrow 15\,\text{V}$** to evaluate **power-supply sensitivity**

---

## Hardware reference: ALD1106 / ALD1105 pinout

<div class="row">
  <div class="col-sm-10 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab-01/lab02_ald110x_pinout.png" title="ALD1106/ALD1105 pinout and internal devices" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  Pinout + internal device diagrams used throughout the lab setup.
</div>

---

## Experiment 1 — MOSFET-resistor bias characterization

### Circuit concept
A diode-connected NMOS (gate tied to drain) with a resistor from **$V_{DD}$ → drain/gate node** sets a bias current.

**Procedure summary**

- Set **$V_{DD}=10\,\text{V}$**
- Replace the resistor with a **20 kΩ potentiometer**
- Tune $R$ until **$I_D \approx 500\,\mu\text{A}$**
- Record the **DC operating point**
- Sweep **$V_{DD}=0 \rightarrow 15\,\text{V}$** and record $I_D(V_{DD})$

### Wiring + build

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab-01/lab02_exp1_wiring_diagram.png" title="Experiment 1 wiring diagram (MOSFET-resistor bias)" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab-01/lab02_breadboard_setup_2.jpg" title="Breadboard build (photo)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  The potentiometer was tuned at <b>$V_{DD}=10\,\text{V}$</b> to achieve <b>$I_D \approx 500\,\mu\text{A}$</b>, then $V_{DD}$ was swept to observe sensitivity.
</div>

### Operating point summary (Simulated vs. Measured)

| Quantity | Simulated | Measured | Units |
|---|---:|---:|---|
| $R$ | 16.200 | 16.003 | kΩ |
| $V_{GS1}$ | 1.910 | 1.940 | V |
| $V_{DS1}$ | 1.910 | 1.940 | V |
| $V_{OV1}$ | 1.337 | 1.341 | V |
| $I_{D1}$ | 499.999 | 504.477 | µA |

**Notes**
- **Current target accuracy:** simulated vs. measured differs by ~**0.90%** ($\approx 4.48\,\mu\text{A}$).
- **Tuned resistor:** measured $R$ is ~**1.22%** lower than simulated.

### $V_{DD}$ sweep (measured vs simulated)

<div class="row">
  <div class="col-sm-10 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab-01/lab02_exp1_measured_vs_sim.png" title="Experiment 1: $I_D$ vs $V_{DD}$ (measured vs simulated)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  MOSFET-resistor bias shows a noticeable dependency of current on $V_{DD}$.
</div>

---

## Experiment 2 — Beta-multiplier bias characterization

### Circuit concept
A beta multiplier uses **device sizing + feedback** to create a self-biased reference current.

**Implementation details**

- Set **$V_{DD}=10\,\text{V}$**
- Replace the resistor with a **5 kΩ potentiometer**
- Tune $R$ until **$I_{D2} \approx 500\,\mu\text{A}$**
- Record DC operating point for multiple devices in the loop
- Sweep **$V_{DD}=0 \rightarrow 15\,\text{V}$** and record currents

**Sizing ratio**

$Q_2$ was implemented as **4×** the width of $Q_1$ by wiring **four NMOS devices in parallel**.

### Wiring + build

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab-01/lab02_exp2_wiring_diagram.png" title="Experiment 2 wiring diagram (beta multiplier)" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab-01/lab02_breadboard_setup_1.jpg" title="Breadboard build (photo)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  Beta-multiplier wiring using the ALD1106/ALD1105 array (including parallel NMOS devices to realize the 4× width ratio).
</div>

### Operating point summary (Simulated vs. Measured)

| Quantity | Simulated | Measured | Units |
|---|---:|---:|---|
| $R$ | 1.254 | 1.0361 | kΩ |
| $V_{GS1}$ | 1.980 | 1.985 | V |
| $V_{DS1}$ | 1.980 | 1.985 | V |
| $V_{OV1}$ | 1.407 | 1.370 | V |
| $I_{D1}$ | 552.000 | 506.814 | µA |
| $V_{GS2}$ | 1.350 | 1.496 | V |
| $V_{DS2}$ | 6.420 | 6.646 | V |
| $V_{OV2}$ | 0.644 | 0.685 | V |
| $I_{D2}$ | 500.000 | 506.814 | µA |
| $V_{SG3}$ | 2.960 | 2.861 | V |
| $V_{SD3}$ | 8.020 | 8.006 | V |
| $|V_{OV3}|$ | 2.313 | 2.406 | V |
| $I_{D3}$ | 552.000 | 506.814 | µA |
| $V_{SG4}$ (row 1) | 2.960 | 2.862 | V |
| $V_{SG4}$ (row 2) | 2.960 | 2.882 | V |
| $|V_{OV4}|$ | 2.313 | 1.441 | V |
| $I_{D4}$ | 500.000 | 506.814 | µA |

Notes:
- The source table lists **$V_{SG4}$ twice**; both rows are preserved here as recorded.
- At the bias point, the **current target** is still close: $I_{D2}$ is about **+1.36%** above 500 µA.

### $V_{DD}$ sweep (measured vs simulated)

<div class="row">
  <div class="col-sm-10 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab-01/lab02_exp2_measured_vs_sim.png" title="Experiment 2: $I_D$ vs $V_{DD}$ (measured vs simulated)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  Beta-multiplier bias current tracks the target region more consistently across $V_{DD}$ compared with the simple MOSFET-resistor bias.
</div>

### Supply sensitivity visualization (derivative)

<div class="row">
  <div class="col-sm-10 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab-01/lab02_exp2_supply_sensitivity.png" title="Experiment 2: derivative-based supply sensitivity visualization" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  The derivative curve illustrates how the simulated current's sensitivity to $V_{DD}$ changes across the sweep (qualitative stability indicator).
</div>

---

## Discussion: Which bias is more supply-robust?

From the measured/simulated sweeps and the post-lab analysis, the **beta-multiplier configuration** is the more supply-robust option in this lab setup.

Why (conceptually):

- **Negative feedback** adjusts gate-source voltages to counter supply-driven current changes.
- A mirror/cascode-like structure can present a **higher small-signal impedance** at the bias node, reducing coupling from $V_{DD}$.

---

## How to add this to your al-folio repo

1. Save this file as:
   - `_projects/ee322_lab_02.md` (recommended), or
   - wherever your site stores project pages.

2. Copy the provided images into:
   - `assets/img/ee322/lab-01/`

3. Rebuild your GitHub Pages site.

If your repo uses a different images folder naming convention (e.g., `lab-02`), update the `img:` field and the `figure.liquid` paths accordingly.
