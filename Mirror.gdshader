shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear;

uniform float distortion_strength = 0.02; // 0.0 = perfect mirror
uniform float reflect_strength = 0.7;     // 0 = none, 1 = full mirror
uniform float glass_tint_strength = 0.15; // how tinted the glass is
uniform vec4 glass_color : source_color = vec4(0.6, 0.8, 1.0, 1.0);

void fragment() {

    vec2 screen_uv = SCREEN_UV;

    // Simple procedural distortion
    float wave = sin(UV.y * 35.0 + TIME * 3.0) * 0.005;
    float noise = cos(UV.x * 25.0 + TIME * 2.0) * 0.005;
    vec2 distortion = vec2(wave, noise) * distortion_strength * 50.0;

    vec4 screen_col = texture(screen_texture, screen_uv + distortion);

    // Original texture (if your sprite has one)
    vec4 base = texture(TEXTURE, UV);

    // Mix reflection + base
    vec4 reflected = mix(base, screen_col, reflect_strength);

    // Add glass tint
    reflected.rgb = mix(reflected.rgb, glass_color.rgb, glass_tint_strength);

    COLOR = reflected;
}