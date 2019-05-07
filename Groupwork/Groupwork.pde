interface Displayable {
  void display();
}
interface Moveable {
  void move();
}
class Thing {
  float x, y;

  Thing(float x, float y) {
    this.x = x;
    this.y = y;
  }
}

class Rock extends Thing implements Displayable {
  Rock(float x, float y) {
    super(x, y);
  }

  void display() { 
    fill(100, 200, 0);
    ellipse(x, y, 50.0, 50.0);
  }
}

public class LivingRock extends Rock implements Moveable {
  LivingRock(float x, float y) {
    super(x, y);
  }
  void move() {
    //remove prev circle.

    ArrayList<Integer> dirs = new ArrayList<Integer>();

    if (x!= 0) {
      //add (-1,0) to move directions.
      dirs.add(-1);
      dirs.add(0);
    } 
    if (x!=width) {
      //add (1,0) to move directions.
      dirs.add(1);
      dirs.add(0);
    }
    if (y!=0) {
      //add (1,0) to move directions.
      dirs.add(0);
      dirs.add(-1);
    }
    if (y!=height) {
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
    if (x >= 1000 || x <= 0){
      xspeed *= -1;
    }
    if (y >= 800 || y <= 0){
      yspeed *= -1;
    }
  }
}

ArrayList<Displayable> thingsToDisplay;
ArrayList<Moveable> thingsToMove;

void setup() {
  size(1000, 800);

  thingsToDisplay = new ArrayList<Displayable>();
  thingsToMove = new ArrayList<Moveable>();
  for (int i = 0; i < 10; i++) {
    Ball b = new Ball(50+random(width-100), 50+random(height)-100);
    thingsToDisplay.add(b);
    thingsToMove.add(b);
    Rock r = new Rock(50+random(width-100), 50+random(height)-100);
    thingsToDisplay.add(r);
  }

  LivingRock m = new LivingRock(50+random(width-100), 50+random(height)-100);
  thingsToDisplay.add(m);
  thingsToMove.add(m);
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