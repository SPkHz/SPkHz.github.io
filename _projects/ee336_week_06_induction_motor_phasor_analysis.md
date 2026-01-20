---
layout: page
title: Induction Motor Phasor Analysis
description: Phasor diagram analysis of induction motor equivalent circuit at multiple operating points (MATLAB • Python • Complex Impedance Analysis).
img: /assets/img/ee336/assignment-06/phasor_all_points.png
category: coursework
importance: 97253416240
related_publications: true
tags:
  - induction motor
  - phasor analysis
  - equivalent circuit
  - slip
  - torque
  - matlab
  - complex impedance
---

This assignment analyzes an **induction motor per-phase equivalent circuit** by computing and visualizing **phasor diagrams** for stator voltage ($\bar{V}_s$), air-gap voltage ($\bar{V}_r$), and load voltage ($\bar{V}_L$) at four different operating points on the motor's speed-torque characteristic curve.

**Author:** Steven Placzek  
**Course:** EE-336 Electrical Energy Systems  
**Date:** March 4, 2025  
**Tools:** MATLAB, Python (`numpy`, `matplotlib`)

---

## Problem Statement

Given an induction motor with the following **per-phase equivalent circuit parameters**:

| Parameter             | Symbol | Value | Description        |
| :-------------------- | :----: | ----: | :----------------- |
| Stator Resistance     | $R_s$  | 0.5 Ω | Winding resistance |
| Stator Reactance      | $X_s$  | 1.0 Ω | Leakage reactance  |
| Magnetizing Reactance | $X_m$  |  25 Ω | Core magnetization |
| Rotor Resistance      | $R_r$  | 0.6 Ω | Referred to stator |
| Rotor Reactance       | $X_r$  | 1.2 Ω | Referred to stator |
| Stator Voltage        | $V_s$  | 220 V | Phase voltage      |

<div class="row justify-content-sm-center">
    <div class="col-sm-8 mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-06/equivalent_circuit.png" title="Induction Motor Equivalent Circuit" class="img-fluid rounded z-depth-1" %}
    </div>
</div>

<div class="caption">
    Per-phase equivalent circuit of the induction motor with stator impedance ($R_s + jX_s$), magnetizing branch ($jX_m$), and rotor branch ($R_r/s + jX_r$).
</div>

---

## Operating Points on Speed-Torque Curve

The speed-torque curve defines four operating points with different **slip values** ($s$):

| Operating Point | Slip ($s$) | Operating Condition                 |
| :-------------: | :--------: | :---------------------------------- |
|      **A**      |    0.80    | Near stall (high slip, low speed)   |
|      **B**      |    0.15    | Loaded operation                    |
|      **C**      |    0.05    | Light load                          |
|      **D**      |    0.01    | Near no-load (low slip, high speed) |

<div class="row justify-content-sm-center">
    <div class="col-sm-8 mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-06/speed_torque_curve.png" title="Speed-Torque Characteristic Curve" class="img-fluid rounded z-depth-1" %}
    </div>
</div>

<div class="caption">
    Induction motor speed-torque curve showing operating points A (stall region), B (peak torque), C (normal operation), and D (no-load).
</div>

---

## Circuit Analysis Method

The equivalent circuit is solved using **complex impedance analysis**. For each slip value $s$:

$$
Z_r = \frac{R_r}{s} + jX_r \quad \text{(rotor branch impedance)}
$$

$$
Z_{\text{parallel}} = \frac{jX_m \cdot Z_r}{jX_m + Z_r} \quad \text{(magnetizing || rotor)}
$$

$$
Z_{\text{total}} = (R_s + jX_s) + Z_{\text{parallel}}
$$

The **stator current** and **voltages** are then:

$$
\bar{I}_s = \frac{\bar{V}_s}{Z_{\text{total}}}, \quad
\bar{V}_r = \bar{I}_s \cdot Z_{\text{parallel}}, \quad
\bar{V}_L = \bar{I}_r \cdot \frac{R_r}{s}
$$

---

## Part 1: Phasor Diagrams for Each Operating Point

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-06/phasor_op_A.png" title="Operating Point A (s=0.80)" class="img-fluid rounded z-depth-1" %}
    </div>
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-06/phasor_op_B.png" title="Operating Point B (s=0.15)" class="img-fluid rounded z-depth-1" %}
    </div>
</div>

<div class="caption">
    <b>Left:</b> Operating Point A (high slip) — large stator current with significant phase lag; $V_L$ is small due to high rotor current. <b>Right:</b> Operating Point B (loaded) — moderate current with balanced voltage distribution.
