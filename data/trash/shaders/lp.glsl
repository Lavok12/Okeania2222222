#ifdef GL_ES
precision highp float;
precision highp int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform sampler2D lp2;
uniform vec2 dis;

void main(void) {

  vec4 clr, clr2;
  vec2 pixel = gl_FragCoord.xy/dis;
  clr = texture2D(texture, pixel);
  clr2 = texture2D(lp2, vec2(pixel.x, 1.0-pixel.y));
 
  clr *= clr2;
  
  gl_FragColor = clr;
}