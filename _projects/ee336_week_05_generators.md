---
layout: page
title: EE-336 Induction Motor Slip Analysis
description: Induction motor fundamentals — slip, synchronous speed, and rotor frequency calculations for 2-pole motors.
img: /assets/img/ee336/assignment-05/slip_vs_speed.png
importance: 2
category: coursework
related_publications: false
---

This assignment explores the fundamental operating principles of **three-phase induction motors**, focusing on the relationships between **slip**, **synchronous speed**, **rotor speed**, and **rotor voltage frequency**. The problems analyze a 2-pole induction motor at two key operating conditions: startup and steady-state operation.

**Course:** EE-336 — Electrical Energy Systems  
**Date:** 2025-02-16  
**Author:** Steven Placzek

---

## Key Equations

The behavior of an induction motor is governed by a few fundamental relationships:

<div class="row justify-content-center">
  <div class="col-sm-10 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-05/key_equations.png" title="Induction Motor Key Equations" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

For a **2-pole motor** connected to a **60 Hz** supply:

$$
n_{sync} = \frac{120 \times 60}{2} = 3600 \text{ RPM}
$$

---

## Problem 1: Motor at Startup

**Scenario:** A 2-pole induction motor is connected to an electrical source, but the rotor has not yet begun to rotate.

### Part (a): Synchronous Frequency

The synchronous frequency equals the **line frequency** of the AC supply:

$$
f_{sync} = 60 \text{ Hz}
$$

The corresponding synchronous speed is:

$$
n_{sync} = \frac{120 \cdot f}{p} = \frac{120 \times 60}{2} = 3600 \text{ RPM}
$$

### Part (b): Rotor Voltage Frequency

At startup, the rotor is **stationary** ($n_{rot} = 0$), so the slip is:

$$
s = \frac{n_{sync} - n_{rot}}{n_{sync}} = \frac{3600 - 0}{3600} = 1.0 \text{ (100\%)}
$$

The rotor voltage frequency is:

$$
f_{rotor} = s \cdot f_{sync} = 1.0 \times 60 = \boxed{60 \text{ Hz}}
$$

**Physical interpretation:** At startup, the rotating magnetic field sweeps past the stationary rotor at full synchronous speed. The rotor conductors experience the full rate of flux change, inducing voltages at the same frequency as the stator supply.

### Part (c): Slip Percentage

$$
s = \frac{n_{sync} - n_{rot}}{n_{sync}} \times 100\% = \frac{3600 - 0}{3600} \times 100\% = \boxed{100\%}
$$

---

## Problem 2: Motor at Steady-State (5% Slip)

**Scenario:** The same induction motor is now operating at no-load steady-state with a slip of 5%.

### Part (a): Rotor Speed

$$
n_{rot} = n_{sync}(1 - s) = 3600 \times (1 - 0.05) = 3600 \times 0.95 = \boxed{3420 \text{ RPM}}
$$

### Part (b): Rotor Voltage Frequency

$$
f_{rotor} = s \cdot f_{sync} = 0.05 \times 60 = \boxed{3 \text{ Hz}}
$$

**Physical interpretation:** At 5% slip, the rotor is nearly keeping up with the rotating magnetic field. The relative speed between the field and rotor is small, so the rotor conductors experience a slowly varying flux, resulting in a low-frequency induced voltage.

### Part (c): Effect of Adding Load

When mechanical load is added to the motor:

- The rotor **slows down** to develop more electromagnetic torque
- This **increases the slip** (larger difference between $n_{sync}$ and $n_{rot}$)
- Greater slip means more induced rotor current and thus more torque

$$
\text{Load} \uparrow \implies n_{rot} \downarrow \implies s \uparrow \implies \text{Torque} \uparrow
$$

**Answer:** Slip percentage will **increase** when load is added.

---

## Visualizations

### Rotor Speed vs. Slip

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-05/slip_vs_speed.png" title="Rotor Speed vs Slip" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  The rotor speed decreases linearly with increasing slip. At s = 0 (impossible in practice), the rotor would match synchronous speed. At s = 100% (startup), the rotor is stationary.
</div>

### Rotor Frequency vs. Slip

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-05/slip_vs_rotor_freq.png" title="Rotor Frequency vs Slip" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  The rotor voltage frequency is directly proportional to slip. At startup (s = 100%), rotor frequency equals stator frequency. During normal operation (s ≈ 2–5%), rotor frequency is just a few Hz.
</div>

### Torque-Speed Characteristic

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-05/torque_speed_curve.png" title="Torque-Speed Characteristic" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  The torque-speed curve shows the stable operating region (green shading). As load increases, the motor moves left along this curve—speed decreases and slip increases to produce more torque.
</div>

---

## Problem Summary

<div class="row justify-content-center">
  <div class="col-sm-12 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-05/problem_summary.png" title="Problem Summary Diagram" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

---

## Results Summary

| Parameter | Problem 1 (Startup) | Problem 2 (5% Slip) |
|:----------|:-------------------:|:-------------------:|
| Rotor Speed $n_{rot}$ | 0 RPM | 3420 RPM |
| Slip $s$ | 100% | 5% |
| Rotor Frequency $f_{rotor}$ | 60 Hz | 3 Hz |
| Synchronous Speed $n_{sync}$ | 3600 RPM | 3600 RPM |

---

## Key Takeaways

1. **Synchronous speed** depends only on line frequency and number of poles—it's independent of load.

2. **Slip** is the fundamental quantity that determines motor performance:
   - Higher slip → Higher rotor frequency → More induced voltage → More torque
   - Typical operating slip for induction motors: 2–5%

3. **Rotor frequency** at normal operation is very low (a few Hz), which explains why rotor reactance ($X_2 = 2\pi f_{rotor} L_2$) is often negligible compared to rotor resistance during steady-state operation.

4. **Load response:** Induction motors are self-regulating—adding load causes the rotor to slow down just enough to induce the additional current needed for the required torque.

---

## Notes

This analysis assumes a standard 60 Hz power system (typical in North America). For 50 Hz systems (Europe, Asia), synchronous speeds would be proportionally lower (e.g., 3000 RPM for a 2-pole motor).