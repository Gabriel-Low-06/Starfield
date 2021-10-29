float globalspeed = 10; //how fast the ship is moving
class Asteroid { 
  int[] coordinates=new int[3]; //self-explanatory local variable declaration
  int[]velocity = {0, 0, (int)globalspeed};
  float[] torque = new float[3];
  float[]spin = new float[3];
  int shade;
  int[] config = new int[3];  

  Asteroid(boolean far) {
    shade=(int)(random(50, 200)); //give asteroid random color, setup, rotation
    int[] loadcon = {(int)(random(0, 50)), (int)(random(0, 50)), (int)(random(25, 75))};
    float[] loadrot = {random(0, 8), random(0, 8), random(0, 8)};
    float[] loadtor = {random(-.1, .1), random(-.1, .1), random(-.1, .1)};

    int[] loadcoord = {(int)(random(0, 1200)), (int)(random(0, 800)), (int)(random(-5000, 0))};
    if (far==true) { //if its respawning, respawn in middle
      loadcoord[2]=(int)random(-7000, -6000);
    }
    spin=loadrot; //initalize variables from randomly generated
    torque=loadtor;
    coordinates=loadcoord;
    config=loadcon;
  }
  void paint() {

    velocity[2]=(int)globalspeed; //update velocity based on global speed
    pushMatrix();
    strokeWeight(1);
    stroke(0, 0, 0);
    translate(coordinates[0], coordinates[1], coordinates[2]); //move asteroid to location in 3d space
    rotateX(spin[0]); 
    rotateY(spin[1]);//rotate accordingly
    rotateZ(spin[2]);
    for (int i=0; i<3; i++) { //update position and coordinates based on velocity and torque
      spin[i]+=torque[i]/5;
      coordinates[i]+=velocity[i];
    }
    fill(shade, shade, shade);
    sphereDetail(7); //control resolution of asteroid
    sphere(50); //draw asteroid
    translate(config[0], config[1], 0);
    sphere(config[2]);
    popMatrix();
  }
}

class Stars {
  float x, y; //self explantory local viarables
  float velocity, theta;
  int mycolor;
  int s = (int)random(0, 7);
  Stars() {
    x=(int)random(0, 1100); //place randomly on screen
    y=(int)(random(0, 700)); 
    theta=atan((y-350)/(x-550)); //point star to move away from center of screen
    if (x<550) {
      theta+=3.141592;
    }
    velocity=globalspeed/13;
    mycolor=color(255, 255, 255);
  }
  void paint() {
    velocity=globalspeed/13; //update velocity based on globalspeed
    fill(mycolor);
    noStroke();
    if (globalspeed<50) {
      ellipse(x, y, s, s); //draw star
    } else {
      strokeWeight(s/25+1); //if moving fast, draw it as line
      if (globalspeed>300 && s<10) { //if in 'hyperspace' give blue tint
        mycolor=color(150, 200, 300);
      }
      stroke(mycolor);

      line(x, y, x-(velocity*cos(theta)), y-velocity*sin(theta));
    }
    x+=velocity*cos(theta);
    y+=velocity*sin(theta); //update position from velocity and rotation
  }
}

class Fireballs extends Stars {
  Fireballs() {
    x=(int)random(0, 1100); //place randomly on screen
    y=(int)(random(0, 700)); 
    mycolor=color(255, 100, 100);
    s=30;
    theta=random(0, 7);
  }
}

Asteroid[] rocks = new Asteroid[15]; //declare asteroids and stars
Stars[] streaks = new Stars[30];

void setup() {
  size(1100, 700, P3D);
  for (int i=0; i<30; i++) {
    if (i<28) {
      streaks[i] = new Stars();
    } else {
      streaks[i]=new Fireballs();
    }
  }
  for (int q=0; q<15; q++) {
    rocks[q]=new Asteroid(false);
  }
}

void draw() {
  if (globalspeed>300) { //break barrier
    globalspeed=600;
  } else if (mousePressed==true) { //control acceleration and velocity
    globalspeed+=.5;
  } else if (globalspeed>0) {
    globalspeed-=.3;
  }
  pushMatrix();
  translate(-4550, -2900, -5000); //move stars and background behind asteroid
  scale(9.25, 9.25);
  fill(0, 0, 0, 70); //create blurred effect while refreshing frame
  noStroke();
  rect(0, 0, 1100, 700);
  for (int i=0; i<30; i++) { //draw stars
    streaks[i].paint();
    if (streaks[i].x>1100||streaks[i].x<0||streaks[i].y>700||streaks[i].y<0) {
      if (i<28) {
        streaks[i] = new Stars();
      } else {
        streaks[i]=new Fireballs();
      }
    }
  }
  popMatrix();

  for (int q=0; q<15; q++) {
    if (globalspeed<300) {
      rocks[q].paint(); //draw asteroids
    }
    if (rocks[q].coordinates[2]>500) {
      rocks[q]=new Asteroid(true);
    }
  }
}


