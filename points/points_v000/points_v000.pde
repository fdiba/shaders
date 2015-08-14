import java.util.Date;
import peasy.*;

//to use shader set to true
public static final boolean USESHADER = false;

PeasyCam cam;
ArrayList<PVector> positions;

PVector avg, cameraCenter;
PVector psCenter, cameraPosition;
float cameraRate;
float[] camPos;

float dofRatio = 50f;

PShader pointShader;

void setup() {

  size(640, 480, OPENGL);

  cam = new PeasyCam(this, 1600);

  positions = new ArrayList<PVector>();
  avg = new PVector();
  cameraCenter = new PVector();

  pointShader = loadShader("pointFrag.glsl", "pointVert.glsl");

  createPS();
}
void createPS() {

  int xSpace = 10;
  int ySpace = 10;

  for (int y=0; y<height-ySpace; y+=ySpace) {
    for (int x=0; x<width-xSpace; x+=xSpace) {

      positions.add(new PVector(x-width/2, y-height/2));
    }
  }
}
float getDistToPoint(PVector psCenter, PVector cameraPos, PVector pos) {

  PVector camPos = cameraPos.get();    
  PVector v  = PVector.sub(pos, psCenter);

  float sn = -camPos.dot(v);

  float sd = camPos.mag();

  sd *= sd;

  camPos.mult(sn / sd);

  PVector isec = PVector.add(pos, camPos);

  float dist = isec.dist(pos);

  return dist;
}
void draw() {

  avg.mult(0);
  for (int i=0; i<positions.size (); i++) {   
    avg.add(positions.get(i));
  }
  avg.div(positions.size());

  cameraCenter.mult(1f-cameraRate);
  cameraCenter.add(PVector.mult(avg, cameraRate));

  translate(-cameraCenter.x, -cameraCenter.y, -cameraCenter.z);

  psCenter = avg.get();

  camPos = cam.getPosition();
  cameraPosition = new PVector(camPos[0], camPos[1], camPos[2]);
  cameraPosition.normalize();

  background(0);

  if (USESHADER) {
    pointShader.set("psCenter", psCenter);
    pointShader.set("cameraPosition", cameraPosition);
    pointShader.set("dofRatio", dofRatio);
    shader(pointShader);
  }

  for (int i=0; i<positions.size (); i++) {

    PVector pos = positions.get(i);

    if (!USESHADER) {
      float distanceToFocalPlane = getDistToPoint(psCenter, cameraPosition, pos);
      distanceToFocalPlane /= dofRatio;
      distanceToFocalPlane = constrain(distanceToFocalPlane, 1, 15);
      strokeWeight(distanceToFocalPlane);
      //stroke(255,0,0);
      stroke(255, constrain(255 / (distanceToFocalPlane * distanceToFocalPlane), 1, 255));
    }

    beginShape(PConstants.POINTS);
    vertex(pos.x, pos.y, pos.z);
    endShape();
  }
}
void keyPressed() {
  if (key == 's') savePicture();
}
void savePicture() {
  Date date = new Date();
  String name = "data/images/blurEffect-"+date.getTime()+".jpg";
  save(name);
}

