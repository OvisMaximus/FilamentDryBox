module end_of_customizer_parameters_NOP(){};
$fn=40;
/*
 * Constants for selection of functionality
 * Some threadings have defined multiple pitches for the same diameter.
 * All diameters are in every type defined, but the definitions differ in 
 * the pitch used. E.g.: F1 uses allways the smallest defined pitch, F2 the
 * pitch after the smallest pitch up to F4 which uses the largest available
 * pitch for a given diameter.
 */

// selection of threading family
METRIC_ISO=0;
METRIC_ISO_F1=1;
METRIC_ISO_F2=2;
METRIC_ISO_F3=3;
METRIC_ISO_F4=4;
SAW=2;
THREADING_TYPE_NAMES = [
	"METRIC_ISO", 
	"METRIC_ISO_F1", 
	"METRIC_ISO_F2", 
	"METRIC_ISO_F3", 
	"METRIC_ISO_F4", 
	"SAW"
];

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
ISO_CROASE_PITCH_BY_DIAMETER = [
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


ISO_FINE_PITCH_1_BY_DIAMETER = [
// Diameter (D,d), Pitch(P)
    [1,0.2],
    [1.1,0.2],
    [1.2,0.2],
    [1.4,0.2],
    [1.6,0.2],
    [1.8,0.2],
    [2,0.25],
    [2.2,0.25],
    [2.5,0.25],
    [3,0.25],
    [3.5,0.35],
    [4,0.35],
    [4.5,0.5],
    [5,0.5],
    [5.5,0.5],
    [6,0.5],
    [7,0.5],
    [8,0.5],
    [8,1],
    [9,0.75],
    [10,0.5],
    [10,1],    
    [12,1],
    [14,1],
    [16,1],
    [18,1],
    [20,1.5],
    [22,1.5],
    [24,1.5],
    [27,1.5],
    [30,1.5],
    [33,1.5],
    [36,1.5],
    [39,1.5],
    [42,1.5],
    [45,1.5],
    [48,1.5],
    [52,1.5],
    [56,2],
    [60,2],
    [64,2],
    [68,2],
    [72,2],
    [76,2],
    [76,3],
    [80,3],
    [85,3],
    [90,3],
    [95,4],
    [100,4]
];

ISO_FINE_PITCH_2_BY_DIAMETER = [
// Diameter (D,d), Pitch(P)
    [1,0.2],
    [1.1,0.2],
    [1.2,0.2],
    [1.4,0.2],
    [1.6,0.2],
    [1.8,0.2],
    [2,0.25],
    [2.2,0.25],
    [2.5,0.25],
    [3,0.25],
    [3.5,0.35],
    [4,0.5],
    [4.5,0.5],
    [5,0.5],
    [5.5,0.5],
    [6,0.75],
    [7,0.75],
    [8,0.75],
    [9,0.75],
    [10,0.75],    
    [12,1.25],
    [14,1.25],
    [16,1.5],
    [18,1.5],
    [20,2],
    [22,2],
    [24,2],
    [27,2],
    [30,2],
    [33,2],
    [36,2],
    [39,2],
    [42,2],
    [45,2],
    [48,2],
    [52,2],
    [56,3],
    [60,3],
    [64,3],
    [68,3],
    [72,3],
    [76,3],
    [80,4],
    [85,4],
    [90,4],
    [95,6],
    [100,6]
];

ISO_FINE_PITCH_3_BY_DIAMETER = [
// Diameter (D,d), Pitch(P)
    [1,0.2],
    [1.1,0.2],
    [1.2,0.2],
    [1.4,0.2],
    [1.6,0.2],
    [1.8,0.2],
    [2,0.25],
    [2.2,0.25],
    [2.5,0.25],
    [3,0.25],
    [3.5,0.35],
    [4,0.5],
    [4.5,0.5],
    [5,0.5],
    [5.5,0.5],
    [6,0.75],
    [7,0.75],
    [8,1],
    [9,0.75],
    [10,1],    
    [12,1.5],
    [14,1.5],    
    [16,1.5],
    [18,2],
    [20,2],
    [22,2],
    [24,2],
    [27,2],
    [30,3],
    [33,3],
    [36,3],
    [39,3],
    [42,3],
    [45,3],
    [48,3],
    [52,3],
    [56,4],
    [60,4],
    [64,4],
    [68,4],
    [72,4],
    [76,4],
    [80,6],
    [85,6],
    [90,6],
    [95,6],
    [100,6]
];

ISO_FINE_PITCH_4_BY_DIAMETER = [
// Diameter (D,d), Pitch(P)
    [1,0.2],
    [1.1,0.2],
    [1.2,0.2],
    [1.4,0.2],
    [1.6,0.2],
    [1.8,0.2],
    [2,0.25],
    [2.2,0.25],
    [2.5,0.25],
    [3,0.25],
    [3.5,0.35],
    [4,0.5],
    [4.5,0.5],
    [5,0.5],
    [5.5,0.5],
    [6,0.75],
    [7,0.75],
    [8,1],
    [9,0.75],
    [10,1.25],    
    [12,1.5],
    [14,1.5],    
    [16,1.5],
    [18,2],
    [20,2],
    [22,2],
    [24,2],
    [27,2],
    [30,3],
    [33,3],
    [36,3],
    [39,3],
    [42,4],
    [45,4],
    [48,4],
    [52,4],
    [56,4],
    [60,4],
    [64,4],
    [68,4],
    [72,6],
    [76,6],
    [80,6],
    [85,6],
    [90,6],
    [95,6],
    [100,6]
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
ISO_CROASE_DESCRIPTION=[ISO_POINTS, iso_standardize_diameter_map(ISO_CROASE_PITCH_BY_DIAMETER)];
ISO_FINE_1_DESCRIPTION=[ISO_POINTS, iso_standardize_diameter_map(ISO_FINE_PITCH_1_BY_DIAMETER)];
ISO_FINE_2_DESCRIPTION=[ISO_POINTS, iso_standardize_diameter_map(ISO_FINE_PITCH_2_BY_DIAMETER)];
ISO_FINE_3_DESCRIPTION=[ISO_POINTS, iso_standardize_diameter_map(ISO_FINE_PITCH_3_BY_DIAMETER)];
ISO_FINE_4_DESCRIPTION=[ISO_POINTS, iso_standardize_diameter_map(ISO_FINE_PITCH_4_BY_DIAMETER)];

SAW_DESCRIPTION=[SAW_POINTS];//todo

THREADING_DESCRIPTION = [
    ISO_CROASE_DESCRIPTION,
    ISO_FINE_1_DESCRIPTION,
    ISO_FINE_2_DESCRIPTION,
    ISO_FINE_3_DESCRIPTION,
    ISO_FINE_4_DESCRIPTION,
    SAW_DESCRIPTION
];

/* ==================== */
tolerance_value=0.3;
cad=0.001;

/*
 * get_properties(description_id) - get the properties from a threading type (see above)
 * get_P(properties, D) - get pitch for a given diameter
 * get_H(properties, D) - get profile height
 * get_shape(properties, D) - get the shape points for the given diameter
 */
function get_property_maps(type) = THREADING_DESCRIPTION[type][1];
function get_P(property_maps, D) = 
    assert(!is_undef(property_maps))
    assert(!is_undef(D))
    lookup(D, property_maps[0]);
function get_H(property_maps, D) = lookup(D, property_maps[1]);
function get_shape(type, D) = 
    assert(type > -1)
    assert(type < len(THREADING_DESCRIPTION))
    assert(D > 0)
    assert(D < 101)
    let(
        shape = THREADING_DESCRIPTION[type][0],
        property_maps = get_property_maps(type),
        p=get_P(property_maps, D),
        h=get_H(property_maps, D))
    assert(!is_undef(shape))
    assert(!is_undef(property_maps))
    assert(!is_undef(p))
    assert(!is_undef(h))
    scale_shape(shape, p, h);
function get_profile_height(type, D) = 
    assert(type > -1)
    assert(type < len(THREADING_DESCRIPTION))
    assert(D > 0)
    assert(D < 101)
    let(property_maps = get_property_maps(type))
    assert(!is_undef(property_maps))
    get_H(property_maps, D);

function scale_shape(shape, P, H) = [for(point=shape) [point.x*H, point.y*P]];
function max_x(points, i=0, maxx=0) = 
    let(x=(is_undef(points[i].x)? 0 : points[i].x),current_max= x > maxx? x : maxx)
    len(points) > i? max_x(points, i+1, current_max) : current_max;

module screw_body(
        threading_diameter=20,
        threading_length=10,
        usage=BOLT,
        add_bezel=true,
        type=METRIC_ISO
) {
    threading_property_maps = get_property_maps(type);
    threading_shape=get_shape(type, threading_diameter);
    assert( !( is_undef(threading_property_maps) || is_undef(threading_shape)) , 
        str("No definition for ", THREADING_TYPE_NAMES[type], 
                " thread with diameter ", threading_diameter));
    profile_depth=get_H(threading_property_maps, threading_diameter);
    tolerance = usage==NUT? +tolerance_value +0.05*profile_depth
			: -tolerance_value -0.05*profile_depth;
    diameter = threading_diameter + tolerance;
    pitch = get_P(threading_property_maps, threading_diameter);
    bezel = add_bezel?  profile_depth:0; 
    screw_parameterized(diameter, threading_length, pitch, threading_shape, usage, bezel);
}

module screw_parameterized(diameter, length, pitch, threading_shape, usage, bezel) {
    module bezel_mask() {
        translate([0,0,length-bezel]) {
            difference() {
                cylinder(h=2*pitch, d=diameter+2*bezel, center=false);
                translate([0,0,-cad])
                    cylinder(h=bezel, d1=diameter, d2=diameter-bezel*1.3, center=false);
            }
        }
    }
    if (usage==NUT)
        translate([0,0,-length])
        union() {
            threading(threading_shape, diameter, length, pitch);
            if(bezel) 
                translate([0,0,length-bezel-cad])
                    cylinder(h=bezel, d1=diameter-bezel*1.3, d2=diameter, center=false);
        }
    else
        difference() {
            threading(threading_shape, diameter, length, pitch);
            if(bezel) 
                bezel_mask();
        }
}

module threading(shape, diameter, length, pitch) {
    threading_length = length + 2*pitch;
    profile_depth = max_x(shape);
    core_diameter = diameter-2 * profile_depth;
    radius = core_diameter / 2;
        
    intersection(){
        union() {
            translate([0,0,-pitch])
                helix(threading_length, radius, pitch, shape);
            cylinder(threading_length, d=core_diameter, center=false);
        }
        cylinder(length,d=diameter,center=false);
    }
}

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
