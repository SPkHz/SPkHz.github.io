---

layout: page
title: Building, Simulating, and Measuring a Common-Source Amplifier with an Active Load 
description: DC biasing + small-signal gain sensitivity to Rsig and RL using an ALD1105 MOSFET array (bench + LTspice).
img: /assets/img/ee322/lab-03/cover.png
category: coursework
toc:
  sidebar: left
importance: 9
related_publications: true
tags:
  - common-source amplifier
  - active load
  - dc biasing
  - small-signal gain
  - ald1105
  - ltspice
  - bench measurement
---

**Course:** EE-322 — Electrical Engineering Lab II  
**Lab date:** 2025-02-24  
**Topic:** Actively-loaded NMOS common-source amplifier (ALD1105)  
**Tools:** Bench PSU + function generator + oscilloscope, LTspice

---

## Overview

This lab investigates a **common-source MOSFET amplifier** built using the **ALD1105** matched transistor array. The stage uses:

- **NMOS (Q1)** as the amplifying device.
- **PMOS active load (Q2)** biased by a **PMOS reference device (Q3)** to approximate a current-source load.

The work is organized into three experiments:

1. **DC operating point:** adjust the gate-bias supply until the output is near **\(V_O \approx 5\,\text{V}\)**.
2. **Effect of source resistance \(R_{sig}\):** quantify how generator/source impedance attenuates the input and changes the overall gain.
3. **Effect of load resistance \(R_L\):** quantify how output loading reduces small-signal gain.

> **Important bench note (from the graded notebook):** early measurements were contaminated by **60 Hz interference** caused by **ground loops**. The circuit is extremely sensitive to bias-node noise; all instruments must share a **single common ground**.

---

## Circuit and key parameters

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab-03/ald1105_pinout.png" title="ALD1105 pinout and internal device diagram" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab-03/wiring_diagram.png" title="Wiring diagram used for the actively loaded common-source amplifier" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  The ALD1105 provides matched MOSFETs. The amplifier biases an NMOS common-source stage using a PMOS active load.
</div>

**Nominal component/model values (from the lab handout):**

- \(V_{DD} = 10\,\text{V}\)
- \(R = 15\,\text{k}\Omega\)
- \(R_G = 10\,\text{M}\Omega\)
- \(C_B = 0.1\,\mu\text{F}\)
- NMOS: \(K_N = 270\,\mu\text{A}/\text{V}^2\), \(V_{Tn}=0.573\,\text{V}\), \(\lambda_N=0.0165\,\text{V}^{-1}\)
- PMOS: \(K_P = 88\,\mu\text{A}/\text{V}^2\), \(V_{Tp}=-0.647\,\text{V}\), \(\lambda_P=0.0219\,\text{V}^{-1}\)

---

## Experiment 1 — DC operating point (\(V_O \approx 5\,\text{V}\))

### Procedure

- Adjust the DC bias supply (\(V_G\) / \(V_{GG}\)) until the output node is approximately **\(V_O = 5\,\text{V}\)**.
- Record node voltages and compute/confirm currents.

### Results

The table below consolidates:

- **Simulated** operating point from LTspice.
- **Measured** operating point values recorded in the **graded** notebook.

| Device | Quantity | Simulated | Measured | Units |
|---|---:|---:|---:|---|
| Q1 (NMOS) | \(I_D\) | 494.0 | 482.750 | \(\mu\text{A}\) |
|  | \(|V_{OV}|\) | 1.299 | 1.296* | V |
|  | \(V_G\) | 1.872 | 1.869 | V |
|  | \(V_D\) | 5.058 | 5.322 | V |
|  | \(V_S\) | 0.000 | 0.000 | V |
| Q2 (PMOS load) | \(I_D\) | 494.0 | 482.750 | \(\mu\text{A}\) |
|  | \(|V_{OV}|\) | 2.250 | 2.158 | V |
|  | \(V_G\) | 7.103 | 7.142 | V |
|  | \(V_D\) | 5.058 | 5.322 | V |
|  | \(V_S\) | 10.000 | 10.000 | V |
| Q3 (PMOS reference) | \(I_D\) | 494.0 | 482.750 | \(\mu\text{A}\) |
|  | \(|V_{OV}|\) | 2.250 | 2.158 | V |
|  | \(V_G\) | 7.103 | 7.142 | V |
|  | \(V_D\) | 7.103 | 7.142 | V |
|  | \(V_S\) | 10.000 | 10.000 | V |

\*For Q1, \(|V_{OV}|\) was computed from measured \(V_G\) using \(|V_{OV}| \approx V_{GS}-V_{Tn} = 1.869-0.573 = 1.296\,\text{V}\).

<div class="row">
  <div class="col-sm-10 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab-03/dc_operating_point_voltages.png" title="DC node voltages: simulated vs measured" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  Node voltages match closely between simulation and measurement; the measured drain/output voltage settled slightly above 5 V.
</div>

---

## Small-signal model (midband intuition)

With the coupling capacitors treated as AC shorts at the test frequency, a useful approximation is:

- **Input divider** (generator source resistance into \(R_G\) to AC ground):

$$
 v_{g,ac} \approx v_{sig}\,\frac{R_G}{R_G + R_{sig}}
