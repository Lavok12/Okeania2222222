#ifdef GL_ES
precision highp float;
precision highp int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform vec2 resolution;
uniform sampler2D texture;
uniform int l;

void main() {
  vec2 pix = gl_FragCoord.xy;
  vec4 c[5];
  vec2 offsets[5];
  
  offsets[0] = vec2(0.,0.);
  offsets[1] = vec2(1.,0.);
  offsets[2] = vec2(-1.,0.);
  offsets[3] = vec2(0.,1.);
  offsets[4] = vec2(0.,-1.);

  for(int i = 0; i < 5; i++) {
    c[i].xyz = texture2D(texture, (pix+offsets[i])/resolution).xyz;
  }

  // Сортировка массива по каждому из RGB
  for(int k = 0; k < 3; k++) {
    for(int i = 0; i < 5; i++) {
      for(int j = i+1; j < 5; j++) {
        if(c[j][k] < c[i][k]) {
          float temp = c[i][k];
          c[i][k] = c[j][k];
          c[j][k] = temp;
        }
      }
    }
  }

  // Сохранение медианного цвета в переменную color
  vec3 color = c[l].xyz;
  gl_FragColor = vec4(color, 1.0);

  /*
  if (pix.x/resolution.x > 0.5) {
    gl_FragColor = vec4(texture2D(texture, pix/resolution.xy).xyz, 1.0);
    if (pix.x/resolution.x < 0.501) {
      gl_FragColor = vec4(1.0,1.0,1.0,1.0);
    }
  }*/
}