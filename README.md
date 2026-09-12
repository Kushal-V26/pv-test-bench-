# Solar PV Test Bench — Design, Analysis & Efficiency Study

A tilt-adjustable solar panel test rig used to compare theoretical vs.
measured PV efficiency, originally built as a bachelor's final-year
project (presented at ICGCP-2023, Bengaluru). This repo reconstructs and
extends that project with the tools now available during my master's
(FAU Erlangen-Nürnberg) — CAD model, a MATLAB efficiency model, and a
MATLAB structural/thermal check on the mounting frame.

## ⚠️ Honest status of this project
The original native CAD files and raw test data no longer exist digitally
— only a printed report survives (reason: pre-graduation laptop/
storage situation). Everything here is a **faithful reconstruction**:
- The panel size, tilt mechanism, and test methodology match the real
  project.
- The specific numbers (panel wattage, exact tilt angles tested, wind
  speeds, sensor readings) are currently **placeholders** marked clearly
  in each file, pending the real report being re-digitized.
- The MATLAB analysis and structural/thermal study are **new** —  I didn't
  have this level of tooling or FEA access as a bachelor's student. This
  is the honest "enhanced it in Germany" part.


## Repo structure
```
├── cad/
│   ├── pv_test_bench.step/.stl    # full assembly — open in Solid Edge/SolidWorks/NX
│   ├── pv_panel.step              # panel sub-part
│   ├── tilt_frame.step            # frame sub-part
│   ├── CAD_PARAMETERS.md          # dimension table + native rebuild steps
│   └── README.md
├── matlab/
│   └── pv_efficiency_analysis.m   # theoretical vs measured I-V/P-V, efficiency
├── structural_thermal/
│   ├── structural_thermal_analysis.m   # wind load + thermal expansion calc
│   ├── ANSYS_SETUP_NOTES.md            # how to reproduce in real ANSYS
│   └── *.png, structural_summary.csv
└── README.md   (this file)
```

## Project narrative
1. **Original bachelor's work**: physical test bench, PV panel, tilt
   adjustment, irradiance/temperature/output logging, theoretical vs.
   measured efficiency comparison, presented at ICGCP-2023.
2. **CAD reconstruction**: rebuilt as a native STEP/STL assembly
3. **Efficiency analysis (new)**: single-diode I-V model in MATLAB,
   swept across irradiance and temperature, benchmarked against a
   synthetic "measured" curve with realistic real-world losses (series
   resistance, mismatch, soiling). Replace the synthetic data with the
   real logged data once the report is available.
4. **Structural/thermal check (new)**: wind load on the tilted panel and
   thermal expansion of the frame, MATLAB closed-form model with a
   documented path to validate in real ANSYS.

