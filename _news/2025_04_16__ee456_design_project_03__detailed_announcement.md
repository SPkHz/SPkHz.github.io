---
layout: post
title: EE-456 Design Project 03 Published: Chebyshev Insertion-Loss Matching for a 10–20 GHz pHEMT Amplifier
date: 2025-04-16 09:08:12-0500
inline: false
related_posts: true
---

I’ve published **EE-456 (RF & mm-Wave Active Circuits) — Design Project 03**: a **wideband 10–20 GHz amplifier** built around the **NEC NE321000 ultra-low-noise pHEMT** (biased at **VDS = 2 V**, **IDS = 10 mA**) using **Chebyshev-polynomial (insertion-loss) matching synthesis**.

The focus here is not a single-frequency conjugate match. It’s **response shaping across a decade-class band**: synthesizing **high-order matching networks** that produce a controlled wideband gain profile while maintaining realizable impedances and predictable behavior.

---

## Design targets

- **Amplifier gain:** ~\(8.15~\text{dB} \pm 0.17~\text{dB}\) across **10–20 GHz**
- **IMN:** **7-element** network synthesized over **9–20 GHz**
  - intentionally **sloped response (~6 dB/octave)** with **0.1 dB Chebyshev ripple**
- **OMN:** **7-element** network synthesized over **9–20 GHz**
  - **non-sloped** response with **0.1 dB ripple**

---

## What was implemented

- Built Chebyshev **insertion-loss polynomial** \(IL(s)\) for the chosen order and ripple
- Performed **ladder extraction** (series/shunt L/C) to obtain element values
- Applied **impedance scaling / transformer-equivalent steps** to land in a practical **50 Ω environment**
- Cascaded the full chain:
  - **IMN → NE321000 (Touchstone) → OMN**
- Verified responses using **two independent toolchains**:
  - **MATLAB:** synthesis + ABCD→S implementation + wideband plots
  - **ADS:** schematic recreation + simulation + Touchstone export for direct overlays

The final MATLAB vs ADS overlays agree extremely closely (reported in the project summary as effectively negligible difference for the compared metrics).

---

## What’s included in the repo

- MATLAB synthesis + verification code (including GPU-accelerated variants for faster sweeps)
- Touchstone files (device + exported networks / full-chain overlays)
- ADS project artifacts (schematic + simulation outputs)
- Tables and figures documenting final element values and performance
