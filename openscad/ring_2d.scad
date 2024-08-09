/*
 TODO: Replace this modules with proper BOSL2 modules.

*/

module anilla_2d(radio_exterior=10, radio_interior=5) {

    difference(){
        circle(radio_exterior,  );
        circle(radio_interior,  );
    }
}

module extremo_tarjeta_2d(ancho=5, alto=10, radio_interior=1) {
    radio_exterior=ancho/2;
    union() {
      difference() {
        square([ancho, alto]);
        translate([radio_exterior, alto]) circle(radio_exterior, $fn=100);
      }
      translate([radio_exterior, alto]) anilla_2d(radio_exterior, radio_interior);
    }
}

extremo_tarjeta_2d();
