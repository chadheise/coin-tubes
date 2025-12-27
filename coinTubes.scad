/* [Labels] */
side_label = "Nickels";
side_text_size = 7; // [0:1:100]
cap_label = "$";
cap_text_size = 9; // [0:1:100]
font = "Roboto:style=Regular";

/* [Dimensions] */
coin_diameter = 21.21; // [10:0.0001:100]
coin_thickness = 1.95; // [0:0.01:]
coin_capacity = 40; // [0:1:100]
side_length = 25.40; // [0:0.0001:100]
height = 82.55; // [0:0.0001:1000]

/* [Universal Dimensions] */
top_tube_height = 11.0;
cap_height = 12.75;
cap_tolerance = 0.4;
coin_tolerance = 0.7;

/* [Hidden] */
tube_wall_thickness = 1;
corner_radius = 2;
cap_render_position_shift = 20;
text_depth = 0.5;

$fn = 64;

color("#52C8E3")
  main();

module main() {
  base_height = height - cap_height;

  coin_height = coin_thickness * coin_capacity;

  cap_tube_depth = top_tube_height;

  inner_tube_diameter = coin_diameter + coin_tolerance;
  outer_tube_diameter = inner_tube_diameter + tube_wall_thickness;

  base_tube(side_length, base_height, corner_radius, top_tube_height, outer_tube_diameter, inner_tube_diameter, coin_height);

  cap_translation = side_length + cap_render_position_shift;
  translate([cap_translation, 0, 0])
    cap(side_length, cap_height, corner_radius, outer_tube_diameter, cap_tolerance, cap_tube_depth);
}

module base_tube(side_length, height, corner_radius, tube_height, outer_tube_diameter, inner_tube_diameter, coin_height) {
  difference() {
    base_tube_solid(side_length, height, corner_radius, tube_height, outer_tube_diameter);

    bottom_thickness = height + tube_height - coin_height;
    echo(height, tube_height, height + tube_height, coin_height);

    translate([0, 0, bottom_thickness])
      cylinder(h = coin_height, d = inner_tube_diameter, center = false);

    text_position_x = -height / 2;
    text_position_z = (side_length / 2) - text_depth;

    rotate(a = [90, 90, 0])
      translate([text_position_x, 0, text_position_z])
        label(side_label, side_text_size, text_depth);
  }
}

module base_tube_solid(side_length, height, corner_radius, tube_height, tube_diameter) {
  union() {
    base_translation = side_length / 2;

    translate([-base_translation, -base_translation, 0])
      round_corner_cube(side_length, side_length, height, corner_radius);

    translate([0, 0, height])
      cylinder(h = tube_height, d = tube_diameter, center = false);
  }
}

module cap(side_length, height, corner_radius, tube_diamater, tolerance, tube_depth) {
  difference() {
    base_translation = -side_length / 2;

    translate([base_translation, base_translation, 0])
      round_corner_cube(side_length, side_length, cap_height, corner_radius);

    cap_inner_diameter = tube_diamater + tolerance;

    top_thickness = height - tube_depth;

    translate([0, 0, top_thickness])
      cylinder(h = tube_depth + top_thickness, d = cap_inner_diameter, center = false);

    text_size = side_length * 0.1;

    rotate(a = [180, 0, 0])
      translate([0, 0, -text_depth])
        label(cap_label, cap_text_size, text_depth);
  }
}

module round_corner_cube(x, y, z, r) {
  translate([r, r, 0])
    minkowski() {
      adjusted_x = x - 2 * r;
      adjusted_y = y - 2 * r;

      cube([adjusted_x, adjusted_y, z]);
      cylinder(r = r, h = 1);
    }
}

module label(text, text_size, thickness) {
  linear_extrude(height = thickness)
    text(text = text, size = text_size, font = font, halign = "center", valign = "center");
}
