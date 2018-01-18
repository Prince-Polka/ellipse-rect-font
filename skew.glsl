// Author: Prince Polka
// Title: lowercase 'a'
// to draw the ellipses and rects from inkscape , rotate is not enough, it also needs skew
// i have not implemented skew 

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
  mat2 transform; // sin(angle)*sqrt(2) , cos(angle)*sqrt(2)
  float mode; // 0.0 for eli, 1.0 for rect
  float addsub; // 0.0 to add to glyp 1.0 to subtract from glyph
};

elirect new_eli(float cx , float cy, float rx, float ry, 
                float a, float b, float c, float d, 
                float addsub){
    elirect ret;
    
    rx*=2.0;
    ry*=2.0;
    ret.sizesq = vec2(rx*rx,ry*ry)*0.25;
    ret.transform = mat2(a,c,
                         b,d);
    /* svg transformation matrix
    [a][c][e]
    [b][d][f]
    [0][0][1] 
    */
    ret.centre = vec2(cx,cy) * ret.transform;
    ret.centre.y = 500.0 - ret.centre.y;
    ret.mode = 0.0;
    ret.addsub = addsub;
    return ret;
}
elirect new_rect(float x , float y, float width, float height, 
                 float a, float b, float c, float d, 
                 float addsub){
    elirect ret;
    ret.sizesq = vec2(width*width,height*height);
    ret.transform = mat2(a,c,
                         b,d);
    ret.centre = vec2(x,y) * ret.transform; // svg xy is top left corner not center !!!
    ret.centre.y = 500.0 - ret.centre.y;
    ret.mode = 1.0;
    ret.addsub = addsub;
    return ret;
}

float pointinelirect(vec2 st,float background, elirect e){
    /* rotation same for both modes */
    st -= e.centre;
    
    vec2 erot = st * e.transform;
    erot *= erot;
    
    /* for eli e.rot / e.sizesq , for rect e.rot / e.sizesq */
    vec2 mode = clamp ( mix( erot/e.sizesq, erot-e.sizesq, e.mode ), 0.0 , 1.0);
    
    /* end part same for both modes */
    float ret = 1.0 - float( dot( mode ,vec2(1) ) >= 1.0 );
    
    return mix(
        min(background,1.0-ret),
        max(background,ret),
        e.addsub);
}
elirect a[21];

void main() {
/*a[0] = new_eli(250.,250.,500.,100.,
               1.0,0.0,0.0,1.0,
               1.0); // add*/

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
    a[7] = a[8] = a[12] = a[20] = 
        a[18] = a[19] = a[11]
        
        = new_eli(10.,10.,10.,10.,1.,0.0,0.0,1.,1.);
    
    float mode; // 0.0 for eli 1.0 for rect
    vec2 st = gl_FragCoord.xy;
    
    float color = 0.0;
    
    for(int i=0;i<21;i++)
    color = pointinelirect(st,color,a[i]);
    
    gl_FragColor = vec4(vec3(color),1.00);
}
