---

layout: page
title: "EE Lab II<br/>Spring 2025<br/>Lab<br/>Portfolio<br/>"
description: MOSFET characterization → amplifier design → differential pairs → VNA S-parameter de-embedding (LTspice • Python • LaTeX).
img: /assets/img/ee322/hero/Lab_05_Bode_Sim_Vs_Meas_Gain_Phase.png
category: coursework
giscus_comments: false
toc: true
importance: 4
related_publications: true
tags:
  - ee322 portfolio
  - mosfet characterization
  - amplifier design
  - differential pair
  - vna
  - s-parameters
  - de-embedding
  - ltspice
  - python
_styles: |
  .post article .mjx-container[display="true"] {
    font-size: 1.3em;
    margin: 0.9em 0 1.1em;
  }
  .post article .mjx-container {
    font-size: 1.12em;
  }
---

This project is my **EE-322 (Electrical Engineering Lab II)** final portfolio: a full arc from **device-level MOSFET characterization** to **analog amplifier design**, **differential signaling + CMRR**, and **RF measurement workflows** using **S-parameters** and **de-embedding**.

**Course:** EE-322 — Electrical Engineering Lab II (WNEU)  
**Author:** Steven Placzek  
**Tools:** Analog Discovery Studio, LTspice, Python (NumPy/Pandas/Matplotlib), LaTeX, VNA (S-parameters)  
**Core themes:** measurement vs simulation, biasing, small-signal gain, frequency response (Bode), feedback, differential operation, de-embedding

---

## Quick Links

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    <a class="btn btn-outline-primary btn-sm" href="https://spkhz.github.io/EE-322-Electrical-Engineering-Lab-II--Final-Portfolio/" target="_blank" rel="noopener">Interactive Viewer</a>
    <a class="btn btn-outline-secondary btn-sm" href="/assets/pdf/ee322/EE_322_Final_Lab_Portfolio_Placzek.pdf" target="_blank" rel="noopener">Download PDF</a>
    <a class="btn btn-outline-dark btn-sm" href="https://github.com/spkhz/EE-322-Electrical-Engineering-Lab-II--Final-Portfolio" target="_blank" rel="noopener">Source Repo</a>
  </div>
</div>

> **Note:** Update the GitHub link if your repo name/username differs.  
> For the PDF button to work, place the PDF at: `assets/pdf/ee322/EE_322_Final_Lab_Portfolio_Placzek.pdf`

---

## Skills Demonstrated

- **MOSFET characterization:** extracting trends from sweeps; connecting measured curves to device behavior
- **Biasing + operating point:** targeting stable DC operating conditions, validating with simulation
- **Small-signal thinking:** relating measured frequency response to gain/bandwidth tradeoffs
- **Negative feedback:** stabilizing bias and gain, and observing bandwidth expansion
- **Differential circuits:** differential vs common-mode response, **CMRR** as a performance metric
- **Active loads + current mirrors:** converting differential to single-ended while improving gain
- **RF measurement workflow:** VNA fundamentals, interpreting **S11/S21**, fixture effects, **de-embedding**
- **Reproducible analysis:** Python scripts generating tables/plots; LaTeX for clean technical reporting

---

## Portfolio Contents

| Lab | Topic | What it Proves |
|---:|---|---|
| 01 | NMOS characterization | Device behavior from sweeps; grounding “models” in data |
| 02 | IC biasing techniques | Bias strategies + simulation/measurement cross-checks |
| 03 | Actively-loaded common-source amplifier | Gain creation with active loads; early frequency behavior |
| 04 | Common-source frequency response | Practical Bode measurement; added caps to emulate parasitics |
| 05 | Feedback amplifier | Bias stabilization + gain/bandwidth tradeoff under feedback |
| 06 | MOS differential pair | Differential vs single-ended operation; CMRR measurement workflow |
| 07 | Differential pair + current mirror load | Differential-to-single-ended stage; mismatch sensitivity; CMRR |
| 08 | VNA + de-embedding (LPF/HPF) | S-parameters, fixture removal via **Open/Short/Thru**, corrected DUT response |

---

## Highlights by Lab

### Lab 01 — NMOS Characterization (Device-Level Ground Truth)
Goal: measure NMOS behavior directly and connect the observed curves to thresholding, conduction regions, and sensitivity to bias.

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab01/Lab_01_1_3.png" title="NMOS sweep results (representative plots)" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
</div>

<div class="caption">
  Representative Lab 01 output plots from measurement sweeps. (Copy from your portfolio repo into <code>assets/img/ee322/lab01/</code>.)
</div>

---

### Lab 03 — Actively-Loaded Common-Source Amplifier (Gain + Load Strategy)
Goal: implement an actively-loaded common-source amplifier and evaluate gain behavior and frequency response.

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab03/Lab_03_Bode_Plot.png" title="Actively-loaded CS amplifier — Bode plot" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
</div>

