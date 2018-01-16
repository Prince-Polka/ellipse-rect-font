// Author: Prince Polka
// Title: ellipse

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
#define SQRT2 1.414213562

struct elirect{
  vec2 centre; // centre of ellipse / rectangle
  vec2 sizesq; // width height squared
  vec2 rot; // sin(angle)*sqrt(2) , cos(angle)*sqrt(2) 
  float mode; // 0.0 for eli, 1.0 for rect
  float mult; // 1 add to glyph, or -1 remove from glyph
};

elirect new_elirect(float centerx, float centery, float width, float height, float angle, float mode, float mult){
    elirect ret;
    ret.centre = vec2(centerx,centery);
    ret.sizesq = vec2(width*width,height*height);
    ret.rot = vec2(cos(angle),sin(angle))*SQRT2;
    ret.mode = mode; // 0.0 for eli 1.0 for rect
    ret.mult = mult;
    return ret;
}

float pointinelirect(vec2 st, elirect e){
    /* rotation same for both modes */
    st -= e.centre;
    e.rot = e.rot * st.x + e.rot.yx * vec2(st.y,-st.y);
    e.rot *= e.rot;
    
    /* for eli e.rot / e.sizesq , for rect e.rot / e.sizesq */
    vec2 mode = max ( mix( e.rot/e.sizesq, e.rot-e.sizesq, e.mode ), vec2(0) );
    
    /* end part same for both modes */
    return 1.0 - e.mult * float( dot( mode ,vec2(1) ) >= 1.0 );
}

void main() {
    float mode; // 0.0 for eli 1.0 for rect
    
    mode = float(mod(u_time,2.0)>=1.0);
    
    vec2 st =gl_FragCoord.xy;
    elirect glyph = new_elirect(250.,250.,30.,50.,u_time,mode,1.0);
    float foo = pointinelirect(st,glyph);
    
    gl_FragColor = vec4(vec3(foo),1.00);
}
