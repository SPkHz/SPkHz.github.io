---
layout: page
title: "Common-Source Amplifier: Frequency Response Measurement and Analysis"
description: "DC bias + Bode magnitude response (Measured vs LTspice), using discrete capacitors to emulate MOSFET parasitics."
img: /assets/img/ee322/lab-04/bode_mag_hero.png
importance: 4
category: coursework
related_publications: false
date: 2025-03-05
---

**Course:** EE-322 - Electrical Engineering Lab II  
**Lab Date:** 2025-03-05  
**Topic:** Frequency response characterization of a **common-source MOSFET amplifier** (ALD1105), including **DC operating point** verification and **Bode magnitude** measurement.

---

## Goals

1. **Bias** the amplifier to a symmetric operating point (**$V_O \approx 5\,\text{V}$** with **$V_{DD}=10\,\text{V}$**).
2. Measure the **DC operating point** (node voltages and drain currents) and compare to simulation.
3. Measure the **frequency response magnitude** from **10 Hz to 100 kHz**, then extract:
   - **Mid-band gain** $\lvert G_{v(\text{mid})}\rvert$
   - **Lower/upper cutoff frequencies** $f_L$, $f_H$ (−3 dB points)
   - **Bandwidth** $BW=f_H-f_L$
   - **Gain-bandwidth product** $GBP=\lvert G_{v(\text{mid})}\rvert\cdot BW$

Because intrinsic MOSFET capacitances are often too small to observe with standard lab instrumentation, the circuit includes **small discrete capacitors** (pF range) that emulate parasitic capacitances and make the high-frequency roll-off measurable.

---

## Circuit and component values

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab-04/circuit_schematic.png" title="Common-source amplifier test circuit" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  Common-source amplifier used for DC biasing and AC frequency sweep. Small capacitors (C1–C5) emulate device parasitics (including Miller-related effects).
</div>

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab-04/ald1105_pinout.png" title="ALD1105 pinout / internal device mapping" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

### Nominal component values

| Parameter | Value | Notes |
|---|---:|---|
| $V_{DD}$ | 10 V | Supply |
| Target $V_O$ | 5 V | Bias set by adjusting $V_{GG}$ / $V_G$ |
| $R$ | 15 kΩ | Bias branch resistor |
| $R_G$ | 100 kΩ | Gate bias resistor |
| $R_{sig}$ | 100 kΩ | Signal source resistance |
| $R_L$ | 10 MΩ | Oscilloscope probe input resistance |
| $C_B$ | 0.022 µF | Coupling capacitor |
| $C_1$ | 10 pF | Emulates small-signal gate capacitance |
| $C_2$ | 3.3 pF | Feedback / parasitic emulation |
| $C_3$ | 22 pF + 15 pF (probe) | Output loading capacitance |
| $C_4$ | 3.3 pF | Feedback / parasitic emulation |
| $C_5$ | 22 pF | Supply / reference node AC stabilization |

---

## Experiment 1 — DC operating point

### Method

- Adjust the gate bias voltage ($V_G$) until **$V_O \approx 5\,\text{V}$**.
- Measure node voltages and compute drain currents.
- Compare **measured** values to **LTspice** operating point results.

### DC summary (corrected from graded version)

> Note: SPICE current sign conventions can produce negative drain currents depending on device orientation. Values below are reported as **magnitudes**.

| Device | Quantity | Simulated | Measured | Units |
|---:|---|---:|---:|---|
| $Q_1$ | $I_D$ | 473.564 | 986.777 | µA |
|  | $\lvert V_{OV}\rvert$ | 1.299 | 1.330 | V |
|  | $V_G$ | 1.872 | 1.903 | V |
|  | $V_D$ | 5.058 | 4.967 | V |
|  | $V_S$ | 0.000 | 0.005 | V |
| $Q_2$ | $I_D$ | 473.564 | 986.777 | µA |
|  | $\lvert V_{OV}\rvert$ | 2.250 | 2.224 | V |
|  | $V_G$ | 7.103 | 7.129 | V |
|  | $V_D$ | 5.058 | 4.980 | V |
|  | $V_S$ | 10.000 | 10.000 | V |
| $Q_3$ | $I_D$ | 473.564 | 986.777 | µA |
|  | $\lvert V_{OV}\rvert$ | 2.250 | 2.224 | V |
|  | $V_G$ | 7.103 | 7.129 | V |
|  | $V_D$ | 7.103 | 7.129 | V |
|  | $V_S$ | 10.000 | 10.000 | V |

