---
layout: page
title: EE 319 Lab 03 — Bode Plot & Small-Signal Gain
description: Calculated vs LTspice vs Analog Discovery measurements for a diode-biased LM741 amplifier (mid-band gain, cutoff frequencies, and small-signal limits).
img: assets/img/ee319/lab-03/midband-gain.png
importance: 3
category: coursework
---

## Overview

This lab characterizes the frequency response of a diode-biased op-amp amplifier and compares results across three workflows:

- **Calculated:** small-signal (hand) analysis
- **Simulated:** LTspice AC analysis
- **Measured:** Digilent Analog Discovery (Bode tool + scope/FFT)

The primary deliverables were the **mid-band gain**, the **low/high cutoff frequencies** (*f*<sub>L</sub>, *f*<sub>H</sub>), and a **small-signal verification** showing where the diode network begins to introduce nonlinearity.

### Key results at a glance

- **Mid-band gain** (V/V): calculated **-3.8391**, simulated **-3.8563**, measured **-4.2132**
- **Mid-band gain** (dB): calculated **11.6845 dB**, simulated **11.7235 dB**, measured **12.4923 dB**
- **Cutoffs (measured):** *f*<sub>L</sub> ≈ **5.43 Hz**, *f*<sub>H</sub> ≈ **89.46 kHz**

---

## Mid-band gain response

<div class="row justify-content-sm-center">
  <div class="col-sm-10 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee319/lab-03/midband-gain.png" title="Mid-band gain (calculated vs simulated vs measured)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  Bode magnitude showing the mid-band gain plateau and the measured/simulated cutoff markers.
</div>

