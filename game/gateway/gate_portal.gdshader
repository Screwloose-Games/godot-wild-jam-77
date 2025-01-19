shader_type spatial;

uniform vec3 base_col;
uniform vec3 noise_col;
uniform float noise_strength;
uniform float noise_freq;

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
}

void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
}
