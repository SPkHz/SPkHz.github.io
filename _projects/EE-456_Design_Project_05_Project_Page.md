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
**Project:** Design Project 05  
**Author:** Steven Placzek  
**Frequency:** 8 GHz (**Z<sub>0</sub> = 50 Ω**)  
**Device / bias:** ATF-33143 GaAs pHEMT @ **V<sub>DS</sub> = 4 V**, **I<sub>DS</sub> = 80 mA**  
**Tooling:** MATLAB (Touchstone I/O, indefinite-admittance conversion, parameter sweeps)

Goal: synthesize an **8 GHz negative-resistance oscillator** by (1) converting manufacturer **common-source** S-parameters to **common-gate**, (2) adding **gate feedback reactance** to increase ∣S<sub>11</sub>∣, and (3) designing **termination** and **resonator** transmission-line networks that realize target reflection coefficients and enable verification of **Γ<sub>in</sub>** and **Z<sub>in</sub>**.

---

## Design targets

- **f<sub>0</sub>:** 8 GHz, **Z<sub>0</sub> = 50 Ω**
- **Convert** common-source → **common-gate** (indefinite-admittance method)
- **Optimize** feedback reactance **X<sub>B</sub>** to maximize **∣S<sub>11</sub>∣** (common-gate)
- **Implement** X<sub>B</sub> with an **ideal transmission-line stub**
- **Synthesize**:
  - **Drain termination** to realize **Γ<sub>T</sub>**
  - **Source resonator** to realize **Γ<sub>R</sub>**
- **Verify** the termination-attached input condition:

\[
\Gamma*{\text{in}} = S*{11} + \frac{S*{12}S*{21}\,\Gamma*T}{1 - S*{22}\Gamma_T}
\]

Oscillation (negative-resistance view) requires:

- **Start-up:** \(\lvert\Gamma\_{\text{in}}\Gamma_R\rvert > 1\)
- **Phase closure:** \(\angle(\Gamma\_{\text{in}}\Gamma_R)=0\) (mod \(2\pi\))

---

## Implementation and results (8 GHz)

### Task 1 — Common-source → common-gate conversion

Starting from the ATF-33143 Touchstone file (common-source), convert S→Y, form the **3×3 indefinite admittance matrix**, select the **gate** as the new common reference, then convert back Y→S.

S→Y conversion used:
\[
\mathbf{Y} = Y_0\,(\mathbf{I}-\mathbf{S})\,(\mathbf{I}+\mathbf{S})^{-1},\qquad Y_0=\frac{1}{Z_0}
\]

Indefinite admittance matrix:
\[
\mathbf{Y}^{(I)} = \begin{bmatrix}
Y*{11} & Y*{12} & -Y*{11}-Y*{12}\\
Y*{21} & Y*{22} & -Y*{21}-Y*{22}\\
-Y*{11}-Y*{21} & -Y*{12}-Y*{22} & Y*{11}+Y*{12}+Y*{21}+Y*{22}
\end{bmatrix}
\]

Common-gate extraction (gate = node 1 as common):
\[
\mathbf{Y}_{\text{CG}} = \begin{bmatrix}
Y_{33}^{(I)} & Y*{32}^{(I)}\\
Y*{23}^{(I)} & Y\_{22}^{(I)}
\end{bmatrix}
\]

**Common-source S-parameters @ 8 GHz (Touchstone):**

|   Parameter    | Magnitude |  Phase  |
| :------------: | :-------: | :-----: |
| S<sub>11</sub> |  0.7373   | +84.18° |
| S<sub>12</sub> |  0.1486   | −33.05° |
| S<sub>21</sub> |  1.7979   | −22.87° |
| S<sub>22</sub> |  0.2815   | +83.13° |

**Common-gate S-parameters @ 8 GHz:**

|   Parameter    | Magnitude |  Phase  |
| :------------: | :-------: | :-----: |
| S<sub>11</sub> |  1.0823   | −17.95° |
| S<sub>12</sub> |  0.9455   | −26.68° |
| S<sub>21</sub> |  1.9676   | +96.82° |
| S<sub>22</sub> |  1.3885   | +81.73° |

---

### Task 2 — Optimum gate feedback reactance

Sweep \(X*B\in[-300,+300]~\Omega\) and maximize \(\lvert S*{11}\rvert\) after adding feedback admittance:

\[
\mathbf{Y}_{\text{FB}} = \begin{bmatrix}
Y_{fb} & -Y*{fb}\\
-Y*{fb} & Y*{fb}
\end{bmatrix},\qquad Y*{fb}=\frac{1}{jX_B}
\]

Result:
\[
X\_{B,\text{opt}}=+130~\Omega
\]
Equivalent inductance at 8 GHz:
\[
L_B=\frac{X_B}{2\pi f_0}=\frac{130}{2\pi\cdot 8\times 10^9}=2.586\ \text{nH}
\]

Common-gate S-parameters with optimum feedback @ 8 GHz:

