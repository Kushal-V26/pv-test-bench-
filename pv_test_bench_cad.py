"""
PV Test Bench - Parametric CAD Model
=====================================
Reconstruction of a tilt-adjustable solar panel test rig for PV efficiency
testing (theoretical vs. measured output comparison).

⚠️ PLACEHOLDER SPECS — all dimensions below are typical values for a small
educational/lab-scale PV test bench. Replace them with your actual bachelor
project numbers (panel size, tilt range, mounting geometry) once you have
them, then re-run this script to regenerate accurate files.

Outputs (in /mnt/user-data/outputs/cad/):
    pv_test_bench.step   - full assembly, opens in SolidWorks/NX/Solid Edge/FreeCAD
    pv_test_bench.stl    - for 3D preview / GitHub STL viewers
    pv_panel.step        - panel sub-part only
    tilt_frame.step       - frame/mount sub-part only
"""

import cadquery as cq
import os

# ----------------------------------------------------------------------
# PLACEHOLDER PARAMETERS — update with your real report values
# ----------------------------------------------------------------------
PANEL_LENGTH   = 400.0   # mm  (long edge)
PANEL_WIDTH    = 300.0   # mm
PANEL_THICK    = 3.0     # mm  (laminate + backsheet, simplified)
FRAME_BORDER   = 15.0    # mm  (aluminium frame around panel)
FRAME_DEPTH    = 20.0    # mm

BASE_LENGTH    = 500.0   # mm
BASE_WIDTH     = 400.0   # mm
BASE_THICK     = 6.0     # mm

TILT_ANGLE_DEG = 30.0    # current tilt for the rendered assembly
TILT_MIN, TILT_MAX, TILT_STEP = 0, 90, 15   # degrees, protractor notches

STRUT_WIDTH    = 20.0
STRUT_THICK    = 6.0
HINGE_DIA      = 8.0

SENSOR_ARM_LEN = 120.0
SENSOR_ARM_W   = 12.0

OUT_DIR = "/mnt/user-data/outputs/cad"
os.makedirs(OUT_DIR, exist_ok=True)

# ----------------------------------------------------------------------
# 1. Base plate (table-mounted test bed)
# ----------------------------------------------------------------------
base = (
    cq.Workplane("XY")
    .box(BASE_LENGTH, BASE_WIDTH, BASE_THICK)
)
# mounting holes at corners
for dx in (-1, 1):
    for dy in (-1, 1):
        base = base.faces(">Z").workplane().pushPoints(
            [(dx * (BASE_LENGTH/2 - 25), dy * (BASE_WIDTH/2 - 25))]
        ).hole(6)

# hinge pillars (two, holding the tilt axis)
pillar_h = 60
pillar = (
    cq.Workplane("XY")
    .center(0, -BASE_WIDTH/2 + 40)
    .box(STRUT_WIDTH, STRUT_THICK, pillar_h, centered=(True, True, False))
    .translate((0, 0, BASE_THICK/2))
)
pillar_left  = pillar.translate((-PANEL_WIDTH/2 + 20, 0, 0))
pillar_right = pillar.translate((PANEL_WIDTH/2 - 20, 0, 0))

base_assembly = base.union(pillar_left).union(pillar_right)

# ----------------------------------------------------------------------
# 2. Adjustable strut (angle-setting arm with notch holes)
# ----------------------------------------------------------------------
import math
strut_len = 220
strut = (
    cq.Workplane("XY")
    .box(STRUT_THICK, strut_len, STRUT_WIDTH, centered=(True, False, True))
)
notches = list(range(TILT_MIN, TILT_MAX + 1, TILT_STEP))
for i, ang in enumerate(notches):
    y = 40 + i * 20
    strut = strut.faces(">Z").workplane(centerOption="CenterOfBoundBox").pushPoints(
        [(0, y - strut_len/2)]
    ).hole(4)

hinge_pivot = (BASE_LENGTH/2 - 60, -BASE_WIDTH/2 + 40, BASE_THICK/2 + pillar_h)

