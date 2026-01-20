---
layout: post
title: "Designing a Personalized Audiogram-Driven FIR Filter-Bank for a Virtual Hearing Aid"
date: 2025-04-29 11:48:00-0400
tags: [signal-processing, dsp, fir, filter-bank, audio, audiogram, equalization, matlab]
categories: coursework
thumbnail: assets/img/ee302/design01/design2_combined_response.png
inline: false
related_posts: true
show_on_home: false
---

I’ve published an **EE-302 (Introduction to Digital Signal Processing)** project that designs a **personalized “virtual hearing aid” audio equalizer** using **linear-phase FIR filter banks**.

Given a user **audiogram** (hearing loss vs. frequency), the goal is to synthesize a composite FIR magnitude response that applies **frequency-dependent gain** to counteract the loss—ideally bringing the effective response back toward **0 dB** across **0–10 kHz** at **\(f_s = 20~\text{kHz}\)**.

---

## Core idea: audiogram → compensation target

Audiogram loss points (in dB) are converted into a gain target and smoothed using **PCHIP interpolation**, with small bandwidth padding around each point to avoid sharp transitions. Loss (dB) is mapped to linear gain via:

\[
G*{\text{linear}} = 10^{(\text{Loss}*{dB}/20)}
\]

That target then drives the filter-bank synthesis.

---

## Two FIR filter-bank architectures

### Design 1 — Wideband overlapping bands (fir2, N = 300)

- **8 overlapping FIR bands** spanning 0–10 kHz
- Designed using **frequency-sampling** via `fir2`
- Each band uses a controlled amplitude profile (plateau/triangle) and is scaled by the audiogram-derived gain
- Produces a **smoother overall correction**, at the cost of more filters and higher order

### Design 2 — Center-frequency band-pass bank (fir1, N = 51)

- **5 Hamming-window band-pass FIR filters**
- Designed using `fir1`, centered near key audiogram regions
- Reduced computational load with a more approximate fit to the compensation target

---

## Practical validation: real audio + spectral analysis

The composite FIR responses were applied to real audio (speech/music/noise). Spectral comparisons use **Welch PSD** (Taylor window) to verify that energy is lifted in frequency regions associated with higher hearing-loss compensation targets.

---

## What’s included in the repo

- MATLAB implementations for both architectures:
  - `Design_1_Final.m` (fir2-based bank)
  - `Design_2_Final.m` (fir1-based bank)
- Figures showing:
  - audiogram smoothing and gain target formation
  - individual band responses and combined compensation response
  - Welch spectrum comparisons (before vs after filtering)

---

## Notes

This is a DSP design study—not a medical device. Real hearing aids must address compression, loudness growth, feedback cancellation, latency, and safety limits.
