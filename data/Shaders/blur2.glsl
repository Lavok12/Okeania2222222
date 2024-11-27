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
  vec2 pixel = gl_FragCoord.xy / dis;

  // Вычисляем расстояние от текущего пикселя до центра экрана
  vec2 center = vec2(0.5, 0.5);
  float distToCenter = distance(pixel, center)-0.2;
  distToCenter = max(0.0, distToCenter);
  // Определяем силу размытия в зависимости от расстояния до центра
  float blurFactor = mix(0.0, power, distToCenter);

  // Начинаем собирать цвет с разных точек, увеличивая размытие по мере удаления от центра
  vec4 clr = vec4(0., 0., 0., 0.);
  clr += texture2D(texture, pixel) * del;
  clr += texture2D(texture, pixel + vec2(-blurFactor, 0.) / dis);
  clr += texture2D(texture, pixel + vec2(0., -blurFactor) / dis);
  clr += texture2D(texture, pixel + vec2(blurFactor, 0.) / dis);
  clr += texture2D(texture, pixel + vec2(0., blurFactor) / dis);
  clr += texture2D(texture, pixel + vec2(blurFactor, -blurFactor) / 1.41 / dis);
  clr += texture2D(texture, pixel + vec2(-blurFactor, blurFactor) / 1.41 / dis);
  clr += texture2D(texture, pixel + vec2(-blurFactor, -blurFactor) / 1.41 / dis);
  clr += texture2D(texture, pixel + vec2(blurFactor, blurFactor) / 1.41 / dis);

  // Усредняем результат
  clr /= del + 8.0;
  
  gl_FragColor = clr;
}
