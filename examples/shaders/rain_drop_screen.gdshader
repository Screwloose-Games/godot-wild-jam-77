shader_type canvas_item;

#define iResolution 1.0 / SCREEN_PIXEL_SIZE
#define iTime TIME
#define fragColor COLOR

// Define the screen texture uniform using the hint
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float frequency : hint_range(-10.0, 4.0, 0.1) = 0.0;
uniform float size : hint_range(0.001, 0.05, 0.001) = 0.015;

vec2 rand(vec2 c) {
    mat2 m = mat2(vec2(12.9898, .16180), vec2(78.233, .31415));
    return fract(sin(m * c) * vec2(43758.5453, 14142.1));
}

vec2 noise(vec2 p) {
    vec2 co = floor(p);
    vec2 mu = fract(p);
    mu = 3.0 * mu * mu - 2.0 * mu * mu * mu;
    vec2 a = rand((co + vec2(0.0, 0.0)));
    vec2 b = rand((co + vec2(1.0, 0.0)));
    vec2 c = rand((co + vec2(0.0, 1.0)));
    vec2 d = rand((co + vec2(1.0, 1.0)));
    return mix(mix(a, b, mu.x), mix(c, d, mu.x), mu.y);
}

void fragment() {
    vec2 u = FRAGCOORD.xy / SCREEN_PIXEL_SIZE; // Use screen pixel size
    vec2 v = u * 0.1;
    vec2 n = noise(v * 200.0); // Displacement

    fragColor = textureLod(SCREEN_TEXTURE, u / iResolution.xy, 2.5); // Sample from the screen texture

    // Loop through the different inverse sizes of drops
    for (float r = 4.0; r > frequency; r--) {
        vec2 x = iResolution.xy * r * size; // Number of potential drops (in a grid)
        vec2 p = 6.28 * u * x + (n - 0.5) * 2.0;
        vec2 s = sin(p);

        // Current drop properties
        vec2 v = round(u * x - 0.25) / x;
        vec4 d = vec4(noise(v * 200.0), noise(v));

        // Drop shape and fading
        float t = (s.x + s.y) * max(0.0, 1.0 - fract(iTime * (d.b + 0.1) + d.g) * 2.0);

        // d.r -> only x% of drops are kept on, with x depending on the size of drops
        if (d.r < (5.0 - r) * 0.08 && t > 0.5) {
            // Drop normal
            vec3 v = normalize(-vec3(cos(p), mix(0.2, 2.0, t - 0.5)));

            // Poor man's refraction (no visual need to do more)
            fragColor = texture(SCREEN_TEXTURE, u / iResolution.xy - v.xy * 0.3);
        }
    }

    // Debug noise function
    // fragColor = vec4(n, 0.0, 1.0);
}
