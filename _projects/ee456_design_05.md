---
layout: page
title: EE-456 Design Project 05 — 8 GHz Oscillator (ATF-33143) via Negative Resistance
description: Negative-resistance oscillator synthesis at 8 GHz using common-gate conversion, feedback-reactance optimization, and transmission-line termination/resonator networks (MATLAB • Touchstone).
img: /assets/img/ee456/design05/thumbnail.png
importance: 1
category: coursework
date: 2025-05-08
tags: RF microwave oscillator GaAs pHEMT negative-resistance MATLAB
giscus_comments: false
related_publications: false
pretty_table: true
images:
  slider: true
_styles: |
  .post article .mjx-container[display="true"] {
    font-size: 1.3em;
    margin: 0.9em 0 1.1em;
  }
  .post article .mjx-container {
    font-size: 1.12em;
  }
---

## Overview

**Course:** EE-456 RF & Microwave Active Circuit Design
**Project:** Design Project 05 - 8 GHz Negative-Resistance Oscillator
**Author:** Steven Placzek
**Date:** 2025-05-08
**Frequency:** 8 GHz  
**Device / bias:** ATF-33143 GaAs pHEMT @ **V<sub>DS</sub> = 4 V**, **I<sub>DS</sub> = 80 mA**  
**Tooling:** MATLAB (Touchstone I/O, indefinite-admittance conversion, parameter sweeps)

This project follows the **negative-resistance oscillator workflow** used in EE-456/556: convert the device to **common-gate**, add **gate feedback reactance** to drive the input toward instability, then synthesize **termination** and **resonator** networks (ideal transmission lines) to realize target reflection coefficients and verify the resulting **Γ<sub>in</sub>** and **Z<sub>in</sub>** at 8 GHz.

---

## Design targets

- **f<sub>0</sub>:** 8 GHz, **Z<sub>0</sub> = 50 Ω**
- **Convert** common-source S-parameters → **common-gate**
- **Optimize** gate feedback reactance **X<sub>B</sub>** to maximize **|S<sub>11</sub>|** (common-gate)
- **Replace** X<sub>B</sub> with an **ideal short-circuited transmission-line stub**
- **Synthesize**:
  - **Drain termination network** to realize **Γ<sub>T</sub>**
  - **Source resonator network** to realize **Γ<sub>R</sub>**
- **Verify** **Γ<sub>in</sub>** and **Z<sub>in</sub>** with the termination attached

Core relationship used for verification:
\[
\Gamma_{\text{in}} = S_{11} + \frac{S_{12}S_{21}\Gamma_T}{1 - S_{22}\Gamma_T}
\]

---

## Implementation and results (8 GHz)

### Task 1 — Common-source → common-gate conversion

Starting from the ATF-33143 Touchstone file (common-source), the device was converted to **common-gate** using the **indefinite admittance matrix** method and then converted back to S-parameters.

**Common-source S-parameters @ 8 GHz (from Touchstone):**

| Parameter | Magnitude | Phase |
|:--:|:--:|:--:|
| S<sub>11</sub> | 0.7373 | +84.18° |
| S<sub>12</sub> | 0.1486 | −33.05° |
| S<sub>21</sub> | 1.7979 | −22.87° |
| S<sub>22</sub> | 0.2815 | +83.13° |

**Common-gate S-parameters @ 8 GHz:**

| Parameter | Magnitude | Phase |
|:--:|:--:|:--:|
| S<sub>11</sub> | 1.0823 | −17.95° |
| S<sub>12</sub> | 0.9455 | −26.68° |
| S<sub>21</sub> | 1.9676 | +96.82° |
| S<sub>22</sub> | 1.3885 | +81.73° |

---

### Task 2 — Optimum gate feedback reactance

A sweep of **X<sub>B</sub> ∈ [−300, +300] Ω** was used to maximize **|S<sub>11</sub>|** in common-gate.

- **X<sub>B,opt</sub> = +130 Ω**
- Equivalent lumped inductance at 8 GHz:
  - **L<sub>B</sub> = X<sub>B</sub> / (2πf<sub>0</sub>) = 2.586 nH**

**Common-gate S-parameters with optimum X<sub>B</sub> @ 8 GHz:**

| Parameter | Magnitude | Phase |
|:--:|:--:|:--:|
| S<sub>11</sub> | 1.2295 | +17.05° |
| S<sub>12</sub> | 1.2486 | −12.55° |
| S<sub>21</sub> | 1.4692 | +123.23° |
| S<sub>22</sub> | 1.4487 | +102.96° |

