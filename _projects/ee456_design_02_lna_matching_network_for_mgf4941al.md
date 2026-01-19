---
layout: page
title: 15 GHz Low-Noise Amplifier Input/Output Matching Network Design
description: 15 GHz LNA IMN/OMN for the MGF4941AL (VDS = 2 V, IDS = 10 mA). Joint gain/NF/VSWR optimization with MATLAB + Keysight ADS cross-verification.
img: assets/img/ee456/design02/Stab_Cirs.png
importance: 4
category: coursework
giscus_comments: true
related_publications: false
_styles: |
  .post article .mjx-container[display="true"] {
    font-size: 1.3em;
    margin: 0.9em 0 1.1em;
  }
  .post article .mjx-container {
    font-size: 1.12em;
  }
---

<!--
asset placement:
assets/img/ee456/design02/ADS_Complete_Schematic.png
assets/img/ee456/design02/Stab_Cirs.png
assets/img/ee456/design02/Gamma_A_and_Gamma_S.png
assets/img/ee456/design02/S21_dB---ADSvsMtLb.jpg
assets/img/ee456/design02/NF_ADSvsMtLB.jpg
assets/img/ee456/design02/VSWR_OMN__ADSvsMtLb.jpg
assets/img/ee456/design02/VSWR_IMN_ADSvsMtLb.jpg
assets/img/ee456/design02/S11_ADSvsMtLb.jpg
assets/img/ee456/design02/S22_ADSvsMtLb.jpg
-->
## Overview

**Course:** EE-456 Microwave Active Circuits
**Project:** Design Project 01
**Author:** Steven Placzek
**Date:** 2024-11-18 9:00 AM
**Tools:** Keysight ADS (circuit verification) + MATLAB (Touchstone workflows, Smith chart synthesis, S-parameter comparison)  
**Frequency:** $f_0 = 15~\text{GHz}$ (sweep ~14–16 GHz)

Design Project 02 for EE-456 (RF & mm-Wave Active Circuits): a **15 GHz LNA matching design** for the **MGF4941AL InGaAs HEMT** at **$V_{DS}=2~\text{V}$** and **$I_{DS}=10~\text{mA}$**.

Unlike a pure max-gain match, this design targets the *intersection* of constraints: **transducer gain**, **noise figure**, and **input/output VSWR**, then validates the final solution independently in **MATLAB** and **Keysight ADS**.

**Project Targets @ $f_0$:**
- $G_T \ge 12~\text{dB}$
- $NF \le 0.6~\text{dB}$
- $\text{VSWR} \le 1.5$ (input + output)

The design flow is simple: start from device **S-parameters + noise parameters** at 15 GHz, map the design space with Smith-chart geometry, and choose $\Gamma_S$ and $\Gamma_L$ from the feasible region defined by **available gain circles**, **noise-figure circles**, and **stability constraints**.

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee456/design02/ADS_Complete_Schematic.png" title="Final ADS schematic (IMN + device + OMN)" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee456/design02/Stab_Cirs.png" title="Stability, gain, and noise design space @ 15 GHz" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee456/design02/Gamma_A_and_Gamma_S.png" title="Selected feasible \u0393S from the intersection region" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  Final layout and selection logic: $\Gamma_S$ and $\Gamma_L$ are chosen from the feasible gain–NF–stability intersection, then realized with compact single-stub transmission-line networks (IMN + OMN).
</div>

At $15~\text{GHz}$, the selected terminations are:

- $\Gamma_S = 0.4256 \angle -136.02^\circ$
- $\Gamma_L = 0.2904 \angle +146.09^\circ$

…and the verified performance is:

- $G_T = \mathbf{12.26~dB}$
- $NF = \mathbf{0.580~dB}$
- VSWR (IMN) $= \mathbf{1.50}$
- VSWR (OMN) $= \mathbf{1.39}$

**Electrical lengths (open-stub TL networks):**
- **IMN:** $\theta_{I1}=43.25^\circ$ (series TL), $\theta_{I2}=10.42^\circ$ (open shunt stub)
- **OMN:** $\theta_{O1}=31.26^\circ$ (series TL), $\theta_{O2}=53.52^\circ$ (open shunt stub)

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee456/design02/S21_dB---ADSvsMtLb.jpg" title="Transducer gain overlay (ADS vs MATLAB)" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee456/design02/NF_ADSvsMtLB.jpg" title="Noise figure overlay (ADS vs MATLAB)" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee456/design02/VSWR_OMN__ADSvsMtLb.jpg" title="Output VSWR overlay (ADS vs MATLAB)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  Cross-verification: MATLAB and ADS were run as independent toolchains (Touchstone export + re-plot). Overlays confirm the same operating point and consistent behavior near 15 GHz.
</div>

**What’s in the repo:**
- Slides (**PDF/PPTX**) + plots/screenshots used in the deck
- **MATLAB** (design + verification scripts)
- **ADS** project (schematics + simulations)
- **Excel** summary tables (trade-space + final selection)
- Touchstone files (**.s2p**) for IMN, OMN, and full network + exported noise data (**.csv**)

This is an **ideal transmission-line** matching exercise to isolate the gain–NF–match trade-space cleanly. A layout-ready version would add substrate-backed lines (microstrip/CPW), losses/discontinuities, wideband stability checks, a full bias network, and EM-aware validation.
