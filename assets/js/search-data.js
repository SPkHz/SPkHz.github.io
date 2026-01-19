// get the ninja-keys element
const ninja = document.querySelector('ninja-keys');

// add the home and posts menu items
ninja.data = [{
    id: "nav-about",
    title: "About",
    section: "Navigation",
    handler: () => {
      window.location.href = "/";
    },
  },{id: "nav-blog",
          title: "blog",
          description: "",
          section: "Navigation",
          handler: () => {
            window.location.href = "/blog/";
          },
        },{id: "nav-projects",
          title: "projects",
          description: "A growing collection of all of my electrical engineering design projects and coursework.",
          section: "Navigation",
          handler: () => {
            window.location.href = "/projects/";
          },
        },{id: "nav-repositories",
          title: "repositories",
          description: "Edit the `_data/repositories.yml` and change the `github_users` and `github_repos` lists to include your own GitHub profile and repositories.",
          section: "Navigation",
          handler: () => {
            window.location.href = "/repositories/";
          },
        },{id: "nav-resume",
          title: "resume",
          description: "This is a description of the page. You can modify it in &#39;_pages/cv.md&#39;. You can also change or remove the top pdf download button.",
          section: "Navigation",
          handler: () => {
            window.location.href = "/cv/";
          },
        },{id: "post-",
        
          title: "",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2026/2025-04-28-ee456-design-04-detailed-announcement/";
          
        },
      },{id: "post-designing-an-8-ghz-negative-resistance-oscillator-with-an-atf-33143-gaas-phemt",
        
          title: "Designing an 8 GHz Negative-Resistance Oscillator with an ATF-33143 GaAs pHEMT",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2025/ee456-design-project-05/";
          
        },
      },{id: "post-optimized-silicon-solar-cell-design",
        
          title: "Optimized Silicon Solar Cell Design",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2025/ee212-design-01-optimized-solar-cell-detailed-announcement/";
          
        },
      },{id: "post-eelab-ii-final-lab-portfolio",
        
          title: "eeLab II — Final Lab Portfolio",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2025/ee322-final-lab-portfolio-detailed-announcement/";
          
        },
      },{id: "post-ee-336-single-phase-h-bridge-inverter-analysis",
        
          title: "EE-336 Single-Phase H-Bridge Inverter Analysis",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2025/ee336-week-14-h-bridge-inverter-analysis-detailed-announcement/";
          
        },
      },{id: "post-designing-a-personalized-audiogram-driven-fir-filter-bank-for-a-virtual-hearing-aid",
        
          title: "Designing a Personalized Audiogram-Driven FIR Filter-Bank for a Virtual Hearing Aid",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2025/ee302-design-project-01/";
          
        },
      },{id: "post-fir-filter-bank-for-hearing-aid-audio-response",
        
          title: "FIR Filter-Bank for Hearing Aid Audio Response",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2025/ee302-design-01-fir-filterbank-for-hearing-aid-detailed-announcement/";
          
        },
      },{id: "post-discrete-time-control-for-receiver-positioning-and-satellite-tracking",
        
          title: "Discrete-Time Control for Receiver Positioning and Satellite Tracking",
        
        description: "Discrete-time state-space controller (pole placement) for a servo-driven receiver positioning system. Validated in MATLAB/Simulink across multiple sampling rates.",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2025/ee470-design-project-01/";
          
        },
      },{id: "post-discrete-time-control-system-design-for-a-satellite-receiver-servo-motor-actuator-achieving-accurate-satellite-sky-tracking",
        
          title: "Discrete-Time Control System Design for a Satellite Receiver Servo-motor Actuator achieving Accurate Satellite-Sky...",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2025/ee470-design-01-servomotor-control-sys-detailed-announcement/";
          
        },
      },{id: "post-design-of-an-8-ghz-maximum-absolute-gain-or-mag-amplifier-with-non-linear-simulations-and-ip3-analysis",
        
          title: "Design of an 8 GHz Maximum Absolute Gain (or MAG) Amplifier with Non-linear...",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2025/ee-456-design-project-04/";
          
        },
      },{id: "post-ee-336-boost-converter-analysis",
        
          title: "EE-336 Boost Converter Analysis",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2025/ee336-week-13-boost-converter-analysis-detailed-announcement/";
          
        },
      },{id: "post-chebyshev-insertion-loss-matching-for-a-10-20-ghz-phemt-amplifier",
        
          title: "Chebyshev Insertion-Loss Matching for a 10–20 GHz pHEMT Amplifier",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2025/ee456-design-project-03/";
          
        },
      },{id: "post-using-chebyshev-polynomials-for-the-synthesis-of-impedance-matching-networks",
        
          title: "Using Chebyshev Polynomials for the Synthesis of Impedance-Matching Networks",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2025/ee456-design-03-10-ghz-to-20-ghz-chebyshev-synthesis-detailed-announcement/";
          
        },
      },{id: "post-ee-336-transmission-line-analysis",
        
          title: "EE-336 Transmission Line Analysis",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2025/ee336-week-12-trl-voltage-regulation-and-surge-impedance-loading-detailed-announcement/";
          
        },
      },{id: "post-ee-336-transmission-line-abcd-parameters",
        
          title: "EE-336 Transmission Line ABCD Parameters",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2025/ee336-week-11-transmission-line-abcd-parameters-detailed-announcement/";
          
        },
      },{id: "post-ee-336-gauss-seidel-power-flow-analysis",
        
          title: "EE-336 Gauss-Seidel Power Flow Analysis",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2025/ee336-week-10-gauss-seidel-power-flow-analysis-detailed-announcement/";
          
        },
      },{id: "post-15-ghz-low-noise-amplifier-input-output-matching-network-design",
        
          title: "15 GHz Low-Noise Amplifier Input/Output Matching Network Design",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2025/ee456-design-02-lna-matching-network-for-mgf4941al-detailed-announcement/";
          
        },
      },{id: "post-ee-336-power-transfer-amp-frequency-droop-analysis",
        
          title: "EE-336 Power Transfer &amp; Frequency Droop Analysis",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2025/ee336-week-09-generator-power-xfer-droop-detailed-announcement/";
          
        },
      },{id: "post-ee-336-induction-motor-phasor-analysis",
        
          title: "EE-336 Induction Motor Phasor Analysis",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2025/ee336-week-06-induction-motor-phasor-analysis-detailed-announcement/";
          
        },
      },{id: "post-15-ghz-hemt-amplifier-with-imn-omn-synthesis-and-ads-matlab-verification",
        
          title: "15 GHz HEMT Amplifier with IMN/OMN Synthesis and ADS/MATLAB Verification",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2025/ee456-design-project-01/";
          
        },
      },{id: "post-15-ghz-gaas-hemt-amplifier-design",
        
          title: "15 GHz GaAs HEMT Amplifier Design",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2025/ee456-design-01-15ghz-gaas-hemt-amp-detailed-announcement/";
          
        },
      },{id: "post-ee-336-induction-motor-slip-analysis",
        
          title: "EE-336 Induction Motor Slip Analysis",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2025/ee336-week-05-generators-detailed-announcement/";
          
        },
      },{id: "post-assignment-02",
        
          title: "Assignment 02",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2025/ee336-week-02-faradays-law-detailed-announcement/";
          
        },
      },{id: "post-ee-336-assignment-04-autotransformer-power-rating",
        
          title: "EE-336 Assignment 04 — Autotransformer Power Rating",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2025/ee336-week-04-autotransformer-ratings-detailed-announcement/";
          
        },
      },{id: "post-ee-336-assignment-3-delta-y-transformer-analysis",
        
          title: "EE-336 Assignment 3 – Delta-Y Transformer Analysis",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2025/ee336-week-03-transformers-detailed-announcement/";
          
        },
      },{id: "post-ee-336-assignment-01-three-phase-apparent-power",
        
          title: "EE-336 Assignment 01 — Three-Phase Apparent Power",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2025/ee336-week-01-three-phase-power-detailed-announcement/";
          
        },
      },{id: "post-laplace-transform-applications-for-system-analysis-and-modeling",
        
          title: "Laplace Transform Applications for System Analysis and Modeling",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2024/ee301-laplace-transform/";
          
        },
      },{id: "post-ee-319-lab-07-measurements",
        
          title: "EE 319 Lab 07 — Measurements",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2024/ee319-lab-07-detailed-announcement/";
          
        },
      },{id: "post-laplace-transform-applications-for-system-analysis-in-electrical-engineering",
        
          title: "Laplace Transform Applications for System Analysis in Electrical Engineering",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2024/ee301-report-02-laplace-transform-detailed-announcement/";
          
        },
      },{id: "post-ee-319-lab-06-measurements-lm741-op-amp",
        
          title: "EE 319 Lab 06 — Measurements (LM741 Op-Amp)",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2024/ee319-lab-06-detailed-announcement/";
          
        },
      },{id: "post-fourier-transform-applications-for-signal-analysis-in-engineering",
        
          title: "Fourier Transform Applications for Signal Analysis in Engineering",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2024/ee301-fourier-transform/";
          
        },
      },{id: "post-fourier-transform-applications-for-signal-analysis-in-electrical-engineering",
        
          title: "Fourier Transform Applications for Signal Analysis in Electrical Engineering",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2024/ee301-report-01-fourier-transform-detailed-announcement/";
          
        },
      },{id: "post-ee-319-lab-05-measurements",
        
          title: "EE 319 Lab 05 — Measurements",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2024/ee319-lab-05-detailed-announcement/";
          
        },
      },{id: "post-common-source-mosfet-amplifier-characterization",
        
          title: "Common-Source MOSFET Amplifier Characterization",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2024/ee319-lab-04-detailed-announcement/";
          
        },
      },{id: "post-ghz-transmission-line-matching-networks-with-ads-and-microstrip-layout",
        
          title: "GHz Transmission-Line Matching Networks with ADS and Microstrip Layout",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2024/ee314-design-project-01/";
          
        },
      },{id: "post-millimeter-wave-impedance-matching-network-designs",
        
          title: "Millimeter-Wave Impedance Matching Network Designs",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2024/ee314-design-01-detailed-announcement/";
          
        },
      },{id: "post-ee-319-lab-03-bode-plot-amp-small-signal-gain",
        
          title: "EE 319 Lab 03 — Bode Plot &amp; Small-Signal Gain",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2024/ee319-lab-03-small-signal-gain-detailed-announcement/";
          
        },
      },{id: "post-ee-319-lab-02-active-band-pass-filter-measurements",
        
          title: "EE-319 Lab 02 — Active Band-Pass Filter Measurements",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2024/ee319-lab-02-active-band-pass-filter-detailed-announcement/";
          
        },
      },{id: "post-ee-319-lab-01-low-pass-filter-measurements",
        
          title: "EE 319 Lab 01 — Low-Pass Filter Measurements",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2024/ee319-lab-01-low-pass-filter-detailed-announcement/";
          
        },
      },{id: "post-ee-319-lab-01-passive-rc-band-pass-filter",
        
          title: "EE-319 Lab 01 — Passive RC Band-Pass Filter",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2024/ee319-lab-01-band-pass-filter-detailed-announcement/";
          
        },
      },{id: "post-ee-319-lab-01-high-pass-filter-measurements",
        
          title: "EE-319 Lab 01 — High-Pass Filter Measurements",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2024/ee319-lab-01-high-pass-filter-detailed-announcement/";
          
        },
      },{id: "post-15-ghz-lna-matching-with-joint-gain-noise-and-vswr-optimization",
        
          title: "15 GHz LNA Matching with Joint Gain, Noise, and VSWR Optimization",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2024/ee456-design-project-02/";
          
        },
      },{id: "books-the-godfather",
          title: 'The Godfather',
          description: "",
          section: "Books",handler: () => {
              window.location.href = "/books/the_godfather/";
            },},{id: "news-rc-high-pass-in-practice-or-view-the-project-page",
          title: 'RC High-Pass in Practice — or view the project page.',
          description: "",
          section: "News",},{id: "news-passive-rc-band-pass-or-view-the-project-page",
          title: 'Passive RC Band-Pass — or view the project page.',
          description: "",
          section: "News",},{id: "news-rc-low-pass-in-practice-or-view-the-project-page",
          title: 'RC Low-Pass in Practice — or view the project page.',
          description: "",
          section: "News",},{id: "news-active-band-pass-lm741-or-view-the-project-page",
          title: 'Active Band-Pass (LM741) — or view the project page.',
          description: "",
          section: "News",},{id: "news-bode-plot-small-signal-limits-or-view-the-project-page",
          title: 'Bode Plot + Small-Signal Limits — or view the project page.',
          description: "",
          section: "News",},{id: "news-ghz-matching-networks-or-view-the-project-page",
          title: 'GHz Matching Networks — or view the project page.',
          description: "",
          section: "News",},{id: "news-common-source-mosfet-gain-or-view-the-project-page",
          title: 'Common-Source MOSFET Gain — or view the project page.',
          description: "",
          section: "News",},{id: "news-bjt-common-emitter-amplifier-or-view-the-project-page",
          title: 'BJT Common-Emitter Amplifier — or view the project page.',
          description: "",
          section: "News",},{id: "news-fourier-transform-in-practice-or-view-the-project-page",
          title: 'Fourier Transform in Practice — or view the project page.',
          description: "",
          section: "News",},{id: "news-op-amp-non-ideality-measurements-or-view-the-project-page",
          title: 'Op-Amp Non-Ideality Measurements — or view the project page.',
          description: "",
          section: "News",},{id: "news-laplace-transform-applications-or-view-the-project-page",
          title: 'Laplace Transform Applications — or view the project page.',
          description: "",
          section: "News",},{id: "news-difference-vs-instrumentation-amplifiers-or-view-the-project-page",
          title: 'Difference vs Instrumentation Amplifiers — or view the project page.',
          description: "",
          section: "News",},{id: "news-three-phase-power-in-delta-loads-or-view-the-project-page",
          title: 'Three-Phase Power in Delta Loads — or view the project page.',
          description: "",
          section: "News",},{id: "news-delta-y-transformer-voltages-or-view-the-project-page",
          title: 'Delta-Y Transformer Voltages — or view the project page.',
          description: "",
          section: "News",},{id: "news-autotransformer-power-ratings-or-view-the-project-page",
          title: 'Autotransformer Power Ratings — or view the project page.',
          description: "",
          section: "News",},{id: "news-faraday-s-law-amp-amp-phasor-analysis-or-view-the-project-page",
          title: 'Faraday’s Law &amp;amp;amp; Phasor Analysis — or view the project page.',
          description: "",
          section: "News",},{id: "news-induction-motor-slip-basics-or-view-the-project-page",
          title: 'Induction Motor Slip Basics — or view the project page.',
          description: "",
          section: "News",},{id: "news-15-ghz-gaas-hemt-amplifier-or-view-the-project-page",
          title: '15 GHz GaAs HEMT Amplifier — or view the project page.',
          description: "",
          section: "News",},{id: "news-induction-motor-phasors-or-view-the-project-page",
          title: 'Induction Motor Phasors — or view the project page.',
          description: "",
          section: "News",},{id: "news-generator-power-transfer-droop-or-view-the-project-page",
          title: 'Generator Power Transfer + Droop — or view the project page.',
          description: "",
          section: "News",},{id: "news-15-ghz-lna-matching-or-view-the-project-page",
          title: '15 GHz LNA Matching — or view the project page.',
          description: "",
          section: "News",},{id: "news-gauss-seidel-power-flow-or-view-the-project-page",
          title: 'Gauss-Seidel Power Flow — or view the project page.',
          description: "",
          section: "News",},{id: "news-transmission-line-abcd-parameters-or-view-the-project-page",
          title: 'Transmission Line ABCD Parameters — or view the project page.',
          description: "",
          section: "News",},{id: "news-voltage-regulation-sil-or-view-the-project-page",
          title: 'Voltage Regulation + SIL — or view the project page.',
          description: "",
          section: "News",},{id: "news-10-20-ghz-chebyshev-matching-or-view-the-project-page",
          title: '10–20 GHz Chebyshev Matching — or view the project page.',
          description: "",
          section: "News",},{id: "news-boost-converter-waveforms-or-view-the-project-page",
          title: 'Boost Converter Waveforms — or view the project page.',
          description: "",
          section: "News",},{id: "news-8-ghz-mag-amplifier-ip3-or-view-the-project-page",
          title: '8 GHz MAG Amplifier + IP3 — or view the project page.',
          description: "",
          section: "News",},{id: "news-satellite-tracking-control-or-view-the-project-page",
          title: 'Satellite Tracking Control — or view the project page.',
          description: "",
          section: "News",},{id: "news-audiogram-tuned-fir-filter-bank-or-view-the-project-page",
          title: 'Audiogram-Tuned FIR Filter Bank — or view the project page.',
          description: "",
          section: "News",},{id: "news-h-bridge-inverter-switching-or-view-the-project-page",
          title: 'H-Bridge Inverter Switching — or view the project page.',
          description: "",
          section: "News",},{id: "news-device-to-system-portfolio-or-view-the-project-page",
          title: 'Device-to-System Portfolio — or view the project page.',
          description: "",
          section: "News",},{id: "news-optimized-silicon-solar-cell-or-view-the-project-page",
          title: 'Optimized Silicon Solar Cell — or view the project page.',
          description: "",
          section: "News",},{id: "news-designing-an-8-ghz-oscillator-using-negative-resistance-feedback-and-passive-components-or-view-the-project-page",
          title: 'Designing an 8 GHz Oscillator using Negative-Resistance Feedback and Passive Components — or...',
          description: "",
          section: "News",},{id: "projects-optimized-silicon-solar-cell-design",
          title: 'Optimized Silicon Solar Cell Design',
          description: "Single-junction silicon PV cell optimized in ANSYS Lumerical DEVICE (AM1.5). 16.08% efficiency with Si3N4 ARC + Al contacts, plus cost and sustainability analysis.",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee212_design_01_optimized_solar_cell/";
            },},{id: "projects-fourier-transform-applications-for-signal-analysis-in-electrical-engineering",
          title: 'Fourier Transform Applications for Signal Analysis in Electrical Engineering',
          description: "Fourier Transform applications across audio, ECG, imaging, SDR spectrum analysis, and vibration diagnostics (MATLAB-based examples).",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee301_report_01_fourier_transform/";
            },},{id: "projects-laplace-transform-applications-for-system-analysis-in-electrical-engineering",
          title: 'Laplace Transform Applications for System Analysis in Electrical Engineering',
          description: "Applications of the Laplace Transform across neural decoding (BCIs), DC-DC converter stability, electromagnetic partial inductance modeling, and memristor simulation.",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee301_report_02_laplace_transform/";
            },},{id: "projects-fir-filter-bank-for-hearing-aid-audio-response",
          title: 'FIR Filter-Bank for Hearing Aid Audio Response',
          description: "Audiogram-driven FIR filter-bank audio equalizer (MATLAB • fir1/fir2 • linear-phase FIR).",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee302_design_01_fir_filterbank_for_hearing_aid/";
            },},{id: "projects-millimeter-wave-impedance-matching-network-designs",
          title: 'Millimeter-Wave Impedance Matching Network Designs',
          description: "Transmission-line impedance matching in Keysight ADS — shunt-stub + quarter-wave transformer designs (ideal + microstrip), with Smith-chart synthesis and layout verification.",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee314_design_01/";
            },},{id: "projects-low-pass-filter-measurement-and-analysis",
          title: 'Low-Pass Filter Measurement and Analysis',
          description: "First-order RC low-pass filter build + Bode measurement (10 Hz–100 kHz) with MATLAB/LTspice validation.",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee319_lab_01_low_pass_filter/";
            },},{id: "projects-active-band-pass-filter-measurement-and-analysis",
          title: 'Active Band-Pass Filter Measurement and Analysis',
          description: "Measurement + modeling of a 2nd-order active band-pass filter (LM741). Bode sweep (10 Hz–100 kHz), time-domain validation, and harmonic/spectrum analysis (MATLAB + LTspice + Digilent WaveForms).",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee319_lab_02_active_band_pass_filter/";
            },},{id: "projects-utilizing-bode-plots-to-determine-small-signal-gain",
          title: 'Utilizing Bode Plots to Determine Small-Signal Gain',
          description: "Calculated vs LTspice vs Analog Discovery measurements for a diode-biased LM741 amplifier (mid-band gain, cutoff frequencies, and small-signal limits).",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee319_lab_03_small_signal_gain/";
            },},{id: "projects-common-source-mosfet-amplifier-characterization",
          title: 'Common-Source MOSFET Amplifier Characterization',
          description: "MOSFET amplification with the ALD1105 dual complementary pair NMOS/PMOS transistors (MATLAB • LTspice • Analog Discovery Studio).",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee319_lab_04/";
            },},{id: "projects-distortion-measurements-of-a-common-emmiter-bipolar-junction-transistor",
          title: 'Distortion Measurements of a Common-Emmiter BiPolar Junction Transistor',
          description: "BJT common-emitter amplifier (2N3904): DC bias, midband gain, frequency response, and distortion limits.",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee319-lab-05/";
            },},{id: "projects-measuring-the-non-ideal-characteristics-of-an-operational-amplifier-lm741-op-amp",
          title: 'Measuring the Non-Ideal Characteristics of an Operational Amplifier (LM741 Op-Amp)',
          description: "Non-ideal op-amp characteristics measured in LTspice—offset voltage, input bias currents, slew rate, and gain-bandwidth product.",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee319-lab-06/";
            },},{id: "projects-measurements",
          title: 'Measurements',
          description: "Differential-mode gain, common-mode gain, and CMRR for a single-op-amp difference amplifier and a 3-op-amp instrumentation amplifier (LM741).",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee319/lab-07/";
            },},{id: "projects-passive-rc-band-pass-filter-measurement-and-analysis",
          title: 'Passive RC Band-Pass Filter Measurement and Analysis',
          description: "Two-pole passive RC band-pass filter: analytic frequency response + LTspice AC sweep + Analog Discovery Studio measurements (MATLAB post-processing).",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee319_lab_01_band_pass_filter/";
            },},{id: "projects-high-pass-filter-measurement-techniques",
          title: 'High-Pass Filter Measurement Techniques',
          description: "First-order RC high-pass filter characterization (theory vs. LTspice vs. WaveForms measurements) with MATLAB Bode magnitude/phase plots.",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee319_lab_01_high_pass_filter/";
            },},{id: "projects-final-lab-portfolio-eelab-ii-spring-39-25",
          title: 'Final Lab Portfolio (eeLab II | Spring &amp;#39;25)',
          description: "MOSFET characterization → amplifier design → differential pairs → VNA S-parameter de-embedding (LTspice • Python • LaTeX).",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee322_final_lab_portfolio/";
            },},{id: "projects-transistor-characterization-techniques",
          title: 'Transistor Characterization Techniques',
          description: "Extracting NMOS SPICE parameters (VTn, KN, VA) from automated SMU sweeps + Python analysis.",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee322_lab_01_transistor_characterization_methods/";
            },},{id: "projects-",
          title: '',
          description: "",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee322_lab_02_ic_biasing_techniques/";
            },},{id: "projects-building-simulating-and-measuring-a-common-source-amplifier-with-an-active-load",
          title: 'Building, Simulating, and Measuring a Common-Source Amplifier with an Active Load',
          description: "DC biasing + small-signal gain sensitivity to Rsig and RL using an ALD1105 MOSFET array (bench + LTspice).",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee322_lab_03_actively_loaded_common_source_ampflier/";
            },},{id: "projects-common-source-amplifier-frequency-response-measurement-and-analysis",
          title: 'Common-Source Amplifier: Frequency Response Measurement and Analysis',
          description: "DC bias + Bode magnitude response (Measured vs LTspice), using discrete capacitors to emulate MOSFET parasitics.",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee322_lab_04_frequency_response_of_common_source_amplifier/";
            },},{id: "projects-frequency-response-analysis-of-a-common-source-amplifier-with-feedback",
          title: 'Frequency Response Analysis of a Common-Source Amplifier with Feedback',
          description: "Measured Bode magnitude/phase, −3 dB bandwidth, and gain-bandwidth product for a drain-to-gate feedback common-source MOSFET amplifier (ALD1105).",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee322_lab_05_frequency_response_of_common_source_amplifier_with_feedback/";
            },},{id: "projects-analysis-of-the-mos-differential-pair-single-ended-vs-differential-signaling",
          title: 'Analysis of the MOS Differential Pair (Single-Ended vs. Differential Signaling)',
          description: "Characterization a MOS differential pair (ALD1105) in DC and AC; compare single-ended vs differential output and quantify CMRR.",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee322_lab_06_MOS_differential_pair/";
            },},{id: "projects-analysis-of-the-mos-differential-pair-with-a-current-mirror-load",
          title: 'Analysis of the MOS Differential Pair (with a Current Mirror Load)',
          description: "Differential-to-single-ended MOS amplifier using an ALD1105 current-mirror load; DC operating point, differential/common-mode gain, and CMRR (2025-04-08).",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee322_lab_07_MOS_differential_pair_with_current_mirror_load/";
            },},{id: "projects-de-embedding-device-s-parameters-from-vector-network-analyzer-measurments",
          title: 'De-Embedding Device S-Parameters from Vector Network Analyzer Measurments',
          description: "Vector Network Analyzer (VNA) measurements of LPF/HPF frequency response with 2x-thru de-embedding (Touchstone • Python • SciPy).",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee322_lab_08_de-embedding_s-parameters/";
            },},{id: "projects-three-phase-apparent-power",
          title: 'Three-Phase Apparent Power',
          description: "Calculating total 3-phase apparent power for a Δ-connected balanced load (MATLAB • phasor analysis • power systems).",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee336_week_01_three_phase_power/";
            },},{id: "projects-faraday-39-s-law-synchronous-generator-speed-and-phasor-analysis",
          title: 'Faraday&amp;#39;s Law, Synchronous Generator Speed, and Phasor Analysis',
          description: "Faraday&#39;s Law, Synchronous Generator Speed, and Phasor Analysis",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee336_week_02_faradays_law/";
            },},{id: "projects-delta-y-transformer-analysis",
          title: 'Delta-Y Transformer Analysis',
          description: "Three-phase transformer voltage analysis for Δ-Y configuration (Electrical Energy Systems • 480V line-to-line • Turns ratio derivation).",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee336_week_03_transformers/";
            },},{id: "projects-autotransformer-power-rating",
          title: 'Autotransformer Power Rating',
          description: "Isolation transformer to autotransformer conversion analysis (3:1 turns ratio • power rating comparison • step-up vs step-down configurations).",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee336_week_04_autotransformer_ratings/";
            },},{id: "projects-induction-motor-slip-analysis",
          title: 'Induction Motor Slip Analysis',
          description: "Induction motor fundamentals — slip, synchronous speed, and rotor frequency calculations for 2-pole motors.",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee336_week_05_generators/";
            },},{id: "projects-induction-motor-phasor-analysis",
          title: 'Induction Motor Phasor Analysis',
          description: "Phasor diagram analysis of induction motor equivalent circuit at multiple operating points (MATLAB • Python • Complex Impedance Analysis).",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee336_week_06_induction_motor_phasor_analysis/";
            },},{id: "projects-power-transfer-amp-frequency-droop-analysis",
          title: 'Power Transfer &amp;amp; Frequency Droop Analysis',
          description: "Generator power transfer calculation via transformer and frequency droop characteristic analysis for parallel generators (Per-unit analysis • Power-angle relationship • Droop control).",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee336_week_09_generator_power_xfer_droop/";
            },},{id: "projects-gauss-seidel-power-flow-analysis-for-electrical-energy-systems",
          title: 'Gauss-Seidel Power Flow Analysis for Electrical Energy Systems',
          description: "Iterative power flow solution for a 6-bus system using the Gauss-Seidel method (MATLAB • Y-bus • per-unit system).",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee336_week_10_gauss-seidel_power_flow_analysis/";
            },},{id: "projects-transmission-line-abcd-parameters",
          title: 'Transmission Line ABCD Parameters',
          description: "100-mile transmission line analysis using two-port ABCD parameters and the nominal π-model (60 Hz power system).",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee336_week_11_transmission_line_abcd_parameters/";
            },},{id: "projects-transmission-line-analysis",
          title: 'Transmission Line Analysis',
          description: "Voltage regulation and surge impedance loading analysis for power transmission lines (MATLAB/Python • Two-port networks • SIL concepts).",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee336_week_12_trl_voltage_regulation_and_surge_impedance_loading/";
            },},{id: "projects-boost-converter-analysis",
          title: 'Boost Converter Analysis',
          description: "DC waveform analysis and boost converter duty cycle calculations (Week 13 Assignment • DC-DC Converters • Switching Power Supplies).",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee336_week_13_boost_converter_analysis/";
            },},{id: "projects-single-phase-h-bridge-inverter-analysis",
          title: 'Single-Phase H-Bridge Inverter Analysis',
          description: "H-bridge inverter switching analysis and load voltage waveform generation (MATLAB • Power Electronics • DC-AC Conversion).",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee336_week_14_h_bridge_inverter_analysis/";
            },},{id: "projects-15-ghz-gaas-hemt-amplifier-design",
          title: '15 GHz GaAs HEMT Amplifier Design',
          description: "15 GHz GaAs HEMT amplifier (MGF4941AL) with TL-based input/output matching. MATLAB + Keysight ADS (ideal TRLs) verification.",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee456_design_01_15GHz_GaAs_HEMT_amp/";
            },},{id: "projects-15-ghz-low-noise-amplifier-input-output-matching-network-design",
          title: '15 GHz Low-Noise Amplifier Input/Output Matching Network Design',
          description: "15 GHz LNA IMN/OMN for the MGF4941AL (VDS = 2 V, IDS = 10 mA). Joint gain/NF/VSWR optimization with MATLAB + Keysight ADS cross-verification.",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee456_design_02_lna_matching_network_for_mgf4941al/";
            },},{id: "projects-using-chebyshev-polynomials-for-the-synthesis-of-impedance-matching-networks",
          title: 'Using Chebyshev Polynomials for the Synthesis of Impedance-Matching Networks',
          description: "Wideband 10–20 GHz pHEMT amplifier using Chebyshev (insertion-loss) matching synthesis. 7-element IMN/OMN, MATLAB + ADS verification.",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee456_design_03_10_ghz_to_20_ghz_chebyshev_synthesis/";
            },},{id: "projects-",
          title: '',
          description: "",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee456_design_04/";
            },},{id: "projects-design-of-an-8-ghz-oscillator-using-negative-resistance-atf-33143",
          title: 'Design of an 8 GHz Oscillator using Negative-Resistance (ATF-33143)',
          description: "Negative-resistance oscillator synthesis at 8 GHz using common-gate conversion, feedback-reactance optimization, and transmission-line termination/resonator networks (MATLAB • Touchstone).",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee456_design_05/";
            },},{id: "projects-discrete-control-system-design-for-receiver-positioning-and-accurate-satellite-tracking",
          title: 'Discrete Control System Design for Receiver Positioning and Accurate Satellite Tracking',
          description: "Discrete-time state-space controller (pole placement) for a servo-driven receiver positioning system. Validated in MATLAB/Simulink across multiple sampling rates.",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee470_design_01_servomotor_control_sys/";
            },},{
        id: 'social-cv',
        title: 'CV',
        section: 'Socials',
        handler: () => {
          window.open("/assets/pdf/example_pdf.pdf", "_blank");
        },
      },{
        id: 'social-email',
        title: 'email',
        section: 'Socials',
        handler: () => {
          window.open("mailto:%79%6F%75@%65%78%61%6D%70%6C%65.%63%6F%6D", "_blank");
        },
      },{
        id: 'social-inspire',
        title: 'Inspire HEP',
        section: 'Socials',
        handler: () => {
          window.open("https://inspirehep.net/authors/1010907", "_blank");
        },
      },{
        id: 'social-rss',
        title: 'RSS Feed',
        section: 'Socials',
        handler: () => {
          window.open("/feed.xml", "_blank");
        },
      },{
        id: 'social-scholar',
        title: 'Google Scholar',
        section: 'Socials',
        handler: () => {
          window.open("https://scholar.google.com/citations?user=qc6CJjYAAAAJ", "_blank");
        },
      },{
        id: 'social-custom_social',
        title: 'Custom_social',
        section: 'Socials',
        handler: () => {
          window.open("https://www.alberteinstein.com/", "_blank");
        },
      },{
      id: 'light-theme',
      title: 'Change theme to light',
      description: 'Change the theme of the site to Light',
      section: 'Theme',
      handler: () => {
        setThemeSetting("light");
      },
    },
    {
      id: 'dark-theme',
      title: 'Change theme to dark',
      description: 'Change the theme of the site to Dark',
      section: 'Theme',
      handler: () => {
        setThemeSetting("dark");
      },
    },
    {
      id: 'system-theme',
      title: 'Use system default theme',
      description: 'Change the theme of the site to System Default',
      section: 'Theme',
      handler: () => {
        setThemeSetting("system");
      },
    },];
