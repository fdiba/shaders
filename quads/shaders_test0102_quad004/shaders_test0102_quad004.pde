import java.util.Date;
import peasy.*;

PeasyCam cam;

ArrayList<PVector> grid;
PShape shapeGrid;
boolean shapeMode;
PShader pshader;

PImage image;

int KWIDTH = 640;
int KHEIGHT = 480;

void setup() {

  size(640, 480, OPENGL);

  cam = new PeasyCam(this, 500);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(1500);

  image = loadImage("depth.jpg");

  pshader = loadShader("frag.glsl", "vert.glsl");

  shapeGrid = createGrid(10);
  //shapeGrid.setFill(false);
  //shapeGrid.setStroke(color(255));
  //shapeGrid.setStroke(color(0, 255, 0));
  shapeGrid.setStroke(false);
  //shapeGrid.setStrokeWeight(5);
}

PShape createGrid(int detail) {

  PShape sh = createShape();

  sh.beginShape(QUADS);
  sh.textureMode(NORMAL);
  sh.texture(image);

  for (int y=0; y<height-detail; y+=detail) {

    for (int x=0; x<width-detail; x+=detail) {

      PVector tl, bl, br, tr;

      tl = new PVector(x, y);
      bl = new PVector(x, y+detail);
      br = new PVector(x+detail, y+detail);
      tr = new PVector(x+detail, y);

      sh.vertex(tl.x, tl.y, tl.z, tl.x/KWIDTH, tl.y/KHEIGHT);
      sh.vertex(bl.x, bl.y, bl.z, bl.x/KWIDTH, bl.y/KHEIGHT);
      sh.vertex(br.x, br.y, br.z, br.x/KWIDTH, br.y/KHEIGHT);
      sh.vertex(tr.x, tr.y, tr.z, tr.x/KWIDTH, tr.y/KHEIGHT);
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

  background(0);

  //pushMatrix();
  shapeMode(CENTER);
  //translate(width/2, height/2);

  shader(pshader);

  shape(shapeGrid); 

  //sphere(120);

  //popMatrix();
}

