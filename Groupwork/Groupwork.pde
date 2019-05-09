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
  Ball(float x, float y) {
    super(x, y);
    xspeed = random(-2,2);
    yspeed = random(-2,2);
  }

  void display() {
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
  int savedTime; //implementing a timer, got help from documentation 
  int totalTime; //time of each zigzag 
  boolean vert; //horizontal or vertical zigzag 
  color c = color(random(256), random(256), random(256)); //fill in random color once 
  
  FootBall(float x, float y){
    super(x,y);
    savedTime = millis(); //starts time 
    totalTime = (int)random(300, 2000); //randomizes time of each zigzag
    vert = ((int)random(2) == 1); //horizontal or vertical zigzag
  }  
  
  void display(){ //draws a football shape 
    fill(c);
    beginShape();
    curveVertex(x,y);
    curveVertex(x,y);
    curveVertex(x+40,y-20);
    curveVertex(x+80,y);
    curveVertex(x+40,y+20);
    curveVertex(x,y);
    curveVertex(x,y);
    endShape();
  }
  
  void move(){
    x += xspeed; //updates xcor
    y += yspeed; //updates ycor
    
    //code for bouncing off sides 
    if (x >= 920 || x <= 0){ 
      xspeed *= -1;
      xspeed += random(-1,1); //changes the angle slightly 
      yspeed += random(-1,1);
    }
    if (y >= 780 || y <= 20){
      yspeed *= -1;
      xspeed += random(-1,1);
      yspeed += random(-1,1); 
    }
    
    int passedTime = millis() - savedTime; //keeps track of elapsed time 
    if (passedTime > totalTime){ 
      if (vert){ //vertical zigzag 
        xspeed += random(-2,2); //randomizes zigzag a little 
        xspeed *= -1;
      }
      else{ //horizontal zigzag 
        yspeed += random(-2,2);
        yspeed *= -1;
      }
      savedTime = millis(); //resets timer
    }
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