</div>

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-06/phasor_op_C.png" title="Operating Point C (s=0.05)" class="img-fluid rounded z-depth-1" %}
    </div>
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-06/phasor_op_D.png" title="Operating Point D (s=0.01)" class="img-fluid rounded z-depth-1" %}
    </div>
</div>

<div class="caption">
    <b>Left:</b> Operating Point C (light load) — smaller current, voltages converging toward $V_s$. <b>Right:</b> Operating Point D (no-load) — minimum current, $V_r \approx V_L \approx V_s$.
</div>

### Combined Phasor Diagram

<div class="row justify-content-sm-center">
    <div class="col-sm-10 mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-06/phasor_all_points.png" title="Combined Phasor Diagram" class="img-fluid rounded z-depth-1" %}
    </div>
</div>

<div class="caption">
    Overlay of all four operating points showing the progression of phasor magnitudes and angles as slip decreases from stall (A) to no-load (D).
</div>

---

## Part 2: Stator Current Magnitude Analysis

**Question:** Which operating point has the largest stator current magnitude $\|I_s\|$?

**Answer: Operating Point A** (slip = 0.80) has the **largest stator current** at **89.20 A**.

### Physical Interpretation

At **high slip** (low rotor speed), the effective rotor impedance $R_r/s$ becomes **small**, causing:

$$
\text{As } s \uparrow \implies \frac{R_r}{s} \downarrow \implies Z_{\text{total}} \downarrow \implies |I_s| \uparrow
$$

This explains why **inrush current at startup** (when $s = 1$) can be 5-8× the rated full-load current.

### Numerical Results

| Operating Point | Slip | $\|I_s\|$ (A) | $\|V_r\|$ (V) | $\|V_L\|$ (V) | $\angle I_s$ (°) |
| :-------------: | :--: | :-----------: | :-----------: | :-----------: | :--------------: |
|      **A**      | 0.80 |   **89.20**   |    120.39     |     63.81     |      -61.36      |
|        B        | 0.15 |     45.19     |    178.00     |    170.50     |      -33.52      |
|        C        | 0.05 |     19.27     |    201.64     |    200.64     |      -33.39      |
|        D        | 0.01 |     9.15      |    209.79     |    209.75     |      -67.36      |

<div class="row justify-content-sm-center">
    <div class="col-sm-8 mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-06/stator_current_comparison.png" title="Stator Current Comparison" class="img-fluid rounded z-depth-1" %}
    </div>
</div>

<div class="caption">
    Bar chart comparing stator current magnitudes across operating points. The inverse relationship between slip and rotor impedance causes current to increase dramatically at high slip values.
</div>

---

## Key Observations

1. **Voltage Behavior:** As slip decreases (motor speeds up), $V_r$ and $V_L$ approach $V_s$ in both magnitude and phase angle.

2. **Current Behavior:** Stator current is **maximum at high slip** (near stall) and **minimum at no-load** — this is why motor protection circuits monitor startup current.

3. **Phase Angle:** The stator current lags the voltage significantly at both high and low slip, but for different reasons:
   - High slip: Large reactive current through rotor inductance
   - Low slip: Magnetizing current dominates (mostly reactive)

4. **No-Load Condition (Point D):** When $s \approx 0$, the rotor branch opens ($R_r/s \to \infty$), so $I_s$ becomes primarily the **magnetizing current** through $X_m$.

---

## MATLAB Implementation

```matlab
% Motor parameters
Rs = 0.5; Xs = 1.0; Rr = 0.6; Xr = 1.2; Xm = 25;
Vs = 220;
Vs_complex = complex(Vs, 0);

% Operating point slips
slips = [0.8, 0.15, 0.05, 0.01];

for i = 1:length(slips)
    s = slips(i);
    Rr_s = Rr/s;
    Zr = complex(Rr_s, Xr);
    Zm = complex(0, Xm);
    Zs = complex(Rs, Xs);

    Z_parallel = (Zm * Zr) / (Zm + Zr);
    Ztotal = Zs + Z_parallel;

    Is_complex(i) = Vs_complex / Ztotal;
    Vr_complex(i) = Is_complex(i) * Z_parallel;

    % Current through rotor branch
    Ir = Vr_complex(i) / Zr;
    VL_complex(i) = Ir * complex(Rr_s, 0);
end
```

---

## Notes

- The **per-phase equivalent circuit** assumes balanced three-phase operation with all core losses neglected.
- Real motors exhibit additional effects: saturation, skin effect, and mechanical losses.
- The slip values chosen represent typical points on a NEMA Design B motor characteristic.
