---
layout: page
title: Design of an 8 GHz Negative-Resistance Oscillator Using ATF-33143 GaAs pHEMT
description: EE-456 Design Project 05 -- 8 GHz Negative-Resistance Oscillator Using ATF-33143 GaAs pHEMT.
importance: 3
date: 2025-05-08 03:46:00-0500
inline: false
related_posts: true
show_on_home: false
tags: RF microwave oscillator GaAs pHEMT
category: coursework
---

## Overview

**Course:** EE-456 Microwave Active Circuits
**Project:** Design Project 05
**Author:** Steven Placzek
**Date:** 2025-05-08 03:46:00-0500

I've published **EE-456 (RF & mm-Wave Active Circuits) — Design Project 05**: an **8 GHz negative-resistance oscillator** built around the **Avago ATF-33143 GaAs pHEMT** (biased at **V<sub>DS</sub> = 4 V**, **I<sub>DS</sub> = 80 mA**) using **common-gate topology with inductive gate feedback**.

The focus here is **oscillator synthesis via S-parameter manipulation**: converting the device to a common-gate configuration, introducing deliberate instability through feedback, and designing transmission-line termination/resonator networks to satisfy the oscillation conditions.

---

## Design targets

- **Oscillation frequency:** 8 GHz
- **Device:** ATF-33143 GaAs pHEMT in common-gate configuration
- **Feedback element:** Optimized gate reactance X<sub>B</sub> to maximize \|S<sub>11</sub>\|
- **Termination network:** Series line + shunt short-circuited stub at drain
- **Resonator network:** Series line + shunt open-circuited stub at source
- **Goal:** Achieve \|Γ<sub>in</sub> · Γ<sub>R</sub>\| > 1 with proper phase alignment

---

## What was implemented

### Task 1: Common-Source to Common-Gate Conversion

Starting from the manufacturer's S-parameters (common-source), the indefinite admittance matrix approach was used to convert to common-gate configuration:

$$
\mathbf{Y}_\text{CG} = \begin{bmatrix} Y_{33}^{(I)} & Y_{32}^{(I)} \\ Y_{23}^{(I)} & Y_{22}^{(I)} \end{bmatrix}
$$

The resulting common-gate S-parameters at 8 GHz:

| Parameter | Magnitude | Phase |
|:---------:|:---------:|:-----:|
| S<sub>11</sub> | 1.0823 | −17.95° |
| S<sub>12</sub> | 0.9455 | −26.68° |
| S<sub>21</sub> | 1.9676 | +96.82° |
| S<sub>22</sub> | 1.3885 | +81.73° |

### Task 2: Optimum Feedback Reactance

A parametric sweep over X<sub>B</sub> ∈ [−300, +300] Ω determined the value that maximizes \|S<sub>11</sub>\|:

$$
X_{B,\text{opt}} = +130\ \Omega \quad \Rightarrow \quad L_B = \frac{X_B}{2\pi f_0} = 2.586\ \text{nH}
$$

With optimum feedback applied:

| Parameter | Magnitude | Phase |
|:---------:|:---------:|:-----:|
| S<sub>11</sub> | 1.2295 | +17.05° |
| S<sub>12</sub> | 1.2486 | −12.55° |
| S<sub>21</sub> | 1.4692 | +123.23° |
| S<sub>22</sub> | 1.4487 | +102.96° |

{% include figure.liquid loading="eager" path="assets/img/ee456/design05/calculations_page1.png" class="img-fluid rounded z-depth-1" caption="Hand calculations: S-parameter conversion, feedback optimization, and termination network design." %}

### Task 3: Transmission-Line Feedback Implementation

The lumped inductor L<sub>B</sub> was replaced with a short-circuited transmission line stub:

$$
\theta_x = \arctan\left(\frac{Z_0}{X_B}\right) = \arctan\left(\frac{50}{130}\right) = 21.04°
$$

Physical dimensions at 8 GHz:
- Electrical length: θ<sub>x</sub> = 21.04°
- Physical length: ℓ = 2.190 mm
- Normalized length: d/λ = 0.0584

### Task 4: Termination Network Design

The drain termination network consists of a series transmission line followed by a shunt short-circuited stub. The target reflection coefficient:

$$
\Gamma_T = 0.7500 \angle{-126°}
$$

