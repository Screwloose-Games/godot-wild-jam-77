shader_type spatial;

uniform sampler2D albedo_texture;

uniform float opacity : hint_range(0.0, 1.0);
uniform float r : hint_range(0.0, 1.0);
uniform float g : hint_range(0.0, 1.0);
uniform float b : hint_range(0.0, 1.0);
uniform float mix_color : hint_range(0.0, 1.0);

void fragment() {
    vec4 texture_color = texture(albedo_texture, UV);
    if (texture_color.a > 0.0) {
        ALBEDO = mix(texture_color.rgb, vec3(r, g, b), mix_color);
        ALPHA = opacity * texture_color.a;
    } else {
        discard; // Optional: discard completely transparent pixels
    }
}

void light() {
    // Calculate diffuse lighting
    float cNdotL = max(dot(NORMAL, LIGHT), 0.0); // Cosine of angle between normal and light
    vec3 diffuse_light = LIGHT_COLOR.rgb * ALBEDO * cNdotL;

    // Combine with ambient light if needed
    DIFFUSE_LIGHT = diffuse_light; // Output final diffuse light
}
