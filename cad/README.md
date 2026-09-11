# PV Test Bench — CAD Model

Reconstruction of the tilt-adjustable solar panel test rig used for the
bachelor's PV efficiency testing project (theoretical vs. measured
output, presented at ICGCP-2023, Bengaluru).

## ⚠️ Status: placeholder dimensions
The original CAD files and report are only available as a hard-printed
copy in India. All dimensions here are **typical lab-bench values**, not
the real ones yet. See `CAD_PARAMETERS.md` for the full dimension table
and the rebuild sequence — once you have the real report numbers, redo
the affected sketches in Solid Edge/SolidWorks/NX using that sheet.

## Files
| File | Description |
|---|---|
| `pv_test_bench.step` | Full assembly — opens directly in SolidWorks, NX, Solid Edge, FreeCAD |
| `pv_test_bench.stl` | Full assembly, mesh format (GitHub renders STL inline) |
| `pv_panel.step` | Panel + frame sub-assembly only |
| `tilt_frame.step` | Base + support pillars only |
| `preview.png` | Isometric preview |
| `CAD_PARAMETERS.md` | Dimension table + native rebuild/edit steps |

## Assembly overview
- Base plate with corner mounting holes
- Two support pillars forming the tilt hinge axis
- Notched adjustment strut (angle range 0–90° in 15° steps)
- Framed PV panel with a simplified cell-grid engraving, hinged off the
  pillars at the configured tilt angle, front face up and outward
- Pyranometer mounting arm + head
- Thermocouple clip on the panel backside

## Next steps for the repo
- [ ] Swap in real specs once you have the report (update sketches per
      `CAD_PARAMETERS.md`)
- [ ] Add a couple of real photos of the original physical rig if you
      have any
