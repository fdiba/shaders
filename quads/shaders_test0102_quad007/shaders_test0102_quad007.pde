import java.util.Date;
import peasy.*;

PeasyCam cam;

//TODO make it move
//TODO use two different textures to edit the z position and color each quads 

ArrayList<PVector> grid;
PShape shapeGrid;
boolean shapeMode;
PShader pshader;

int detail;
int borderYSize;

PImage[] images;

int KWIDTH = 640;
int KHEIGHT = 480;

boolean lowRes;

void setup() {

  size(640, 480, OPENGL);

  cam = new PeasyCam(this, 500);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(1500);
  
  images = new PImage[2];
  
  images[0] = loadImage("depth.jpg");
  images[1] = loadImage("upAndDown.jpg");

  pshader = loadShader("frag.glsl", "vert.glsl");
  
  pshader.set("tex1", images[1]);

  detail = 10;
  borderYSize = 15;
  //borderYSize = 16;

  shapeGrid = createGrid();
  //shapeGrid.setFill(false);
  //shapeGrid.setStroke(color(255));
  //shapeGrid.setStroke(color(0, 255, 0));
  shapeGrid.setStroke(false);
  //shapeGrid.setStrokeWeight(5);
}

PShape createGrid() {

  PShape sh = createShape();

  sh.beginShape(QUADS);
  sh.textureMode(NORMAL);
  sh.texture(images[0]);

  float ySpace = borderYSize/2;
  int numberOfRows = 0;

  for (int y=0; y<height-detail; y+=detail) {

    for (int x=0; x<width-detail; x+=detail) {

      PVector tl, bl, br, tr;

      if (numberOfRows==0) {

        tl = new PVector(x, y+ySpace);
        bl = new PVector(x, y+detail);
        br = new PVector(x+detail, y+detail);
        tr = new PVector(x+detail, y+ySpace);
      } else {

        tl = new PVector(x, y);
        bl = new PVector(x, y+detail-ySpace);
        br = new PVector(x+detail, y+detail-ySpace);
        tr = new PVector(x+detail, y);
      }



      if (lowRes) { //TODO do it in the shader!

        sh.vertex(tl.x, tl.y, tl.z, tl.x/KWIDTH, tl.y/KHEIGHT);
        sh.vertex(bl.x, bl.y, bl.z, tl.x/KWIDTH, tl.y/KHEIGHT);
        sh.vertex(br.x, br.y, br.z, tl.x/KWIDTH, tl.y/KHEIGHT);
        sh.vertex(tr.x, tr.y, tr.z, tl.x/KWIDTH, tl.y/KHEIGHT);
      } else {

        sh.vertex(tl.x, tl.y, tl.z, tl.x/KWIDTH, tl.y/KHEIGHT);
        sh.vertex(bl.x, bl.y, bl.z, bl.x/KWIDTH, bl.y/KHEIGHT);
        sh.vertex(br.x, br.y, br.z, br.x/KWIDTH, br.y/KHEIGHT);
        sh.vertex(tr.x, tr.y, tr.z, tr.x/KWIDTH, tr.y/KHEIGHT);
      }
    }

    numberOfRows++;
    if (numberOfRows==2)numberOfRows=0;
  }

  sh.endShape(CLOSE);

  return sh;
}
void mousePressed() {
}
void keyPressed() {

  if (key=='0') {

    Date date = new Date();
    //String name = "data/images/shapes-"+date.getTime()+".png";
    String name = "data/images/shapes-"+date.getTime()+".jpg";
    save(name);
  } else if (key=='r') {

    lowRes = !lowRes;
    shapeGrid = createGrid();
    shapeGrid.setStroke(false);
  }
}
void draw() {

  background(127);
  //background(255);
  
  shapeMode(CENTER);

  shader(pshader);

  shape(shapeGrid);
}

