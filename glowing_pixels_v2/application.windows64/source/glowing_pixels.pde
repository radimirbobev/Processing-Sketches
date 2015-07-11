int count_x = 256;
int count_y = 256;
Square[][] squares = new Square[count_x][count_y];
int sq_width;
int sq_height;

void setup() {
  size( 512, 512 );
  background( 0, 0, 0 );
  
  sq_width = width/count_x;
  sq_height = height/count_y;

  for ( int i=0; i<count_x; i++ ) {
    for ( int ii=0; ii<count_y; ii++ ) {
      squares[i][ii] = new Square( sq_width*i, sq_height*ii, (int) random( 0, 255 ) );      
    }
  }  
}

void draw() {
  for ( int i=0; i<count_x; i++ ) {
    for ( int ii=0; ii<count_y; ii++ ) {
      squares[i][ii].update();      
    }
  }
}

class Square {
  int x;
  int y;
  int c;
  int dir;
 
  Square( int startx, int starty, int startc ) {
    x = startx;
    y = starty;
    c = startc;
    dir = 1;
    int temp = (int) random(1,2); 
    if ( temp == 1 ) dir *= -1;
  }
  
  void update() {
    c += dir * 2;
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
}
