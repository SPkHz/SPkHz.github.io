---
layout: page
title: Quarter-Wave Transformer Impedance Matching Network Design
description: Transmission-line impedance matching in Keysight ADS — shunt-stub + quarter-wave transformer designs (ideal + microstrip), with Smith-chart synthesis and layout verification.
img: assets/img/ee314/hero.jpg
importance: 6
category: coursework
giscus_comments: false
---

## Overview

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

### 1. Smith Charts + Hand Synthesis

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee314/smith_shunt_stub_solution1.jpg" title="Shunt-stub Smith chart synthesis (solution example)" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee314/smith_shunt_stub_solution2.jpg" title="Shunt-stub Smith chart synthesis (alternate solution)" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee314/smith_quarter_wave.jpg" title="Quarter-wave transformer Smith chart synthesis" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  Smith-chart synthesis used to determine normalized impedance/admittance moves, stub termination choice (OC/SC), and electrical lengths at the design frequency.
</div>

---

### 2. ADS Ideal TL Schematics (S-Parameter Verification)

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee314/ads_shunt_stub_ideal.png" title="ADS ideal TL shunt-stub schematic" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee314/ads_quarter_wave_ideal.png" title="ADS ideal TL quarter-wave schematic's" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  Ideal transmission-line implementations were simulated first to confirm matching behavior before committing to microstrip geometry.
</div>

---

### 3. Microstrip (MStrip) Implementation + Layout

<div class="row justify-content-sm-center">
  <div class="col-sm-8 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee314/ads_mstrip_schematic.png" title="ADS microstrip schematic (substrate + line geometry)" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm-4 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee314/layout_view.png" title="Microstrip layout view" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  Microstrip lines were dimensioned from the substrate definition, then verified in layout to ensure physical realizability and correct connectivity.
</div>

---

### 4. Plots + Tables (Performance Snapshot)

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee314/sparam_plots.png" title="S-parameter plots around the design frequency" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  Representative S-parameter performance across the GHz sweep, showing matching behavior near the design point and the impact of microstrip implementation vs ideal TL.
</div>

---

## Repository Contents (What’s Included)

This repo is organized so someone can reproduce the work end-to-end:

- `report/` — final submitted PDF
- `ads/` — ADS workspace(s): ideal TL + microstrip + layouts
- `images/` — exported figures used on this page
- `notes/` — Smith-chart scans + handwritten derivations (as images/PDF)

---

## Download

- **Full report PDF:** `assets/img/ee314/EE_314_Design_Project_Placzek.pdf`
- **ADS workspace:** `assets/img/ee314/EE314_Final_Design_Project/`