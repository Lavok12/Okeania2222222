#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define TAU 6.28318530718
#define MAX_ITER 5

uniform float iTime;
uniform vec2 iResolution;
uniform vec2 iS;

uniform float Alpha;
uniform float Balance;

uniform sampler2D texture1;
uniform sampler2D tm;

void main() 
{
	float time = iTime * .5+23.0;
    // uv should be the 0-1 uv of texture...
	vec2 uv = gl_FragCoord.xy / iResolution.xy + iS / iResolution;
    
#ifdef SHOW_TILING
	vec2 p = mod(uv*TAU*2.0, TAU)-250.0;
#else
    vec2 p = mod(uv*TAU, TAU)-250.0;
#endif

vec3 tmap = (1.0-texture2D(tm, gl_FragCoord.xy / iResolution.xy).xyz);
vec3 original = texture2D(texture1, gl_FragCoord.xy / iResolution.xy).xyz;

	vec2 i = vec2(p);
	float c = 1.0;
	float inten = .005;

	for (int n = 0; n < MAX_ITER; n++) 
	{
		float t = time * (1.0 - (3.5 / float(n+1)));
		i = p + vec2(cos(t - i.x) + sin(t + i.y), sin(t - i.y) + cos(t + i.x));
		c += 1.0/length(vec2(p.x / (sin(i.x+t)/inten),p.y / (cos(i.y+t)/inten)));
	}
	c /= float(MAX_ITER);
	c = 1.17-pow(c, 1.4);
	vec3 colour = vec3(pow(abs(c), 8.0));
    colour = clamp(colour + vec3(0.0, 0.35, 0.5), 0.0, 1.0);

	#ifdef SHOW_TILING
	// Flash tile borders...
	vec2 pixel = 2.0 / iResolution.xy;
	uv *= 2.0;
	float f = floor(mod(iTime*.5, 2.0)); 	// Flash value.
	vec2 first = step(pixel, uv) * f;		   	// Rule out first screen pixels and flash.
	uv  = step(fract(uv), pixel);				// Add one line of pixels per tile.
	colour = mix(colour, vec3(1.0, 1.0, 0.0), (uv.x + uv.y) * first.x * first.y); // Yellow line
	#endif
    
	float mp = iResolution.x/Balance;
	gl_FragColor = vec4(colour*(1.0-Alpha) + texture2D(texture1, 
	(gl_FragCoord.xy+
	vec2(sin(colour.x*60.0+colour.y*60.0+iTime/100.0)*mp, sin(colour.y*60.0+colour.z*60.0-iTime/100.0)*mp)
	) / iResolution.xy).xyz*Alpha, 1.0);

	gl_FragColor.xyz = gl_FragColor.xyz*0.7+vec3(0.19,0.21,0.4)*0.3;
	gl_FragColor.xyz = gl_FragColor.xyz * tmap + original * (1.0-tmap);
}