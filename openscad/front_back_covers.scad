include <BOSL2/std.scad>
use <slash.scad>

module front_cover(width, height, cover_thickness) {

union() {
 linear_extrude(height=cover_thickness) 
 
     square([width, height], center=true);

     // slahes on the cover
    for(i=[-1:1:1]) {
      x=-width/2 + cover_thickness; 
      y=i*100 + 5;

       slash(x, y,-90,180,0);
       mirror([1,0,0]) slash(x, y,-90,180,0);
    }

    for(j=[-1:1:1]) {
      x=(width*j/3) + 5; 
      y=height/2 - 5;
       
      slash(x, y,-90,-90,0);
      mirror([0,1,0]) slash(x, y,-90,-90,0);
    }
    
   translate([0,0,0]) _front_cover_logo();
  }
}

module _front_cover_logo() {
union() {
linear_extrude(height=20,center=true,convexity = 200) import("logo.svg", center = true, dpi = 150, $fn=50);
translate([0,-80,0]) text3d("My Local Cloud", h=20, size=18, font="Helvetica",anchor=CENTER);
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

