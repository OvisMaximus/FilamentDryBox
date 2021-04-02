//include <MCAD/screw.scad>;

/*[select part]*/
part=0;//[0:screw out, 1:screw in, 2:fix cap, 3:cover cap]

/*[Box Properties]*/
wall_thickness=1.5;
wall_hole_diameter=25;
/*[Cap Properties]*/
cap_diameter=40;
cap_height=8.0;
/*[Screw Properties]*/
threading_diameter=20;
threading_depth=threading_diameter/10;
hose_diameter=4;
pneu_sealing_diameter=9.38;
pneu_sealing_length=5.8;
/*[Mechanical Properties]*/
tolerance=0.1;

module end_of_customizer_fields_NOP(){}
screw_out_length=(cap_height+tolerance)*2+wall_thickness+tolerance;
screw_in_length=screw_out_length+cap_height+tolerance;
cad=0.001;
$fn=300;

module cap_body() {
    cylinder(cap_height, d=cap_diameter, center=false);
}

module helix(pitch, length){
    rotations = length/pitch/2;
    linear_extrude(height=length, center=false, convexity=10, twist=360*rotations, 
    $fn=200)
        children(0);
}

module auger(pitch, length, outside_radius, inner_radius, taper_ratio = 1) {
    steps=22;
    circular_steps=round(steps*taper_ratio);
    skip_steps=steps-circular_steps;
    
    points = [
        for (a = [skip_steps : circular_steps]) 
            [outside_radius * sin(a * 180 / steps), inner_radius * cos( a*180/steps)],
        for (a = [skip_steps : circular_steps]) 
            [-outside_radius * sin(a * 180 / steps), -inner_radius * cos( a*180/steps)]
    ];
    union(){
        helix(pitch, length)
            polygon(points=points);
        cylinder(h=length, r=inner_radius);
    }

}

outside=threading_diameter/2;
inside=threading_diameter/2-threading_depth;

module screw_threading(is_inside_threading) {
    threading_tolerance=is_inside_threading? +tolerance: -tolerance;
    taper_ratio=.95;
    auger(pitch=3, length=20,
        outside_radius=outside+threading_tolerance, 
        inner_radius=inside+threading_tolerance,
        taper_ratio=taper_ratio);
}

module hose_bore() {
    translate([0,0,-cad])
        cylinder(h=cap_height+screw_out_length+2*cad, d=hose_diameter+tolerance, center=false);
}

module base_screw(screw_length) {
    module solid_body() {
        cap_body();
        translate([0,0,cap_height])
            intersection() {
                screw_threading(false);
                cylinder(h=screw_length, r=outside-2*tolerance);
            }
        translate([0,0,cap_height-cad])         
            cylinder(h=wall_thickness, d=wall_hole_diameter, center=false);
    }
    
    module soft_end(pos_z) {
        translate([0,0,pos_z])
            difference() {
                cylinder(h=2*threading_depth, r=outside+5, center=false);
                cylinder(h=threading_depth, r1=outside, r2=inside, center=false);
            }
    }
    
    difference() {
        solid_body();
        hose_bore();
        soft_end(cap_height+screw_length+cad-threading_depth);
    }
}

module screw_out() {
    module pneu_sealing_bore() {
        translate([0,0,cap_height+screw_out_length-pneu_sealing_length+cad])
           # cylinder(h=pneu_sealing_length, d=pneu_sealing_diameter, center=false);
    }

    difference() {
        base_screw(screw_out_length)
        pneu_sealing_bore();
    }
}

module screw_in() {
    cap_body();
    cylinder(screw_in_length, d=threading_diameter-tolerance, center=false);
}

module cap_fix() {
    difference(){
        cap_body();
        translate([0,0,-cad])         
            screw_threading(true);
        translate([0,0,cap_height-threading_depth+cad])
            cylinder(h=threading_depth,r1=inside,r2=outside,center=false);
        translate([0,0,-cad])
            cylinder(h=threading_depth,r1=outside,r2=inside,center=false);
    }
}

module cap_cover() {
    cap_body();
}

if(part==0)
    screw_out();
else if(part==1)
    screw_in();
else if(part==2)
    cap_fix();
else
    cap_cover();

