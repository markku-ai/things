use <MCAD/nuts_and_bolts.scad>

// Length of the rail
length = 240;

// Distance from rail end to the first hole
hole_end_margin = 10;

// Distance from the beginning of the rail to the front fastening screw hole
front_fastening_position = 25;

// Distance from the end of the rail to the rear fastening screw hole
rear_fastening_position = 25;

// Adds extra gap to the rail slot
gap_tolerance = 1; // [0:0.1:2]

// Moves holes closer top of the rail
hole_top_tolerance = 0; // [0:0.05:1.25]

/* [Hidden] */

$fn=16;
rail_bottom_width = 23;
rail_side_height = 6;
rail_side_width = 4.5 - gap_tolerance;
rail_top_height = 4;
rail_wall_thickness = 2;
rail_slot_width = 2 + gap_tolerance * 2;
rail_center_thickness = 6 - gap_tolerance * 2;
rail_slot_height = 6;
total_height = rail_side_height + rail_top_height;
chamfer_width = 1 + 1/3;
chamfer_height = 4;

fastening_slot_length = 5.5;

hole_distance = 10;
rail_hole_top_margin = 1.25;

module profile() {
    polygon([
        [0, 0],
        [0, chamfer_height],
        [chamfer_width, rail_side_height],
        [rail_side_width, rail_side_height],
        [rail_side_width, rail_side_height + rail_top_height],
        [rail_side_width + rail_wall_thickness, total_height],
        [rail_side_width + rail_wall_thickness, total_height - rail_slot_height],
        [rail_side_width + rail_wall_thickness + rail_slot_width, total_height - rail_slot_height],
        [rail_side_width + rail_wall_thickness + rail_slot_width, total_height],
        [rail_side_width + rail_wall_thickness + rail_slot_width + rail_center_thickness, total_height],
        [rail_side_width + rail_wall_thickness + rail_slot_width + rail_center_thickness, total_height - rail_slot_height],
        [rail_side_width + rail_wall_thickness + 2 * rail_slot_width + rail_center_thickness, total_height - rail_slot_height],
        [rail_side_width + rail_wall_thickness + 2 * rail_slot_width + rail_center_thickness, total_height],
        [rail_side_width + 2 * rail_wall_thickness + 2 * rail_slot_width + rail_center_thickness, total_height],
        [rail_bottom_width - rail_side_width, rail_side_height],
        [rail_bottom_width - chamfer_width, rail_side_height],
        [rail_bottom_width, chamfer_height],
        [rail_bottom_width, 0]
    ]);     
}

module railBoltHole() {
    rotate([90, 0, 0]) {
        rotate([0, 90, 0]) {
            union() {
                cylinder(side_width, d=6);
                linear_extrude(height=total_width) {
                    boltHole(size=3, length=total_width, tolerance=0.25, proj=1);
                }
                translate([0, 0, total_width - side_width]) {
                    linear_extrude(height=side_width) {
                        nutHole(size=3, proj=1);
                    }
                }
            }
        }
    }
}

module fasteningSlot() {
    union() {
        translate([rail_side_width + rail_wall_thickness + rail_slot_width, 0, rail_top_height]) {
            cube(size = [rail_center_thickness, fastening_slot_length, rail_slot_height ]);
            translate([rail_center_thickness / 2, fastening_slot_length / 2, -total_height]) {
                rotate([0, 0, 90]) {
                    boltHole(size=3, length=total_height);
                }
            }
        }
    }
}

difference() {
    translate([0, length, 0]) {
        rotate([90, 0, 0]) {
            linear_extrude(height=length) {
                profile();
            }
        }
    }
    
    translate([0, hole_end_margin, 0]){
        for(i = [0: hole_distance: length - 2 * hole_end_margin]) {
            translate([0, i, total_height - rail_slot_height / 2 + hole_top_tolerance]) {
                railBoltHole();
            }
        }
    }

    translate([0, front_fastening_position - fastening_slot_length / 2, 0]) {
        fasteningSlot();
    }

    translate([0, length - rear_fastening_position - fastening_slot_length / 2, 0]) {
        fasteningSlot();
    }

    linear_extrude(height=total_height) {
        polygon([
            [0,0],
            [rail_side_width, 0],
            [0, rail_side_width],
        ]);
        polygon([
            [rail_bottom_width, 0],
            [rail_bottom_width - rail_side_width, 0],
            [rail_bottom_width, rail_side_width],
        ]);
    }
}