<div class="row justify-content-sm-center">
  <div class="col-sm-6 mt-3 mt-md-0">
    {% include figure.liquid loading="lazy" path="assets/img/ee319/lab-03/midband-gain-zoom.png" title="Mid-band gain (zoom)" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm-6 mt-3 mt-md-0">
    {% include figure.liquid loading="lazy" path="assets/img/ee319/lab-03/phase-response.png" title="Phase response" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  Left: zoomed magnitude response around the passband. Right: phase response across frequency.
</div>

---

## Circuit under test

<div class="row justify-content-sm-center">
  <div class="col-sm-10 mt-3 mt-md-0">
    {% include figure.liquid loading="lazy" path="assets/img/ee319/lab-03/ltspice-schematic.png" title="LTspice schematic" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  LTspice schematic used for AC analysis (LM741 model), including coupling capacitors and a diode bias network.
</div>

**Nominal component values (from schematic):**

- *R*<sub>sig</sub> = 330 Ω
- *R*<sub>D</sub> = 20 kΩ
- *R*<sub>1</sub> = 1 kΩ
- *R*<sub>2</sub> = 10 kΩ
- *C*<sub>B1</sub> = 100 µF
- *C*<sub>B2</sub> = 100 µF
- Diodes: 1N914 (×3)
- Op-amp: LM741, supplies ±12 V

---

## Simulation vs measurement workflow

### LTspice AC analysis

<div class="row justify-content-sm-center">
  <div class="col-sm-10 mt-3 mt-md-0">
    {% include figure.liquid loading="lazy" path="assets/img/ee319/lab-03/ltspice-bode-plot.png" title="LTspice Bode plot" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  LTspice AC sweep (1 Hz to 1 MHz) used to extract mid-band gain and cutoff frequencies.
</div>

### Analog Discovery measurement

<div class="row justify-content-sm-center">
  <div class="col-sm-5 mt-3 mt-md-0">
    {% include figure.liquid loading="lazy" path="assets/img/ee319/lab-03/analog-discovery-small-signal-note.png" title="Input amplitude selection for small-signal" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm-7 mt-3 mt-md-0">
    {% include figure.liquid loading="lazy" path="assets/img/ee319/lab-03/measured-bode-plot.png" title="Measured Bode plot" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  Input amplitude selection (100 mV) and measured Bode magnitude/phase (1 Hz to 1 MHz).
</div>

---

## Results summary

### Gain and bandwidth metrics

| Metric | Calculated | Simulated (LTspice) | Measured (AD) | Units |
|---|---:|---:|---:|---|
| Mid-band gain, *G*<sub>v(mid)</sub> | -3.8391 | -3.8563 | -4.2132 | V/V |
| Mid-band gain, \|*G*<sub>v(mid)</sub>\| | 11.6845 | 11.7235 | 12.4923 | dB |
| Low cutoff, *f*<sub>L</sub> | — | 3.5456 | 5.4261 | Hz |
| Reference mid-band test frequency, *f*<sub>x</sub> | — | 599.5625 | 872.8567 | Hz |
| High cutoff, *f*<sub>H</sub> | — | 106.0952 | 89.4605 | kHz |
| Bandwidth, BW<sub>f</sub> | — | 106.0917 | 89.4551 | kHz |
| Quality factor, *Q* = *f*<sub>x</sub>/BW<sub>f</sub> | — | 0.0057 | 0.0098 | Hz/Hz |

> **Note on units:** Some source tables label *f*<sub>x</sub> as “kHz”; the values (≈600–873) are treated as **Hz** (consistent with the bandwidth and *Q* values).

<div class="row justify-content-sm-center">
  <div class="col-sm-10 mt-3 mt-md-0">
    {% include figure.liquid loading="lazy" path="assets/img/ee319/lab-03/results-summary.png" title="Calculated, simulated, and measured results (slide table)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  Slide summary table (included as an image for parity with the original report).
</div>

### Percent differences (gain only)

For comparisons, percent difference was computed using the symmetric “average denominator” form:

\[
\%\,\mathrm{diff} = \frac{|a-b|}{\tfrac{|a|+|b|}{2}} \times 100\%
\]

| Comparison | Metric | Diff | % diff |
|---|---|---:|---:|
| Calculated vs Simulated | *G*<sub>v(mid)</sub> (V/V) | 0.0172 | 0.4470% |
| Calculated vs Simulated | \|*G*<sub>v(mid)</sub>\| (dB) | 0.0390 | 0.3332% |
| Calculated vs Measured | *G*<sub>v(mid)</sub> (V/V) | 0.3741 | 9.2918% |
| Calculated vs Measured | \|*G*<sub>v(mid)</sub>\| (dB) | 0.8078 | 6.6824% |

<div class="row justify-content-sm-center">
  <div class="col-sm-10 mt-3 mt-md-0">
    {% include figure.liquid loading="lazy" path="assets/img/ee319/lab-03/excel-percent-differences.png" title="Excel percent difference calculations" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  Excel sheet used to compute differences and percent differences.
</div>

---

## Small-signal verification

Because the circuit includes diodes, the small-signal model is only valid within a region where the diodes stay near their operating point.

A mid-band reference frequency was selected at **f**<sub>x</sub> = **872.8567 Hz** using a **100 mV** input, then the gain was re-measured for frequency multiples/divisions of **f**<sub>x</sub>.

<div class="row justify-content-sm-center">
  <div class="col-sm-12 mt-3 mt-md-0">
    {% include figure.liquid loading="lazy" path="assets/img/ee319/lab-03/small-signal-gain-table.png" title="Finding small-signal gain" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  Gain extracted from measured scope amplitudes across multiples of f\_x, with color-coded regions indicating where the system begins leaving the small-signal regime.
</div>

### Example scope/FFT captures

<div class="row justify-content-sm-center">
  <div class="col-sm-6 mt-3 mt-md-0">
    {% include figure.liquid loading="lazy" path="assets/img/ee319/lab-03/scope-fx-872hz.png" title="Oscilloscope at f_x" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm-6 mt-3 mt-md-0">
    {% include figure.liquid loading="lazy" path="assets/img/ee319/lab-03/spectrum-fx-872hz.png" title="Spectrum at f_x" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  f\_x = 872.8567 Hz: sinusoidal waveforms and a spectrum dominated by the fundamental.
</div>

<div class="row justify-content-sm-center">
  <div class="col-sm-6 mt-3 mt-md-0">
    {% include figure.liquid loading="lazy" path="assets/img/ee319/lab-03/scope-1-32fx-27hz.png" title="Oscilloscope at (1/32) f_x" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm-6 mt-3 mt-md-0">
    {% include figure.liquid loading="lazy" path="assets/img/ee319/lab-03/spectrum-1-32fx-27hz.png" title="Spectrum at (1/32) f_x" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  (1/32)f\_x = 27.2768 Hz: gain begins drifting as the circuit approaches the edge of the small-signal region.
</div>

<div class="row justify-content-sm-center">
  <div class="col-sm-6 mt-3 mt-md-0">
    {% include figure.liquid loading="lazy" path="assets/img/ee319/lab-03/scope-64fx-56khz.png" title="Oscilloscope at 64 f_x" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm-6 mt-3 mt-md-0">
    {% include figure.liquid loading="lazy" path="assets/img/ee319/lab-03/spectrum-64fx-56khz.png" title="Spectrum at 64 f_x" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  64f\_x = 55.8628 kHz: gain drop is consistent with approaching the high-frequency roll-off.
</div>

---

<!-- ## Add to an al-folio site

1. Place this markdown file at: `/_projects/ee319-lab-03.md`
2. Unzip the provided assets into your repo root so the images land at: `assets/img/ee319/lab-03/`

Referenced image files:

- `midband-gain.png`
- `midband-gain-zoom.png`
- `phase-response.png`
- `ltspice-schematic.png`
- `ltspice-bode-plot.png`
- `measured-bode-plot.png`
- `results-summary.png`
- `excel-percent-differences.png`
- `analog-discovery-small-signal-note.png`
- `small-signal-gain-table.png`
- `scope-fx-872hz.png`, `spectrum-fx-872hz.png`
- `scope-1-32fx-27hz.png`, `spectrum-1-32fx-27hz.png`
- `scope-64fx-56khz.png`, `spectrum-64fx-56khz.png` -->
