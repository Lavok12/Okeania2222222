#ifdef GL_ES
precision mediump float;
#endif

uniform float time;          // время для анимации
uniform vec2 resolution;     // разрешение экрана
uniform sampler2D screenTex; // текстура экрана для обработки

// Функция для генерации случайного значения на основе координат
float random(vec2 uv) {
    return fract(sin(dot(uv.xy ,vec2(12.9898, 78.233))) * 43758.5453);
}

// Функция для создания горизонтальных глич-искажений
vec3 glitchEffect(vec2 uv, vec2 res) {
    float scanline = smoothstep(0.1, 0.9, sin(uv.y * res.y * 0.25 + time * 10.0));
    vec2 offset = vec2(0.0, random(uv + time) * 0.02); // горизонтальный сдвиг
    return texture2D(screenTex, uv + offset).rgb * scanline;
}

// Функция для создания вспышек
vec3 flashEffect(vec2 uv) {
    float intensity = smoothstep(0.7, 1.0, sin(time * 5.0)) * 0.3;
    return vec3(intensity);
}

// Функция для вертикальных полос
vec3 lineEffect(vec2 uv, vec2 res) {
    float line = step(0.9, sin(uv.x * res.x * 0.15 + time * 3.0));
    return vec3(line * 0.15);
}

// Функция для случайных искажений
vec3 distortionEffect(vec2 uv) {
    vec2 offset = vec2(sin(uv.y * 40.0 + time * 2.0) * 0.02, 0.0);
    return texture2D(screenTex, uv + offset).rgb;
}

void main() {
    vec2 uv = gl_FragCoord.xy / resolution.xy;
    vec3 color = texture2D(screenTex, uv).rgb;
    
    uv /= 2.0;

    // Рандомизация эффектов
    float rnd = random(vec2(time, uv.y));
    
    // Применение случайных эффектов
    if (rnd < 0.25) {
        color += glitchEffect(uv, resolution)/3.0;
    } else if (rnd < 0.5) {
        color += flashEffect(uv)/3.0f;
    } else if (rnd < 0.75) {
        color += lineEffect(uv, resolution)/3.0;
    } else {
        color += distortionEffect(uv)/3.0;
    }

    gl_FragColor = vec4(color, 1.0);
}
