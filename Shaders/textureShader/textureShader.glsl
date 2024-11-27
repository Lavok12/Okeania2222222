#ifdef GL_ES
precision highp float;
precision highp int;
#endif

#define PROCESSING_COLOR_SHADER

uniform sampler2D texture1;
uniform vec2 dis;
uniform float fix;
uniform vec2 cam;
uniform float zoom;

void main(void) {  
  vec2 pixel = (gl_FragCoord.xy-dis/2.0)/fix/zoom+cam;
  vec4 color = texture2D(texture1, vec2(mod(pixel.x/10.0,1.0), 1.0-mod(pixel.y/10.0,1.0)))*0.48;
  color += texture2D(texture1, vec2(mod(pixel.x/73.0,1.0), 1.0-mod(pixel.y/73.0,1.0)))*0.52;

  color.w = 1.0;

  gl_FragColor = color;
}