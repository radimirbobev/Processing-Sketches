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
int numFrames = 60;
float shutterAngle = .6;
boolean recording = true;

// End of motion blur, start sketch code

MovingTri[] tris = new MovingTri[4];
float x_mid;
float y_mid;
float t_size = 100;
float sx1;
float sy1;
float sx2;
float sy2;
float sx3;
float sy3;

void setup_() {
  	size( 300, 300, P2D );
  	smooth(8);
  	x_mid = width*0.5f;
  	y_mid = height*0.5f + 40;
  	sx1 = x_mid - t_size*0.5f;
	sy1 = y_mid - t_size*0.165;
	sx2 = x_mid + t_size*0.5f;
	sy2 = y_mid - t_size*0.165;
	sx3 = x_mid;
	sy3 = y_mid - t_size;
	tris[0] = new MovingTri( x_mid, y_mid, t_size, 180, true );
	tris[1] = new MovingTri( sx1, sy1, t_size, 0, false );
	tris[2] = new MovingTri( sx2, sy2, t_size, 0, false );
	tris[3] = new MovingTri( sx3, sy3, t_size, 0, false );
	tris[1].c = tris[2].c = tris[3].c = 255;
}

void draw_() {
	background( 255 );
	for ( int i=0; i<4; i++ ) {
		tris[i].DrawTri();
	}
	float tx1 = 0 - t_size*0.5f;
	float ty1 = height + t_size*0.5f;
	float tx2 = width + t_size*0.5f;
	float ty2 = height + t_size*0.5f;
	float ty3 = 0 - t_size*0.5f;

	tris[1].x = map( t, 0, 0.4, sx1, tx1 );
	tris[1].y = map( t, 0, 0.4, sy1, ty1 );
	tris[2].x = map( t, 0, 0.4, sx2, tx2 );
	tris[2].y = map( t, 0, 0.4, sy2, ty2 );
	tris[3].y = map( t, 0, 0.4, sy3, ty3 );

	tris[0].angle = map( t, 0, 1, 180, 360 );
	tris[0].c = map( t, 0, 1, 0, 255 );

	for ( int i=1; i<4; i++ ) {
		tris[i].angle = map( t, 0, 1, 0, 720 );
		tris[i].s = map( t, 0, 1, t_size, 0 );
	}
}

class MovingTri {
	float x;
	float y;
	float s;
	float angle;
	float c;
	boolean mid;

	MovingTri( float startx, float starty, float startsize, float startangle, boolean ismid ) {
		x = startx;
		y = starty;
		s = startsize;
		angle = startangle;
		mid = ismid;
		c = 0;
	}

	void DrawTri() {
		float x1, y1, x2, y2, x3, y3;
		x1 = 0 - s*0.5f;
		float start_y1 = y1 = 0 + s*0.5f;
		x2 = 0 + s*0.5f;
		float start_y2 = y2 = 0 + s*0.5f;
		x3 = 0;
		float start_y3 = y3 = 0 - 0.33 * s;

		fill( c,0,0 );
		stroke( c,0,0 );
		pushMatrix();
		if ( !mid ) {
			translate( x, y );
		}
		else {
			float temp = 0.34*s;
			translate( x, y-temp );
			y1 = map( t, 0, 1, y1-temp, start_y1 );
			y2 = map( t, 0, 1, y2-temp, start_y2 );
			y3 = map( t, 0, 1, y3-temp, start_y3 );
			s = map( t, 0, 1, t_size, 2*t_size );			
		}
		rotate( radians(angle) );
		triangle( x1, y1, x2, y2, x3, y3 );
		popMatrix();
	}
}