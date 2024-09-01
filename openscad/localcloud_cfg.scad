/////////////// Global params
$clearance=0.2;  
$slop=$clearance; //BOSL2 clearance
$global_thickness=5;  

/////////////// Back cover screws params
$num_back_screws=5;  //Num back cover screws (one side). Min 2.
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

//////////////FAN params
$lc_main_fan_size=[120,120,25];


/////////////// ATX Power Supply params
$atx_size=[150,86,160];
$atx_s_p_size=[50,35,$global_thickness*3]; //switch and plug
$atx_s_p_ps=[7,30]; //displacement with alignment RIGHT and FRONT. 
$power_delivery_pcb_size=[90,90,5];

/////////////// Front Door Sliders Params
$front_slider_wall=$global_thickness*0.5;

/////////////////// End of configurable params

_base_x_dimension = ($atx_size.x/2 > $power_delivery_pcb_size.x)? $atx_size.x: $power_delivery_pcb_size.x*2;

$lc_case_dimensions=[_base_x_dimension + $clearance*2 + $back_screws_height*2 + $global_thickness*2,
                $atx_size.y + $inter_af_space*$num_afs + $global_thickness*2,
                $atx_size.z  + $clearance*2 +  $global_thickness*2 + $back_screws_lenght];

$back_screws_distrib_length=$lc_case_dimensions.y-$lc_case_dimensions.y/$num_back_screws;
