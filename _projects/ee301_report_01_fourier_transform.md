---
layout: page
title: Fourier Transform Applications within Electrical Engineering
description: Fourier Transform applications across audio, ECG, imaging, SDR spectrum analysis, and vibration diagnostics (MATLAB-based examples).
img: assets/img/ee301/ee301-ft-banner.jpg
importance: 6
category: coursework
giscus_comments: false
---

## Overview

**Course:** EE-301 Signals and Systems
**Project:** Project 01 - Electrical Engineering Applications of the Fourier Transform
**Author:** Steven Placzek
**Date:** 2024-11-27 10:11 AM

This project explores the Fourier Transform as a practical engineering tool: converting time-domain complexity into frequency-domain structure so signals can be analyzed, filtered, and interpreted. The report walks through four application areas, with MATLAB-style examples and supporting figures:

- **Signal analysis** (audio spectra, ECG frequency content + filtering)
- **Image processing** (frequency-domain representations, DCT vs FT context, MRI reconstruction)
- **Software-defined radio** (spectrum/waterfall views, LTE-style spectral content)
- **Mechanical diagnostics** (FFT-based vibration analysis)

---

## 1. Signal Analysis (Audio + ECG)

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee301/fourier_transform_project_01/audio_spectrum.png" title="Audio signal: time vs frequency domain" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee301/fourier_transform_project_01/ecg_time.png" title="ECG signal in time domain" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee301/fourier_transform_project_01/ecg_spectrum_filtered.png" title="ECG spectrum + filtered reconstruction" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  Fourier analysis reveals dominant tones in audio and separates ECG fundamentals from interference/noise, enabling frequency-domain filtering and time-domain reconstruction.
</div>

---

## 2. Image Processing (Compression + MRI Reconstruction)

<div class="row justify-content-sm-center">
  <div class="col-sm-6 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee301/fourier_transform_project_01/image_processing_dct.png" title="Image processing: frequency-domain viewpoint (DCT vs FT context)" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm-6 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee301/fourier_transform_project_01/mri_reconstruction.png" title="MRI reconstruction concept (k-space to image)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  Compression leverages frequency-domain energy compaction (DCT as a close relative), while MRI reconstruction relies on Fourier structure to recover spatial-domain anatomy from frequency-domain measurements.
</div>

---

## 3. Software-Defined Radio (Spectrum + Waterfall)

Fourier tools are the backbone of SDR spectrum visibility: FFT-based displays make RF occupancy measurable (and actionable) in real time.

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee301/fourier_transform_project_01/wifi_spectrum_waterfall.png" title="2.4 GHz band spectrum + waterfall example" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  Waterfall + spectrum views show signal activity over time and frequency, where peaks correspond to transmitters sharing the band.
</div>

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee301/fourier_transform_project_01/lte_downlink_waterfall.png" title="LTE downlink waterfall example" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee301/fourier_transform_project_01/lte_spectrum.png" title="LTE-style spectrum example (MATLAB)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  LTE-style spectral structure can be modeled and visualized using FFT-based analysis, mirroring what real RF receivers compute internally.
</div>

---

## 4. Mechanical Diagnostics (Vibration FFT)

<div class="row justify-content-sm-center">
  <div class="col-sm-8 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee301/fourier_transform_project_01/bridge_fft_code.png" title="Bridge vibration FFT example (MATLAB code excerpt)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  Vibration signals can be decomposed into resonant components; peaks in the spectrum map to forcing terms (wind/traffic) and potential fatigue-related content.
</div>

---

## Files

- Full report PDF (source document): `assets/img/ee301/fourier_transform_project_01/EE_301_FT-Project_01_Placzek.pdf`