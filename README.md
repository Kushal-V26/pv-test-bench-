# Solar PV Test Bench — Design, Analysis & Efficiency Study

A tilt-adjustable solar panel test rig used to compare theoretical vs.
measured PV efficiency, originally built as a bachelor's final-year
project (presented at ICGCP-2023, Bengaluru). This repo reconstructs and
extends that project with the tools now available during my master's
(FAU Erlangen-Nürnberg) — parametric CAD, a scripted efficiency model,
and a structural/thermal check on the mounting frame.

## ⚠️ Honest status of this repo
The original native CAD files and raw test data no longer exist digitally
— only a printed report survives (long story: pre-graduation laptop/
storage situation). Everything here is a **faithful reconstruction**:
- The panel size, tilt mechanism, and test methodology match the real
  project.
- The specific numbers (panel wattage, exact tilt angles tested, wind
  speeds, sensor readings) are currently **placeholders** marked clearly
  in each file, pending the real report being re-digitized.
- The MATLAB analysis and structural/thermal study are **new** —  I didn't
  have this level of tooling or FEA access as a bachelor's student. This
  is the honest "enhanced it in Germany" part.

If asked about this directly (e.g. in an interview), the accurate framing
is: *"The physical build and the theoretical-vs-measured comparison were
done for my bachelor's. Since then I've rebuilt the CAD as a parametric
model and added a proper efficiency model and a structural/thermal check
on the frame — things I didn't have the tools or time for back then."*

## Repo structure
```
├── cad/
│   ├── pv_test_bench_cad.py       # parametric model (CadQuery)
│   ├── pv_test_bench.step/.stl    # full assembly
│   ├── pv_panel.step              # panel sub-part
│   ├── tilt_frame.step            # frame sub-part
│   └── README.md
├── matlab/
│   └── pv_efficiency_analysis.m   # theoretical vs measured I-V/P-V, efficiency
├── structural_thermal/
│   ├── structural_thermal_analysis.py  # wind load + thermal expansion calc
│   ├── ANSYS_SETUP_NOTES.md            # how to reproduce in real ANSYS
│   └── *.png, structural_summary.csv
└── README.md   (this file)
```

## Project narrative
1. **Original bachelor's work**: physical test bench, PV panel, tilt
   adjustment, irradiance/temperature/output logging, theoretical vs.
   measured efficiency comparison, presented at ICGCP-2023.
2. **CAD reconstruction**: rebuilt as a parametric CadQuery model instead
   of a from-memory SolidWorks sketch — reproducible, version-controlled,
   demonstrates scripted CAD as an additional skill.
3. **Efficiency analysis (new)**: single-diode I-V model in MATLAB,
   swept across irradiance and temperature, benchmarked against a
   synthetic "measured" curve with realistic real-world losses (series
   resistance, mismatch, soiling). Replace the synthetic data with the
   real logged data once the report is available.
4. **Structural/thermal check (new)**: wind load on the tilted panel and
   thermal expansion of the frame, analytical closed-form model with a
   documented path to validate in real ANSYS.

## Before publishing to GitHub
- [ ] Swap in real specs from the report (panel datasheet, tilt range,
      base dimensions) — update the parameter blocks in `cad/
      pv_test_bench_cad.py`, `matlab/pv_efficiency_analysis.m`, and
      `structural_thermal/structural_thermal_analysis.py`
- [ ] Replace the synthetic "measured" I-V data with real logged
      readings if you can recover/re-transcribe them from the report
- [ ] Optionally run the real ANSYS study per `ANSYS_SETUP_NOTES.md` and
      add the screenshots
- [ ] Add a couple of photos of the original physical rig if you have
      any (phone photos, conference presentation slides) — nothing beats
      a real photo next to the CAD reconstruction
- [ ] Decide how much of the "reconstruction" framing you want visible
      in the public README vs. kept for interview conversation — the
      honest version above is the safe default either way
