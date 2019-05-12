interface Displayable {
  void display();
}
interface Moveable {
  void move();
}
interface Collideable {
  boolean isTouching(Thing other);
}
class Thing implements Collideable{
  float x, y;

  Thing(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  boolean isTouching(Thing other){
    return dist(x, y, other.x, other.y) <= 30;
  }
  
}

class Rock extends Thing implements Displayable {
  PImage img;
  Rock(float x, float y, PImage img) {
    super(x, y);
    this.img = img;
  }

  void display() {
    noTint();
    image(img, x, y, 40, 40);
  }
}

public class LivingRock extends Rock implements Moveable {
  LivingRock(float x, float y, PImage img) {
    super(x, y, img);
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
      xspeed += random(-1,1);
    }
    if (y >= 775 || y <= 25){
      yspeed *= -1;
      yspeed += random(-1,1);
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
    for (Collideable c: collideables){
      if (c.isTouching(this)){
        fill(255,0,0);
      }
    }
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
      xspeed *= -1;
      xspeed += random(-0.5,0.5); //changes the angle slightly 
      yspeed += random(-0.5,0.5);
    }
    if (y >= 780 || y <= 8){
      yspeed *= -1;
      xspeed += random(-0.5,0.5);
      yspeed += random(-0.5,0.5); 
    }
    
    int passedTime = millis() - savedTime; //keeps track of elapsed time 
    if (passedTime > totalTime){ 
      if (vert){ //vertical zigzag 
        xspeed += random(-0.2,0.2); //randomizes zigzag a little 
        xspeed *= -1;
      }
      else{ //horizontal zigzag 
        yspeed += random(-0.2,0.2);
        yspeed *= -1;
      }
      savedTime = millis(); //resets timer
    }
  }
  
}

class Basketball extends Ball {
  float xVel;
  float yVel;
  float xAcc;
  float yAcc;
  float originalX;
  float originalY;
  PImage img; 
  Basketball (float x, float y, PImage img) {
    super(x, y);
    this.img = img;
    xVel = 0;
    yVel = 1;
    xAcc = 0;
    yAcc = .05;
  }
  
  void display() {
    noTint();
    for (Collideable c: collideables){
      if (c.isTouching(this)){
        tint(255, 0, 0);
      }
    }
    image(img, x, y, 30, 30);
  }
  
  void move() {
    x += xVel;
    y += yVel;
    yVel += yAcc;
    if (y >= 775) {
      yVel *= -1;
    }
  }
}

ArrayList<Displayable> thingsToDisplay;
ArrayList<Moveable> thingsToMove;
ArrayList<Collideable> collideables;

void setup() {
  size(1000, 800);
  PImage img1 = loadImage("rock.png");
  PImage img2 = loadImage("rock2.png");
  PImage img3 = loadImage("Basketball.png");
  

  thingsToDisplay = new ArrayList<Displayable>();
  thingsToMove = new ArrayList<Moveable>();
  collideables = new ArrayList<Collideable>();
  
  for (int i=0;i<3;i++){
    int num = (int)random(2);
    LivingRock m;
    if (num == 0){
      m = new LivingRock(50+random(width-100), 50+random(height)-100, img1);
    }
    else{
      m = new LivingRock(50+random(width-100), 50+random(height)-100, img2);
    }
    thingsToDisplay.add(m);
    thingsToMove.add(m);
    collideables.add(m);
  }
  
  for (int i = 0; i < 10; i++) {
    int num = (int)random(2);
    Rock r;
    if (num == 0){
      r = new Rock(50+random(width-100), 50+random(height)-100, img1);
    }
    else{
      r = new Rock(50+random(width-100), 50+random(height)-100, img2);
    }
    thingsToDisplay.add(r);
    collideables.add(r);
    
    Ball b; 
    if (i < 5){
      b = new FootBall(50+random(width-100), 50+random(height)-100);
    }
    else{
      b = new Basketball(50+random(width-100), 50+random(height)-100, img3);
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
