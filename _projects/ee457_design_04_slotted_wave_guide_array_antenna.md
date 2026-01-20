---
layout: page
title: EE-457 Design Project 04 — Slotted Waveguide Array Antenna (14 GHz)
description: WR-62 resonant longitudinal-slot array (1×8 and 8×8) synthesized with a -26 dB Chebyshev taper and validated in Ansys HFSS.
img: /assets/img/ee457/design-04/hero_8x8_model.png
importance: 1
category: coursework
related_publications: false
---

This project designs and simulates a **resonant longitudinal slotted waveguide array** operating at **14 GHz** using **WR-62** waveguide.  
A **1×8** linear slot array is synthesized using a **Chebyshev amplitude taper** targeting **-26 dB sidelobes**, and then replicated into an **8×8 planar array** (8 parallel waveguides × 8 slots each) to form a narrow **broadside pencil beam**.

**Course:** EE-457 — Wave Transmission and Reception  
**Design Project:** 04  
**Date:** 2025-12-04  

**Team:** Steven Placzek, Ryan Leonard, Aidan Butler, Max Brown, Bryam Yanza  
**Tools:** MATLAB (array synthesis), Ansys HFSS (full-wave simulation)

---

## Antenna concept

A resonant slotted waveguide array uses the **TE$_{10}$** mode in a rectangular waveguide. Each **longitudinal slot** cut into the broad wall behaves like a radiating element whose coupling is primarily set by its **offset from the centerline**. By:

- spacing slots by approximately **$\lambda_g/2$** along the guide, and  
- alternating the slot offsets from one side of the centerline to the other,

the slots can radiate **in-phase** at broadside while supporting an amplitude taper for sidelobe control.

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid path="assets/img/ee457/design-04/hero_8x8_model.png" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
</div>
<div class="caption">
  HFSS geometry of the 8×8 slotted waveguide array (8 parallel WR-62 waveguides, 8 slots per waveguide).
</div>

---

## Design requirements and constants

### Given / specified

- **Operating frequency:** $f_0 = 14\ \text{GHz}$  
- **Waveguide:** WR-62 (inner dimensions $a\times b$)  
- **Slots per waveguide:** $N_y = 8$  
- **Number of waveguides (planar array):** $N_x = 8$  
- **Target sidelobe level (Chebyshev):** $\mathrm{SLL} = -26\ \text{dB}$  
- **Slot dimensions (spec):**
  - $L = 0.464\,\lambda_0$
  - $W = \lambda_g/20$
- **Wall thickness:** top wall (slot wall) = 0.635 mm, remaining walls = 1.016 mm

### Derived waveguide quantities

For a rectangular waveguide operating in TE$_{10}$:

$$
f_c = \frac{c}{2a},\qquad
\lambda_0 = \frac{c}{f_0},\qquad
\lambda_g = \frac{\lambda_0}{\sqrt{1-(f_c/f_0)^2}}
$$

The final synthesized dimensions used in HFSS are summarized below.

| Parameter | Value | Notes |
| :-- | --: | :-- |
| $f_0$ | 14.0 GHz | design frequency |
| $a$ | 15.7988 mm | WR-62 broad wall |
| $b$ | 7.8994 mm | WR-62 narrow wall |
| $f_c$ | 9.4878 GHz | TE$_{10}$ cutoff |
| $\lambda_0$ | 21.4137 mm | free-space wavelength |
| $\lambda_g$ | 29.1210 mm | guided wavelength |
| Slot spacing $d_y$ | 14.5605 mm | $\lambda_g/2$ |
| Slot length $L$ | 9.9360 mm | $0.464\lambda_0$ |
| Slot width $W$ | 1.4560 mm | $\lambda_g/20$ |
| Waveguide length $L_{WG}$ | 123.7642 mm | resonant guide length |
| Waveguide spacing $d_x$ | 16.8148 mm | for $N_x=8$ planar array |

---

## MATLAB synthesis

### Chebyshev taper (-26 dB SLL)

A Chebyshev distribution provides a controlled sidelobe level while maximizing directivity for that constraint. The **normalized amplitudes** $A_n$ (symmetric for $N_y=8$) are:

| n | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
| :--: | --: | --: | --: | --: | --: | --: | --: | --: |
| $A_n$ | 1.0000 | 1.6313 | 2.3916 | 2.8603 | 2.8603 | 2.3916 | 1.6313 | 1.0000 |

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid path="assets/img/ee457/design-04/chebyshev_amplitudes.png" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
</div>
<div class="caption">
  Chebyshev amplitude taper used for the 8-slot linear array (symmetric about the center).
</div>

### Slot conductance targets and offsets

To realize the taper in a **resonant** slotted waveguide, the desired **normalized conductances** are proportional to $A_n^2$:

$$
g_n = K\,A_n^2,\qquad
K = \frac{1}{\sum_{n=1}^{N_y} A_n^2}
$$

The slot admittance model is used to compute the required **offset** $\Delta_n$ from the centerline (with alternating sign to maintain broadside in-phase radiation).

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid path="assets/img/ee457/design-04/slot_conductance_targets.png" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid path="assets/img/ee457/design-04/slot_offsets.png" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
</div>
<div class="caption">
  (Left) Target conductances proportional to $A_n^2$. (Right) Alternating slot offsets $\Delta_n$ (mm) used to implement the taper and preserve broadside phasing.
</div>

### Final per-slot geometry

