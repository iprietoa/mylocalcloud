/*
  Main design file of the cloud case.
  
- Size of plastic plates where xPIs are mounted: 117mm x 85mm. 

- Distance between plates: 25mm

- Fans: 120mm x 120mm x 25mm, from 6v a 12V PWM PST

- ATX Antec HCG - 620M : 150mm x 160mm x 86mm (width, depth and height)

- 3 Rock5+ -> 100 x 72 mm

*/

include <BOSL2/std.scad>
include <BOSL2/sliders.scad>
include <localcloud_cfg.scad>
use <slash.scad>
use <front_back_covers.scad>
use <main_structure.scad>



/* ATX Power supply dimenssions. TODO: replace with  selectable standar PSU sizes */
atx_dimensions=[150,160,86];

/* Power splitter from ATX to 8 molex ports */
ps_dimensions=[90,90,17];

back_cover_screw_holders_width=15;
back_cover_screw_diameter=4;  

//af == acrylic frame
af_dimensions=[117,5,85];
num_afs=8;
inter_afs_distance=35; 

base_dimensions=[atx_dimensions.x + $clearance*2 + back_cover_screw_holders_width*2,
                atx_dimensions.y + 50,
                atx_dimensions.z  + $clearance*2 + inter_afs_distance*num_afs + 50];

 
$fn=100;
 
/* Of course, not to be printed */
/* Of course, not to be printed */
module atx_power_supply() {
  cube(atx_dimensions,anchor=FRONT,    orient=FRONT);
}

module power_delivery(size) {
  
}

  
!main_structure(case_size=base_dimensions, thickness=$global_thickness, atx_size=atx_dimensions, num_acrylic_frames=num_afs, inter_acrylic_frame=inter_afs_distance, af_size=af_dimensions);
 
 
 color("green") translate([0,(-base_dimensions.z/2) + atx_dimensions.z/2,115]) atx_power_supply();

%translate([0,0,base_dimensions.y+100]) color("blue") front_cover(base_dimensions.x, base_dimensions.z, $global_thickness); 

%translate([0,0,-base_dimensions.y+100]) color("magenta") back_cover(base_dimensions.z, base_dimensions.z, $global_thickness, back_cover_screw_diameter);