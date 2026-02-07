shader_type canvas_item;

uniform sampler2D mask_texture;

uniform float progress : hint_range(0.0, 1.0);
uniform vec4 color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
	float mask = texture(mask_texture, UV).r;

	if (mask < progress) {
		COLOR = color;
	} else {
		COLOR = vec4(0.0, 0.0, 0.0, 0.0);
	}
}