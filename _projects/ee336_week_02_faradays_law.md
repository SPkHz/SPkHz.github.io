---
layout: page
title: Assignment 02
description: Faraday's Law, Synchronous Generator Speed, and Phasor Analysis
img: assets/img/ee336/assignment-02/problem4_phasor.png
importance: 2
category: EE-336
related_publications: false
---

## Course Information

**Course:** EE-336 — Electrical Energy Systems  
**Assignment:** Week 2 Assignment  
**Date:** January 31, 2025  
**Author:** Steven Placzek

---

## Problem 1: Faraday's Law and Induced Voltage

### Problem Statement

Consider a conductive loop in a time-varying magnetic field $$\vec{B}$$. Given Faraday's Law:

$$\oint \vec{E} \cdot d\vec{l} = -\frac{d}{dt} \iint \vec{B} \cdot d\vec{S}$$

Draw the time-domain voltage $$V(t)$$ with correct phase with respect to $$B(t)$$, and draw the phasor $$\tilde{V}$$ with correct phase with respect to phasor $$\vec{B}$$.

### Solution

For a sinusoidal magnetic field with period $$T = 6$$ seconds:

$$B(t) = B_0 \sin(\omega t)$$

where the angular frequency is:

$$\omega = \frac{2\pi}{T} = \frac{2\pi}{6} = \frac{\pi}{3} \text{ rad/s}$$

Therefore:

$$B(t) = B_0 \sin\left(\frac{\pi t}{3}\right)$$

By Faraday's Law, the induced voltage is the negative time derivative of the magnetic flux. Assuming the flux is proportional to the magnetic field:

$$\tilde{V}(t) = -\frac{d\Phi}{dt} \propto -\frac{dB}{dt} = -\frac{B_0 \pi}{3} \cos\left(\frac{\pi t}{3}\right)$$

This can be rewritten using the identity $$-\cos(\theta) = \sin(\theta - 90°)$$:

$$\tilde{V}(t) \propto \sin\left(\frac{\pi t}{3} - \frac{\pi}{2}\right)$$

**Key Observation:** The induced voltage **lags** the magnetic field by **90°**.

<div class="row justify-content-center">
    <div class="col-sm-10 mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-02/problem1_waveforms.png" title="Problem 1 Waveforms" class="img-fluid rounded z-depth-1" %}
    </div>
</div>
<div class="caption">
    Time-domain representation showing B(t) (dashed) and V(t) (solid blue). Note the 90° phase lag of V(t) relative to B(t).
</div>

<div class="row justify-content-center">
    <div class="col-sm-8 mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-02/problem1_phasor.png" title="Problem 1 Phasor" class="img-fluid rounded z-depth-1" %}
    </div>
</div>
<div class="caption">
    Phasor diagram showing the 90° phase relationship between \(\vec{B}\) and \(\tilde{V}\). The voltage phasor lags the magnetic field phasor by 90°.
</div>

---

## Problem 2: Synchronous Generator Speed

### Problem Statement

What is the mechanical speed in RPM of a 2-pole synchronous generator?

### Solution

The synchronous speed of an AC machine is given by:

$$N_s = \frac{120 f}{P}$$

where:
- $$N_s$$ = synchronous speed (RPM)
- $$f$$ = electrical frequency (Hz)
- $$P$$ = number of poles

Assuming the standard North American grid frequency of $$f = 60$$ Hz:

$$N_s = \frac{120 \times 60}{2} = \frac{7200}{2} = \boxed{3600 \text{ RPM}}$$

---

## Problem 3: Minimum Number of Poles

### Problem Statement

Consider that due to vibration issues, a turbine has a maximum speed of 1,000 RPM. What is the minimum number of poles that a synchronous machine must have to be able to use this turbine as its prime mover?

### Solution

Rearranging the synchronous speed equation to solve for the number of poles:

$$P = \frac{120 f}{N_s}$$

#### For 60 Hz System (North America)

$$P = \frac{120 \times 60}{1000} = 7.2$$

Since the number of poles must be an **even integer**, we round up:

$$\boxed{P_{\min} = 8 \text{ poles at } 60 \text{ Hz}}$$

This gives an actual synchronous speed of:

$$N_s = \frac{120 \times 60}{8} = 900 \text{ RPM} \leq 1000 \text{ RPM} \checkmark$$

#### For 50 Hz System (Europe/Asia)

$$P = \frac{120 \times 50}{1000} = 6$$

$$\boxed{P_{\min} = 6 \text{ poles at } 50 \text{ Hz}}$$

This gives an actual synchronous speed of:

$$N_s = \frac{120 \times 50}{6} = 1000 \text{ RPM} \leq 1000 \text{ RPM} \checkmark$$

| # of Poles | $$N_s$$ at 60 Hz (RPM) |
|:----------:|:----------------------:|
| 2          | 3600                   |
| 4          | 1800                   |
| 6          | 1200                   |
| **8**      | **900** ✓              |

---

## Problem 4: Synchronous Generator Phasor Diagram

### Problem Statement

Consider the following model of a synchronous generator connected to a load $$\tilde{Z}_L$$ where:

$$\tilde{Z}_L = |\tilde{Z}_L| \cos(45°) + j|\tilde{Z}_L| \sin(45°) = |\tilde{Z}_L| \angle 45° \, \Omega$$

Using phasor $$\tilde{V}_t$$ as reference, draw the remaining phasors $$\tilde{E}_g$$, $$\tilde{I}_a$$, and $$jX_s\tilde{I}_a$$ with correct phase and reasonable magnitudes.

