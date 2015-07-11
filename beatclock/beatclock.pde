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
int numFrames = 120;
float shutterAngle = .6;
boolean recording = true;

// End of motion blur, start sketch code

int PULSERS = 4;
Pulser[] pulsers = new Pulser[PULSERS];
PVector ballpos;
int ballsize = 20;
int active_pulsers;
int r = 70;

void setup_() {
  size( 300, 300, P2D );
  smooth(8);
  strokeWeight(7);
  ballpos = new PVector( width*0.5f, 100 );
  active_pulsers = 0;
  //perspective( PI/2.3, 1, 100, 1000 );
}

void draw_() {
	background( 255,255,255 );
	PVector midpoint = new PVector( width*0.5f, height*0.5f );
	int x_offset = round( r*sin( -t*TWO_PI ) );
	int y_offset = round( r*cos( -t*TWO_PI ) );
	ballpos.x = midpoint.x - x_offset;
	ballpos.y = midpoint.y - y_offset;
	x_offset = abs( x_offset );
	y_offset = abs( y_offset );
	fill(255);
	stroke(100);
	ellipseMode(CENTER);
	ellipse( midpoint.x, midpoint.y, 2*r, 2*r );
	fill(150);
	stroke(150);
	ellipse( midpoint.x, midpoint.y, ballsize/2, ballsize/2 );

	pushMatrix();
	translate( midpoint.x, midpoint.y );
	rotate( radians(t*360) );
	float m = map( t, 0, 0.125, 1, 0 );
	if ( t > 0.125 ) m = map( t, 0.125, 0.25, 0, 1 );
	if ( t > 0.25 ) m = map( t, 0.25, 0.375, 1, 0 );
	if ( t > 0.375 ) m = map( t, 0.375, 0.5, 0, 1 );
	if ( t > 0.5 ) m = map( t, 0.5, 0.625, 1, 0 );
	if ( t > 0.625 ) m = map( t, 0.625, 0.75, 0, 1 );
	if ( t > 0.75 ) m = map( t, 0.75, 0.875, 1, 0 );
	if ( t > 0.875 ) m = map( t, 0.875, 1, 0, 1 );
	ellipse( 0, -m*r, ballsize*0.5f, ballsize*0.5f );
	popMatrix();

	if ( ( x_offset == r && y_offset == 0 ) ||
		 ( x_offset == 0 && y_offset == r ) ||
		 ( x_offset == r && y_offset == r ) ||
		 ( x_offset == 0 && y_offset == 0 ) ) SpawnPulser( ballpos.x, ballpos.y );

	for ( int i=0; i<PULSERS; i++ ) {
		if ( pulsers[i] != null ) pulsers[i].Update();
	}

	stroke(0);
	fill(0);
	ellipse( ballpos.x, ballpos.y, ballsize, ballsize );
}

void SpawnPulser( float x, float y ) {
	int id = 0;
	if ( t < 1.0f ) id = 0;
	if ( t < 0.75f ) id = 1;
	if ( t < 0.5f ) id = 2;
	if ( t < 0.25f ) id = 3;
	if ( pulsers[id] == null ) pulsers[id] = new Pulser( new PVector( x,y ), id );
}

class Pulser {
	PVector pos;
	float s;
	int id;
	float spawntime;

	Pulser( PVector startPos, int newId ) {
		pos = startPos;
		s = 10;
		id = newId;
		spawntime = t;
	}

	void Update() {
		pushMatrix();
		translate( pos.x, pos.y );
		for ( int i=0; i<8; i++ ) {
			fill( random( 0,255 ), random( 0,255 ), random( 0,255 ) );
			stroke( random( 0,255 ), random( 0,255 ), random( 0,255 ) );
			line( 0,s , 0,s+10 );
			s = map( t, spawntime, spawntime+0.25, 10, width );
			rotate( radians( 360/8 ) );
		}
		popMatrix();
	}
}