---
layout: post
title: "Discrete-Time Control for Receiver Positioning and Satellite Tracking"
date: 2025-04-28 10:01:48-05:00
description: Discrete-time state-space controller (pole placement) for a servo-driven receiver positioning system. Validated in MATLAB/Simulink across multiple sampling rates.
tags: [control-systems, discrete-control, digital-control, state-space, pole-placement, zoh, matlab, simulink, satellite-tracking]
categories: coursework
thumbnail: assets/img/ee470/Position_Full_Plot.jpg
inline: false
related_posts: true
show_on_home: false
giscus_comments: false
pretty_table: true
_styles: |
  .post article .mjx-container[display="true"] {
    font-size: 1.3em;
    margin: 0.9em 0 1.1em;
  }
  .post article .mjx-container {
    font-size: 1.12em;
  }
---

I've published **EE-470 (Discrete Digital Computer Control Systems) - Final Design Project 01**: a **discrete-time controller** for a **servo-driven receiver positioning system** (satellite-tracking use case). The design target was a tight transient response - **~1% overshoot** and **~0.05 s peak time** - so the actuator can reposition quickly without hunting or ringing that would break alignment.

If you maintain alignment to a moving satellite, the control loop is the difference between *tracking* and *chasing*. This project is about making the digital controller behave like the continuous design **on purpose**, not by luck.

---

## Design targets

- **Plant:** 2nd-order servo positioning dynamics (position + velocity state model)
- **Controller:** discrete-time state feedback via **pole placement** (`acker`)
- **Nominal sampling:** **T_s = 0.01 s (100 Hz)**
- **Transient spec:** **PO ~ 1%**, **T_p ~ 0.05 s**
- **Validation:** MATLAB + Simulink, including a sampling-rate sweep (**50 Hz -> 500 Hz**)

---

## System model (plant)

The servo actuator was modeled from the open-loop transfer function:

$$
G_p(s) = \frac{6776.29}{s(s+48.27)}
$$

A continuous-time state-space model was constructed using states $x_1 = \theta$ and $x_2 = \dot{\theta}$, then discretized using **zero-order hold (ZOH)** for digital implementation.

---

## Digital control design (discrete pole placement)

The continuous transient specs were converted into desired pole locations.

From percent overshoot and peak time:

$$
\zeta = -\frac{\ln(PO/100)}{\sqrt{\pi^2 + \ln^2(PO/100)}}
$$

$$
T_p = \frac{\pi}{\omega_n\sqrt{1-\zeta^2}}
\quad\Rightarrow\quad
\omega_n = \frac{\pi}{T_p\sqrt{1-\zeta^2}}
$$

Desired continuous poles:

$$
s_{1,2} = -\zeta\omega_n \pm j\,\omega_n\sqrt{1-\zeta^2}
$$

Mapped into the z-plane at the chosen sample time $T_s$:

$$
z_{1,2} = e^{s_{1,2}T_s}
$$

State-feedback gains were computed by discrete pole placement (MATLAB `acker`). For implementation, the controller was expressed in an output-feedback form:

$$
u(k) = -G_1\,y_1(k) - G_2\,y_2(k) + r(k)
$$

where $y_1(k)$ is position and $y_2(k)$ is velocity.

---

## Implementation view (Simulink)

<div class="row justify-content-sm-center">
  <div class="col-sm-8 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee470/EE470_Final_Design_Simulink_Screenshot1.png" title="Simulink implementation (discrete controller + plant)" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm-4 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee470/Continous_Sys_TF.png" title="Plant block diagram / scaling (continuous model reference)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  Simulink was used to validate both the continuous reference design and the discrete controller behavior at the chosen sampling rate.
</div>

---

## Sampling-rate sensitivity (50 Hz -> 500 Hz)

Sampling rate is not a cosmetic setting - it changes the closed-loop behavior because the controller only updates at sample instants. This project explicitly swept sampling frequency to show how discretization artifacts appear and then disappear as $f_s$ increases.

### Position step response sweep

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
  Position response sweep: increasing sampling frequency reduces discretization artifacts and improves overlay with the continuous reference.
</div>

### Velocity step response sweep

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
  Velocity response sweep: discrete velocity feedback can amplify measurement noise in real hardware, so filtering and timing discipline matter.
</div>

---

## Performance summary (100 Hz design point)

At the nominal design rate (**100 Hz**), the discrete controller closely matches the continuous transient performance.

| Metric | Continuous | Discrete |
| --- | ---: | ---: |
| Peak time | 0.049 s | 0.050 s |
| Settling time (2%) | 0.061 s | 0.060 s |
| Percent overshoot | 0.98% | 1.02% |

---

## Hardware feasibility notes

The report also documents what changes when you leave MATLAB:

- **Sampling/timing:** interrupt-driven timing to maintain a stable 100 Hz loop (jitter shows up as phase noise in the control loop)
- **Noise:** velocity measurement filtering (derivative channels punish noise)
- **Limits:** saturation handling and anti-windup (for typical +/- 6 V drive constraints)
- **Deployment readiness:** I/O scaling and code-generation / rapid-prototyping considerations

---

## What's included

- Full technical report (PDF + source)
- MATLAB scripts: discretization, pole placement, and plotting
- Simulink model(s) + scope plots (position/velocity/control input)
- Motor + gearhead specification appendix and compliance checks
