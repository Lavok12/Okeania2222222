#ifdef GL_ES
precision highp float;
precision highp int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform vec2 dis;
uniform float waterLine;
uniform float camera;
uniform float power;
uniform float fix;
uniform float zoom;
uniform float s;

uniform sampler2D dark;

void main(void) {

  vec2 pixel = gl_FragCoord.xy/dis;
  
  vec2 npx = vec2(gl_FragCoord.x + -dis.x/2.0, dis.y/2.0 - gl_FragCoord.y)/fix*zoom;
  
  float realWater = waterLine;
  
  if (npx.y+40.0 > waterLine) {
    float wpx = (npx.x + camera) / 40.0 + power / 30.0;
    realWater += sin(wpx)*3.0*s;
    wpx = (npx.x + camera) / 32.6 - power / 60.0;
    realWater += abs(sin(wpx)*6.0*s);
    wpx = (npx.x + camera) / 120.0 + power / 50.5;
    realWater += sin(wpx)*4.0*s;
    wpx = (npx.x + camera) / 190.5 - power / 61.6;
    realWater += sin(wpx)*8.0*s;
    wpx = (npx.x + camera) / 206.6 + power / 115.9;
    realWater += abs(sin(wpx)*6.0)*s;
    wpx = (npx.x + camera) / 800.5 + power / 56.6;
    realWater += sin(wpx)*5.0*s;
    wpx = (npx.x + camera) / 12.6 - power / 95.9;
    realWater += abs(sin(wpx)*2.)*s;
  }
  vec4 clr = vec4(0.,0.,0.,0.);
  
  if (npx.y > realWater) {
    vec2 pixel2 = pixel;
    if ((npx.y - realWater) <= (realWater-waterLine)/2.0) {
      clr = vec4(0.2,0.2,0.7,100.0)/2.; 
      pixel2.x += ((sin(power/zoom/23.0+(realWater-waterLine)/20.0+(npx.y-waterLine)/8.0)/zoom/280.0)/min(5.0, abs(1.0+(npx.y-waterLine)/150.0)))*2.0;
      pixel2.y += ((sin(power/zoom/35.4+(realWater-waterLine)/24.22+(npx.y-waterLine)/11.72)/zoom/190.0)/min(5.0, abs(1.0+(npx.y-waterLine)/150.0)))*2.0;
    
    } else {
      clr = vec4(0.2,0.2,0.7,100.0)/3.5; 
      pixel2.x += (sin(power/zoom/23.0+(realWater-waterLine)/20.0+(npx.y-waterLine)/8.0)/zoom/280.0)/min(5.0, abs(1.0+(npx.y-waterLine)/150.0))/2.0;
      pixel2.y += (sin(power/zoom/35.4+(realWater-waterLine)/24.22+(npx.y-waterLine)/11.72)/zoom/190.0)/min(5.0, abs(1.0+(npx.y-waterLine)/150.0))/2.0;
    }
    clr = clr + ((texture2D(texture, pixel2)/2.0));
    vec2 pixel3 = pixel;
    pixel3.y = (-(realWater*1.9/dis.y*fix/zoom)+1)-pixel3.y;
    pixel3.x += sin(pixel.y*zoom*5.0+pixel3.x*zoom*35.2+realWater*zoom/25.0)/200.0/zoom;
    //if (abs((npx.y-realWater)/10.0+1.0) < 50.0) {
      clr = clr + ((texture2D(texture, pixel3)/3.0/pow(abs((npx.y-realWater)/100.0+1.0),1.4)));
    //}
  } else {
    clr = texture2D(texture, pixel);
  }
  clr.w = 1.0;
  gl_FragColor = clr;
}