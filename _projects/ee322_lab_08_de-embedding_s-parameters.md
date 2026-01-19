---
layout: page
title: "De-Embedding Device S-Parameters from Vector Network Analyzer Measurments"
description: "Vector Network Analyzer (VNA) measurements of LPF/HPF frequency response with 2x-thru de-embedding (Touchstone • Python • SciPy)."
img: /assets/img/ee322/lab-08/thumbnail.png
importance: 1
category: coursework
related_publications: true
---

**Course:** EE-322 — Electrical Engineering Lab II  \
**Lab:** 08 — Vector Network Analyzer Basics and S-Parameter De-Embedding  \
**Date:** 2025-04-28  \
**Tools:** Keysight P9371A VNA, Keysight ECal, RF demo board (LPF/HPF), Python (NumPy/SciPy/Matplotlib), Touchstone (`.s1p`, `.s2p`)

---

## Overview

This lab focused on using a **Vector Network Analyzer (VNA)** to measure **S-parameters** and then applying **de-embedding** to remove the measurement fixture’s influence from the results.

Two devices on an RF demo board were characterized over a **1–60 MHz** sweep:

- **Low‑Pass Filter (LPF)** section of the demo board
- **High‑Pass Filter (HPF)** section of the demo board

The main deliverable was a repeatable workflow that:

1. Loads VNA-exported **Touchstone** data.
2. Converts the measured **S-parameters** into a cascaded form (**chain-scattering / T-parameters**).
3. Uses a **2x‑Thru** fixture measurement to estimate **half‑fixtures** via a matrix square root.
4. Removes the fixture halves from both sides of the DUT measurement.
5. Plots and compares **raw vs. de‑embedded** responses.

> **Correction applied:** An initial draft computed `thru_half` but did not use it. This page uses the **Thru** measurement directly (2x‑thru / half‑fixture method), so the fixture’s transmission line effects are actually removed.

---

## Measurement Setup

<div class="row justify-content-sm-center">
  <div class="col-sm-10 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab-08/setup_overview.png" title="Lab hardware overview (VNA + ECal + RF demo board)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  Keysight P9371A VNA with ECal module and RF demo board sections used for the LPF/HPF measurements.
</div>

### Calibration / reference measurements

The dataset includes fixture reference structures measured on the same sweep grid:

- **Open** (reflection standard)
- **Short** (reflection standard)
- **Thru** (2‑port “fixture + fixture” path)

For the de‑embedding shown on this page, the **Thru** measurement is treated as a **2x‑thru** structure:

- `Thru ≈ Fixture_half ∘ Fixture_half`

---

## Theory Snapshot

A VNA measures the cascaded network it “sees” between its two ports:

