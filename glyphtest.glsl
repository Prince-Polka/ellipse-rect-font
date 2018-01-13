// Author: Prince Polka
// Title: triglyph

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

struct tri{vec3 s; vec3 t;float A;};
tri tris[2];

/* shader should not make triangles this way, they should be made from memory*/
tri new_triangle(vec2 p0, vec2 p1, vec2 p2){
    tri ret;
    ret.s = vec3(p0.y * p2.x - p0.x * p2.y, p2.y - p0.y , p0.x - p2.x );
    ret.t = vec3(p0.x * p1.y - p0.y * p1.x, p0.y - p1.y , p1.x - p0.x );
    ret.A = -p1.y * p2.x + p0.y * (p2.x - p1.x) + p0.x * (p1.y - p2.y) + p1.x * p2.y;
    if (ret.A < 0.0) {
        ret.s = -ret.s;
        ret.t = -ret.t;
        ret.A = -ret.A;
    }
    return ret;
}

vec3 glyph(){
    mat3 sample;
    vec2 base = mod(gl_FragCoord.xy,vec2(15,20)); // width and height of "glyph box"
    for(int i=0;i<3;i++)
        for(int j=0;j<3;j++){
            vec3 pitch = vec3(1,base+(vec2(i,j)-1.0)*0.333);
            for(int k=0;k<2;k++){
            float s = dot(tris[k].s,pitch);
            float t = dot(tris[k].t,pitch);
            sample[i][j] += float( s> 0.0 && t > 0.0 && (s + t) <= tris[k].A);
            }
            //for(int k=0;k<2;k++)
            //repeat for elis
        }
    
    vec3 down = vec3(0.333);
    return clamp(vec3( 
        dot(sample[0],down),
        dot(sample[1],down),
        dot(sample[2],down) 
    ),vec3(0),vec3(1));
}

void main() {
    tris[0] = new_triangle(vec2(0.,0.),vec2(10.,10.),vec2(0.,10.));
    tris[1] = new_triangle(vec2(0.,0.),vec2(10.,10.),vec2(10.,0.));
    
    gl_FragColor = vec4(glyph(),1.00);
}
