---
layout: page
title: "EE-322 Lab 05 — Frequency Response of a Common-Source Amplifier with Feedback"
description: "Measured Bode magnitude/phase, −3 dB bandwidth, and gain-bandwidth product for a drain-to-gate feedback common-source MOSFET amplifier (ALD1105)."
img: /assets/img/ee322/lab-05/cover.png
importance: 5
category: coursework
related_publications: false
toc:
  sidebar: right
---

**Course:** EE-322 — Electrical Engineering Lab II  \
**Lab Date:** 2025-03-18  \
**Topic:** Negative feedback applied to a common-source MOSFET amplifier; frequency-response measurement and comparison to an ideal feedback gain.

---

## Objectives

1. Modify the common-source amplifier (from Lab 04) by adding **drain-to-gate negative feedback**.
2. Adjust the bias network so the circuit operates at the specified DC current (handout target: **$I_{Total}=1\,\mathrm{mA}$**).
3. Measure the amplifier’s frequency response and extract:
   - midband gain $|G_v(\mathrm{mid})|$
   - cutoff frequencies $f_L$, $f_H$
   - bandwidth $BW$
   - gain-bandwidth product $GBP$

---

## Circuit

<div class="row">
  <div class="col-sm-8 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab-05/circuit_schematic.png" title="Lab 05 circuit: common-source amplifier with drain-to-gate feedback" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm-4 mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab-05/ald1105_pinout.png" title="ALD1105 pinout and internal device mapping" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
  The feedback resistor <code>R<sub>F</sub></code> returns a portion of the output voltage to the MOSFET gate node, implementing negative feedback.
</div>

### Key parameters

| Parameter | Value |
|---|---:|
| $V_{DD}$ | 10 V |
| $R_F$ | 330 kΩ |
| $R_{sig}$ | 100 kΩ |
| $R$ (potentiometer) | 25 kΩ |
| $R_L$ (probe) | 10 MΩ |
| $C_B$ | 0.022 µF |
| $C_1$ | 10 pF |
| $C_2$ | 3.3 pF |
| $C_3$ (probe) | 22 pF + 15 pF |
| $C_4$ | 3.3 pF |
| $C_5$ | 22 pF |

---

## Measurement workflow

### DC operating point

Per the handout, the potentiometer was adjusted to set the total current to approximately **1 mA**, then node voltages/currents were recorded.

### AC / frequency-response measurement

- Instrument method: oscilloscope frequency-response / Bode function (input on **C1**, output on **C2**).
- Sweep range (exported dataset): **10 Hz → 1 MHz**.
- Input amplitude in the exported dataset: **100 mVpp**.

---

## Data processing

### Phase correction

The oscilloscope export reports phase in a **0° to 360°** format. For standard Bode interpretation of an inverting amplifier (phase near **−180°** in the midband), the plotted phase was shifted by **−360°**:

$$
\phi_{plot}(f)=\phi_{export}(f)-360^\circ
$$

### −3 dB cutoffs

- Midband gain $|G_v(\mathrm{mid})|$ was computed as the **average gain from 1 kHz to 10 kHz**.
- The −3 dB cutoff frequencies were found by interpolating the gain crossings of:

$$
G_{dB}(f)=G_{dB}(\mathrm{mid})-3\,\mathrm{dB}
$$

---

## Results

### Measured magnitude and phase

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab-05/bode_gain_phase_measured.png" title="Measured Bode magnitude and phase (phase shifted by −360°)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="lazy" path="assets/img/ee322/lab-05/bode_gain_measured.png" title="Measured Bode magnitude with midband, −3 dB level, and ideal feedback-gain reference" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="lazy" path="assets/img/ee322/lab-05/bode_phase_measured.png" title="Measured Bode phase (shifted by −360°) with −180° reference" class="img-fluid rounded z-depth-1" %}
  </div>
</div>

### Extracted metrics (measured)

| Quantity | Measured value |
|---|---:|
| $|G_v(\mathrm{mid})|$ (V/V) | 3.05 V/V |
| $|G_v(\mathrm{mid})|$ (dB) | 9.67 dB |
| $f_L$ | 79.8 Hz |
| $f_H$ | 71.8 kHz |
| $BW = f_H - f_L$ | 71.7 kHz |
| $GBP = |G_v(\mathrm{mid})| \cdot BW$ | 218 kHz |

---

## Discussion

### Feedback-set gain (ideal expectation)

With drain-to-gate feedback and a large gate impedance, the closed-loop midband gain is approximately set by the resistor ratio:

$$
|G_v| \approx \frac{R_F}{R_{sig}}
$$

Using $R_F = 330\,\mathrm{k\Omega}$ and $R_{sig}=100\,\mathrm{k\Omega}$:

$$
|G_v|_{ideal} = 3.3\;\mathrm{V/V} \;\Rightarrow\; 20\log_{10}(3.3)=10.37\,\mathrm{dB}
$$

The measured midband gain (9.67 dB) is slightly lower than this ideal estimate, which is consistent with:

- finite open-loop gain of the MOSFET stage,
- device variation and bias-point sensitivity,
- loading and parasitic capacitances (including the probe model capacitance in the handout).

### Bandwidth and phase behavior

- The response is effectively **band-pass** over the sweep range: low-frequency rise (coupling/bypass caps), midband plateau, and high-frequency roll-off.
- The midband phase is near **−180°**, consistent with an **inverting** common-source stage.

---

## Files

All figures and supporting files are intended to live under:

- `assets/img/ee322/lab-05/`

Included in the provided asset pack:

- Plots (generated from the exported CSV):
  - `bode_gain_measured.png`
  - `bode_phase_measured.png`
  - `bode_gain_phase_measured.png`
- Circuit / device figures:
  - `circuit_schematic.png`
  - `ald1105_pinout.png`
- Raw data:
  - `data/Lab_05_Bode_Phase.CSV`
  - `data/Lab_05_WFM02.CSV`
  - `data/LAB5IM01.CSV`
- PDFs:
  - `docs/EE322_Lab_5.pdf` (handout)
  - `docs/EE322_Lab_5_with_Bode.pdf` (notebook copy with plots)

---

## Reproducibility notes

If re-processing the Bode export in Python, the main steps are:

1. Load the CSV.
2. Compute midband gain from a flat region (here: 1–10 kHz).
3. Interpolate the −3 dB crossings for $f_L$ and $f_H$.
4. Shift phase by −360° (or unwrap) if the instrument exports phase in 0–360°.

<details>
  <summary><b>Minimal Python snippet</b> (click to expand)</summary>

```python
import pandas as pd
import numpy as np

df = pd.read_csv("Lab_05_Bode_Phase.CSV")
f = df["Frequency in Hz"].to_numpy()
g_db = df["Gain in dB"].to_numpy()
phase = df["Phase in °"].to_numpy() - 360  # phase correction

# midband (example): average 1 kHz to 10 kHz
mid_mask = (f >= 1e3) & (f <= 1e4)
mid_db = g_db[mid_mask].mean()
lvl = mid_db - 3

# find -3 dB crossings and linearly interpolate
idx_l = np.where(g_db >= lvl)[0][0]
fl = np.interp(lvl, [g_db[idx_l-1], g_db[idx_l]], [f[idx_l-1], f[idx_l]])

idx_r = np.where(g_db >= lvl)[0][-1]
fh = np.interp(lvl, [g_db[idx_r], g_db[idx_r+1]], [f[idx_r], f[idx_r+1]])

bw = fh - fl
mid_vv = 10**(mid_db/20)
gbp = mid_vv * bw
```

</details>
