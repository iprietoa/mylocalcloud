use <front_back_covers.scad>
use <front_back_covers.scad>


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
    
    partition([500,500,500],spread=60, cutsize=60, cutpath="flat")  front_cover(200, 400, 10);
