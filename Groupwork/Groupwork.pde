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
  int num; 
  int[][] moves;
  int random;
  int xMove;
  int yMove;
  Ball(float x, float y) {
    super(x, y);
    moves = new int[][] {{-1, -1}, {0, -1}, {1, -1}, {1, 0}, {1, 1}, {0, 1}, {-1, 1}, {-1, 0}};
    random = (int) random(8);
    xMove = moves[random][0];
    yMove = moves[random][1];
  }

  void display() {
    PImage img; 
    if (num == 0) img = loadImage("GolfBall.png");
    if (num == 1) img = loadImage("SoccerBall.png");
    if (num == 2) img = loadImage("BasketBall.png");
    else img = loadImage("FootBall.png");
    img.resize(20, 20);
    image(img, x, y);
  }

  void move() {
    x += xMove;
    y += yMove;
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