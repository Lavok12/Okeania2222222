#ifdef GL_ES
precision highp float;
#endif

uniform sampler2D texture;
uniform vec2 resolution;
uniform float sigma; // Радиус фильтра
uniform float sigmaR; // Сила фильтра

const float PI = 3.1415926535;

float gaussian(float x, float sigma) {
    return exp(-(x*x) / (2.0 * sigma*sigma)) / (2.0 * PI * sigma);
}

void main() {
    vec2 texCoord = gl_FragCoord.xy / resolution;
    vec4 sum = vec4(0.0);
    vec4 centralColor = texture2D(texture, texCoord);
    float normalization = 0.0;

    for(int x = -int(sigma); x <= int(sigma); x++) {
        for(int y = -int(sigma); y <= int(sigma); y++) {
            vec2 samplePos = texCoord + vec2(x, y) / resolution;
            vec4 color = texture2D(texture, samplePos);

            float weight = gaussian(float(x), sigma) * gaussian(float(y), sigma) * gaussian(length(color.rgb - centralColor.rgb), sigmaR);

            sum += color * weight;
            normalization += weight;
        }
    }

    gl_FragColor = sum / normalization;
}
