#ifdef GL_ES
precision highp float;
precision highp int;
#endif

#define PROCESSING_COLOR_SHADER

uniform sampler2D texture1;
uniform sampler2D texture2;
uniform sampler2D texture3;

uniform vec2 dis;
uniform float fix;
uniform vec2 cam;
uniform float zoom;

void main(void) {  
  vec2 pixel = (gl_FragCoord.xy - dis / 2.0) / fix / zoom + cam;
  vec4 color1, color2, color3;
  float blendFactor1, blendFactor2;

  // Обработка первой текстуры (texture1) для верхней части
  color1 = texture2D(texture1, vec2(mod(pixel.x / 10.0, 1.0), 1.0 - mod(pixel.y / 10.0, 1.0))) * 0.48;
  color1 += texture2D(texture1, vec2(mod(pixel.x / 73.0, 1.0), 1.0 - mod(pixel.y / 73.0, 1.0))) * 0.52;

  // Обработка второй текстуры (texture2) для средней части
  color2 = texture2D(texture2, vec2(mod(pixel.x / 10.0, 1.0), 1.0 - mod(pixel.y / 10.0, 1.0))) * 0.48;
  color2 += texture2D(texture2, vec2(mod(pixel.x / 73.0, 1.0), 1.0 - mod(pixel.y / 73.0, 1.0))) * 0.52;

  // Обработка третьей текстуры (texture3) для нижней части
  color3 = texture2D(texture3, vec2(mod(pixel.x / 10.0, 1.0), 1.0 - mod(pixel.y / 10.0, 1.0))) * 0.48;
  color3 += texture2D(texture3, vec2(mod(pixel.x / 73.0, 1.0), 1.0 - mod(pixel.y / 73.0, 1.0))) * 0.52;
  color3.y = color3.x;
  color3.z = color3.x;
  color3.xyz /= 2.0;

  // Определяем факторы смешивания на основе координаты Y
  if (pixel.y > -330.0) {
    // Верхняя часть, только texture1
    gl_FragColor = color1;
  } else if (pixel.y > -1760.0) {
    // Плавный переход между texture1 и texture2
    blendFactor1 = smoothstep(-330.0, -400.0, pixel.y); // Переход между -340 и -600 по Y
    gl_FragColor = mix(color1, color2, blendFactor1);
  } else {
    // Плавный переход между texture2 и texture3
    blendFactor2 = smoothstep(-1760.0, -1900.0, pixel.y); // Переход между -1800 и -2100 по Y
    gl_FragColor = mix(color2, color3, blendFactor2);
  }

  // Устанавливаем альфа-канал в 1.0
  gl_FragColor.w = 1.0;
}