<div class="row justify-content-center">
    <div class="col-sm-8 mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-02/generator_circuit.png" title="Generator Circuit" class="img-fluid rounded z-depth-1" %}
    </div>
</div>
<div class="caption">
    Synchronous generator equivalent circuit with internal EMF \(\tilde{E}_g\), synchronous reactance \(jX_s\), and load impedance \(\tilde{Z}_L\).
</div>

### Solution

**Step 1: Establish the reference**

Let $$\tilde{V}_t = |V_t| \angle 0°$$ (terminal voltage along the positive real axis)

**Step 2: Find the armature current**

$$\tilde{I}_a = \frac{\tilde{V}_t}{\tilde{Z}_L} = \frac{|V_t| \angle 0°}{|\tilde{Z}_L| \angle 45°} = \frac{|V_t|}{|\tilde{Z}_L|} \angle -45°$$

The current **lags** the terminal voltage by 45° (lagging power factor load).

**Step 3: Find the voltage drop across synchronous reactance**

$$jX_s \tilde{I}_a = X_s \angle 90° \cdot |\tilde{I}_a| \angle -45° = X_s |\tilde{I}_a| \angle 45°$$

This voltage is **90° ahead** of the armature current.

**Step 4: Apply KVL to find the internal EMF**

$$\tilde{E}_g = \tilde{V}_t + jX_s \tilde{I}_a$$

The internal EMF leads the terminal voltage by the power angle $$\delta$$.

<div class="row justify-content-center">
    <div class="col-sm-10 mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-02/problem4_phasor.png" title="Problem 4 Phasor Diagram" class="img-fluid rounded z-depth-1" %}
    </div>
</div>
<div class="caption">
    Phasor diagram for the synchronous generator with a load impedance of \(\tilde{Z}_L = |\tilde{Z}_L| \angle 45°\, \Omega\). The terminal voltage is the reference, current lags by 45°, and \(jX_s\tilde{I}_a\) leads the current by 90°.
</div>

---

## Problem 5: Generator Operating Conditions Analysis

### Problem Statement

Consider a generator model operating under two different loading conditions represented by the following phasor diagrams:

<div class="row justify-content-center">
    <div class="col-sm-12 mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-02/problem5_conditions.png" title="Problem 5 Conditions" class="img-fluid rounded z-depth-1" %}
    </div>
</div>
<div class="caption">
    Phasor diagrams for Condition A (underexcited) and Condition B (overexcited) generator operation.
</div>

Which condition(s):
- Supply real power?
- Supply reactive power?
- Are underexcited?
- Supplies more real power than the other?

### Solution

#### Real Power Analysis

Real power transfer from the generator is given by:

$$P = \frac{|E_g||V_t|}{X_s} \sin(\delta)$$

where $$\delta$$ is the power angle (angle between $$\tilde{E}_g$$ and $$\tilde{V}_t$$).

**Both conditions A and B supply real power** because $$\delta > 0$$ in both cases ($$\tilde{E}_g$$ leads $$\tilde{V}_t$$).

$$\boxed{\text{Real Power: Conditions A and B}}$$

#### Reactive Power Analysis

Reactive power depends on the relative magnitudes of $$|\tilde{E}_g|$$ and $$|\tilde{V}_t|$$:

- **Condition A:** $$|\tilde{E}_g| < |\tilde{V}_t|$$ — The generator **absorbs** reactive power (appears as a lagging load to the system)
- **Condition B:** $$|\tilde{E}_g| > |\tilde{V}_t|$$ — The generator **supplies** reactive power (appears as a leading load to the system)

$$\boxed{\text{Supplies Reactive Power: Condition B}}$$

#### Excitation State

The excitation state is determined by comparing $$|\tilde{E}_g|$$ to $$|\tilde{V}_t|$$:

- **Underexcited:** $$|\tilde{E}_g| < |\tilde{V}_t|$$
- **Overexcited:** $$|\tilde{E}_g| > |\tilde{V}_t|$$

$$\boxed{\text{Underexcited: Condition A}}$$

#### Comparison of Real Power

Since $$P \propto \sin(\delta)$$ and observing that $$\delta_B > \delta_A$$:

$$P_B > P_A$$

$$\boxed{\text{More Real Power: Condition B}}$$

### Summary Table

| Property | Condition A | Condition B |
|:---------|:-----------:|:-----------:|
| Supplies Real Power | ✓ | ✓ |
| Supplies Reactive Power | ✗ (absorbs) | ✓ |
| Underexcited | ✓ | ✗ |
| More Real Power | ✗ | ✓ |

---

## Key Concepts Summary

1. **Faraday's Law:** Induced voltage is the negative time derivative of magnetic flux, creating a 90° phase lag between voltage and magnetic field.

2. **Synchronous Speed:** $$N_s = \frac{120f}{P}$$ — Speed is inversely proportional to the number of poles.

3. **Pole Count:** Must be an even integer; for speed-limited prime movers, more poles reduce the required speed.

4. **Phasor Relationships in Generators:**
   - $$\tilde{E}_g = \tilde{V}_t + jX_s\tilde{I}_a$$
   - $$jX_s\tilde{I}_a$$ always leads $$\tilde{I}_a$$ by 90°

5. **Generator Excitation:**
   - Overexcited ($$|\tilde{E}_g| > |\tilde{V}_t|$$): Supplies reactive power
   - Underexcited ($$|\tilde{E}_g| < |\tilde{V}_t|$$): Absorbs reactive power

6. **Power Angle:** The angle $$\delta$$ between $$\tilde{E}_g$$ and $$\tilde{V}_t$$ determines real power transfer; larger $$\delta$$ means more real power (up to stability limits).