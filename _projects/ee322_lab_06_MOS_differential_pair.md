---

layout: page
title: Analysis of the MOS Differential Pair (Single-Ended vs. Differential Signaling)
description: Characterization a MOS differential pair (ALD1105) in DC and AC; compare single-ended vs differential output and quantify CMRR.
img: /assets/img/ee322/lab-06/lab06_cover.png
category: coursework
importance: 97157844802
related_publications: true
tags:
  - mos differential pair
  - single-ended output
  - differential signaling
  - cmrr
  - ald1105
  - ltspice
  - measurement
---

**Course:** EE-322 — Electrical Engineering Lab II  \\
**Lab:** 06 — MOS Differential Pair: Single-Ended vs. Differential Signaling  \\
**Date:** 2025-03-31

---

## Overview

This lab investigates a **MOS differential pair** implemented with the **ALD1105 MOSFET array** and compares:

- **Single-ended output** (measuring one drain node w.r.t. ground)
- **Differential output** (measuring the voltage across both drain nodes)

The main goal is to quantify how differential signaling improves **common-mode rejection** (CMRR) while preserving (or improving) differential gain.

**Tools:** Analog Discovery Studio (bench measurement), LTspice (simulation)

---

## Key results

- **Measured CMRR (single-ended):** **21.724 dB**
- **Measured CMRR (differential):** **48.328 dB**
- Differential output improved measured CMRR by **≈ 26.6 dB**.

---

## Hardware reference and circuit

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab-06/ald1105_pinout.png" title="ALD1105 pinout and internal device diagram" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab-06/mos_diff_pair_schematic.png" title="MOS differential pair used for DC + AC characterization" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  <b>Implementation note:</b> In the ALD1105 array, the NMOS body (<code>V−</code>) is tied to the NMOS source and the PMOS body (<code>V+</code>) is tied to the PMOS source (package substrate pins).
</div>

**Nominal circuit parameters** (per lab handout):

- \(V_{DD} = +12\,\text{V}\), \(V_{SS} = -12\,\text{V}\)
- \(R_D = 18\,\text{k}\Omega\) (two resistors)
- \(R_{CS} = 10\,\text{k}\Omega\)
- \(V_{I1} = V_{I2} = 0\,\text{V}\) for the DC operating point

---

## Measured resistor values

| Quantity | Measured | Units |
|---|---:|:---:|
| \(R_D\) (left) | 18.025 | kΩ |
| \(R_D\) (right) | 17.975 | kΩ |
| \(R_{CS}\) | 9.839 | kΩ |

---

## DC operating point

The DC operating point was measured at the drain and source nodes and compared against LTspice.

| Device | Quantity | Simulated | Measured | Units |
|---|---|---:|---:|:---:|
| Q1 | \(I_D\) | 562.943 | 483.141 | µA |
| Q1 | \(|V_{OV}|\) | 1.407 | 1.141 | V |
| Q1 | \(V_G\) | 0.000 | 0.000 | V |
| Q1 | \(V_D\) | 3.063 | 2.896 | V |
| Q1 | \(V_S\) | -1.891 | -1.820 | V |
| Q2 | \(I_D\) | 558.043 | 524.011 | µA |
| Q2 | \(|V_{OV}|\) | 1.407 | 1.140 | V |
| Q2 | \(V_G\) | 0.000 | 0.000 | V |
| Q2 | \(V_D\) | 2.060 | 2.011 | V |
| Q2 | \(V_S\) | -1.700 | -1.819 | V |

---

## AC characterization

### Definitions

For a differential pair, the small-signal metrics of interest are:

- **Differential gain** \(A_d\)
- **Common-mode gain** \(A_{cm}\)
- **Common-mode rejection ratio** (CMRR)

The CMRR is defined as:

$$
\mathrm{CMRR} = \left|\frac{A_d}{A_{cm}}\right|, \qquad \mathrm{CMRR}_{dB} = 20\log_{10}\left|\frac{A_d}{A_{cm}}\right|.
$$

### Measurement modes

- **Differential input:** equal-amplitude sinusoids applied to \(v_{I1}\) and \(v_{I2}\), **180° out of phase**, with both generators synchronized and properly biased.
- **Common-mode input:** identical sinusoids applied to \(v_{I1}\) and \(v_{I2}\), **in phase**, synchronized and biased.

---

## Results

### Single-ended output (node \(V_Y\) w.r.t. ground)

| Quantity | Simulated | Measured | Units |
|---|---:|---:|:---:|
| \(A_d\) | 6.018 | 6.205 | V/V |
| \(A_d\) | 15.580 | 15.801 | dB |
| \(A_{cm}\) | 0.840 | 0.499 | V/V |
| \(A_{cm}\) | -1.515 | -5.924 | dB |
| CMRR | 17.104 | 21.724 | dB |

### Differential output (\(V_Y - V_X\))

| Quantity | Simulated | Measured | Units |
|---|---:|---:|:---:|
| \(A_d\) | 12.020 | 12.024 | V/V |
| \(A_d\) | 21.598 | 21.578 | dB |
| \(A_{cm}\) | 0.001 | 0.053 | V/V |
| \(A_{cm}\) | -61.379 | -26.760 | dB |
| CMRR | 59.872 | 48.328 | dB |

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab-06/cmrr_comparison.png" title="CMRR comparison (single-ended vs differential output)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  Differential output rejects common-mode content much more effectively than single-ended output. The measured CMRR improvement is about <b>26.6 dB</b> (48.328 dB − 21.724 dB).
</div>

---

## Why differential signaling improves noise rejection

Differential signaling measures the difference between two complementary nodes:

$$
\text{If } v_x = v_s + v_n \text{ and } v_y = -v_s + v_n, \quad (v_y - v_x) = -2v_s.
$$

Any **common-mode disturbance** \(v_n\) that couples similarly onto both nodes cancels in the subtraction. Practical limitations (finite device mismatch, finite tail resistance, measurement resolution, generator alignment, etc.) keep \(A_{cm}\) from reaching zero in the lab.

---

## Differential-pair behavior (current steering + \(g_m\))

A MOS differential pair “steers” the tail current between devices as the differential input changes. In the square-law saturation model, the differential gain is often approximated as:

$$
|A_v| \approx g_m R_D.
$$

The normalized plots below illustrate:

- **Current steering:** \(I_{D1}\) increases while \(I_{D2}\) decreases as \(\Delta v_{in}\) becomes positive.
- **Transconductance:** \(g_m\) peaks near \(\Delta v_{in}=0\) and falls toward 0 as one device approaches cutoff.

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab-06/diff_pair_current_gm_normalized.png" title="Conceptual differential-pair current steering and transconductance (normalized)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

---

## LTspice verification example

The plot below shows the output behavior for **differential excitation** (out-of-phase inputs) versus **common-mode excitation** (in-phase inputs). The differential case produces a much larger output swing.

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab-06/ltspice_vo_common_vs_diff.png" title="LTspice time-domain output: common-mode vs differential input" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

---

## Reproducibility notes

- In LTspice, using the **measured resistor values** (instead of nominal values) improves agreement with bench results.
- CMRR measurements are sensitive to:
  - generator amplitude/phase matching,
  - bias offsets,
  - probe ground/reference configuration,
  - and device mismatch in the MOS array.

