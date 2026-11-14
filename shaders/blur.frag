// Smooth 5x5 Gaussian-weighted blur fragment shader for Attract-Mode Plus
uniform sampler2D texture;
uniform vec2 texel_offset;

void main()
{
    vec2 uv = gl_TexCoord[0].xy;
    vec4 sum = vec4(0.0);

    // 5x5 Gaussian kernel weights (sum = 256.0)
    // Row -2
    sum += texture2D(texture, uv + vec2(-2.0, -2.0) * texel_offset) * 1.0;
    sum += texture2D(texture, uv + vec2(-1.0, -2.0) * texel_offset) * 4.0;
    sum += texture2D(texture, uv + vec2( 0.0, -2.0) * texel_offset) * 6.0;
    sum += texture2D(texture, uv + vec2( 1.0, -2.0) * texel_offset) * 4.0;
    sum += texture2D(texture, uv + vec2( 2.0, -2.0) * texel_offset) * 1.0;

    // Row -1
    sum += texture2D(texture, uv + vec2(-2.0, -1.0) * texel_offset) * 4.0;
    sum += texture2D(texture, uv + vec2(-1.0, -1.0) * texel_offset) * 16.0;
    sum += texture2D(texture, uv + vec2( 0.0, -1.0) * texel_offset) * 24.0;
    sum += texture2D(texture, uv + vec2( 1.0, -1.0) * texel_offset) * 16.0;
    sum += texture2D(texture, uv + vec2( 2.0, -1.0) * texel_offset) * 4.0;

    // Row 0
    sum += texture2D(texture, uv + vec2(-2.0,  0.0) * texel_offset) * 6.0;
    sum += texture2D(texture, uv + vec2(-1.0,  0.0) * texel_offset) * 24.0;
    sum += texture2D(texture, uv + vec2( 0.0,  0.0) * texel_offset) * 36.0;
    sum += texture2D(texture, uv + vec2( 1.0,  0.0) * texel_offset) * 24.0;
    sum += texture2D(texture, uv + vec2( 2.0,  0.0) * texel_offset) * 6.0;

    // Row +1
    sum += texture2D(texture, uv + vec2(-2.0,  1.0) * texel_offset) * 4.0;
    sum += texture2D(texture, uv + vec2(-1.0,  1.0) * texel_offset) * 16.0;
    sum += texture2D(texture, uv + vec2( 0.0,  1.0) * texel_offset) * 24.0;
    sum += texture2D(texture, uv + vec2( 1.0,  1.0) * texel_offset) * 16.0;
    sum += texture2D(texture, uv + vec2( 2.0,  1.0) * texel_offset) * 4.0;

    // Row +2
    sum += texture2D(texture, uv + vec2(-2.0,  2.0) * texel_offset) * 1.0;
    sum += texture2D(texture, uv + vec2(-1.0,  2.0) * texel_offset) * 4.0;
    sum += texture2D(texture, uv + vec2( 0.0,  2.0) * texel_offset) * 6.0;
    sum += texture2D(texture, uv + vec2( 1.0,  2.0) * texel_offset) * 4.0;
    sum += texture2D(texture, uv + vec2( 2.0,  2.0) * texel_offset) * 1.0;

    gl_FragColor = gl_Color * (sum / 256.0);
}
