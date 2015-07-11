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
  /*
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
    */

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

int count_x = 25;
int count_y = 25;
Square[][] squares = new Square[count_x][count_y];
int sq_width;
int sq_height;
int line1_x = 0;
int line1_y = 0;
int line2_x = count_x-1;
int line2_y = count_y-1;
int line3_x = 0;
int line3_y = count_y-1;
int line4_x = count_x-1;
int line4_y = 0;

void setup_() {
  size( 300, 300 );
  background( 0, 0, 0 );
  
  sq_width = width/count_x;
  sq_height = height/count_y;

  for ( int i=0; i<count_x; i++ ) {
    for ( int ii=0; ii<count_y; ii++ ) {
      squares[i][ii] = new Square( sq_width*i, sq_height*ii, (int) random( 0, 255 ) );      
    }
  }
}

void draw_() {
  for ( int i=0; i<count_x; i++ ) {
    for ( int ii=0; ii<count_y; ii++ ) {
      squares[i][ii].update();      
    }
  }
  squares[line1_x][line1_y].black();
  squares[line2_x][line2_y].black();
  squares[line3_x][line3_y].black();
  squares[line4_x][line4_y].black();

  float vel = count_x*count_y/numFrames;
  line1_y += vel;
  if ( line1_y >= count_y-1 ) {
    line1_x++;
    if ( line1_x == count_x ) line1_x = 0;
    line1_y = 0;
  }
  line2_y -= vel;
  if ( line2_y <= 0 ) {
    line2_x--;
    if ( line2_x < 0 ) line2_x = count_x-1;
    line2_y = count_y-1;
  }
  line3_x += vel;
  if ( line3_x >= count_x-1 ) {
    line3_y--;
    if ( line3_y < 0 ) line3_y = count_y-1;
    line3_x = 0;
  }
  line4_x -= vel;
  if ( line4_x <= 0 ) {
    line4_y++;
    if ( line4_y == count_y ) line4_y = 0;
    line4_x = count_x-1;
  }
}

class Square {
  int x;
  int y;
  float c;
  int dir;
   
  Square( int startx, int starty, float startc ) {
    x = startx;
    y = starty;
    c = startc;
    dir = 1; 
  }
    
  void update() {
    float vel = 512f/numFrames * dir;
    c += vel;
    if ( c < 0 ) {
      c = 0;
      dir *= -1;
    }
    if ( c > 255 ) {
      c = 255;
      dir *= -1;
    }
      
    fill( c );
    stroke( c );
    rect( x, y, sq_width, sq_height );
  }

  void black() {
      fill(0);
      stroke(0);
      rect( x, y, sq_width, sq_height );
  }
}