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
**Project:** Design Project 05 — 8 GHz Negative-Resistance Oscillator  
**Author:** Steven Placzek  
**Date:** 2025-05-08  
**Frequency:** 8 GHz  
**Device / Bias:** ATF-33143 GaAs pHEMT @ $$V_{DS} = 4\ \text{V}$$, $$I_{DS} = 80\ \text{mA}$$  
**Tooling:** MATLAB (Touchstone I/O, indefinite-admittance conversion, parameter sweeps)

This project follows the **negative-resistance oscillator workflow**: convert the device to **common-gate**, add **gate feedback reactance** to drive the input toward instability, then synthesize **termination** and **resonator** networks (ideal transmission lines) to realize target reflection coefficients and verify the resulting $$\Gamma_{\text{in}}$$ and $$Z_{\text{in}}$$ at 8 GHz.

---

## Design Targets

- $$f_0 = 8\ \text{GHz}$$, $$Z_0 = 50\ \Omega$$
- **Convert** common-source S-parameters → **common-gate**
- **Optimize** gate feedback reactance $$X_B$$ to maximize $$\lvert S_{11}\rvert$$ (common-gate)
- **Replace** $$X_B$$ with an **ideal short-circuited transmission-line stub**
- **Synthesize:**
  - **Drain termination network** to realize $$\Gamma_T$$
  - **Source resonator network** to realize $$\Gamma_R$$
- **Verify** $$\Gamma_{\text{in}}$$ and $$Z_{\text{in}}$$ with the termination attached

Core relationship used for verification:

$$
\Gamma_{\text{in}} = S_{11} + \frac{S_{12}S_{21}\Gamma_T}{1 - S_{22}\Gamma_T}
$$

---

## Task 1 — Common-Source → Common-Gate Conversion

Starting from the ATF-33143 Touchstone file (common-source), the device was converted to **common-gate** using the **indefinite admittance matrix** method.

### Conversion Method

First, compute the 2-port Y-parameters from common-source S-parameters:

$$
\mathbf{Y} = Y_0 (\mathbf{I} - \mathbf{S})(\mathbf{I} + \mathbf{S})^{-1}
$$

Expand to the 3×3 indefinite admittance matrix by enforcing current conservation at each node:

$$
\mathbf{Y}^{(I)} = \begin{bmatrix} Y_{11} & Y_{12} & -(Y_{11}+Y_{12}) \\ Y_{21} & Y_{22} & -(Y_{21}+Y_{22}) \\ -(Y_{11}+Y_{21}) & -(Y_{12}+Y_{22}) & Y_{11}+Y_{12}+Y_{21}+Y_{22} \end{bmatrix}
$$

Extract common-gate parameters by selecting the gate (node 1) as the new common terminal:

$$
\mathbf{Y}_{\text{CG}} = \begin{bmatrix} Y_{33}^{(I)} & Y_{32}^{(I)} \\ Y_{23}^{(I)} & Y_{22}^{(I)} \end{bmatrix}
$$

Convert back to S-parameters:

$$
\mathbf{S}_{\text{CG}} = (\mathbf{I} - Z_0\mathbf{Y}_{\text{CG}})(\mathbf{I} + Z_0\mathbf{Y}_{\text{CG}})^{-1}
$$

### Results

**Common-source S-parameters @ 8 GHz (from Touchstone):**

| Parameter | Magnitude | Phase |
|:--:|:--:|:--:|
| $$S_{11}$$ | 0.7373 | +84.18° |
| $$S_{12}$$ | 0.1486 | −33.05° |
| $$S_{21}$$ | 1.7979 | −22.87° |
| $$S_{22}$$ | 0.2815 | +83.13° |

**Common-gate S-parameters @ 8 GHz:**

| Parameter | Magnitude | Phase |
|:--:|:--:|:--:|
| $$S_{11}$$ | 1.0823 | −17.95° |
| $$S_{12}$$ | 0.9455 | −26.68° |
| $$S_{21}$$ | 1.9676 | +96.82° |
| $$S_{22}$$ | 1.3885 | +81.73° |

---

## Task 2 — Optimum Gate Feedback Reactance

A parametric sweep of $$X_B \in [-300, +300]\ \Omega$$ was used to maximize $$\lvert S_{11}\rvert$$ in common-gate configuration.

### Feedback Analysis

The feedback admittance matrix added to the common-gate Y-matrix:

$$
\mathbf{Y}_{\text{FB}} = \begin{bmatrix} Y_{fb} & -Y_{fb} \\ -Y_{fb} & Y_{fb} \end{bmatrix}, \quad Y_{fb} = \frac{1}{jX_B}
$$

Combined Y-matrix with feedback:

$$
\mathbf{Y}_{\text{total}} = \mathbf{Y}_{\text{CG}} + \mathbf{Y}_{\text{FB}}
$$

### Optimum Result

$$
\boxed{X_{B,\text{opt}} = +130\ \Omega}
$$

Equivalent lumped inductance at 8 GHz:

$$
L_B = \frac{X_B}{2\pi f_0} = \frac{130}{2\pi \cdot 8 \times 10^9} = 2.586\ \text{nH}
$$

**Common-gate S-parameters with optimum $$X_B$$ @ 8 GHz:**

| Parameter | Magnitude | Phase |
|:--:|:--:|:--:|
| $$S_{11}$$ | 1.2295 | +17.05° |
| $$S_{12}$$ | 1.2486 | −12.55° |
| $$S_{21}$$ | 1.4692 | +123.23° |
| $$S_{22}$$ | 1.4487 | +102.96° |

---

## Task 3 — Transmission-Line Feedback Implementation

The optimum reactance was realized using an **ideal short-circuited stub** ($$Z_0 = 50\ \Omega$$).

