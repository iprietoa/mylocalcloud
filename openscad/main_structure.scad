include <BOSL2/std.scad>
include <BOSL2/walls.scad>
include <BOSL2/sliders.scad>

use <front_back_covers.scad>


module main_structure(width=180, height=388.5, depth=135, thickness=5, atx_height=86, num_acrylic_frames=7, inter_acrylic_frame=30, acrylic_frame_width=117, acrylic_frame_height=86) {


union() {
    linear_extrude(height=depth) 
        union() { 
            difference() { 
                offset(r=5)  square([width, height],center=true); 
                offset(r=0)  square([width, height],center=true); 
            }       
        }
        translate([0, (-(height/2) + atx_height)], ) hex_panel([width, depth, thickness], strut=1.5, spacing=10, orient=BACK, anchor=BACK);
       // screw anchors
       for(j=[0:1:2]) {
               x=-(width/2) + 10; 
               y=(height/2 - 10) - j*(height/2 - 10);
               echo("x,y:",x,y);
               translate([x,y,thickness]) rotate([0,0,0]) rotate([0,0,-90]) _back_cover_screw_anchor();
               mirror([1,0,0]) translate([x,y,thickness]) rotate([0,0,0]) rotate([0,0,-90]) _back_cover_screw_anchor();
            }
            
        initial_y=-atx_height+ 20;
        step=inter_acrylic_frame;
        final_y=initial_y + num_acrylic_frames*step;
        for(y=[initial_y:step:final_y]) {
           translate([-width/2, y, depth/2 ]) slider(l=acrylic_frame_width+10, base=10, wall=4, $slop=0.2, spin=0, orient=RIGHT);
        }
    }
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

 

main_structure();