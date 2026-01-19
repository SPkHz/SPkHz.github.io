---
layout: post
title: "EE-456 Design Project 01 Published: 15 GHz HEMT Amplifier (IMN/OMN TL Synthesis + ADS/MATLAB Verification)"
date: 2025-02-25 09:24:33-0500
tags: [rf, microwave, amplifier, hemts, matching-networks, s-parameters, ads, matlab]
categories: coursework
thumbnail: assets/img/ee456/design01/ADS_all_TRL_Simulation.png
inline: false
related_posts: true
show_on_home: false
---

I’ve published **EE-456 Microwave Active Circuits — Design Project 01**: a **15 GHz single-stage amplifier** designed around the **MGF4941AL super–low-noise InGaAs HEMT** at **VDS = 2 V** and **IDS = 10 mA**.

The objective was **maximum transducer gain at 15 GHz** by selecting the **optimal source/load terminations** (ΓS, ΓL) from the device S-parameters, then synthesizing **TL-based input/output matching networks** and validating performance using **two independent toolchains**: **Keysight ADS** and **MATLAB Touchstone workflows**.

---

## Design flow (what was actually done)

- **Extract / target terminations at f0 = 15 GHz**
  - Selected ΓS and ΓL for maximum gain operation at the specified bias point
- **Synthesize matching networks**
  - Implemented **IMN + OMN** using **ideal transmission-line sections** (series lines + shunt stubs) plus DC blocks
- **Cross-verify in ADS and MATLAB**
  - ADS: simulated the complete matched amplifier across **14–16 GHz**
  - MATLAB: parsed exported Touchstone files and regenerated plots for direct overlay / consistency checks

---

## Representative results (14–16 GHz sweep)

Near **15 GHz**, the design exhibits a strong conjugate-match condition and produces near-maximum gain for the chosen device/bias point:

- **Peak gain (|S21|):** ~12.9 dB near 15 GHz  
- **Input match:** deep |S11| notch near 15 GHz (well below −30 dB)  
- **Output match:** deep |S22| notch near 15 GHz (well below −30 dB)  
- **Reverse transmission:** |S12| in the mid −10s dB range near 15 GHz  

The MATLAB/ADS overlays confirm the Touchstone workflow and the ideal-TL network implementation are consistent.

---

## What’s included in the repo

- ADS workspace (complete schematic + standalone IMN/OMN)
- MATLAB scripts for Touchstone parsing + plotting (macOS + Windows variants)
- Touchstone exports for IMN / OMN / full amplifier
- Comparison tables (Γ targets, VSWR, gain consistency)

---

## Notes / limitations

This version intentionally uses **ideal transmission lines** to isolate **matching synthesis + verification**. A layout-ready revision would require physical line models (microstrip/CPW), substrate definition, loss/dispersion, discontinuities, and full stability/noise evaluation using the complete device model.
