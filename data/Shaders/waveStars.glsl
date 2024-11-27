#ifdef GL_ES
precision mediump float;
#endif

uniform float iTime;
uniform vec2 iResolution;
uniform vec3 iMouse;

// colors
vec3 col_water = vec3(0.3, 0.7, 1.0);
float t = 20.0;

// marching
float maxdist = 5.0;
float det = 0.001;

// 2D rotation
mat2 rot2D(float a) {
  a = radians(a);
  float s = sin(a);
  float c = cos(a);
  return mat2(c, s, -s, c);
}

// Align vector
mat3 lookat(vec3 fw, vec3 up) {
  fw = normalize(fw);
  vec3 rt = normalize(cross(fw, normalize(up)));
  return mat3(rt, cross(rt, fw), fw);
}

// Tile fold
float fmod(float p, float c) {
  return abs(c - mod(p, c * 2.0)) / c;
}

// Smooth min
float smin(float a, float b, float k) {
  float h = clamp(0.5 + 0.5 * (b - a) / k, 0.0, 1.0);
  return mix(b, a, h) - k * h * (1.0 - h);
}

// Smooth max
float smax(float a, float b, float k) {
  float h = clamp(0.5 + 0.5 * (a - b) / k, 0.0, 1.0);
  return mix(b, a, h) - k * h * (1.0 - h);
}

// BACKGROUND AND FOREGROUND FRACTAL

float fractal(vec3 p, float time) {
  p += cos(p.z * 3.0 + time * 4.0) * 0.02;
  float depth = smoothstep(0.0, 6.0, -p.z + 5.0);
  p *= 0.3;
  p = abs(2.0 - mod(p + vec3(0.4, 0.7, time * 0.07), 4.0));
  float ls = 0.0;
  float c = 0.0;
  for (int i = 0; i < 6; i++) {
    p = abs(p) / min(dot(p, p), 1.0) - 0.9;
    float l = length(p);
    c += abs(l - ls);
    ls = l;
  }
  return 0.15 + smoothstep(0.0, 50.0, c) * depth * 4.0;
}

// RAY MARCHING AND SHADING

vec3 march(vec3 from, vec3 dir, vec3 dir_light, float time) {
  vec3 odir = dir;
  vec3 p = from + dir * 2.0;
  float fg = fractal(p + dir, time) * 0.55;
  vec3 col = vec3(0.0);
  float totdist = 0.0;
  float d;
  float v = 0.0;

  float fade = smoothstep(maxdist * 0.2, maxdist * 0.9, maxdist - totdist);
  float ref = 1.0;
  if (d < det * 2.0) {
    p -= (det - d) * dir;
    col = mix(col_water * 0.15, col, fade);
  }
  col *= normalize(col_water + 1.5) * 1.7;
  p = maxdist * dir;
  vec3 bk = fractal(p, time) * ref * col_water;
  float glow = pow(max(0.0, dot(dir, -dir_light)), 1.5);
  vec3 glow_water = normalize(col_water + 1.0);
  bk += glow_water * (glow + pow(glow, 8.0) * 1.5) * ref;
  col += v * 0.06 * glow * ref * glow_water;
  col += bk + fg * col_water;
  return col;
}

// MAIN

void main() {
  // Set globals
  float time = mod(iTime, 600.0);
  vec3 dir_light = normalize(vec3(-0.3, 0.2, 1.0));

  // Pixel coordinates
  vec2 uv = gl_FragCoord.xy / iResolution.xy - 0.5;
  vec2 uv2 = uv;
  float ar = iResolution.x / iResolution.y;
  uv.x *= ar;

  // Camera
  vec2 mouse = (iMouse.xy / iResolution.xy - 0.5) * 4.0;
  float tcam = (time + 67.0) * 0.05;
  float zcam = smoothstep(0.7, 1.0, cos(tcam)) * 1.8 - 0.3;
  zcam -= smoothstep(0.7, 1.0, -cos(tcam)) * 1.6;
  if (iMouse.z < 0.1) mouse = vec2(sin(time * 0.15) * ar, zcam);
  vec3 dir = normalize(vec3(uv, 0.9));
  vec3 from = vec3(1.0, 0.0, -0.5 + mouse.y) * 1.25;
  from.xy *= rot2D(-mouse.x * 40.0);
  dir = lookat(normalize(-from + vec3(sin(time * 0.5) * 0.3, cos(time * 0.25) * 0.1, 0.0)), vec3(0.0, 0.0, -1.0)) * dir;

  // March and color
  vec3 col = march(from, dir, dir_light, time);
  col *= vec3(1.1, 0.9, 0.8);
  col += dot(uv2, uv2) * vec3(0.0, 0.6, 1.0) * 0.8;

  // Output to screen
  gl_FragColor = vec4(col, 0.5);
}
