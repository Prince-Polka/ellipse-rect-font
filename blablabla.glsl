// Author: Prince Polka
// Title: blablabla

#ifdef GL_ES
precision mediump float;
#endif

float elirect(vec2 st, mat3 e, float background){
    st = (vec3(st,1) * e).xy;
    
    float mode = e[2].y;
    
    float ret = mix(float( dot(st,st) < 1.0 ), // ellipse
               float( abs(st.x) < 1.0 && abs(st.y) < 1.0), // rect
               mode);
    float addsub = e[2].x;
    return mix(
        min(background,1.0-ret),
        max(background,ret),
        addsub);;
}

mat3 a[21];

mat3 new_eli(float cx,float cy, float rx, float ry, float a, float b, float c, float d, float addsub){
    
    float determinant = a * d - c * b;
    mat3 ret = mat3( d,-c, 0,
                    -b, a, 0,
                     0, 0, 0) / determinant;
    
    ret[0].z -= cx;
    ret[1].z -= cy;

    ret[0]/=rx;
    ret[1]/=ry;
    
    ret[2] = vec3(addsub,0,0);
    
    return ret;
}
mat3 new_rect(float cx,float cy, float rx, float ry, float a, float b, float c, float d, float addsub){
    
    float determinant = a * d - c * b;
    mat3 ret = mat3( d,-c, 0,
                    -b, a, 0,
                     0, 0, 0) / determinant;
    
    ret[0].z -= cx + rx*.5;
    ret[1].z -= cy + ry*.5;

    ret[0]/=rx*.5;
    ret[1]/=ry*.5;
    
    ret[2] = vec3(addsub,1.0,0);
    
    return ret;
}

void main() {
    vec2 st = gl_FragCoord.xy;
    
    st.y = 500.-st.y; // why is this needed? svg coordinate system is the same ?
    
a[0] = new_eli(71.2647,60.38826,13.04794,18.410017,1.0,0.0,0.0,1.0, 1.0); //add
a[1] = new_eli(50.2828,75.060036,17.14451,12.122665,0.9659317,-0.25879713,0.15135048,0.98848016,0.0); // sub
a[2] = new_eli(33.187256,93.021355,17.939568,15.685188,0.9408793,-0.338742,0.34884064,0.93718206, 1.0); // add
a[3] = new_eli(-70.25394,-64.52862,8.049047,3.4132562,0.20971779,-0.97776196,-0.99819337,-0.06008324, 1.0); // add
a[4] = new_eli(13.386086,-84.09805,10.080282,4.5451026,0.91987785,-0.39220497,-0.54096946,-0.84104223, 1.0); // add
a[5] = new_eli(42.61643,111.97088,4.4185677,5.328557,0.63787003,-0.77014403,0.2553418,0.96685085, 0.0); //sub
a[6] = new_eli(108.95916,-50.744713,7.4470477,6.3730893,0.39748503,0.91760866,-0.56638705,0.82413937, 0.0); // sub
a[7] = new_rect(62.385555,59.985596,21.93629,15.179836,1.0,0.0,0.0,1.0, 1.0); //add
a[8] = new_rect(64.54863,66.45616,11.783567,6.2556005,1.0,0.0,0.0,1.0, 0.0); // sub
a[9] = new_eli(-1.4153281,100.92607,10.768983,8.3511715,0.8646293,-0.50241036,0.65159074,0.7585707, 0.0); //sub
a[10] = new_eli(67.823746,107.32591,6.451519,13.598023,0.94812948,-0.31788439,0.18175331,0.98334416, 1.0); //add
a[11] = new_eli(182.43204,103.64643,16.006676,12.943449,0.30172771,0.95339414,0.34534512,-0.93847576, 0.0); //sub
a[12] = new_rect(76.76328,91.659294,18.842505,6.1471987,1.0,0.0,0.0,1.0, 0.0); //sub
a[13] = new_eli(54.38339,52.961555,16.888391,6.3014092,0.99577692,-0.09180593,0.13569767,0.99075029, 1.0); //add
a[14] = new_eli(26.167976,70.26772,9.284182,6.208097,0.98378405,-0.17935702,0.56902573,0.82231972, 0.0); //sub
a[15] = new_eli(59.797527,-73.26616,6.76419,6.821096,0.99675905,0.08044504,8.6588599e-4,-0.99999963, 0.0); //sub
a[16] = new_eli(26.092546,-84.93787,7.900486,3.4645555,0.96833671,-0.24964778,-0.43045568,-0.90261171, 0.0); //sub
a[17] = new_eli(-92.83819,76.53188,8.2668295,6.1394157,0.04369243,-0.99904503,0.972228,-0.23403573, 0.0); //sub
a[18] = new_eli(32.39888,-101.10135,9.147848,7.7123475,-0.93577986,0.35258481,-0.9153349,-0.40269345, 0.0); //sub
a[19] = new_eli(173.30899,-202.99057,5.0874796,5.45426,-0.83799693,0.54567495,-0.97687289,0.21382087, 0.0); //sub
a[20] = new_rect(41.131027,41.97464,8.074159,12.695303,1.0,0.0,0.0,1.0, 0.0); //sub
    
    float color = 0.0;
    
    for(int i=0;i<21;i++) color = elirect(st,a[i],color);

    gl_FragColor = vec4(vec3(color),1.0);
}
