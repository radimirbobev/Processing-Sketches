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
int numFrames = 240;
float shutterAngle = .6;
boolean recording = true;

// End of motion blur, start sketch code

float tri_angle;
float radius = 150;
int max_tris = 90;
color tri_colors[] = new color[max_tris];
float lower_threshold = 0.2;
float upper_threshold = 0.8;

void setup_() {
  size( 400, 400, P2D );
  smooth(8);
}

void draw_() {
	Fill_Colors();
	colorMode( RGB, 255 );
	background( 255 );
	strokeWeight( 1 );

	float start_tris = 5;
	float start_angle = 360/start_tris;
	float cur_offset = map( t, 0, lower_threshold, 0, 360-start_angle );
	
	// build triangles
	if ( t <= lower_threshold ) {
		for ( int i=0; i<start_tris; i++ ) {
			if ( t >= lower_threshold/start_tris*i ) {
				pushMatrix();
				translate( width*0.5f, height*0.5f );
				int index = floor(map( i, 0, start_tris, 0, max_tris ));
				color c = tri_colors[index];
				Section( radius, cur_offset - i*start_angle, start_angle, c );
				popMatrix();
			}
		}
	}
	// spin wheel
	else {
		int sides = 5;
		if ( t <= upper_threshold ) {
			sides = min( max_tris, floor( map( t, lower_threshold, 0.45, 5, max_tris*0.5f ) ) );
			if ( t > 0.45 ) sides = min( max_tris, floor( map( t, 0.45, 0.5, max_tris*0.5f, max_tris ) ) );
			if ( t > 0.5 ) sides = min( max_tris, floor( map( t, 0.5, 0.55, max_tris, max_tris*0.5f ) ) );
			if ( t > 0.55 ) sides = min( max_tris, floor( map( t, 0.55, upper_threshold, max_tris*0.5f, 5 ) ) );
			pushMatrix();
			translate( width*0.5f, height*0.5f );
			rotate( radians( (t-lower_threshold)*360 ) );
			Full_Circle( sides );
			popMatrix();
		}
		// deconstruct triangles
		else {
			Fill_Colors();
			cur_offset = map( t, upper_threshold, 1, 0, 360 );
			int end_tris = floor( map( t, upper_threshold, 1, 5, 1 ) );
			for ( int i=0; i<end_tris; i++ ) {
					pushMatrix();
					translate( width*0.5f, height*0.5f );
					int index = ceil(map( i, 0, start_tris, 0, max_tris-1 ));
					color c = tri_colors[index];
					Section( radius, cur_offset - i*start_angle, start_angle, c );
					popMatrix();
			}
		}

	}
}

void Section( float r, float offset, float angle, color c ) {
	fill( c );
	stroke( 0 );

	pushMatrix();
	//translate( width*0.5f, height*0.5f );
	rotate( radians(offset) );
	float outer_side = tan(radians(angle*0.5f)) * r;
	triangle( 0,0, -outer_side,-r, outer_side,-r );
	popMatrix();
}

void Full_Circle( int sides ) {
	float a = 360f/sides;
	for ( int i=0; i<sides; i++ ) {
		int index = floor(map( i, 0, sides, 0, max_tris ));
		int shift = min( max_tris, floor( map( t, lower_threshold, 1, 0, 200 ) ) );
		Shift_Colors( shift );
		color c = tri_colors[index];
		Section( radius, i*a, a, c );
	}
}

void Fill_Colors() {
	for ( int i=0; i<max_tris; i++ ) {
		colorMode( HSB, 1 );
		tri_colors[i] = color( map( i, 0, max_tris, 0, 1f ), 1, 1 );
	}
}

void Shift_Colors( int dist ) {
	Fill_Colors();
	color[] temp = new color[max_tris];
	for ( int i=dist; i<max_tris; i++ ) {
		temp[i-dist] = tri_colors[i];
	}
	int d = max_tris - dist;
	for ( int i=0; i<dist; i++ ) {
		temp[i+d] = tri_colors[i];
	}
	tri_colors = temp;
}