$$

- **Common-source voltage gain** (inverting, midband):

$$
A_v \approx -g_{m1}\,R_{out}
\quad\text{with}\quad
R_{out} \approx r_{o1} \parallel r_{o2} \parallel R_L
$$

So the overall measured gain defined in the lab is approximately:

$$
G_v \equiv \frac{v_o}{v_{sig}} \approx \left(-g_{m1}R_{out}\right)\frac{R_G}{R_G + R_{sig}}
$$

Using the simulated Q1 operating point:

- \(g_{m1} \approx \frac{2I_D}{|V_{OV}|} \approx \frac{2\cdot 494\,\mu\text{A}}{1.299\,\text{V}} \approx 0.761\,\text{mS}\)
- \(r_{o1} \approx \frac{1}{\lambda_N I_D} \approx \frac{1}{0.0165\cdot 494\,\mu\text{A}} \approx 123\,\text{k}\Omega\)
- \(r_{o2} \approx \frac{1}{\lambda_P I_D} \approx \frac{1}{0.0219\cdot 494\,\mu\text{A}} \approx 92\,\text{k}\Omega\)

This yields \(r_{o1}\parallel r_{o2} \approx 53\,\text{k}\Omega\), giving a midband gain estimate:

$$
A_v \approx -(0.761\,\text{mS})(53\,\text{k}\Omega) \approx -40\,\text{V/V} \;\; (\approx 32\,\text{dB})
$$

The LTspice values below are slightly higher (≈32.8 dB), consistent with model details and the exact bias point.

---

## Experiment 2 — Gain sensitivity to \(R_{sig}\) (\(R_L = 10\,\text{M}\Omega\))

### Simulated results

| \(R_{sig}\) | \(G_v\) (V/V) | \(|G_v|\) (dB) | Phase |
|---:|---:|---:|---:|
| 10 MΩ | -21.900 | 26.809 | ≈ -180° |
| 100 kΩ | -43.366 | 32.743 | ≈ -180° |
| 10 kΩ | -43.756 | 32.821 | ≈ -180° |
| 1 kΩ | -43.795 | 32.829 | ≈ -180° |

<div class="row">
  <div class="col-sm-10 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab-03/gain_vs_rsig_db.png" title="Voltage gain magnitude vs Rsig (simulated)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  The gain stays near 32.8 dB until Rsig approaches RG (10 MΩ). At Rsig = RG, the gate sees a 0.5 divider, reducing gain by ≈6.02 dB.
</div>

---

## Experiment 3 — Gain sensitivity to \(R_L\) (\(R_{sig} = 1\,\text{k}\Omega\))

### Correction applied (graded notebook)

The graded notebook indicates the intention of Experiment 3 is **\(R_{sig}=1\,\text{k}\Omega\)** (per the lab handout). The raw RL-sweep data file contained gains consistent with an additional **\(10\,\text{M}\Omega / 10\,\text{M}\Omega\)** input divider (i.e., \(R_{sig}=R_G\)), which halves \(v_g\) and therefore halves \(G_v\).

Because \(R_{sig}\) only affects the **input attenuation** (not the bias point), the corrected RL-sweep values are obtained by removing the extra 0.5 divider:

- \(G_{v,\text{corrected}} \approx 2\,G_{v,\text{raw}}\)
- \(|G_v|_{dB,\text{corrected}} = |G_v|_{dB,\text{raw}} + 6.02\,\text{dB}\)

### Corrected simulated results

| \(R_L\) | \(G_v\) (V/V) | \(|G_v|\) (dB) | Phase |
|---:|---:|---:|---:|
| 10 MΩ | -43.800 | 32.829 | ≈ -180° |
| 100 kΩ | -27.885 | 28.907 | ≈ -180° |
| 10 kΩ | -6.480 | 16.232 | ≈ -180° |
| 1 kΩ | -0.747 | -2.535 | ≈ -180° |

<div class="row">
  <div class="col-sm-10 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab-03/gain_vs_rl_db.png" title="Voltage gain magnitude vs RL (corrected)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  Decreasing RL loads the output node, reducing Rout and therefore reducing gain.
</div>

---

## Grounding issue observed on the bench (60 Hz interference)

During early bench measurements, the observed output waveform was dominated by **60 Hz pickup**. The failure mode was consistent with **ground loops** created by splitting instrument/circuit grounds across different rails.

**Mitigation checklist used after grading feedback:**

- Use **one** breadboard rail as the **single ground reference**.
- Tie the following to that same ground point:
  - DC power supply negative terminal
  - function generator ground/negative terminal
  - oscilloscope probe ground clip(s)
  - circuit ground rail
- Keep all leads **short** (long jumpers behave like antennas).
- Avoid “floating” instrument grounds or mixing ground rails.

---

## Reproducibility notes

- **LTspice schematics/raw data:** provided in the submitted source folder (\`.asc\`, \`.raw\`, \`.log\`).
- **Chart data:** exported to CSV and replotted here in Python for clean, non-handwritten figures.

If you are reproducing the AC results, use a midband frequency where the coupling capacitors are effectively shorted (e.g., \(\ge\) 1 kHz for \(C_B = 0.1\,\mu\text{F}\) with kΩ–MΩ impedances).
