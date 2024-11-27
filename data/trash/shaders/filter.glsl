#ifdef GL_ES
precision highp float;
precision highp int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform vec2 dis;



void main(void) { 
  vec4 clr = vec4(0.,0.,0.,0.);
  vec2 npx = gl_FragCoord.xy/dis.xy;
  vec2 npx2 = gl_FragCoord.xy/dis.x;

  vec4 pclr = texture2D(texture, npx);

  clr = pclr;
  clr.xyz /= 2.0;
  float s = clr.x+clr.y+clr.z;

  clr.xyz += s/2.5;
  clr.xyz -= 0.1;
  clr.xyz /= vec3(1.3,1.2,1.1)/1.1;

  clr.x = pow(clr.x+0.1, 1.3);
  clr.y = pow(clr.y+0.1, 1.3);
  clr.z = pow(clr.z+0.1, 1.3);

  clr.xyz -= 0.1;

  float w = length(vec2(npx-0.5));
  clr.xyz /= (pow(w*2.4,2.0)+1.0);
  

  gl_FragColor = clr;
}
