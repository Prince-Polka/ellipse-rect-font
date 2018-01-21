# ellipse-rectangle-font
Just an idea for a different approach to font rendering.

Standard font-rendering finds intercections between an infinite horizontal line and the outlines of glyps, row by row.  
Then for every pixel count the number of intersections.x < pixel.X  
If that number is odd then the pixel is inside a glyph.  

My idea is using ellipses/rectanges rather than outlines.   
The plan is to make ONE custom font,mono-spaced, one wieght, just ASCII-characters, in inkscape,
then turn the drawing into a custom file format.  

The plan is NOT to read outlines from .ttf .otf files etc, converting them into ellipses and rects as I have no idea how to do that.   
  
GLSL code , just an example
  
http://thebookofshaders.com/edit.php?log=170904133835  
  
Inkscape screenshot  
![example](https://raw.githubusercontent.com/Prince-Polka/ellipse-rect-font/master/ellipse%20rect%20font.png)  

I have been working on this some more and created a mess of experiment files.  
Some progress though, ellipses of lowercase 'a' fetched from an inkscape .svg  

Output of blablabla.glsl file;

![lowercasea](https://raw.githubusercontent.com/Prince-Polka/ellipse-rect-font/master/lowercasea.png)  

it needs a few rectangles aswell, but it looks the same as in inkscape  

This is all that's necessary to determine wheter a point is inside a translated, rotated, skewed and scaled ellipse
```glsl
bool eli(vec2 st, mat3 e){
    st = (vec3(st,1) * e).xy;
    return dot(st,st) < 1.0;
}```

However one must first generate that matrix from svg data  
I used a processing.org sketch to read the .svg as xml 
The conversion math should also be done on cpu as it's not a per-pixel thing.
But it's done in the shader for now.
