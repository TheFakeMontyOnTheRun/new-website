AndroidTeapots
==============

In a parallel to what [I've done in the past for Cardboard](https://github.com/TheFakeMontyOnTheRun/adapting-OpenGLES2-sample-into-cardboard), using the simple Android sample for OpenGL ES 2, Rylie Pavlik has converted the [teapots](https://github.com/android/ndk-samples/tree/main/teapots) demo (from the NDK samples) to OpenXR. And a lot of credit goes to her: The Google sample is a big mess of shared dependencies and support scripts.

A small rant here: Google is really lousy when it comes to learning materials. The samples are always super robust and complicated - and while this reflects on desired skills for a programmer to learn, it also makes for a very daunting learning experience.

[AndroidTeapots](https://gitlab.freedesktop.org/monado/demos/androidteapots), was vert well factored and reasonably clear to read. And a miracle here! It's OpenGL ES only! Most examples for OpenXR these days tend to focus on Vulkan (which I'm not afraid of), making for a much more complicated base for a eventual new prototype.

Even with all this quality, there was a fatal issue: the view matrix was being computed upside down! And given that the example uses quaternions (which I could never really wrap my head around), I was really struggling to find a quick fix.

On a whim, the view matrix computation from [hello_xr](https://github.com/KhronosGroup/OpenXR-SDK-Source/tree/main/src/tests/hello_xr) has proven easier to lift and adapt. With a small update to the OpenXR SDK present in the repo, everything was working like charm. With that, a MR was submitted and merged.

![](images/teapot.png)