# RCLootCouncil Classic
World of Warcraft Classic port of [RCLootCouncil](https://www.curseforge.com/wow/addons/rclootcouncil).

Latest release is available at [Curse](https://www.curseforge.com/wow/addons/rclootcouncil-classic/).

The [RCLootCouncil Wiki](https://github.com/evil-morfar/RCLootCouncil2/wiki) is also the official documentation source of features, although a few things have been removed from this version (see below).

## Description
This project is an direct extension to RCLootCouncil, so that it may be updated without any changes to the core project. Instead patches, hooks, and replacements are implemented to modify the core addon to function within the Classic environment.

This also allows for future updates of RCLootCouncil to be easily implemented, as it's mostly core features that need changing for Classic.


### Changes
The following features are changed from the retail version of RCLootCouncil:

* **Versioning**  
In the version checker ("/rc v") the version of this module will show up. The Core RCLootCouncil version is shown when mousing over a player.

* **Master Loot**  
The options menu have been updated with settings of old regarding Master Looting.

* **Auto Pass**  
Updated for Classic. For now, Hunters and Shamans doesn't auto pass leather, and Warriors and Paladins doesn't auto pass mail. I haven't decided if it should stay this way, so let me now what you think.

* **Enchanting Level**  
I haven't found a good way to precisely get a candidate's Enchanting level, so for now it will be displayed as "< 300".


### Removed
The following features are completely removed:

* **Loot Status**  
Not used with Master Looting.

* **Personal Loot**  
Removed everything related to personal loot.

* **Azerite Armor**  
No longer an option in the "More Buttons" options.

* **Spec Icon**  
As there's no clear definition of a spec (nor really the need to have it) the spec icon option has been removed.

* **Role Column**  
There's no concept of roles in Classic, and no clear cut way of determining a candidate's role based on their talents, so I decided to remove it completely.


## Git Flow
RCLootCouncil Classic is developed using the [Git Flow](https://nvie.com/posts/a-successful-git-branching-model/) branching model.


## Developers
For those interested, RCLootCouncil Classic contains several development scripts located in the *.scripts* folder. Most of these relies on a **.env** file being present in the root folder, which can contain the following fields:
* **WOW_LOCATION="wow_path"**  
WoW install location - used in the *deploy* script to copy the development files into the WoW AddOns folder.

* **CF_API_KEY="key"**  
CurseForge API key. Used by the *release* script to upload new files. You probably don't need this.

* **GITHUB_OAUTH="key"**  
GitHub OAUTH key. Used by the *release* script to manage GitHub releases. You probably don't need this.

### Build process
RCLootCouncil uses slightly modified version of [BigWigsMods release.sh](https://github.com/BigWigsMods/packager) which allows it to run on Git submodules, and more importantly, fetch the localization files for the retail version of RCLootCouncil bundled into the addon. See *build.sh* for details.

#### Dependencies
The scripts are developed for use on MS Windows mainly due to the use of robocopy. Other tools used include git, bash and sed.
