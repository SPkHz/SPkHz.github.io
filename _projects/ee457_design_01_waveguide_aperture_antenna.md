---
layout: page
title: "WR-62 Waveguide Aperture Antenna Design (14 GHz)"
description: "HFSS + MATLAB design of a two-section quarter-wave transformer to match a WR-62 waveguide aperture to free space."
img: /assets/img/ee457/design-01/thumbnail.png
importance: 1
category: coursework
date: 2025-10-03
tags: [EE-457, waveguide, antenna, impedance-matching, quarter-wave-transformer, HFSS, MATLAB]
related_publications: true
---

## Overview

**Course:** EE-457 — Wave Transmission and Reception  
**Project:** Design Project 01
**Author:** Steven Placzek
**Date:** 2025-10-03
**Tools:** MATLAB (closed-form sizing + efficiency iteration), Ansys HFSS (3D full-wave EM)

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee457/design-01/thumbnail.png" title="WR-62 waveguide aperture antenna matching — overview" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  Overview: HFSS geometry (left), matched return loss (center), and 3D realized gain at 14&nbsp;GHz (right).
</div>

---

## Project summary

This design project models a **WR-62 open-ended rectangular waveguide** radiating into free space (an _aperture antenna_) and then designs a **two-section matching network** to reduce the input reflection at **14&nbsp;GHz**.

Key outcomes (HFSS results):

| Metric                                        |                                Result | Notes                          |
| --------------------------------------------- | ------------------------------------: | ------------------------------ | ---------------------------- | --------------------------------------- |
| Aperture reflection (unmatched) @ 14&nbsp;GHz |                                    \( | \Gamma_L                       | = 0.256\angle -88.17^\circ\) | Return loss \(\approx 11.8\,\text{dB}\) |
| Matched return loss @ 14&nbsp;GHz             | \(S\_{11} \approx -35.06\,\text{dB}\) | \(                             | \Gamma                       | \approx 0.0177\)                        |
| \(-20\,\text{dB}\) return-loss bandwidth      |                    13.3–14.8&nbsp;GHz | BW = 1.5&nbsp;GHz (≈10.7% FBW) |
| Peak realized gain @ 14&nbsp;GHz              |                          6.87&nbsp;dB | Broadside                      |
| 3&nbsp;dB beamwidth (E-plane)                 |                               123.93° | Principal-plane cut            |
| 3&nbsp;dB beamwidth (H-plane)                 |                                61.70° | Principal-plane cut            |

---

## HFSS baseline model

The starting point is a **WR-62 waveguide section** with an open aperture radiating into free space. The simulation uses a wave port excitation and a surrounding radiation region.

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="lazy" path="assets/img/ee457/design-01/hfss_model_port.png" title="HFSS baseline model and wave port" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="lazy" path="assets/img/ee457/design-01/hfss_model_symmetry.png" title="HFSS model showing symmetry setup" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  Baseline HFSS model: wave port excitation and symmetry boundaries used to reduce simulation cost.
</div>

### Unmatched reflection coefficient

At the design frequency (14&nbsp;GHz), HFSS reports the aperture reflection coefficient:

\[
\Gamma*L = 0.256\angle (-88.17^\circ)
\]
so the unmatched return loss is:
\[
\text{RL} = -20\log*{10}(|\Gamma_L|) \approx 11.8\,\text{dB}.
\]

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="lazy" path="assets/img/ee457/design-01/s11_unmatched.png" title="Unmatched |S11| (dB) versus frequency" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  Unmatched return loss is roughly 11–13&nbsp;dB across 12–16&nbsp;GHz, indicating a substantial mismatch at the aperture.
</div>

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="lazy" path="assets/img/ee457/design-01/smith_unmatched.png" title="Unmatched S11 on a Smith chart" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  Unmatched input reflection shown on a Smith chart (marker at 14&nbsp;GHz).
</div>

---

## Matching-network synthesis

A **two-section transformer** is used:

1. A short line section of length \(d_1\) to rotate the normalized impedance to the real axis.
2. A quarter-wave transformer section of length \(d*2=\lambda_g/4\) with characteristic impedance \(Z*{02}\).

