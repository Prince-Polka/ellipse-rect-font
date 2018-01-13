// Author: Prince Polka
// Title: triangle

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
/*
float side( vec2 A, vec2 B) {
    return dot(vec2(B.y-A.y,A.x-B.x),gl_FragCoord.xy-A);
}
float triangle(vec2 A, vec2 B, vec2 C) {
    float AB = side(A,B);
    return clamp(AB*side(B,C),0.0,1.0) *
           clamp(AB*side(C,A),0.0,1.0);
           
triangle would be more usefull than rect 
ellipse will be rewritten to use the same aa for consistency
           
will do multisampling so want to minimize the amount of work per sample by using the barrycentric method
https://stackoverflow.com/a/20861130/4900546

the 'new_triangle' function in finnished shader should 'just' fetch pre-calculated values from texture
}*/

struct tri{
    vec3 s;
    vec3 t;
    float A;
};

//uniform tri u_tri[5];

tri new_triangle(vec2 p0, vec2 p1, vec2 p2){
    tri ret;
    ret.s = vec3(p0.y * p2.x - p0.x * p2.y, p2.y - p0.y , p0.x - p2.x );
    ret.t = vec3(p0.x * p1.y - p0.y * p1.x, p0.y - p1.y , p1.x - p0.x );
    ret.A = -p1.y * p2.x + p0.y * (p2.x - p1.x) + p0.x * (p1.y - p2.y) + p1.x * p2.y;
    if (ret.A < 0.0) {
        ret.s = -ret.s;
        ret.t = -ret.t;
        ret.A = -ret.A;
    }
    return ret;
}

float triangle(tri T){
    vec3 p = vec3(1,gl_FragCoord.xy);
    float s = dot(T.s,p);
    float t = dot(T.t,p);
    return float(s > 0.0 && t > 0.0 && (s + t) <= T.A);
}

vec3 aatriangle(tri T){
    vec3 ret, p = vec3(1,gl_FragCoord.xy);
    float s,t,A = T.A;
    
    vec3 sample;
    
    sample = vec3(0.,-0.333,-0.333);
    s = dot(T.s,p+sample); t = dot(T.t,p+sample);
    ret.r += float(s > 0.0 && t > 0.0 && (s + t) <= T.A);
    sample.z = 0.0;
    s = dot(T.s,p+sample); t = dot(T.t,p+sample);
    ret.r += float(s > 0.0 && t > 0.0 && (s + t) <= T.A);
    sample.z = 0.333;
    s = dot(T.s,p+sample); t = dot(T.t,p+sample);
    ret.r += float(s > 0.0 && t > 0.0 && (s + t) <= T.A);
    
    sample = vec3(0.,0.,-0.333);
    s = dot(T.s,p+sample); t = dot(T.t,p+sample);
    ret.g += float(s > 0.0 && t > 0.0 && (s + t) <= T.A);
    s = dot(T.s,p); t = dot(T.t,p);
    ret.g += float(s > 0.0 && t > 0.0 && (s + t) <= T.A);
    sample.z = 0.333;
    s = dot(T.s,p+sample); t = dot(T.t,p+sample);
    ret.g += float(s > 0.0 && t > 0.0 && (s + t) <= T.A);
    
    sample = vec3(0.,0.333,-0.333);
    s = dot(T.s,p+sample); t = dot(T.t,p+sample);
    ret.b += float(s > 0.0 && t > 0.0 && (s + t) <= T.A);
    sample.z = 0.0;
    s = dot(T.s,p+sample); t = dot(T.t,p+sample);
    ret.b += float(s > 0.0 && t > 0.0 && (s + t) <= T.A);
    sample.z = 0.333;
    s = dot(T.s,p+sample); t = dot(T.t,p+sample);
    ret.b += float(s > 0.0 && t > 0.0 && (s + t) <= T.A);
    
    
    return ret*0.333;
}

void main() {
    vec2 st =gl_FragCoord.xy;
    tri mytriangle = new_triangle(vec2(0.760,0.610)*500., vec2(0.220,0.680)*500., vec2(0.400,0.300)*500. );
    vec3 foo= aatriangle(mytriangle);
    gl_FragColor = vec4(foo,1.00);
}
