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
mult 1 add to glyph, or -1 remove from glyph
*/
struct eli{
  vec2 centre;
  vec2 sizesq;
  vec2 rot;
  float mult;
};
//vec2 rot(float angle){return vec2(cos(angle),sin(angle))*SQRT2;}
eli ellipse(float centerx, float centery, float width, float height, float angle, float mult){
    eli ret;
    ret.centre = vec2(centerx,centery);
    ret.sizesq = vec2(width*width,height*height);
    ret.rot = vec2(cos(angle),sin(angle))*SQRT2;
    ret.mult = mult;
    return ret;
}

float ellipse(vec2 st, eli e){
    st -= e.centre;
    e.rot = e.rot * st.x + e.rot.yx * vec2(st.y,-st.y);
    return e.mult * smoothstep(1.1,0.9, dot( e.rot*e.rot / e.sizesq , vec2(1) ) );
}

void main() {
    vec2 st =gl_FragCoord.xy;
    eli glyph[4];
    const int n = 4;
    glyph[0] = ellipse(250.,250.,30.,50.,0.1,1.0);
    glyph[1] = ellipse(250.,250.,30.,50.,-0.1,1.0);
    glyph[2] = ellipse(250.0,250.,20.,40.,0.1,-1.0);
    glyph[3] = ellipse(250.0,250.,20.,40.,-0.1,-1.0);
    
    float foo = 0.0;
    for(int i=0;i<n;i++)
        foo = clamp(foo+ellipse(st,glyph[i]),0.,1.);
    gl_FragColor = vec4(vec3(foo),1.00);
}
