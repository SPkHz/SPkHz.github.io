---
layout: page
title: EE-456 Design Project 04 Published: MAG Amplifier Design \& Non-Linear Simulation (8 GHz)
description: Maximum-Available-Gain (MAG) amplifier design at 8 GHz using transmission-line + stub matching (ATF34143 pHEMT). Verified in MATLAB vs Keysight ADS; evaluated with 1 dB compression, harmonic balance, and two-tone IP3.
tags: [RF, mm-wave, amplifier, matching, MAG, ADS, MATLAB, harmonic balance, IP3]
importance: 1
category: coursework
date: 2025-05-02 09:08:12-0500
thumbnail: assets/img/ee456/design04/00_cover.png
inline: false
show_on_home: false
related_posts: true
giscus_comments: false
pretty_table: true
images:
  slider: true
_styles: |
  .post article .mjx-container[display="true"] {
    font-size: 1.3em;
    margin: 0.9em 0 1.1em;
  }
  .post article .mjx-container {
    font-size: 1.12em;
  }
---

{% include figure.liquid loading="eager" path="assets/img/ee456/design04/00_cover.png" title="EE-456 Design Project 04 — MAG Amplifier Design / Non-Linear Simulation" class="img-fluid rounded z-depth-1" zoomable=true %}

## Overview

**Course:** EE-456 Microwave Active Circuits
**Project:** Design Project 04
**Author:** Steven Placzek
**Date:** 2025-05-02 09:08:12-0500

This project designs a **Maximum-Available-Gain (MAG)** amplifier at **\(f_0 = 8\ \text{GHz}\)** by choosing **\(\Gamma_S = \Gamma_{MS}\)** and **\(\Gamma_L = \Gamma_{ML}\)** (simultaneous conjugate match) for a pHEMT device, then implementing **transmission-line + shunt-stub matching networks** in **Keysight ADS** and validating the small-signal behavior with an independent **MATLAB** cascade model.

## Design setup

- **Center frequency:** \(f_0 = 8.0\ \text{GHz}\) (swept **7.5–8.5 GHz**)
- **Bias (ADS operating point):** \(V_D = 3.0\ \text{V}\), \(I_D = 20\ \text{mA}\), \(V_G \approx -0.665\ \text{V}\)
- **Target:** maximize transducer gain via **MAG design** (simultaneous conjugate match)

## MAG solution (target reflection coefficients)

| Quantity | Value (polar) | Notes |
|---|---:|---|
| \(\Gamma_S\) | \(0.8495\ \angle\ -88.9039^\circ\) | chosen as \(\Gamma_{MS}\) |
| \(\Gamma_L\) | \(0.4978\ \angle\ -179.4924^\circ\) | chosen as \(\Gamma_{ML}\) |
| \(G_T\) | \(8.3146\ \text{W/W}\) (**9.1984 dB**) | MAG operating point |

{% include figure.liquid loading="lazy" path="assets/img/ee456/design04/01_mag_design_specs.png" title="MAG design specifications (\(\Gamma_S\), \(\Gamma_L\), \(G_T\))" class="img-fluid rounded z-depth-1" zoomable=true %}

## Matching networks (TL + stub topology)

The input and output matches were realized with **50 Ω transmission-line sections** plus a **shunt stub** (short- or open-terminated, depending on side), with **DC block / feed elements** included where needed for biasing.

### Electrical lengths at \(f_0\)

| Network | Electrical length (deg) | Element type | Stub termination |
|---|---:|---|---|
| IMN | \(\theta_{I1} = 17.2506^\circ\) | TRL | — |
| IMN | \(\theta_{I2} = 118.5310^\circ\) | shunt stub | short |
| OMN | \(\theta_{O1} = 48.9375^\circ\) | TRL | — |
| OMN | \(\theta_{O2} = 29.8200^\circ\) | shunt stub | open |

{% include figure.liquid loading="lazy" path="assets/img/ee456/design04/14_transmission_lines.png" title="Transmission-line electrical lengths used in the IMN and OMN" class="img-fluid rounded z-depth-1" zoomable=true %}

### Smith-chart and ADS implementations

<swiper-container keyboard="true" navigation="true" pagination="true" pagination-clickable="true" rewind="true">
  <swiper-slide>{% include figure.liquid loading="eager" path="assets/img/ee456/design04/08_imn_smith_1.png" title="IMN Smith-chart design (part 1)" class="img-fluid rounded z-depth-1" %}</swiper-slide>
  <swiper-slide>{% include figure.liquid loading="eager" path="assets/img/ee456/design04/09_imn_smith_2.png" title="IMN Smith-chart design (part 2)" class="img-fluid rounded z-depth-1" %}</swiper-slide>
  <swiper-slide>{% include figure.liquid loading="eager" path="assets/img/ee456/design04/10_imn_ads_schematic.png" title="IMN schematic in ADS" class="img-fluid rounded z-depth-1" %}</swiper-slide>
  <swiper-slide>{% include figure.liquid loading="eager" path="assets/img/ee456/design04/11_omn_smith_1.png" title="OMN Smith-chart design (part 1)" class="img-fluid rounded z-depth-1" %}</swiper-slide>
  <swiper-slide>{% include figure.liquid loading="eager" path="assets/img/ee456/design04/12_omn_smith_2.png" title="OMN Smith-chart design (part 2)" class="img-fluid rounded z-depth-1" %}</swiper-slide>
  <swiper-slide>{% include figure.liquid loading="eager" path="assets/img/ee456/design04/13_omn_ads_schematic.png" title="OMN schematic in ADS" class="img-fluid rounded z-depth-1" %}</swiper-slide>
