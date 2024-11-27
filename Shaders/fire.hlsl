
#define ITR 120
#define MAX 80.0
#define SRF 0.001



vec3 pal(vec3 a, vec3 b, vec3 c, vec3 d, float t)
{

    
    return a + b * cos(c * (t + d));


}


float map(vec3 sp)
{
    sp.x = mod(sp.x + 0.2, 2.5) - 1.25;
    sp *= 0.7;
    sp.y += 3.5;
    sp.y *= 0.25;
    return length(sp) - 1.0;

}



float mrch(vec3 ro, vec3 rd)
{


    float d0 = 0.0;
    for (int i = 0; i < ITR; ++i)
    {
    
    
        vec3 sp = ro + rd * d0;
        float ds = map(sp);
        d0 += ds;
        
        if (d0 > MAX || abs(ds) < SRF) break;
    
    
    }
    
    
    return d0;


}



vec3 dir(vec2 uv, vec3 r0, vec3 fx)
{



    vec3 w = normalize(fx - r0);
    vec3 u = normalize(cross(w, vec3(0.0, 1.0, 0.0)));
    vec3 v = normalize(cross(u, w));
    return mat3(u, v, w) * normalize(vec3(uv, 2.5));
    

}




vec3 nml(vec3 p)
{


    vec2 d = vec2(0.001, 0.0);
    return normalize(map(p) - vec3(map(p - d.xyy), map(p - d.yxy), map(p - d.yyx)));
    

}



float lighting(vec3 sp, vec3 lp)
{


    vec3 l = normalize(lp - sp);
    vec3 n = nml(sp);
    float df = clamp(dot(n, l), 0.0, 1.0);
    float ds = mrch(sp + n * 0.02, l);
    
    if (ds < length(lp - sp))
    {
    
    
        df *= 0.1;
        
    
    }
    
    
    return df;


}



void mainImage(out vec4 c_out, in vec2 u)
{
    
    
    vec2 rr = iResolution.xy, uv = (u + u - rr) / rr.y;
    vec3 r0 = vec3(0.0, 0.5, -5.0 -(cos(iTime) * 0.5 + 0.5) * 0.1);
    vec3 fx = vec3(0.0, cos(iTime) * 0.5 + 0.5, sin(iTime));
    
    uv.x *= 0.3;
    uv.y *= 0.6;
    
    float tscale = 0.9;
    float ampscale = 0.8;
    
    uv.x += cos(uv.y * 6.0 + iTime * 23.0) * 0.018 * ampscale;
    uv.x *= (1.0 + sin(uv.y * 2.5 + iTime * 29.4 * tscale) * 0.01 * ampscale);
    uv.y *= (1.0 + cos(uv.x * 2.7 + iTime * 31.1 * tscale) * 0.01 * ampscale);
    uv.x -= sin(uv.y * 3.0 + iTime * 41.5 * tscale) * 0.01 * ampscale;
    uv.x += cos(uv.y * 5.0 + iTime * 53.2 * tscale) * 0.055 * ampscale;
    uv.y -= cos(uv.x * 11.0 + iTime * 41.1 * tscale) * 0.5 * ampscale;
    uv.y -= cos(uv.x * 41.0 + iTime * 311.2 * tscale) * 0.1 * ampscale;
    uv.y += cos(uv.x * 23.0 + iTime * 31.1 * tscale) * 0.14 * ampscale;
    uv.y -= sin(uv.x * 31.0 + iTime * 43.0 * tscale) * 0.16 * ampscale;
    
    vec3 rd = dir(uv, r0, fx);
    
   
    vec3 a = vec3(0.2, 0.2, 0.2);
    vec3 b = vec3(0.5,  0.25, 0.23);
    vec3 c = vec3(7.0,  1.1, 0.76);
    vec3 d = vec3(1.0, 1.0, 1.75);
    
    
    float d0 = mrch(r0, rd);
    
    vec3 cl = vec3(0.0);
    
    if (d0 > 0.0)
    {
    
        vec3 hp = r0 + rd * d0;
        cl += lighting(hp, vec3(-0.2, 0.065, -2.0)) * pal(a, b, c, d, d0);
        
    }

    cl = pow(cl, vec3(3.0)) * 22.0;
    c_out = vec4(cl, 1.0);
}
