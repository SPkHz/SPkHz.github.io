---
layout: page
title: Pyramidal Horn Antenna Design (14 GHz)
description: Ku-band pyramidal horn fed by WR-62 waveguide; analytical sizing (MATLAB) + full-wave validation (Ansys HFSS).
img: /assets/img/ee457/design-02/cover.png
importance: 2
category: coursework
tags: [waveguide, antenna, impedance-matching, quarter-wave-transformer, HFSS, MATLAB]
related_publications: true
---

## Overview

**Course:** EE-457 — Wave Transmission and Reception  
**Project:** Design Project 02
**Author:** Steven Placzek
**Date:** 2025-10-24
**Tools:** MATLAB (closed-form sizing + efficiency iteration), Ansys HFSS (3D full-wave EM)

This project designs and simulates a **Ku-band pyramidal horn antenna** for **14 GHz**, using a **WR-62 rectangular waveguide feed** and a pyramidal flare sized from classic aperture/directivity relationships, then validated in **Ansys HFSS**.

---

## Design goals / requirements

- **Center frequency:** 14 GHz
- **Feed waveguide:** WR-62 (inner dimensions)
  - \(a = 15.7988~\text{mm}\), \(b = 7.8994~\text{mm}\)
- **Target gain (design goal):** ~25 dBi (analytical sizing target)
- **Key checks (simulation):**
  - good input match (\(S\_{11}\))
  - stable main beam and reasonable sidelobes
  - expected beamwidth vs. aperture size

---

## Analytical sizing (MATLAB)

### 1. Aperture area from gain/directivity

A pyramidal horn can be estimated as an “efficient aperture”:

\[
D \approx \frac{4\pi}{\lambda^2}\,\varepsilon\_{ap}\,A\,B
\]

where:

- \(A\) = aperture width (H-plane), \(B\) = aperture height (E-plane)
- \(\varepsilon\_{ap}\) = aperture efficiency (includes taper + phase error terms)
- \(\lambda = c/f\) is the free-space wavelength

At \(f = 14~\text{GHz}\), \(\lambda \approx 21.43~\text{mm}\).

### 2. “Optimum” pyramidal horn curvature parameters

The horn sizing follows the standard “optimum” phase-error choices:

\[
R*{0H}=\frac{A^2}{3\lambda},\qquad R*{0E}=\frac{B^2}{2\lambda}
\]

and the flare angles (degrees) are:

\[
\alpha*H=\tan^{-1}\!\left(\frac{A}{2R*{0H}}\right),\qquad
\alpha*E=\tan^{-1}\!\left(\frac{B}{2R*{0E}}\right)
\]

### 3. Iterating aperture efficiency (Fresnel-integral model)

The MATLAB workflow iterates \(\varepsilon\_{ap}\) to convergence:

1. assume \(\varepsilon\_{ap}\) (start at ~0.50)
2. solve for \(A\) and \(B\) that meet the desired directivity
3. compute \(\varepsilon\_{ap}\) from E-plane + H-plane phase-error integrals
4. repeat until \(\varepsilon\_{ap}\) stabilizes

For the final geometry, the analytical breakdown is approximately:

| Term                              | Meaning             | Value |
| --------------------------------- | ------------------- | ----: |
| \(e_t\)                           | taper factor        | 0.811 |
| \(e_E\)                           | E-plane phase term  | 0.803 |
| \(e_H\)                           | H-plane phase term  | 0.796 |
| \(\varepsilon\_{ap}=e_t e_E e_H\) | aperture efficiency | 0.518 |

---

## Final geometry (used in HFSS)

**Free-space wavelength:** \(\lambda \approx 21.43~\text{mm}\)

