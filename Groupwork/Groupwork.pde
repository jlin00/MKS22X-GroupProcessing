interface Displayable {
  void display();
}
interface Moveable {
  void move();
}
interface Collideable { //rocks will be collideable 
  boolean isTouching(Thing other);
}
class Thing implements Collideable{
  float x, y;

  Thing(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  boolean isTouching(Thing other){
    return dist(x, y, other.x, other.y) <= 30; //the number 30 was obtained through testing 
  }
  
}

class Rock extends Thing implements Displayable {
  PImage img; //will only be loaded once in setup
  float xspeed;
  float yspeed;
  int r; 
  int g; 
  int b;
  Rock(float x, float y, PImage img) {
    super(x, y);
    xspeed = (int) (Math.random() * 4);
    yspeed = (int) (Math.random() * 4);
    r = (int) (Math.random() * 256);
    g = (int) (Math.random() * 256);
    b = (int) (Math.random() * 256);
    this.img = img;
  }

  void display() { //loads image
    noTint();
    image(img, x, y, 40, 40);
    fill(0,255,0);
    ellipse(x+13, y+7, 4, 4);
    ellipse(x+22, y+7, 4, 4);
  }
}

public class LivingRock extends Rock implements Moveable {
  int moveMode;
  LivingRock(float x, float y, PImage img) {
    super(x, y, img);
    moveMode = (int) (Math.random() * 2); // 0 or 1.
  }
  
  void moveRandom() {
    // RANDOM MOVEMENT
    ArrayList<Integer> dirs = new ArrayList<Integer>();

    if (x > 5) {
      //add (-1,0) to move directions.
      dirs.add(-1);
      dirs.add(0);
    } 
    if (x+5<width) {
      //add (1,0) to move directions.
      dirs.add(1);
      dirs.add(0);
    }
    if (y>5) {
      //add (1,0) to move directions.
      dirs.add(0);
      dirs.add(-1);
    }
    if (y+5<height) {
      //add (1,0) to move directions.
      dirs.add(0);
      dirs.add(1);
    }

    int r = (int) (Math.random() * (dirs.size()/2));
    r *= 2;// r and r+1 are indices for move coordinates
    //System.out.println(dirs);
    x += dirs.get(r);
    y += dirs.get(r+1);
  }
  
  void moveStraight() {
     //if it is out of bounds, negate y or x speed
    if (x+xspeed < 5 || x+xspeed > (width-8)) {
      xspeed *= -1;
    }
    if (y+yspeed < 5 || y+yspeed > (height-8)) {
      yspeed *= -1;
    }
         x+= xspeed;
     y += yspeed;
  }
  
  void move() {
    //remove prev circle.
    if (moveMode == 0) moveRandom();
    if (moveMode == 1) moveStraight();
    
  }
  
}

abstract class Ball extends Thing implements Displayable, Moveable {
  float xspeed;
  float yspeed;
  Ball(float x, float y) { //creates a thing with speed
    super(x, y);
    xspeed = random(-2,2);
    yspeed = random(-2,2);
  }

  abstract void display(); //unnecessary methods that will be overidden
  abstract void move();
}

class FootBall extends Ball{ //first subclass of ball 
  int savedTime; //implementing a timer, got help from documentation 
  int totalTime; //time of each zigzag 
  boolean vert; //horizontal or vertical zigzag 
  color c = color(random(256), random(256), random(256)); //fill in random color once 
  
  FootBall(float x, float y){ //creates a football with a timer system 
    super(x,y);
    savedTime = millis(); //starts time 
    totalTime = (int)random(300, 2000); //randomizes time of each zigzag
    vert = ((int)random(2) == 1); //horizontal or vertical zigzag
  }  
  
  void display(){ //draws a football shape
    fill(c); //default color 
    for (Collideable c: collideables){
      if (c.isTouching(this)){
        fill(0,0,255); //if collides with rock, change to blue 
      }
    }
    //drawing the football
    beginShape();
    curveVertex(x,y);
    curveVertex(x,y);
    curveVertex(x+15,y-8);
    curveVertex(x+30,y);
    curveVertex(x+15,y+8);
    curveVertex(x,y);
    curveVertex(x,y);
    endShape();
  }
  