### Converting HFSS \(\Gamma_L\) to impedance

Using normalized impedance \(z\) and the standard mapping:

\[
z_L = \frac{1+\Gamma_L}{1-\Gamma_L}
\]

With \(|\Gamma_L|=0.256\) and \(\angle\Gamma_L\approx -88.17^\circ\), the normalized load at the aperture is:

\[
z_L \approx 0.8907 - j0.4878
\]

(consistent with the Smith chart marker).

### Guided wavelength and section lengths

For WR-62, the broadwall dimension is \(a\approx 15.7988\,\text{mm}\), so the TE\(\_{10}\) cutoff is:

\[
f_c = \frac{c}{2a}.
\]

At \(f_0 = 14\,\text{GHz}\), the guided wavelength is:

\[
\lambda_g = \frac{\lambda_0}{\sqrt{1-(f_c/f_0)^2}}.
\]

Using the project’s final synthesis values:

| Parameter |     Electrical length | Physical length |
| --------- | --------------------: | --------------: |
| \(d_1\)   | \(0.1275\,\lambda_g\) |  3.7142&nbsp;mm |
| \(d_2\)   | \(0.2500\,\lambda_g\) |  7.2802&nbsp;mm |

The resulting transformer impedance (from the real impedance at \(d_1\)) is:

\[
Z\_{02} \approx 394.31\,\Omega.
\]

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="lazy" path="assets/img/ee457/design-01/smith_matlab_design.png" title="MATLAB Smith-chart synthesis of the two-section match" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  MATLAB Smith-chart synthesis showing: (1) rotation from the aperture load to \(d_1\), (2) quarter-wave transformer section, and (3) rotation back toward the source match.
</div>

---

## HFSS verification of the matched design

The synthesized sections are implemented in HFSS and re-simulated to verify the improvement in return loss and to confirm radiation performance is preserved.

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="lazy" path="assets/img/ee457/design-01/hfss_model_qwt.png" title="HFSS geometry including the two-section transformer" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  Final HFSS geometry with the two-section matching network.
</div>

### Matched return loss and bandwidth

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="lazy" path="assets/img/ee457/design-01/s11_matched.png" title="Matched S11 (dB) versus frequency" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  Matched return loss with a deep null at 14&nbsp;GHz (about −35&nbsp;dB). The −20&nbsp;dB bandwidth spans approximately 13.3–14.8&nbsp;GHz.
</div>

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="lazy" path="assets/img/ee457/design-01/smith_matched.png" title="Matched S11 on a Smith chart" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  Smith chart after matching: the 14&nbsp;GHz marker is near the chart center (close to a 1+j0 normalized impedance).
</div>

---

## Radiation performance at 14&nbsp;GHz

The matching network is designed to improve input match while preserving the radiation characteristics of the aperture.

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="lazy" path="assets/img/ee457/design-01/gain_3d_db.png" title="3D realized gain pattern (dB) at 14 GHz" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  3D realized gain pattern at 14&nbsp;GHz. Peak realized gain is about 6.87&nbsp;dB.
</div>

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="lazy" path="assets/img/ee457/design-01/gain_cuts_db.png" title="Principal-plane gain cuts at 14 GHz (dB)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  Principal-plane cuts (two orthogonal \(\phi\) cuts) showing a broadside main lobe. The reported 3&nbsp;dB beamwidths are ~61.70° and ~123.93°.
</div>

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="lazy" path="assets/img/ee457/design-01/gain_vs_theta.png" title="Gain versus theta for two principal phi cuts (dB)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  Gain versus \(\theta\) for two principal cuts at 14&nbsp;GHz.
</div>

---

## Reproducibility notes

If you are recreating the project locally:

- **HFSS**: start from the baseline open-ended WR-62 model, then add the two matching sections using \(d*1\), \(d_2\), and the geometry needed to realize \(Z*{02}\).
- **MATLAB**: compute \(z*L\) from \(\Gamma_L\), solve for \(d_1\) such that \(\Im\{z(d_1)\}=0\), then set \(d_2=\lambda_g/4\) and \(Z*{02}=Z_0\sqrt{\Re\{z(d_1)\}}\).

---