| Slot n | $A_n$ | $g_n$ (mS/S) | $L_n$ (mm) | $W_n$ (mm) | $\Delta_n$ (mm) |
| :--: | --: | --: | --: | --: | --: |
| 1 | 1.0000 | 28.4700 | 9.9360 | 1.4560 | -0.9726 |
| 2 | 1.6313 | 75.7611 | 9.9360 | 1.4560 | 1.6038 |
| 3 | 2.3916 | 162.8404 | 9.9360 | 1.4560 | -2.4019 |
| 4 | 2.8603 | 232.9286 | 9.9360 | 1.4560 | 2.9272 |
| 5 | 2.8603 | 232.9286 | 9.9360 | 1.4560 | -2.9272 |
| 6 | 2.3916 | 162.8404 | 9.9360 | 1.4560 | 2.4019 |
| 7 | 1.6313 | 75.7611 | 9.9360 | 1.4560 | -1.6038 |
| 8 | 1.0000 | 28.4700 | 9.9360 | 1.4560 | 0.9726 |

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid path="assets/img/ee457/design-04/slot_layout_1x8.png" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
</div>
<div class="caption">
  Slot center locations (top view of one waveguide). The dashed line indicates the broad-wall centerline ($x=a/2$).
</div>

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid path="assets/img/ee457/design-04/slot_layout_8x8.png" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
</div>
<div class="caption">
  Slot center locations for the full 8×8 array (replicating the 1×8 pattern across 8 parallel guides).
</div>

---

## HFSS modeling

Two HFSS models were created:

1. **1×8 array** — a single WR-62 waveguide section with 8 longitudinal slots on the broad wall and a wave port feed.  
2. **8×8 array** — eight parallel waveguides (8 ports total), each with the same 8-slot pattern.

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid path="assets/img/ee457/design-04/hfss_1x8_model.png" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid path="assets/img/ee457/design-04/hfss_8x8_model.png" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
</div>
<div class="caption">
  HFSS geometries: (left) 1×8 single-waveguide slot array, (right) 8×8 planar array (8 waveguides × 8 slots).
</div>

---

## Results summary (HFSS)

| Metric | 1×8 array | 8×8 array | Units |
| :-- | --: | --: | :-- |
| Peak gain (linear) | 34.70 | 272.42 | W/W |
| Peak gain | 15.40 | 24.35 | dB |
| 10-dB beamwidth (E-plane) | 11.24 | 11.26 | degrees |
| 10-dB beamwidth (H-plane) | 77.69 | 9.72 | degrees |
| Match (near resonance) | $|S_{11}| < -40$ | $|S_{nn}| < -25$ (all ports) | dB |
| Resonant frequency | $\approx 13.75$ | $\approx 13.75$ | GHz |

---

## 1×8 linear array results

### Radiation patterns (14 GHz)

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid path="assets/img/ee457/design-04/gain_1x8_polar_db.jpg" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid path="assets/img/ee457/design-04/gain_1x8_rect_db.jpg" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
</div>
<div class="caption">
  1×8 array gain patterns at 14 GHz: (left) polar plot, (right) principal-plane rectangular cut.
</div>

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid path="assets/img/ee457/design-04/gain_1x8_polar_linear.jpg" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
</div>
<div class="caption">
  1×8 array gain (linear scale) highlighting the broadside main lobe.
</div>

### Input match

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid path="assets/img/ee457/design-04/s11_1x8.jpg" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
</div>
<div class="caption">
  1×8 array $|S_{11}|$ vs. frequency. A deep resonance occurs near 13.75 GHz ($|S_{11}|$ below -40 dB).
</div>

---

## 8×8 planar array results

### Radiation patterns (14 GHz)

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid path="assets/img/ee457/design-04/gain_8x8_polar_db.jpg" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid path="assets/img/ee457/design-04/gain_8x8_rect_db.jpg" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
</div>
<div class="caption">
  8×8 array gain patterns at 14 GHz. The added aperture in the second dimension collapses the H-plane beamwidth to ~10°.
</div>

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid path="assets/img/ee457/design-04/gain_8x8_polar_linear.jpg" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
</div>
<div class="caption">
  8×8 array gain (linear scale) highlighting the narrow broadside beam.
</div>


<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid path="assets/img/ee457/design-04/gain_8x8_3d_db.jpg" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
</div>
<div class="caption">
  3D gain pattern (dB scale) for the 8×8 array showing a broadside pencil beam.
</div>

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid path="assets/img/ee457/design-04/gain_8x8_3d_linear.jpg" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
</div>
<div class="caption">
  3D gain pattern (linear scale) for the 8×8 array. Peak gain is ~272 (linear), i.e., 24.35 dB.
</div>

### S-parameters

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid path="assets/img/ee457/design-04/s11_8x8.jpg" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid path="assets/img/ee457/design-04/sparams_all_ports_8x8.jpg" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
</div>
<div class="caption">
  8×8 array return loss: (left) $|S_{11}|$ vs. frequency, (right) all diagonal $|S_{nn}|$ traces showing consistent matching across waveguide ports.
</div>

---

## Discussion

- **Beam shaping:** The Chebyshev taper provides a controlled sidelobe design target for the 1×8 array, and duplicating the guide in the x-dimension produces a **pencil beam** with significantly reduced H-plane beamwidth.  
- **Frequency shift:** Both arrays resonate near **13.75 GHz** rather than exactly 14 GHz. In practice this can be tuned by small adjustments to **slot length**, **end-short distance**, or including fabrication tolerances and conductor losses in the model.  
- **Scalability:** Because the 8×8 array is formed by **replicating** the synthesized 1×8 waveguide, the planar design approach scales naturally to larger apertures when feed/manifold constraints allow.

---

## Files and assets

- Place the images from the provided ZIP into: `assets/img/ee457/design-04/`
- Place this page into your al-folio repository (commonly): `_projects/ee457_design_04_slotted_wave_guide_array_antenna.md`
