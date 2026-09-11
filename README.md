# PV Test Bench — CAD Model

Parametric reconstruction of the tilt-adjustable solar panel test rig used
for the bachelor's PV efficiency testing project (theoretical vs. measured
output, presented at ICGCP-2023, Bengaluru).

## ⚠️ Status: placeholder dimensions
The original CAD files and report are only available as a hard-printed
copy in India. All dimensions in `pv_test_bench_cad.py` are **typical
lab-bench values**, not the real ones. Before publishing this to your
profile as a faithful reconstruction:

1. Pull the real numbers from the printed report (panel L×W×thickness,
   tilt angle range actually tested, base/frame dimensions, which sensors
   were mounted where).
2. Update the parameters block at the top of `pv_test_bench_cad.py`.
3. Re-run the script to regenerate the STEP/STL files.

## Files
| File | Description |
|---|---|
| `pv_test_bench_cad.py` | Parametric CAD source (CadQuery/Python) — edit parameters here |
| `pv_test_bench.step` | Full assembly — opens in SolidWorks, NX, Solid Edge, FreeCAD |
| `pv_test_bench.stl` | Full assembly, mesh format (GitHub renders STL inline) |
| `pv_panel.step` | Panel + frame sub-assembly only |
| `tilt_frame.step` | Base + support pillars only |
| `pv_test_bench_preview.svg` | Quick isometric preview |

## Why parametric / scripted CAD instead of a native SolidWorks file
Since the original native CAD file no longer exists, this was rebuilt as a
scripted parametric model rather than a fresh from-memory sketch in
SolidWorks/NX. That's a legitimate (and honestly a *stronger*) story for
an interview: it's version-controllable, regenerates from a single
parameter change, and demonstrates Python-driven CAD — a skill most
classmates won't have on their profile. Frame it as exactly that: "the
original was a manual SolidWorks model; I rebuilt it as a scripted
parametric version so it's reproducible and sits properly in version
control."

## Assembly overview
- Base plate with corner mounting holes
- Two support pillars forming the tilt hinge axis
- Notched adjustment strut (angle range configurable, default 0–90° in
  15° steps)
- Framed PV panel with simplified cell-grid engraving, mounted at the
  configured tilt angle
- Pyranometer mounting arm + head
- Thermocouple clip on the panel backside

## Next steps for the repo
- [ ] Swap in real specs once you have the report
- [ ] Add MATLAB PV efficiency analysis (theoretical vs. measured I-V/power)
- [ ] Add thermal/structural sim for the frame under wind/thermal load
- [ ] Top-level README tying CAD + MATLAB + sim together as one project
