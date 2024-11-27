#ifdef GL_ES
precision highp float;
precision highp int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform vec2 dis;
uniform float power;
uniform float del;

void main(void) {  
  vec2 pixel = gl_FragCoord.xy/dis;
  vec4 clr = vec4(0.,0.,0.,0.);
  clr += texture2D(texture, pixel)*del;
  clr += texture2D(texture, pixel + vec2(-power, 0.)/dis);
  clr += texture2D(texture, pixel + vec2(0., -power)/dis);
  clr += texture2D(texture, pixel + vec2(power, 0.)/dis);
  clr += texture2D(texture, pixel + vec2(0., power)/dis);
  clr += texture2D(texture, pixel + vec2(power, -power)/dis);
  clr += texture2D(texture, pixel + vec2(-power, power)/dis);
  clr += texture2D(texture, pixel + vec2(-power, -power)/dis);
  clr += texture2D(texture, pixel + vec2(power, power)/dis);
  clr /= del+8.0;
  
  gl_FragColor = clr;
}