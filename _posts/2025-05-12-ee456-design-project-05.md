---
layout: post
title: "EE-456 Design Project 05 Published: 8 GHz Negative-Resistance Oscillator Using ATF-33143 GaAs pHEMT"
date: 2025-05-08 23:46:00-0500
inline: false
related_posts: true
show_on_home: false
tags: RF microwave oscillator GaAs pHEMT
categories: coursework
---

I've published **EE-456 (RF & mm-Wave Active Circuits) — Design Project 05**: an **8 GHz negative-resistance oscillator** built around the **Avago ATF-33143 GaAs pHEMT** (biased at $$V_{DS} = 4\ \text{V}$$, $$I_{DS} = 80\ \text{mA}$$) using **common-gate topology with inductive gate feedback**.

---

## Design Overview

The focus is **oscillator synthesis via S-parameter manipulation**: converting the device to common-gate configuration, introducing deliberate instability through feedback, and designing transmission-line termination/resonator networks to satisfy the oscillation conditions.

**Key design targets:**
- Oscillation frequency: 8 GHz
- Optimize gate reactance $$X_B$$ to maximize $$\lvert S_{11}\rvert$$
- Synthesize termination network for target $$\Gamma_T = 0.5000 \angle 162.019°$$
- Synthesize resonator network for target $$\Gamma_R = 0.7500 \angle -127.733°$$
- Verify $$\lvert\Gamma_{\text{in}} \cdot \Gamma_R\rvert > 1$$ with proper phase alignment

---

## Core Results

**Optimum feedback reactance:**

$$
X_{B,\text{opt}} = +130\ \Omega \quad \Rightarrow \quad L_B = 2.586\ \text{nH}
$$

**Verification with termination attached:**

$$
\Gamma_{\text{in}} = 0.8403 \angle -17.172°, \quad Z_{\text{in}} = 146.305\ \Omega
$$

The indefinite admittance matrix technique cleanly converts between device configurations, while parametric sweeps over feedback reactance reveal optimal operating points for maximum instability.

---

## What's Included

- MATLAB synthesis/verification scripts
- Touchstone files for ATF-33143
- Contour plots showing $$\Gamma_T$$ over the design space

{% include figure.liquid loading="eager" path="assets/img/ee456/design05/gammaT_contours.png" class="img-fluid rounded z-depth-1" caption="Phase contours of ΓT over the (θs, θp) design space for the termination network." %}

See the [full project page](/projects/ee456_design05/) for detailed derivations, S-parameter tables, and network synthesis steps.