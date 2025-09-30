module square_de_square(size, center=false) {
    sz = is_list(size)?(size.x==size.y?size.x:size):size;
    render()
    if (is_list(sz)) {
        translate(center?[-sz.x/2, -sz.y/2]:[0,0])
        {
            sml_len = sz.x > sz.y ? sz.y : sz.x;
            big_len = sz.x > sz.y ? sz.x : sz.y;
            unit_dir = sz.x > sz.y ? [1, 0] : [0, 1];
            {
                frac = big_len / sml_len;
                floor_num = floor(frac);
                num = ceil(frac);
                remain_len = (sml_len * num) - big_len;
                for (i=[0:num-2]) {
                    translate(i*sml_len*unit_dir)
                        square(sml_len, center=false);
                }
                translate(((floor_num*sml_len)-(remain_len==0?sml_len:remain_len))*unit_dir)
                square(sml_len, center=false);
            }
        }
    } else {
        square(sz, center);
    }
}

module circ_de_square(radius, $fn=20) {
    angle = 360/$fn;
    chord = 2 * radius * sin(angle/2);
    sagitta = radius - (chord / (2*tan(angle/2)));
    for (i = [0:$fn]) {
        rotate(angle * i)
            translate([(radius / 2)-sagitta, 0])
                square_de_square([radius, chord], center=true);
    }
}

module cylinder_de_square(h,r1,r2,center=false) {
    scale = r1 != 0 ? r2/r1 : r1/r2;
    base = r1 != 0 ? r1 : r2;
    flip = r1 == 0;
    translate([0, 0, flip?h:0])
        rotate([flip?180:0,0,0])
            linear_extrude(h,scale=scale,center=center)
                circ_de_square(base);
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
                    square_de_square(radius*2, center=true);
            };
            rotate(angle / 2, [0, 1, 0])
                linear_extrude(chord)
                    square_de_square(radius*2, center=true);
            rotate(-angle / 2, [0, 1, 0])
                translate([0, 0, -chord])
                    linear_extrude(chord)
                        square_de_square(radius*2, center=true);
        }
    }
}

module cube_de_square(side_length, center=false) {
    if (is_list(side_length)) {
        linear_extrude(side_length.z, center=center)
            square_de_square([side_length.x, side_length.y], center=center);
    } else {
        linear_extrude(side_length, center=center)
            square_de_square(side_length, center=center);
    }
}
