// Author: Prince Polka
// Title: ellipse

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
#define SQRT2 1.414213562
#define third 0.33333334

const vec3 some = vec3(-third,0,third);
const vec3 down = vec3(third);
const mat3 pitchx = mat3(some,some,some);
const mat3 pitchy = mat3(-down,vec3(0),down);

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
    ret.sizesq = vec2(width*width*1.5,height*height*1.5);
    ret.rot = vec2(cos(angle),sin(angle))*SQRT2;
    ret.mode = mode; // 0.0 for eli 1.0 for rect
    ret.mult = mult;
    return ret;
}

vec3 sample9(vec2 st, elirect e){
    st -= e.centre;
    
    mat3 mx,my,px,py;
    
    mx = mat3(e.rot.x);
    my = mat3(e.rot.y);
    px = pitchx + st.x;
    py = pitchy + st.y;
    
    mx = mx *px + e.rot.y *py;
    my = my *px + e.rot.x *-py;
    
    mx *= mx;
    my *= my;
    
    if(e.mode==0.0){
        mx/=e.sizesq.x;
        my/=e.sizesq.y;
        
    }
    else{
    mx-=e.sizesq.x;
    my-=e.sizesq.y;
        
    mx[0] = max(mx[0],0.0);
    mx[1] = max(mx[1],0.0);
    mx[2] = max(mx[2],0.0);
    
    my[0] = max(my[0],0.0);
    my[1] = max(my[1],0.0);
    my[2] = max(my[2],0.0);
    }
    
    mx += my;
    
    mx[0] = min(floor(mx[0]),1.0);
    mx[1] = min(floor(mx[1]),1.0);
    mx[2] = min(floor(mx[2]),1.0);

    return 1.0 - e.mult * vec3( 
          dot(mx[0],down),
          dot(mx[1],down),
          dot(mx[2],down) );
}


void main() {
    float mode; // 0.0 for eli 1.0 for rect
    mode = float(mod(u_time,2.0)>=1.0);
    vec2 st =gl_FragCoord.xy;
    
    elirect glyph = new_elirect(250.,250.,50.,30.,u_time,mode,1.0);
    
    vec3 bar = sample9(st,glyph);
    
    gl_FragColor = vec4(bar,1.00);
}
