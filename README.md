# Platelet Commander
Make and upgrade blood clots in this submission to Ludum Dare 51 ("Every 10 seconds").

- [Web game and tutorial screenshots on itch.io](https://dandeliondino.itch.io/plateletcommander)
- [Ludum Dare submission page](https://ldjam.com/events/ludum-dare/51/platelet-commander)
- [Github repository](https://github.com/dandeliondino/plateletcommander)

# Gameplay Instructions
In this light-hearted microbiology sim game, you guide platelets through leaving the bone marrow and finding a blood vessel injury, to plugging the wall and strengthening into a [proper blood clot](https://en.wikipedia.org/wiki/Platelet_plug).

It is currently web-only and played entirely with the mouse.

- **Access the in-game reference by right-clicking on a cell or item**.

## Leave the bone marrow
Platelets mature and bud from the megakaryocyte every 10 seconds.
- **To start the game, click and drag a budding platelet** to an empty space in the main blood vessel

## Move around and get activated
- **To move, left-click on a platelet, then click on an empty space** in the blood vessel.
- **Left-click on a potion to add it to your inventory.**
- **Click and drag to apply the potion from your inventory** to the platelet or platelet connection.

## Make a clot
- **To begin making your clot, left-click and drag from an activated platelet to a neighboring cell**. *Note: Once a platelet joins a clot, it can no longer move.*
- **To upgrade the connections in your clot, apply powerup potions.** These are secreted by platelets after they have begun forming the clot.

# Notes
**Thank you so much for playing!** I am a beginner and solo game dev and this is obviously "programmer art", but I started learning game dev last year in order to make medical games and it is a huge pleasure to share this with you all.

**Feedback and suggestions are greatly appreciated.**

## Known bugs (to be fixed in an update after the jam):
- There is dead space under the score at the top of the screen where you can't click... it also happens to be where right side of the injured vessel wall is. This means that **you may not be able to plug the injury**, but you can still play around making clots and raising your score.
- Clicking to make connections can be tricky, especially in a crowded space. If it doesn't work the first time, try again.
- (If there are any Godot programmers reading this who can tell me why RandomNumberGenerator .randomize() does not work inside of instances in web builds, please absolve me of my 2:59PM frustrations!)

# Repository requirements
Required addons:
- [godot-ink](https://github.com/paulloz/godot-ink)
- [ink-engine-runtime.dll](https://github.com/inkle/ink/releases)
- Pixel art outline shader from [weekend](https://www.youtube.com/watch?v=nBds_kFL2yY) and [GDQuest and contributors]( https://www.gdquest.com/)
- [integer_resolution_handler](https://github.com/Yukitty/godot-addon-integer_resolution_handler)

Recommended addons:
- [godot-color-palette](https://github.com/EricEzaM/godot-color-palette)


# Credits
This was a solo jam entry created in 3 days. Art was made by me with exceptions noted (certain UI elements). Incredibly grateful to the organizers of the jam and everyone who has donated their time and resources to making game dev accessible to all of us.

- Created with [Godot Engine](https://godotengine.org/) and [Ink Engine](https://www.inklestudios.com/ink/), integrated with paulloz's [godot-ink](https://github.com/paulloz/godot-ink)
- M5x7 font by [Daniel Linssen](https://managore.itch.io/m5x7) ([CC0](https://creativecommons.org/publicdomain/zero/1.0/))
- Kenney Space font by [Kenney](https://www.kenney.nl/assets/kenney-fonts) ([CC0](https://creativecommons.org/publicdomain/zero/1.0/))
- Emotes adapted from [Kenney](https://www.kenney.nl/assets/) ([CC0](https://creativecommons.org/publicdomain/zero/1.0/))
- UI elements adapted from Pixel Art GUI Elements by [Mounir Tohami](https://mounirtohami.itch.io/pixel-art-gui-elements) ("free to use for any purpose")
- "Soft Mysterious Harp Loop" from [VWolfdog](https://opengameart.org/content/soft-mysterious-harp-loop) ([CC-BY 3.0](https://creativecommons.org/licenses/by/3.0/))

## License
[CC-BY 4.0](https://creativecommons.org/licenses/by/4.0/)