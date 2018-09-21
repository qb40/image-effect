**imageeffect** is a dos tool that can be used to create an animation out of an image.
It can used for displaying logo in dos games / software. Alternatively, it can be used to
add ui animations in dos. It uses `rrgggbbb` color palette format for displaying images,
and only 24-bit bitmap images are supported. The file format of `.eff` file is:

```vb
header {
  frames as integer
  xres   as integer
  yres   as integer
}
frame { color-value as xres*yres byte }
frame { color-value as xres*yres byte }
...
```


## demo

<img src="https://raw.githubusercontent.com/qb40/imageeffect/gh-pages/0/image/0.png"><br/>
Start `eff-make.exe` to create an image effect.
<br/><br/>


<img src="https://raw.githubusercontent.com/qb40/imageeffect/gh-pages/0/image/1.png"><br/>
`ball.bmp` is the 24-bit bitmap image.
<br/><br/>


<img src="https://raw.githubusercontent.com/qb40/imageeffect/gh-pages/0/image/2.png"><br/>
`Bitmap file` is the image whose effect is required.<br/>
`Output file` is the resulting image effect file.<br/>
`Frames` determines the length of the animation.<br/>
`Method` tells the effect to be used.
<br/><br/>


<img src="https://raw.githubusercontent.com/qb40/imageeffect/gh-pages/0/image/3.png"><br/>
<img src="https://raw.githubusercontent.com/qb40/imageeffect/gh-pages/0/image/4.png"><br/>
<img src="https://raw.githubusercontent.com/qb40/imageeffect/gh-pages/0/image/5.png"><br/>
*Dark to bright* effect is stored in `ball0.eff`.
<br/><br/>


<img src="https://raw.githubusercontent.com/qb40/imageeffect/gh-pages/0/image/6.png"><br/>
*Bright to dark* effect of `ball.bmp`.
<br/><br/>


<img src="https://raw.githubusercontent.com/qb40/imageeffect/gh-pages/0/image/7.png"><br/>
<img src="https://raw.githubusercontent.com/qb40/imageeffect/gh-pages/0/image/8.png"><br/>
<img src="https://raw.githubusercontent.com/qb40/imageeffect/gh-pages/0/image/9.png"><br/>
*Bright to dark* effect is stored in `ball1.eff`.
<br/><br/>


<img src="https://raw.githubusercontent.com/qb40/imageeffect/gh-pages/0/image/10.png"><br/>
Start `eff-join.exe` to join two image effects.
<br/><br/>


<img src="https://raw.githubusercontent.com/qb40/imageeffect/gh-pages/0/image/11.png"><br/>
`Img-effect file-1` is the first effect file.<br/>
`Img-effect file-2` is the second effect file.<br/>
`Output file` is the combined effect file.
<br/><br/>


<img src="https://raw.githubusercontent.com/qb40/imageeffect/gh-pages/0/image/12.png"><br/>
<img src="https://raw.githubusercontent.com/qb40/imageeffect/gh-pages/0/image/13.png"><br/>
<img src="https://raw.githubusercontent.com/qb40/imageeffect/gh-pages/0/image/14.png"><br/>
<img src="https://raw.githubusercontent.com/qb40/imageeffect/gh-pages/0/image/15.png"><br/>
`ball0.eff` and `ball1.eff` is joined to `ball.eff`.
<br/><br/>


<img src="https://raw.githubusercontent.com/qb40/imageeffect/gh-pages/0/image/16.png"><br/>
Start `eff-play.exe` to view the combined animation.
<br/><br/>


<img src="https://raw.githubusercontent.com/qb40/imageeffect/gh-pages/0/image/17.png"><br/>
`Img-effect file` is the file to be played.
<br/><br/>


<img src="https://raw.githubusercontent.com/qb40/imageeffect/gh-pages/0/image/17.png"><br/>
`Img-effect file` is the file to be played.
<br/><br/>


<img src="https://raw.githubusercontent.com/qb40/imageeffect/gh-pages/0/image/18.png"><br/>
<img src="https://raw.githubusercontent.com/qb40/imageeffect/gh-pages/0/image/19.png"><br/>
<img src="https://raw.githubusercontent.com/qb40/imageeffect/gh-pages/0/image/20.png"><br/>
<img src="https://raw.githubusercontent.com/qb40/imageeffect/gh-pages/0/image/21.png"><br/>
*Dark to bright to dark* animation is seen.
<br/><br/>


[![qb40](https://i.imgur.com/xAWLn0I.jpg)](https://qb40.github.io)
