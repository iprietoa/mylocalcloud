include <BOSL2/std.scad>
include <BOSL2/walls.scad>
include <BOSL2/wiring.scad>
include <BOSL2/sliders.scad>
include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/fans.scad>
include <NopSCADlib/vitamins/psus.scad>
include <NopSCADlib/printed/fan_guard.scad>
include <BOSL2/joiners.scad>
include <case_splitting.scad>
include <utils.scad>
use <main_structure.scad>

 slider(l=50, w=5, h=5, base=5, ang=15, wall=2.5,                              
                               orient=RIGHT, 
                               spin=90,
                               anchor=LEFT);
*fan(fan120x25);
*scale([1.36,1.36,1.36]) psu(ATX300);
*fan_guard(type=fan120x25,  thickness = fan_guard_thickness(), spokes = 4, finger_width = 7, grill = false, screws = true);

*partition(size=[500,500,0], spread=20, gap=0, cutsize=[20,20], cutpath="flat") cylinder(h=50, d=80, center=false);

$clearance=0.3; // global clearance
$global_thickness=5; // global thickness

base_dimensions=[200,
                400,
                200];
                
atx_size=[150,160,86];
af_size=[117,5,85];
inter_slider_distance=35;
              
joiner_lenght=$global_thickness*4;
joiner_width=$global_thickness*2;
spread=20; 
num_case_joiners=3;
joiner_screw_size=3;
$fn=100;

 *_af_sliders_and_wall(case_size=base_dimensions, af_size=af_size, atx_size=atx_size, num_afs=1, inter_af_length=1, thickness=5 );

module split_case(case_dimensions,num_joiners=3, spread=20) {
    cut_axis="Z";
    partition(size=[500,500,500], spread=spread, gap=0, cutsize=[20,20], cutpath="flat") 
     diff("remove")  rect_tube(l=case_dimensions.z,size=[case_dimensions.x, case_dimensions.y], wall=$global_thickness, center=true) {
      color("green") face_mask(get_split_faces(cut_axis)) {
      if (cut_axis=="Z") {
       orient(FRONT, spin=90)  _split_box_add_joiners(case_dimensions, joiner_lenght, joiner_width, num_joiners=num_joiners, axis=cut_axis);
        } else if (cut_axis=="Y") {
          orient(FRONT, spin=90)  _split_box_add_joiners(case_dimensions, joiner_lenght, joiner_width, num_joiners=num_joiners, axis=cut_axis);
        } else {
          orient(FRONT, spin=90)  _split_box_add_joiners(case_dimensions, joiner_lenght, joiner_width, num_joiners=num_joiners, axis=cut_axis);
        }
        }
    }
}

*split_case(base_dimensions); 
/*
_left_joiners();
mirror([1,0,0]) _left_joiners();
_right_joiners();
mirror([1,0,0]) _right_joiners();
*/
 
/*
union() {
linear_extrude(height=10,center=true,convexity = 200) import("logo.svg", center = true, dpi = 200, $fn=50);
translate([0,-80,0]) text3d("My local cloud", h=10, size=24, font="Helvetica",anchor=CENTER);
}

wire_bundle([[50,0,-50], [50,50,-50], [0,50,-50], [0,0,-50], [0,0,0]], rounding=10, wires=13);
hex_panel([180, 135, 5], strut=1.5, spacing=10, orient=BACK, anchor=CENTER);

slider(l=135, base=10, wall=4, $slop=0.2, spin=0, orient=RIGHT);
*/