</swiper-container>

{% include figure.liquid loading="lazy" path="assets/img/ee456/design04/07_matching_network_layout.png" title="Matching-network layout and reflection-coefficient relations (image credit: Dr. Burke)" class="img-fluid rounded z-depth-1" zoomable=true %}

{% include figure.liquid loading="lazy" path="assets/img/ee456/design04/15_ads_device_schematic.png" title="Full ADS device-level schematic (IMN → pHEMT → OMN, with biasing and S-parameter simulation)" class="img-fluid rounded z-depth-1" zoomable=true %}

## Small-signal validation (MATLAB vs ADS)

The MATLAB cascade model (ABCD/T conversions + S-parameter interpolation) and ADS simulations agree essentially exactly at the design point.

<swiper-container keyboard="true" navigation="true" pagination="true" pagination-clickable="true" rewind="true">
  <swiper-slide>{% include figure.liquid loading="eager" path="assets/img/ee456/design04/16_compare_s21.png" title="\(|S_{21}|\) MATLAB vs ADS" class="img-fluid rounded z-depth-1" %}</swiper-slide>
  <swiper-slide>{% include figure.liquid loading="eager" path="assets/img/ee456/design04/17_compare_s11.png" title="\(|S_{11}|\) MATLAB vs ADS" class="img-fluid rounded z-depth-1" %}</swiper-slide>
  <swiper-slide>{% include figure.liquid loading="eager" path="assets/img/ee456/design04/18_compare_s22.png" title="\(|S_{22}|\) MATLAB vs ADS" class="img-fluid rounded z-depth-1" %}</swiper-slide>
  <swiper-slide>{% include figure.liquid loading="eager" path="assets/img/ee456/design04/19_compare_sij.png" title="All \(S_{ij}\) overlay (MATLAB vs ADS)" class="img-fluid rounded z-depth-1" %}</swiper-slide>
</swiper-container>

{% include figure.liquid loading="lazy" path="assets/img/ee456/design04/20_ads_small_signal_results.png" title="ADS small-signal summary (\(G_T\) and S-parameter response)" class="img-fluid rounded z-depth-1" zoomable=true %}

## Non-linear simulations (ADS)

### 1 dB compression

| Metric | Value |
|---|---:|
| \(G_T\) (small-signal) | **9.1984 dB** |
| \(G_T\) at 1 dB comp | **8.1858 dB** |
| \(P_{in,1\text{dB}}\) | **5.9500 dBm** |
| \(P_{out,1\text{dB}}\) | **14.1358 dBm** |

{% include figure.liquid loading="lazy" path="assets/img/ee456/design04/03_1db_compression_table2.png" title="1 dB compression point summary" class="img-fluid rounded z-depth-1" zoomable=true %}

{% include figure.liquid loading="lazy" path="assets/img/ee456/design04/22_gt_1db_compression.png" title="Gain compression plot used to extract \(P_{in,1\text{dB}}\) and \(G_T(1\text{dB})\)" class="img-fluid rounded z-depth-1" zoomable=true %}

### Harmonic balance (single-tone)

{% include figure.liquid loading="lazy" path="assets/img/ee456/design04/23_harmonic_balance_pin_1db.png" title="Harmonic balance example at \(P_{in} = P_{in,1\text{dB}}\): output spectrum and \(v_o(t)\)" class="img-fluid rounded z-depth-1" zoomable=true %}

### Two-tone intermodulation + IP3

| Metric | Value |
|---|---:|
| \(P_{out}(\mathrm{IP3})\) | 25.6176 dBm (LSB), 25.8347 dBm (USB) |
| \(P_{in}(\mathrm{IP3})\) | 16.5620 dBm (LSB), 16.8225 dBm (USB) |

{% include figure.liquid loading="lazy" path="assets/img/ee456/design04/06_ip3_table5.png" title="Two-tone IP3 point summary" class="img-fluid rounded z-depth-1" zoomable=true %}

{% include figure.liquid loading="lazy" path="assets/img/ee456/design04/24_two_tone_ip3_task11.png" title="Two-tone spectrum and mixing products (Task 11)" class="img-fluid rounded z-depth-1" zoomable=true %}

#### Single-tone power output (harmonics)

{% include figure.liquid loading="lazy" path="assets/img/ee456/design04/04_single_tone_table3.png" title="Single-tone output power at \\(f_0\\), \\(2f_0\\), and \\(3f_0\\) for multiple input levels" class="img-fluid rounded z-depth-1" zoomable=true %}

#### Two-tone power output (low-level IMD)

{% include figure.liquid loading="lazy" path="assets/img/ee456/design04/05_two_tone_table4.png" title="Two-tone output power and third-order intermodulation products at low input level" class="img-fluid rounded z-depth-1" zoomable=true %}
