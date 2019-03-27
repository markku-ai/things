$fn=64;

// Configurable 
rail_length = 280;
rail_end_margin = 10; // Distance from rail end to the first hole
front_fastening_position = 24.5; // Distance from the beginning of the rail to the front fastening screw hole
rear_fastening_position = 15; // Distance from the end of the rail to the rear fastening screw hole
tolerance = 0.5;

// Should not need configuration
rail_bottom_width = 23;
rail_side_height = 6;
rail_side_width = 4;
rail_top_height = 4;
rail_wall_thickness = 2;
rail_slot_width = 2 + tolerance * 2;
rail_center_thickness = 6 - tolerance * 2;
rail_slot_height = 6;
total_height = rail_side_height + rail_top_height;
chamfer_width = 1 + 1/3;
chamfer_height = 4;

rail_fastening_slot_length = 5;

rail_hole_distance = 10;
rail_hole_top_margin = 1.25;

m3_nut_diameter = 5.5;
m3_thread_diameter = 3.5;
m3_socket_diameter = 5;

module railEndProfile() {
    
    rotate([0, 0, 0]) {
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
            [rail_bottom_width, 0]]);     
    }    
}

module railHole() {
    rotate([90, 0, 0]) {
        rotate([0, 90, 0]) {
            union() {
                cylinder(rail_side_width, d=m3_socket_diameter);
                cylinder(rail_bottom_width, d=m3_thread_diameter);
                translate([0, 0, rail_bottom_width - rail_side_width]) {
                    cylinder($fn=6, rail_side_width, d=m3_nut_diameter);
                }
            }
        }
    }
}

module railFasteningSlot() {
    union() {
        translate([rail_side_width + rail_wall_thickness + rail_slot_width, 0, rail_top_height]) {
            cube(size = [rail_center_thickness, rail_fastening_slot_length, rail_slot_height ]);
            translate([rail_center_thickness / 2, rail_fastening_slot_length / 2, -total_height]) {
                rotate([0, 0, 90]) {
                    cylinder(total_height,d=m3_thread_diameter);
                }
            }
        }
    }
}

difference() {
    translate([0, rail_length, 0]) {
        rotate([90, 0, 0]) {
            linear_extrude(height=rail_length) {
                railEndProfile();
            }
        }
    }
    
    translate([0, rail_end_margin, 0]){
        for(i = [0: rail_hole_distance: rail_length - 2 * rail_end_margin]) {
            translate([0, i, total_height - m3_thread_diameter / 2 - rail_hole_top_margin]) {
                railHole();
            }
        }
    }

    translate([0, front_fastening_position - rail_fastening_slot_length / 2, 0]) {
        railFasteningSlot();
    }

    translate([0, rail_length - rear_fastening_position - rail_fastening_slot_length / 2, 0]) {
        railFasteningSlot();
    }
}
