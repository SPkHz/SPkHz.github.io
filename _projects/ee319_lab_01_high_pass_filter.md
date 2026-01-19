---

layout: page
title: High-Pass Filter Measurement Techniques
description: First-order RC high-pass filter characterization (theory vs. LTspice vs. WaveForms measurements) with MATLAB Bode magnitude/phase plots.
img: /assets/img/ee319/lab-01/hpf/thumbnail.jpg
category: coursework
date: 2024-09-04 00:00:00-0400
giscus_comments: false
pretty_table: true
images:
  slider: true
importance: 19683917889536129
related_publications: true
tags:
  - rc high-pass
  - first-order filter
  - bode magnitude
  - phase response
  - ltspice
  - waveforms
  - matlab
_styles: |
  /* Slightly larger MathJax without blowing up inline math */
  .post article .mjx-container[display="true"] {
    font-size: 1.28em;
    margin: 0.85em 0 1.05em;
  }
  .post article .mjx-container {
    font-size: 1.10em;
  }
---

## Overview

**Course:** EE-319 — EE Lab I (WNEU ECE)  
**Lab:** #01 — HPF Measurements  
**Tools:** Digilent WaveForms (Bode + Scope), LTspice, MATLAB  

This lab builds and measures a **first-order high-pass filter** and compares:
- **Calculated** transfer-function expectations
- **LTspice** AC simulation
- **Measured** frequency response (10 Hz → 100 kHz) and time-domain spot checks  

(Full lab report: [`EE_319_Lab01_HPF_Report.pdf`](assets/img/ee319/lab-01/hpf/EE_319_Lab01_HPF_Report.pdf))

---

## Circuit

Component values (per lab spec):
- $$R_1 = 10~\text{k}\Omega$$
- $$R_2 = 10~\text{k}\Omega$$
- $$C_2 = 56~\text{nF}$$

<div class="row justify-content-sm-center">
  <div class="col-sm-10 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee319/lab-01/hpf/hpf_schematic.png" title="High-pass filter schematic (R1=10 kΩ, C2=56 nF, R2=10 kΩ)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

### Transfer function (compact form)

With output taken across $$R_2$$, the filter reduces to a standard 1st-order HPF:

$$
H(s)=\frac{V_o}{V_i}=\frac{s C_2 R_2}{1+sC_2(R_1+R_2)}
$$

Key metrics:
- High-frequency gain:
$$
A_{v(\text{HF})}=\lim_{\omega\to\infty}|H(j\omega)|=\frac{R_2}{R_1+R_2}=0.5 \Rightarrow -6.02~\text{dB}
$$
- Corner (3 dB) frequency:
$$
f_L=\frac{1}{2\pi C_2 (R_1+R_2)}\approx 142.1~\text{Hz}
$$

---

## Measurement workflow

1. Build the circuit on the bench.  
2. Run WaveForms Bode Analyzer sweep: **10 Hz → 100 kHz** and export CSV.  
3. Plot in MATLAB:
   - Magnitude $$20\log_{10}(|A_v(f)|)$$ (target display: **-30 to -5 dB**)
   - Phase $$\theta(f)$$ (target display: **0° to +90°**)  
4. Extract:
   - $$A_{v(\text{HF})}$$ (linear and dB)
   - $$f_L$$ (measured -3 dB point relative to HF gain)  
5. Capture time-domain scope traces at:
   - $$f=f_L$$
   - $$f=100~\text{kHz}$$
   - $$f=10~\text{Hz}$$

---

## Results

### Measured Bode sweep (WaveForms)

<div class="row justify-content-sm-center">
  <div class="col-sm-12 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee319/lab-01/hpf/bode_measured_waveforms.png" title="WaveForms measured Bode response (10 Hz → 100 kHz)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

### Magnitude: LTspice vs measured (MATLAB)

<div class="row justify-content-sm-center">
  <div class="col-sm-12 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee319/lab-01/hpf/bode_magnitude_sim_vs_meas.jpg" title="Magnitude response: simulated vs measured" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

### Phase: measured (MATLAB)

<div class="row justify-content-sm-center">
  <div class="col-sm-12 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee319/lab-01/hpf/bode_phase_measured.jpg" title="Measured phase response" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

---

## Key parameters

| Parameter | Calculated | Simulated | Measured |
|---|---:|---:|---:|
| $$A_{v(\text{HF})}$$ (mV/V) | 500.0000 | 499.9995 | 496.4600 |
| $$A_{v(\text{HF})}$$ (dB) | -6.0206 | -6.0206 | -6.0823 |
| $$f_L$$ (Hz) | 142.1026 | 142.1023 | 136.8137 |

<div class="row justify-content-sm-center">
  <div class="col-sm-10 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee319/lab-01/hpf/table_hpf_1.png" title="Table HPF-1: calculated vs simulated vs measured" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

### Comparison tables (bench-check)

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee319/lab-01/hpf/table_calc_vs_sim.jpg" title="Calculated vs simulated comparison" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee319/lab-01/hpf/table_calc_vs_meas.jpg" title="Calculated vs measured comparison" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

---

## Time-domain spot checks

### At $$f=f_L \approx 136.8~\text{Hz}$$
Near the corner frequency, the output magnitude is ~3 dB below the HF gain point and the phase is near 45°.

{% include figure.liquid loading="eager" path="assets/img/ee319/lab-01/hpf/scope_fl_136hz.png" title="Scope capture at f = fL" class="img-fluid rounded z-depth-1" %}

### At $$f=100~\text{kHz}$$
Well above $$f_L$$, the capacitor is effectively a short: $$V_o \approx 0.5V_i$$ and phase is near 0°.

{% include figure.liquid loading="eager" path="assets/img/ee319/lab-01/hpf/scope_100khz.png" title="Scope capture at f = 100 kHz" class="img-fluid rounded z-depth-1" %}

### At $$f=10~\text{Hz}$$
Well below $$f_L$$, the capacitor blocks the signal: strong attenuation and phase lead.

{% include figure.liquid loading="eager" path="assets/img/ee319/lab-01/hpf/scope_10hz.png" title="Scope capture at f = 10 Hz" class="img-fluid rounded z-depth-1" %}

---

## Downloads / reproducibility

- **Report PDF:** [`EE_319_Lab01_HPF_Report.pdf`](assets/img/ee319/lab-01/hpf/EE_319_Lab01_HPF_Report.pdf)  
- **Source bundle (MATLAB + LTspice + measured data):** [`EE_319_Lab01_HPF_Source.zip`](assets/img/ee319/lab-01/hpf/EE_319_Lab01_HPF_Source.zip)

Contents of the source bundle include:
- MATLAB script (`EE_319_Lab_01_HPF_Placzek.m`)
- LTspice schematics (`*.asc`)
- WaveForms projects (`*.dwf3work`)
- Measurement exports (`*.csv`)
