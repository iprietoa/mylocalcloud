/*
-   X-PI acryilic frame: 117 x 85 (outer), 90x60 (inner square).  
*/

use <ring_2d.scad>

module pi_frame() {
    
frame_width=95;
frame_height=60;
outer_radius=5;
inner_radius=2;
anchor_width=outer_radius*2;
anchor_height=15;
frame_thickness=2;    
ajuste_extremo=sqrt(outer_radius^2/2); //teorema de pitagoras, obviamente
    echo("ajuste:", ajuste_extremo);
    
linear_extrude(frame_thickness) union() {
    square([frame_width,frame_height]);
    translate([ajuste_extremo*2,ajuste_extremo]) rotate([0,0,135]) extremo_tarjeta_2d(anchor_width,anchor_height,inner_radius);
 
    translate([frame_width,ajuste_extremo*3]) rotate([0,0,-135]) extremo_tarjeta_2d(anchor_width,anchor_height,inner_radius);
   
    translate([ajuste_extremo,frame_height-ajuste_extremo*2]) rotate([0,0,45]) extremo_tarjeta_2d(anchor_width,anchor_height,inner_radius);
   
    translate([frame_width-ajuste_extremo*2,frame_height])  rotate([0,0,-45]) extremo_tarjeta_2d(anchor_width,anchor_height,inner_radius);
    
}  

}

pi_frame();