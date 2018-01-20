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
    
    return mix(float( dot(st,st) < 1.0 ), // ellipse
               float( abs(st.x) < 1.0 && abs(st.y) < 1.0), // rect
               mode);
}

mat3 identity = mat3(1,0,0,
                     0,1,0,
                     0,0,1);

mat3 scale(mat3 m,vec2 s){
    return mat3(m[0] / s.x,
                m[1] / s.y,
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

mat3 a[4];

mat3 new_eli(float cx,float cy, float rx, float ry, float a, float b, float c, float d){

    mat3 ret = identity;
    
    mat3 transform = mat3(a,c,0,
                          b,d,0,
                          0,0,0);
    
    ret = translate(ret,vec2(cx,cy));
    
    ret = scale(ret,vec2(rx,ry));
    
    ret *= transform;
    
    return ret;
}

void main() {
    vec2 st = gl_FragCoord.xy;
    //float mode = float(mod(u_time,2.0)<1.0);
    /*
    mat3 transform = identity;
    transform = translate(transform,vec2(250.0,250.0));
    transform = rotate(transform,u_time);
    transform = scale(transform,vec2(100.0,200.0)); 
    transform = skew(transform,u_mouse*0.001);
    float color = elirect(st,transform,0.0);
    */
/*
<ellipse
cx="350.08215"
cy="261.56686"
rx="31.27211"
ry="50.04192"
transform="matrix(0.95567154,0.29443489,-0.51154064,0.85925909,0,0)"
/>
<ellipse
cx="494.43402"
cy="-163.34969"
rx="38.430882"
ry="70.311661"
transform="matrix(0.45470679,0.89064119,-0.61182571,0.79099261,0,0)"
/>
<ellipse
cx="496.03284"
cy="-38.805408"
rx="43.829727"
ry="39.536449"
transform="matrix(0.32702,0.94501742,-0.96404292,0.26574658,0,0)"
/>
<ellipse
cx="-210.97321"
cy="-693.86157"
rx="27.460346"
ry="56.968483"
transform="matrix(-0.38146552,0.92438307,-0.3482411,-0.937405,0,0)"
/>
*/
    a[0] = new_eli(350.08215,261.56686,31.27211,50.04192,0.95567154,0.29443489,-0.51154064,0.85925909);
    a[1] = new_eli(494.43402,-163.34969,38.43088,70.31166,0.45470679,0.89064119,-0.61182571,0.79099261);
    a[2] = new_eli(496.03284,-38.80541,43.829727,39.53645,0.32702,0.94501742,-0.96404292,0.26574658);
    a[3] = new_eli(-210.9732,-693.8616,27.460346,56.968483,-0.38146552,0.92438307,-0.3482411,-0.937405);
    
    
    float color = 0.0;
    color += elirect(st,a[0],0.0);
    color += elirect(st,a[1],0.0);
    color += elirect(st,a[2],0.0);
    color += elirect(st,a[3],0.0);

    gl_FragColor = vec4(vec3(color),1.0);
}
