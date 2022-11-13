include <thread.scad>;

/*[Select Part]*/
part=0;//[0:screw out, 1:screw in, 2:fix cap, 3:cover cap, 4:tightening ring, 5:label holder]

/*[Box Properties]*/
wall_thickness=1.5;
wall_hole_diameter=25;

/*[Cap Properties]*/
cap_diameter=40;
cap_height=8.0;
cover_diameter=28;
cover_height=25;

/*[Screw Properties]*/
threading_diameter=20;
hose_diameter=4;
pneu_outlet_diameter=10;
pneu_outlet_length=5.8;
pneu_intake_diameter=6;
pneu_intake_length=5.2;

/*[Tightening Ring Properties]*/
hTighteningRing = 0.75;

/*[Label Properties]*/
lLabel = 50;
wLabel = 22;
hLabel = 1.5;
rLabel = 2.0;
lLabelFrame = 4.0;
rLabelProfile = 0.75;

/*[Mechanical Properties]*/
tolerance=0.2; // additional distance between bolt and nut due to 3d printing traits.

/*[Render Quality]*/
$fn=24;

module end_of_customizer_fields_NOP(){}
screw_length=(cap_height+tolerance)*2+wall_thickness+tolerance;

cad=0.001;

if(part==0)
    screw_out();
else if(part==1)
    screw_in();
else if(part==2)
    cap_fix();
else if (part==3)
    rotate([180,0,0]) cap_cover();
else if (part==4)
    tighteningRing();
else
    labelHolder();


inside=threading_diameter*0.46;
outside=threading_diameter*0.54;
delta=outside-inside;

lLabelHolder = lLabel + 2*lLabelFrame;
wLabelHolder = wLabel + 2*lLabelFrame;


module screw_out() {
    module pneu_outlet_bore() {
        translate([0, 0, cap_height+screw_length+cad])
            screw_body(pneu_outlet_diameter, pneu_outlet_length, NUT, type=METRIC_ISO_F2);
    }

    difference() {
        base_screw(screw_length);
        pneu_outlet_bore();
    }
}

module screw_in() {
    module pneu_intake_bore() {
        translate([0, 0, cap_height+screw_length+cad])
                screw_body(6,pneu_outlet_length, NUT);
    }

    difference() {
        base_screw(screw_length);
        pneu_intake_bore();
    }
}

module cap_fix() {
    difference(){
        cap_body($fn=180);

        nutThread();
        translate([0,0,cap_height-delta+cad])
            cylinder(h=delta,r1=inside,r2=outside,center=false,$fn=180);
        translate([0,0,-cad])
            cylinder(h=delta,r1=outside,r2=inside,center=false,$fn=180);
    }
}

module cap_cover() {
    bore_depth=cover_height-cap_height/2;
    difference(){
        cylinder(h=cover_height,d=cover_diameter,center=false, $fn=180);
        translate([0,0,cover_height/10])
            profile_diameter(cover_diameter/2+1, cover_height, 3, 0.75, $fn=180);
        translate([0,0,-cad])         
            soft_end(cover_height-1, cover_diameter/2,  1, $fn=180);
        translate([0,0,bore_depth-cad])         
            screw_body(threading_diameter, bore_depth, usage=NUT);
        translate([0,0,-cad])
            cylinder(h=delta,r1=outside,r2=inside,center=false, $fn=180);
    }
}

module tighteningRing() {
    $fn = 200;
    difference() {
        cylinder(0.3, d=cap_diameter - 2);
        translate([0,0,-cad])
            cylinder(hTighteningRing, d=wall_hole_diameter + 2*tolerance);
    }
}

module labelHolder() {
    module solid() {
        module holderNutBody() {
            circle(d = cap_diameter);
        }
        module holderNeckBody() {
            wNeck = cap_diameter-threading_diameter;
            translate([-wNeck/2, -cap_diameter/2, 0])
                square([wNeck, threading_diameter/2 + 2 * cad]);
        }
        module labelFrameBase() {
            translate([-lLabelHolder/2, -cap_diameter/2 - wLabelHolder, 0])
                square([lLabelHolder, wLabelHolder]);
        }
        module bodyRaw() {
            holderNutBody();
            holderNeckBody();
            labelFrameBase();
        }
        linear_extrude(hLabel)
            offset(r=rLabel)
                offset(r=-rLabel)
                    bodyRaw();
    }
    difference() {
        solid();
        nutThread();
        translate([-lLabel/2, -cap_diameter/2 - wLabel -lLabelFrame,-cad])
            minkowski() {
                labelBase();
                sphere(r=2*cad);
            }
    }
}

module labelBase() {
    module profile() {
        pShape = [
            [0, 0],
            [0, hLabel-cad],
            [rLabelProfile, hLabel/2]
            ];
        rotate_extrude() {
            polygon(pShape);
        }
    }

    minkowski() {
        cube([lLabel, wLabel, cad]);
        profile();
    }
}

module base_screw(screw_length) {
    module solid_body() {
        cap_body($fn=150);
        translate([0,0,cap_height])
            screw_body(threading_diameter, screw_length, BOLT, add_bezel=true);
        translate([0,0,cap_height-cad])         
            cylinder(h=wall_thickness, d=wall_hole_diameter, center=false, $fn=150);
    }
    
    difference() {
        solid_body();
        hose_bore();
    }
}

module cap_body() {
    difference() {
        cylinder(cap_height, d=cap_diameter, center=false);
        cap_grip();
    }
}

module cap_grip() {
        profile_diameter(cap_diameter/2+.2, cap_height, 1, 0.75);
        translate([0,0,-cad])         
            soft_end(cap_height-1, cap_diameter/2,  1);
        rotate([180,0,0])
            soft_end(-1, cap_diameter/2,  1);
}

module profile_diameter(radius, height, groove_depth, spacing_ratio) {
    diameter_length=radius*PI;
    num = round(diameter_length*spacing_ratio / groove_depth);
    angle_delta=360/num;
    for(i=[0:num-1]) {
        angle = i*angle_delta;
        pos_x=cos(angle)*radius;
        pos_y=sin(angle)*radius;
        translate([pos_x, pos_y, -cad])
            cylinder(height+2*cad, r=groove_depth, center=false);
    }
}

module soft_end(pos_z,diameter, size) {
    translate([0,0,pos_z])
        difference() {
            cylinder(h=2*size, r=diameter+5, center=false);
            cylinder(h=size, r1=diameter, r2=diameter-size, center=false);
        }
}

module nutThread() {
    translate([0, 0, screw_length / 2])
        screw_body(threading_diameter, screw_length, usage = NUT);

}

module hose_bore() {
    translate([0,0,-cad])
        cylinder(h=cap_height+screw_length+2*cad, d=hose_diameter+tolerance, center=false, $fn=80);
}

