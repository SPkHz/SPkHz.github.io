---
layout: page
title: EE-548 Final Design Project 01 — Silicon Photonic Mach–Zehnder Modulator
description: Carrier-depletion silicon MZM in 220 nm SOI (Tidy3D MODE + CHARGE) meeting Vπ, ER, IL, and RC bandwidth specifications.
img: /assets/img/ee548/design-01/mzm_schematic.png
importance: 1
category: coursework
related_publications: false
toc:
  beginning: true
---

**Course:** EE-548 Silicon Photonics  
**Deliverable:** Final Design Project 01 (**2025-12-15**)  
**Topic:** Carrier-depletion **Mach–Zehnder Modulator (MZM)** in a silicon rib waveguide at **λ = 1.55 µm**  
**Tools:** **Tidy3D** (MODE + CHARGE solvers), Python/Jupyter

---

## Project objective and specifications

Design a silicon photonic MZM using a **reverse-biased lateral pn junction** to deplete carriers from the guided mode and induce a voltage-controlled phase shift.

### Target specifications

| Metric                   |  Requirement | Notes                                                      |
| ------------------------ | -----------: | ---------------------------------------------------------- |
| $V_\pi$                  |    $\le 5$ V | evaluated at **IL = 0.5 dB threshold**                     |
| Peak insertion loss (IL) | $\le 0.5$ dB | ON-state optical loss budget                               |
| Extinction ratio (ER)    |  $\ge 20$ dB | $\mathrm{ER}=P_\mathrm{max}-P_\mathrm{min}$ in dB          |
| $f_{\mathrm{3dB}}$       |  $\ge 1$ GHz | **RC-limited** estimate with $R_{\mathrm{sig}}=50\,\Omega$ |

---

## System-level architecture

<div class="row justify-content-sm-center">
  <div class="col-sm-10 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee548/design-01/mzm_schematic.png" title="Mach–Zehnder modulator architecture" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  A <b>2×2 coupler → two arms → 2×2 coupler</b> interferometer. One arm contains a <b>carrier-depletion phase shifter</b> (reverse-biased pn junction), while the other arm serves as a reference.
</div>

The MZI optical output intensity is modeled (including arm loss) as:

$$
|I_\text{out}| = \frac{1}{4}\left| e^{-j\beta_1 L - \frac{\alpha_1}{2}L} + e^{-j\beta_2 L - \frac{\alpha_2}{2}L} \right|^2
$$

where $\beta = k_0\,\Re\{n_{\mathrm{eff}}\}$ and $\alpha$ is derived from $\Im\{n_{\mathrm{eff}}\}$.

---

## Device geometry

**Platform:** 220 nm SOI rib waveguide with 100 nm slab  
**Assigned waveguide width:** 540 nm  
**Metal contact placement:** ≥ 1.0 µm from the optical mode center (used: **1.15 µm**) to suppress metal absorption.

| Parameter               |   Value |
| ----------------------- | ------: |
| Waveguide width         |  540 nm |
| Rib height              |  220 nm |
| Slab thickness          |  100 nm |
| Contact-to-core spacing | 1.15 µm |
| Operating wavelength    | 1.55 µm |

---

## Task 1 — Waveguide mode analysis

The fundamental **TE mode** is solved using the MODE eigenmode solver.

- Extracted effective index: **$n_{\mathrm{eff}} \approx 2.822$**
- Verified that the optical field at the metal interface satisfies **≥ 30 dB attenuation** to avoid significant metal loss.

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee548/design-01/Task_1_Plots.png" title="Task 1 — Fundamental TE mode (linear and dB)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  <b>Left:</b> TE-mode intensity on a linear scale (strong confinement in the rib). <b>Right:</b> dB-scale field map showing >30 dB attenuation at the metal contact locations.
</div>

---

## Task 2 — PN junction and carrier depletion

### Doping strategy

A **symmetric lateral pn junction** is formed across the waveguide core.

| Region             |                      Concentration |
| ------------------ | ---------------------------------: |
| p (Na)             | $1\times10^{17}\ \mathrm{cm^{-3}}$ |
| n (Nd)             | $1\times10^{17}\ \mathrm{cm^{-3}}$ |
| p++ / n++ contacts | $1\times10^{19}\ \mathrm{cm^{-3}}$ |
| Junction offset    |                    0 nm (centered) |

Design intent:

- **Low core doping** ($10^{17}$ cm⁻³) reduces **free-carrier absorption (FCA)** and helps meet the IL constraint.
- A **centered junction** maximizes overlap between the depletion region and the optical mode.

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee548/design-01/Task_2_Doping_Profile.png" title="Task 2 — Doping profile" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  <b>Left:</b> Full device doping map (including heavily doped contacts). <b>Right:</b> Zoom of the waveguide region showing a centered lateral pn junction.
</div>

### Charge solver results

Reverse bias expands the depletion region and **sweeps carriers out of the waveguide core**.

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee548/design-01/electron_density_distribution.png" title="Electron density vs bias" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  Electron density (log scale) at 0 V, 2.5 V, and 5 V reverse bias. The depletion boundary moves laterally with bias.
</div>

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee548/design-01/hole_density_distribution.png" title="Hole density vs bias" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  Hole density (log scale) at 0 V, 2.5 V, and 5 V reverse bias. Symmetric depletion behavior is consistent with a centered junction.
</div>