|   Parameter    | Magnitude |  Phase   |
| :------------: | :-------: | :------: |
| S<sub>11</sub> |  1.2295   | +17.05°  |
| S<sub>12</sub> |  1.2486   | −12.55°  |
| S<sub>21</sub> |  1.4692   | +123.23° |
| S<sub>22</sub> |  1.4487   | +102.96° |

---

### Task 3 — Transmission-line implementation of the feedback element

Replace the lumped reactance with an ideal TL stub (\(Z_0=50~\Omega\)) by matching the required susceptance:

\[
B\_{\text{stub}} = Y_0\tan(\theta_x)=\frac{1}{X_B}
\]
\[
\theta_x=\arctan\left(\frac{Z_0}{X_B}\right)=\arctan\left(\frac{50}{130}\right)=21.04^{\circ}
\]

Using \(\lambda=c/f_0\approx 37.47\ \text{mm}\) at 8 GHz (ideal propagation):
\[
\ell=\frac{\theta_x}{360^{\circ}}\lambda=2.190\ \text{mm},\qquad \frac{d}{\lambda}=0.0584
\]

---

### Task 4 — Drain termination network (Γ<sub>T</sub>)

A transmission-line termination network (series line + shunt shorted stub) was synthesized to realize the target drain reflection coefficient:

\[
\Gamma_T = 0.5000\angle 162.019^{\circ}
\]

Reflection coefficient ↔ impedance mapping used:
\[
Z_T = Z_0\,\frac{1+\Gamma_T}{1-\Gamma_T}
\]
Numerical result:
\[
Z_T = (17.0365 + j\,7.0123)\ \Omega
\]
Normalized and inverted (for Smith/admittance workflows):
\[
z_T=\frac{Z_T}{Z_0}=0.3407+j0.1402,\qquad y_T=\frac{1}{z_T}=2.5097-j1.0330
\]

The final TL parameters were selected from MATLAB sweep/contours (see plots).

---

### Task 5 — Source resonator network (Γ<sub>R</sub>)

A transmission-line resonator network (series line + shunt open stub) was synthesized to realize:

\[
\Gamma_R = 0.7500\angle (-127.733^{\circ})
\]

Equivalent impedance for reference:
\[
Z_R = Z_0\,\frac{1+\Gamma_R}{1-\Gamma_R}=(8.8189 - j\,23.9129)\ \Omega
\]

---

### Task 6 — Verification with termination attached

With the termination attached to the feedback-enhanced common-gate network:

\[
\Gamma*{\text{in}} = S*{11} + \frac{S*{12}S*{21}\,\Gamma*T}{1 - S*{22}\Gamma_T}
\]

Computed (course method at 8 GHz):

- \(\Gamma\_{\text{in}} = 0.8403\angle(-17.172^{\circ})\)
- \(Z*{\text{in}} = Z_0\,\frac{1+\Gamma*{\text{in}}}{1-\Gamma\_{\text{in}}}\approx (146.33 - j\,247.05)\ \Omega\)
- Extracted term (course method): \(\tilde{Z}\_R \approx 8.8188\ \Omega\)

Start-up check (magnitude only):
\[
\lvert\Gamma\_{\text{in}}\Gamma_R\rvert\approx 0.8403\times 0.75 \approx 0.63 < 1
\]

---

## Results summary

| Parameter      |              Value | Notes                                            |
| -------------- | -----------------: | ------------------------------------------------ |
| X<sub>B</sub>  |              130 Ω | maximizes \(\lvert S\_{11}\rvert\) (common-gate) |
| L<sub>B</sub>  |           2.586 nH | equivalent at 8 GHz                              |
| θ<sub>x</sub>  |             21.04° | feedback stub electrical length                  |
| Γ<sub>T</sub>  |  0.5000 ∠ 162.019° | drain termination target                         |
| Γ<sub>R</sub>  | 0.7500 ∠ −127.733° | source resonator target                          |
| Γ<sub>in</sub> |  0.8403 ∠ −17.172° | with termination attached                        |
| Z<sub>in</sub> | 146.33 − j247.05 Ω | derived from Γ<sub>in</sub>                      |
| Z̃<sub>R</sub>  |           8.8188 Ω | extracted term (course method)                   |

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
    {% include figure.liquid loading="eager" path="assets/img/ee456/design05/gammaT_contours.png" title="ΓT contour sweep (series-line + shunt-stub)" class="img-fluid rounded z-depth-1" %}
  </swiper-slide>
  <swiper-slide>
    {% include figure.liquid loading="eager" path="assets/img/ee456/design05/gammaT_contours_raw.png" title="Raw MATLAB sweep output (reference capture)" class="img-fluid rounded z-depth-1" %}
  </swiper-slide>
</swiper-container>

---

## Repository Contents

- MATLAB scripts: indefinite-Y conversion, feedback sweep, stability metrics, Γ sweeps/contours
- Touchstone file(s): ATF-33143 S-parameters at the specified bias
- Exported figures: \(\lvert S\_{11}\rvert\) sweep, stability factors, Γ sweeps/contours
- Hand-calculation scans used in the write-up
