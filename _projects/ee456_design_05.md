---
layout: page
title: EE-456 Design Project 05 — 8 GHz Oscillator (ATF-33143) via Negative Resistance
description: Negative-resistance oscillator synthesis at 8 GHz using common-gate conversion, feedback-reactance optimization, and transmission-line termination/resonator networks (MATLAB • Touchstone).
img: /assets/img/ee456/design05/thumbnail.png
importance: 1
category: coursework
giscus_comments: false
related_publications: false
pretty_table: true
images:
  slider: true
---

This project designs an **8 GHz oscillator** using the **ATF-33143 GaAs FET** biased at **V<sub>DS</sub> = 4 V** and **I<sub>DS</sub> = 80 mA**, following the **negative-resistance** workflow used in EE-456/556.

**Tools:** MATLAB (Touchstone I/O + network transforms + parameter sweeps)

---

## Design workflow (what was built)

1. **Common-source → common-gate conversion**
   - Converted the device’s 2-port **S-parameters** to a **common-gate** configuration using an **indefinite admittance matrix** transformation.

2. **Feedback-reactance optimization**
   - Swept a gate feedback reactance **X<sub>B</sub>** to **maximize |S<sub>11</sub>|** in common-gate.

3. **Transmission-line replacement (feedback stub)**
   - Replaced the optimized lumped reactance with a **transmission-line stub** (electrical-length equivalent at 8 GHz).

4. **Drain termination network**
   - Synthesized a transmission-line termination network that realizes the target **Γ<sub>T</sub>** at the drain.

5. **Source resonator network**
   - Synthesized the resonator network that realizes the target **Γ<sub>R</sub>** at the source.

6. **Verification**
   - Verified the resulting **Γ<sub>in</sub>** and **Z<sub>in</sub>** when the termination network is attached.

---

## Results summary

| Parameter | Value (MATLAB) | Notes |
| --- | ---: | --- |
| X<sub>B</sub> | 130 Ω | Maximizes \(|S_{11}|\) in common-gate |
| θ<sub>x</sub> | 0.367 rad (≈ 21.0°) | Electrical length of the feedback-stub equivalent at 8 GHz |
| Γ<sub>T</sub> | 0.500 ∠ 162.019° | Drain termination reflection coefficient |
| Z<sub>in</sub> | 146.305 Ω | Input impedance after attaching termination network |
| Γ<sub>in</sub> | 0.8403 ∠ -17.172° | Input reflection coefficient after attaching termination network |
| \(\tilde{Z}_R\) | 8.8188 Ω | Extracted effective negative-resistance term (per course method) |
| Γ<sub>R</sub> | 0.7500 ∠ -127.733° | Source resonator reflection coefficient |

---

## Plots

<swiper-container keyboard="true" navigation="true" pagination="true" pagination-clickable="true" pagination-dynamic-bullets="true" rewind="true">
  <swiper-slide>
    {% include figure.liquid loading="eager" path="assets/img/ee456/design05/s11_vs_xb.png" title="|S11| vs. feedback reactance (common-gate)" class="img-fluid rounded z-depth-1" %}
  </swiper-slide>
  <swiper-slide>
    {% include figure.liquid loading="eager" path="assets/img/ee456/design05/stability_vs_xb.png" title="Stability factors vs. feedback reactance" class="img-fluid rounded z-depth-1" %}
  </swiper-slide>
  <swiper-slide>
    {% include figure.liquid loading="eager" path="assets/img/ee456/design05/gammaT_contours.png" title="ΓT contour sweep (series-line + shunt-stub) with chosen solution" class="img-fluid rounded z-depth-1" %}
  </swiper-slide>
  <swiper-slide>
    {% include figure.liquid loading="eager" path="assets/img/ee456/design05/gammaT_contours_raw.png" title="Raw MATLAB sweep output: ΓT contours" class="img-fluid rounded z-depth-1" %}
  </swiper-slide>
</swiper-container>

---

## Files

- MATLAB: parameter sweeps, indefinite-Y conversion, and transmission-line synthesis
- Touchstone: **ATF-33143** S-parameters at the specified bias point
