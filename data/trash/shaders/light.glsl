#ifdef GL_ES
precision highp float;
precision highp int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform sampler2D light;
uniform vec2 dis;

void main(void) {
  vec4 clr = vec4(0.,0.,0.,1.);
  clr.xyz = texture2D(texture, gl_FragCoord.xy/dis).xyz*texture2D(light, gl_FragCoord.xy/dis).xyz;
  gl_FragColor = clr;
}
