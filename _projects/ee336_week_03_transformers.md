---
layout: page
title: Delta-Y Transformer Analysis
description: Three-phase transformer voltage analysis for Δ-Y configuration (Electrical Energy Systems • 480V line-to-line • Turns ratio derivation).
img: /assets/img/ee336/assignment-03/circuit_diagram.png
category: coursework
importance: 1213772857596
related_publications: true
tags:
  - delta-wye transformer
  - line-to-line voltage
  - turns ratio
  - three-phase
  - phasor analysis
  - power systems
---

This assignment analyzes a **three-phase Delta-Y (Δ-Y) transformer** to determine the secondary line-to-line voltage magnitude given the primary configuration and voltage.

**Course:** EE-336 – Electrical Energy Systems  
**Date:** 2025-01-31  
**Author:** Steven Placzek

---

## Problem Statement

Consider a three-phase transformer with the following configuration:

- **Primary:** Delta (Δ) connected at $$V_{LL} = 480V$$ line-to-line
- **Secondary:** Wye (Y) connected
- **Turns ratio:** $$N_1 \neq N_2$$

**Find:** The magnitude of the secondary line-to-line voltage $$|V_{L'L'}|$$.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-03/circuit_diagram.png" title="Delta-Y Transformer Configuration" class="img-fluid rounded z-depth-1" %}
    </div>
</div>

<div class="caption">
    Three-phase Delta-Y transformer showing primary (Δ) and secondary (Y) windings with turns $N_1$ and $N_2$ respectively.
</div>

---

## Solution Approach

The solution requires understanding the voltage relationships in both delta and wye configurations, combined with the ideal transformer turns ratio.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-03/solution_flowchart.png" title="Solution Methodology" class="img-fluid rounded z-depth-1" %}
    </div>
</div>

<div class="caption">
    Step-by-step solution methodology with key three-phase transformer relationships.
</div>

### Step 1: Identify the Configuration

|   Side    | Connection |      Voltage Relationship       |       Current Relationship        |
| :-------: | :--------: | :-----------------------------: | :-------------------------------: |
|  Primary  | Delta (Δ)  |     $$V_{LL} = V_{phase}$$      | $$I_{line} = \sqrt{3} I_{phase}$$ |
| Secondary |  Wye (Y)   | $$V_{LL} = \sqrt{3} V_{phase}$$ |     $$I_{line} = I_{phase}$$      |

### Step 2: Primary Side Analysis (Delta)

For a **delta-connected** winding, the phase voltage equals the line-to-line voltage:

$$
V_{phase,1} = V_{LL,1} = 480V
$$

This is because each winding in a delta configuration is connected directly across two line terminals.

### Step 3: Apply Transformer Turns Ratio

The ideal transformer voltage relationship is:

$$
\frac{V_{phase,2}}{V_{phase,1}} = \frac{N_2}{N_1}
$$

Therefore, the secondary phase voltage is:

$$
V_{phase,2} = \frac{N_2}{N_1} \cdot V_{phase,1} = \frac{N_2}{N_1} \cdot 480V
$$

### Step 4: Secondary Side Analysis (Wye)

For a **wye-connected** winding, the line-to-line voltage is $$\sqrt{3}$$ times the phase voltage:

$$
V_{LL,2} = \sqrt{3} \cdot V_{phase,2}
$$

Substituting the expression from Step 3:

$$
|V_{L'L'}| = \sqrt{3} \cdot \frac{N_2}{N_1} \cdot 480V
$$

---

## Final Answer

$$
\boxed{|V_{L'L'}| = 480\sqrt{3}\frac{N_2}{N_1} \text{ Volts}}
$$

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-03/voltage_relationships.png" title="Voltage Transformation Flow" class="img-fluid rounded z-depth-1" %}
    </div>
</div>

<div class="caption">
    Visual representation of voltage transformation through the Delta-Y configuration.
</div>

---

## Phasor Analysis

The phasor diagrams below illustrate the voltage relationships on both the primary and secondary sides of the transformer.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-03/phasor_diagram.png" title="Phasor Diagrams" class="img-fluid rounded z-depth-1" %}
    </div>
</div>

<div class="caption">
    <b>Left:</b> Primary (Delta) voltages where phase voltage equals line voltage. <b>Right:</b> Secondary (Wye) voltages showing phase (L-N) and line (L-L) voltage phasors with the √3 magnitude relationship.
</div>

### Key Observations from Phasor Analysis

**Primary (Delta):**

- All three phase voltages ($$V_{ab}$$, $$V_{bc}$$, $$V_{ca}$$) have magnitude 480V
- Phase voltages are displaced by 120° from each other
- In delta: $$|V_{LL}| = |V_{phase}| = 480V$$

**Secondary (Wye):**

- Phase voltages ($$V_{a'n}$$, $$V_{b'n}$$, $$V_{c'n}$$) are measured line-to-neutral
- Line voltages ($$V_{a'b'}$$, $$V_{b'c'}$$, $$V_{c'a'}$$) are $$\sqrt{3}$$ times larger
- Line voltages lead their corresponding phase voltages by 30°

---

## Summary of Three-Phase Relationships

| Configuration |    Line Voltage     | Phase Voltage |    Line Current     | Phase Current |
| :-----------: | :-----------------: | :-----------: | :-----------------: | :-----------: |
| **Delta (Δ)** |       $$V_L$$       |    $$V_L$$    | $$\sqrt{3} I_{ph}$$ |  $$I_{ph}$$   |
|  **Wye (Y)**  | $$\sqrt{3} V_{ph}$$ |  $$V_{ph}$$   |       $$I_L$$       |    $$I_L$$    |

For a **Δ-Y transformer** with turns ratio $$a = N_1/N_2$$:

$$
\frac{V_{LL,secondary}}{V_{LL,primary}} = \frac{\sqrt{3}}{a} = \sqrt{3} \cdot \frac{N_2}{N_1}
$$

---

## Notes

- This analysis assumes an **ideal transformer** (no losses, infinite permeability core, no leakage flux).
- The $$\sqrt{3}$$ factor arises from the geometric relationship between phase and line quantities in three-phase systems.
- Delta-Y transformers are commonly used in power distribution to step down transmission voltages and provide a neutral point for single-phase loads.
