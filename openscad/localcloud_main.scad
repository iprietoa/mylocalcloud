/*
  Parametric 3D model case for storing a local cloud cluster of varios PI alike SBCs. Features:
   - ATX powered, using an ATX spliter.
   - Easy to open/close; sliding front door and screwable back door.
 
  All the configurable parameters are in localcloud_cfg.scad file.
  
- Size of plastic plates where xPIs are mounted: 117mm x 85mm. 

- Distance between plates: 35mm

- Fans: 120mm x 120mm x 25mm, from 6v a 12V PWM PST

- ATX Antec HCG - 620M : 150mm x 160mm x 86mm (width, depth and height)

- 3 Rock5+ -> 100 x 72 mm

 
 TODO:
   - Use right area to store SDD and an small ethernet hub. 
  
*/

include <BOSL2/std.scad>
include <BOSL2/sliders.scad>
include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/fans.scad>
use <slash.scad>
use <front_back_covers.scad>
use <main_structure.scad>
use <case_splitting.scad>
include <localcloud_cfg.scad>




$fn=100;
 
 
/* Of course, not to be printed */
module atx_power_supply(size) {
  cube(size,anchor=CENTER,orient=UP);
}
 

cut_axis="Z";
sep_distance=40;

 main_structure(case_size=$lc_case_dimensions, 
                thickness=$global_thickness, 
                atx_size=$atx_size,              
                num_acrylic_frames=$num_afs, 
                inter_acrylic_frame=$inter_af_space, 
                af_size=$af_dimensions) {
                  color("green") 
                    back($atx_size.y + $global_thickness) 
                        align(FWD)
                            atx_power_supply($atx_size);
}
            
back($lc_case_dimensions.y+20) 
    up($lc_case_dimensions.z/2 + $global_thickness) color("blue") 
        front_cover($lc_case_dimensions.x, $lc_case_dimensions.y, $global_thickness); 



down($lc_case_dimensions.z/2 + 50) yrot(180)
        color("magenta") 
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
                                $back_screws_height + $global_thickness -3,
                                $num_back_screws, 
                                $back_screws_distrib_length - 7,
                                $global_thickness);
            }
                           
//                           !up(200) fan(fan120x25);
                           
  