---

### Task 3 — Replace X<sub>B</sub> with a short-circuited transmission-line stub

The optimum reactance was realized using an **ideal short-circuited stub** (Z<sub>0</sub> = 50 Ω). Electrical length at 8 GHz:

- **θ<sub>x</sub> = 0.3672 rad = 21.04°**
- **d/λ = 0.0584**
- **ℓ = 2.190 mm** (ideal line assumption; physical length depends on actual propagation velocity if implemented on a substrate)

---

### Task 4 — Drain termination network (Γ<sub>T</sub>)

A transmission-line termination network (series-line + shunt shorted-stub, explored via sweep/contours) was synthesized to realize the target:

- **Γ<sub>T</sub> = 0.5000 ∠ 162.019°**

(See contour plot in the slider below.)

---

### Task 5 — Source resonator network (Γ<sub>R</sub>)

A transmission-line resonator network (series-line + shunt open-stub, explored via sweep/contours / hand calcs) was synthesized to realize:

- **Γ<sub>R</sub> = 0.7500 ∠ −127.733°**

---

### Task 6 — Verification with termination attached

With the termination network attached to the feedback-enhanced common-gate network:

- **Z<sub>in</sub> = 146.305 Ω**
- **Γ<sub>in</sub> = 0.8403 ∠ −17.172°**
- Extracted term (per course method): **Z̃<sub>R</sub> = 8.8188 Ω**

Note: A complete oscillator design would additionally check the start-up/phase conditions (e.g., magnitude and phase closure around the loop). This page documents the synthesis steps and extracted Γ/Z results at 8 GHz.

---

## Results summary (MATLAB)

| Parameter | Value | Notes |
| --- | ---: | --- |
| X<sub>B</sub> | 130 Ω | Maximizes \|S<sub>11</sub>\| (common-gate) |
| θ<sub>x</sub> | 0.3672 rad (21.04°) | Feedback stub electrical length |
| Γ<sub>T</sub> | 0.5000 ∠ 162.019° | Drain termination reflection coefficient |
| Z<sub>in</sub> | 146.305 Ω | With termination attached |
| Γ<sub>in</sub> | 0.8403 ∠ −17.172° | With termination attached |
| Z̃<sub>R</sub> | 8.8188 Ω | Extracted term (course method) |
| Γ<sub>R</sub> | 0.7500 ∠ −127.733° | Source resonator reflection coefficient |

---

## Plots

<swiper-container keyboard="true" navigation="true" pagination="true" pagination-clickable="true" pagination-dynamic-bullets="true" rewind="true">
  <swiper-slide>
    {% include figure.liquid loading="eager" path="assets/img/ee456/design05/s11_vs_xb.png" title="|S11| vs. feedback reactance (common-gate)" class="img-fluid rounded z-depth-1" %}
  </swiper-slide>
  <swiper-slide>
    {% include figure.liquid loading="eager" path="assets/img/ee456/design05/stability_vs_xb.png" title="Stability factors vs. feedback reactance" class="img-fluid rounded z-depth-1" %}
  </swiper-slide>
  <swiper-slide>
    {% include figure.liquid loading="eager" path="assets/img/ee456/design05/gammaT_contours.png" title="ΓT contour sweep (series-line + shunt-stub) over the design space" class="img-fluid rounded z-depth-1" %}
  </swiper-slide>
  <swiper-slide>
    {% include figure.liquid loading="eager" path="assets/img/ee456/design05/gammaT_contours_raw.png" title="Raw MATLAB sweep output (reference capture)" class="img-fluid rounded z-depth-1" %}
  </swiper-slide>
</swiper-container>

---

## Hand calculations

<div class="row">
  <div class="col-md-6">
    {% include figure.liquid loading="eager" path="assets/img/ee456/design05/calculations_page1.png" class="img-fluid rounded z-depth-1" caption="Hand calculations (page 1): conversion + feedback + termination work." %}
  </div>
  <div class="col-md-6">
    {% include figure.liquid loading="eager" path="assets/img/ee456/design05/calculations_page2.png" class="img-fluid rounded z-depth-1" caption="Hand calculations (page 2): resonator work + verification notes." %}
  </div>
</div>

---

## Repository Contents

- MATLAB synthesis/verification script(s): indefinite-Y conversion, feedback sweep, stability metrics, Γ sweeps
- Touchstone file(s): ATF-33143 S-parameters at the specified bias
- Exported figures: \|S<sub>11</sub>\| sweep, stability factors, Γ sweeps/contours
- Hand-calculation scans used in the write-up
