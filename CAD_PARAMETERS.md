# PV Test Bench — CAD Parameter Sheet

The `.step` / `.stl` files in this folder are the actual CAD deliverable —
open them directly in Solid Edge, SolidWorks, NX, or AutoCAD, no scripting
involved. This sheet is here so you (or anyone reviewing it) can rebuild
or edit the model natively from a sketch, without touching any code.

## ⚠️ Placeholder dimensions
Replace these with your real report values once available, then just
redo the affected sketch/feature in your CAD tool of choice.

| Part | Parameter | Value |
|---|---|---|
| PV panel | Length × Width × Thickness | 400 × 300 × 3 mm |
| Panel frame | Border width | 15 mm |
| Panel frame | Frame depth | 20 mm |
| Base plate | Length × Width × Thickness | 500 × 400 × 6 mm |
| Base plate | Corner mounting holes | Ø6 mm, 25 mm inset from edges |
| Hinge pillars | Cross-section | 20 × 6 mm |
| Hinge pillars | Height | 60 mm |
| Hinge pillars | Position | 40 mm from base back edge, inset 20 mm from panel width on each side |
| Tilt adjustment strut | Cross-section | 6 mm × 20 mm |
| Tilt adjustment strut | Length | 220 mm |
| Tilt adjustment strut | Angle notches | 0°–90° in 15° steps |
| Current rendered tilt | — | 30° |
| Pyranometer arm | Cross-section × Length | 12 × 6 mm × 120 mm |
| Pyranometer sensor head | Cylinder | Ø30 × 20 mm |
| Thermocouple clip | Block | 10 × 4 × 15 mm |
| Cell grid (visual only) | Layout | 6 columns × 10 rows |

## Rebuild sequence (Solid Edge / SolidWorks / NX — same logic in any of them)

1. **Base plate**: sketch a 500×400 mm rectangle on the XY plane, extrude
   6 mm. Add 4× Ø6 mm holes, 25 mm inset from each corner.
2. **Hinge pillars**: sketch two 20×6 mm rectangles on the base's top
   face, positioned 40 mm in from the back edge and inset 20 mm from the
   panel's width on each side; extrude 60 mm.
3. **PV panel core**: new sketch, 400×300 mm rectangle, extrude 3 mm.
4. **Panel frame**: sketch a 430×330 mm outer rectangle around the panel,
   extrude 20 mm, then shell/cut a 400×300 mm pocket to fit the panel
   core inside, flush with the top.
5. **Cell grid (cosmetic)**: sketch a 6×10 grid of lines on the panel's
   front face and engrave ~0.5 mm deep (optional — purely visual).
6. **Assemble + tilt**: mate the panel's back edge to the pillar tops as
   a revolute (hinge) joint; rotate 30° so the panel lifts up and its
   front (cell-grid) face points up and outward — not folded down.
7. **Tilt strut**: sketch a 220 mm long, 6×20 mm bar; add a row of Ø4 mm
   holes every 20 mm along its length as the angle-notch positions;
   mate one end to the panel back, the other resting against a pillar
   notch.
8. **Pyranometer arm + head**: extrude a 120 mm arm from the base next to
   the panel, cap it with a Ø30×20 mm cylinder to represent the sensor.
9. **Thermocouple clip**: small 10×4×15 mm block mounted on the panel
   backside.

Once you have the real report numbers, just update the sketch dimensions
in steps 1–4 and re-run the mate/rotation in step 6 — everything else
scales the same way.
