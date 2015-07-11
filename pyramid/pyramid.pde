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

float p_base_size = 150;
float p_height = 220;
float s_size = 70;
PVector b1 = new PVector( -p_base_size*0.5f, p_height*0.5f,-p_base_size*0.5f );
PVector b2 = new PVector( -p_base_size*0.5f, p_height*0.5f, p_base_size*0.5f );
PVector b3 = new PVector( p_base_size*0.5f, p_height*0.5f, p_base_size*0.5f );
PVector b4 = new PVector( p_base_size*0.5f, p_height*0.5f,-p_base_size*0.5f );

PVector t1 = new PVector( -p_base_size*0.5f, -p_height*0.5f,-p_base_size*0.5f );
PVector t2 = new PVector( -p_base_size*0.5f, -p_height*0.5f, p_base_size*0.5f );
PVector t3 = new PVector( p_base_size*0.5f, -p_height*0.5f, p_base_size*0.5f );
PVector t4 = new PVector( p_base_size*0.5f, -p_height*0.5f,-p_base_size*0.5f );

void setup_() {
  size( 450, 450, P3D );
  smooth(8);
  perspective( PI*0.5f, 1, 50, 1000 );
}

void draw_() {
	background( 0 );

	b1.x = -p_base_size*0.5f*Pulse_t(180);
	b1.z = -p_base_size*0.5f*Pulse_t(180);
	b2.x = -p_base_size*0.5f*Pulse_t(180);
	b2.z = p_base_size*0.5f*Pulse_t(180);
	b3.x = p_base_size*0.5f*Pulse_t(180);
	b3.z = p_base_size*0.5f*Pulse_t(180);
	b4.x = p_base_size*0.5f*Pulse_t(180);
	b4.z = -p_base_size*0.5f*Pulse_t(180);

	t1.x = -p_base_size*0.5f*Pulse_t2();
	t1.z = -p_base_size*0.5f*Pulse_t2();
	t2.x = -p_base_size*0.5f*Pulse_t2();
	t2.z = p_base_size*0.5f*Pulse_t2();
	t3.x = p_base_size*0.5f*Pulse_t2();
	t3.z = p_base_size*0.5f*Pulse_t2();
	t4.x = p_base_size*0.5f*Pulse_t2();
	t4.z = -p_base_size*0.5f*Pulse_t2();


	pushMatrix();
	translate( width*0.5f, height*0.5f, 200 );
	float rot_angle = 120 * Pulse_t(180);
	rotateX( radians( -20 ) );
	rotateY( radians(rot_angle) );
	
	//rotateZ( radians(rot_angle*2) );
	noFill();
	strokeWeight( 1 );

	stroke(200);
	fill(200);
	sphereDetail(100);
	float t_y = p_height*0.5f - ( p_height - s_size*0.5 ) * Pulse_t(180);
	translate( 0,t_y,0 );
	sphere( s_size * Pulse_t(360) );
	stroke(255);
	translate( 0,-t_y,0 );

	noFill();
	strokeWeight(3);

	Side( b1,b2,t2,t1 );
	Side( b2,b3,t3,t2 );
	Side( b3,b4,t4,t3 );
	Side( b1,b4,t4,t1 );
	
	popMatrix();
}

void Side( PVector p1, PVector p2, PVector p3, PVector p4 ) {
	beginShape(QUADS);
	vertex( p1.x, p1.y, p1.z );
	vertex( p2.x, p2.y, p2.z );
	vertex( p3.x, p3.y, p3.z );
	vertex( p4.x, p4.y, p4.z );
	endShape(CLOSE);
}

float Pulse_t( float period ) {
	return abs(sin(radians(t*period)));
}

float Pulse_t2() {
	return abs(cos(radians(t*180)));
}