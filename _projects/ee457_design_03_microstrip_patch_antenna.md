---
layout: page
title: Coaxial-Fed Microstrip Patch Antenna Design (3 GHz)
description: MATLAB transmission-line sizing + HFSS optimization for a 3 GHz coax-fed rectangular patch on FR4 (|S11|(3 GHz) ≈ −31 dB, ~3% BW, ~3.8 dB gain).
img: /assets/img/ee457/design-03/hero.png
importance: 1
category: coursework
tags: [rf, waveguide, antenna, impedance-matching, quarter-wave-transformer, HFSS, MATLAB]
related_publications: true
---

## Overview

**Course:** EE-457 — Wave Transmission and Reception  
**Project:** Design Project 03  
**Author:** Steven Placzek
**Date:** 2025-11-17
**Tools:** MATLAB (TL sizing + bandwidth extraction), Ansys HFSS (3D EM simulation)

This project designs and simulates a **3 GHz coaxial-fed rectangular microstrip patch antenna** on **62 mil FR4** using a **transmission-line (TL) starting point in MATLAB** and **parametric optimization in Ansys HFSS**.

---

## Requirements (assignment targets)

| Item                  | Target                                                                   |
| --------------------- | ------------------------------------------------------------------------ | ------- | ------------------- |
| Center frequency      | 3.0 GHz                                                                  |
| Substrate             | FR4, $h = 1.5748\,\text{mm}$, $\varepsilon_r = 4.4$, $\tan\delta = 0.02$ |
| Patch width guideline | $W \approx 1.5\,L_e$                                                     |
| Match at 3 GHz        | $                                                                        | S\_{11} | \le -30\,\text{dB}$ |
| Characterize          | gain, directivity, E/H beamwidths, radiation efficiency                  |

---

## Geometry (final HFSS sweep)

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee457/design-03/hfss_model_3d.png" title="HFSS 3D model (coax-fed patch + radiation box)" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee457/design-03/patch_dimensions.png" title="Top-view geometry summary (final sweep, V4)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  <b>Model + dimensions:</b> coax probe feed connects to the patch; ground plane is on the opposite copper layer of the FR4 substrate. The feed offset is tuned in HFSS to hit the <b>−30 dB</b> match requirement at 3 GHz.
</div>

### Final dimensions (V4)

| Parameter                                 |   Value | Unit |
| ----------------------------------------- | ------: | ---- |
| $L$ (patch length)                        | 22.5652 | mm   |
| $W$ (patch width)                         | 36.0279 | mm   |
| $x_0$ (feed offset from patch centerline) |  6.1910 | mm   |
| $L_s$ (substrate length)                  | 33.8478 | mm   |
| $W_s$ (substrate width)                   | 54.0418 | mm   |

---

## Transmission-line design starting point (MATLAB)

A TL model provides an initial patch size before full-wave simulation. The basic workflow is:

1. **Guided wavelength (first cut):**
   $$\lambda_g \approx \frac{\lambda_0}{\sqrt{\varepsilon_r}}$$

2. **Effective half-wavelength length:**
   $$L_e \approx \frac{\lambda_g}{2}$$

3. **Assignment width rule:**
   $$W \approx 1.5\,L_e$$

4. **Effective permittivity (Hammerstad):**
   $$\varepsilon_{\text{eff}} = \frac{\varepsilon_r+1}{2}+\frac{\varepsilon_r-1}{2}\left(1+12\frac{h}{W}\right)^{-1/2}$$

5. **Fringing extension (Hammerstad):**
   $$\Delta L = 0.412h\,\frac{(\varepsilon_{\text{eff}}+0.3)\left(\frac{W}{h}+0.264\right)}{(\varepsilon_{\text{eff}}-0.258)\left(\frac{W}{h}+0.8\right)}$$

6. **Physical patch length:**
   $$L \approx L_e - 2\Delta L$$

7. **Coax feed location from the radiating edge** (using the edge resistance $R_{\text{edge}}$):
   $$x_f = \frac{L_e}{\pi}\cos^{-1}\!\left(\sqrt{\frac{R_{in}}{R_{\text{edge}}}}\right),\qquad x_0 = \frac{L_e}{2}-x_f$$

### Table 1 (MATLAB-calculated initial design)

| Parameter                  | Calculated | Unit |
| -------------------------- | ---------: | ---- |
| $f_0$                      |     3.0000 | GHz  |
| $h$                        |     1.5748 | mm   |
| $\varepsilon_r$            |        4.4 | –    |
| $\lambda_g$                |    47.6401 | mm   |
| $L_e$                      |    23.8201 | mm   |
| $W$                        |    35.7301 | mm   |
| $\varepsilon_{\text{eff}}$ |     4.4000 | –    |
| $\Delta L$                 |   726.7002 | µm   |
| $L$                        |    22.3667 | mm   |
| $R_{\text{edge}}$          |   239.4675 | Ω    |
| $x_f$                      |     8.3119 | mm   |

