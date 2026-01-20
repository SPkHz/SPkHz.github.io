---

layout: page
title: 15 GHz GaAs HEMT Amplifier Design
description: 15 GHz GaAs HEMT amplifier (MGF4941AL) with TL-based input/output matching. MATLAB + Keysight ADS (ideal TRLs) verification.
img: assets/img/ee456/design01/All_Params_vs_Frequency_ADS_ALL_TRLs.png
category: coursework
importance: 6
related_publications: true
tags:
  - 15ghz amplifier
  - gaas hemt
  - mgf4941al
  - input matching network
  - output matching network
  - s-parameter simulation
  - keysight ads
  - matlab
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

**Course:** EE-456 Microwave Active Circuits
**Project:** Design Project 01
**Author:** Steven Placzek
**Date:** 2024-11-18 9:00 AM
**Tools:** Keysight ADS + MATLAB (Touchstone workflows, Smith chart synthesis, S-parameter comparison)  
**Frequency sweep:** 14–16 GHz (centered at 15 GHz)

This project (completed for the EE-456/556: RF & Microwave Active Circuit Design course at Western New England University College of Engineering) designs a **15 GHz microwave amplifier** using the **MGF4941AL super–low-noise InGaAs HEMT**, biased at **V<sub>DS</sub> = 2 V** and **I<sub>DS</sub> = 10 mA**. The design goal was **maximum gain at 15 GHz** by synthesizing **input and output matching networks** using transmission-line sections, then validating performance with **S-parameter simulations** in both **MATLAB** and **Keysight ADS**.

---

## Design Strategy

### 1. Find the optimum source/load terminations (for max gain)
The amplifier is designed around the device S-parameters at 15 GHz, selecting the **target source and load reflection coefficients** (Γ<sub>S</sub>, Γ<sub>L</sub>) for maximum gain operation.

### 2. Synthesize IMN + OMN with transmission lines
Both the **Input Matching Network (IMN)** and **Output Matching Network (OMN)** are implemented using **ideal transmission-line (TRL/TLIN) models** (series lines + shunt stubs) and DC blocks to realize the target Γ<sub>S</sub> and Γ<sub>L</sub> at **f<sub>0</sub> = 15 GHz**.

### 3. Verify in two independent toolchains
- **MATLAB:** compute/plot S-parameters and gain vs. frequency from Touchstone files
- **ADS:** simulate the matching networks and complete amplifier schematic (ideal TLs), then export Touchstone and compare directly to MATLAB

---

## Schematics (ADS)

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee456/design01/ALL_TRLs_Schematic_ADS.png" title="Complete amplifier schematic (ADS, ideal TLs)" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee456/design01/ADS_IMN_SCHEMATIC.png" title="Input Matching Network (IMN) schematic" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee456/design01/ADS_OMN_Schematic.png" title="Output Matching Network (OMN) schematic" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
</div>

<div class="caption">
  ADS schematics for the complete amplifier and the standalone IMN/OMN. Simulations use ideal transmission-line models at <b>f<sub>0</sub> = 15 GHz</b>.
</div>

---

## Results: Matching + Gain (14–16 GHz)

At 15 GHz, the design hits a strong conjugate-match condition and produces near-theoretical maximum transducer gain for the chosen device/bias point.

**Representative performance near 15 GHz (from the final simulations):**
- **Peak gain:** peak |S21| / gain = ~12.9 dB near 15 GHz  
- **Input return loss:** deep notch near 15 GHz (|S11| well below −30 dB)  
- **Output return loss:** deep notch near 15 GHz (|S22| well below −30 dB)  
- **Reverse transmission:** |S12| around the mid −10s dB near 15 GHz

<div class="row justify-content-sm-center">
  <div class="col-sm-8 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee456/design01/ADS_all_TRL_Simulation.png" title="ADS results: Smith charts + S-parameters vs frequency (full design)" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
  <div class="col-sm-4 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee456/design01/S21.png" title="MATLAB vs ADS comparison: |S21| (gain) overlay" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
</div>

<div class="caption">
  Full-design ADS outputs (Smith + S-parameters) and a direct MATLAB-vs-ADS overlay for |S21|. The agreement confirms the Touchstone workflow and the ideal-TL implementation.
</div>

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee456/design01/S11.png" title="MATLAB vs ADS comparison: |S11| overlay" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee456/design01/S21.png" title="MATLAB vs ADS comparison: |S21| overlay" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee456/design01/S22.png" title="MATLAB vs ADS comparison: |S22| overlay" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
</div>

<div class="caption">
  MATLAB and ADS comparisons for the key S-parameters, verifying that both toolchains predict essentially the same matching behavior and gain across 14–16 GHz.
</div>

---

## Repository Contents

- **ADS workspace** (schematics + ideal TL networks)
- **MATLAB scripts** (Touchstone parsing + plotting, design verification)
  - `Design_Project_1_Final_Draft_vMacOS.m`
  - `Design_Project_1_Final_Draft_vWindows.m`
- **Touchstone exports** (IMN / OMN / full amplifier)
  - `EE456_DsgnPrjct1_Placzek_ADS_Ideal_TRLs_IMN.s2p`
  - `EE456_DsgnPrjct1_Placzek_ADS_Ideal_TRLs_OMN.s2p`
  - `EE456_DsgnPrjct1_Placzek_ADS_Ideal_TRLs_All.s2p`
- **Comparison tables** (CSV/XLSX) used to summarize Γ targets, VSWR, and gain consistency

---

## Notes / Limitations

This project intentionally uses **ideal transmission lines** (lossless, dispersion-free) to focus on **matching synthesis and verification**. A layout-ready version would require physical line models (microstrip/CPW), substrate definition, losses, discontinuities, and stability/noise analysis with the full device model.

---

## Download

- **Full report PDF:** [EE_456_Design_Project_01_Placzek_Presentation.pdf](assets/pdf/ee456/design01/EE_456_Design_Project_01_Placzek_Presentation.pdf)
