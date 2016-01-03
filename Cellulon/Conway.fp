#version 300 es

precision highp float;

in vec2 point;

out vec4 vFragColor;

float rnd(vec2 x) {
    int n = int(x.x * 400.0 + x.y * 64000.0);
    n = (n << 13) ^ n;
    return 1.0 - float( (n * (n * n * 15731 + 789221) + 1376312589) & 0x7fffffff) / 1073741824.0;
}

void main() {
    float random = rnd(point) > 0.5 ? 1.0 : 0.0;
    vFragColor = vec4(random, random, random, 1.0);
}
