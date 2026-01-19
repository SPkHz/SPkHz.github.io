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
          
            window.location.href = "/blog/2026/2025-04-29-ee302-design-project-01/";
          
        },
      },{id: "post-",
        
          title: "",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2026/2025-04-16-ee456-design-project-03/";
          
        },
      },{id: "post-",
        
          title: "",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2026/2025-03-28-ee456-design-project-02/";
          
        },
      },{id: "post-",
        
          title: "",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2026/2025-02-25-ee456-design-project-01/";
          
        },
      },{id: "post-",
        
          title: "",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2026/2024-12-06-ee301-laplace-transform/";
          
        },
      },{id: "post-",
        
          title: "",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2026/2024-11-27-ee301-fourier-transform/";
          
        },
      },{id: "post-",
        
          title: "",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2026/2024-11-18-ee314-design-project-01/";
          
        },
      },{id: "post-ee-456-design-project-05",
        
          title: "EE-456 Design Project 05",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2025/ee456-design-project-05/";
          
        },
      },{id: "post-ee-456-design-project-04",
        
          title: "EE-456 Design Project 04",
        
        description: "",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2025/ee456-design-project-04/";
          
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
          section: "News",},{id: "news-digital-signal-processing-design-project-or-view-the-project-page",
          title: 'Digital Signal Processing Design Project — or view the project page.',
          description: "",
          section: "News",},{id: "news-ee-456-design-project-05-or-view-the-project-page",
          title: 'EE-456 Design Project 05 — or view the project page.',
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
            },},{id: "projects-ee-456-design-project-04",
          title: 'EE-456 Design Project 04',
          description: "Placeholder for EE-456 Design Project 04.",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ee456_design_04/";
            },},{id: "projects-ee-456-design-project-05",
          title: 'EE-456 Design Project 05',
          description: "Placeholder for EE-456 Design Project 05.",
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
