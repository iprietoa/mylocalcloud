include <BOSL2/std.scad>
include <BOSL2/attachments.scad>
include <utils.scad>
use <slash.scad>
include <localcloud_cfg.scad>

//TODO: Clean code to use BOSL2 in all its glory

module front_cover(width, height, cover_thickness) {

cover_notch_width= width/PHI;
cover_molding_width= cover_thickness*4; //both sides
cover_molding_height= cover_thickness*6;

union() {
 
    
    cube([width, height,cover_thickness], anchor=CENTER) {
        #color("red") mirror_copy(RIGHT) left(width/4) down(cover_thickness/2) align(FWD, inside=true)
            sphere(d=cover_thickness, anchor=CENTER); // lower slashes
    
        back(height/2 - 20) up(cover_thickness) 
            xcyl(l=cover_notch_width, d=cover_thickness, anchor=TOP); // cover notch so the cover can be slided up easily
    up(cover_thickness) _front_cover_logo(width, height, cover_thickness);
      }
  }
 
}


module _front_cover_logo(width, height, cover_thickness) {
 
    linear_extrude(height=cover_thickness,center=true,convexity = 200) 
        import("logo.svg", center = true, dpi = width/PHI, $fn=100);
    fwd(height/2/PHI)
        text3d("My Local Cloud", h=cover_thickness, size=18, font="Helvetica",anchor=CENTER);
        
}

module back_cover(size, 
                 cover_thickness,
                 fan_size,
                 s_p_size,  
                 s_p_pos,
                 atx_size, 
                 anchor=CENTER,
                 spin=0,
                 orient=TOP){
    
    attachable(anchor,spin,orient, size) {
   
        diff("eliminar") 
          cube([size.x, size.y,cover_thickness], anchor=CENTER) {
            cube([size.x-cover_thickness*2 - $clearance, 
                  size.y-cover_thickness*2 - $clearance,
                  cover_thickness], 
                    anchor=TOP);
             tag("eliminar") face_mask(TOP) {
               // fan hole
               fwd(size.y/4) 
                align(BACK, inside=true) 
                    cube([fan_size.x-10, fan_size.y-10,cover_thickness*3],  anchor=CENTER); 
               //atx s&p hole
               back(s_p_pos.y + cover_thickness) 
                left((size.x - atx_size.x)/2) //TODO: centralice pos calculations
                    left(s_p_pos.x + cover_thickness) 
                        align(RIGHT,FRONT, inside=true) 
                            cube(s_p_size,  anchor=CENTER); 
                
                }
           }; children();
     }
    
}
 
module back_cover_holes(hole_lenght, 
      hole_diameter, 
      hole_left_pos,
      num_holes, 
      hole_distrib_length,
      cover_thickness) {
        echo(hole_lenght, hole_diameter, num_holes, hole_distrib_length,cover_thickness);
           //Screw holes
          color("red") 
           mirror_copy(RIGHT) 
           align(LEFT,CENTER,inside=true)  
            ycopies(n=num_holes, l=hole_distrib_length) //TODO: centralize calcs
                down(cover_thickness) 
                    right(hole_left_pos) 
                        cylinder(h=hole_lenght,
                                d=hole_diameter,
                                anchor=CENTER);
}



diff("back_holes")
back_cover($lc_case_dimensions, 
           $global_thickness,
           $lc_main_fan_size,
           $atx_s_p_size,
           $atx_s_p_ps, 
           $atx_size) {
                 tag("back_holes")    
                 back_cover_holes(50, 
                                $back_screws_internal_diameter, 
                                $back_screws_height + $global_thickness,
                                $num_back_screws, 
                                $back_screws_distrib_length,
                                $global_thickness);
            }
                           
//         
//                