| Parameter                       |                     Value | Notes                     |
| ------------------------------- | ------------------------: | ------------------------- |
| Throat \(a \times b\)           |    15.7988 mm × 7.8994 mm | WR-62                     |
| Aperture \(A \times B\)         | **161.97 mm × 127.74 mm** | pyramidal opening         |
| Horn length \(R_p\)             |             **275.37 mm** | axial length (approx.)    |
| Flare angle \(\alpha_H\)        |                **14.18°** | H-plane                   |
| Flare angle \(\alpha_E\)        |                **12.05°** | E-plane                   |
| Estimated \(\varepsilon\_{ap}\) |                 **≈ 52%** | from the design iteration |

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee457/design-02/profile_h_plane.png" title="H-plane linear flare (width: a → A over Rp)" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee457/design-02/profile_e_plane.png" title="E-plane linear flare (height: b → B over Rp)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  Simplified 2D flare profiles (generated for documentation). The HFSS model is a full 3D pyramidal flare.
</div>

<div class="row justify-content-sm-center">
  <div class="col-sm-8 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee457/design-02/hfss_model.png" title="HFSS geometry view of the pyramidal horn" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

---

## HFSS simulation results

### Input match (\(S\_{11}\))

The original HFSS export is included below, along with a _digitized_ curve for easier reading.

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee457/design-02/sparam_digitized.png" title="Digitized S11 trace (12.5–15.5 GHz)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

Key observations (from digitizing the HFSS plot):

- \(S\_{11}(14~\text{GHz}) \approx -29.2~\text{dB}\)
- Over 12.5–15.5 GHz, \(S\_{11}\) stays roughly between **-35 dB** (best) and **-27.7 dB** (worst)

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="lazy" path="assets/img/ee457/design-02/sparam.png" title="Original HFSS S-parameter export (as generated)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

---

### Radiation pattern and gain (14 GHz)

The antenna produces a **single dominant forward main lobe** with narrow beamwidths set primarily by the aperture size.

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee457/design-02/gain_polar.png" title="Gain polar cut (HFSS, 14 GHz) — φ = 0° and φ = 90°" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee457/design-02/gain_cut.png" title="Gain vs. θ (HFSS, 14 GHz) — φ = 0° and φ = 90°" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  From the HFSS result tables embedded in the plots: peak gain at 14 GHz is about <b>23.64 dB</b> with 3 dB beamwidths of <b>11.23°</b> (φ=0°) and <b>9.44°</b> (φ=90°).
</div>

For a qualitative “3D view” of the main beam shape, MATLAB-generated pattern visualizations are also included:

<div class="row justify-content-sm-center">
  <div class="col-sm-6 mt-3 mt-md-0">
    {% include figure.liquid loading="lazy" path="assets/img/ee457/design-02/matlab_pattern1.png" title="MATLAB 3D pattern visualization (view 1)" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm-6 mt-3 mt-md-0">
    {% include figure.liquid loading="lazy" path="assets/img/ee457/design-02/matlab_pattern2.png" title="MATLAB 3D pattern visualization (view 2)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

---

## Quick theory ↔ simulation comparison

Using the aperture estimate \(D \approx \frac{4\pi}{\lambda^2}\varepsilon\_{ap}AB\) with:

- \(A \times B = 161.97~\text{mm} \times 127.74~\text{mm}\)
- \(\varepsilon\_{ap} \approx 0.52\)
- \(\lambda \approx 21.43~\text{mm}\)

gives an estimated directivity:

\[
D \approx 24.7~\text{dBi}
\]

HFSS peak gain is about **23.64 dB**, implying an overall efficiency (relative to the idealized aperture estimate) of roughly:

\[
\eta \approx 10^{(23.64-24.69)/10}\approx 0.78
\]

Beamwidth sanity-check (common horn approximations):

\[
\text{HPBW}\_H \approx 68.8\,\frac{\lambda}{A},\qquad
\text{HPBW}\_E \approx 50.6\,\frac{\lambda}{B}
\]

which predicts ~9–9.5° class beamwidths, consistent with the simulated 9.44–11.23° values.

---

## Reproducibility notes

- **MATLAB sizing / efficiency iteration:** `ee457_Horn_Antenna_Design_Placzek_v2.m` + `EE457_Horn_Analysis.m`
- **HFSS model + sweep:** `ee457_Design_Project_02_Placzek.aedt` (Ansys HFSS project)
