// Author: Prince Polka
// Title: Back to Basics

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

/*
multiplying the fragcoord to a transformation matrix should be
sufficent to draw an arbitrary elippse or rectangle
mat3x2 should be enough but as it's not supported on this editor hence mat3 in this test

the inkscape generated svg for ellipse looks like so
<ellipse
       style="bla bla bla"
       id="bla bla bla"
       cx="float" centre x
       cy="float" centre y
       rx="float" radius x
       ry="float" radius y
       
       transform="matrix(float,float,float,float,float,float)" 
/>

cx,cy is the position BEFORE transformation

transform may be omitted or use rotate(float) instead of matrix(float...)  
but let's assume transform is used and let's call the six floats a,b,c,d,e,f

that corresponds to a mat3x2(a,c,e,
                             b,d,f)
                             
e and f (transformation) seems to always be 0 
also the matrix genteretad seems to NOT scale the shape

transformation happens around the 0,0 of document not center of shape, 
after transformation 

<rect
       style="bla bla bla"
       id="bla bla bla"
       width="float" 
       height="float" full size not half as in ellipse
       x="float" 
       y="float" corner not center
       
       transform , see above
/>

*/
float elirect(vec2 st, mat3 e,float mode){
    st = (vec3(st,1) * e).xy;
    
    return mix(float( dot(st,st) < 1.0), // ellipse
               float( abs(st.x) < 1.0 && abs(st.y) < 1.0), // rect
               mode);
}

mat3 identity = mat3(1,0,0,
                         0,1,0,
                         0,0,1);

mat3 scale(mat3 m,vec2 s){
    return mat3(m[0]/s.x,
                m[1]/s.y,
                0,0,0);
}
mat3 translate(mat3 m,vec2 t){
    m[0].z -= t.x;
    m[1].z -= t.y;
    return m;
}

mat3 rotate(mat3 m,float a){
    return m * mat3(
        cos(a),sin(a),0,
        -sin(a),cos(a),0,
        0,0,1
    ); 
}

mat3 skew(mat3 m,vec2 sk){
    return m * mat3(
        1,tan(sk.y),0,
        tan(sk.x),1,0,
        0,0,1
    ); 
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    st.x *= u_resolution.x/u_resolution.y;
    
    float mode = float(mod(u_time,2.0)<1.0);
    
    mat3 transform = identity;
    
    transform = translate(transform,vec2(0.5,0.5));
    transform = rotate(transform,u_time);
    transform = scale(transform,vec2(0.15,0.25)); 
    transform = skew(transform,u_mouse*0.001);
    
    float color = elirect(st,transform,mode);

    gl_FragColor = vec4(vec3(color),1.0);
}
