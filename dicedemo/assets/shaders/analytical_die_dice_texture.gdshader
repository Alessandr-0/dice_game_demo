// Original from Snowlith, https://godotshaders.com/shader/analytical-die-dice-texture/

shader_type canvas_item;

uniform int value: hint_range(1, 6, 1) = 1;

void fragment() {
	vec2 uv = UV * 3.0;
	float d = distance(ceil(uv) - 0.5, uv) - 0.45;
	float m = smoothstep(fwidth(d), 0.0, d);
	int c = abs(int(floor(uv.y) * 3.0 + floor(uv.x)) - 4);
	
	m *= float(c != 3);
	m *= float(c != 2 || value >= 2);
	m *= float(c != 4 || value >= 4);
	m *= float(c != 1 || value >= 6);
	m *= float(c != 0 || value % 2 == 1);
	
	COLOR.rgb = vec3(1.0 - m);
}