<div class="row justify-content-sm-center">
  <div class="col-sm-10 mt-3 mt-md-0">
    {% include figure.liquid path="assets/img/ee322/lab-08/measurement_topology.png" title="Measured network = fixture + DUT + fixture" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

### S-parameters

<div class="row justify-content-sm-center">
  <div class="col-sm-10 mt-3 mt-md-0">
    {% include figure.liquid path="assets/img/ee322/lab-08/sparameter_directions.png" title="2-port S-parameter definition" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

### Cascading via chain-scattering (T) parameters

S-parameters do **not** cascade by simple matrix multiplication. To cascade/de-cascade fixture networks, we convert to **T** (chain-scattering) parameters:

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid path="assets/img/ee322/lab-08/s_to_t_conversion.png" title="S → T conversion" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid path="assets/img/ee322/lab-08/deembed_equation.png" title="De-embedding in the T-domain" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid path="assets/img/ee322/lab-08/t_to_s_conversion.png" title="T → S conversion" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  The conversion relationships used in the Python workflow (matching the lab handout). After de-embedding in the T-domain, we convert back to S-parameters for plotting.
</div>

---

## Data Processing Workflow

### 1) Load Touchstone data

- `Thru.s2p` (fixture + fixture)
- `lpf.s2p` (fixture + LPF + fixture)
- `hpf.s2p` (fixture + HPF + fixture)

> **Note (data hygiene):** some VNA exports may contain placeholder values for `S12`/`S22` if only forward terms were enabled during capture. In this dataset, the LPF + Thru files include placeholder reverse terms, so the processing step enforces a **reciprocal/symmetric** two-port model (`S12 = S21`, `S22 = S11`) before the T‑conversion.

### 2) 2x-thru de-embedding steps

For each frequency point:

1. Convert `S_thru → T_thru`
2. Compute half‑fixture: `T_half = sqrtm(T_thru)`
3. Convert measured DUT network: `S_meas → T_meas`
4. De‑embed: `T_dut = inv(T_half) · T_meas · inv(T_half)`
5. Convert back: `T_dut → S_dut`

---

## Results — Low‑Pass Filter (LPF)

Key metrics extracted from the de‑embedded response:

- **Passband insertion loss (1–10 MHz, mean):** ~**−0.09 dB**
- **−3 dB cutoff frequency:** **~24.84 MHz**
- **Stopband attenuation at 60 MHz:** ~**−21.8 dB**

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab-08/lpf_s21_raw_vs_deembedded.png" title="LPF S21 (raw vs de-embedded)" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab-08/lpf_s11_raw_vs_deembedded.png" title="LPF S11 (raw vs de-embedded)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  LPF transmission (S21) and input reflection (S11) before and after 2x‑thru de‑embedding.
</div>

<div class="row justify-content-sm-center">
  <div class="col-sm-7 mt-3 mt-md-0">
    {% include figure.liquid path="assets/img/ee322/lab-08/lpf_s11_complex_plane.png" title="LPF S11 complex plane" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  Complex-plane view of S11 (unit circle reference). De‑embedding shifts the apparent reflection trajectory by removing the fixture contribution.
</div>

---

## Results — High‑Pass Filter (HPF)

Within the **1–60 MHz** sweep, the HPF is still in its rising transition region (the board’s HPF corner is higher than this sweep), so a **−3 dB corner is not observed** in the captured data.

A practical summary from the measured sweep:

- **S21 @ 1 MHz:** ~**−93 dB** (deep attenuation)
- **S21 @ 60 MHz:** ~**−9.4 dB** (still attenuated)
- **S21 crosses −10 dB:** ~**58.4 MHz**

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab-08/hpf_s21_raw_vs_deembedded.png" title="HPF S21 (raw vs de-embedded)" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab-08/hpf_s11_raw_vs_deembedded.png" title="HPF S11 (raw vs de-embedded)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  HPF transmission (S21) and input reflection (S11) before and after 2x‑thru de‑embedding.
</div>

<div class="row justify-content-sm-center">
  <div class="col-sm-7 mt-3 mt-md-0">
    {% include figure.liquid path="assets/img/ee322/lab-08/hpf_s11_complex_plane.png" title="HPF S11 complex plane" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

---

## ADS Cross‑Check (Optional)

The same Touchstone files can be imported into ADS and de‑embedded using its built‑in **De_Embed2** block.

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid path="assets/img/ee322/lab-08/ads_LPF_OST_S21.png" title="ADS: LPF de-embedded S21" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid path="assets/img/ee322/lab-08/ads_De_Embedded_vs_Embed_1.png" title="ADS: Smith chart comparison" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  Example ADS outputs using the same measurement data.
</div>

---

## Reproducibility (Python)

The following snippet shows the core of the processing pipeline used to generate the plots on this page (Touchstone parsing omitted for brevity):

```python
import numpy as np
import scipy.linalg

# S is a complex 2x2 matrix at one frequency:
# S = [[S11, S12],
#      [S21, S22]]

def s_to_t(S):
    S11, S12, S21, S22 = S[0,0], S[0,1], S[1,0], S[1,1]
    det = S11*S22 - S12*S21
    T11 = -det/S21
    T12 =  S11/S21
    T21 = -S22/S21
    T22 =  1.0/S21
    return np.array([[T11, T12], [T21, T22]], dtype=complex)

def t_to_s(T):
    T11, T12, T21, T22 = T[0,0], T[0,1], T[1,0], T[1,1]
    S21 = 1.0/T22
    S11 = T12/T22
    S22 = -T21/T22
    S12 = (T11*T22 - T12*T21)/T22
    return np.array([[S11, S12], [S21, S22]], dtype=complex)

# 2x-thru de-embedding for one frequency point
T_thru = s_to_t(S_thru)
T_half = scipy.linalg.sqrtm(T_thru)
T_meas = s_to_t(S_measured)

T_dut  = np.linalg.inv(T_half) @ T_meas @ np.linalg.inv(T_half)
S_dut  = t_to_s(T_dut)
```

---

## Files

Measurement files used (Touchstone):

- `Open.s2p`, `short.s2p`, `Thru.s2p`
- `lpf.s2p`, `hpf.s2p`

Generated artifacts (this page):

- All plots and figures are stored under `assets/img/ee322/lab-08/`.

---

## References

- IEEE 370-2020: *Standard for Electrical Characterization of Printed Circuit Board and Related Interconnects at Frequencies up to 50 GHz*.
- Additional background papers on de-embedding and fixture removal are included in the lab’s source package.
