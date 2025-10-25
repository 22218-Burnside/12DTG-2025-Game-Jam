shader_type canvas_item;

uniform bool make_white = false;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    
    if (make_white) {
        // Make it solid white but preserve alpha
        COLOR = vec4(1.0, 1.0, 1.0, tex_color.a);
    } else {
        COLOR = tex_color;
    }
}
