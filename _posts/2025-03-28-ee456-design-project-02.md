---
layout: post
title: "EE-456 Design Project 02 Published: 15 GHz LNA Matching (Joint Gain/NF/VSWR Optimization + ADS/MATLAB Cross-Verification)"
date: 2024-03-28 09:24:48-0500
inline: false
related_posts: true
show_on_home: false
---

I’ve published **EE-456 (RF & mm-Wave Active Circuits) — Design Project 02**: a **15 GHz LNA input/output matching design** for the **MGF4941AL InGaAs HEMT** biased at **VDS = 2 V** and **IDS = 10 mA**.

Unlike a max-gain-only match, this project targets the **feasible intersection** of three constraints at **f0 = 15 GHz**:

- **Transducer gain:** \(G_T \ge 12~\text{dB}\)  
- **Noise figure:** \(NF \le 0.6~\text{dB}\)  
- **Input/output match:** \(\text{VSWR} \le 1.5\) (both ports)

---

## Design approach

The workflow starts from the device **S-parameters + noise parameters** at 15 GHz and treats matching as a constrained selection problem on the Smith chart:

- mapped **available gain circles**, **noise-figure circles**, and **stability constraints**
- selected \(\Gamma_S\) and \(\Gamma_L\) from the **overlap region** that satisfies all targets simultaneously
- realized the chosen terminations with **compact single-stub transmission-line networks** (IMN + OMN)

Selected terminations at 15 GHz:

- \(\Gamma_S = 0.4256\angle -136.02^\circ\)  
- \(\Gamma_L = 0.2904\angle +146.09^\circ\)

---

## Verified performance @ 15 GHz

- \(G_T = \mathbf{12.26~dB}\)  
- \(NF = \mathbf{0.580~dB}\)  
- VSWR (IMN) \(= \mathbf{1.50}\)  
- VSWR (OMN) \(= \mathbf{1.39}\)

Matching network electrical lengths (open-stub TL networks):

- **IMN:** \(\theta_{I1}=43.25^\circ\), \(\theta_{I2}=10.42^\circ\)  
- **OMN:** \(\theta_{O1}=31.26^\circ\), \(\theta_{O2}=53.52^\circ\)

---

## Independent toolchain verification

The final design was validated using **two independent flows**:

- **ADS:** full circuit simulation (IMN + device + OMN) across ~14–16 GHz  
- **MATLAB:** Touchstone export + re-plot overlays for gain, NF, VSWR, and S-parameters  

The overlays agree closely, confirming the selected operating point and the matching implementation near 15 GHz.

---

## Repo contents

- Slides (PDF/PPTX) + plots/screenshots used in the deck  
- MATLAB scripts (design + verification)  
- ADS project (schematics + simulations)  
- Excel summary tables (trade-space + final selection)  
- Touchstone files (.s2p) + exported noise data (.csv)

This is an **ideal transmission-line** matching exercise to isolate the gain–NF–match trade-space cleanly. A layout-ready revision would add substrate-backed lines, losses/discontinuities, wideband stability checks, bias network implementation, and EM-aware validation.
