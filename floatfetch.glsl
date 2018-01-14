/* 
Prince Polka
In shader, index expression must be constant (or a loop index)
To get random access to float data can't use a float array
Textures can be sampled arbitrarily but returns normalized vec4()'s
This is a workaround for that issue 

Tested in processing.org loading a java float[][] to the shader like so; 
    
void setfloatarray(PShader target, String sampler2Dname, float[][] source){
    int cols,rows;
    cols = source.length;
    rows = source[0].length;
    PImage array = createImage(rows,cols,ARGB);
    
    for(int i=0,c=0;c<cols;c++)
    for(int     r=0;r<rows;r++)
    array.pixels[i++] = Float.floatToIntBits( source[c][r] );
    
    target.set(sampler2Dname,array); 
}
    
The components for inbits = ... ; may or may not have to be shuffled on other platforms
*/

// uniform sampler2D u_sampler_array;
// uniform float u_real_array[10][10];

float floatFetch(sampler2D sampler, int y_index , int x_index){
    ivec4 temp = ivec4(texelFetch(sampler,ivec2(x_index,y_index),0) * 255.0);
    
    int intbits = 
    (temp.a << 24) | 
    (temp.r << 16) |
    (temp.g <<  8) |
     temp.b;

    return intBitsToFloat(intbits);
}

// float somethingA  = u_real_array[7][5]; // this works as long as '7' and '5' are constants
// float somethingB  = floatFetch(u_sampler_array,7,5); // this works the same, and '7' '5' can be variables
