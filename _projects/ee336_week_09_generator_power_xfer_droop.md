---
layout: page
title: EE-336 Power Transfer & Frequency Droop Analysis
description: Generator power transfer calculation via transformer and frequency droop characteristic analysis for parallel generators (Per-unit analysis • Power-angle relationship • Droop control).
img: /assets/img/ee336/assignment-09/problem1_power_angle.png
importance: 2
category: coursework
related_publications: false
---

This assignment analyzes **real power transfer** from a generator to the grid through a transformer using **per-unit analysis**, and examines **frequency droop characteristics** for parallel generator operation.

**Author:** Steven Placzek  
**Course:** EE-336 — Electrical Energy Systems  
**Date:** March 25, 2025

---

## Problem 1: Generator Power Transfer via Transformer

### Problem Statement

Consider a generator connected to the transmission system via a transformer:

| Parameter | Value |
|:--|--:|
| Generator base voltage | 23 kV |
| Transformer reactance | 5% (p.u.) |
| Transformer turns ratio | 1:5 |
| System base power | 200 MVA |

**Question:** How much real power does the generator transfer to the grid when its voltage is **22.5 kV** and **leads** the grid voltage by **5 degrees**?

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-09/problem1_circuit.png" title="Generator-Transformer-Grid System" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  Single-line diagram of the generator connected to the infinite bus (grid) via a step-up transformer.
</div>

---

### Solution

#### Step 1: Establish Base Values

The transformer has a 1:5 turns ratio, which sets up two voltage zones:

$$
V_{base,1} = 23 \text{ kV} \quad \text{(generator side)}
$$

$$
V_{base,2} = 23 \times 5 = 115 \text{ kV} \quad \text{(grid side)}
$$

$$
S_{base} = 200 \text{ MVA}
$$

#### Step 2: Convert to Per-Unit Values

**Generator voltage:**

$$
\tilde{V}_{gen} = \frac{22.5}{23} \angle 5° = 0.9783 \angle 5° \text{ p.u.}
$$

**Grid voltage** (given as 112.5 kV on the HV side):

$$
\tilde{V}_{grid} = \frac{112.5}{115} \angle 0° = 0.9783 \angle 0° \text{ p.u.}
$$

**Transformer reactance:**

$$
X_{g1} = 0.05 \text{ p.u.}
$$

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-09/problem1_pu_circuit.png" title="Per-Unit Equivalent Circuit" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  Per-unit equivalent circuit for power transfer analysis. The transformer is represented by its series reactance.
</div>

#### Step 3: Apply Power Transfer Formula

For a lossless transmission element, real power transfer is given by:

$$
P = \frac{V_{gen} \cdot V_{grid}}{X} \sin(\delta)
$$

where $\delta = 5°$ is the power angle (phase difference between generator and grid voltages).

Substituting values:

$$
P_{pu} = \frac{0.9783 \times 0.9783}{0.05} \sin(5°)
$$

$$
P_{pu} = \frac{0.9571}{0.05} \times 0.0872 = 19.14 \times 0.0872 = 1.668 \text{ p.u.}
$$

#### Step 4: Convert to Physical Units

$$
\boxed{P = 1.668 \times 200 \text{ MVA} = 333.6 \text{ MW} \approx 334 \text{ MW}}
$$

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-09/problem1_power_angle.png" title="Power-Angle Characteristic" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  Power-angle (P-δ) curve showing the operating point at δ = 5°. The sinusoidal relationship governs steady-state power transfer between synchronous machines.
</div>

---

## Problem 2: Frequency Droop Characteristics

### Problem Statement

Consider the following frequency droop characteristics for two generators with the **same no-load frequency** $f_{NL}$:

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-09/problem2_droop.png" title="Droop Characteristics" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  Frequency droop characteristics for generators A and B. Generator A has a shallower slope (2% droop), while Generator B has a steeper slope (4% droop).
</div>

**Questions:**

1. Which generator is **more heavily loaded** compared to its rating?
2. When $f_{grid}$ changes, which generator has a **larger change in load** compared to its rating?

---

### Solution

#### Droop Control Fundamentals

The frequency droop characteristic relates generator frequency to power output:

$$
f = f_{NL} - R \cdot P
$$

where $R$ is the droop coefficient (slope). **Droop percentage** is defined as:

$$
\text{Droop \%} = \frac{f_{NL} - f_{FL}}{f_{NL}} \times 100\%
$$

where $f_{FL}$ is the frequency at full load.

#### Analysis of the Droop Curves

From the characteristic curves at grid frequency $f_{grid}$:

| Generator | Droop | Loading at $f_{grid}$ |
|:--|:--|--:|
| A | 2% (shallower) | ~50% |
| B | 4% (steeper) | ~25% |

#### Answer 1: More Heavily Loaded Generator

$$
\boxed{\textbf{Generator A}}
$$

**Reasoning:** At the operating frequency $f_{grid}$, Generator A intersects at approximately **50% of its rated capacity**, while Generator B operates at only **25%**. Therefore, A is more heavily loaded relative to its rating.

#### Answer 2: Larger Load Change with Frequency

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-09/problem2_frequency_change.png" title="Response to Frequency Change" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  When grid frequency drops from f₁ to f₂, Generator A experiences a larger percentage change in power output due to its shallower droop slope.
</div>

$$
\boxed{\textbf{Generator A}}
$$

**Reasoning:** A shallower droop slope means that for the same frequency deviation $\Delta f$, the generator experiences a **larger change in power output** (as a percentage of rating):

$$
\Delta P = \frac{\Delta f}{R}
$$

Since $R_A < R_B$ (shallower slope = smaller droop coefficient), we have:

$$
\Delta P_A > \Delta P_B
$$

Generator A is **more responsive** to frequency changes, making it pick up (or shed) a larger share of load during transients.

---

## Key Concepts Summary

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-09/solution_summary.png" title="Solution Summary" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

### Power Transfer (Problem 1)
- Per-unit analysis simplifies calculations across transformer voltage zones
- Power transfer follows $P = \frac{V_1 V_2}{X} \sin(\delta)$
- Small angles: $\sin(\delta) \approx \delta$ provides good approximation

### Droop Control (Problem 2)
- **Less droop (shallower slope):** More responsive, larger load share changes
- **More droop (steeper slope):** Less responsive, more stable load sharing
- Droop control enables **automatic load sharing** among parallel generators

---

## Notes

This analysis assumes ideal conditions (lossless transformer, infinite bus). In practice, transformer resistance, line impedance, and generator dynamics introduce additional considerations for power system stability analysis.
