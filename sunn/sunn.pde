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

float wave_duration = 0.5;
float wave_height = 350;

void setup_() {
  size( 512, 300, P2D );
  smooth(8);
}

void draw_() {
	background(255);

	pushMatrix();
	translate( width*0.5f, height*0.5f );
	ellipseMode(CENTER);
	
	float[] wave_times = new float[]{ 0.25, 0.5, 0.75 };
	Wave( 0 );
	if ( t < wave_times[0] ) Wave( -wave_duration*0.5f ); // "leftover" wave that starts halfway faded for proper looping
	for ( int i=0; i<3; i++ ) {
		if ( t > wave_times[i] ) Wave( wave_times[i] );
	}

	CirclePart( 0, 180, 20, 1.2 );
	CirclePart( 255, 160, 25, 1 );
	CirclePart( 0, 130, 20, 1.16 );
	CirclePart( 255, 120, 20, 1 );
	CirclePart( 0, 90, 25, 1 );

	popMatrix();
}

void Wave( float start_time ) {
	float weight = map( t, start_time, start_time+wave_duration, 25, 13 );
	float w = map( t, start_time, start_time+wave_duration, 660, 900 );
	float h = map( t, start_time, start_time+wave_duration, wave_height, wave_height+100 );
	float c = map( t, start_time, start_time+wave_duration, 0, 255 );
	fill(255, 0);
	stroke(c);
	strokeWeight(weight);
	arc(-200, 0, w, h, -PI / 6, PI / 6);
	arc(200, 0, -w, h, -PI / 6, PI / 6);
}

void CirclePart( float c, float factor_start, float factor_extra, float multiplier ) {
	float period = 720;
	fill(c);
	stroke(c);
	strokeWeight(1);
	float s1 = factor_start + factor_extra*abs( sin( radians( t*period ) ) );
	ellipse( 0,0, multiplier*s1, s1 );
}