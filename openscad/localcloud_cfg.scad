/////////////// Global params
$clearance=0.2;  
$slop=$clearance; //BOSL2 clearance
$global_thickness=5;  

/////////////// Back cover screws params
$num_back_screws=5;  
assert($num_back_screws>1, "$num_back_screws var must be >1");

$back_screws_width=10;
$back_screws_lenght=30; 
$back_screws_height=10; 
$back_screws_internal_diameter=5;

/////////////// Acrylic frames (or 3D printed frames) params
$num_afs=8;
$af_dimensions=[117,5,85];
$inter_af_space=35;

////////////// Box Splitting params
$num_joiners=3;
$joiner_lenght=20;
$joiner_width=10;

/////////////// ATX Power Supply params
$atx_size=[150,86,160];
$power_delivery_pcb_size=[90,90,5];

/////////////////// End of configurable params



