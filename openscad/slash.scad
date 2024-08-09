module 2d_slash(width=5, height=15, slash_height=5, slash_width=10) {
  polygon([[0,0],[width,0],[width,(height-slash_height)],[(width+slash_width),height-slash_height],[0,height]]);
}

module slash(x_location, y_location, x_rot, y_rot, z_rot) {
   translate([x_location,y_location,0]) rotate([x_rot,0,0]) rotate([0,y_rot,0]) rotate([0,0,z_rot]) color("red") minkowski(convexity = 5) {
        linear_extrude(height = 10) 2d_slash(width=3);
        sphere(2);
    }
}

