// Author: Prince Polka
// Title: ellipse

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
#define SQRT2 1.414213562
#define THIRD 0.33333334

const vec3 down = vec3(THIRD,THIRD,THIRD);

const mat3 pitchx = mat3(-THIRD,-THIRD,-THIRD,0.0,0.0,0.0,THIRD,THIRD,THIRD);
const mat3 pitchy = mat3(-THIRD,0.0,THIRD,-THIRD,0.0,THIRD,-THIRD,0.0,THIRD); 


struct elirect{
  vec2 centre; // centre of ellipse / rectangle
  vec2 sizesq; // width height squared, and multiplied by 1.5 don't know why 1.5 but it works
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
    
    mat3 sx,sy,px,py;
    
    sx = mat3(e.rot.x);
    sy = mat3(e.rot.y);
    px = st.x + pitchx;
    py = st.y + pitchy;
    
    sx = sx *px + e.rot.y *py;
    sy = sy *px + e.rot.x *-py;
    
    sx *= sx;
    sy *= sy;
    /*
    if(e.mode==0.0){
        sx/=e.sizesq.x;
        sy/=e.sizesq.y;
    }
    else{
        sx-=e.sizesq.x;
        sy-=e.sizesq.y;
    }
    */
    
    /*bool bmode = bool(e.mode);
    
    sx = bmode ? sx - e.sizesq.x : sx / e.sizesq.x;
    sy = bmode ? sy - e.sizesq.y : sy / e.sizesq.y;*/
    
    vec2 div = mix(e.sizesq,vec2(1),e.mode);
    vec2 sub = mix(vec2(0),e.sizesq,e.mode);
    
    sx = sx / div.x - sub.x;
    sy = sy / div.y - sub.y;

    //sx = sx / mix(e.sizesq.x,1.0,e.mode) - mix(0.0,e.sizesq.x,e.mode);
    //sy = sy / mix(e.sizesq.y,1.0,e.mode) - mix(0.0,e.sizesq.y,e.mode);
    
    
    //if(e.mode == 1.0){
    // only necessary for rect but does not ruin  ellipse
    sx[0] = max(sx[0],0.0);
    sx[1] = max(sx[1],0.0);
    sx[2] = max(sx[2],0.0);
    
    sy[0] = max(sy[0],0.0);
    sy[1] = max(sy[1],0.0);
    sy[2] = max(sy[2],0.0);
    //}
    
    sx +=sy; // this should be done for both modes
    
    //if(e.mode == 0.0){
    // only necessary for ellipse but does not ruin rect
    sx[0] = min(floor(sx[0]),1.0);
    sx[1] = min(floor(sx[1]),1.0);
    sx[2] = min(floor(sx[2]),1.0);
    //}

    return  e.mult * vec3( 
          dot(sx[0],down),
          dot(sx[1],down),
          dot(sx[2],down) );
}


void main() {
    float mode; // 0.0 for eli 1.0 for rect
    mode = float(mod(u_time,2.0)>=1.0);
    vec2 st = mod(gl_FragCoord.xy,vec2(500,500));
    
    elirect glyph = new_elirect(250.,250.,10.,5.,u_time,mode,1.0);
    
    vec3 bar = sample9(st,glyph);
    
    gl_FragColor = vec4(bar,1.00);
}
