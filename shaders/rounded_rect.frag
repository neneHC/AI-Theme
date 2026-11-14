// Anti-aliased rounded rectangle / pill fragment shader for Attract-Mode Plus
uniform sampler2D texture;
uniform vec2 size;
uniform float radius;

void main()
{
    vec2 uv = gl_TexCoord[0].xy;
    vec2 half_size = size * 0.5;
    vec2 p = uv * size - half_size;
    float r = min(radius, min(half_size.x, half_size.y));
    vec2 q = abs(p) - half_size + vec2(r);
    float dist = length(max(q, 0.0)) + min(max(q.x, q.y), 0.0) - r;
    float edge_alpha = 1.0 - smoothstep(-1.0, 1.0, dist);

    vec4 pixel = texture2D(texture, uv);
    gl_FragColor = vec4(gl_Color.rgb * pixel.rgb, gl_Color.a * pixel.a * edge_alpha);
}
