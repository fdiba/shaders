#define PROCESSING_POINT_SHADER

uniform mat4 projection;
uniform mat4 modelview;
uniform mat4 transform;

uniform float dofRatio; 
uniform vec3 psCenter;
uniform vec3 cameraPosition;

attribute vec4 vertex;
attribute vec4 color;
attribute vec2 offset;

varying vec4 vertColor;
varying vec2 center;
varying vec2 texCoord;
varying vec2 pos;

void main() {

  vec4 col;
  vec2 m0ffset = vec2(offset);

  //---------- get distance to focalPlane ----------//

  vec3 camPos = cameraPosition;

  vec3 v =  psCenter - vertex.xyz;

  //dot returns the dot product of two vectors

  float sn = dot(-camPos, v);

  float sd = length(camPos);
  sd = pow(sd, 2);

  camPos *= (sn/sd);

  vec3 isec = vertex.xyz + camPos;

  float dist = distance(isec, vertex.xyz);

  float distToFocalPlane = dist;


  //---------- end get distance to focalPlane ----------//
  
  distToFocalPlane /= dofRatio;

  distToFocalPlane = clamp(distToFocalPlane, 1., 15.);

  float alpha = (255./(distToFocalPlane*distToFocalPlane))/255.;

  alpha = clamp(alpha, .1, 1.);

  col.a = alpha;

  //to debug
  //col = vec4(1.,1.,1.,1.);

  if(m0ffset[0] > 0)m0ffset[0]+=distToFocalPlane;
  if(m0ffset[0] < 0)m0ffset[0]+=-distToFocalPlane;
  if(m0ffset[1] > 0)m0ffset[1]+=distToFocalPlane;
  if(m0ffset[1] < 0)m0ffset[1]+=-distToFocalPlane;


  vec4 clip = transform * vertex;
  gl_Position = clip + projection * vec4(m0ffset, 0, 0);

  vertColor = col;   

  center = clip.xy;
  pos = m0ffset;

}
