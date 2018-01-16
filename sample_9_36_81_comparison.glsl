// Author: Prince Polka
// Title: sampe 9 36 81 comparison

/*
9 samples should be fastest, and smooth enough for large text
for small text it may become a bit "crispy"

36 samples makes it a little smoother

81 samples doesn't add much smoothness over 36
*/

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
#define SQRT2 1.414213562
#define THIRD 0.33333334
#define NINTH 0.11111111
#define SIXTH 0.16666667

const vec3 down = vec3(THIRD,THIRD,THIRD);

const mat3 pitchx = mat3(-THIRD,-THIRD,-THIRD,0.0,0.0,0.0,THIRD,THIRD,THIRD);
const mat3 pitchy = mat3(-THIRD,0.0,THIRD,-THIRD,0.0,THIRD,-THIRD,0.0,THIRD); 


struct elirect{
  vec2 centre; // centre of ellipse / rectangle
  vec2 sizesq; // width height squared, and multiplied by 0.5 don't know why 0.5 but it works
  vec2 rot; // sin(angle)*sqrt(2) , cos(angle)*sqrt(2) 
  float mode; // 0.0 for eli, 1.0 for rect
  float mult; // 1 add to glyph, or -1 remove from glyph
};

elirect new_elirect(float centerx, float centery, float width, float height, float angle, float mode, float mult){
    elirect ret;
    ret.centre = vec2(centerx,centery);
    ret.sizesq = vec2(width*width*0.5,height*height*0.5);
    ret.rot = vec2(cos(angle),sin(angle))*SQRT2;
    ret.mode = mode; // 0.0 for eli 1.0 for rect
    ret.mult = mult;
    return ret;
}
/* 9 samples seems too few for small fonts, 81 looks better but may be too many when drawing many elirects will see if 27 works */
vec3 sample81(vec2 st, elirect e){
    vec3 ret;
    st -= e.centre;
    for(int c=0;c<3;c++){
        float temp = 0.0;
    for(int x=0;x<3;x++)
        for(int y=0;y<9;y++){
            vec2 sample = st + (vec2(c*3+x,y)-4.0)*NINTH;
            vec2 samplerot = e.rot * sample.x + e.rot.yx * vec2(sample.y,-sample.y);
            samplerot *= samplerot;
            vec2 mode = max ( mix( samplerot/e.sizesq, samplerot-e.sizesq, e.mode ), 0.0 );
            temp += clamp(floor( dot( mode ,vec2(1) ) ),0.0,1.0);
        }
        ret[c]=temp;
    }
    return ret/27.0;
}

vec3 sample9(vec2 st, elirect e){
    st -= e.centre;
    
    e.sizesq*=3.0;
    
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

    return  e.mult * vec3( 
          dot(mx[0],down),
          dot(mx[1],down),
          dot(mx[2],down) );
    
}

vec3 sample36(vec2 st, elirect e){
    vec3 ret;
    st -= e.centre;
    for(int c=0;c<3;c++){
        float temp = 0.0;
    for(int x=0;x<2;x++)
        for(int y=0;y<6;y++){
            vec2 sample = st + (vec2(c+c+x,y)-3.0)*SIXTH;
            vec2 samplerot = e.rot * sample.x + e.rot.yx * vec2(sample.y,-sample.y);
            samplerot *= samplerot;
            vec2 mode = max ( mix( samplerot/e.sizesq, samplerot-e.sizesq, e.mode ), 0.0 );
            temp += clamp(floor( dot( mode ,vec2(1) ) ),0.0,1.0);
        }
        ret[c]=temp;
    }
    return ret/12.00;
}

void main() {
    float mode; // 0.0 for eli 1.0 for rect
    mode = float(mod(u_time,2.0)>=1.0);
    vec2 st = mod(gl_FragCoord.xy,vec2(167,500));
    
    elirect glyph = new_elirect(84.,250.,30.,50.,u_time,mode,1.0);
    
    vec3 bar;
    if(gl_FragCoord.x < 167.0) 
        bar = sample9(st,glyph);
    else if(gl_FragCoord.x < 167.0*2.) 
        bar = sample36(st,glyph);
    
    else bar = sample81(st,glyph);
    
    gl_FragColor = vec4(bar,1.00);
}
