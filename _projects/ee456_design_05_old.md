---
layout: post
title: "EE-456 Design Project 05 Published: 8 GHz Negative-Resistance Oscillator Using ATF-33143 GaAs pHEMT"
date: 2025-05-08 23:46:00-0500
inline: false
related_posts: true
show_on_home: false
tags: RF microwave oscillator GaAs pHEMT
categories: coursework
---

I've published **EE-456 (RF & mm-Wave Active Circuits) — Design Project 05**: an **8 GHz negative-resistance oscillator** built around the **Avago ATF-33143 GaAs pHEMT** (biased at **V<sub>DS</sub> = 4 V**, **I<sub>DS</sub> = 80 mA**) using **common-gate topology with inductive gate feedback**.

The focus here is **oscillator synthesis via S-parameter manipulation**: converting the device to a common-gate configuration, introducing deliberate instability through feedback, and designing transmission-line termination/resonator networks to satisfy the oscillation conditions.

---

## Design Targets

- **Oscillation frequency:** 8 GHz
- **Device:** ATF-33143 GaAs pHEMT in common-gate configuration
- **Feedback element:** Optimized gate reactance X<sub>B</sub> to maximize \|S<sub>11</sub>\|
- **Termination network:** Series line + shunt short-circuited stub at drain
- **Resonator network:** Series line + shunt open-circuited stub at source
- **Goal:** Achieve \|Γ<sub>in</sub> · Γ<sub>R</sub>\| > 1 with proper phase alignment

---

## Task 1: Common-Source to Common-Gate Conversion

Starting from the manufacturer's S-parameters (common-source), the indefinite admittance matrix approach converts to common-gate configuration. First, compute the 2-port Y-parameters from S-parameters, then expand to a 3×3 indefinite admittance matrix:

$$
\mathbf{Y}^{(I)} = \begin{bmatrix} Y_{11} & Y_{12} & -Y_{11}-Y_{12} \\ Y_{21} & Y_{22} & -Y_{21}-Y_{22} \\ -Y_{11}-Y_{21} & -Y_{12}-Y_{22} & Y_{11}+Y_{12}+Y_{21}+Y_{22} \end{bmatrix}
$$

The common-gate parameters are extracted by selecting the gate (node 1) as the new common terminal:

$$
\mathbf{Y}_\text{CG} = \begin{bmatrix} Y_{33}^{(I)} & Y_{32}^{(I)} \\ Y_{23}^{(I)} & Y_{22}^{(I)} \end{bmatrix}
$$

Converting back to S-parameters yields the **common-gate S-matrix at 8 GHz**:

$$
\mathbf{S}_\text{CG} = \begin{bmatrix} 1.0823 \angle -17.95° & 0.9455 \angle -26.68° \\ 1.9676 \angle +96.82° & 1.3885 \angle +81.73° \end{bmatrix}
$$

---

## Task 2: Optimum Feedback Reactance

A parametric sweep over X<sub>B</sub> ∈ [−300, +300] Ω determines the value maximizing \|S<sub>11</sub>\|. The feedback admittance is added to the common-gate Y-matrix:

$$
\mathbf{Y}_\text{FB} = \begin{bmatrix} Y_{fb} & -Y_{fb} \\ -Y_{fb} & Y_{fb} \end{bmatrix}, \quad Y_{fb} = \frac{1}{jX_B}
$$

**Result:**

$$
X_{B,\text{opt}} = +130\ \Omega
$$

The equivalent inductance:

$$
L_B = \frac{X_B}{2\pi f_0} = \frac{130}{2\pi \cdot 8 \times 10^9} = 2.5863\ \text{nH}
$$

**S-parameters with optimum feedback:**

$$
\mathbf{S}_\text{FB} = \begin{bmatrix} 1.2295 \angle +17.05° & 1.2486 \angle -12.55° \\ 1.4692 \angle +123.23° & 1.4487 \angle +102.96° \end{bmatrix}
$$

---

## Task 3: Transmission-Line Feedback Implementation

Replace the lumped inductor with a short-circuited transmission line stub. The stub susceptance must equal the inductor susceptance:

$$
B_\text{stub} = Y_0 \tan(\theta_x) = \frac{1}{X_B}
$$

Solving for the electrical length:

$$
\theta_x = \arctan\left(\frac{Z_0}{X_B}\right) = \arctan\left(\frac{50}{130}\right) = 21.04°
$$

**Physical dimensions at 8 GHz** (with λ = c/f₀ = 37.47 mm):

$$
\ell = \frac{\theta_x}{360°} \cdot \lambda = 2.190\ \text{mm}, \quad \frac{d}{\lambda} = 0.0584
$$

**Verification of stub parameters:**

$$
B_\text{stub} = Y_0 \tan\left(\frac{\beta \ell}{1}\right) \quad \Rightarrow \quad X_B = -\frac{1}{B_\text{stub}} = 130\ \Omega \ \ \checkmark
$$

**S-parameters with SC stub:**

$$
\mathbf{S}_\text{stub} = \begin{bmatrix} 0.7530 \angle -51.04° & 0.5996 \angle -23.89° \\ 2.0053 \angle +73.77° & 1.084 \angle +66.04° \end{bmatrix}
$$

Normalized impedance/admittance at device input with stub:

$$
z_X = 0.5344 - j0.636, \quad y_X = 0.7742 + j0.9216, \quad Y_\text{stub} = 0.1316 - j0.8008
$$

---

## Task 4: Design Termination Network

