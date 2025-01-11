shader_type canvas_item;

uniform float angle : hint_range(0.0, 360.0) = 45.0; // Angle of the rain lines in degrees
uniform int count : hint_range(1, 500) = 100; // Number of lines
uniform float length : hint_range(1.0, 100.0) = 10.0; // Length of each rain line

// Randomness seed based on time or any other seed you'd like to use
float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void fragment() {
    vec2 uv = FRAGCOORD.xy / SCREEN_PIXEL_SIZE;
    float time = TIME * 2.0;

    // Calculate direction vector from angle
    float rad_angle = radians(angle);
    vec2 direction = vec2(cos(rad_angle), sin(rad_angle));

    // Loop to draw multiple lines
    float rain = 0.0;
    for (int i = 0; i < count; i++) {
        float line_seed = float(i) / float(count);

        // Random position for each line
        float x_pos = rand(vec2(line_seed, time)) * SCREEN_PIXEL_SIZE.x;
        float y_pos = rand(vec2(line_seed + 0.1, time)) * SCREEN_PIXEL_SIZE.y;

        vec2 rain_start = vec2(x_pos, y_pos);
        vec2 rain_end = rain_start + direction * length;

        // Compute the distance from the current pixel to the rain line
        float distance = length(rain_start + mod(time * direction * 100.0, SCREEN_PIXEL_SIZE) - uv);

        // Draw line if the pixel is close enough to the rain line
        if (distance < 1.0) {
            rain += 1.0;
        }
    }

    // Set the output color (white for rain, otherwise transparent)
    if (rain > 0.0) {
        COLOR = vec4(1.0, 1.0, 1.0, 1.0);
    } else {
        discard; // Discard pixels that are not part of the rain
    }
}
