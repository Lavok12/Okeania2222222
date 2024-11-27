#ifdef GL_ES
precision highp float;
precision highp int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform vec2 dis;
uniform float power;

void main(void) {  
  vec2 pixel = gl_FragCoord.xy/dis;
  vec3 clr = vec3(0.,0.,0.);
  clr = texture2D(texture, pixel).xyz;
  clr = clr*power+(clr.x*0.3+clr.y*0.5+clr.z*0.2)*(1.0-power);
  
  gl_FragColor.xyz = clr;
  gl_FragColor.w = 1.0;
}