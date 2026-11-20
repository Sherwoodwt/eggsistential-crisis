shader_type canvas_item;

uniform vec4 highlight_color : source_color = vec4(0.2, 0.9, 0.3, 1.0);
uniform float hover_amount : hint_range(0.0, 1.0) = 0.25;
uniform float pulse_speed : hint_range(0.0, 10.0) = 4.0;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	float pulse = 0.5 + 0.5 * sin(TIME * pulse_speed);
	float mix_factor = hover_amount * mix(0.35, 0.75, pulse);
	
	vec3 mixed = mix(tex.rgb, highlight_color.rgb, mix_factor);
	COLOR = vec4(mixed, tex.a);
}