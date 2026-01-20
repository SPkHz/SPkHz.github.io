---
layout: page
title: Three-Phase Apparent Power
description: Calculating total 3-phase apparent power for a Δ-connected balanced load (MATLAB • phasor analysis • power systems).
img: /assets/img/ee336/assignment-01/delta_connected_circuit.png
category: coursework
importance: 2124651598013
related_publications: true
tags:
  - three-phase power
  - apparent power
  - delta load
  - balanced load
  - phasor analysis
  - power systems
---

This assignment analyzes a **balanced three-phase system** with a **delta (Δ)-connected load** to compute the total apparent power. The problem reinforces the critical distinction between **Y-connected** and **Δ-connected** configurations—a common source of errors in power systems calculations.

**Author:** Steven Placzek  
**Course:** EE 336 — Power Systems  
**Date:** January 31, 2025  
**Tools:** MATLAB, hand calculations

---

## Problem Statement

Consider the following balanced 3-phase system with a Δ-connected load:

<div class="row justify-content-sm-center">
  <div class="col-sm-10 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-01/delta_connected_circuit.png" title="Three-phase delta-connected load circuit" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  Three-phase system with Y-connected source and Δ-connected load. Each phase impedance has magnitude |Z̃| = 48 Ω.
</div>

**Given:**

- Line-to-line voltage magnitude: $$|\tilde{V}_{LL}| = 480\ \text{V}$$
- Load impedance magnitude (per phase): $$|\tilde{Z}| = 48\ \Omega$$

**Find:** The magnitude of the total three-phase complex power $$|\tilde{S}_{3\phi}|$$ (apparent power).

---

## Solution Approach

### Key Insight: Δ-Connected Load Relationships

For a **delta-connected** load, the phase voltage equals the line-to-line voltage—this is the critical relationship that distinguishes Δ from Y configurations:

$$
V_{phase} = V_{LL} \quad \text{(for Δ)}
$$

In contrast, for a Y-connected load: $$V_{phase} = V_{LL}/\sqrt{3}$$

<div class="row justify-content-sm-center">
  <div class="col-sm-10 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-01/formula_summary.png" title="Delta connection formulas" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  Summary of delta (Δ) connection formulas for balanced three-phase systems.
</div>

### Step-by-Step Calculation

**Step 1: Phase Current**

Since this is a Δ-connected load, phase voltage equals line voltage:

$$
I_{phase} = \frac{V_{phase}}{|Z|} = \frac{V_{LL}}{|Z|} = \frac{480\ \text{V}}{48\ \Omega} = 10\ \text{A}
$$

**Step 2: Line Current**

For delta connections, line current is $$\sqrt{3}$$ times the phase current:

$$
I_L = \sqrt{3} \cdot I_{phase} = \sqrt{3} \times 10\ \text{A} = 17.32\ \text{A}
$$

**Step 3: Total Three-Phase Apparent Power**

Using the standard three-phase power formula:

$$
|\tilde{S}_{3\phi}| = \sqrt{3} \cdot V_{LL} \cdot I_L = \sqrt{3} \times 480 \times 17.32 = 14{,}400\ \text{VA}
$$

$$
\boxed{|\tilde{S}_{3\phi}| = 14.4\ \text{kVA}}
$$

**Alternative Direct Formula:**

For Δ-connected loads, we can also use:

$$
|\tilde{S}_{3\phi}| = \frac{3 \cdot V_{LL}^2}{|Z|} = \frac{3 \times (480)^2}{48} = \frac{691{,}200}{48} = 14{,}400\ \text{VA} = 14.4\ \text{kVA}
$$

---

## Common Error Analysis

My initial submission contained an error by treating the Δ-connected load as if it were Y-connected:

| Approach                     |          Phase Voltage           |    Line Current     |     Apparent Power     |
| :--------------------------- | :------------------------------: | :-----------------: | :--------------------: |
| **Incorrect (Y assumption)** | $$480/\sqrt{3} = 277\ \text{V}$$ | $$5.77\ \text{A}$$  | $$4.8\ \text{kVA}$$ ❌ |
| **Correct (Δ connection)**   |        $$480\ \text{V}$$         | $$17.32\ \text{A}$$ | $$14.4\ \text{kVA}$$ ✓ |

The instructor's feedback highlighted: _"If using phase voltage, need to use wye impedance"_—meaning the impedance value given (48 Ω) was the **per-phase delta impedance**, not the wye-equivalent.

---

## MATLAB Verification

```matlab
% Steven Placzek
% EE 336 — Assignment 01 (Corrected)

vLineToLine = 480;      % Line-to-line voltage [V]
zMagnitude = 48;        % Delta impedance magnitude per phase [Ω]

% Delta-connected load analysis
vPhase = vLineToLine;                    % For Δ: V_phase = V_LL
iPhase = vPhase / zMagnitude;            % Phase current [A]
iLine = sqrt(3) * iPhase;                % Line current [A]

% Total 3-phase apparent power
apparentPower = sqrt(3) * vLineToLine * iLine;   % [VA]

% Alternative formula verification
apparentPowerAlt = 3 * vLineToLine^2 / zMagnitude;

fprintf('=== EE 336 Assignment 01 — Corrected Solution ===\n\n')
fprintf('Phase Current:         %.4f A\n', iPhase)
fprintf('Line Current:          %.4f A\n', iLine)
fprintf('Apparent Power:        %.4f kVA\n', apparentPower/1000)
fprintf('Verification (alt):    %.4f kVA\n', apparentPowerAlt/1000)
```

**Output:**

```
=== EE 336 Assignment 01 — Corrected Solution ===

Phase Current:         10.0000 A
Line Current:          17.3205 A
Apparent Power:        14.4000 kVA
Verification (alt):    14.4000 kVA
```

---

## Key Takeaways

1. **Always identify the load configuration** (Y vs. Δ) before applying voltage/current relationships
2. For **Δ-connected loads**: $$V_{phase} = V_{LL}$$ and $$I_L = \sqrt{3} \cdot I_{phase}$$
3. For **Y-connected loads**: $$V_{phase} = V_{LL}/\sqrt{3}$$ and $$I_L = I_{phase}$$
4. The three-phase apparent power formula $$|S| = \sqrt{3} V_{LL} I_L$$ applies to **both** configurations
5. Direct formulas can simplify calculations:
   - Delta: $$|S_{3\phi}| = 3V_{LL}^2/|Z_\Delta|$$
   - Wye: $$|S_{3\phi}| = 3V_{LL}^2/(3|Z_Y|) = V_{LL}^2/|Z_Y|$$

---

## References

- Grainger, J.J. & Stevenson, W.D., _Power System Analysis_, McGraw-Hill
- EE 336 Course Notes, Spring 2025
