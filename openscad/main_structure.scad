include <BOSL2/std.scad>
include <BOSL2/walls.scad>
include <BOSL2/sliders.scad>
include <localcloud_cfg.scad>
use <front_back_covers.scad>

 

module main_structure(case_size=[1,1,1], thickness=5, atx_size=[1,1,1], num_acrylic_frames=7, inter_acrylic_frame=35, af_size=[117,5,85]) {

union() {
    linear_extrude(height=case_size.y) 
        union() { 
            difference() { 
                offset(r=5)  square([case_size.x, case_size.z],center=true); 
                offset(r=0)  square([case_size.x, case_size.z],center=true); 
            }       
        }
        translate([0, (-(case_size.z/2) + atx_size.z + thickness/2)]) hex_panel([case_size.x, case_size.y + $clearance*2, thickness], strut=1.5, spacing=10, orient=BACK, anchor=BACK);
       // screw anchors
       screw_x=-(case_size.x/2) + 10; 
       for(j=[0:1:3]) {

               screw_y=(case_size.y/2 - 10) - j*(case_size.y/2 - 10);
               echo("screw_x,screw_y:",screw_x,screw_y);
               translate([screw_x,screw_y,thickness]) rotate([0,0,0]) rotate([0,0,-90]) _back_cover_screw_anchor();
               mirror([1,0,0]) translate([screw_x,screw_y,thickness]) rotate([0,0,0]) rotate([0,0,-90]) _back_cover_screw_anchor();
            }
 
        //sliders for xPIs acrylic cluster plates + right wall
        _af_sliders_and_wall(case_size=case_size, af_size=af_size, atx_size=[0,0,atx_size.z], num_afs=num_acrylic_frames, inter_af_length=inter_acrylic_frame, thickness=thickness); 
        _atx_sliders(case_size=case_size, atx_size=atx_size, thickness=5);      
       _usb_power_delivery(case_size=case_size, atx_size=atx_size);
    }
}
 
module _af_sliders_and_wall(case_size=[1,1,1], af_size=[1,1,1], atx_size=[1,1,1], num_afs=1, inter_af_length=1, thickness=5 ) {

        initial_y=-atx_size.z + 20;
        step=inter_af_length; 
        final_y=initial_y + num_afs*(step-1);  

        x_sliders_left=-case_size.x/2; 
        x_sliders_right=x_sliders_left + af_size.z + thickness*2; //TODO: requires clearance
        
        for(y=[initial_y:step:final_y]) {
           translate([x_sliders_left, y, case_size.y/2 ]) slider(l=af_size.x+10, w=thickness*2.1, base=thickness, wall=4, $slop=0.2, spin=0, orient=RIGHT);
           translate([x_sliders_right, y, case_size.y/2 ]) slider(l=af_size.x+10,  w=thickness*2.1, base=thickness, wall=4, $slop=0.2, spin=0, orient=LEFT);
        } 
        x_sliders_wall=x_sliders_right; //xpos of the wall supporting righet af sliders.
        height_sliders_wall= case_size.z - atx_size.z;
       color("brown") translate([x_sliders_wall, atx_size.z/2, case_size.y/2]) sparse_cuboid([thickness*2,height_sliders_wall,case_size.y-50], strut=1);

}

module _atx_sliders(case_size=[1,1,1], atx_size=[1,1,1], thickness=5) {
  x1=-atx_size.x/2;
  x2=x1 + thickness + atx_size.x + $clearance*2;
  y=-case_size.z/2 - thickness;
  z=case_size.y/2 - thickness*6;
  echo ("_atx_sliders dimensions: x1:[",x1,"], x2:[",x2,"], y:[", y,"], z:[", z);
  union() {
    translate([x1, y, z]) cube([thickness, thickness*2,atx_size.z+thickness]);
    translate([x2, y, z]) cube([thickness, thickness*2,atx_size.z+thickness]);
    translate([x1, y, z]) rotate([0,90,0]) cube([thickness, thickness*2,atx_size.x+thickness*2]);
   };
  }
 
module _back_cover_screw_anchor(internal_diameter=5) {
   external_diameter=internal_diameter+3;
   screw_length=30;
   difference() {
      union() {
      cylinder(h=screw_length,d=external_diameter);
      translate([-(external_diameter/2),-(external_diameter+internal_diameter/2),0]) cube([external_diameter,10,screw_length]);
      }
      cylinder(h=screw_length,d=internal_diameter);
   };
}

module _usb_power_delivery(case_size,atx_size) {
   dimensions=[90+$global_thickness*2 + $clearance*2, 90+$global_thickness*2+$clearance*2, 10];
   atx_plug_dimensions=60;
    
  right(dimensions.x/2-$global_thickness) left(case_size.x/2) back(-case_size.z/2 + atx_size.z+$global_thickness*2) up(atx_size.z/2) difference() {
   rect_tube(h=dimensions.z,size=[dimensions.x, dimensions.y],wall=$global_thickness,rounding1=5, anchor=FWD, orient=FWD);
   cube(dimensions-[20,0,0], anchor=FWD, orient=FWD);
   }
}
  

main_structure(case_size=[200,200,420], thickness=5, atx_size=[150,160,86], num_acrylic_frames=8, inter_acrylic_frame=35, af_size=[117,5,85]);