shader_type canvas_item;

uniform vec2 scroll_speed_1 =vec2(0.025, 0.012);
uniform vec2 scroll_speed_2 = vec2(-0.018, 0.022);
uniform float shimmer_strength = 0.25;
uniform vec4 tint_color : source_color = vec4(0.23, 0.71, 0.76, 1.0);

void fragment() {
    // Two UV offsets for layered movement
    vec2 uv1 = UV + TIME * scroll_speed_1 + vec2(0.23, 0.42);
	vec2 uv2 = UV + TIME * scroll_speed_2 + vec2(-0.37, 0.18);

    // Sample the base texture twice with different offsets
    vec4 tex1 = texture(TEXTURE, uv1);
    vec4 tex2 = texture(TEXTURE, uv2);

    // Combine with a shimmer modulation
    float shimmer = mix(0.8, 1.2, (tex1.r + tex2.g) * 0.5);
    vec4 color = mix(tex1, tex2, 0.5) * shimmer;
    // Apply tint and output
    COLOR = color * tint_color;
	
	float pulse = 1.0 + 0.05 * sin(TIME * 0.5);
	COLOR.rgb *= pulse;
	COLOR.rgb = pow(COLOR.rgb, vec3(0.9));
	
}