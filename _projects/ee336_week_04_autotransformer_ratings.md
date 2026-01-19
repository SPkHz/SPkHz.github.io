---

layout: page
title: Autotransformer Power Rating
description: Isolation transformer to autotransformer conversion analysis (3:1 turns ratio • power rating comparison • step-up vs step-down configurations).
img: /assets/img/ee336/assignment-04/04_power_comparison.png
category: coursework
importance: 904225214604
related_publications: true
tags:
  - autotransformer
  - power rating
  - turns ratio
  - step-up step-down
  - apparent power
  - transformer analysis
---

This assignment analyzes how a **3:1 isolation transformer** rated at **10 kVA** can be rewired as an **autotransformer** to achieve higher power capacity. The key insight is that **two distinct autotransformer configurations exist**, and identifying the **maximum power rating** requires evaluating both.

**Author:** Steven Placzek  
**Course:** EE-336 — Electrical Energy Systems  
**Date:** 2025-02-16

---

## Problem Statement

Consider a two-winding transformer with turns ratio **N₁ = 3** and **N₂ = 1** (3:1 step-down), rated at **10 kVA** when used as an isolation transformer. Determine the **maximum power rating** when this transformer is rewired as an autotransformer.

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-04/01_isolation_transformer.png" title="Isolation transformer configuration" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  <b>Isolation Transformer:</b> Standard configuration with electrically isolated primary (N₁=3) and secondary (N₂=1) windings. Power rating S<sub>iso</sub> = 10 kVA.
</div>

---

## Fundamental Relationships

For an ideal transformer operating as an **isolation transformer**:

$$
\frac{V_1}{V_2} = \frac{N_1}{N_2} = 3 \quad \Rightarrow \quad V_2 = \frac{V_1}{3}
$$

$$
\frac{I_1}{I_2} = \frac{N_2}{N_1} = \frac{1}{3} \quad \Rightarrow \quad I_2 = 3I_1
$$

The apparent power is constrained by the winding ratings:

$$
S_{\text{iso}} = V_1 I_1 = V_2 I_2 = 10 \text{ kVA}
$$

---

## Autotransformer Configurations

When windings are connected in series-additive configuration, an autotransformer is formed. **Two distinct configurations** are possible depending on which terminals serve as input/output.

### Configuration A — Step-Down (Input Across Full Winding)

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-04/02_autotransformer_config_a.png" title="Autotransformer Configuration A" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  <b>Configuration A:</b> Input applied across both windings (V<sub>H</sub> = V₁ + V₂), output tapped from N₂ only. This creates a <b>step-down</b> autotransformer.
</div>

**Voltage Analysis:**

$$
V_H = V_1 + V_2 = V_1 + \frac{V_1}{3} = \frac{4}{3}V_1
$$

$$
V_X = V_1
$$

**Power Calculation:**

The input current equals the primary current (series path):

$$
I_H = I_1 = \frac{10\text{ kVA}}{V_1}
$$

Therefore:

$$
S_A = V_H \cdot I_H = \frac{4}{3}V_1 \cdot \frac{10\text{ kVA}}{V_1} = \frac{40}{3} \text{ kVA} = 13.33 \text{ kVA}
$$

This represents a **+33.3%** increase over the isolation rating.

---

### Configuration B — Step-Up (Input Across N₂ Only) ✓ MAXIMUM

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-04/03_autotransformer_config_b.png" title="Autotransformer Configuration B" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  <b>Configuration B:</b> Input applied across N₂ only (V<sub>H</sub> = V₂), output taken across both windings. This creates a <b>step-up</b> autotransformer with <b>maximum power transfer</b>.
</div>

**Voltage Analysis:**

$$
V_H = V_2 = \frac{V_1}{3}
$$

$$
V_X = V_1 + V_2 = \frac{4}{3}V_1
$$

**Power Calculation:**

The key insight is that in this configuration, the input current is the **sum** of both winding currents:

$$
I_H = I_1 + I_2
$$

From the isolation transformer ratings:

$$
I_1 = \frac{10\text{ kVA}}{V_1}, \quad I_2 = \frac{10\text{ kVA}}{V_2} = \frac{10\text{ kVA}}{V_1/3} = \frac{30\text{ kVA}}{V_1}
$$

Therefore:

$$
I_H = \frac{10\text{ kVA}}{V_1} + \frac{30\text{ kVA}}{V_1} = \frac{40\text{ kVA}}{V_1}
$$

And the autotransformer power rating:

$$
S_B = V_H \cdot I_H = \frac{V_1}{3} \cdot \frac{40\text{ kVA}}{V_1} = \frac{40}{3} \cdot 3 \text{ kVA} = \boxed{40 \text{ kVA}}
$$

This represents a **+300%** increase over the isolation rating.

---

## General Formula

The autotransformer power rating can be expressed as:

$$
S_{\text{auto}} = S_{\text{iso}} \times \frac{x + 1}{x}
$$

where $$x$$ is the **effective turns ratio** for the given configuration.

| Configuration | Turns Ratio x | S<sub>auto</sub> | Increase |
|:---:|:---:|:---:|:---:|
| A (Step-Down) | N₁/N₂ = 3 | 10 × (4/3) = 13.33 kVA | +33.3% |
| B (Step-Up) | N₂/N₁ = 1/3 | 10 × (4/1) = 40 kVA | +300% |

The formula shows that **smaller values of x yield larger power ratings**. For a step-up configuration where x < 1, the multiplier (x+1)/x becomes large.

---

## Results Summary

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-04/04_power_comparison.png" title="Power rating comparison" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  <b>Comparison:</b> The step-up autotransformer configuration (B) achieves the maximum power rating of <b>40 kVA</b>, a 4× improvement over the isolation transformer.
</div>

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-04/05_autotransformer_principles.png" title="Autotransformer principles" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  <b>Key Principle:</b> Autotransformers achieve higher power ratings by utilizing <i>conduction</i> (direct electrical connection) in addition to <i>transformation</i> (magnetic coupling). The step-up configuration maximizes this benefit.
</div>

---

## Key Takeaways

1. **Two configurations exist**: Any two-winding transformer can be rewired as either a step-up or step-down autotransformer.

2. **Maximum power occurs in step-up mode**: For a 3:1 isolation transformer, the step-up autotransformer achieves **40 kVA** (4× the isolation rating).

3. **The original submission error**: Finding only one configuration (13.33 kVA) missed the maximum power rating by not considering the step-up arrangement.

4. **Physical interpretation**: Autotransformers handle more power because part of the energy transfer occurs via direct electrical conduction rather than magnetic coupling, reducing the VA burden on the windings.

---

## Correction Notes

The original submission calculated **S = 13.33 kVA** using only Configuration A. The correct answer requires recognizing that **Configuration B yields the maximum** at **S = 40 kVA**.

> **Maximum Power Rating as Autotransformer: 40 kVA**
