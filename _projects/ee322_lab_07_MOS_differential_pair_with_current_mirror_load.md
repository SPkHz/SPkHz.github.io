---
layout: page
title: Analysis of the MOS Differential Pair (with a Current Mirror Load)
description: Differential-to-single-ended MOS amplifier using an ALD1105 current-mirror load; DC operating point, differential/common-mode gain, and CMRR (2025-04-08).
img: /assets/img/ee322/lab-07/thumbnail.png
importance: 1
category: coursework
related_publications: true
toc:
  beginning: true
---

**Course:** EE-322 - Electrical Engineering Lab II  
**Lab Date:** 2025-04-08  
**Topic:** MOS differential pair with current-mirror active load (differential → single-ended) and **common-mode rejection ratio (CMRR)**

---

## Overview

This lab characterizes a **MOS differential pair** (\(Q_1, Q_2\)) with a **PMOS current-mirror active load** (\(Q_3, Q_4\)), implemented using the **ALD1105 matched MOSFET array**. The circuit operates as a **differential-to-single-ended amplifier**, where the output \(v_O\) is taken from one side of the differential pair.

Primary goals:

- Measure the **DC operating point** and compare against an LTspice operating-point simulation.
- Measure the **differential-mode gain** \(A_d\), **common-mode gain** \(A_{cm}\), and compute **CMRR**.
- Identify practical non-idealities that reduce gain and CMRR (device mismatch, finite output resistance, finite tail impedance).

**Key measured results (single-ended output):**

- \(A_d\) = **24.161 V/V** (**27.662 dB**)
- \(A_{cm}\) = **0.183 V/V** (**-14.751 dB**)
- **CMRR** = **42.413 dB**

---

## Hardware and tools

- **ALD1105 MOSFET array** (matched NMOS + PMOS pairs)
- **Digilent Analog Discovery Studio** (signal generation + measurement)
- Dual supplies: \(V_{DD}=+12\text{ V}\), \(-V_{SS}=-12\text{ V}\)
- **LTspice** (DC operating point + AC validation)
- **Python / matplotlib** (plotting + post-processing)

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab-07/ald1105_pinout.png" title="ALD1105 pinout and internal device mapping" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  The ALD1105 integrates matched NMOS and PMOS devices. Matching is critical for good current mirroring and high CMRR.
</div>

---

## Circuit configurations

### Common-mode (DC bias and common-mode test)

For the DC operating point and the common-mode measurement, both inputs are set equal (\(v_{I1}=v_{I2}\)). Ideally, the output should not respond to common-mode changes.

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab-07/common_mode_schematic.png" title="Common-mode input configuration" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

### Differential-mode (gain test)

For differential-mode testing, the inputs are driven with equal magnitude and opposite phase:

\[
 v_{I1} = +\frac{v_i}{2},\qquad v_{I2} = -\frac{v_i}{2}
\]

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab-07/differential_mode_schematic.png" title="Differential-mode input configuration" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

---

## Experiment 1 — DC operating point

### Measured tail resistance

The source (“tail”) element used in this lab is a resistor (not an ideal current source).

- \(R_{CS}\) (measured): **9.872 k\(\Omega\)**

### DC summary table

The table below summarizes the operating point used for comparison. (In the graded calculations, the reported \(I_D\) “measured” value is obtained from \(V_{OV}\) using a square-law model with typical parameters, while raw bench currents showed noticeable device mismatch.)

**NMOS differential pair (\(Q_1\), \(Q_2\))**

| Quantity | LTspice (sim) | “Measured” (from \(V_{OV}\) model) | Units |
|---|---:|---:|---|
| \(I_D\) | 514.000 | 540.335 | \(\mu\text{A}\) |
| \(|V_{OV}|\) | 1.267 | 1.365 | V |
| \(V_G\) | 0.000 | 0.000 | V |
| \(V_D\) | 9.010–9.011 | 8.606 | V |
| \(V_S\) | -1.844 | -1.985 | V |

**PMOS current mirror load (\(Q_3\), \(Q_4\))**

| Quantity | LTspice (sim) | “Measured” (from \(V_{OV}\) model) | Units |
|---|---:|---:|---|
| \(I_D\) | 514.000 | 540.335 | \(\mu\text{A}\) |
| \(|V_{OV}|\) | 2.343 | 2.394 | V |
| \(V_G\) | 9.010 | 8.606 | V |
| \(V_D\) | 9.010 | 8.606 | V |
| \(V_S\) | 12.000 | 12.000 | V |