Using a 2D parameter sweep over (θ<sub>s</sub>, θ<sub>p</sub>), the optimal electrical lengths were found:

| Element | Electrical Length |
|:--------|:-----------------:|
| Series line (θ<sub>T1</sub>) | 48.996° |
| Shunt stub (θ<sub>T2</sub>) | 11.896° |

{% include figure.liquid loading="eager" path="assets/img/ee456/design05/gamma_t_contours.png" class="img-fluid rounded z-depth-1" caption="Phase contours of Γ<sub>T</sub> over the (θ<sub>s</sub>, θ<sub>p</sub>) design space for the termination network." %}

### Task 5: Resonator Network Design

The source resonator network uses a series line and shunt open-circuited stub to present the required reflection coefficient:

$$
\Gamma_R = 0.7500 \angle{+162.73°}
$$

Optimized electrical lengths:

| Element | Electrical Length |
|:--------|:-----------------:|
| Series line (θ<sub>R1</sub>) | 22.28° |
| Shunt stub (θ<sub>R2</sub>) | 0.58° |

{% include figure.liquid loading="eager" path="assets/img/ee456/design05/calculations_page2.png" class="img-fluid rounded z-depth-1" caption="Hand calculations: Resonator network design and final Γ<sub>in</sub> verification." %}

### Task 6: Input Reflection Coefficient Verification

With the termination network connected to the feedback-enhanced common-gate device:

$$
\Gamma_\text{in} = S_{11} + \frac{S_{12} S_{21} \Gamma_T}{1 - S_{22} \Gamma_T} = 0.1057 \angle{-96.1°}
$$

---

## Summary of Results

| Parameter | Calculated | Unit |
|:----------|:----------:|:----:|
| X<sub>B</sub> | 130 | Ω |
| θ<sub>x</sub> | 21.04 | ° |
| Γ<sub>T</sub> | 0.7500 ∠ −126° | — |
| θ<sub>T1</sub> (series) | 48.996 | ° |
| θ<sub>T2</sub> (shunt) | 11.896 | ° |
| Γ<sub>R</sub> | 0.7500 ∠ +162.73° | — |
| θ<sub>R1</sub> (series) | 22.28 | ° |
| θ<sub>R2</sub> (shunt) | 0.58 | ° |
| Γ<sub>in</sub> | 0.1057 ∠ −96.1° | — |

---

## Design Approach

The oscillator design follows the **negative-resistance** methodology:

1. **Device configuration:** Common-gate topology naturally provides higher \|S<sub>11</sub>\| than common-source, making it easier to achieve the required instability condition.

2. **Feedback optimization:** Inductive feedback at the gate further increases \|S<sub>11</sub>\| beyond unity, creating the potential for negative resistance at the input port.

3. **Termination network:** The drain termination is designed to present Γ<sub>T</sub> such that when combined with the device S-parameters, the resulting Γ<sub>in</sub> has magnitude sufficient for oscillation.

4. **Resonator network:** The source resonator must satisfy both magnitude and phase conditions:
   - \|Γ<sub>in</sub> · Γ<sub>R</sub>\| > 1 (start-up condition)
   - ∠(Γ<sub>in</sub> · Γ<sub>R</sub>) = 0° (resonance condition)

---

## What's included in the repo

- **MATLAB synthesis code:** Complete implementation including S-parameter conversion, feedback optimization sweeps, stability factor analysis, and network parameter extraction
- **Touchstone files:** ATF-33143 S-parameters at the specified bias point
- **Contour plots:** 2D parameter sweeps showing Γ<sub>T</sub> and Γ<sub>R</sub> magnitude/phase over the design space
- **Hand calculations:** Detailed derivations for all six design tasks

---

## Key Takeaways

This project demonstrates the systematic approach to negative-resistance oscillator design:

- The indefinite admittance matrix technique provides a clean method for converting between device configurations without re-measurement
- Parametric sweeps over feedback reactance reveal the optimal operating point for maximum instability
- Transmission-line implementations of reactive elements offer practical realizability at microwave frequencies
- The interplay between termination and resonator networks requires careful phase management to satisfy oscillation conditions

The final design achieves \|Γ<sub>in</sub>\| ≈ 0.106, which when combined with the resonator reflection coefficient magnitude of 0.75, would require additional gain margin for reliable oscillation startup. In practice, the device would be operated slightly deeper into the potentially unstable region.