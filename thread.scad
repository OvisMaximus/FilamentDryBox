module end_of_customizer_parameters_NOP(){};
$fn=40;
/*
 * Constants for selection of functionality
 */

// selection of threading family
METRIC_ISO=0;
SAW=1;
THREADING_TYPE_NAMES = ["SAW", "METRIC_ISO"];


// inside or outside threading
BOLT=false;
NUT=true;

// --------------- metric ISO definition ----------------
/*
 *   * the shape is defined in a rectangle with height H and pitch P each set to 1
 *   * shapes don't have to cover the full pitch
 *   * for outside threads on bolts H==1 equals the thread diameter e.g. the 5 in M5.
 */
ISO_POINTS = [
    [0,1],
    [1/6,1],
    [7/8,11/16],
    [7/8,9/16],
    [1/6,1/4],
    [1/6,0],
    [0,0]
];

function iso_H_by_P(P) = sqrt(3)/2*P;
ISO_PROPERTIES_BY_DIAMETER = [
// Diameter (D,d), Pitch(P)
    [1,0.25],
    [1.2,0.25],
    [1.4,0.3],
    [1.6,0.35],
    [1.8,0.35],
    [2,0.4],
    [2.5,0.45],
    [3,0.5],
    [3.5,0.6],
    [4,0.7],
    [5,0.8],
    [6,1],
    [7,1],
    [8,1.25],
    [10,1.5],
    [12,1.75],
    [14,2],
    [16,2],
    [18,2.5],
    [20,2.5],
    [22,2.5],
    [24,3],
    [27,3],
    [30,3.5],
    [33,3.5],
    [36,4],
    [39,4],
    [42,4.5],
    [45,4.5],
    [48,5],
    [52,5],
    [56,5.5],
    [60,5.5],
    [64,6],
    [68,6]
];

function iso_standardize_diameter_map(properties) = [
    properties,
    [for(prop=properties)
        [ prop[0], iso_H_by_P(prop[1]) ]]
];

// --------------- metric saw definition ----------------

SAW_POINTS = [
    [0,0],
    [0.8,0.5],
    [0,0.5]
];

/*
 * Shape definitions - the profile of the threading.
 * The profiles are standardized: 
 *   * every thread has a shape
 *   * every thread has a map [diameter => properties] 
 */
ISO_DESCRIPTION=[ISO_POINTS, iso_standardize_diameter_map(ISO_PROPERTIES_BY_DIAMETER)];
SAW_DESCRIPTION=[SAW_POINTS];//todo

THREADING_DESCRIPTION = [
    ISO_DESCRIPTION,
    SAW_DESCRIPTION
];

/* ==================== */
tolerance_value=0.2;
cad=0.001;

/*
 * get_properties(description_id) - get the properties from a threading type (see above)
 * get_P(properties, D) - get pitch for a given diameter
 * get_H(properties, D) - get profile height
 * get_shape(properties, D) - get the shape points for the given diameter
 */
function get_property_maps(threading_type) = THREADING_DESCRIPTION[threading_type][1];
function get_P(property_maps, D) = 
    assert(!is_undef(property_maps))
    assert(!is_undef(D))
    lookup(D, property_maps[0]);
function get_H(property_maps, D) = lookup(D, property_maps[1]);
function get_shape(threading_type, D) = 
    assert(threading_type > -1)
    assert(threading_type < 2)
    assert(D > 0)
    assert(D < 100)
    let(
        shape = THREADING_DESCRIPTION[threading_type][0],
        property_maps = get_property_maps(threading_type),
        p=get_P(property_maps, D),
        h=get_H(property_maps, D))
    assert(!is_undef(shape))
    assert(!is_undef(property_maps))
    assert(!is_undef(p))
    assert(!is_undef(h))
    scale_shape(shape, p, h);

function scale_shape(shape, P, H) = [for(point=shape) [point.x*H, point.y*P]];
function max_x(points, i=0, maxx=0) = 
    let(x=(is_undef(points[i].x)? 0 : points[i].x),current_max= x > maxx? x : maxx)
    len(points) > i? max_x(points, i+1, current_max) : current_max;

module helix(height, radius, threading_pitch, points) {
    stepsPerRound=$fn==0?12:$fn;
    rounds=height/threading_pitch;
    anglePerStep=360/stepsPerRound;
    pitchPerStep=threading_pitch/stepsPerRound;
    steps=round(rounds*stepsPerRound);

    function angle(step) = (step%stepsPerRound)*anglePerStep;
    function transpose_to_xz(points,pos) = [for(point=points)[point.x+pos.x, 0,point.y+pos.y]];
    function rotate_and_pitch_surface(points,angle,pitch) = [for(point=points)
        [cos(angle)*point.x, sin(angle)*point.x,  point.z+pitch]
    ];
    function calculate_faces(num_points_of_shape) = [
         [for(i=[0:num_points_of_shape-1]) i], //front
         [for(i=[num_points_of_shape-1:-1:0]) i+num_points_of_shape], //back
         for(i=[0:num_points_of_shape-1]) [     //sides
             i, 
             i+num_points_of_shape, 
            (i+1)%num_points_of_shape+num_points_of_shape, 
            (i+1)%num_points_of_shape]
         
    ];
    points_on_xz = transpose_to_xz(points, [radius-cad, 0, 0]);
    faces = calculate_faces(len(points)); 
         
    for(step=[0:steps]) {
        next=step+1;
        angle=angle(step)-cad;
        angle_next=angle(next)+cad;
        points_close_face = 
            rotate_and_pitch_surface(points_on_xz, angle, step*pitchPerStep);
        points_far_face = 
            rotate_and_pitch_surface(points_on_xz, angle_next, (step+1)*pitchPerStep);
        polyhedron(concat(points_close_face, points_far_face), faces,2);
    }
}

module threading(shape, diameter, length, pitch) {
    threading_length = length + 2*pitch;
    profile_depth = max_x(shape);
    core_diameter = diameter-2 * profile_depth;
    radius = core_diameter / 2;
        
    echo("diameter: ", diameter);

    intersection(){
        union() {
            translate([0,0,-pitch])
                helix(threading_length, radius, pitch, shape);
            cylinder(threading_length, d=core_diameter, center=false);
        }
        cylinder(length,d=diameter,center=false);
    }
}

module screw_body(
        threading_diameter=20,
        threading_length=10,
        usage=BOLT,
        threading_type=METRIC_ISO
) {
    tolerance = usage==NUT? +tolerance_value:-tolerance_value;
    threading_property_maps = get_property_maps(threading_type);
    threading_shape=get_shape(threading_type, threading_diameter);
    assert( !( is_undef(threading_property_maps) || is_undef(threading_shape)) , 
        str("No definition for ", THREADING_TYPE_NAMES[threading_type], 
                " thread with diameter ", threading_diameter));
    diameter = threading_diameter + tolerance;
    pitch = get_P(threading_property_maps, threading_diameter);
    if (usage==NUT)
        translate([0,0,-threading_length])
            threading( threading_shape, diameter, threading_length, pitch);
    else
        threading( threading_shape, diameter, threading_length, pitch);
}

module debugging_scale() {
    for(i=[-10:10]){
        translate([0, i, -0.05])
            color("CornflowerBlue")
                cube([0.1, 0.1, 0.1]);
    }
}

//debugging_scale();
//screw_body(68,18);
