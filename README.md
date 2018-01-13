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
  
I will share the .svg if I make any progress  

EDIT:  
new plan, ellipses and triangles rather than ellipses and rects  
anti alias will be 9 samples per pixel, (3 samples per channel)  
every glyph will be a struct of fixed number of ellipses and triangles, sufficent to draw complicated glyphs like ampersand '&'
simpler glyphs like whitespace ' ' may have to do the same work if branching is to be avoided  
What needs to be solved is how to provide random access to the glyph, texture lookup? 
