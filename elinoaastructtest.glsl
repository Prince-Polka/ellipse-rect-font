// Author: Prince Polka
// Title: ellipse

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
#define SQRT2 1.414213562
/*
st fragCoord
pos, centre of ellipse
sizesq width and height of ellipse
rot sin(angle)*sqrt(2) , cos(angle)*sqrt(2) 
*/
struct eli{
  vec2 centre;
  vec2 sizesq;
  vec2 rot;
};
vec2 rot(float angle){
    return vec2(cos(angle),sin(angle))*SQRT2;
}
eli ellipse(float centerx, float centery, float width, float height){
    eli ret;
    ret.centre = vec2(centerx,centery);
    ret.sizesq = vec2(width*width,height*height);
    ret.rot = vec2(SQRT2,0);
    return ret;
}

float ellipse(vec2 st, eli e){
    st -= e.centre;
    e.rot = e.rot * st.x + e.rot.yx * vec2(st.y,-st.y);
    return smoothstep(0.9,1.1, dot( e.rot*e.rot / e.sizesq , vec2(1) ) );
}

void main() {
    vec2 st =gl_FragCoord.xy;
    eli e = ellipse(250.,250.,30.,50.);
    //e.rot = rot(u_time);
    gl_FragColor = vec4(vec3(ellipse(st, e)),1.00);
}
