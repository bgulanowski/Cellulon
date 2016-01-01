#version 300 es

precision highp float;

in vec2 position;
layout(location = 0) out vec4 vFragColor;

float rnd(vec2 x) {
    int n = int(x.x * 40.0 + x.y * 6400.0);
    n = (n << 13) ^ n;
    return 1.0 - float( (n * (n * n * 15731 + 789221) + 1376312589) & 0x7fffffff) / 1073741824.0;
}

void main() {
    float random = rnd(position);
    vFragColor = vec4(random, random, random, 1.0);
}
