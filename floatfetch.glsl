/* 
Prince Polka
In shader, index expression must be constant (or a loop index)
To get random access to float data can't use a float array
Textures can be sampled arbitrarily but returns normalized vec4()'s
This is a workaround for that issue 
*/

uniform sampler2D u_array;

float floatFetch(ivec2 index){
    vec4 temp = texelFetch(u_array,index,0);

    ivec4 tempi = ivec4(temp * 255.0);
    
    int intbits = 
    (tempi.a << 24) | 
    (tempi.r << 16) |
    (tempi.g <<  8) |
     tempi.b;

    return intBitsToFloat(intbits);
}
