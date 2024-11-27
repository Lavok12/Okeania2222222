#ifdef GL_ES
precision mediump float;
#endif

uniform float time;          // время для анимации
uniform vec2 resolution;     // разрешение экрана
uniform sampler2D screenTex; // текстура экрана для обработки

// Функция для генерации псевдослучайного значения на основе координат
float random(vec2 uv) {
    return fract(sin(dot(uv.xy ,vec2(12.9898, 78.233))) * 43758.5453);
}

// Функция для генерации плавного шума
float noise(vec2 uv) {
    vec2 i = floor(uv);
    vec2 f = fract(uv);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Функция для создания искажения на основе шума
vec2 chaoticDistortion(vec2 uv) {
    float strength = 0.02; // сила искажения
    float waveX = noise(uv * 4.0 + time) * 2.0 - 1.0;
    float waveY = noise(uv * 4.0 - time) * 2.0 - 1.0;
    
    vec2 offset = vec2(waveX, waveY) * strength/6.0;
    return uv + offset;
}

void main() {
    vec2 uv = gl_FragCoord.xy / resolution.xy;
    
    // Применяем хаотичные искажения к UV-координатам
    vec2 distortedUV = chaoticDistortion(uv);
    
    // Получаем цвет из текстуры экрана с искажёнными координатами
    vec3 color = texture2D(screenTex, distortedUV).rgb;
    
    gl_FragColor = vec4(color, 1.0);
}
