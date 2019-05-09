interface Displayable {
  void display();
}
interface Moveable {
  void move();
}
interface Collideable {
  boolean isTouching(Thing other);
}
class Thing {
  float x, y;

  Thing(float x, float y) {
    this.x = x;
    this.y = y;
  }
}

class Rock extends Thing implements Displayable {
  PImage img;
  Rock(float x, float y) {
    super(x, y);
    int n = (int)random(2);
    if (n==1) img = loadImage("rock.png");
    else img = loadImage("rock2.png");
    img.resize(40,40);
  }

  void display() {
    image(img, x,y);
  }
}

public class LivingRock extends Rock implements Moveable {
  LivingRock(float x, float y) {
    super(x, y);
  }
  void move() {
    //remove prev circle.

    // RANDOM MOVEMENT
    ArrayList<Integer> dirs = new ArrayList<Integer>();

    if (x > 25) {
      //add (-1,0) to move directions.
      dirs.add(-1);
      dirs.add(0);
    } 
    if (x<975) {
      //add (1,0) to move directions.
      dirs.add(1);
      dirs.add(0);
    }
    if (y>25) {
      //add (1,0) to move directions.
      dirs.add(0);
      dirs.add(-1);
    }
    if (y<775) {
      //add (1,0) to move directions.
      dirs.add(0);
      dirs.add(1);
    }

    int r = (int) (Math.random() * (dirs.size()/2));
    x += dirs.get(r);
    y += dirs.get(r+1);
  }
  
}

class Ball extends Thing implements Displayable, Moveable {
  float xspeed;
  float yspeed;
  int color1;
  int color2;
  int color3;
  Ball(float x, float y) {
    super(x, y);
    xspeed = random(-3,3);
    yspeed = random(-3,3);
    color1 = (int)random(255);
    color2 = (int)random(255);
    color3 = (int)random(255);
  }

  void display() {
    fill(color1,color2,color3);
    ellipse(x,y,50,50);
  }

  void move() {
    x += xspeed;
    y += yspeed;
    if (x >= 975 || x <= 25){
      xspeed *= -1;
      xspeed += random(-2,2);
    }
    if (y >= 775 || y <= 25){
      yspeed *= -1;
      yspeed += random(-2,2);
    }
  }
}

class FootBall extends Ball{ 
  FootBall(float x, float y){
    super(x,y);
  }  
  
  void display(){
     beginShape();
     curveVertex(x,y);
     curveVertex(x,y);
     curveVertex(x+20,y-10);
     curveVertex(x+40,y);
     curveVertex(x+20,y+10);
     curveVertex(x,y);
     curveVertex(x,y);
     endShape();
  }
  
}

/*
class BasketBall extends Ball{}
*/

ArrayList<Displayable> thingsToDisplay;
ArrayList<Moveable> thingsToMove;

void setup() {
  size(1000, 800);
  PImage imgy = loadImage("rock.png");
  PImage imgz = loadImage("rock.png");
  

  thingsToDisplay = new ArrayList<Displayable>();
  thingsToMove = new ArrayList<Moveable>();
  for (int i = 0; i < 10; i++) {
    Ball b = new FootBall(50+random(width-100), 50+random(height)-100);
    thingsToDisplay.add(b);
    thingsToMove.add(b);
    Rock r = new Rock(50+random(width-100), 50+random(height)-100);
    thingsToDisplay.add(r);
  }
  for (int i=0;i<3;i++) {
    LivingRock m = new LivingRock(50+random(width-100), 50+random(height)-100);
    thingsToDisplay.add(m);
    thingsToMove.add(m);
  }
  
}

void draw() {
  background(255);

  for (Displayable thing : thingsToDisplay) {
    thing.display();
  }
  for (Moveable thing : thingsToMove) {
    thing.move();
  }
}
