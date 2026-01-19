---
layout: page
title: Discrete Control System Design for Receiver Positioning and Accurate Satellite Tracking
description: Discrete-time state-space controller (pole placement) for a servo-driven receiver positioning system. Validated in MATLAB/Simulink across multiple sampling rates.
img: /assets/img/ee470/Position_Full_Plot.jpg
importance: 3
category: coursework
related_publications: false
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

**Course:** EE-470 Discrete Digital Computer Control Systems
**Project:** Final Design Project 01 - Discrete Control for Receiver Positioning and Satellite Tracking
**Team:** Steven Placzek, Bryam Yanza
**Date:** 2025-04-28

This project designs a **discrete-time controller** for a **servo-driven receiver positioning system** (satellite tracking use-case). The design target was a tight transient response—**~1% overshoot** and **~0.05 s peak time**—so the actuator can reposition quickly without hunting or ringing that would break alignment.

**Tools:** MATLAB + Simulink (state-space modeling, ZOH discretization, pole placement via `acker`)
**Deliverable:** Digital controller design + simulation validation + rapid-prototyping readiness notes

---

## System Model (Plant)

The servo actuator was modeled from the open-loop transfer function:

$$
G_p(s) = \frac{6776.29}{s(s+48.27)}
$$

A state-space model was constructed with states $x_1=\theta$ and $x_2=\dot{\theta}$, then discretized using **zero-order hold (ZOH)** for digital implementation.

---

## Digital Control Design (Pole Placement)

**Performance specs:**
- **Percent overshoot:** PO = 1%
- **Peak time:** $T_p = 0.05$ s
- **Nominal controller sample time:** $T_s = 0.01$ s (**100 Hz**)

From PO and $T_p$, the damping ratio $\zeta$ and natural frequency $\omega_n$ were computed, producing desired continuous poles, then mapped into the z-plane via:

$$
z = e^{sT_s}
$$

State-feedback gains were computed via **discrete-time pole placement**, then converted into an **output-feedback form** suitable for implementation:

$$
u(k) = -G_1\,y_1(k) - G_2\,y_2(k) + r(k)
$$

---

## Implementation View (Simulink)

<div class="row justify-content-sm-center">
  <div class="col-sm-8 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee470/EE470_Final_Design_Simulink_Screenshot1.png" title="Simulink implementation (discrete controller + plant)" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm-4 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee470/Continous_Sys_TF.png" title="Plant block diagram / scaling (continuous model reference)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  The controller was built and validated in Simulink using both continuous and discrete representations to verify that the discrete controller tracks the continuous design closely at the chosen sampling rate.
</div>

---

## Sampling-Rate Sensitivity (50 Hz → 500 Hz)

A key part of the project was showing how sampling rate affects the *practical* discrete response. Below are representative **position** and **velocity** step response comparisons at different sampling frequencies.

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee470/Figure_1_Step_response_Pos_50Hz.png" title="Position step response (50 Hz sampling)" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee470/Position_Full_Plot.jpg" title="Position step response (100 Hz sampling)" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee470/Sweep_500Hz_Pos.jpg" title="Position step response (500 Hz sampling)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  Position response sweep: increasing sampling frequency reduces discretization artifacts and improves how closely the discrete response overlays the continuous reference.
</div>

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee470/Figure_2_Step_Response_Vel_50Hz.png" title="Velocity step response (50 Hz sampling)" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee470/Velocity_Full_Plot.jpg" title="Velocity step response (100 Hz sampling)" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee470/Sweep_500Hz_Vel.jpg" title="Velocity step response (500 Hz sampling)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  Velocity response sweep: discrete velocity feedback can amplify measurement noise in real hardware, so filtering and careful timing become part of the control design (not an afterthought).
</div>

---

## Performance Summary (100 Hz Design Point)

Simulation results show that the discrete controller closely matches the continuous design at **100 Hz**, meeting the intended transient response targets:

| Metric | Continuous | Discrete |
|---|---:|---:|
| Peak time | 0.049 s | 0.050 s |
| Settling time (2%) | 0.061 s | 0.060 s |
| Percent overshoot | 0.98% | 1.02% |

---

## Hardware Feasibility Notes

The report also documents practical constraints that matter when you leave MATLAB:
- **Sampling/timing:** interrupt-driven timing to maintain a stable 100 Hz loop
- **Noise:** velocity measurement filtering to prevent noise-driven control effort
- **Limits:** saturation + anti-windup recommended for ±6 V actuator constraints
- **Rapid prototyping readiness:** code-generation setup and I/O scaling considerations are included

---

## Repository Contents

- Full technical report (PDF + LaTeX source)
- MATLAB scripts for discretization, pole placement, and plotting
- Simulink models + scope plots (position/velocity/control input)
- Motor + gearhead specification appendix and compliance checks
