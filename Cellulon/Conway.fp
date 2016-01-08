#version 300 es

precision highp float;

uniform sampler2D sampler;

in vec2 point;

layout (location = 0) out lowp vec4 vFragColor;

float rnd(vec2 x) {
    int n = int(x.x * 400.0 + x.y * 64000.0);
    n = (n << 13) ^ n;
    return 1.0 - float( (n * (n * n * 15731 + 789221) + 1376312589) & 0x7fffffff) / 1073741824.0;
}

int count(vec2 p) {
    
    const vec2 neighbours[8] = vec2[](
        vec2(-1, -1),
        vec2(-1,  0),
        vec2(-1,  1),
        
        vec2( 0, -1),
        vec2( 0,  1),
        
        vec2( 1, -1),
        vec2( 1,  0),
        vec2( 1,  1)
    );
    
    int count = 0;
    for (int i = 0; i < 8; ++i) {
        if (texture(sampler, p + neighbours[i]).r > 0.5) {
            ++count;
        }
    }
    return count;
}

// TODO: convert to uniforms
const int min = 2;
const int max = 3;
const int add = 3;

const vec4 alive = vec4(1.0);
const vec4 dead = vec4(vec3(0.0), 1.0);

void main() {

    vec4 texColor = texture(sampler, point);
#if 1
    float random = rnd(point) > 0.5 ? 1.0 : 0.0;
    vec4 randomColor = vec4(random, random, random, 1.0);
    vFragColor = texColor * 0.6 + randomColor * .4;
#else
    vFragColor = texColor;
    int count = count(point);
    
    if (count < min || count > max) {
        vFragColor = dead;
    }
    else if (count == add) {
        vFragColor = alive;
    }
    else {
        vFragColor = texColor;
    }
#endif
}