The drain termination network uses a series transmission line followed by a shunt short-circuited stub:

```
         θ_T2
          ┃
    ──────┨──────○
    θ_T1  ┃  Z_0
          ┃
         ═╧═ (SC)
```

**Target reflection coefficient:**

$$
\Gamma_T = 0.7500 \angle -126.00°
$$

**Convert to impedance:**

$$
Z_T = Z_0 \cdot \frac{1 + \Gamma_T}{1 - \Gamma_T} = (8.9498 - j24.8248)\ \Omega
$$

**Normalize:**

$$
z_T = \frac{Z_T}{Z_0} = 0.1790 - j0.4965
$$

$$
y_T = \frac{1}{z_T} = 0.6436 + j1.7824
$$

**Smith chart / analytical solution for stub matching:**

Using standard single-stub matching:

$$
d_{T1} = 0.136\lambda \quad \Rightarrow \quad \theta_{T1} = 48.996°
$$

$$
d_{T2} = 0.402\lambda \quad \Rightarrow \quad \theta_{T2} = 11.896°
$$

{% include figure.liquid loading="eager" path="assets/img/ee456/design05/gamma_t_contours.png" class="img-fluid rounded z-depth-1" caption="Phase contours of Γ_T over the (θ_s, θ_p) design space for the termination network." %}

---

## Task 5: Resonator Network Design

The source resonator network uses a series line and shunt **open-circuited** stub:

```
         θ_R2
          ┃
    ──────┨──────○
    θ_R1  ┃  Z_0
          ┃
          ○ (OC)
```

**Target reflection coefficient** (conjugate match to Γ<sub>in</sub>):

$$
\Gamma_R = 0.7500 \angle +162.7335°
$$

**Computed electrical lengths:**

$$
d_{R2} = 0.0024\lambda \quad \Rightarrow \quad \theta_{R2} = 0.5825°
$$

$$
d_{R1} = 0.0619\lambda \quad \Rightarrow \quad \theta_{R1} = 22.2823°
$$

The open-stub susceptance:

$$
B_\text{OC} = -Y_0 \cot(\theta_{R2})
$$

---

## Task 6: Input Reflection Coefficient Verification

With the termination network connected to the feedback-enhanced common-gate device, the input reflection coefficient is:

$$
\Gamma_\text{in} = S_{11} + \frac{S_{12} S_{21} \Gamma_T}{1 - S_{22} \Gamma_T}
$$

**Final result:**

$$
\boxed{\Gamma_\text{in} = 0.1057 \angle -96.1°}
$$

---

## Summary of Results

| Parameter | Calculated | Unit |
|:----------|:----------:|:----:|
| X<sub>B</sub> | 130 | Ω |
| L<sub>B</sub> | 2.5863 | nH |
| θ<sub>x</sub> (feedback stub) | 21.04 | ° |
| Γ<sub>T</sub> | 0.7500 ∠ −126° | — |
| θ<sub>T1</sub> (series line) | 48.996 | ° |
| θ<sub>T2</sub> (shunt SC stub) | 11.896 | ° |
| Γ<sub>R</sub> | 0.7500 ∠ +162.73° | — |
| θ<sub>R1</sub> (series line) | 22.28 | ° |
| θ<sub>R2</sub> (shunt OC stub) | 0.58 | ° |
| Γ<sub>in</sub> | 0.1057 ∠ −96.1° | — |
| Z<sub>in</sub> | — | Ω |

---

## Design Methodology

The oscillator design follows the **negative-resistance** approach:

1. **Device configuration:** Common-gate topology naturally provides higher \|S<sub>11</sub>\| than common-source, facilitating the required instability.

2. **Feedback optimization:** Inductive feedback at the gate increases \|S<sub>11</sub>\| beyond unity, creating negative resistance at the input port.

3. **Termination network:** The drain termination presents Γ<sub>T</sub> such that when combined with device S-parameters, Γ<sub>in</sub> has sufficient magnitude for oscillation.

4. **Resonator network:** Must satisfy both conditions:
   - **Start-up:** \|Γ<sub>in</sub> · Γ<sub>R</sub>\| > 1
   - **Resonance:** ∠(Γ<sub>in</sub> · Γ<sub>R</sub>) = 0°

---

## What's Included in the Repo

- **MATLAB synthesis code:** S-parameter conversion, feedback optimization sweeps, stability factor analysis, and network parameter extraction
- **Touchstone files:** ATF-33143 S-parameters at the specified bias point (V<sub>DS</sub> = 4 V, I<sub>DS</sub> = 80 mA)
- **Contour plots:** 2D parameter sweeps showing Γ<sub>T</sub> magnitude/phase over the design space

---

## Key Takeaways

This project demonstrates systematic negative-resistance oscillator design:

- The **indefinite admittance matrix** technique cleanly converts between device configurations without re-measurement
- **Parametric sweeps** over feedback reactance reveal optimal operating points for maximum instability
- **Transmission-line implementations** of reactive elements provide practical realizability at microwave frequencies
- The interplay between termination and resonator networks requires careful **phase management** to satisfy oscillation conditions

The final design achieves \|Γ<sub>in</sub>\| ≈ 0.106, which combined with the resonator \|Γ<sub>R</sub>\| = 0.75 yields \|Γ<sub>in</sub> · Γ<sub>R</sub>\| ≈ 0.08—below the start-up threshold. In practice, the device would be biased deeper into the potentially unstable region or the feedback adjusted for additional gain margin.