<div class="caption">
  Measured/simulated frequency response for the actively-loaded common-source stage.
</div>

---

### Lab 04 — Common-Source Frequency Response (Measured Bode Reality)
Goal: measure the **mid-band gain**, cutoff frequencies, and bandwidth; compare against LTspice.
Because intrinsic device capacitances can be too small to observe cleanly with lab equipment, **discrete capacitors** were added to mimic parasitic behavior and force measurable poles.

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab04/Lab_04_Sim_vs_Meas.png" title="Common-source amplifier — simulation vs measurement" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
</div>

---

### Lab 05 — Feedback Amplifier (Stability + Bandwidth Tradeoff)
Goal: apply **negative feedback** to stabilize DC bias and make gain less device-dependent.

A standard outcome shows up clearly:

- Feedback **reduces gain** (often)  
- Feedback **increases bandwidth** (often)  
- Gain becomes more dependent on the feedback network than raw device variation

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab05/Lab_05_Bode_Sim_Vs_Meas_Gain_Phase.png" title="Feedback amplifier — Bode gain/phase (sim vs meas)" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
</div>

<div class="caption">
  Feedback reshapes the frequency response: the “more stable, wider, less peaky” signature shows up in the Bode curves.
</div>

---

### Lab 06 — MOS Differential Pair (Differential vs Common-Mode)
Goal: quantify differential operation and noise rejection using **CMRR**.

Key metric:

\[
\mathrm{CMRR} = \left|\frac{A_d}{A_{cm}}\right|, \qquad \mathrm{CMRR_{dB}} = 20\log_{10}(\mathrm{CMRR})
\]

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab06/Lab-06-LTSpice-Plot.png" title="Differential pair — simulation support plot" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
</div>

---

### Lab 07 — Differential Pair + Current Mirror Load (Diff → Single-Ended Stage)
Goal: build a differential pair with an **active (current mirror) load** to convert differential current into a single-ended voltage output, and evaluate **CMRR** and mismatch sensitivity.

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab07/Lab_07_CM_vs_Diff_Plot.png" title="Common-mode vs differential behavior (representative plot)" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
</div>

---

### Lab 08 — VNA + De-embedding (LPF/HPF S-Parameters)
Goal: measure LPF/HPF responses using a **VNA**, interpret **S-parameters**, and remove fixture influence via **de-embedding** (Open/Short/Thru).

What changes after de-embedding:
- The DUT response becomes less “polluted” by fixture resonances/parasitics
- Stopband artifacts and weird notches often clean up
- Passband behavior aligns better with the expected filter topology

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab08/Lab_08_lpf_deembedded_comparison.png" title="LPF S21 — before vs after de-embedding" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/ee322/lab08/Lab_08_hpf_deembedded_comparison.png" title="HPF S21 — before vs after de-embedding" class="img-fluid rounded z-depth-1" zoomable=true %}
  </div>
</div>

---

## Full PDF (Embedded Preview)

If you want the entire document visible directly on this page, put the PDF at:
`assets/pdf/ee322/EE_322_Final_Lab_Portfolio_Placzek.pdf` and keep the embed below.

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    <iframe
      src="/assets/pdf/ee322/EE_322_Final_Lab_Portfolio_Placzek.pdf"
      width="100%"
      height="950"
      style="border: 1px solid rgba(0,0,0,0.15); border-radius: 8px;"
      loading="lazy">
    </iframe>
  </div>
</div>

---

## Reproducibility (Where the Work Lives)

Follow this link to visit the <a href="https://github.com/SPkHz/EE-322-Electrical-Engineering-Lab-II--Final-Portfolio">EE-322 - Electrical Engineering Lab II: Final Lab Portfolio Public Repository</a>, all of the analysis scripts will be kept public so that all the plots and tables from each lab will remain auditable.

This portfolio is built from:
- **LaTeX source:** `main.tex` + per-lab chapter files (`Chapter_*/*.tex`)
- **Python analysis scripts:** `Appendix/Python_Code/*.py`
- **S-parameter data:** `Chapter_8/sparam_files/*.s2p`

---
<!-->
## Suggested Asset Layout for Your al-folio Repo

Copy selected images + the PDF into your al-folio site using a predictable structure:

- `assets/pdf/ee322/EE_322_Final_Lab_Portfolio_Placzek.pdf`
- `assets/img/ee322/hero/Lab_05_Bode_Sim_Vs_Meas_Gain_Phase.png`
- `assets/img/ee322/lab01/...`
- `assets/img/ee322/lab03/...`
- `assets/img/ee322/lab04/...`
- `assets/img/ee322/lab05/...`
- `assets/img/ee322/lab06/...`
- `assets/img/ee322/lab07/...`
- `assets/img/ee322/lab08/...`

Once the assets exist at those paths, every figure include above will render without further edits.
</--!>
