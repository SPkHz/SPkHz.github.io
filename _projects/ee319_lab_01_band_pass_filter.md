---

layout: page
title: Passive RC Band-Pass Filter Measurement and Analysis
description: "Two-pole passive RC band-pass filter: analytic frequency response + LTspice AC sweep + Analog Discovery Studio measurements (MATLAB post-processing)."
img: /assets/img/ee319/lab-01/bpf/thumbnail.png
category: coursework
date: 2024-09-04 00:00:00-0400
giscus_comments: false
pretty_table: true
date: 2024-09-04
importance: 58022536485320760
related_publications: true
tags:
  - passive band-pass filter
  - rc filter
  - bode plot
  - ltspice
  - analog discovery
  - matlab
  - frequency response
_styles: |
  /* Slightly larger MathJax without blowing up inline math */
  .post article .mjx-container[display="true"] {
    font-size: 1.28em;
    margin: 0.85em 0 1.05em;
  }
  .post article .mjx-container {
    font-size: 1.10em;
  }
---

## Overview

**Course:** EE-319 — Electronics Lab I
**Project/Assignment:** Laboratory 02
**Team:** Steven Placzek, Jeremy Burke  
**Tools:** MATLAB • LTspice • Analog Discovery Studio (WaveForms)

This lab analyzes a **passive RC band-pass filter** using three parallel methods:

1. **Closed-form frequency-domain analysis** (transfer function + Bode asymptotes)
2. **LTspice AC sweep** (SPICE validation)
3. **Hardware measurement** using a **Digilent Analog Discovery Studio**, with MATLAB used for post-processing and overlay plots.

---

## Circuit

The circuit is a **2-pole RC band-pass** formed by a **series coupling capacitor** (sets the low cutoff) and a **shunt capacitor** (sets the high cutoff), with source/load resistances providing the real parts.

| Component | Value | Role |
|---:|---:|---|
| \(R_1\) | 10 kΩ | Source series resistance |
| \(R_2\) | 10 kΩ | Load resistance (output across \(R_2\)) |
| \(C_1\) | 3.3 nF | Shunt capacitor → high cutoff |
| \(C_2\) | 56 nF | Series capacitor → low cutoff |

<div class="row justify-content-sm-center">
  <div class="col-sm-6 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee319/lab-01/bpf/ltspice_schematic.png" title="LTspice schematic (parameterized component values)" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm-6 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee319/lab-01/bpf/protoboard_closeup.jpg" title="Hardware build (Analog Discovery Studio protoboard)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  The lab compares theory, LTspice, and hardware measurements of the same passive network.
</div>

---

## Frequency-Domain Model

### Midband gain (intuitive check)

Between the two corner frequencies, \(C_2\) behaves approximately like a short and \(C_1\) behaves approximately like an open, so the circuit reduces to a simple divider:

$$
A_v(\text{mid}) \approx \frac{R_2}{R_1 + R_2}
$$

With \(R_1 = R_2\), the *first-order intuition* is \(A_v(\text{mid})\approx 0.5\) (≈ −6.02 dB). The full network (exact nodal analysis) predicts a slightly smaller midband gain due to loading interaction between \(C_1\) and \(C_2\).

### Corner-frequency estimates

A useful estimate for the band edges comes from the effective resistance each capacitor “sees” in its limiting regime:

$$
\begin{aligned}
 f_L &\approx \frac{1}{2\pi (R_1 + R_2) C_2} \\
 f_H &\approx \frac{1}{2\pi (R_1 \parallel R_2) C_1}
\end{aligned}
$$

From these, the center frequency and quality factor (using the standard narrow-to-moderate band approximations) are:

$$
\begin{aligned}
 f_0 &\approx \sqrt{f_L f_H} \\
 BW_f &\approx f_H - f_L \\
 Q &\approx \frac{f_0}{BW_f}
\end{aligned}
$$

---

## LTspice Simulation

An AC sweep from **10 Hz → 100 kHz** validates the analytic response.

<div class="row justify-content-sm-center">
  <div class="col-sm-10 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee319/lab-01/bpf/ltspice_ac_sweep.png" title="LTspice AC sweep (magnitude + phase)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

