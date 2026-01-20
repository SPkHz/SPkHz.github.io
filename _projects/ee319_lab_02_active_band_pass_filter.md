---
layout: page
title: Active Band-Pass Filter Measurement and Analysis
description: Measurement + modeling of a 2nd-order active band-pass filter (LM741). Bode sweep (10 Hz–100 kHz), time-domain validation, and harmonic/spectrum analysis (MATLAB + LTspice + Digilent WaveForms).
img: /assets/img/ee319/lab-02/thumbnail.png
category: coursework
date: 2024-10-01 00:11:30-0400
giscus_comments: false
pretty_table: true
images:
  slider: true
  compare: true
tabs: true
importance: 6178927185569738
related_publications: true
tags:
  - active band-pass filter
  - second-order filter
  - lm741
  - bode plot
  - harmonic analysis
  - ltspice
  - analog discovery
  - matlab
_styles: |
  /* Slightly larger MathJax without blowing up inline math */
  .post article .mjx-container[display="true"],
  .page article .mjx-container[display="true"] {
    font-size: 1.25em;
    margin: 0.85em 0 1.05em;
  }
  .post article .mjx-container,
  .page article .mjx-container {
    font-size: 1.10em;
  }
---

## Overview

**Course:** EE-319 Electronics Lab I (WNEU • Fall 2024)  
**Lab:** #02 — Measurements  
**Focus:** Active band-pass filter characterization (magnitude/phase, time-domain, and frequency spectrum)

This lab builds and characterizes a 2nd-order **active band-pass filter** using an **LM741** op-amp. The workflow:

1. Build the circuit and measure the **Bode response** from 10 Hz to 100 kHz.
2. Post-process the measured data in **MATLAB** (magnitude + phase).
3. Extract key band-pass parameters (mid-band gain, fL, f0, fH, BW, Q).
4. Validate behavior in the time domain at key frequencies.
5. Run **spectrum/harmonic** measurements for a 1.5 kHz test tone and square wave.

---

## Circuit

Component values used in the build:

- R1 = 1 kΩ
- R2 = 68 kΩ
- R3 = 22 kΩ
- C1 = 4.7 nF
- C2 = 47 nF
- Op-amp: LM741, powered at ±12 V

<div class="row justify-content-sm-center">
  <div class="col-sm-10 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee319/lab-02/schematic_active_bpf.png" title="Active band-pass filter schematic" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  Active band-pass filter used for the lab.
</div>

A compact transfer-function form (idealized):

- Let G1 = 1/R1, G2 = 1/R2, G3 = 1/R3.
- Av(s) = - (G1*C1*s) / (C1*C2*s^2 + G2*(C1+C2)*s + G2\*(G1+G3))

---

## Bode sweep (10 Hz → 100 kHz)

<swiper-container keyboard="true" navigation="true" pagination="true" pagination-clickable="true" pagination-dynamic-bullets="true" rewind="true">
  <swiper-slide>{% include figure.liquid loading="eager" path="assets/img/ee319/lab-02/measured_bode_waveforms.png" title="Measured Bode plot (WaveForms)" class="img-fluid rounded z-depth-1" %}</swiper-slide>
  <swiper-slide>{% include figure.liquid loading="eager" path="assets/img/ee319/lab-02/bode_magnitude_measured_vs_calculated.png" title="Magnitude: measured vs calculated" class="img-fluid rounded z-depth-1" %}</swiper-slide>
  <swiper-slide>{% include figure.liquid loading="eager" path="assets/img/ee319/lab-02/bode_phase_measured_vs_calculated.png" title="Phase: measured vs calculated" class="img-fluid rounded z-depth-1" %}</swiper-slide>
  <swiper-slide>{% include figure.liquid loading="eager" path="assets/img/ee319/lab-02/bode_magnitude_key_frequencies.png" title="Magnitude with key frequencies marked" class="img-fluid rounded z-depth-1" %}</swiper-slide>
  <swiper-slide>{% include figure.liquid loading="eager" path="assets/img/ee319/lab-02/bode_magnitude_matlab.jpg" title="MATLAB magnitude plot (report figure)" class="img-fluid rounded z-depth-1" %}</swiper-slide>
  <swiper-slide>{% include figure.liquid loading="eager" path="assets/img/ee319/lab-02/bode_phase_matlab.jpg" title="MATLAB phase plot (report figure)" class="img-fluid rounded z-depth-1" %}</swiper-slide>
</swiper-container>

<div class="caption">
  Bode magnitude/phase across 10 Hz–100 kHz. The clean plots are regenerated directly from the WaveForms CSV export and compared to the ideal transfer function.
</div>

---

## Extracted band-pass parameters

The table below summarizes the key filter metrics (calculated vs LTspice vs measured). For readability, fL/f0/fH are shown in kHz.

| Metric  | Calculated | LTspice | Measured | Units   | Calc vs LTspice (% diff) | Calc vs Measured (% diff) |
| ------- | ---------: | ------: | -------: | ------- | -----------------------: | ------------------------: | -------- | ------ |
| Av(mid) |    -6.1818 | -6.1811 |  -6.8075 | V/V     |                  0.0118% |                    9.634% |
|         |    Av(mid) |         |  15.8223 | 15.8213 |                  16.6598 |                        dB | 0.00649% | 5.157% |
| fL      |     1.0818 |  1.0802 |   1.0038 | kHz     |                   0.150% |                    7.484% |
| f0      |     1.3278 |  1.3253 |   1.5000 | kHz     |                   0.186% |                    12.18% |
| fH      |     1.6296 |  1.6261 |   1.5409 | kHz     |                   0.215% |                    5.594% |
| BW      |     547.78 |  545.89 |   537.14 | Hz      |                   0.345% |                    1.961% |
| Q       |     2.4239 |  2.4278 |   2.2957 | —       |                   0.159% |                    5.433% |

