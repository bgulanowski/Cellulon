#version 300 es

precision highp float;

uniform sampler2D sampler;
uniform bool initRandom;
uniform vec2 seed;

in vec2 point;

const float pixelWidth = 1.0/256.0;

layout (location = 0) out lowp vec4 vFragColor;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
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
        vec2 neighbour = p + neighbours[i] * pixelWidth;
        vec4 neighbourColour = texture(sampler, neighbour);
        if (neighbourColour.r == 1.0) {
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
    if (initRandom) {
        float random = rand(point + seed);
        vFragColor = (random > 0.5) ? alive : dead;
    }
    else {
        int count = count(point);
        vec4 texColor = texture(sampler, point);
        
        if (count < min || count > max) {
            vFragColor = vec4(0.0, 0.0, texColor.b * 31.0/32.0, 1.0);// + vec4(0.0, 0.0, 1.0/16.0, 0.0); // dead; //
        }
        else if (count == add) {
            vFragColor = alive;
        }
        else {
            vFragColor = texColor.r == 1.0 ? texColor : dead;
        }
    }
}