### Device mismatch observation

Even with a “matched” array, measurable mismatch can appear and will directly degrade current mirroring and CMRR.

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab-07/dc_current_mismatch.png" title="DC drain current mismatch (bench observation) vs model-based ID estimate" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  Bench observations showed a clear split between the two sides of the differential pair and mirror. Mismatch and channel-length modulation (finite \(r_o\)) are practical contributors.
</div>

---

## Experiment 2 — AC response and CMRR

### Small-signal relationships used

A current-mirror active load converts differential current to a single-ended output and increases gain relative to a purely resistive load. The following relationships were used to interpret results:

\[
A_{v,d} \approx \frac{2g_{m3}}{g_{o2} + g_{o4} + G_L}
\]

\[
A_{v,cm} \approx \frac{g_{ob}}{2\left(g_{m2} + g_{o4} + G_L\right)}
\]

\[
\mathrm{CMRR} = \left|\frac{A_d}{A_{cm}}\right|,\qquad \mathrm{CMRR}_{dB} = 20\log_{10}\left(\frac{A_d}{A_{cm}}\right)
\]

A finite tail impedance (here, \(R_{CS}\)) and any device mismatch (\(g_{m1}\neq g_{m2}\), \(r_{o3}\neq r_{o4}\), etc.) increases common-mode to differential conversion, which reduces CMRR.

### AC summary (single-ended output)

| Metric | LTspice (sim) | Bench (meas) | Units |
|---|---:|---:|---|
| \(A_d\) | 44.888 | 24.161 | V/V |
| \(A_d\) | 33.040 | 27.662 | dB |
| \(A_{cm}\) | 0.105 | 0.183 | V/V |
| \(A_{cm}\) | -19.591 | -14.751 | dB |
| CMRR | 52.632 | 42.413 | dB |

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab-07/ac_summary_bar.png" title="AC performance: LTspice vs bench" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

### Output waveforms

The plots below show representative single-ended outputs \(v_O\) for differential-mode and common-mode drive. In a well-balanced differential amplifier, the common-mode output swing should be much smaller than the differential-mode output swing.

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab-07/vout_differential_mode.png" title="Output: differential-mode drive" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab-07/vout_common_mode.png" title="Output: common-mode drive" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="caption">
  Differential-mode excitation produces a larger \(v_O\) ripple than common-mode excitation, consistent with a finite but non-zero CMRR.
</div>

---

## Discussion

- **Differential gain decreased vs simulation.** The measured \(A_d\) (24.161 V/V) is below LTspice (44.888 V/V). Likely contributors include **finite output resistance** (channel-length modulation), load/scope effects, and imperfect biasing.
- **Common-mode gain increased vs simulation.** Measured \(A_{cm}\) is higher than simulated, which directly reduces CMRR.
- **CMRR degraded vs simulation.** The measured CMRR of **42.413 dB** (vs 52.632 dB simulated) is consistent with:
  - **Mismatch** in the NMOS pair and/or the PMOS mirror
  - **Finite tail impedance** (\(R_{CS}\) is a resistor, not an ideal current source)
  - Non-ideal current mirroring and finite \(r_o\) in the active load

---

## Reproducibility notes

- Use measured component values (especially \(R_{CS}\)) in LTspice when comparing against the bench.
- When computing CMRR in dB from measured gains:

```text
CMRR_dB = 20*log10(Ad/Acm)
```

- The plots on this page were generated using Python/matplotlib (no handwritten figures).

---

## References

1. A. Rajesh and D. B. L. Raju, “Design of a differential amplifier using current mirror as active load,” *International Journal of Engineering Research and General Science*, vol. 2, no. 6, pp. 43–47, 2014.
2. C. Fonstad, “Two active loads for differential amplifiers: The lee load and the current mirror load,” MIT OCW (6.012), 2009 (accessed 2025-04-04).
3. G. S. Deo, J. A. Totlani, K. E. Mamidi, and C. V. Mahamuni, “Performance analysis of BiMOS differential pair with active load…,” *2020 4th ICICCS*, IEEE, 2020.
4. B. Razavi, lecture notes on single-ended and differential operation, common-mode response, and MOS differential pairs.
5. S. Palermo, “Lab 6: Differential pair characterization,” Texas A&M University (accessed 2025-03-31).
6. M. Shashmi, “Lecture 16: CMOS amplifiers,” IIIT Delhi (accessed 2025-04-04).