# ----------------------------------------------------------------------
# 3. PV panel with frame + simplified cell grid (engraved grooves)
# ----------------------------------------------------------------------
panel_core = (
    cq.Workplane("XY")
    .box(PANEL_LENGTH, PANEL_WIDTH, PANEL_THICK)
)

frame_outer_l = PANEL_LENGTH + 2 * FRAME_BORDER
frame_outer_w = PANEL_WIDTH + 2 * FRAME_BORDER
frame = (
    cq.Workplane("XY")
    .box(frame_outer_l, frame_outer_w, FRAME_DEPTH)
    .faces(">Z")
    .workplane()
    .rect(PANEL_LENGTH, PANEL_WIDTH)
    .cutBlind(-FRAME_DEPTH + PANEL_THICK)
)

panel_with_frame = frame.union(
    panel_core.translate((0, 0, (FRAME_DEPTH - PANEL_THICK) / 2))
)

# engrave a simple cell grid on the front face (visual only, 6x10 cells)
cols, rows = 6, 10
cell_w = PANEL_LENGTH / cols
cell_h = PANEL_WIDTH / rows
grid = panel_with_frame.faces(">Z").workplane()
grid_lines = cq.Workplane("XY")
for c in range(1, cols):
    x = -PANEL_LENGTH/2 + c * cell_w
    grid_lines = grid_lines.union(
        cq.Workplane("XY").center(x, 0).box(0.6, PANEL_WIDTH, 0.5)
    )
for r in range(1, rows):
    y = -PANEL_WIDTH/2 + r * cell_h
    grid_lines = grid_lines.union(
        cq.Workplane("XY").center(0, y).box(PANEL_LENGTH, 0.6, 0.5)
    )
grid_lines = grid_lines.translate((0, 0, FRAME_DEPTH/2 + 0.25))
panel_final = panel_with_frame.cut(grid_lines)

# mount panel at tilt angle, hinged at the pillar tops
panel_final = (
    panel_final
    .rotate((0, -frame_outer_w/2, 0), (1, -frame_outer_w/2, 0), -TILT_ANGLE_DEG)
    .translate((0, -BASE_WIDTH/2 + 40, BASE_THICK/2 + pillar_h + FRAME_DEPTH/2))
)

# ----------------------------------------------------------------------
# 4. Sensor mounting arms (pyranometer + thermocouple clip)
# ----------------------------------------------------------------------
pyranometer_arm = (
    cq.Workplane("XY")
    .box(SENSOR_ARM_W, SENSOR_ARM_LEN, STRUT_THICK)
    .translate((PANEL_LENGTH/2 + 40, -BASE_WIDTH/2 + 100, BASE_THICK/2 + 5))
)
pyranometer_head = (
    cq.Workplane("XY")
    .cylinder(15, 20)
    .translate((PANEL_LENGTH/2 + 40, -BASE_WIDTH/2 + 100 + SENSOR_ARM_LEN/2, BASE_THICK/2 + 15))
)

thermocouple_clip = (
    cq.Workplane("XY")
    .box(10, 4, 15)
    .translate((0, -BASE_WIDTH/2 + 60, BASE_THICK/2 + pillar_h + FRAME_DEPTH + 3))
)

# ----------------------------------------------------------------------
# 5. Assemble & export
# ----------------------------------------------------------------------
assembly = (
    base_assembly
    .union(panel_final)
    .union(pyranometer_arm)
    .union(pyranometer_head)
    .union(thermocouple_clip)
)

cq.exporters.export(assembly, f"{OUT_DIR}/pv_test_bench.step")
cq.exporters.export(assembly, f"{OUT_DIR}/pv_test_bench.stl")
cq.exporters.export(panel_final, f"{OUT_DIR}/pv_panel.step")
cq.exporters.export(base_assembly.union(pillar_left).union(pillar_right), f"{OUT_DIR}/tilt_frame.step")

print("Exported CAD files to", OUT_DIR)
