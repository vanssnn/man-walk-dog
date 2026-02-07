shader_type canvas_item;

uniform sampler2D mask_texture;
uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform vec4 transition_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
    // Ambil nilai dari gambar dither yang kamu kirim (masker)
    float mask = texture(mask_texture, UV).r;
    
    // Jika nilai mask lebih kecil dari progress, tampilkan warna penutup
    float alpha = step(mask, progress);
    
    COLOR = vec4(transition_color.rgb, alpha);
}