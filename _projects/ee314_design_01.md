---
layout: page
title: Millimeter-Wave Impedance Matching Network Designs
description: Transmission-line impedance matching in Keysight ADS — shunt-stub + quarter-wave transformer designs (ideal + microstrip), with Smith-chart synthesis and layout verification.
img: assets/img/ee314/Microstrip_1_Layout.JPG
category: coursework
giscus_comments: false
importance: 553355078410098
related_publications: true
tags:
  - millimeter-wave
  - impedance matching
  - shunt stub
  - quarter-wave transformer
  - smith chart
  - keysight ads
  - microstrip layout
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

**Course:** EE-314 Electromagnetic Fields and Waves
**Project:** Final Design Project - Design of mmWave Impedance Matching Networks
**Author:** Steven Placzek
**Date:** 2024-11-18 9:00 AM

This project is my **EE-314 (Electromagnetic Fields and Waves)** final design project. The goal was to design and verify **two transmission-line matching networks** in the GHz range:

1. **Shunt-stub matching network** (multiple valid solutions)
2. **Quarter-wave transformer matching network** (short/long line solutions)

Each network was completed in two forms:

- **Ideal transmission-line (TL)** design and simulation in **Keysight ADS**
- **Microstrip (MStrip)** physical design using a defined substrate stackup, with **layout-level verification** and S-parameter performance checks.

---

## Tools + Workflow

- **Smith chart synthesis** to determine electrical lengths and characteristic impedances
- **ADS S-parameter simulations** over a GHz sweep (project spans a 3.5–4.5 GHz style range in the provided schematics)
- **Microstrip implementation** using the specified substrate parameters (shown in the ADS setup screenshots)
- **Layout generation** and geometry verification (line widths/lengths, connectivity, ports)

---

## Results Summary

### Shunt-Stub Matching

- Multiple solutions were produced (e.g., **open-circuit vs short-circuit stubs**, and alternative placements/lengths).
- Each solution was validated in:
  - **ADS ideal TL**
  - **ADS microstrip**
  - **Layout view**

### Quarter-Wave Transformer Matching

- Implemented using standard **λ/4 transformer logic**, with **two valid line-length choices** (short/long alternatives).
- Verified in:
  - **ADS ideal TL**
  - **ADS microstrip**
  - **Layout view**

---

## Substrate / Stackup Used (Microstrip)

The ADS microstrip designs use a defined substrate setup (shown in the ADS schematics), including:

- dielectric thickness and permittivity settings
- conductor thickness
- loss tangent / conductivity style parameters

This ensures the microstrip results reflect realistic dispersion/loss compared to ideal TL models.

---

## Design Artifacts (Gallery)

### 1. Shunt-Stub Solutions

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee314/Shunt_Stub_Soln_1_OC_Schematic.JPG" title="Shunt-stub solution 1 (open-circuit) schematic" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee314/Shunt_Stub_Soln_1_OC_Plots.JPG" title="Shunt-stub solution 1 (open-circuit) plots" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
</div>
<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee314/Shunt_Stub_Soln_2_SC_Schematic.JPG" title="Shunt-stub solution 2 (short-circuit) schematic" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee314/Shunt_Stub_Soln_2_SC_Plots.JPG" title="Shunt-stub solution 2 (short-circuit) plots" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
</div>
<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee314/Shunt_Stub_Soln_3_SC_Schematic.JPG" title="Shunt-stub solution 3 (short-circuit) schematic" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee314/Shunt_Stub_Soln_3_SC_Plots.JPG" title="Shunt-stub solution 3 (short-circuit) plots" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
</div>
<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee314/Shunt_Stub_Soln_4_OC_Schematic.JPG" title="Shunt-stub solution 4 (open-circuit) schematic" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee314/Shunt_Stub_Soln_4_OC_Plots.JPG" title="Shunt-stub solution 4 (open-circuit) plots" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
</div>

<div class="caption">
  Four shunt-stub matching solutions showing both open-circuit (OC) and short-circuit (SC) stub configurations with their corresponding S-parameter plots.
</div>

---

### 2. Quarter-Wave Transformer Solutions

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee314/QWT_Soln_1_Schematic.JPG" title="Quarter-wave transformer solution 1 schematic" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee314/QWT_Soln_1_Plots.JPG" title="Quarter-wave transformer solution 1 plots" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
</div>
<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee314/QWT_Soln_2_Schematic.JPG" title="Quarter-wave transformer solution 2 schematic" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee314/QWT_Soln_2_Plots.JPG" title="Quarter-wave transformer solution 2 plots" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
</div>

<div class="caption">
  Two quarter-wave transformer matching solutions with their corresponding S-parameter plots.
</div>

---

### 3. Microstrip (MStrip) Implementation + Layout

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee314/Microstrip_1_Schematic.JPG" title="Microstrip implementation 1 schematic" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee314/Microstrip_1_Layout.JPG" title="Microstrip implementation 1 layout" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee314/Microstrip_1_Plots.JPG" title="Microstrip implementation 1 plots" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
</div>
<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee314/Microstrip_2_Schematic.JPG" title="Microstrip implementation 2 schematic" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee314/Microstrip_2_Layout.JPG" title="Microstrip implementation 2 layout" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee314/Microstrip_2_Plots.JPG" title="Microstrip implementation 2 plots" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
</div>

<div class="caption">
  Microstrip lines were dimensioned from the substrate definition, then verified in layout to ensure physical realizability and correct connectivity.
</div>

---

---

## Repository Contents

This repo is organized so someone can reproduce the work end-to-end:

- `report/` — final submitted PDF
- `ads/` — ADS workspace(s): ideal TL + microstrip + layouts
- `images/` — exported figures used on this page
- `notes/` — Smith-chart scans + handwritten derivations (as images/PDF)

---

## Download

- **Full report PDF:** [EE_314_Design_Project_Placzek.pdf](assets/pdf/ee314/EE_314_Design_Project_Placzek.pdf)
