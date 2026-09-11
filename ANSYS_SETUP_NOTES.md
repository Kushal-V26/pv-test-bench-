# Replicating This in ANSYS Workbench (for real screenshots)

The `structural_thermal_analysis.py` script gives closed-form results —
good for validation numbers, but a portfolio benefits from an actual
ANSYS mesh/contour screenshot too. Now that you have ANSYS access at FAU,
here's the setup to reproduce the same study for real:

## Static Structural (wind load on the support strut)
- **Geometry**: import `cad/tilt_frame.step` (or the full assembly)
- **Material**: Aluminium 6061-T6 (built into ANSYS Engineering Data)
- **Mesh**: default sizing is fine for a first pass; refine at the
  strut/pillar fillet if you add one (stress concentration point)
- **Boundary conditions**:
  - Fixed support at the base plate underside
  - Pressure load on the panel face = dynamic pressure × Cd
    (use the values from `structural_summary.csv` for a given wind
    speed/tilt combination, e.g. 20 m/s → ~245 Pa dynamic pressure)
- **Solve for**: Equivalent (von-Mises) stress, total deformation
- **Compare against**: the `stress_vs_tilt_wind.png` curve — ANSYS
  should land close to the hand-calc for a simple cantilever; the
  interesting interview point is *explaining any difference* (ANSYS
  captures the base-plate flexibility and stress concentrations that
  the beam formula ignores)

## Steady-State Thermal
- Same geometry, aluminium material
- Apply a temperature load across the expected operating range
  (e.g. 25 degC to 65 degC panel surface temp)
- Solve for thermal expansion / directional deformation
- Compare against `thermal_expansion.png`

## Talking point for interviews
"I validated the ANSYS results against a closed-form beam/thermal
calculation I wrote myself, rather than trusting the solver output
blindly" is a stronger statement than either piece alone — it shows you
understand what the FEA tool is doing under the hood.
