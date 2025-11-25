shader_type canvas_item;

// New way to access the screen behind the control
uniform sampler2D screen_tex : hint_screen_texture;

// Your noise texture
uniform sampler2D noise_tex;
uniform float noise_strength = 0.08;
uniform float noise_scale = 4.0;

void fragment() {
    // Sample the screen (what the StyleBoxFlat already drew)
    vec4 base = texture(screen_tex, SCREEN_UV);

    // Sample tiling noise
    vec4 noise = texture(noise_tex, UV * noise_scale);

    // Combine
    COLOR = vec4(base.rgb + noise.rgb * noise_strength, base.a);
}