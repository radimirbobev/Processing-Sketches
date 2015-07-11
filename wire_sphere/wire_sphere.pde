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

    if ( recording ) saveFrame("out/export###.png");
    if (frameCount==numFrames)
      exit();
    }
}

int samplesPerFrame = 32;
int numFrames = 90;
float shutterAngle = .6;
boolean recording = true;

// End of motion blur, start sketch code

float sphereSize = 118;

void setup_() {
  size( 290, 290, P3D );
  smooth(8);
  perspective( PI*0.5f.3, 1, 100, 1000 );
}

void draw_() {
  colorMode( RGB, 255 );
  background( 0 );
  pushMatrix();
  translate( width*0.5f, height*0.5f, sphereSize );
  beginShape();
  noFill();
  strokeWeight(2);
  stroke( 255 );
  rotateZ( radians( 90 ) );
  float y = map( t, 0.25, 0.5, 255, 0 );
  if ( t > 0.5 )
    y = map( t, 0.5, 0.75, 0, 255 );
  stroke( 255,255,y );
  rotateY( radians( map( t, 0, 1, 0, 360 ) ) );
  int detail = floor( abs( sin( radians(t*180) ) ) * 30 );
  sphereDetail( 5 + detail );
  endShape();
  sphere( sphereSize );
  popMatrix();
}



