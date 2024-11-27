#ifdef GL_ES
precision highp float;
precision highp int;
#endif

#define PROCESSING_COLOR_SHADER

uniform vec2 dis;
uniform sampler2D tex1;
uniform vec2 cam;
uniform float fix;
uniform float zoom;
uniform float l;

void main(void) {
  
  vec4 clr = vec4(0.0,0.0,0.0,0.0);
  vec2 npx = (vec2(gl_FragCoord.x + -dis.x/2.0, dis.y/2.0 - gl_FragCoord.y))/fix*zoom+cam;
  
/* float k = texture2D(tex1, mod(npx/300.0,1.0)).r;
  float f = 1.0;
  
  for (float i = 0.0; i < 10.0; i++) {
    npx = (vec2(gl_FragCoord.x + -dis.x/2.0+sin(l)*i*3.0, dis.y/2.0 - gl_FragCoord.y+cos(l)*i*3.0))/fix*zoom+cam;
    if (texture2D(tex1, mod(npx/300.0,1.0)).r>k) {
      f = (3.0/(i/6.0+1.0))/8.0+1.0;
      break;
    }
  }
  
  npx = (vec2(gl_FragCoord.x + -dis.x/2.0, dis.y/2.0 - gl_FragCoord.y))/fix*zoom+cam;*/

  float k =  sin(npx.x/100.0+npx.y/100.0)+sin(npx.x/77.0)-sin(npx.y/60.0)+sin(-npx.x/150.0+npx.y/85.0);
  clr = texture2D(tex1, mod(npx/300.0,1.0))/(k/20.0+1.0);
  clr.w=1.0;
  
  gl_FragColor = clr; 
}