include <BOSL2/std.scad>
include <BOSL2/walls.scad>
include <BOSL2/sliders.scad>
include <localcloud_cfg.scad>
use <front_back_covers.scad>

/*
  Return dimension of an af slider as a vector of l, w and h, as specified on https://github.com/BelfrySCAD/BOSL2/wiki/sliders.scad#module-slider
 */
function _get_af_slider_size(af_size) = [af_size.x + 10, $global_thickness*2.1, $global_thickness*2];
 
 

module main_structure(case_size=[1,1,1], 
                    thickness=$global_thickness, 
                    atx_size=$atx_size, 
                    num_back_screws=$num_back_screws,
                    back_screws_height=$back_screws_height,
                    num_acrylic_frames=$num_afs, 
                    inter_acrylic_frame=$inter_af_space, 
                    pd_pcb_size=$power_delivery_pcb_size,
                    af_size=$af_dimensions, anchor=CENTER, spin, orient=TOP) {
                    
    case_min_size=[atx_size.x + thickness*2, 
                   atx_size.y + num_acrylic_frames*inter_acrylic_frame + 2*thickness,
                   atx_size.z + back_screws_height + thickness*2];
    
    echo("Case dimensions: w, h, d:", case_size.x, case_size.y, case_size.z);           

    assert(case_size.x/2 - thickness*2 >= pd_pcb_size.x, str("Power delivery PCB cannot fix!!:",case_size.x/2 - thickness*2, ">",pd_pcb_size.x));              
    assert(case_size.x >= case_min_size.x, "Case width too small");
    assert(case_size.y >= case_min_size.y, str("Case height is too short for num_acrylic_frames:", num_acrylic_frames, ". At least ",case_min_size.y, " is required but get ", case_size.y));
    assert(case_size.z >= case_min_size.z, "Case depth too small");
    
    attachable(anchor,spin,orient, size=case_size) {
        union() {
     rect_tube(h=case_size.z, size=[case_size.x, case_size.y], wall=thickness, center=true){
       // child -1: front door sliders
        mirror_copy(RIGHT) align(LEFT,TOP, inside=true) 
         xrot(90) back(thickness) up(thickness) 
         slider(l=case_size.y, w=thickness, h=thickness, base=thickness, wall=$front_slider_wall, 
                               spin=0, 
                               orient=RIGHT, 
                               anchor=LEFT);
       // child 0: atx top
       *back(atx_size.y + $global_thickness + $clearance*2)  
        align(CENTER,FRONT,inside=true) 
            hex_panel([case_size.x, case_size.z - 4*$global_thickness, $global_thickness], 
                    strut=1.5, 
                    spacing=10, 
                    orient=BACK, 
                    anchor=CENTER) {
                      left($power_delivery_pcb_size.x/2) 
                        align(TOP,CENTER)  
                            _usb_power_delivery(size=$power_delivery_pcb_size);
                    }
                    
         // child 1: back screws
         mirror_copy(RIGHT) align(LEFT,BOT,inside=true)  
            ycopies(n=num_back_screws, l=$back_screws_distrib_length)
                up(thickness) 
                    right(back_screws_height) 
                        zrot(-90) 
                        _back_cover_screw_anchor();
            //child 3: af sliders
            assert(inter_acrylic_frame*(num_acrylic_frames - 1) <= case_size.y-atx_size.y, 
                    str("Too many af sliders",num_acrylic_frames, ":", 
                        inter_acrylic_frame*(num_acrylic_frames - 1), 
                        " is > than ", case_size.y-atx_size.y));
            slider_l = _get_af_slider_size(af_size) [0];
            slider_w = _get_af_slider_size(af_size) [1];
            slider_h = _get_af_slider_size(af_size) [2];
           * xflip_copy(RIGHT, -case_size.x/4) 
                back(atx_size.y*2) align(LEFT,FWD,inside=true) 
                    ycopies(n=num_acrylic_frames, spacing=inter_acrylic_frame)
                        slider(l=slider_l, w=slider_w, h=slider_h, base=thickness, wall=thickness, 
                               spin=0, 
                               orient=RIGHT, 
                               anchor=FWD);
           //child 4: sliders wall (sw)
           sw_w=thickness*1.5;
           sw_h=case_size.y-atx_size.y-thickness*2;
           sw_d=case_size.z-thickness*2;
           *align(CENTER,BACK)color("brown") sparse_cuboid(size=[sw_w,sw_h,sw_d], strut=1);            
           //child 5: ATX guides
           mirror_copy(RIGHT) 
               left(atx_size.x/2 + $clearance + thickness/2)
                   back(thickness) 
                    align(FWD,CENTER, inside=true) 
                        color("brown") 
                            cube([thickness, thickness, case_size.z - 2*thickness],anchor=CENTER);
               
      }
            
    }; children();
   }
}

 
 
 module _back_cover_screw_anchor(screw_length=$back_screws_lenght, 
                                 screw_height=$back_screws_height,  
                                 screw_width=$back_screws_width, 
                                 internal_diameter=$back_screws_internal_diameter,
                                 anchor=BOT,orient,spin) {
  assert(screw_width>internal_diameter, "Screw socket hole too big!");
  external_diameter=screw_width;
  screw_l=screw_length;
  screw_w=screw_width;
  screw_h=screw_height ;
      attachable(anchor,spin,orient,
                     size=[screw_w, screw_h, screw_l]) {     
              down(screw_length/2) difference() {
                  union() {
                  back(external_diameter/2) cylinder(h=screw_length,d=external_diameter);
                  translate([-(external_diameter/2),-(external_diameter+internal_diameter/2),0]) 
                    back(external_diameter/2) cube([external_diameter,screw_height,screw_length]);
                  }
                  back(external_diameter/2) cylinder(h=screw_length,d=internal_diameter);
               }; children();
        }
}


module _usb_power_delivery(size=[1, 1, 1],anchor=CENTER,spin,orient=UP) {
   
   axt_plug_header_w=60;
   dimensions=[size.x+$global_thickness*2 + $clearance*2, size.y+$global_thickness*2+$clearance*2, size.z];
   assert( (size.x >= axt_plug_header_w), "ATX plug header is < then socket width!");
   
  attachable(size=dimensions, anchor=anchor, spin=spin, orient=orient) {   
    
       difference() {
       rect_tube(h=dimensions.z,size=[dimensions.x, dimensions.y],
            wall=$global_thickness,
            rounding1=$global_thickness, 
            anchor=anchor, 
            orient=orient);
       back($global_thickness) align(FWD) cube([axt_plug_header_w,$global_thickness,$global_thickness], anchor=CENTER, orient=orient);
       } children();
   }
}

 
                
main_structure(case_size=[200,405,200], 
                thickness=5, 
                atx_size=[150,86,160], 
                num_acrylic_frames=8, 
                inter_acrylic_frame=35, 
                af_size=[117,5,85]);