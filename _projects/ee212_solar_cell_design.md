---
layout: page
title: EE-212 Optimized Silicon Solar Cell Design
description: Single-junction silicon PV cell optimized in ANSYS Lumerical DEVICE (AM1.5). 16.08% efficiency with Si3N4 ARC + Al contacts, plus cost and sustainability analysis.
img: /assets/img/ee212/Design_Model.png
importance: 2
category: coursework
related_publications: false
---

<!--
Suggested asset placement (copy from your source zip):
assets/img/ee212/Design_Model.png
assets/img/ee212/Cubic_Spline_Fit_vs_Sim_Data_FINAL.png
assets/img/ee212/Power_Density_of_Cubic_Spline_Fit_v9.png
-->

This project (EE-212: Fundamentals of Electro-optics) models and optimizes a **planar, single-junction silicon solar cell** using **ANSYS Lumerical DEVICE**. The goal was straightforward: tune **layer geometry** and **doping profiles** to maximize **power density**, **fill factor**, and **conversion efficiency** under the **AM1.5 solar spectrum**, then sanity-check feasibility with a lightweight **economic + environmental** analysis.

**Toolchain:** ANSYS Lumerical DEVICE (drift–diffusion solver)  
**Focus:** Junction design, recombination tradeoffs, series resistance realism, and optical improvement via ARC.

---

## Device Stack + Key Design Choices

### Layer stack (modeled structure)

| Layer | Material | Thickness |
|---|---|---:|
| Substrate | p-type Si | 100 µm |
| N-emitter region | (doped region) | 1.5 µm |
| Front contacts (n + p) | Al | 0.3 µm |
| Anti-reflective coating (ARC) | Si₃N₄ | 2.5 µm |
| Back contact | Al | 5 µm |

### Doping + resistive assumptions (performance-driven)
- **p-type substrate:** ~1.0 Ω·cm class resistivity (selected as a tradeoff between field strength and recombination).
- **Substrate doping:** ~2 × 10¹⁶ cm⁻³  
- **n-emitter doping:** ~1 × 10¹⁷ cm⁻³ (collection vs. surface recombination balance)  
- **contact doping:** ~1 × 10¹⁸ cm⁻³ (reduced contact resistance / ohmic behavior)  
- **series resistance:** 1 Ω (keeps fill factor realistic without artificially inflating performance)

---

## Results (JV + Power Density)

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee212/Design_Model.png" title="3D solar cell structure in ANSYS Lumerical DEVICE" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee212/Cubic_Spline_Fit_vs_Sim_Data_FINAL.png" title="JV curve (simulated) + cubic spline fit" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee212/Power_Density_of_Cubic_Spline_Fit_v9.png" title="Power density vs. voltage (max power point)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  Left: the simulated 3D structure. Middle: JV curve under AM1.5 with spline-interpolated points (used to locate the knee cleanly). Right: power density peaks near the knee, defining the max-power operating point.
</div>

### Electrical performance summary (AM1.5)

| Metric | Value |
|---|---:|
| Short-circuit current density, Jsc | 34.5 mA/cm² |
| Open-circuit voltage, Voc | 0.56 V |
| Max power density, Pmax/A | 16.08 mW/cm² |
| Fill factor, FF | 83.3% |
| Efficiency, η | 16.08% |

Efficiency is computed in the standard way:
\[
\eta = \frac{J_{sc} V_{oc} FF}{P_{in}}
\]
with \(P_{in}\) set by the AM1.5 illumination condition used in the simulation.

---

## Economic Sizing (Residential Back-of-the-Envelope)

A simple sizing exercise estimates how many modules would be required to offset a typical **2000 sq.ft. home** using **~1000 kWh/month**:
- Power density: **16.08 mW/cm² ≈ 160.8 W/m²**
- 60-cell module area estimate: **~1.458 m²**
- Module power: **~234.6 W**
- With **~5 sun-hours/day**, energy per module: **~1.17 kWh/day**
- Modules required: **~29** to offset ~33.3 kWh/day

A more realistic installed-cost estimate (including hardware + labor) is then derived using a Massachusetts $/W reference and the 30% federal ITC (see report for the full walk-through).

---

## Sustainability + Impact Notes

This design stays intentionally **boring (in a good way)**:
- **c-Si + Al**: abundant materials, mature supply chain, and established recycling pathways.
- Avoids rare/supply-constrained contact metals (e.g., silver-heavy approaches).
- Long operational lifetime (**20–30+ years** typical for crystalline silicon PV) supports favorable lifetime energy return.
- Practical for **distributed deployment** (microgrids, resilience infrastructure, cost-sensitive adoption).

---

## What’s in the repo

- Report source (`.tex`) + bibliography
- Exported figures (device model, JV curve, power curve)
- Design rationale: optimization decisions tied to JV shape, FF, and recombination behavior