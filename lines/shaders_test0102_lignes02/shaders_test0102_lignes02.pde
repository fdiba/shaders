import java.util.Date;
import peasy.*;

PeasyCam cam;

ArrayList<PVector> grid;
PShape shapeGrid;
boolean shapeMode;
PShader pshader;

PImage image;

int TWIDTH = 640;
int THEIGHT = 480;

void setup() {

  size(640, 480, OPENGL);

  cam = new PeasyCam(this, 1000);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(500);

  image = loadImage("depth.jpg");

  pshader = loadShader("frag.glsl", "vert.glsl");
  
  pshader.set("tex1", image);
  pshader.set("gWidth", 640f);
  pshader.set("gHeight", 480f);

  shapeGrid = createGrid(10);
  shapeGrid.setStrokeWeight(1);
  shapeGrid.setStroke(color(255, 255, 0));

}

PShape createGrid(int detail) {

  PShape sh = createShape();

  sh.beginShape(LINES);
  sh.textureMode(NORMAL);
  sh.texture(image);

  PVector lv = new PVector();
  boolean start = true;

  for (int y=0; y<height-detail; y+=detail) {

    lv.x = 0;
    lv.y = y;

    for (int x=0; x<width-detail; x+=detail) {

      PVector tl, tr;

      if (start) {

        tl = new PVector(x, y);
        tl.z = random(-10, 10);

        start = false;
        
      } else {
        tl = lv.get();
      }

      tr = new PVector(x+detail, y);
      tr.z = random(-10, 10);

      lv = tr.get();


      sh.vertex(tl.x, tl.y, tl.z, tl.x/TWIDTH, tl.y/THEIGHT);
      sh.vertex(tr.x, tr.y, tr.z, tr.x/TWIDTH, tr.y/THEIGHT);
    }
  }

  sh.endShape(CLOSE);
  return sh;
}
void keyPressed() {

  if (key=='0') {

    Date date = new Date();
    String name = "data/images/shapes-"+date.getTime()+".png";
    save(name);
  }
}
void draw() {

  background(127);

  shapeMode(CENTER);
  shader(pshader, LINES);
  shape(shapeGrid); 

}

