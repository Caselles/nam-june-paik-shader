#version 300 es

precision highp float;

uniform vec2 u_resolution;
uniform float u_time;

in vec2 uv;
out vec4 out_color;

// Hash function to create pseudo-randomness based on time
float hash(float n) {
    return fract(sin(n) * 43758.5453123);
}

// Interpolated noise
float noise(float x) {
    float i = floor(x);
    float f = fract(x);
    float u = f * f * (3.0 - 2.0 * f); // smoothstep
    return mix(hash(i), hash(i + 1.0), u);
}

void main() {
    vec2 fragCoord = uv * u_resolution;
    vec2 pos = fragCoord / u_resolution;
    pos = pos * 2.0 - 1.0;  // Center UVs from -1 to 1

    // Irregular pulse using noise
    float pulse = 0.01 * (noise(u_time * 0.5) - 0.5);
    float intensity = 0.5 + pulse;

    float y = abs(pos.y); // vertical distance from center line

    float glowFalloff = 0.02 + 0.001 * sin(u_time * 3.0);
    glowFalloff = max(glowFalloff, 0.001); // avoid divide-by-zero

    float g = pow(y / glowFalloff, 0.2);

    vec3 bg = vec3(60.0 / 255.0);
    vec3 glow = vec3(1.6, 1.7, 1.82);
    glow = glow * -g * intensity + glow;
    glow = glow * glow;
    glow = glow * glow;

    vec3 col = bg + glow;

    out_color = vec4(col, 1.0);
}
