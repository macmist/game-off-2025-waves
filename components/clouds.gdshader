shader_type canvas_item;

// ---- Cloud Controls ----
uniform float threshold : hint_range(0.0, 1.0) = 0.55; // Controls how much cloud coverage
uniform float softness : hint_range(0.0, 1.0) = 0.15;  // Smooth edges
uniform vec2 scroll_speed = vec2(0.01, 0.0);           // Horizontal drift speed
uniform float morph_speed = 0.02;                      // How fast cloud shapes change
uniform float alpha = 0.9;                             // Max opacity
uniform vec3 cloud_color = vec3(1.0);                  // Slightly tint clouds if needed

void fragment() {
    // Scroll the UVs over time
    vec2 uv = UV + TIME * scroll_speed;

    // Add a slow morphing offset to the UVs
    // This shifts the sampled noise pattern over time vertically and horizontally
    uv.y += sin(TIME * morph_speed) * 0.2;
    uv.x += cos(TIME * morph_speed * 0.7) * 0.2;

    // Sample the assigned noise texture (FastNoiseLite)
    float n = texture(TEXTURE, uv).r;

    // Soft threshold for smooth alpha edges
    float a = smoothstep(threshold, threshold + softness, n);

    COLOR = vec4(cloud_color, a * alpha);
}