---

## HFSS optimization (feed tuning)

The MATLAB design is imported into HFSS and refined with an **optimetrics sweep** (primary knob: **coax feed offset**) to force the return-loss minimum onto **3.0 GHz** while meeting the **$|S_{11}|\le -30$ dB** requirement.

### Table 2 (geometry updates across sweeps)

| Parameter  |       V1 |       V2 |       V3 | V4 (final) | Unit |
| ---------- | -------: | -------: | -------: | ---------: | ---- |
| $L_e$      |  23.8201 |  23.8201 |  23.8201 |    24.0187 | mm   |
| $\Delta L$ | 726.7001 | 726.7001 | 726.7001 |   726.7001 | µm   |
| $L$        |  22.3667 |  22.3667 |  22.3667 |    22.5652 | mm   |
| $W$        |  35.7302 |  35.7302 |  35.7302 |    36.0279 | mm   |
| $x_f$      |   8.3119 |   8.3119 |   8.3119 |     5.8183 | mm   |
| $x_0$      |   3.5982 |   3.5982 |   3.5982 |     6.1910 | mm   |
| $L_s$      |  33.5501 |  33.5501 |  33.5501 |    33.8478 | mm   |
| $W_s$      |  53.5952 |  53.5952 |  53.5952 |    54.0418 | mm   |

---

## Return loss results (initial vs final)

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee457/design-03/s11_initial_sweep00.png" title="Initial design (V1): |S11|(3 GHz) ≈ −7.90 dB" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee457/design-03/s11_final.png" title="Final design (V4): |S11|(3 GHz) ≈ −31.24 dB" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  <b>Key improvement:</b> feed position + minor geometry updates move the resonance to 3.0 GHz and deepen the return-loss null from roughly <b>−8 dB</b> to <b>−31 dB</b>.
</div>

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee457/design-03/smith_chart.png" title="Smith chart (2.5–3.5 GHz): good 50 Ω match near 3 GHz" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee457/design-03/s11_sweeps_10db_points.png" title="All sweeps: −10 dB crossing points (bandwidth markers)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  <b>Match + bandwidth:</b> the Smith chart shows the impedance trajectory passing near the chart center at 3 GHz. The sweep overlay marks the <b>−10 dB</b> crossing points used to compute impedance bandwidth.
</div>

---

## Bandwidth ($-10$ dB)

| Metric                 | MATLAB estimate | HFSS (final) | Unit |
| ---------------------- | --------------: | -----------: | ---- |
| $BW_f$ (−10 dB)        |         21.6673 |      89.7000 | MHz  |
| Fractional BW (−10 dB) |          0.7222 |       2.9898 | %    |

**Sweep summary (−10 dB BW):** V2–V4 all achieve approximately **3%** fractional bandwidth.

---

## Radiation and gain

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee457/design-03/gain_cut_theta.png" title="Gain cuts (principal planes) with 10 dB beamwidth markers" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee457/design-03/radiation_pattern_polar.png" title="Polar radiation plot (3 GHz): E-plane & H-plane" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  <b>Broadside radiator:</b> maximum gain is approximately <b>3.84 dB</b>, with beamwidths around <b>103°</b> and <b>79°</b> in the principal planes (as marked on the plots).
</div>

### HFSS performance snapshot at 3.0 GHz

| Quantity             |              Value | Notes                   |
| -------------------- | -----------------: | ----------------------- |
| Peak gain            | 2.4211 (≈ 3.84 dB) | broadside maximum       |
| Peak realized gain   | 2.4192 (≈ 3.83 dB) | includes mismatch       |
| Peak directivity     | 4.3989 (≈ 6.43 dB) | from HFSS report        |
| Radiation efficiency |   0.5504 (≈ 55.0%) | FR4 losses dominate     |
| Front-to-back ratio  |          6.1402 dB | finite ground/substrate |

---

## Notes on modeling choices

- **Why coax feed tuning matters:** a probe-fed patch’s input resistance varies strongly with feed position along the resonant dimension, so moving the probe provides a practical way to hit **50 Ω** without adding an external matching network.
- **FR4 tradeoffs:** FR4 is convenient and inexpensive but **lossy at S-band**, reducing efficiency and gain compared to low-loss microwave laminates.

---

## Reproducibility (what I used)

- **MATLAB sizing + tables:** `assets/matlab/ee457/EE_457_Design_Project_03_Placzek_Matlab.m`
- **MATLAB bandwidth extraction (−10 dB markers):** `assets/matlab/ee457/EE_457_Design_Project_03_Placzek_Matlab_read_csv_10dB.m`
- **HFSS project:** `assets/hfss/ee457/EE_457_Design_Project_03_Placzek_HFSS.aedt`
