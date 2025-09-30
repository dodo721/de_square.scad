module square_de_square(size, center=false) {
    render()
    if (is_list(size)) {
        translate(center?[-size.y/2, -size.x/2]:[0,0])
        {
            sml_len = size.x > size.y ? size.y : size.x;
            big_len = size.x > size.y ? size.x : size.y;
            needs_rot = size.x > size.y;
            translate([needs_rot?sml_len:0, 0])
            rotate(needs_rot?90:0)
            {
                frac = big_len / sml_len;
                floor_num = floor(frac);
                num = ceil(frac);
                remain_len = (sml_len * num) - big_len;
                for (i=[0:num-2]) {
                    translate([i*(sml_len), 0])
                        square(sml_len, center=false);
                }
                translate([(floor_num*sml_len)-(remain_len==0?sml_len:remain_len), 0])
                square(sml_len, center=false);
            }
        }
    } else {
        square(size, center);
    }
}

module circ_de_square(radius) {
    angle = 360/$fn;
    chord = 2 * radius * sin(angle/2);
    sagitta = radius - (chord / (2*tan(angle/2)));
    for (i = [0:$fn]) {
        rotate(angle * i)
            translate([(radius / 2)-sagitta, 0])
                square([radius, chord], center=true);
    }
}

module sphere_de_square(radius, $fn=20) {
    angle = 360/$fn;
    chord = 2 * radius * sin(angle/2);
    rotate(90, [1, 0, 0])
    for (i = [0:$fn]) {
        rotate((360 / $fn) * i, [0, 1, 0])
        difference() {
            linear_extrude(chord, center=true)
            difference() {
                circ_de_square(radius);
                translate([radius, 0])
                    square(radius*2, center=true);
            };
            rotate(angle / 2, [0, 1, 0])
                linear_extrude(chord)
                    square(radius*2, center=true);
            rotate(-angle / 2, [0, 1, 0])
                translate([0, 0, -chord])
                    linear_extrude(chord)
                        square(radius*2, center=true);
        }
    }
}

module cube_de_square(side_length, center=false) {
    linear_extrude(side_length, center=center)
        square(side_length, center=center);
}

sphere_de_square(10);
