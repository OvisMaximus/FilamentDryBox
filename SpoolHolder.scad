// High profile to lift the spools as much as possible to put silica gel below, low profile to safe material or for spools with a larger diameter than usual.
profile=0; // [0:low profile, 1:high profile]
which_part=0; // [0:wall, 1:double, 2:snap_on]

module endOfCustomizerableVariablesNOP() {};
profiles_axis_heights=[25.0,35.0,12];
profiles_slot_heights=[1.2,1.8,1];
spool_diameter=200;
floor_wall_radius=5.5;
min_wall_thickness=2.5;
wall_wall_radius=7.5;
wall_angle=2.7;
wall_profile_center_offset=-3.7;
axis_diameter=8.0;
axis_distance=130.0;
axis_height=which_part==2?profiles_axis_heights[2]
            :profiles_axis_heights[profile];
ball_inner_diameter=12;
ball_diameter=22.0;
ball_length=7.0;
cut_out_offset=5;
slot_height=(which_part==2)?profiles_slot_heights[2]*ball_diameter
            : profiles_slot_heights[profile]*ball_diameter;
slot_offset=-1;
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

module spool_slot(pos) {
    translate(pos)
        cube([ball_length+2*tolerance,profile_width+2*cad,slot_height+2*cad]);
}
    
module add_ball_bearing_fits(pos) {
    module add_ball_bearing_fit_pair() {
        ball_bearing_fit(
            [pos.x-cad,axis_distance/2,axis_height],
            [0,90,0]
        );
        ball_bearing_fit(
            [pos.x+ball_length+.5*tolerance+cad,axis_distance/2,axis_height],
            [0,90,0]
        );
    }
    add_ball_bearing_fit_pair();
    mirror([0,1,0]) add_ball_bearing_fit_pair();
}
    
module spool_holder_wall () {

    profile_length=2*(min_wall_thickness+tolerance)+slot_offset+ball_length;

    slot_pos=[min_wall_thickness+slot_offset, 
            -profile_width/2-cad,
            profile_height-slot_height];
    
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

        spool_slot(slot_pos);

        translate([-profile_length/5,0,0])
            holes(profile_length*1.2);
    }
    
    add_ball_bearing_fits(slot_pos);
}

profile_length=3*min_wall_thickness+4*tolerance+2*ball_length;

slot_pos_1=[min_wall_thickness, 
            -profile_width/2-cad,
            profile_height-slot_height];
slot_pos_2=[2*min_wall_thickness+2*(tolerance)+ball_length, 
            -profile_width/2-cad,
            profile_height-slot_height];

module spool_holder_double () {
    difference() {
        translate([0,-profile_width/2,0])
            cube([profile_length,profile_width,profile_height]);

        spool_slot(slot_pos_1);
        spool_slot(slot_pos_2);
        holes(profile_length);
    }
    add_ball_bearing_fits(slot_pos_1);
    add_ball_bearing_fits(slot_pos_2);
}

module spool_holder_snap_on() {
    module axis_snap_on_slots(){
        module axis_slot() {
            translate([-cad,(axis_distance-axis_diameter)/2,-cad])
                cube([profile_length+2*cad,axis_diameter,axis_height]);
        }
        
        axis_slot();
        mirror([0,1,0])axis_slot();
    }

    module slot_clearings(pos) {
        module ball_bearing_clearing(){
            translate([pos.x,(axis_distance-ball_diameter)/2-tolerance,-cad])
                cube([ball_length+2*tolerance, ball_diameter+2*tolerance, 2*min_wall_thickness]);
        }
        ball_bearing_clearing();
        mirror([0,1,0]) ball_bearing_clearing();
        translate([pos.x, -axis_distance/4,-cad])
            cube([ball_length+2*tolerance,axis_distance/2,2*min_wall_thickness]);
    }
        
    module add_brims() {
        module brim() {
            translate([-profile_length/2,profile_width/2-(profile_width-axis_distance)/2-profile_length,0])
                cube([profile_length*2,2*profile_length,0.2]);
        }
        brim();
        mirror([0,1,0]) brim();
    }
    
    difference() {
        union() {
            difference() {
                union() {
                    translate([0,-profile_width/2,0])
                        cube([profile_length,profile_width,profile_height]);
                    add_brims();
                }
                spool_slot(slot_pos_1);
                slot_clearings(slot_pos_1);
                spool_slot(slot_pos_2);
                slot_clearings(slot_pos_2);
                holes(profile_length);
            }
            add_ball_bearing_fits(slot_pos_1);
            add_ball_bearing_fits(slot_pos_2);
        }
        axis_snap_on_slots();
    }
}

if(which_part==0) {
    spool_holder_wall();
} else if(which_part==1) {
    spool_holder_double();
} else {
    spool_holder_snap_on();
}