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

int angle = 0;

void setup_() {
	size( 350, 350, P3D );
	smooth(8);
	perspective( PI*0.5f.3, 1, 100, 1000 );
	
	background(0);
	lights();
}

int boxsize = 200;

void draw_() {
	background( 0 );

	blendMode( BLEND );
	pushMatrix();
	translate( width*0.5f, height*0.5f, -200 );
	colorMode( RGB, 255 );
	float c = map( t, 0, 0.5, 255, 0 );
	if ( t > 0.5 ) c = map( t, 0.5, 1, 0, 255 );
	stroke( c );
	strokeWeight(3);
	fill( 0 );
	rotateY( radians( t*360 ) );
	int d = ceil( map( t, 0, 0.5, 10, 300 ) );
	if ( t > 0.5 ) d = ceil( map( t, 0.5, 1, 300, 10 ) );
	sphereDetail(d);
	sphere( boxsize*1.45 );
	popMatrix();

	blendMode( EXCLUSION );
	colorMode( HSB, 1 );
	pushMatrix();
	translate( width*0.5f, height*0.5f, 0 );
	rotateY( radians( map( t, 0, 1, 0, 359 ) ) );
	rotateX( radians(45) );
	fill( t, 1, 1 );
	stroke( t, 1, 1 );
	box( boxsize );
	popMatrix();

	pushMatrix();
	translate( width*0.5f, height*0.5f, 0 );
	rotateX( radians( map( t, 0, 1, 0, 359 ) ) );
	rotateY( radians(45) );
	fill( t, 1, 1 );
	stroke( t, 1, 1 );
	box( boxsize );
	popMatrix();

}

