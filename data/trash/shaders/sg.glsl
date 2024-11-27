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
  vec4 clr = vec4(0.,0.,0.,0.);
  
  if (texture2D(texture, pixel).w < 0.95) {
    clr += texture2D(texture, pixel + vec2(-power, 0.)/dis);
    clr += texture2D(texture, pixel + vec2(0., -power)/dis);
    clr += texture2D(texture, pixel + vec2(power, 0.)/dis);
    clr += texture2D(texture, pixel + vec2(0., power)/dis);
    clr += texture2D(texture, pixel + vec2(power, -power)/dis)/2.;
    clr += texture2D(texture, pixel + vec2(-power, power)/dis)/2.;
    clr += texture2D(texture, pixel + vec2(-power, -power)/dis)/2.;
    clr += texture2D(texture, pixel + vec2(power, power)/dis)/2.;
    if (clr.w > 3.5) {
      clr /= clr.w;
      gl_FragColor = clr;
    } else if (clr.w > 2.5) {
      clr /= clr.w*2.0;
      gl_FragColor = clr;
    }
  } else {
    gl_FragColor = texture2D(texture, pixel);
  }
}