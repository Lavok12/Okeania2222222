#ifdef GL_ES
precision highp float;
precision highp int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform vec2 dis;
uniform float frame;
uniform sampler2D wt;
uniform sampler2D st;
uniform sampler2D ni;
uniform sampler2D noise;

float random(vec2 co)
{
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.545);
}

float p = 0.5;

void main(void) { 
  vec4 clr = vec4(0.,0.,0.,0.);
  vec2 npx = gl_FragCoord.xy/dis.xy;
  vec2 npx2 = gl_FragCoord.xy/dis.x;

  vec4 pclr = texture2D(texture, npx);

  if (pclr.xyz == vec3(155./255., 218./255., 1.0)) {
    
    clr = vec4(0., 0., 0., 0.);
    float f = frame;
    for (float i = 0.; i < 8.; i++) {
      clr += texture2D(wt, 
      vec2(
        mod(
        npx2.x*3.0/i+f/i/3000.0*(mod(i,2.0)*2.0-1.0)
          ,1.)
        ,
        mod(
          npx2.y*3.0/i+f/i/3000.0*(mod(i/2.0,2.0)*2.0-1.0)
          ,1.)
      )
      )/8.0;
    }
    clr.xyz = clr.xyz*4.0-vec3(1.1,1.9,3.0)/1.5;
    clr.xyz = clr.xyz/2.0+vec3(0.35,0.4,0.45);

    clr.xyz/=1.5;
    clr += texture2D(st, vec2(
      mod((npx.x+sin((clr.x+clr.y)*12.0)*0.02+f/4300.0),1.0)
      ,
      (npx.y+sin((clr.y+clr.z)*12.0)*0.02)
      ))/3.0;

    vec4 clr2 = texture2D(texture, vec2(
      mod((npx.x+sin((clr.x+clr.y)*12.0)*0.005),1.0)
      ,
      (npx.y+sin((clr.y+clr.z)*12.0)*0.005)
      ));
      if (clr2.xyz != vec3(155./255., 218./255., 1.0)) {
        clr -= 0.21;
      }
  } else {
    clr = pclr.rgba;
    if (pclr.xyz != vec3(0.,0.,0.)) {
      normalize(clr.xyz);
      clr.xyz/=2.0;
      clr.rgb += vec3(5.0,3.0,1.5)*texture2D(ni, npx).x/3.0;
    }
  }
  vec4 clro = vec4(0.,0.,0.,0.);
  float f = frame;
  for (float i = 10.; i < 14.; i++) {
      clro += texture2D(noise, 
      vec2(
        mod(
        npx2.x/38.0*i-f*1.5/i/3000.0*(mod(i,2.0)*2.0-1.0)+1.0
          ,1.)
        ,
        mod(
          npx2.y/9.0*i-f/20.5/i/3000.0*(mod(i/2.0,2.0)*2.0-1.0)+1.0
          ,1.)
      )
      )/4.0;
    }
    clro.b = pow(clro.b+0.30,8.0);
    clr.xyz = clr.xyz * (1.0-clro.b) + clro.b;
  gl_FragColor = clr;
}