---

## Task 3 — Voltage-dependent optical response

Carrier depletion changes both:

- the **real part** of $n_{\mathrm{eff}}$ (phase modulation), and
- the **imaginary part** of $n_{\mathrm{eff}}$ (absorption / loss).

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee548/design-01/n_eff_components.png" title="Effective index and loss vs voltage" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  <b>Left:</b> $\Re\{n_{\mathrm{eff}}\}$ increases with reverse bias as carriers are depleted (plasma dispersion). <b>Right:</b> $\Im\{n_{\mathrm{eff}}\}$ decreases as FCA reduces.
</div>

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee548/design-01/Loss_dB_per_cm_vs_voltage.png" title="Propagation loss vs voltage" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee548/design-01/permittivity_change.png" title="Permittivity change visualization" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  Additional views: waveguide propagation loss decreases with bias (lower FCA), and the permittivity perturbation is localized around the depleted junction region.
</div>

---

## Task 4 — Length optimization and performance metrics

### Length selection

A length sweep is used to choose a phase-shifter length that yields strong extinction at 0 V while preserving bandwidth.

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee548/design-01/Length_Sweep.png" title="MZI transmission vs voltage for multiple lengths" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  Transmission response vs voltage for several candidate lengths. Longer phase shifters reduce required voltage for a given phase shift, but increase capacitance and reduce $f_{\mathrm{3dB}}$.
</div>

**Selected phase-shifter length:** **$L = 0.90$ cm**

### Final transmission response

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee548/design-01/Final_Intensity_Plot_with_ER_IL.png" title="Final MZI transmission curve with ER and IL threshold" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  Final MZI transmission curve (selected <b>L = 0.90 cm</b>). The IL threshold is set at <b>−0.5 dB</b>. The measured <b>$V_\pi$</b> is the voltage from the transmission minimum to the IL threshold crossing. ER is the dB difference between peak and minimum.
</div>

### Electrical parasitics and RC bandwidth

The pn junction capacitance per unit length decreases with reverse bias. At the operating point $V=V_\pi/2$, the extracted capacitance is used to estimate the **RC-limited** electrical bandwidth:

$$
C_\text{device} \approx C_j(V_\pi/2)\,L,\qquad
f_{\mathrm{3dB}} \approx \frac{1}{2\pi R_{\mathrm{sig}} C_\text{device}}
$$

<div class="row">
  <div class="col-sm-8 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee548/design-01/capacitance_vs_voltage.png" title="Junction capacitance vs reverse bias" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  Junction capacitance per cm extracted from the CHARGE solver. Capacitance decreases as the depletion width increases.
</div>

---

## Final results and specification compliance

### Summary table

| Parameter                       |      Achieved |     Spec | Pass? |
| ------------------------------- | ------------: | -------: | :---: |
| $V_\pi$ (at IL threshold)       |   **3.952 V** |  ≤ 5.0 V |  ✅   |
| Peak IL                         |  **0.302 dB** | ≤ 0.5 dB |  ✅   |
| ER                              |  **22.69 dB** |  ≥ 20 dB |  ✅   |
| $f_{\mathrm{3dB}}$ (RC-limited) | **2.245 GHz** |  ≥ 1 GHz |  ✅   |

**Derived figure-of-merit:**

- $V_\pi\cdot L = 3.56\ \mathrm{V\cdot cm}$ (single-arm phase shifter, $L=0.90$ cm)

### Operating point used for bandwidth calculation

- $V_\pi/2 = 1.98$ V
- $C_j(V_\pi/2) \approx 1.575\ \mathrm{pF/cm}$
- $C_\text{device} \approx 1.418\ \mathrm{pF}$ (for $L=0.90$ cm)
- $R_{\mathrm{sig}} = 50\,\Omega \Rightarrow f_{\mathrm{3dB}} \approx 2.245$ GHz

---

## Design takeaways

- **Low symmetric doping** ($10^{17}$ cm⁻³) is effective for meeting the IL budget, while still providing sufficient phase shift when paired with a longer phase shifter.
- The chosen **9 mm** device length balances:
  - lower $V_\pi$ (longer device),
  - reduced bandwidth (larger capacitance), and
  - ON-state loss (reduced FCA with depletion).

### Potential improvements

- **Asymmetric doping** or **junction offset optimization** could reduce $V_\pi\cdot L$ while preserving IL.
- A more complete RF model (series resistance, electrode geometry, traveling-wave effects) would refine the $f_{\mathrm{3dB}}$ estimate beyond a lumped RC approximation.

---

## Files and reproducibility

This page is built from the finalized (graded) simulation outputs:

- MODE solver results (TE mode, $n_{\mathrm{eff}}$)
- CHARGE solver results (carrier distributions, capacitance)
- Python/Jupyter post-processing (MZI transfer function, ER/IL/Vπ extraction, RC bandwidth)

If you want this page to link to your notebook/report directly, place your PDFs/notebooks in your repo (e.g., `assets/pdf/ee548/design-01/`) and add links here.
