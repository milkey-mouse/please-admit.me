---
title: Brain-Controlled Legend of Adlez
image: /assets/mindflex-irl.jpg
description: A hacked EEG headset slows down time ingame when the user concentrates.
featured: true
published: false
---

In 6th grade, a science teacher let me borrow a mysterious headset from a previous student. I soon found out it was a [MindFlex](https://store.neurosky.com/products/mindflex) toy, with a [NeuroSky](http://neurosky.com/) EEG module inside. Even though the toy [kind](https://www.amazon.com/product-reviews/B004GHNFKK?filterByStar=two_star) [of](https://www.spiegel.de/spiegel/a-679480.html) [sucked](https://www.spiegel.de/wissenschaft/technik/hirnsteuerungs-studie-wenn-der-ball-nicht-macht-was-der-kopf-will-a-761169.html), the headset part was still interesting for its "mind-reading" capabilities.

After probing an aftermarket headphone jack on the side of the headset, I figured out the student who bought the headset had already soldered connections to the EEG module. I crammed an Arduino and all the other requisite hardware into a Tic Tac box and the rest is software.

Before the [release](./2015-06-24-the-legend-of-adlez.md) of The Legend of Adlez, I was experimenting with the TODO

Rather sensationally, I called this "mind control." Technically it *is* control *by* minds. 🤷

Mirrored from [the original post](https://web.archive.org/web/20161030172439/http://team-ivan.com/blog/2015/05/20/version-0-9-3-9-everyone-in-the-room-is-now-dumber/):

*[This release contains] some general bugfixes, and a cool new obscure feature nobody will ever use or care about: MIND CONTROL!*

*Well, I say mind control, but you’re controlling it with your mind, not the other way around. When playing the game, go to the Options menu (while playing, so from the pause menu) and click “Geeky Options”. Then check the “Brain Control” box and go back to the game. The harder you concentrate, the slower time gets, based on two different algorithms, Attention and Meditation.*

*Follow the instructions located [here](http://www.frontiernerds.com/brain-hack) but instead of [kitschpatrol’s code](https://github.com/kitschpatrol/BrainGrapher), use [my version](https://github.com/milkey-mouse/ArduinoBrainKeyboard) with [this chip](https://www.adafruit.com/products/2000). Also, instead of running the visualizer, just run [Adlez](./2015-06-24-the-legend-of-adlez.md).*

{% include_cached image.html image="adlez-mindflex.png" description="Screenshot of the Adlez 'Geeky Options' menu" %}

{% include_cached image.html image="brain-grapher.jpg" description="kitschpatrol's Processing Brain Grapher" %}

{% include_cached embed.html video_id="gQqw-Zghsms" start=64 %}
