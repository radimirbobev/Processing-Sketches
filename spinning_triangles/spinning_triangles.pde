int[][] result;
float t;

// Motion blur by davebees, used with permission 

void setup() {
  setup_();
  result = new int[width*height][3];
}

void draw() {
	if( !recording ) {
		t = mouseX*1.0/width;
		draw_();
 	}
  
	else {
		for (int i=0; i<width*height; i++)
			for (int a=0; a<3; a++)
				result[i][a] = 0;

		for (int sa=0; sa<samplesPerFrame; sa++) {
			t = map(frameCount-1 + sa*shutterAngle/samplesPerFrame, 0, numFrames, 0, 1);
			draw_();
			loadPixels();
			for (int i=0; i<pixels.length; i++) {
				result[i][0] += pixels[i] >> 16 & 0xff;
				result[i][1] += pixels[i] >> 8 & 0xff;
				result[i][2] += pixels[i] & 0xff;
			}
		}
	 
		loadPixels();
		for (int i=0; i<pixels.length; i++)
			pixels[i] = 0xff << 24 | (result[i][0]/samplesPerFrame) << 16 |
				(result[i][1]/samplesPerFrame) << 8 | (result[i][2]/samplesPerFrame);
		updatePixels();

		saveFrame("tri8ngls###.png");
		if (frameCount==numFrames)
	  		exit();
	}
}

int samplesPerFrame = 32;
int numFrames = 90;
float shutterAngle = .6;
boolean recording = true;

// End of motion blur, start sketch code

float angle1 = 180;
float angle2 = 0;
int cx;
int cy;
float mainSize = 200;
float y_top;
float y_top_start;
float y_top2;
float y_top2_start;


void setup_() {
	size( 400, 400, P2D );
 	smooth(8);
  	cx = width*0.5f;
	cy = height*0.5f + 20;
	y_top_start = y_top = -sqrt(3)*mainSize/3;
	y_top2_start = y_top2 = -sqrt(3)*mainSize/3;
}

void draw_() {
	background( 255 );

	angle2 = t*360;

	float target_top = y_top_start + sqrt(3)*0.5f*mainSize*0.5f;

	y_top2 = max( map( t, 0, 0.5, y_top2_start, target_top ), y_top2_start );
	y_top = max( pulse( y_top_start, target_top, 0.5, 1.0 ), y_top_start );
	if ( t > 0.85 ) y_top2 = max( map( t, 0.85, 1, target_top, y_top2_start ), y_top2_start );
	draw_tri_around( cx, cy, mainSize, 0, angle1, angle2 );
	draw_tri_around( cx, cy, mainSize*0.5f, y_top, angle1, angle2 );
	draw_tri_around( cx, cy, mainSize*0.5f, y_top, angle1, angle2+120 );
	draw_tri_around( cx, cy, mainSize*0.5f, y_top, angle1, angle2+240 );

	draw_secondaries( 0 );
	draw_secondaries( 120 );
	draw_secondaries( 240 );
}

void draw_triangle( float x, float y, float s, float angle ) {
	float x1 = -s*0.5f;
	float y1 = sqrt(3)/6*s;
	float x2 = s*0.5f;
	float y2 = y1;
	float x3 = 0;
	float y3 = -sqrt(3)/3*s;

	pushMatrix();
	translate( x,y );
	rotate( radians( angle ) );
	fill(0);
	stroke(0);
	triangle( x1, y1, x2, y2, x3, y3 );
	popMatrix();
}

void draw_tri_around( float ix, float iy, float s, float r, float tri_angle, float angle ) {
	pushMatrix();
	translate( ix, iy );
	rotate( radians( angle ) );
	draw_triangle( 0, r, s, tri_angle );
	popMatrix();
}

void draw_secondaries( float sec_angle ) {
	pushMatrix();
	translate( cx, cy );
	rotate( radians( angle2+sec_angle ) );
	draw_tri_around( 0, y_top, mainSize/4, y_top2*0.5f, angle1, 0 );
	draw_tri_around( 0, y_top, mainSize/4, y_top2*0.5f, angle1, 120 );
	draw_tri_around( 0, y_top, mainSize/4, y_top2*0.5f, angle1, 240 );
	popMatrix();
}

float pulse( float from, float to, float tfrom, float tto ) {
	float halftime = tfrom + (tto-tfrom)*0.5;
	float temp = map( t, tfrom, halftime, from, to );
	if ( t > halftime ) temp = map( t, halftime, tto, to, from );
	return temp;
}