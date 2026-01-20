---
layout: page
title: Low-Pass Filter Measurement and Analysis
description: First-order RC low-pass filter build + Bode measurement (10 Hz–100 kHz) with MATLAB/LTspice validation.
img: /assets/img/ee319/lab-01/lpf/thumbnail.png
category: coursework
date: 2024-09-04 00:00:00-0400
giscus_comments: false
pretty_table: true
images:
  slider: true
importance: 64198247165515853
related_publications: true
tags:
  - rc low-pass
  - first-order filter
  - bode magnitude
  - phase response
  - ltspice
  - waveforms
  - matlab
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

**Course:** EE 319 — Electrical Engineering Lab I (Western New England University - College of Engineering)  
**Lab:** Lab #01 — Low-Pass Filter Measurements  
**Goal:** build a 1st-order low-pass filter and compare **calculated**, **LTspice simulated**, and **measured** frequency/time-domain behavior.

**Tools:** Digilent WaveForms (Bode + scope), MATLAB (post-processing/plots), LTspice (AC analysis)

---

## Circuit

The lab circuit is a simple RC low-pass with a resistive load:

- \(R_1 = 10\,\text{k}\Omega\)
- \(R_2 = 10\,\text{k}\Omega\)
- \(C_1 = 3.3\,\text{nF}\)

{% include figure.liquid loading="eager" path="assets/img/ee319/lab-01/lpf/schematic.png" title="Low-pass filter schematic (R1 series, C1 || R2 shunt, Vo at the node)" class="img-fluid rounded z-depth-1" %}

---

## Transfer function (calculated)

With \(Z_p = R_2 \parallel \frac{1}{j\omega C_1}\), the gain is

\[
H(j\omega) = \frac{V_o}{V_i} = \frac{Z_p}{R_1 + Z_p}
\]

Using \(Z_p = \frac{R_2}{1 + j\omega R_2 C_1}\):

\[
H(j\omega)=\frac{R_2}{R_1 + R_2 + j\omega R_1 R_2 C_1}
\]

For \(R_1 = R_2 = R\):

\[
H(j\omega)=\frac{\tfrac{1}{2}}{1 + j\omega\tfrac{RC_1}{2}}
\]

So the low-frequency gain is \(A_v(\text{LF}) = 0.5\) (\(-6.02\,\text{dB}\)), and the 3 dB frequency is

\[
f_H = \frac{1}{\pi R C_1}
\]

---

## Measurement setup

- **Bode sweep:** 10 Hz → 100 kHz (log sweep)
- **Stimulus:** 1 V sine (WaveForms wavegen)
- **Acquisition:** WaveForms Network Analyzer (gain magnitude + phase)

{% include figure.liquid loading="eager" path="assets/img/ee319/lab-01/lpf/bode-waveforms.png" title="WaveForms measured Bode plot (magnitude + phase)" class="img-fluid rounded z-depth-1" %}

---

## Results

### Frequency response overlays (calculated vs LTspice vs measured)

<div class="row justify-content-sm-center">
  <div class="col-sm-6 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee319/lab-01/lpf/bode-magnitude.jpg" title="Magnitude response overlay" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm-6 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee319/lab-01/lpf/bode-phase.jpg" title="Phase response overlay" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  MATLAB overlays of the calculated transfer function, LTspice AC simulation, and the measured WaveForms Bode sweep.
</div>

### Key parameters

| Parameter          | Calculated |  LTspice | Measured | Units |
| ------------------ | ---------: | -------: | -------: | ----- |
| \(A_v(\text{LF})\) |   500.0000 | 500.0000 | 498.0422 | mV/V  |
| \(A_v(\text{LF})\) |    -6.0206 |  -6.0206 |  -6.0547 | dB    |
| \(f_H\)            |     9.6458 |   9.6458 |   9.4945 | kHz   |

**Measured vs calculated error:**

- \(A_v(\text{LF})\): 0.39% (mV/V)
- \(f_H\): 1.57%

---

## Time-domain snapshots

Scope captures show the expected behavior: near-constant attenuation \(\approx 0.5\) at low frequency, \(\approx -45^\circ\) around \(f_H\), and strong attenuation with phase approaching \(-90^\circ\) at high frequency.

<swiper-container keyboard="true" navigation="true" pagination="true" pagination-clickable="true" pagination-dynamic-bullets="true" rewind="true">
  <swiper-slide>
    {% include figure.liquid loading="eager" path="assets/img/ee319/lab-01/lpf/scope-10Hz.png" title="10 Hz: output ~0.497 V, phase ~0°" class="img-fluid rounded z-depth-1" %}
  </swiper-slide>
  <swiper-slide>
    {% include figure.liquid loading="eager" path="assets/img/ee319/lab-01/lpf/scope-fH.png" title="fH = 9.4945 kHz: output ~0.352 V, phase ~-44.45°" class="img-fluid rounded z-depth-1" %}
  </swiper-slide>
  <swiper-slide>
    {% include figure.liquid loading="eager" path="assets/img/ee319/lab-01/lpf/scope-100kHz.png" title="100 kHz: output ~0.0469 V, phase ~-83°" class="img-fluid rounded z-depth-1" %}
  </swiper-slide>
</swiper-container>

---

## Notes

- The **calculated** and **LTspice** curves match essentially perfectly (ideal components).
- The **measured** curve tracks the expected 1st-order response closely; the small shift in \(f_H\) is consistent with component tolerance + measurement non-idealities (source/output impedance, parasitics, etc.).
