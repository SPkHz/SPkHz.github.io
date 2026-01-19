---

layout: page
title: Transmission Line Analysis
description: Voltage regulation and surge impedance loading analysis for power transmission lines (MATLAB/Python • Two-port networks • SIL concepts).
img: /assets/img/ee336/assignment-12/two_port_model.png
category: coursework
importance: 7631136280
related_publications: true
tags:
  - transmission line
  - voltage regulation
  - surge impedance loading
  - two-port network
  - power systems
---

This assignment analyzes **transmission line voltage regulation** and **surge impedance loading (SIL)** using two-port network models. The problems explore how ABCD parameters relate sending and receiving-end quantities, and how load magnitude relative to SIL affects voltage profiles.

**Course:** EE-336 Electrical Energy Systems  
**Assignment:** Week 12 (HW10)  
**Date:** April 14, 2025  
**Author:** Steven Placzek

---

## Problem 1: Transmission Line Voltage Regulation

### Problem Statement

A transmission line's sending-end and receiving-end quantities are related by ABCD parameters:

$$
\begin{bmatrix} \tilde{V}_S \\ \tilde{I}_S \end{bmatrix} = 
\begin{bmatrix} A & B \\ C & D \end{bmatrix}
\begin{bmatrix} \tilde{V}_R \\ \tilde{I}_R \end{bmatrix}
$$

Given parameters:
- $$A = D = 0.97\angle 0.2°$$
- $$B = 68\angle 88° \, \Omega$$
- $$C = 1 \times 10^{-3}\angle 90° \, S$$

For a load of **500 MW** at **0.99 power factor lagging** and **330 kV**, calculate the **voltage regulation percent**.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-12/two_port_model.png" title="Transmission Line Two-Port Model" class="img-fluid rounded z-depth-1" %}
    </div>
</div>

<div class="caption">
    Two-port network representation of a transmission line with ABCD parameters relating sending and receiving-end voltage/current phasors.
</div>

### Solution

**Step 1: Calculate the receiving-end current**

For a three-phase load:

$$
\tilde{I}_{R,FL} = \frac{P}{\sqrt{3} \cdot pf \cdot |V_{R,FL}|} \angle -\cos^{-1}(pf)
$$

$$
\tilde{I}_{R,FL} = \frac{500 \text{ MW}}{\sqrt{3} \times 0.99 \times 330 \text{ kV}} = 884\angle -8.11° \text{ A}
$$

**Step 2: Calculate the sending-end voltage**

Using the two-port relationship $$\tilde{V}_S = A \cdot \tilde{V}_R + B \cdot \tilde{I}_R$$:

$$
\tilde{V}_S = (0.97\angle 0.2°)(330\angle 0° \text{ kV}) + (68\angle 88° \, \Omega)(884\angle -8.11° \text{ A})
$$

$$
\tilde{V}_S = 320.1\angle 0.2° + 60.1\angle 79.89° = 336.1\angle 10.3° \text{ kV}
$$

**Step 3: Calculate no-load receiving-end voltage**

At no load ($$I_R = 0$$), the receiving-end voltage becomes:

$$
\tilde{V}_{R,NL} = \frac{\tilde{V}_S}{A} = \frac{336.1\angle 10.3°}{0.97\angle 0.2°} = 346.5\angle 10.1° \text{ kV}
$$

**Step 4: Calculate voltage regulation**

$$
\%VR = \frac{|V_{R,NL}| - |V_{R,FL}|}{|V_{R,FL}|} \times 100\%
$$

$$
\%VR = \frac{346.5 - 330}{330} \times 100\% = \boxed{5\%}
$$

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-12/phasor_diagram.png" title="Voltage Phasor Diagram" class="img-fluid rounded z-depth-1" %}
    </div>
</div>

<div class="caption">
    Phasor diagram showing the relationship between full-load receiving voltage (V<sub>R,FL</sub>), sending voltage (V<sub>S</sub>), and no-load receiving voltage magnitude (|V<sub>R,NL</sub>|). The voltage regulation represents the percentage increase in |V<sub>R</sub>| when load is removed.
</div>

---

## Problem 2: Surge Impedance Loading Comparison

### Problem Statement

Consider two 115 kV transmission lines:
- **Line 1:** $$Z_c = 400 \, \Omega$$, carrying 35 MW
- **Line 2:** $$Z_c = 350 \, \Omega$$, carrying 36 MW

**(a)** Which line will have higher receiving-end voltage magnitude $$|V_R|$$, assuming the same $$|V_S|$$ for both lines?

**(b)** Which line is more heavily loaded relative to its SIL?

