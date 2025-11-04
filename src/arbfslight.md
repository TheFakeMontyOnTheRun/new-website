# src/demos/arbfslight.c

Very basic, but interesting demo.
To someone who deals primarily with GL ES 2, with a past on GL 1.2, it is very readable.
In fact, other than a few state manipulations regarding the matrices, this demo could very easily be converted to GL ES 2 or GL 3 Core Profile.

Honestly, the code is very straightforward and there’s very little to mention, other than how it’s funny that the switch between per-vertex lightning and per-pixel lightning is done by turning on and off the pixel shader program, and then enabling or disabling the default lightning.

The only caveat is that I haven't touched much on GLUT, preferring SDL or the native APIs for the OSes. But GLUT is simple enough for one to get their feet wet (with only the scalability of the code being a possible factor to consider)

## Conclusion:

This demo still illustrates a valid style, when compared to older GL code you see floating around, with the shader extensions being quite well supported in today's hardware.
