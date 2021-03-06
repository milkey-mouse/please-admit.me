---
title: Poor Man's Home Automation
image: /assets/watson-screenshot.png
description: DIY home automation on a $50 budget.
license: MIT
_grade: 5
---

From a very young age, I wished for a super-automated house, or at least room. I taped straws around the baseboards of the living room and pretended they were pneumatic tubes controlling the giant pistons that would turn our house into a Transformer. I tried to convince my mom to let me install a shop vac in the attic—an important prerequisite to a drive-through-bank-esque pneumatic tube system. I designed a Rube Goldberg-like series of tubes to deliver milk & cereal directly to my bedside with no concern for food safety whatsoever. And after having played Portal, I *really* wanted to make one of these articulated [Portal GLaDOS lamps](https://www.youtube.com/watch?v=ZGRRAB8Z1gc).

But 5th grade me had none of the tools, cash, or patience necessary for these projects, hence my project [Poor Man's Home Automation](https://hackaday.io/project/2142-poor-mans-home-automation). With a $50 budget I automated as many of the appliances in my room as possible, even going as far as to add new ones just so I could control them with my new system. I used as much existing hardware as I could: the main server was called [watson](https://github.com/milkey-mouse/watson)[^ibm] and ran on an old laptop. Aside from the computer, one of the of the main interfaces to the system was a somewhat whimsical array of CD drives, floppy drives, and SD card readers into which I could put different "scripts" the Watson engine would automatically execute. Watson also had (somewhat terrible) [CMU PocketSphinx](https://cmusphinx.github.io/)-based voice recognition before voice assistants were widespread (to put it in hipster terms, I had a digital assistant before it was cool). All of this was taped onto a wooden stool—bringing a whole new meaning to the term "computer tower".

{% include_cached image.html image="watson-computer.jpg" description="A spare laptop running the Watson software (well, the Windows lockscreen in the photo)." %}

{% include_cached image.html image="watson-tower.jpg" description="This 'tower' of a couple spare extenal hard drives, Arduinos, and a laptop powered the Watson system." %}

I [documented](https://hackaday.io/project/2142-poor-mans-home-automation) the project for the 2014 Hackaday Prize (the first one). I wrote [tutorials](https://github.com/milkey-mouse/watson/tree/master/instructions) on how to build each of the physical components (not that they're particularly replicable, or that one would want to build them how I had). I still regularly refer to the [graphic](https://github.com/milkey-mouse/watson/blob/master/instructions/blinds/wires.png) I made of a USB cable's pinout. I even printed out a daily summary (it was cheaper than a display; young me didn't understand the environmental implications :P) I made this video as part of my Hackaday Prize entry:

{% include_cached embed.html video_id="8iizb5JBA54" start=5 %}

I made an app for my Windows Phone[^wp] to control the systems in my room.

{% include_cached image.html image="watson-app.png" description="The Watson app for Windows Phone." %}

My solution to automatically open and close my blinds was a remote control car duct taped to my window...

{% include_cached image.html image="watson-blinds.jpg" description="The R/C car duct taped to my window..." %}

A fingerprint reader let me turn different devices on & off with different fingers. This was easier than buying and hooking up regular buttons.

{% include_cached image.html image="watson-fingerprint.jpg" description="A fingerprint reader lets me turn on & off different devices with different fingers." %}

The computer host for the software acted as an alarm clock, with extra data on everything from the school lunch of the day (for which I had to parse a terrible, hand-made PDF irregularly published on the Sodexo website) to the weather to the current amount of resources in Minecraft servers I frequented.

{% include_cached image.html image="watson-screenshot.png" description="Screenshot of the Watson software (acting as an alarm clock)." %}

[^ibm]: To any IBM intellectual property lawyers reading: please excuse 11-year-old me's (lack of) understanding of trademark law.
[^wp]: The Windows Phone was so great; that and the Zune were the only MS products I liked. I wish they were still around.
