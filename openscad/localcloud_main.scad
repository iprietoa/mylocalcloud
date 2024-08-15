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
include <localcloud_cfg.scad>
use <slash.scad>
use <front_back_covers.scad>
use <main_structure.scad>
use <case_splitting.scad>

  

case_dimensions=[$atx_size.x + $clearance*2 + $back_screws_height*2 + $global_thickness*2,
                $atx_size.y + $inter_af_space*$num_afs + $global_thickness*2,
                $atx_size.z  + $clearance*2 +  $global_thickness*2];
echo("Case dimensions: w, h, d:", case_dimensions.x, case_dimensions.y, case_dimensions.z);           
//assert($case_dimensions.x/2 - $global_thickness*2 > $power_delivery_pcb_size.x, "Power delivery PCB cannot fix!!");

$fn=100;
 
 
/* Of course, not to be printed */
module atx_power_supply() {
  cube(atx_dimensions,anchor=FRONT,    orient=FRONT);
}
 

cut_axis="Z";
sep_distance=40;

partition(size=case_dimensions+[10,10,10], spread=sep_distance, gap=0, cutsize=1, cutpath="flat") 
    diff("borrar")  {
     main_structure(case_size=case_dimensions, 
                    thickness=$global_thickness, 
                    atx_size=$atx_size,              
                    num_acrylic_frames=$num_afs, 
                    inter_acrylic_frame=$inter_af_space, 
                    af_size=$af_dimensions) {
                    #color("green") face_mask(get_split_faces(cut_axis)) 
                         tag("borrar") ycopies(n=$num_joiners, l=(case_dimensions.z - case_dimensions.z/5)) 
                            half_joiner_clear(l=$joiner_lenght,w=$joiner_width, orient=RIGHT);
                    
                    }
    }
 

*color("green") translate([0,(-case_dimensions.z/2) + atx_dimensions.z/2,115]) atx_power_supply();

up(case_dimensions.y+20) color("blue") front_cover(case_dimensions.x, case_dimensions.y, $global_thickness); 

*translate([0,0,-case_dimensions.y+100]) color("magenta") back_cover(case_dimensions.z, case_dimensions.z, $global_thickness, back_cover_screw_diameter);