shader_type spatial;
render_mode unshaded;

uniform vec3 base_col;
uniform vec3 noise_col;
uniform float noise_strength;
uniform float noise_freq;
uniform float alpha_strength;

uniform vec2 velocity;
uniform sampler2D noise_sampler;
uniform sampler2D second_noise_sampler;

void vertex()
{
	// Called for every vertex the material is visible on.
}

void fragment()
{
	// Called for every pixel the material is visible on.
    float noise = texture(noise_sampler, UV + (TIME *velocity)).r;
    float noise_sec = texture(second_noise_sampler, UV).r;
    vec3 col = base_col;
    noise_sec = noise_sec - (sin(TIME * noise_freq) * noise_strength);
    col = mix(noise_col, col, noise * noise_sec);
    ALBEDO = col;
    ALPHA = (1.0 - (distance(vec2(0.5), UV)) * 3.0);
}
