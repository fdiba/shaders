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
  
  myVertex.z = vertColor.r * 100 - 50;
  
  gl_Position = transform * myVertex;
   
  if( mod(myVertex.y, 4.0) < 0.5 ) vertColor.a = 0.0;
  
}