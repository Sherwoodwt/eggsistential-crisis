shader_type canvas_item;

uniform vec4 highlight_color = vec4(.6, .6, 1.0, 1.0);
uniform float width = 4.0;
uniform float speed = 3.0;

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 tex = texture(TEXTURE, UV);
	float wave = 0.5 + 0.5 * sin((UV.x + UV.y) * width - TIME * speed);
	float strength = wave * tex.a;
	COLOR.rgb = mix(tex.rgb, highlight_color.rgb, strength * 0.6);
	COLOR.a = tex.a;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
