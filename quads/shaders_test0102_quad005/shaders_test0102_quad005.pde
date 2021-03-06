import java.util.Date;
import peasy.*;

PeasyCam cam;

ArrayList<PVector> grid;
PShape shapeGrid;
boolean shapeMode;
PShader pshader;

int detail;
int borderYSize;

PImage image;

int KWIDTH = 640;
int KHEIGHT = 480;

boolean lowRes;

void setup() {

  size(640, 480, OPENGL);

  cam = new PeasyCam(this, 500);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(1500);

  image = loadImage("color.jpg");

  pshader = loadShader("frag.glsl", "vert.glsl");

  detail = 30;
  borderYSize = 6;

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
  sh.texture(image);

  float ySpace = borderYSize/2;

  for (int y=0; y<height-detail; y+=detail) {

    for (int x=0; x<width-detail; x+=detail) {

      PVector tl, bl, br, tr;

      tl = new PVector(x, y+ySpace);
      bl = new PVector(x, y+detail-ySpace);
      br = new PVector(x+detail, y+detail-ySpace);
      tr = new PVector(x+detail, y+ySpace);

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
  } else if(key=='r'){
    
      lowRes = !lowRes;
  shapeGrid = createGrid();
  
  }
}
void draw() {

  background(255);

  shapeMode(CENTER);

  shader(pshader);

  shape(shapeGrid);
}

