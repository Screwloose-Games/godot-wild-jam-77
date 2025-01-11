shader_type spatial;

// A sludgy wobbly jiggly jello shader 

uniform sampler2D MY_TEXTURE;

// wave var
uniform vec2 wave_strength = vec2(0.05, 0.025);
uniform vec2 wave_frequ = vec2(12.0, 12.0);
uniform vec2 time_factor = vec2(6.0, 12.0);

float waves(vec2 pos, float time) {
	return (wave_strength.y * sin(pos.y * wave_frequ.y + time * time_factor.y)) + (wave_strength.x * sin(pos.x * wave_frequ.x + time * time_factor.x));
}

void vertex() {
	VERTEX.y += waves(VERTEX.xy, TIME);
}

void fragment() {
	// Called for every pixel the material is visible on.
    ALBEDO = texture(MY_TEXTURE, UV).xyz;
}


