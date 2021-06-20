// This work is licensed under a Creative Commons Attribution-ShareAlike 3.0 Unported License.
// https://creativecommons.org/licenses/by-sa/3.0/
// Shawn Rutledge 2021
// Mockup of a case for a hypothetical digital assistant or other touchscreen device

width = 180;
bottomDepth = 80;
topDepth = 12;
height = 150;
backTilt = 12;
outerRadius = 4;
cutoutRadius = width / 2 - 1;
thickness = 2;
buttonProportions=[0.2, 0.6, 0.2];
buttonSpacing = 6;
buttonDepth = 12;
buttonGap = 0.5;
screenMargins = 10;
screenBottomMargin = 30;
screenCornerRadius = 5;

$fn=48;

module round4CornersCube( x, y, z, r ) {
	hull() {
		translate([r, r, 0]) cylinder(r=r, h=z);
		translate([x-r, r, 0]) cylinder(r=r, h=z);
		translate([x-r, y-r, 0]) cylinder(r=r, h=z);
		translate([r, y-r, 0]) cylinder(r=r, h=z);
	}
}

module roundedCube( x, y, z, r ) {
	hull() {
		translate([r, r, r]) sphere(r);
		translate([r, y-r, r]) sphere(r);
		translate([r, r, z-r]) sphere(r);
		translate([r, y-r, z-r]) sphere(r);
		translate([x-r, r, r]) sphere(r);
		translate([x-r, y-r, r]) sphere(r);
		translate([x-r, r, z-r]) sphere(r);
		translate([x-r, y-r, z-r]) sphere(r);
	}
}

module envelope(shrink=0) {
	r = outerRadius;
	x = bottomDepth-shrink;
	y = width-shrink;
	z = height-shrink;
	xft = topDepth - bottomDepth - backTilt;
	xbt = xft - topDepth - backTilt + shrink;
	intersection () {
		translate([-bottomDepth-topDepth-backTilt, 0, 0])
			cube([bottomDepth * 2, width, height]);
		hull() {
			translate([0, r, -r]) sphere(r);
			translate([0, y-r, -r]) sphere(r);
			translate([xft, r, z-r]) sphere(r);
			translate([xft, y-r, z-r]) sphere(r);
			translate([r-x, r, -r]) sphere(r);
			translate([r-x, y-r, -r]) sphere(r);
			translate([xbt+r, r, z-r]) sphere(r);
			translate([xbt+r, y-r, z-r]) sphere(r);
		}
	}
}

function buttonSumTo(endI, i=0) =
	i < endI ?
	buttonProportions[i] + buttonSumTo(endI, i + 1) :
	0;

module button(i) {
	totalButtonWidth = buttonSumTo(len(buttonProportions)) * width - buttonSpacing * (len(buttonProportions) + 1);
	xn = buttonSumTo(i);
	translate([-bottomDepth - backTilt + (topDepth - buttonDepth) / 2 - outerRadius,
				buttonGap + (buttonSpacing * (i + 1) + (xn * totalButtonWidth)),
				height - thickness * 2])
		round4CornersCube(buttonDepth - buttonGap * 2,  buttonProportions[i] * totalButtonWidth - buttonGap * 2, thickness * 3, 2);
}

module case() {
	frontTilt = topDepth - bottomDepth - backTilt;
	frontHeight = sqrt(height * height + frontTilt * frontTilt); // pythag
	frontAngle = atan(frontTilt / height);
	screenWidth = width - screenMargins * 2;
	screenHeight = frontHeight - screenMargins - screenBottomMargin;
	difference() {
		envelope();
		translate([-thickness, thickness, thickness])
			envelope(thickness * 2);

		totalButtonWidth = buttonSumTo(len(buttonProportions)) * width - buttonSpacing * (len(buttonProportions) + 1);
		for ( i = [0:1:len(buttonProportions)-1]) {
			xn = buttonSumTo(i);
			echo (i, xn, buttonProportions[i]);
			translate([- bottomDepth - backTilt + (topDepth - buttonDepth) / 2 - outerRadius,
						(buttonSpacing * (i + 1) + (xn * totalButtonWidth)),
						height - thickness * 2])
				round4CornersCube(buttonDepth,  buttonProportions[i] * totalButtonWidth, thickness * 3, 2);
		}
		translate([-13, screenMargins, screenBottomMargin])
			rotate([0, frontAngle - 90, 0])
				round4CornersCube(screenHeight, screenWidth, thickness * 2, screenCornerRadius);
	}
}

case();

button(0);
