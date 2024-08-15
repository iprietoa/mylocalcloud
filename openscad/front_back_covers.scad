include <BOSL2/std.scad>
include <utils.scad>
use <slash.scad>

//TODO: Clean code to use BOSL2 in all its glory

module front_cover(width, height, cover_thickness) {

cover_notch_width= width/PHI;
cover_molding_width= cover_thickness*4; //both sides
cover_molding_height= cover_thickness*6;

union() {
 
    difference() {
        cube([width, height,cover_thickness], center=true); //main cover
        back(height/2 - 20) up(cover_thickness) 
            xcyl(l=cover_notch_width, d=cover_thickness, anchor=TOP); // cover notch so the cover can be slided up easily
    } 
    down(cover_thickness) 
        cube([width-cover_molding_width, height-(cover_thickness*6),cover_thickness], center=true); //inner cover
   
   translate([width/3,-height/2+cover_thickness,-2*cover_thickness/3]) sphere(d=cover_thickness); // lower slashes
   translate([-width/3,-height/2+cover_thickness,-2*cover_thickness/3]) sphere(d=cover_thickness);
    up(cover_thickness) _front_cover_logo(width, height,cover_thickness);
  }
 
}

module _front_cover_logo(width, height, cover_thickness) {
union() {
    linear_extrude(height=cover_thickness,center=true,convexity = 200) 
        import("logo.svg", center = true, dpi = width/PHI, $fn=100);
    fwd(height/2/PHI)
        text3d("My Local Cloud", h=cover_thickness, size=18, font="Helvetica",anchor=CENTER);
}

}

module _back_cover_without_screws(width, height, cover_thickness, screw_diameter){
  switch_power_width=50;
  switch_power_height=35;
  switch_power_desplazamiento_x=10-cover_thickness; //from the right
  switch_power_desplazamiento_y=24-cover_thickness; //from below 
  fan_side=120;
  
difference() {
    union() {
      cube([width, height,cover_thickness], center=true);
      translate([0,0,-cover_thickness]) cube([width-cover_thickness, height-cover_thickness,cover_thickness], center=true);
    }
    translate([0,75]) cube([fan_side-10, fan_side-10,cover_thickness*3], center=true);
    x=width/2 - switch_power_width ;
    y=-height/2  + switch_power_height;
    translate([x,y]) cube([switch_power_width, switch_power_height, cover_thickness*3],center=true);
}
   
}

module back_cover(width, height, cover_thickness, screw_diameter){

difference() {
   _back_cover_without_screws(width, height, cover_thickness, screw_diameter);
   hole_depth=cover_thickness*2;
    for(j=[0:1:2]) {
               x=-(width/2) + 10; 
               y=(height/2 - 10) - j*(height/2 - 10);
               echo("x,y:",x , y );
               translate([x,y,0]) cylinder(h=hole_depth*2,d=screw_diameter,center=true);
               mirror([1, 0, 0]) translate([x,y,0]) cylinder(h=hole_depth*2,d=screw_diameter,center=true);
     }
  }
}

 front_cover(180, 300, 5);