include <BOSL2/std.scad>
include <BOSL2/walls.scad>
include <BOSL2/wiring.scad>
include <BOSL2/sliders.scad>
include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/fans.scad>
include <NopSCADlib/vitamins/psus.scad>
include <NopSCADlib/printed/fan_guard.scad>

fan(fan120x25);
scale([1.36,1.36,1.36]) psu(ATX300);
!fan_guard(type=fan120x25,  thickness = fan_guard_thickness(), spokes = 4, finger_width = 7, grill = false, screws = true);

union() {
linear_extrude(height=10,center=true,convexity = 200) import("logo.svg", center = true, dpi = 200, $fn=50);
translate([0,-80,0]) text3d("My local cloud", h=10, size=24, font="Helvetica",anchor=CENTER);
}

wire_bundle([[50,0,-50], [50,50,-50], [0,50,-50], [0,0,-50], [0,0,0]], rounding=10, wires=13);
hex_panel([180, 135, 5], strut=1.5, spacing=10, orient=BACK, anchor=CENTER);

slider(l=135, base=10, wall=4, $slop=0.2, spin=0, orient=RIGHT);