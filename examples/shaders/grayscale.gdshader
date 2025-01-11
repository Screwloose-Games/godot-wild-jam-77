shader_type canvas_item;

// --- Uniforms --- //
uniform bool weighted = true;    // Determines whether to use normal or weighted averages
uniform float blue_intensity = 0.1; // Intensity of the blue hue

void fragment() {
    vec3 grayscale = mix(vec3((COLOR.r + COLOR.g + COLOR.b) / 3.0),  vec3(0.299 * COLOR.r + 0.587 * COLOR.g + 0.114 * COLOR.b), float(weighted));
    vec3 blue_tint = vec3(0.0, 0.0, 1.0);
    COLOR.rgb = mix(grayscale, blue_tint, blue_intensity);
}
