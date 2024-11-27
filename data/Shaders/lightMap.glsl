#ifdef GL_ES
precision highp float;
precision highp int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform sampler2D map;

uniform vec2 dis;

void main(void) {  
  vec2 pixel = gl_FragCoord.xy/dis;
  vec3 clr = vec3(0.,0.,0.);
  clr = texture2D(texture, pixel).xyz;
  clr *= texture2D(map, pixel).xyz;
  
  gl_FragColor.xyz = clr;
  gl_FragColor.w = 1.0;
}