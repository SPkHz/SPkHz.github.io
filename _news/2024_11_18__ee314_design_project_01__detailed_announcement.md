---
layout: post
title: EE-314 Final Project Published: GHz Transmission-Line Matching Networks (ADS + Microstrip Layout)
date: 2024-11-18 09:00:00-0500
inline: false
related_posts: true
---

I’ve published my **EE-314 (Electromagnetic Fields and Waves)** final design project: **Millimeter-Wave Impedance Matching Network Designs**.

This project implements and verifies **two canonical transmission-line impedance matching topologies** in **Keysight ADS**—first as **ideal TL models**, then as **realistic microstrip implementations** using a defined substrate stackup and **layout-level validation**.

---

## Scope

Two matching network families were designed for a GHz-range target and evaluated over a wideband sweep (on the order of a **3.5–4.5 GHz** span in the provided schematics):

1. **Single shunt-stub matching**
   - Multiple valid Smith-chart solutions (alternative stub types and placements)
   - Implemented with **open-circuit** and **short-circuit** stub variants
2. **Quarter-wave transformer (λ/4) matching**
   - Implemented using standard impedance-transformer synthesis
   - Includes **short/long electrical-length** alternatives

---

## Methodology and verification

- **Smith chart synthesis**
  - Determined required electrical lengths and characteristic impedances to achieve target match
- **S-parameter simulation in ADS**
  - Verified input match/return loss behavior across frequency for each topology
- **Microstrip realization**
  - Converted TL electrical parameters into physical microstrip dimensions using the given substrate definition
- **Layout verification**
  - Confirmed realizable geometry, correct connectivity, and consistent port definitions
  - Re-simulated the physical implementation to compare against the ideal TL baseline (capturing loss/dispersion effects)

---

## Repository contents

- Final submitted report (PDF)
- ADS workspaces (ideal TL + microstrip + layout)
- Exported schematics, plots, and layout screenshots
- Smith-chart scans and handwritten derivations