---

## Hardware Measurement Setup

The filter was built directly on the **Analog Discovery Studio protoboard** and characterized using the WaveForms instruments (scope + Bode tools).

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee319/lab-01/bpf/protoboard_diagram.png" title="Analog Discovery Studio protoboard (reference)" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee319/lab-01/bpf/protoboard_layout.jpg" title="Wiring layout during measurement" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="row justify-content-sm-center">
  <div class="col-sm-10 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee319/lab-01/bpf/measured_bode.png" title="WaveForms Bode plot measurement (magnitude + phase)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

---

## Results

### Bode magnitude + phase overlays

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee319/lab-01/bpf/bode_mag_calc_sim_meas.jpg" title="Magnitude: calculated vs LTspice vs measured" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  Overlay comparison of the band-pass magnitude response. The measured trace tracks the predicted curve closely, with small shifts consistent with component tolerance and instrument loading.
</div>

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee319/lab-01/bpf/bode_mag_zoom.jpg" title="Magnitude (zoomed near midband)" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee319/lab-01/bpf/phase_unwrapped.jpg" title="Phase (unwrapped)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

### Key numeric results

| Metric | Calculated | Simulated | Measured | Units |
|---|---:|---:|---:|---|
| \(A_v(\text{mid})\) | 485.6895 | 485.6895 | 483.2372 | mV/V |
| \(|A_v(\text{mid})|_{dB}\) | −6.2728 | −6.2728 | −6.3168 | dB |
| \(f_L\) | 136.1683 | 136.1683 | 131.6514 | Hz |
| \(f_0\) | 1.1708 | 1.1708 | 1.0906 | kHz |
| \(f_H\) | 10.0661 | 10.0661 | 9.8537 | kHz |
| \(BW_f\) | 9.9210 | 9.9210 | 9.7221 | kHz |
| \(Q\) | 0.1179 | 0.1179 | 0.1122 | Hz/Hz |

**Notes:**
- Calculated vs simulated matched essentially identically.
- The maximum measured deviation was at \(f_0\) (≈ 7.09%), which is consistent with component tolerance and practical measurement non-idealities.

---

## Time-Domain Spot Checks

Oscilloscope captures at representative frequencies show the expected behavior: strong attenuation at very low / very high frequency, with near-max output around \(f_0\).

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee319/lab-01/bpf/scope_10Hz.png" title="Scope @ 10 Hz" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee319/lab-01/bpf/scope_fL_131_6514Hz.png" title="Scope @ f_L = 131.65 Hz" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee319/lab-01/bpf/scope_f0_1_0906kHz.png" title="Scope @ f_0 = 1.0906 kHz" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee319/lab-01/bpf/scope_fH_9_8537kHz.png" title="Scope @ f_H = 9.8537 kHz" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="row justify-content-sm-center">
  <div class="col-sm-10 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee319/lab-01/bpf/scope_100kHz.png" title="Scope @ 100 kHz" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

---

## Downloads

- **Presentation PDF:** <a href="/assets/img/ee319/lab-01/bpf/files/EE319_Lab01_BPF_Presentation.pdf">EE319_Lab01_BPF_Presentation.pdf</a>
- **MATLAB script:** <a href="/assets/img/ee319/lab-01/bpf/files/EE_319_Lab_01_BPF_Placzek.m">EE_319_Lab_01_BPF_Placzek.m</a>
- **LTspice schematic:** <a href="/assets/img/ee319/lab-01/bpf/files/EE319_Lab01_BPF_Bode.asc">EE319_Lab01_BPF_Bode.asc</a>
- **Measured Bode data (CSV):** <a href="/assets/img/ee319/lab-01/bpf/files/EE319_Lab01_Measured_Bode.csv">EE319_Lab01_Measured_Bode.csv</a>
- **Results sheet (XLSX):** <a href="/assets/img/ee319/lab-01/bpf/files/EE319_Lab01_BPF_Results.xlsx">EE319_Lab01_BPF_Results.xlsx</a>
