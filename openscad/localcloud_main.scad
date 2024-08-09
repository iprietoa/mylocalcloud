/*
  Main design file of the cloud case.
  
- Size of plastic plates where xPIs are mounted: 117mm x 85mm. 

- Distance between plates: 25mm

- Fans: 120mm x 120mm x 25mm, from 6v a 12V PWM PST

- ATX Antec HCG - 620M : 150mm x 160mm x 86mm (width, depth and height)

*/

include <BOSL2/std.scad>
include <BOSL2/sliders.scad>

use <slash.scad>
use <front_back_covers.scad>
use <main_structure.scad>

clearance=0.3; // global clearance
global_thickness=5; // global thickness

atx_width=150;
atx_depth=160;
atx_height=86;

back_cover_screw_holders_width=15;
back_cover_screw_diameter=4;  

base_width=atx_width + clearance*2 + back_cover_screw_holders_width*2;  
base_height=atx_height  + clearance*2 + 178 + 50; // altura de la fuente ATX + Altura torre + clearance para cables y placas adicionales, como le distribuidor de potencia. 
base_depth= atx_depth + 50; // profundidad dede la fuente + 50mm de espacio para pasar cables
 
$fn=100;
 
/* Of course, not to be printed */
module atx_power_supply() {
  cube([atx_width,atx_height,atx_depth], center=true);
}


module frame_sliders(frame_thickness=2) {
  slider(l=30, base=10, wall=4, $slop=0.2, spin=90);
}

 

!difference() {
main_structure(width=base_width, height=base_height, depth=base_depth, thickness=global_thickness, atx_height=atx_height);
translate([0,0,base_depth]) front_cover(base_width, base_height, global_thickness);
}
color("green") translate([0,(-base_height/2) + atx_height/2,115]) atx_power_supply();

translate([0,0,base_depth+100]) color("blue") front_cover(base_width, base_height, global_thickness);

translate([0,0,-base_depth+100]) color("magenta") back_cover(base_width, base_height, global_thickness, back_cover_screw_diameter);