---

## Time-domain validation at key frequencies

Measured v_i(t) and v_o(t) at fL, f0, and fH.

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee319/lab-02/scope_fl.png" title="Scope capture at fL" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee319/lab-02/scope_f0.png" title="Scope capture at f0" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee319/lab-02/scope_fh.png" title="Scope capture at fH" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  Output amplitude peaks near the band center and rolls off toward the -3 dB edges.
</div>

---

## Square-wave test at 1.5 kHz

A 1 V input square wave at 1.5 kHz is strongly band-limited by the filter, producing a waveform that resembles a sine with transient droop/rounding at each transition.

<div class="row justify-content-sm-center">
  <div class="col-sm-10 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee319/lab-02/scope_square_1p5khz.png" title="Scope capture (square-wave input)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

### Spectrum (input vs output)

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee319/lab-02/spectrum_vi.png" title="Measured spectrum of v_i" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee319/lab-02/spectrum_vo.png" title="Measured spectrum of v_o" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  The band-pass response emphasizes the fundamental and nearby odd harmonics while strongly suppressing components outside the passband.
</div>

{% tabs ee319lab02-harmonics %}

{% tab ee319lab02-harmonics Input (Vi) %}

| Harmonic | f   | Calc (dBV) | LTspice (dBV) | Measured (dBV) |
| -------: | --- | ---------: | ------------: | -------------: |
|        1 | fT  |     2.0982 |        2.0966 |         1.3860 |
|        2 | 2fT |  -313.0712 |      -67.9588 |       -63.6707 |
|        3 | 3fT |    -7.4442 |       -7.4445 |        -7.4166 |
|        4 | 4fT |  -313.0712 |      -67.9588 |       -65.4525 |
|        5 | 5fT |   -11.8812 |      -11.8794 |       -11.2048 |
|        6 | 6fT |  -313.0712 |      -67.9588 |       -60.6109 |
|        7 | 7fT |   -14.8038 |      -14.8033 |       -13.2164 |
|        8 | 8fT |  -313.0712 |      -67.9610 |       -68.7340 |
|        9 | 9fT |   -16.9866 |      -16.9849 |       -14.1555 |

{% endtab %}

{% tab ee319lab02-harmonics Output (Vo) %}

| Harmonic | f   | Calc (dBV) | LTspice (dBV) | Measured (dBV) |
| -------: | --- | ---------: | ------------: | -------------: |
|        1 | fT  |    16.6128 |       16.5551 |        13.6300 |
|        2 | 2fT |  -310.3439 |      -67.5827 |       -54.6211 |
|        3 | 3fT |    -9.1994 |       -9.2110 |        -9.5560 |
|        4 | 4fT |  -317.6435 |      -73.3917 |       -59.0701 |
|        5 | 5fT |   -18.5360 |      -18.5771 |       -19.1350 |
|        6 | 6fT |  -321.3872 |      -79.2754 |       -76.6658 |
|        7 | 7fT |   -24.5053 |      -24.6480 |       -25.8916 |
|        8 | 8fT |  -323.9626 |      -79.4775 |       -64.8928 |
|        9 | 9fT |   -28.9217 |      -28.8643 |       -31.1326 |

{% endtab %}

{% tab ee319lab02-harmonics Gain (Av) %}

| Harmonic | f   | Calc (dB) | LTspice (dB) | Measured (dB) |
| -------: | --- | --------: | -----------: | ------------: |
|        1 | fT  |   14.5146 |      14.4586 |       13.3551 |
|        2 | 2fT |    2.7273 |       0.3761 |        2.3803 |
|        3 | 3fT |   -1.7552 |      -1.7665 |       -1.7593 |
|        4 | 4fT |   -4.5723 |      -5.4329 |       -4.4253 |
|        5 | 5fT |   -6.6548 |      -6.6977 |       -6.4363 |
|        6 | 6fT |   -8.3160 |     -11.3166 |       -8.0471 |
|        7 | 7fT |   -9.7015 |      -9.8446 |       -9.3926 |
|        8 | 8fT |  -10.8914 |     -11.5165 |      -10.5499 |
|        9 | 9fT |  -11.9351 |     -11.8794 |      -11.5648 |

{% endtab %}

{% endtabs %}

---

## LTspice (sanity-check simulation)

LTspice was used as a simulation cross-check (AC + transient) against the bench measurements and MATLAB model.

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee319/lab-02/ltspice_schematic.jpg" title="LTspice schematic" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee319/lab-02/ltspice_bode.jpg" title="LTspice AC (Bode)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee319/lab-02/ltspice_transient_schematic.jpg" title="LTspice transient setup" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee319/lab-02/ltspice_transient_vi_vo.jpg" title="LTspice transient (vi and vo)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

---

## Appendix (extra captures)

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="lazy" path="assets/img/ee319/lab-02/scope_10hz.jpg" title="Scope capture at 10 Hz" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="lazy" path="assets/img/ee319/lab-02/scope_100khz.jpg" title="Scope capture at 100 kHz" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

---

## Reproducibility

If you want to reproduce the plots on your own machine:

- MATLAB script: `EE_319_Lab_02_Placzek_fT_1500_Hz.m`
- Measured WaveForms exports: `Measured Data/*.csv`
- LTspice schematics: `LTspice/*.asc` (+ `LM741_Model.txt`)
