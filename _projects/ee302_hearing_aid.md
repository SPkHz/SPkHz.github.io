---
layout: page
title: EE-302 Hearing Aid FIR Filter-Bank Equalizer
description: Audiogram-driven FIR filter-bank audio equalizer (MATLAB • fir1/fir2 • linear-phase FIR).
img: /assets/img/ee302/design1/Audiogram__FilterBank_Response_Direct_Sum.png
importance: 1
category: work
related_publications: false
---

This project designs a **personalized “virtual hearing aid” audio equalizer** using **FIR filter-banks**. Given a user audiogram (hearing loss vs. frequency), the goal is to generate a composite FIR response that **adds frequency-dependent gain** to counteract the loss—ideally pulling the effective response back toward **0 dB** across the audible band of interest (0–10 kHz at **fs = 20 kHz**).

**Team:** Steven Placzek, Bryam Garcia Yanza  
**Tools:** MATLAB (`fir1`, `fir2`, `freqz`, `pwelch`, `audioread`, `audiowrite`)

---

## Problem Setup: Audiogram → Compensation Target

The audiogram is represented by key loss points (dB) and then smoothed using **PCHIP interpolation** with a small ±200 Hz padding around each point to avoid sharp transitions. Gains are mapped from loss in dB to linear amplitude via:

$$
G_{\text{linear}} = 10^{(\text{Loss}_{dB}/20)}
$$

| Frequency (Hz) | Loss (dB) |
|---:|---:|
| 0 | 0 |
| 1250 | 20 |
| 2500 | 10 |
| 3750 | 30 |
| 5000 | 15 |
| 6250 | 45 |
| 7500 | 5 |
| 8750 | 70 |
| 10000 | 80 |

---

## Two Filter-Bank Architectures

### Design 1 — Band-Based FIR Filter-Bank (fir2, N = 300)
A straightforward approach: **8 overlapping band filters** spanning 0–10 kHz. Each band is shaped using `fir2` (frequency-sampling method) with a custom amplitude “plateau/triangle” profile, then scaled by the corresponding audiogram gain. This tends to produce a **smoother overall correction**, at the cost of more filters.

### Design 2 — Center-Frequency Band-Pass FIR Filter-Bank (fir1, N = 51)
A more efficient approach: **5 Hamming-window band-pass filters** designed with `fir1`, centered near key audiogram regions. Bandwidths are chosen so that a single filter can cover multiple audiogram points where reasonable. This reduces computational load but can **approximate** (rather than explicitly hit) every point.

---

## Results (Frequency Response)

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee302/design1/Audiogram_with_Bandwidth-Expanded_Key_Points.png" title="Audiogram (PCHIP smoothed)" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee302/design1/Individual_Filter_Responses_v2.png" title="Design 1 — Individual filter responses" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee302/design1/Audiogram__FilterBank_Response_Direct_Sum.png" title="Design 1 — Compensation check (audiogram + filter-bank)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  <b>Design 1:</b> The smoothed audiogram drives 8 overlapping FIR bands. The direct-sum plot verifies compensation by adding the filter-bank magnitude (dB) to the inverse audiogram; the target is a curve near <b>0 dB</b>.
</div>

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee302/design2/Individual_Band-Pass_Filters_Centered_at_Specific_Frequencies.png" title="Design 2 — Individual band-pass filters" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee302/design2/Combined_FilterBank_Response.png" title="Design 2 — Combined filter-bank response" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee302/design2/Audiogram__FilterBank_Response_Design_2.png" title="Design 2 — Compensation check (audiogram + filter-bank)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  <b>Design 2:</b> Fewer filters (5 total) using <code>fir1</code> + Hamming window. The combined response still tracks the compensation target while reducing filter-bank complexity.
</div>

---

## Real Audio Processing (Time + Spectrum)

To validate practical behavior, the composite FIR filter-bank was applied to real audio (speech/music/noise). Spectral comparisons use **Welch PSD** with a **Taylor window**.

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee302/Fur_Spec.jpg" title="Fur Elise — Welch spectrum (input vs filtered)" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee302/Beethoven_Spec.jpg" title="Beethoven — Welch spectrum (input vs filtered)" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee302/Bensound_Spec.jpg" title="Bensound — Welch spectrum (input vs filtered)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  Filter-bank equalization shifts spectral energy upward in frequency regions associated with higher hearing-loss compensation targets.
</div>

---

## Reproducibility

- **Design 1 (fir2):** Appendix/Matlab/Design_1_Final.m  
- **Design 2 (fir1):** Appendix/Matlab/Design_2_Final.m

If you want the audio demo portion, update the audio file paths in the script to point at your local `.wav` test clips (the provided script expects 20 kHz audio).

---

## Notes

This is a DSP design study and not a medical device. Real hearing aids must also address loudness growth, compression, feedback, latency constraints, and safety limits.
