// todo: general spacing / alignment

// ----------------------------------------
// VARIABLES
// ----------------------------------------

// overall panel size
panel_x            = 200;
panel_y            = 210;
panel_mount_dia    = 3.2;
panel_mount_offset = 6;
panel_corner_r     = 4;

// centre of the tactile switch array
keypad_offset_x  = 100;
keypad_offset_y  = 86;

// keypad mounting hole size & spacing
keypad_mount_dia = 3.2;
keypad_mount_x = 182;
keypad_mount_y = 92;

// tactile switch details
key_hole_x    = 10.3;
key_hole_y    = 10.3;
key_hole_r    = 0.5;
key_spacing_x = 16;
key_spacing_y = 14;
key_num_x     = 10;
key_num_y     = 6;

// Define which key holes in the x/y grid actually get made.
// Note that the size of this array must match the number
// of rows and columns defined above..
key_array = [[0,1,0,1,1,0,1,1,1,0],
             [1,0,1,0,0,0,1,1,1,1],
             [0,1,0,1,1,0,0,0,0,0],
             [0,0,0,0,0,0,1,1,1,1],
             [1,1,1,1,0,0,0,0,0,0],
             [1,1,1,1,0,0,1,1,1,1],
            ];

// centre of the leftmost panel mount button
button_offset_x  = 25;
button_offset_y  = 21;

panel_mount_button_dia       = 16.2;
panel_mount_button_spacing_x = 30;
panel_mount_button_spacing_y = 0;
panel_mount_button_num_x     = 3;
panel_mount_button_num_y     = 1;

// centre of the leftmost ovveride encoder
override_encoder_offset_x  = 115;
override_encoder_offset_y  = 21;

override_encoder_dia       = 7.2;
override_encoder_spacing_x = 30;
override_encoder_spacing_y = 0;
override_encoder_num_x     = 3;
override_encoder_num_y     = 1;

// centre of the mpg encoder
mpg_encoder_offset_x  = 150;
mpg_encoder_offset_y  = 171;

// lcd display - new bezel design

// centre of the lcd display
display_offset_x  = 60;
display_offset_y  = 171;

// rectangular cutout
display_x   = 88.5;
display_y   = 59.5;
display_r   = 0.5;

// panel extrude thickness
extrude_thickness = 2;

// ----------------------------------------
// MODULES
// ----------------------------------------

module rounded_square(size, r, center) {
  s = is_list(size) ? size : [size,size];
  translate(center ? -s/2 : [0,0]) {
    hull() {
        translate([     r,     r]) circle(r, $fn=64);
        translate([     r,s[1]-r]) circle(r, $fn=64);
        translate([s[0]-r,     r]) circle(r, $fn=64);
        translate([s[0]-r,s[1]-r]) circle(r, $fn=64);
    }
  }
}

module panel() {
    rounded_square(size=[panel_x,panel_y], r = panel_corner_r, center = false);
}

module panel_mounting_holes() {

  translate([panel_mount_offset, panel_mount_offset, 0]) {
    through_hole(keypad_mount_dia);
  }
  translate([panel_mount_offset, panel_y - panel_mount_offset, 0]) {
    through_hole(keypad_mount_dia);
  }
  translate([panel_x - panel_mount_offset, panel_mount_offset, 0]) {
    through_hole(keypad_mount_dia);
  }
  translate([panel_x - panel_mount_offset, panel_y - panel_mount_offset, 0]) {
    through_hole(keypad_mount_dia);
  }

}

module keyhole() {
  rounded_square(size=[key_hole_x,key_hole_y], r = key_hole_r, center = true);
}

module keyholes() {

  // key holes
  keypad_overall_x  = (key_spacing_x*(key_num_x-1));
  keypad_overall_y  = (key_spacing_y*(key_num_y-1));

  translate([-keypad_overall_x/2, keypad_overall_y/2, 0]) {
  for (key_pos_x=[0:key_num_x-1])
    for (key_pos_y=[0:key_num_y-1])
    if (key_array[key_pos_y][key_pos_x]) {
      translate([key_spacing_x*key_pos_x, -key_spacing_y*key_pos_y, 0]) {
        keyhole();
      }
    }
  }

  // mounting holes
  translate([-keypad_mount_x/2, -keypad_mount_y/2, 0]) {
    through_hole(keypad_mount_dia);
  }
  translate([-keypad_mount_x/2, keypad_mount_y/2, 0]) {
    through_hole(keypad_mount_dia);
  }
  translate([0, -keypad_mount_y/2, 0]) {
    through_hole(keypad_mount_dia);
  }
  translate([0, keypad_mount_y/2, 0]) {
    through_hole(keypad_mount_dia);
  }
  translate([-keypad_mount_x/2, -keypad_mount_y/2, 0]) {
    through_hole(keypad_mount_dia);
  }
  translate([keypad_mount_x/2, -keypad_mount_y/2, 0]) {
    through_hole(keypad_mount_dia);
  }
  translate([keypad_mount_x/2, keypad_mount_y/2, 0]) {
    through_hole(keypad_mount_dia);
  }
}

module mpg_encoder() {
  circle(d=44, $fn=64);
  // 3x 3.5mm mounting holes on 50.8mm diameter
  for (angle=[0:120:240])
    rotate (a=[0,0,angle]) {
      translate([0,25.4,0]) {
        circle(d=3.5, $fn=64);
      }
    }
}

module display() {
    rounded_square(size=[display_x,display_y], r = display_r, center = true);
}

module through_hole(diameter) {
    circle(d=diameter, $fn=64);
}

module through_holes(num_x, num_y, spacing_x, spacing_y, dia) {
  for (pos_x=[0:num_x-1])
    for (pos_y=[0:num_y-1])
      translate([spacing_x*pos_x, spacing_y*pos_y, 0]) {
        through_hole(dia);
      }
}

module front_panel() {
  difference() {
    panel();
    panel_mounting_holes();
    translate([keypad_offset_x,keypad_offset_y,0]) {
      keyholes();
    }
    translate([button_offset_x, button_offset_y, 0]) {
        through_holes(panel_mount_button_num_x,
                      panel_mount_button_num_y,
                      panel_mount_button_spacing_x,
                      panel_mount_button_spacing_y,
                      panel_mount_button_dia);
    }
    translate([override_encoder_offset_x, override_encoder_offset_y, 0]) {
        through_holes(override_encoder_num_x,
                      override_encoder_num_y,
                      override_encoder_spacing_x,
                      override_encoder_spacing_y,
                      override_encoder_dia);
    }
    translate([mpg_encoder_offset_x, mpg_encoder_offset_y, 0]) {
        mpg_encoder();
    }
    translate([display_offset_x, display_offset_y, 0]) {
        display();
    }
  }
}

// ----------------------------------------
// EXECUTION STARTS HERE
// ----------------------------------------

//linear_extrude(extrude_thickness) {
//  front_panel();
//}

front_panel();