### Stub Design

For a short-circuited stub, the input impedance is:

$$
Z_{\text{SC}} = jZ_0 \tan(\theta_x)
$$

Setting $$Z_{\text{SC}} = jX_B$$:

$$
\theta_x = \arctan\left(\frac{X_B}{Z_0}\right) = \arctan\left(\frac{130}{50}\right)
$$

### Results

$$
\boxed{\theta_x = 0.3672\ \text{rad} = 21.04°}
$$

Physical dimensions at 8 GHz (free-space wavelength $$\lambda_0 = c/f_0 = 37.47\ \text{mm}$$):

$$
\frac{d}{\lambda} = \frac{\theta_x}{2\pi} = 0.0584
$$

$$
\ell = \frac{\theta_x}{2\pi} \cdot \lambda_0 = 2.190\ \text{mm}
$$

*(Physical length depends on actual propagation velocity if implemented on a substrate.)*

---

## Task 4 — Drain Termination Network

A transmission-line termination network (series-line + shunt shorted-stub) was synthesized to realize the target reflection coefficient.

### Network Topology

```
         θ_T2
          ┃
    ──────┨──────○ Port
    θ_T1  ┃  Z_0
          ┃
         ═╧═ (SC)
```

### Target

$$
\boxed{\Gamma_T = 0.5000 \angle 162.019°}
$$

### Synthesis

Convert to normalized impedance:

$$
z_T = \frac{1 + \Gamma_T}{1 - \Gamma_T}
$$

$$
y_T = \frac{1}{z_T}
$$

Using single-stub matching, the series line rotates the load admittance on the Smith chart, and the shunt stub cancels the susceptance. The network parameters were determined via contour sweeps over $$(θ_{T1}, θ_{T2})$$ design space (see plots below).

---

## Task 5 — Source Resonator Network

A transmission-line resonator network (series-line + shunt open-stub) was synthesized to realize the conjugate match condition.

### Network Topology

```
         θ_R2
          ┃
    ──────┨──────○ Port
    θ_R1  ┃  Z_0
          ┃
          ○ (OC)
```

### Target

$$
\boxed{\Gamma_R = 0.7500 \angle -127.733°}
$$

### Open-Stub Susceptance

For an open-circuited stub:

$$
Y_{\text{OC}} = jY_0 \tan(\theta_{R2})
$$

$$
B_{\text{OC}} = Y_0 \tan(\theta_{R2})
$$

---

## Task 6 — Verification with Termination Attached

With the termination network connected to the feedback-enhanced common-gate device, the input reflection coefficient is computed using:

$$
\Gamma_{\text{in}} = S_{11} + \frac{S_{12} S_{21} \Gamma_T}{1 - S_{22} \Gamma_T}
$$

### Final Results

$$
\boxed{\Gamma_{\text{in}} = 0.8403 \angle -17.172°}
$$

Converting to input impedance:

$$
Z_{\text{in}} = Z_0 \cdot \frac{1 + \Gamma_{\text{in}}}{1 - \Gamma_{\text{in}}}
$$

$$
\boxed{Z_{\text{in}} = 146.305\ \Omega}
$$

Extracted term (per course method):

$$
\tilde{Z}_R = 8.8188\ \Omega
$$

---

## Results Summary

| Parameter | Value | Notes |
|:--|--:|:--|
| $$X_B$$ | 130 Ω | Maximizes $$\lvert S_{11}\rvert$$ (common-gate) |
| $$L_B$$ | 2.586 nH | Equivalent lumped inductance |
| $$\theta_x$$ | 0.3672 rad (21.04°) | Feedback stub electrical length |
| $$\Gamma_T$$ | $$0.5000 \angle 162.019°$$ | Drain termination reflection coefficient |
| $$Z_{\text{in}}$$ | 146.305 Ω | With termination attached |
| $$\Gamma_{\text{in}}$$ | $$0.8403 \angle -17.172°$$ | With termination attached |
| $$\tilde{Z}_R$$ | 8.8188 Ω | Extracted term (course method) |
| $$\Gamma_R$$ | $$0.7500 \angle -127.733°$$ | Source resonator reflection coefficient |

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

## Design Methodology

The oscillator design follows the **negative-resistance** approach:

1. **Device configuration:** Common-gate topology naturally provides higher $$\lvert S_{11}\rvert$$ than common-source, facilitating the required instability.

2. **Feedback optimization:** Inductive feedback at the gate increases $$\lvert S_{11}\rvert$$ beyond unity, creating negative resistance at the input port.

3. **Termination network:** The drain termination presents $$\Gamma_T$$ such that when combined with device S-parameters, $$\Gamma_{\text{in}}$$ has sufficient magnitude for oscillation.

4. **Resonator network:** Must satisfy both conditions:
   - **Start-up:** $$\lvert\Gamma_{\text{in}} \cdot \Gamma_R\rvert > 1$$
   - **Resonance:** $$\angle(\Gamma_{\text{in}} \cdot \Gamma_R) = 0°$$

---

## Repository Contents

- **MATLAB synthesis scripts:** indefinite-Y conversion, feedback sweep, stability metrics, $$\Gamma$$ sweeps
- **Touchstone file(s):** ATF-33143 S-parameters at the specified bias
- **Exported figures:** $$\lvert S_{11}\rvert$$ sweep, stability factors, $$\Gamma$$ sweeps/contours

---

## Notes

A complete oscillator design would additionally check the start-up/phase conditions (magnitude and phase closure around the loop). This page documents the synthesis steps and extracted $$\Gamma/Z$$ results at 8 GHz. The **indefinite admittance matrix** technique cleanly converts between device configurations without re-measurement, while **transmission-line implementations** provide practical realizability at microwave frequencies.