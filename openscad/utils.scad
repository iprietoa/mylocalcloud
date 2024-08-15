include <BOSL2/std.scad>
include <BOSL2/fnliterals.scad>


AXIS_MAP = hashmap(items=[["X",TOP],["Y",TOP],["Z",FWD]]);
AXIS_FACE_MASK = hashmap(items=[["Z",[LEFT,RIGHT]],["Y",[FRONT,BACK]],["X",[TOP,DOWN]]]);

// true iff axis is "X" or "Y" or "Z", false otherwise.
function is_axis(axis) = (axis=="Z" || axis=="Y" || axis=="X");

function get_orient(axis) = AXIS_MAP(axis);

function get_split_faces(axis) = AXIS_FACE_MASK(axis); 