---

## Experiment 2 — Frequency response

### Measurement and calculations

For each test frequency, measure the input and output amplitude (oscilloscope), then compute:

$$
|G_v(f)| = \left|\frac{V_o}{V_{in}}\right|
$$

$$
G_v(f)_{dB} = 20\log_{10}(|G_v(f)|)
$$

Cutoff frequencies are defined by the **−3 dB** points relative to the measured mid-band gain:

$$
G_{v,\,dB}(f_L)=G_{v,\,dB}(f_H)=G_{v(\text{mid}),\,dB}-3\,\text{dB}
$$

For a band-limited response, a useful “center” reference is the **geometric mean**:

$$
 f_0 = \sqrt{f_L\,f_H}
$$

### AC summary (corrected from graded version)

| Quantity | Simulated | Measured | Units |
|---|---:|---:|---|
| $\lvert G_{v(\text{mid})}\rvert$ | 27.545 | 17.134 | V/V |
| $\lvert G_{v(\text{mid})}\rvert$ | 28.801 | 24.677 | dB |
| $f_L$ | 10.536 | 33 | Hz |
| $f_H$ | 13.002 | 8.000 | kHz |
| $BW$ | 12.991 | 7.967 | kHz |
| $GBP$ | 357.837 | 136.510 | kHz |

---

## Results — Bode magnitude (measured vs simulated)

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab-04/bode_mag_meas_vs_sim.png" title="Bode magnitude: measured vs simulated" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  **Measured** points are from oscilloscope amplitude data. The **simulated** curve shown is a first-order band-pass fit using the LTspice summary values (mid-band gain, $f_L$, $f_H$) so both can be compared on a single axis with the required 0–30 dB magnitude window.
</div>

Key measured markers (from the graded summary):

- $f_L = 33\,\text{Hz}$
- $f_H = 8.0\,\text{kHz}$
- $f_0 = \sqrt{f_L f_H} \approx \sqrt{33\cdot8000} \approx 513.8\,\text{Hz}$

---

## Discussion

- **Mid-band gain difference (measured < simulated):** real devices exhibit parameter spread, finite output resistance, and loading effects not perfectly captured by simplified assumptions.
- **High-frequency roll-off (measured $f_H$ < simulated $f_H$):** practical builds include additional parasitics (wiring + probe capacitance). In a common-source stage, the **Miller effect** increases the effective input capacitance due to the gate–drain capacitance being multiplied by approximately $(1+|A_v|)$, pushing the upper cutoff lower than ideal predictions.
- **Low-frequency corner (measured $f_L$ > simulated $f_L$):** coupling capacitor tolerances and the effective resistance seen by $C_B$ shift the high-pass pole.

---

## Measured dataset

<details>
  <summary>Show measured frequency response points (gain magnitude)</summary>

| Frequency (Hz) | $\lvert G_v\rvert$ (V/V) | Gain (dB) |
|---:|---:|---:|
| 6 | 2.172 | 6.735 |
| 9 | 3.197 | 10.095 |
| 13 | 5.652 | 15.043 |
| 25 | 9.221 | 19.296 |
| 33 | 11.890 | 21.503 |
| 50 | 14.158 | 23.020 |
| 100 | 15.126 | 23.595 |
| 200 | 16.966 | 24.592 |
| 514 | 17.134 | 24.677 |
| 1,000 | 17.361 | 24.791 |
| 3,000 | 16.331 | 24.260 |
| 5,000 | 15.005 | 23.525 |
| 8,000 | 13.106 | 22.349 |
| 12,000 | 9.153 | 19.231 |
| 16,000 | 7.325 | 17.296 |
| 20,000 | 5.780 | 15.239 |
| 50,000 | 2.374 | 7.510 |
| 80,000 | 1.416 | 3.022 |

</details>

---

## Reproducibility notes

- **Data source:** `EE_322_eeLab_II_Lab_4_Data.xlsx` (scope measurements and computed gains)
- **Simulation files:** `Lab_04_LTSpice/EE322_Lab_4_Bode.asc`, `Lab_04_LTSpice/EE322_Lab_04_DC_Operating_Point2.asc`, `Lab_04_LTSpice/Lab_04_SPICE_MODELS.txt`
- Plot generation can be reproduced by reading frequency + gain columns from the spreadsheet and generating a semilog magnitude plot with a 0–30 dB y-axis window.