  void move(){
    x += xspeed; //updates xcor
    y += yspeed; //updates ycor
    
    //code for bouncing off sides 
    if (x >= 920 || x <= 0){ 
      xspeed *= -1; //reverse direction 
      xspeed += random(-0.5,0.5); //changes the angle slightly 
      yspeed += random(-0.5,0.5);
    }
    if (y >= 780 || y <= 8){
      yspeed *= -1; //reverse direction 
      xspeed += random(-0.5,0.5); //changes the angle slightly 
      yspeed += random(-0.5,0.5); 
    }
    
    int passedTime = millis() - savedTime; //keeps track of elapsed time 
    if (passedTime > totalTime){ 
      if (vert){ //vertical zigzag 
        xspeed += random(-0.2,0.2); //randomizes zigzag a little 
        xspeed *= -1; //creates zigzag motion by reversing direction 
      }
      else{ //horizontal zigzag 
        yspeed += random(-0.2,0.2); //randomizes zigzag a little 
        yspeed *= -1; //creates zigzag motion by reversing direction 
      }
      savedTime = millis(); //resets timer
    }
  }
  
}

class Basketball extends Ball { //second subclass of ball
  float yAcc; //for gravity effect
  PImage img; 
  
  Basketball (float x, float y, PImage img) {
    super(x, y);
    this.img = img;
    yspeed = abs(yspeed); //ball always starts off falling downward 
    yAcc = .05; //constant acceleration 
  }
  
  void display() {
    noTint(); //default color 
    for (Collideable c: collideables){
      if (c.isTouching(this)){
        tint(255, 0, 0); //tint red
      }
    }
    image(img, x, y, 30, 30);
  }
  
  void move() {
    x += xspeed;
    y += yspeed;
    yspeed += yAcc;
    if (y >= 770 || y <= 0) { //code for bouncing off the edge 
      yspeed += random(-0.8,0.8); //changes speed slightly 
      yspeed *= -1; //reverses direction 
    }
    if (x >= 970 || x <= 0){ //code for bouncing off the edge 
      xspeed += random(-0.8,0.8); //changes speed slightly 
      xspeed *= -1; //reverses direction 
    }
  }
}

ArrayList<Displayable> thingsToDisplay;
ArrayList<Moveable> thingsToMove;
ArrayList<Collideable> collideables; //list of collideables (rocks) 

void setup() {
  size(1000, 800);
  
  //loads images onces
  PImage img1 = loadImage("rock.png");
  PImage img2 = loadImage("rock2.png");
  PImage img3 = loadImage("Basketball.png");
  

  thingsToDisplay = new ArrayList<Displayable>();
  thingsToMove = new ArrayList<Moveable>();
  collideables = new ArrayList<Collideable>();
  
  for (int i=0;i<3;i++){
    int num = (int)random(2); //randomizes which image is chosen for display 
    LivingRock m;
    if (num == 0){
      m = new LivingRock(50+random(width-100), 50+random(height-100), img1);
    }
    else{
      m = new LivingRock(50+random(width-100), 50+random(height-100), img2);
    }
    thingsToDisplay.add(m);
    thingsToMove.add(m);
    collideables.add(m);
  }
  
  for (int i = 0; i < 10; i++) {
    int num = (int)random(2); //randomizes which image is chosen for display 
    Rock r;
    if (num == 0){
      r = new Rock(50+random(width-100), 50+random(height-100), img1);
    }
    else{
      r = new Rock(50+random(width-100), 50+random(height-100), img2);
    }
    thingsToDisplay.add(r);
    collideables.add(r);
    
    Ball b; 
    if (i < 5){
      b = new FootBall(50+random(width-100), 50+random(height-100));
    }
    else{
      b = new Basketball(50+random(width-100), 50+random(height-100), img3);
    }
    thingsToDisplay.add(b);
    thingsToMove.add(b);
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
