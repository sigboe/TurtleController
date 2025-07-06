# TurtleController

This is a fork of [ShaguController](https://github.com/shagu/ShaguController), this first revision mainly removes the function that remaps keybinds automatically on login. The motivation for this fork is that ShaguController expects the default steamdeck button mappings for wasd+mouse, and the camera feels horrible, and it changes your keybind settings for you which is not nice. And Ryac's Controller UI feels nicer to use, but it bothers me that it is basically just fragile set of settings. First step is to get the best of both worlds by making changes to ShaguController. And then after seeing if I can add some more QoL features. This might not go anywhere, because I am very busy, and have a limited time left over to split between hobby programming and gaming.

## Todo

1. Make a SteamDeck layout based on [Ryac's TW SteamDeck UI](https://github.com/Ryac1/Ryac_TW_Steamdeck_UI) Upload the .vdf file here, add instructions to install it
2. Add instructions for using [Luskanek's Interact mod](https://github.com/luskanek/Interact)
3. Overhaul the Readme
4. Investigate further QoL improvements

### QoL wishlist

This list is for investigation, I need to write it down to remember to look into it

1. Navigate loot window using keyboard
2. loot all button
3. Investigate more keyboard driven UI features after I am able to do it with the loot window.

A World of Warcraft (1.12) addon that enhances the default user interface to be more controller friendly. This addon is made with the [SteamDeck](https://www.steamdeck.com/en/) in mind. If you don't use a SteamDeck you need to use another software to map controller buttons to keyboard buttons.

![Overview](screenshots/overview.jpg)
*(Addons used: ShaguController, ShaguTweaks, ShaguPlates, pfQuest)*

## Keybinding

## UI Changes

* The action bar size is reduced and got all action buttons removed, to have only the
bag buttons and the micro panel left.
* The normal action buttons are moved to the left and the right side
to match the gamepad layout.
* Action buttons got their keybinds replaced by gamepad button icons.
* Out-of-Range actions will be displayed as a gray-scaled texture.
* The loot window is automatically positioned to have the most relevant part of it under your cursor.
* The chat window is attached to the main actionbar and got buttons removed.
* Clicking on the chat window will zoom and move it to make space for the onscreen keyboard.

![Keyboard](screenshots/keyboard.jpg)
*Chat is moved, to make space for screen keyboard*

![Outofrange](screenshots/outofrange.jpg)
*Buttons shade to grayscale if out of range*

# Play on SteamDeck

> Prerequisite: You already have the game copied over to the steamdeck.

Enter the Desktop Mode, navigate to your World of Warcraft directory and install the add-on as usual:

    cd Interface/AddOns
    git clone https://github.com/shagu/ShaguController
    cd -

Open Steam Library and click on "[+] Add a Game" and select "Add a Non-Steam Game...".
Browse to your World of Warcraft Folder and select WoW.exe. Then choose "Add Selected Programs".
Find the "WoW.exe" in your Steam Library and right click -> Properties. You can set the name there to: World of Warcraft

Next, open the Steam Settings and navigate to "Steam Play". There you want to enable: "Enable Steam Play for all other titles".
The preselected proton version should be fine. If something doesn't work or you have graphical glitches, try to select another version there.

## AutoLogin

Entering an account and password on a Steam Deck can be a hassle. A client patch like [Turtle-Autologin](https://github.com/Haaxor1689/turtle-autologin) or
[Vanilla-Autologin](https://github.com/Haaxor1689/vanilla-autologin) can help by adding an account selection field to the login screen.
Follow the install instructions there to get it running.
