# src/demos/arbocclude.c

Now we're getting into the juicy parts! For the last 25+ years I've been doing OpenGL, my data was always flowing from the main memory and into the rendering pipeline, but never in the other direction. This is a real learning opportunity for me!


Some variable names are not all that clear, TBH. But once you run the program, everything becomes clearer.

The demo is deeply rooted in old style OpenGL, but there might be modern equivalents. Gonna read the docs to see if there is any recommendation.

For some of the functions, there seems to be no dedicated documentation page.

And sadly, the Apple documentation links poison the search results, since they seem to have removed the pages.

From the search results, I also get info that this operation might be slow (reinforcing the common notion that this direction flow always pays some penalties).
It is possible, however, to query if the result is ready before trying to query it in full, to avoid bottlenecks; as the code illustrates.

## Conclusion

Gotta admit - I never heard of glRasterPos3f! Oh, ok - it's only for printing text.

As for the ARB extension, there's now an official equivalent, without the ARB suffixes.
