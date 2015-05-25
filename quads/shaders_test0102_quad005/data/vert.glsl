#define PROCESSING_TEXTURE_SHADER

uniform mat4 transform;
uniform mat4 texMatrix;

uniform sampler2D texture;

attribute vec4 vertex;
attribute vec4 color;
attribute vec2 texCoord;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main() {

  
  vec4 myVertex = vertex;
  
  vertTexCoord = texMatrix * vec4(texCoord, 1.0, 1.0);
  
  vertColor = texture2D(texture, vertTexCoord.st) * color;
  
  myVertex.z = (vertColor.r+vertColor.g+vertColor.b) * 100 - 150;
  
  //myVertex.z = mod(myVertex.y, 4.0)*10;
  
  if(myVertex.z == 10) vertColor = vec4(0.1, 1.0, 0.1, 1.0);
  
  gl_Position = transform * myVertex;
  
  //if(myVertex.x == 0 || myVertex.x == 480) vertColor.a = 0.0;
  //if( mod(myVertex.y, 4.0) < 0.5 ) vertColor.a = 0.0;
  
}