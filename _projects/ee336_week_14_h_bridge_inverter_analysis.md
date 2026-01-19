---
layout: page
title: Single-Phase H-Bridge Inverter Analysis
description: H-bridge inverter switching analysis and load voltage waveform generation (MATLAB • Power Electronics • DC-AC Conversion).
img: /assets/img/ee336/assignment-14/switch_signals_and_vload.png
importance: 2
category: coursework
related_publications: false
---

This assignment analyzes a **single-phase H-bridge inverter** circuit, a fundamental topology in power electronics for DC-to-AC conversion. Given a set of switching functions for four switches (SW1–SW4), the goal is to determine the resulting **load voltage waveform** $$V_{\text{load}}(t)$$.

**Student:** Steven Placzek  
**Course:** EE-336 — Electrical Energy Systems  
**Date:** Spring 2025  
**Tools:** MATLAB (`stairs`, `subplot`, `figure`)

---

## Circuit Topology

The H-bridge inverter consists of two series-connected DC voltage sources (each $$V_{in}/2$$) and four switches arranged in an "H" configuration. The load is connected between the two bridge legs.

<div class="row">
  <div class="col-sm-8 mt-3 mt-md-0 mx-auto">
    {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-14/hbridge_circuit.png" title="H-Bridge Inverter Circuit Topology" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  <b>Single-Phase H-Bridge Inverter:</b> Two DC sources (each $$V_{in}/2$$) supply the bridge. Switches SW1 and SW4 form the left leg; SW2 and SW3 form the right leg. The load is connected horizontally between the midpoints of each leg.
</div>

---

## Switching Logic

The H-bridge can produce three distinct output voltage levels based on which switch pairs are activated:

| SW1 | SW2 | SW3 | SW4 | $$V_{\text{load}}$$ | Current Path |
|:---:|:---:|:---:|:---:|:---:|:---|
| ON | OFF | ON | OFF | $$+V_{in}$$ | Top-Left → Load → Bottom-Right |
| OFF | ON | OFF | ON | $$-V_{in}$$ | Top-Right → Load → Bottom-Left |
| Other combinations | | | | $$0$$ | No current or short-circuit protection |

The key operating principle:
- **SW1 & SW3 ON** (diagonal pair): Current flows left-to-right through load → $$V_{\text{load}} = +V_{in}$$
- **SW2 & SW4 ON** (opposite diagonal): Current flows right-to-left through load → $$V_{\text{load}} = -V_{in}$$
- **All other states**: Load voltage is zero (either both top/bottom switches ON, or no complete path)

<div class="row">
  <div class="col-sm-10 mt-3 mt-md-0 mx-auto">
    {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-14/switching_logic_table.png" title="H-Bridge Switching Logic Truth Table" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  <b>Switching Logic Summary:</b> Green indicates positive output, red indicates negative output, and yellow indicates zero-voltage states.
</div>

---

## Given Switching Patterns

The assignment provides the following 22-step switching sequences:

```matlab
t = 1:22;

SW1 = [0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1];
SW2 = [1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1];
SW3 = [0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0];
SW4 = [1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0];
```

Where a high value (1) indicates the switch is **closed** (ON) and a low value (0) indicates the switch is **open** (OFF).

---

## Solution: Load Voltage Waveform

Applying the switching logic to each time step:

```matlab
Vload = zeros(size(t));
for i = 1:length(t)
    if SW1(i) == 1 && SW3(i) == 1
        Vload(i) = +Vin;
    elseif SW2(i) == 1 && SW4(i) == 1
        Vload(i) = -Vin;
    else
        Vload(i) = 0;
    end
end
```

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-14/switch_signals_and_vload.png" title="Switch Signals and Load Voltage" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  <b>Complete Waveform Analysis:</b> The top four subplots show the individual switch states (ON/OFF), and the bottom subplot shows the resulting load voltage $$V_{\text{load}}(t)$$ oscillating between $$+V_{in}$$, $$0$$, and $$-V_{in}$$.
</div>

---

## Detailed Output Analysis

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-14/vload_annotated.png" title="Annotated Load Voltage with Active Switch Pairs" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  <b>Annotated Output:</b> Green regions indicate when SW1 & SW3 are both ON (positive output), red regions indicate when SW2 & SW4 are both ON (negative output), and gray regions indicate zero-voltage states.
</div>

The load voltage waveform exhibits a **quasi-square wave** pattern with the following characteristics:
- **Period:** Approximately 8 time steps per full cycle
- **Duty cycle:** Varies due to intermediate zero-voltage states
- **Peak-to-peak voltage:** $$2V_{in}$$

---

## Individual Switch Behavior

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-14/individual_switch_signals.png" title="Individual Switch Signals" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  <b>Individual Switch Patterns:</b> Each switch follows a periodic pattern with phase offsets to achieve the desired output waveform. Note that SW1/SW3 and SW2/SW4 form complementary diagonal pairs.
</div>

---

## Clean Output Waveform

<div class="row">
  <div class="col-sm-10 mt-3 mt-md-0 mx-auto">
    {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-14/vload_output.png" title="Load Voltage Output" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  <b>Final Result:</b> The H-bridge inverter output $$V_{\text{load}}(t)$$ shows the characteristic three-level waveform typical of single-phase inverters with this switching strategy.
</div>

---

## Key Observations

1. **Three-Level Output:** The inverter produces a three-level output ($$+V_{in}$$, $$0$$, $$-V_{in}$$) rather than a simple two-level square wave, which can help reduce harmonic content.

2. **Dead Time:** The zero-voltage intervals between positive and negative pulses act as "dead time," preventing shoot-through conditions where both switches in a leg conduct simultaneously.

3. **Switching Frequency:** The output frequency is determined by the switching pattern repetition rate. In this case, approximately one complete cycle occurs every 8 time steps.

4. **Practical Considerations:** In real implementations, the switches would typically be IGBTs or MOSFETs with anti-parallel diodes to handle inductive load currents during switching transitions.

---

## MATLAB Implementation

The complete MATLAB code for this analysis:

```matlab
% Steven Placzek
% EE 336 - Week 14 Assignment

t = 1:22;

SW1 = [0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1];
SW2 = [1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1];
SW3 = [0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0];
SW4 = [1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0];

Vin = 1;
Vload = zeros(size(t));

for i = 1:length(t)
    if SW1(i) == 1 && SW3(i) == 1
        Vload(i) = +Vin;
    elseif SW2(i) == 1 && SW4(i) == 1
        Vload(i) = -Vin;
    else
        Vload(i) = 0;
    end
end

figure(1);
subplot(5,1,1); stairs(t, SW1, 'LineWidth', 2);
xlim([1, 22]); ylim([-0.1, 1.1]); ylabel('SW1'); grid on;
title('Switch Signals and V_{Load} Voltage');

subplot(5,1,2); stairs(t, SW2, 'LineWidth', 2);
xlim([1, 22]); ylim([-0.1, 1.1]); ylabel('SW2'); grid on;

subplot(5,1,3); stairs(t, SW3, 'LineWidth', 2);
xlim([1, 22]); ylim([-0.1, 1.1]); ylabel('SW3'); grid on;

subplot(5,1,4); stairs(t, SW4, 'LineWidth', 2);
xlim([1, 22]); ylim([-0.1, 1.1]); ylabel('SW4'); grid on;

subplot(5,1,5); stairs(t, Vload, 'LineWidth', 2);
xlim([1, 22]); ylim([-Vin*1.1, Vin*1.1]);
ylabel('V_{load} (V)'); xlabel('Time Step'); grid on;
```

---

## Notes

This analysis demonstrates the fundamental operation of a single-phase H-bridge inverter, a building block for many power electronic applications including motor drives, uninterruptible power supplies (UPS), and grid-tied solar inverters. Real-world implementations would include additional considerations such as PWM modulation for output voltage control, snubber circuits for switch protection, and filtering for harmonic reduction.
