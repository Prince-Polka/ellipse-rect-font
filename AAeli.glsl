// Author: Prince Polka
// Title: Anti Aliased Ellipse

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
const float angle=0.5;
const vec2 rot = vec2(sin(angle),cos(angle))*1.414213562;
vec3 pitch = vec3(-0.33,0.0,0.33);
vec3 ellipse(vec2 A, vec4 size, vec2 rot){
         A -= size.xy;
    vec3 B = A.x+pitch;
    vec3 C = (B*rot.y+A.y*rot.x)/size.w;
    B = B*rot.x-A.y*rot.y;
    B=B*B/(size.z*size.z)+C*C;
    return smoothstep(0.9,1.1,B);
}
void main() {

    vec2 st =gl_FragCoord.xy;
    gl_FragColor = vec4(ellipse(st-0.5,vec4(250.0,250.0,30.0,50.0),rot),1.00);
}
