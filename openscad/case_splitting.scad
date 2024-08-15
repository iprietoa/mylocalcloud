include <BOSL2/std.scad>
include <BOSL2/joiners.scad>
include <utils.scad>

///////////////////////////////////////////////////////////////////////////
// Create num_joiners half_joiner_clear masks a containing case. See https://github.com/BelfrySCAD/BOSL2/wiki/joiners.scad#functionmodule-half_joiner_clear
//
// Arguments:
//  case_dimensions -> vector with splitting case dimensions. E.g. [200, 200, 400] for width, depth and height of the box.
//  joiner_lenght -> length of the joiner mask.
//  joiner_width -> width of the joiner mask. 
//  num_joiners -> number of joiners to distribute across both sides of the box
//  axis -> the axis to which aply the mask. Possible values are those of BOSL2 https://github.com/BelfrySCAD/BOSL2/wiki/constants.scad#section-directional-vectors

module _split_box_add_joiners(case_dimensions, joiner_lenght, joiner_width, num_joiners=3, axis=Z) { 

assert(is_axis(axis), "axis param is not 'X', 'Y' or 'Z'"); 
ori = get_orient(axis);
if (axis == "Z") {
tag("remove") zcopies(n=num_joiners, l=case_dimensions.z - case_dimensions.z/5 ) half_joiner_clear(l=joiner_lenght,w=joiner_width, orient=ori);

} else if (axis == "Y") {
tag("remove") ycopies(n=num_joiners, l=case_dimensions.y - case_dimensions.y/5) half_joiner_clear(l=joiner_lenght,w=joiner_width, orient=ori);
} else {
tag("remove") xcopies(n=num_joiners, l=case_dimensions.x - case_dimensions.x/5) half_joiner_clear(l=joiner_lenght,w=joiner_width, orient=ori, spin=90);
}
}

module _left_joiners() {
fwd(joiner_lenght/2) up(base_dimensions.z/4) right($global_thickness/2) left(base_dimensions.y/2) zcopies(n=num_case_joiners, l=base_dimensions.y/2) half_joiner(l=joiner_lenght,w=joiner_width, screwsize=joiner_screw_size,  $slop=$clearance,  orient=BACK);
}
module _right_joiners() {
back(joiner_lenght/2) up(base_dimensions.z/4) right($global_thickness/2) left(base_dimensions.y/2) zcopies(n=num_case_joiners, l=base_dimensions.y/2) half_joiner2(l=joiner_lenght,w=joiner_width, screwsize=joiner_screw_size, $slop=$clearance,  orient=FRONT);
}

