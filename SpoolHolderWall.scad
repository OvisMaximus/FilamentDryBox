// High profile to lift the spools as much as possible to put silica gel below, low profile to safe material or for spools with a larger diameter than usual.
profile=0; // [0:low profile, 1:high profile]
which_part=0; // [0:wall, 1:double]

module endOfCustomizerableVariablesNOP() {};
profiles_axis_heights=[25.0,35.0];
profiles_slot_heights=[1.2,1.8];
spool_diameter=200;
floor_wall_radius=5.5;
min_wall_thickness=2.5;
wall_wall_radius=7.5;
wall_angle=2.7;
wall_profile_center_offset=-3.7;
axis_diameter=8.0;
axis_distance=130.0;
axis_height=profiles_axis_heights[profile];
ball_inner_diameter=12;
ball_diameter=22.0;
ball_length=7.0;
cut_out_offset=5;
slot_offset=-1;
slot_height=profiles_slot_heights[profile]*ball_diameter;
tolerance=0.2;

cad=0.001;
$fn=150;

module wedge(size){
    points=[
        [0,0,0],
        [0,0,size.z],
        [size.x,0,size.z],
        [0,size.y,0],
        [0,size.y,size.z],
        [size.x,size.y,size.z]
    ];
    faces=[
        [2,1,0],
        [0,1,4,3],
        [3,4,5],
        [0,3,5,2],
        [1,2,5,4]
    ];
    polyhedron(points, faces);
    
}

module profile_bar(size,angle) {
    assert(angle >= 0);
    
    beta=90-angle;
    tan_x=sin(beta)*floor_wall_radius;
    tan_z=floor_wall_radius-cos(beta)*floor_wall_radius;
    wedge_z=size.z-tan_z;
    wedge_x=tan(angle)*wedge_z;
    base_block_size=[size.x-tan_x,size.y,size.z];
    fill_block_size=[tan_x+2*cad,size.y,wedge_z];
    
    translate([tan_x,0,0])
        cube(base_block_size);
    translate([-cad,0,tan_z])
        cube(fill_block_size);
    translate([tan_x,size.y,floor_wall_radius])
        rotate([90,0,0])
            cylinder(size.y,r=floor_wall_radius,center=false);
    translate([0,0,tan_z])
        wedge([-wedge_x,size.y,wedge_z]);

}

module bore(diameter,depth, pos_y, pos_z){
    translate([-cad,pos_y,pos_z])
        rotate([0,90,0])
            cylinder(depth+2*cad,d=diameter,center=false);
}

module cylinder_mask(length, radius) {
    l = length + 2*cad;
    difference() {
        cube([l,radius+cad,radius+cad]);
        translate([0,0,0])
            rotate([0,90,0])
                cylinder(length, r=radius, center=false);
    }
}

module holes(length) {
        bore(8.1,length,axis_distance/2, axis_height);
        translate([-cad-2*length,axis_distance/2,axis_height])
            cylinder_mask(3*length+2*cad, ball_diameter/2+min_wall_thickness);

        bore(8.1,length,-axis_distance/2, axis_height);
        translate([-cad-2*length,-axis_distance/2,axis_height])
            rotate([90,0,0])
                cylinder_mask(3*length+2*cad, ball_diameter/2+min_wall_thickness);
        
        translate([-cad,0,spool_diameter/2+axis_height-cut_out_offset])
            rotate([0,90,0])
                cylinder(length+2*cad,r=spool_diameter/2,center=false);       
}    

module ball_bearing_fit(position, rotation) {
    translate(position) rotate(rotation)    
        difference() {
            cylinder(h=tolerance*1.5, d=ball_inner_diameter, center=false);
            translate([0,0,-cad])
                cylinder(h=tolerance*1.5+2*cad, d=axis_diameter, center=false);
        }
}

profile_width=axis_distance+ball_diameter+2*min_wall_thickness;
profile_height=axis_height+ball_diameter/2+min_wall_thickness;
module spool_holder_wall () {

    profile_length=2*(min_wall_thickness+tolerance)+slot_offset+ball_length;
    
    module vincinity_clearence() {
        translate([profile_length-cad, -profile_width/2-cad,-cad])
            cube([profile_length,profile_width+2*cad,2*profile_height]);
        translate([-1.5*profile_length-cad, -profile_width/2-2*profile_length-cad,-cad])
            cube([3*profile_length,2*profile_length+2*cad,2*profile_height]);
        translate([-1.5*profile_length-cad, profile_width/2-cad,-cad])
            cube([3*profile_length,2*profile_length+2*cad,2*profile_height]);
        translate([-1.7*profile_length-cad, -profile_width/2-cad,-cad])
            cube([profile_length,profile_width+2*cad,2*profile_height]);
    }

    slot_pos=[min_wall_thickness+slot_offset, 
            -profile_width/2-cad,
            profile_height-slot_height];
    module spool_slot() {
        translate(slot_pos)
            cube([ball_length+2*tolerance,profile_width+2*cad,slot_height+2*cad]);
    }
    
    module add_ball_bearing_fits() {
        ball_bearing_fit(
            [slot_pos.x-cad,axis_distance/2,axis_height],
            [0,90,0]
        );
        ball_bearing_fit(
            [slot_pos.x+ball_length+.5*tolerance+cad,axis_distance/2,axis_height],
            [0,90,0]
        );
    }

    module holder_end() {
        stub_width=20;
        stub_x_pos=stub_width/10;
        stub_y_pos=axis_distance/2+wall_profile_center_offset;
        translate([stub_x_pos,stub_y_pos,0])
            rotate([0,0,45])
                profile_bar([profile_length,stub_width,profile_height],wall_angle);
        translate([0,stub_y_pos+10,0])
                cube([10,10,10]);
    }
    
    difference() {
        union() {
            translate([0,-profile_width/2,0])
                profile_bar([profile_length,profile_width,profile_height],wall_angle);
            holder_end();
            mirror([0,1,0]) holder_end();
        }

        vincinity_clearence();

        spool_slot();

        translate([-profile_length/5,0,0])
            holes(profile_length*1.2);
    }
    
    add_ball_bearing_fits();
    mirror([0,1,0]) add_ball_bearing_fits();
    
    
}

module spool_holder_double () {
    profile_length=3*min_wall_thickness+4*tolerance+2*ball_length;

    difference() {
        translate([0,-profile_width/2,0])
            cube([profile_length,profile_width,profile_height]);

        translate([min_wall_thickness, -profile_width/2-cad,profile_height-slot_height])
            cube([ball_length+2*tolerance,profile_width+2*cad,slot_height+2*cad]);

        translate([2*min_wall_thickness+2*(tolerance)+ball_length, -profile_width/2-cad,profile_height-slot_height])
            cube([ball_length+2*tolerance,profile_width+2*cad,slot_height+2*cad]);

        holes(profile_length);
    }
}

if(which_part==0) {
    spool_holder_wall();
} else {
    spool_holder_double();
}