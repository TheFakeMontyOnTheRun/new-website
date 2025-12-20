# src/demos/reflect.c

Jumping ahead because I had some issues building this for MacOS.
This resulted in a brew invocation that took me *hours* to run - and eventually failed!

As for the demo itself: there's a lot of code for handling windows and such. A lot of "flexibility" for what is simply supposed to be a one-off demo. Turns out it supports creating multiple windows, which is very usefult o visualize how the effect is achieved, but rendering each of the buffers.

In regards to the graphics stuff, it's a really nice classical effect that would have blown me away in the 90's.

And how it's achieved? Aside from the usual stuff, like display lists, textures and matrix stacks, the trick is that it first draws the table to the stencil buffer, only to then render again the table with blending enabled (this time, with the colour buffer rendering enabled).

Note that the reflection and the real objects are actually the rendering of the objects called twice (but horizontally flipped).

## Conclusion

This is an old trick to achieve this effect. I was familiar with the general idea, but not on how to achieve this on OpenGL (or at least on classic OpenGL). I suspect that this might be cleaner to be achieved in modern GL or Vulkan - but a bit messier on an uber shader.