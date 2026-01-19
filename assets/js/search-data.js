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
        },{id: "post-designing-an-8-ghz-negative-resistance-oscillator-with-an-atf-33143-gaas-phemt",
        
          title: "Designing an 8 GHz Negative-Resistance Oscillator with an ATF-33143 GaAs pHEMT",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2025/ee456-design-project-05/";
          
        },
      },{id: "post-designing-a-personalized-audiogram-driven-fir-filter-bank-for-a-virtual-hearing-aid",
        
          title: "Designing a Personalized Audiogram-Driven FIR Filter-Bank for a Virtual Hearing Aid",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2025/ee302-design-project-01/";
          
        },
      },{id: "post-discrete-time-control-for-receiver-positioning-and-satellite-tracking",
        
          title: "Discrete-Time Control for Receiver Positioning and Satellite Tracking",
        
        description: "Discrete-time state-space controller (pole placement) for a servo-driven receiver positioning system. Validated in MATLAB/Simulink across multiple sampling rates.",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2025/ee470-design-project-01/";
          
        },
      },{id: "post-designing-an-8-ghz-mag-amplifier-with-nonlinear-verification-and-ip3-analysis",
        
          title: "Designing an 8 GHz MAG Amplifier with Nonlinear Verification and IP3 Analysis",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2025/ee-456-design-project-04/";
          
        },
      },{id: "post-chebyshev-insertion-loss-matching-for-a-10-20-ghz-phemt-amplifier",
        
          title: "Chebyshev Insertion-Loss Matching for a 10–20 GHz pHEMT Amplifier",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2025/ee456-design-project-03/";
          
        },
      },{id: "post-15-ghz-hemt-amplifier-with-imn-omn-synthesis-and-ads-matlab-verification",
        
          title: "15 GHz HEMT Amplifier with IMN/OMN Synthesis and ADS/MATLAB Verification",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2025/ee456-design-project-01/";
          
        },
      },{id: "post-laplace-transform-applications-for-system-analysis-and-modeling",
        
          title: "Laplace Transform Applications for System Analysis and Modeling",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2024/ee301-laplace-transform/";
          
        },
      },{id: "post-fourier-transform-applications-for-signal-analysis-in-engineering",
        
          title: "Fourier Transform Applications for Signal Analysis in Engineering",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2024/ee301-fourier-transform/";
          
        },
      },{id: "post-ghz-transmission-line-matching-networks-with-ads-and-microstrip-layout",
        
          title: "GHz Transmission-Line Matching Networks with ADS and Microstrip Layout",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2024/ee314-design-project-01/";
          
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
            },},{id: "news-ghz-transmission-line-matching-networks-or-view-the-project-page",
          title: 'GHz Transmission-Line Matching Networks — or view the project page.',
          description: "",
          section: "News",},{id: "news-fourier-transform-applications-for-signal-analysis-or-view-the-project-page",
          title: 'Fourier Transform Applications for Signal Analysis — or view the project page.',
          description: "",
          section: "News",},{id: "news-laplace-transform-applications-for-system-analysis-or-view-the-project-page",
          title: 'Laplace Transform Applications for System Analysis — or view the project page.',
          description: "",
          section: "News",},{id: "news-15-ghz-gaas-hemt-amplifier-design-or-view-the-project-page",
          title: '15 GHz GaAs HEMT Amplifier Design — or view the project page.',
          description: "",
          section: "News",},{id: "news-15-ghz-lna-matching-network-design-or-view-the-project-page",
          title: '15 GHz LNA Matching Network Design — or view the project page.',
          description: "",
          section: "News",},{id: "news-10-20-ghz-chebyshev-insertion-loss-matching-or-view-the-project-page",
          title: '10-20 GHz Chebyshev Insertion-Loss Matching — or view the project page.',
          description: "",
          section: "News",},{id: "news-ee-456-design-project-04-or-view-the-project-page",
          title: 'EE-456 Design Project 04 — or view the project page.',
          description: "",
          section: "News",},{id: "news-discrete-control-for-receiver-positioning-and-satellite-tracking-or-view-the-project-page",
          title: 'Discrete Control for Receiver Positioning and Satellite Tracking — or view the project...',
          description: "",
          section: "News",},{id: "news-design-of-a-fir-virtual-filter-bank-customized-for-individual-patients-audiograms-for-use-in-hearing-aids-or-view-the-project-page",
          title: 'Design of a FIR Virtual Filter-bank Customized for Individual Patients’ Audiograms for use...',
          description: "",
          section: "News",},{id: "news-negative-feedback-oscillator-design-or-view-the-project-page",
          title: 'Negative-Feedback Oscillator Design — or view the project page.',
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
            },},{id: "projects-ee-319-lab-01-low-pass-filter-measurements",
          title: 'EE 319 Lab 01 — Low-Pass Filter Measurements',
          description: "First-order RC low-pass filter build + Bode measurement (10 Hz–100 kHz) with MATLAB/LTspice validation.",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee319_lab_01_low_pass_filter/";
            },},{id: "projects-eelab-ii-final-lab-portfolio",
          title: 'eeLab II — Final Lab Portfolio',
          description: "MOSFET characterization → amplifier design → differential pairs → VNA S-parameter de-embedding (LTspice • Python • LaTeX).",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee322_final_lab_portfolio/";
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
            },},{id: "projects-ee-456-design-project-05-published-8-ghz-negative-resistance-oscillator-using-atf-33143-gaas-phemt",
          title: 'EE-456 Design Project 05 Published: 8 GHz Negative-Resistance Oscillator Using ATF-33143 GaAs pHEMT...',
          description: "",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee456_design_05_old/";
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
