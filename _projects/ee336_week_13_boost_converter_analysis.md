---

layout: page
title: Boost Converter Analysis
description: DC waveform analysis and boost converter duty cycle calculations (Week 13 Assignment • DC-DC Converters • Switching Power Supplies).
img: /assets/img/ee336/assignment-13/boost_converter_circuit.png
category: coursework
importance: 8720809056
related_publications: true
tags:
  - boost converter
  - duty cycle
  - inductor current ripple
  - dc-dc converter
  - power electronics
  - switching waveforms
---

This assignment explores **DC-DC power conversion** fundamentals, focusing on **boost converters** and their operating characteristics. The problems cover waveform DC value analysis and a complete boost converter design calculation including duty cycle determination and average current analysis.

**Author:** Steven Placzek  
**Course:** EE-336 Electrical Energy Systems  
**Date:** April 21, 2025

---

## Problem 1: Waveform DC Value Comparison

Given three periodic waveforms (A, B, and C), determine which has the highest and lowest DC (average) value.

### Solution

The **DC value** of a periodic waveform is simply its **time-average** over one complete period:

$$
V_{DC} = \frac{1}{T} \int_0^T v(t) \, dt
$$

Graphically, this corresponds to the horizontal line that makes the area above and below it equal.

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-13/waveform_dc_comparison.png" title="Waveform DC Value Comparison" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  Three waveforms with different DC offsets. Waveform A (blue) has the highest DC value at 3.0V, while Waveform C (orange) has the lowest at -1.0V. The dashed red lines indicate the average (DC) value of each waveform.
</div>

**Answer:**
- **Waveform A** has the **highest** DC value
- **Waveform C** has the **smallest** DC value

---

## Problem 2: Boost Converter Analysis

A boost converter circuit is given with the following specifications:

| Parameter | Value |
|:--|--:|
| Input Voltage $$V_{in}$$ | 9 V |
| Output Voltage $$V_{out}$$ | 12 V |
| Average Output Current $$\langle I_{out} \rangle$$ | 9 A |

### Circuit Topology

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-13/boost_converter_circuit.png" title="Boost Converter Circuit Schematic" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  Boost converter topology showing the inductor L, main switch SW1, freewheeling diode SW2, output capacitor C, and load resistor R. The input supplies 9V and the output delivers 12V.
</div>

### Part A: Duty Cycle Calculation

The boost converter voltage transfer function in **continuous conduction mode (CCM)** is:

$$
\frac{V_{out}}{V_{in}} = \frac{1}{1-D}
$$

where $$D$$ is the duty cycle (fraction of the switching period that SW1 is closed).

**Solution:**

$$
\frac{12}{9} = \frac{1}{1-D}
$$

$$
1-D = \frac{9}{12} = 0.75
$$

$$
\boxed{D = 0.25 = 25\%}
$$

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-13/voltage_gain_vs_duty_cycle.png" title="Boost Converter Voltage Gain" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  Voltage gain characteristic of a boost converter. The operating point at D = 25% yields a gain of 1.33, stepping up 9V to 12V. Higher duty cycles produce larger voltage boosts but increase component stress.
</div>

### Part B: Switch Timing Analysis

Since $$D = 25\%$$:
- **SW1 (main switch)** is closed for $$D \cdot T = 0.25T$$ each period
- **SW2 (diode)** conducts for $$(1-D) \cdot T = 0.75T$$ each period

**Conclusion:** SW1 is closed for a **shorter** duration than SW2 conducts each switching period. In other words, **SW2 conducts longer than SW1 is closed**.

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-13/switching_waveforms.png" title="Switching Waveforms" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  Complementary switching waveforms for SW1 and SW2. With D = 25%, SW1 is ON for only 25% of each period while SW2 (the diode path) conducts for the remaining 75%.
</div>

### Part C: Average Inductor Current

In steady-state, the average inductor current relates to the average output current by:

$$
\langle I_L \rangle = \frac{\langle I_{out} \rangle}{1-D}
$$

This relationship arises because current flows to the output **only** when SW2 is conducting (the $$(1-D)$$ portion of each cycle).

**Solution:**

$$
\langle I_L \rangle = \frac{9\text{ A}}{1-0.25} = \frac{9\text{ A}}{0.75} = \boxed{12\text{ A}}
$$

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-13/inductor_current_waveform.png" title="Current Waveforms" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  Inductor and output current waveforms. The inductor current has a triangular ripple with an average of 12A. Output current only flows during the SW2 conduction interval (75% of each period), resulting in a 9A average.
</div>

---

## Summary of Results

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-13/boost_converter_summary.png" title="Solution Summary" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  Complete summary of the boost converter analysis showing given values, key equations, solution steps, and final answers.
</div>

| Problem | Question | Answer |
|:--|:--|:--|
| 1 | Highest DC waveform | **Waveform A** |
| 1 | Smallest DC waveform | **Waveform C** |
| 2a | Duty cycle $$D$$ | **25%** |
| 2b | Which switch conducts longer? | **SW2** (diode) |
| 2c | Average inductor current | **12 A** |

---

## Key Equations Reference

**Boost Converter (CCM):**

$$
\frac{V_{out}}{V_{in}} = \frac{1}{1-D}
$$

$$
\langle I_L \rangle = \frac{\langle I_{out} \rangle}{1-D} = \langle I_{in} \rangle
$$

$$
P_{in} = P_{out} \quad \Rightarrow \quad V_{in} \cdot \langle I_L \rangle = V_{out} \cdot \langle I_{out} \rangle
$$

---

## Notes

- All analysis assumes **continuous conduction mode (CCM)** where the inductor current never falls to zero.
- Ideal components are assumed (no losses in switches, inductor, or capacitor).
- The duty cycle $$D$$ must remain below 1 for proper boost operation; practical designs typically limit $$D < 0.8$$ to avoid excessive component stress.
