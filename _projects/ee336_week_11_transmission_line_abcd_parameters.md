---
layout: page
title: EE-336 Transmission Line ABCD Parameters
description: 100-mile transmission line analysis using two-port ABCD parameters and the nominal π-model (60 Hz power system).
img: /assets/img/ee336/assignment-11/phasor_diagram_B.png
importance: 2
category: coursework
related_publications: false
---

This assignment analyzes a **100-mile transmission line** using **two-port ABCD parameters**. Given the per-unit-length electrical parameters, we determine the **B parameter** (series impedance) of the transmission line model, which relates sending-end and receiving-end voltages and currents.

**Course:** EE-336 — Electrical Energy Systems  
**Assignment:** HW#9 (Week 11)  
**Date:** April 14, 2025  
**Author:** Steven Placzek

---

## Problem Statement

Consider a 100-mile transmission line operating at 60 Hz with the following per-unit-length parameters:

| Parameter | Symbol | Value |
|:----------|:------:|------:|
| Series Inductance | $L$ | $10 \times 10^{-3}$ H/mi |
| Series Resistance | $R$ | $10 \times 10^{-3}$ Ω/mi |
| Shunt Capacitance | $C$ | $10 \times 10^{-6}$ F/mi |

Given the two-port ABCD parameter relationships between sending-end and receiving-end quantities:

$$
V_S = A \cdot V_R + B \cdot I_R
$$

$$
I_S = C \cdot V_R + D \cdot I_R
$$

**Question:** What is the quantity $B$?

---

## Transmission Line Classification

Transmission lines are classified by electrical length, which determines the appropriate circuit model:

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-11/line_classification.png" title="Transmission Line Classification" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  Transmission line classification by length. Our 100-mile line falls in the <b>medium-length</b> category, where the nominal π-model provides adequate accuracy.
</div>

For our **100-mile line**, we use the **nominal π-model** where the total series impedance $Z$ directly equals the $B$ parameter.

---

## Circuit Model: Nominal π Representation

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-11/pi_model_circuit.png" title="Nominal π-Model Circuit" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  The nominal π-model for a medium-length transmission line. Series elements (R, L) are lumped at the center, while shunt capacitance is split between sending and receiving ends.
</div>

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-11/abcd_block_diagram.png" title="ABCD Parameter Block Diagram" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  Two-port ABCD parameter representation relating sending-end quantities (V<sub>S</sub>, I<sub>S</sub>) to receiving-end quantities (V<sub>R</sub>, I<sub>R</sub>).
</div>

---

## Solution

### Step 1: Calculate Total Line Parameters

For a line of length $\ell = 100$ miles:

$$
R_{total} = R \cdot \ell = (10 \times 10^{-3}) \cdot 100 = 1 \text{ Ω}
$$

$$
L_{total} = L \cdot \ell = (10 \times 10^{-3}) \cdot 100 = 1 \text{ H}
$$

$$
C_{total} = C \cdot \ell = (10 \times 10^{-6}) \cdot 100 = 10^{-3} \text{ F} = 1 \text{ mF}
$$

### Step 2: Calculate Angular Frequency

At $f = 60$ Hz:

$$
\omega = 2\pi f = 2\pi(60) = 120\pi \approx 376.99 \text{ rad/s}
$$

### Step 3: Determine B Parameter

For short and medium-length transmission lines, the **B parameter equals the total series impedance**:

$$
B = Z_{series} = R_{total} + j\omega L_{total}
$$

$$
B = 1 + j(120\pi)(1) = 1 + j376.99 \text{ Ω}
$$

### Step 4: Convert to Polar Form

$$
|B| = \sqrt{R^2 + (\omega L)^2} = \sqrt{1^2 + 376.99^2} = 377.00 \text{ Ω}
$$

$$
\angle B = \tan^{-1}\left(\frac{\omega L}{R}\right) = \tan^{-1}\left(\frac{376.99}{1}\right) = 89.85°
$$

---

## Final Answer

$$
\boxed{B = 1 + j377 \approx 377 \angle 89.85° \text{ Ω}}
$$

<div class="row">
  <div class="col-sm-8 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-11/phasor_diagram_B.png" title="Phasor Diagram for B Parameter" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm-4 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-11/abcd_parameters_table.png" title="ABCD Parameters Summary" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  <b>Left:</b> Phasor diagram showing the B parameter as the vector sum of resistance (real) and inductive reactance (imaginary). <b>Right:</b> Summary table of all ABCD parameters for the nominal π-model.
</div>

---

## Physical Interpretation

The **B parameter** has units of impedance (Ω) and represents the **voltage drop per unit current** through the transmission line. Key observations:

- **Magnitude:** $|B| = 377$ Ω indicates significant series impedance over 100 miles
- **Angle:** $\angle B = 89.85°$ shows the line is **highly inductive** (X >> R)
- The near-90° angle is characteristic of high-voltage transmission lines where $\omega L \gg R$

The large imaginary component ($j377$ Ω) versus the small real component ($1$ Ω) yields an **X/R ratio of ~377**, typical for long-distance power transmission.

---

## Complete ABCD Parameters (Nominal π-Model)

For completeness, the full set of ABCD parameters for the nominal π-model are:

| Parameter | Formula | Expression |
|:---------:|:-------:|:-----------|
| $A$ | $1 + \frac{ZY}{2}$ | $A = 1 + \frac{(1+j377)(j0.377)}{2}$ |
| $B$ | $Z$ | $B = 1 + j377$ Ω |
| $C$ | $Y\left(1 + \frac{ZY}{4}\right)$ | $C = (j0.377)\left(1 + \frac{(1+j377)(j0.377)}{4}\right)$ S |
| $D$ | $1 + \frac{ZY}{2}$ | $D = A$ (symmetric line) |

Where $Y = j\omega C_{total} = j(376.99)(10^{-3}) = j0.377$ S

---

## Model Comparison

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-11/B_parameter_comparison.png" title="B Parameter Model Comparison" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  Comparison between short line approximation and exact (distributed parameter) model. For a 100-mile line at 60 Hz, the lumped-parameter approximation is acceptable for most power system studies.
</div>

---

## Key Takeaways

1. **Line Classification Matters:** A 100-mile line is "medium length" — long enough to require the π-model, but short enough that lumped parameters remain accurate.

2. **B = Series Impedance:** For short/medium lines, the B parameter directly equals the total series impedance $Z = R + j\omega L$.

3. **Highly Inductive:** Power transmission lines have X/R ratios >> 1, making the B parameter nearly purely imaginary.

4. **Units:** B has units of ohms (Ω), relating voltage to current: $V_S = AV_R + BI_R$.

---

## Notes

This analysis assumes a balanced three-phase system represented by per-phase equivalent circuit. Real transmission lines may require more detailed modeling including:
- Corona losses at high voltages
- Skin effect at higher frequencies  
- Temperature-dependent resistance
- Transposition for balanced inductance
