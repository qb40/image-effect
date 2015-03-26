#qb-img-effect
**qb-img-effect** is a dos tool that can be used to create an animation out of an image.
It can used for displaying logo in dos games / software. Alternatively, it can be used to
add ui animations in dos. It uses `rrgggbbb` color palette format for displaying images,
and only 24-bit bitmap images are supported. The file format of `.eff` file is:

```vb
header {
  frames as integer
  xres   as integer
  yres   as integer
}
frame { color-value as xres * yres byte }
frame { color-value as xres * yres byte }
...
```


##demo

<img src="/assets/img/0.png" width="70%"><br/>
Start `eff-make.exe` to create an image effect.
<br/><br/>


<img src="/assets/img/1.png" width="70%"><br/>
`ball.bmp` is the 24-bit bitmap image.
<br/><br/>


<img src="/assets/img/2.png" width="70%"><br/>
`Bitmap file` is the image whose effect is required.<br/>
`Output file` is the resulting image effect file.<br/>
`Frames` determines the length of the animation.<br/>
`Method` tells the effect to be used.
<br/><br/>


<img src="/assets/img/3.png" width="70%"><br/>
<img src="/assets/img/4.png" width="70%"><br/>
<img src="/assets/img/5.png" width="70%"><br/>
*Dark to bright* effect is stored in `ball0.eff`.
<br/><br/>


<img src="/assets/img/6.png" width="70%"><br/>
*Bright to dark* effect of `ball.bmp`.
<br/><br/>


<img src="/assets/img/7.png" width="70%"><br/>
<img src="/assets/img/8.png" width="70%"><br/>
<img src="/assets/img/9.png" width="70%"><br/>
*Bright to dark* effect is stored in `ball1.eff`.
<br/><br/>


<img src="/assets/img/10.png" width="70%"><br/>
Start `eff-join.exe` to join two image effects.
<br/><br/>


<img src="/assets/img/11.png" width="70%"><br/>
`Img-effect file-1` is the first effect file.<br/>
`Img-effect file-2` is the second effect file.<br/>
`Output file` is the combined effect file.
<br/><br/>


<img src="/assets/img/12.png" width="70%"><br/>
<img src="/assets/img/13.png" width="70%"><br/>
<img src="/assets/img/14.png" width="70%"><br/>
<img src="/assets/img/15.png" width="70%"><br/>
`ball0.eff` and `ball1.eff` is joined to `ball.eff`.
<br/><br/>


<img src="/assets/img/16.png" width="70%"><br/>
Start `eff-play.exe` to view the combined animation.
<br/><br/>


<img src="/assets/img/17.png" width="70%"><br/>
`Img-effect file` is the file to be played.
<br/><br/>


<img src="/assets/img/17.png" width="70%"><br/>
`Img-effect file` is the file to be played.
<br/><br/>


<img src="/assets/img/18.png" width="70%"><br/>
<img src="/assets/img/19.png" width="70%"><br/>
<img src="/assets/img/20.png" width="70%"><br/>
<img src="/assets/img/21.png" width="70%"><br/>
*Dark to bright to dark* animation is seen.
<br/><br/>