### Solution

**Surge Impedance Loading (SIL)** is defined as:

$$
SIL = \frac{V^2}{Z_c}
$$

where $$V$$ is the line-to-line voltage and $$Z_c$$ is the characteristic (surge) impedance.

**Calculate SIL for each line:**

$$
SIL_1 = \frac{(115 \text{ kV})^2}{400 \, \Omega} = \frac{13225}{400} = 33 \text{ MW}
$$

$$
SIL_2 = \frac{(115 \text{ kV})^2}{350 \, \Omega} = \frac{13225}{350} = 38 \text{ MW}
$$

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-12/sil_comparison.png" title="SIL Comparison" class="img-fluid rounded z-depth-1" %}
    </div>
</div>

<div class="caption">
    Comparison of Surge Impedance Loading (SIL) and actual load for both transmission lines. Line 1 is overloaded (106.1% of SIL) while Line 2 is underloaded (94.7% of SIL).
</div>

### Part (a): Receiving-End Voltage Comparison

The voltage profile along a transmission line depends on the load relative to SIL:

| Condition | Voltage Profile |
|:----------|:----------------|
| Load < SIL | $$\|V_R\| > \|V_S\|$$ (voltage rise) |
| Load = SIL | $$\|V_R\| = \|V_S\|$$ (flat profile) |
| Load > SIL | $$\|V_R\| < \|V_S\|$$ (voltage drop) |

Comparing loads to SIL:
- **Line 1:** Load (35 MW) > SIL₁ (33 MW) → **Overloaded** → $$|V_R| < |V_S|$$
- **Line 2:** Load (36 MW) < SIL₂ (38 MW) → **Underloaded** → $$|V_R| > |V_S|$$

**Answer:** $$\boxed{\text{Line 2}}$$ has the higher receiving-end voltage magnitude.

### Part (b): Loading Relative to SIL

Calculate the load-to-SIL ratio for each line:

$$
\frac{\text{Load}_1}{SIL_1} = \frac{35}{33} = 1.061 = 106.1\%
$$

$$
\frac{\text{Load}_2}{SIL_2} = \frac{36}{38} = 0.947 = 94.7\%
$$

**Answer:** $$\boxed{\text{Line 1}}$$ is more heavily loaded relative to its SIL.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-12/voltage_profile.png" title="Voltage Profile vs Load" class="img-fluid rounded z-depth-1" %}
    </div>
</div>

<div class="caption">
    Voltage ratio |V<sub>R</sub>|/|V<sub>S</sub>| as a function of load relative to SIL. Line 1 (red circle) operates in the overloaded region, experiencing voltage drop. Line 2 (green triangle) operates in the underloaded region, experiencing voltage rise.
</div>

---

## Key Concepts

### Voltage Regulation

Voltage regulation quantifies the change in receiving-end voltage from no-load to full-load conditions:

$$
\%VR = \frac{|V_{R,NL}| - |V_{R,FL}|}{|V_{R,FL}|} \times 100\%
$$

A lower voltage regulation indicates better voltage stability under varying load conditions. Typical values for transmission lines range from 3-10%.

### Surge Impedance Loading (SIL)

SIL represents the "natural" loading of a transmission line where reactive power generation by line capacitance equals reactive power absorption by line inductance. At SIL:
- No net reactive power flow
- Flat voltage profile ($$|V_R| = |V_S|$$)
- Maximum power transfer efficiency

Operating **below SIL** causes the line to act as a capacitive reactive source (Ferranti effect), while operating **above SIL** causes the line to absorb reactive power, resulting in voltage drop.

---

## Summary of Results

| Problem | Quantity | Value |
|:--------|:---------|:------|
| 1 | Receiving-end current $$I_{R,FL}$$ | $$884\angle -8.11°$$ A |
| 1 | Sending-end voltage $$V_S$$ | $$336.1\angle 10.3°$$ kV |
| 1 | No-load receiving voltage $$\|V_{R,NL}\|$$ | 346.5 kV |
| 1 | **Voltage Regulation** | **5%** |
| 2 | SIL₁ (Line 1) | 33 MW |
| 2 | SIL₂ (Line 2) | 38 MW |
| 2(a) | **Higher $$\|V_R\|$$** | **Line 2** |
| 2(b) | **More heavily loaded** | **Line 1** |

---

## References

1. Glover, J.D., Overbye, T.J., & Sarma, M.S. (2017). *Power System Analysis and Design* (6th ed.). Cengage Learning.
2. Bergen, A.R., & Vittal, V. (2000). *Power Systems Analysis* (2nd ed.). Prentice Hall.
