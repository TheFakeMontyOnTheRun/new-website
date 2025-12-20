# oclock

Taking a slight detour once again to look into oclock.

Last year, as I did a survey on UI toolkits for creating portable tools, I eventually settled on Athena (libXaw), since it was the common denominator of all the systems I had around me.

As I dug deeper for samples on how to use it, I started noticing that some of the X11 programs would run with very weird colours on Ubuntu. I really wanted to understand why, but eventually life got in the way.

Now, I'm finally back and selected one which I feel is the simplest one I could use to check this weird behaviour: oclock.

I and this odd behaviour is not exclusive to Ubuntu on amd64, but also noticed on both X11 and Wayland on RaspberryPi OS (Pi4):


It is, however, showing up quite normally under MacOS:

But what is causing it?

![](images/oclock-bad.png)

If I try running it from the command line, specifying the colours for the borders and background, the correct colours appear, 

![](images/oclock-good.png)

Turns out the code calls SetBackground and SetForeground with 0 and 1 - and this might result in unintended visuals.

Now, consider that XLogo also seem to have weird colours, but it is explicitly relying on the default background and foreground colours for the system; this means the author might have intended for the logo to "blend in" with the system. This doesn't seem to be the case with oclock.


## Conclusion

Oclock and other X11 programs are really ancient, but hold IMHO, a very important lesson in minimalism and functionality. You can have a very respectable X11 workstation with just a few megabytes of programs to serve you.

Unfortunately, it might assume certain aspects of the hardware that were true back when the program was written, but that became wrong over the years.

Mind you, xclock behaves much better and present the correct colours everywhere.

