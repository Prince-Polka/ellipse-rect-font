// Author: Prince Polka
// Title: Bla bla bla

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
float elirect(vec2 st, mat3 e,float mode,float background){
    st = (vec3(st,1) * e).xy;
    
    float ret = mix(float( dot(st,st) < 1.0 ), // ellipse
               float( abs(st.x) < 1.0 && abs(st.y) < 1.0), // rect
               mode);
    float addsub = e[2].x;
    return mix(
        min(background,1.0-ret),
        max(background,ret),
        addsub);;
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
/* inver() from Processing.org, originally OpenJDK */
mat3 invert(mat3 m) {
    float determinant = m[0][0] * m[1][1] - m[0][1] * m[1][0];

    float t00 = m[0][0];
    float t01 = m[0][1];
    float t02 = m[0][2];
    float t10 = m[1][0];
    float t11 = m[1][1];
    float t12 = m[1][2];
                     
    return mat3(t11,-t01,t01 * t12 - t11 * t02,
                -t10,t00,t10 * t02 - t00 * t12,
                0,0,0) / determinant;
  }



mat3 a[21];


mat3 new_eli(float cx,float cy, float rx, float ry, float a, float b, float c, float d, float addsub){

    mat3 ret = identity;
    
    mat3 transform = mat3(a,c,0,
                          b,d,0,
                          0,0,0);
    
    ret *= invert(transform);
    
    ret = translate(ret,vec2(cx,cy));
    
    ret = scale(ret,vec2(rx,ry));
    
    ret[2].x = addsub;
    return ret;
}

void main() {
    vec2 st = gl_FragCoord.xy;
    
    st.y = 500.-st.y; // why is this needed? svg coordinate system is the same ,  aso why 650 ?
    
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
    /*a[0] = new_eli(350.08215,261.56686,31.27211,50.04192,0.95567154,0.29443489,-0.51154064,0.85925909);
    a[1] = new_eli(494.43402,-163.34969,38.43088,70.31166,0.45470679,0.89064119,-0.61182571,0.79099261);
    a[2] = new_eli(496.03284,-38.80541,43.829727,39.53645,0.32702,0.94501742,-0.96404292,0.26574658);
    a[3] = new_eli(-210.9732,-693.8616,27.460346,56.968483,-0.38146552,0.92438307,-0.3482411,-0.937405);*/
    
a[0] = new_eli(71.2647,60.38826,13.04794,18.410017,1.0,0.0,0.0,1.0, 1.0); //add
a[1] = new_eli(50.2828,75.060036,17.14451,12.122665,0.9659317,-0.25879713,0.15135048,0.98848016,0.0); // sub
a[2] = new_eli(33.187256,93.021355,17.939568,15.685188,0.9408793,-0.338742,0.34884064,0.93718206, 1.0); // add
a[3] = new_eli(-70.25394,-64.52862,8.049047,3.4132562,0.20971779,-0.97776196,-0.99819337,-0.06008324, 1.0); // add
a[4] = new_eli(13.386086,-84.09805,10.080282,4.5451026,0.91987785,-0.39220497,-0.54096946,-0.84104223, 1.0); // add
a[5] = new_eli(42.61643,111.97088,4.4185677,5.328557,0.63787003,-0.77014403,0.2553418,0.96685085, 0.0); //sub
a[6] = new_eli(108.95916,-50.744713,7.4470477,6.3730893,0.39748503,0.91760866,-0.56638705,0.82413937, 0.0); // sub
//a[7] = new_rect(62.385555,59.985596,21.93629,15.179836,1.0,0.0,0.0,1.0, 1.0); //add
//a[8] = new_rect(64.54863,66.45616,11.783567,6.2556005,1.0,0.0,0.0,1.0, 0.0); // sub
a[9] = new_eli(-1.4153281,100.92607,10.768983,8.3511715,0.8646293,-0.50241036,0.65159074,0.7585707, 0.0); //sub
a[10] = new_eli(67.823746,107.32591,6.451519,13.598023,0.94812948,-0.31788439,0.18175331,0.98334416, 1.0); //add
a[11] = new_eli(182.43204,103.64643,16.006676,12.943449,0.30172771,0.95339414,0.34534512,-0.93847576, 0.0); //sub
//a[12] = new_rect(76.76328,91.659294,18.842505,6.1471987,1.0,0.0,0.0,1.0, 0.0); //sub
a[13] = new_eli(54.38339,52.961555,16.888391,6.3014092,0.99577692,-0.09180593,0.13569767,0.99075029, 1.0); //add
a[14] = new_eli(26.167976,70.26772,9.284182,6.208097,0.98378405,-0.17935702,0.56902573,0.82231972, 0.0); //sub
a[15] = new_eli(59.797527,-73.26616,6.76419,6.821096,0.99675905,0.08044504,8.6588599e-4,-0.99999963, 0.0); //sub
a[16] = new_eli(26.092546,-84.93787,7.900486,3.4645555,0.96833671,-0.24964778,-0.43045568,-0.90261171, 0.0); //sub
a[17] = new_eli(-92.83819,76.53188,8.2668295,6.1394157,0.04369243,-0.99904503,0.972228,-0.23403573, 0.0); //sub
a[18] = new_eli(32.39888,-101.10135,9.147848,7.7123475,-0.93577986,0.35258481,-0.9153349,-0.40269345, 0.0); //sub
a[19] = new_eli(173.30899,-202.99057,5.0874796,5.45426,-0.83799693,0.54567495,-0.97687289,0.21382087, 0.0); //sub
//a[20] = new_rect(41.131027,41.97464,8.074159,12.695303,1.0,0.0,0.0,1.0, 0.0); //sub
    a[7] = a[8] = a[12] = a[20] 
        //= a[18] = a[19] = a[11]
        
        = new_eli(10.,10.,10.,10.,1.,0.0,0.0,1.,1.);
    
    
    float color = 0.0;
    
    for(int i=0;i<21;i++)
        color = elirect(st,a[i],0.0,color);

    gl_FragColor = vec4(vec3(color),1.0);
}
