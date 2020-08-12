// 12 August 2020
// Circle-Tree-015
// Fork by Rupert Russell of Circle Tree by Agoston Nagy
// https://www.openprocessing.org/sketch/138954
// Code on Github at: https://github.com/rupertrussell/Circle-Tree-009
// Artwork on redbubble at: https://www.redbubble.com/shop/ap/54746647

String filename = "tree_9411_42200_01_";  
int maxCells = 42200; 
float startradius = 500; //
float rand = 0;
float minRadius = 2; 
int count = 0;
float speed = 1;  
int startTime = 0;
int maxTime = 0;
int cellCount, oldCellCount;
ArrayList Cells = new ArrayList(); 
float shrink = 0.789  ; // smaller number faster shrinking
boolean savedFinalCopy = false;

void setup()
{
  size(9411, 9411);
  background(0);
  noStroke();

  Cell C = new Cell(new PVector(width/2, height/2), null, startradius);
}

void metro(int maxTime) {

  if (Cells.size() >= maxCells) {
    updatePixels();
    save("finished_" + filename + ".png");

    // exit();
  }

  int elapsed = millis() - startTime; // first call elapsed = millis();
  if (elapsed > maxTime) { // first call will be true
    int over = elapsed - maxTime; // first call over 
    startTime = millis() - over; 

    for (int c=0; c<Cells.size(); c++)
    {
      Cell C = (Cell) Cells.get(c); 
      if (Cells.size() < maxCells && C.radius > minRadius)
      {
        C.grow();
      }
    }
  }
}

void draw() {
  loadPixels();  //   Loads pixels into the pixels[] array.
  background(178, 228, 15); 
  oldCellCount = Cells.size();

  metro(int(speed));
  if (Cells.size() > oldCellCount) {
    updatePixels();
    println("Cells.size() = " + Cells.size());
    oldCellCount = Cells.size();
    updatePixels(); // Updates the display window with the data in the pixels[] array. Otherwise the screen is blank when we save it
    save(filename + Cells.size() + ".png");
    println("*** saved " + filename + Cells.size());
  }

  for (int c=0; c<Cells.size(); c++)
  {
    Cell C = (Cell) Cells.get(c); 
    C.render();
  }
}

class Cell {
  PVector pos; 
  float radius; 

  int child; 
  int age; 
  int maxAge = 20; 
  Cell parent; 

  float alpha = 0;

  Cell(PVector _pos, Cell _parent, float _radius)
  { 
    pos = _pos;
    parent = _parent;
    radius = _radius;
    age = 0; 
    child = 0;    
    Cells.add(this);
  }

  void render() {
    noStroke();
    fill(50, 205-child*35, 255); 
    ellipse(pos.x, pos.y, radius*2, radius*2); 

    if (parent == null) //  start cell (no parent)
    { 
      fill(255);
      ellipse(pos.x, pos.y, 15, 15);
    }

    strokeWeight(2); // was 1;
    stroke(255);

    if (parent != null) { 
      line(pos.x, pos.y, parent.pos.x, parent.pos.y);
    }

    for  (int c=0; c<Cells.size(); c++) {
      Cell C = (Cell) Cells.get(c);
      if (child < 1) {  //  last cell (no children)
        noStroke();
        fill(255, 0, 0);
        ellipse(pos.x, pos.y, 5, 5); // red dot at center
      }
    }
  }

  void grow() {
    float nextradius = radius * shrink; // make the size of the next cell smaller by shrink
    float growAngle = 0;
    for (int i=0; i < 2; i++) { // was i<3
      boolean collide = false; // boolean switch for collisions
      rand = int(random(9));
      if (rand == 0.0) {
        growAngle = 0;
      }
      if (rand == 2.0) {
        growAngle = 45;
      }
      if (rand == 3.0) {
        growAngle = 90;
      }
      if (rand == 4.0) {
        growAngle = 135;
      }
      if (rand == 5.0) {
        growAngle = 180;
      }
      if (rand == 6.0) {
        growAngle = 225;
      }
      if (rand == 7.0) {
        growAngle = 270;
      }
      if (rand == 8.0) {
        growAngle = 315;
      }

      PVector growPos = new PVector(pos.x +  cos(growAngle)*(radius+nextradius), pos.y + sin(growAngle)*(radius+nextradius)); 

      //  check collisions
      for (int c=0; c<Cells.size(); c++) { // check every cell
        Cell C = (Cell)  Cells.get(c);
        if (C != this  && growPos.dist(C.pos) < radius + C.radius) { 
          collide = true; 
          // nextradius *= shrink;
        }
      }
      if (! collide) { 
        Cell newCell = new Cell(growPos, this, nextradius); 
        child++; 
        return;
      }
    }
  }
}
