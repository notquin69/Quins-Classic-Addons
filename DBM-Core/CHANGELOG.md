# Deadly Boss Mods Core

## [1.13.7](https://github.com/DeadlyBossMods/DBM-Classic/tree/1.13.7) (2019-09-08)
[Full Changelog](https://github.com/DeadlyBossMods/DBM-Classic/compare/1.13.6...1.13.7)

- Fix bug local validation found that lua check did not  
- Add optional knock away warning to onyxia, for those who want to track the 25% threat removals on the tank.  
    Bump version  
- Fixed Lua error caused by a missed call to ObjectiveTracker\_Expand that should be QuestWatchFrame. Closes #9  
    Fixed adds and addscustom special warning type assignments to conform to standards rest of them do (all lower case) Include icon in special warning callback, for uniformity.  
    Added a new boolean value to DBM\_Announce to say whether or not it's a special warning object Improved documentation of DBM\_Announce callback types  
    Improved documentation of DBM\_Announce callback types  
    Fixed DBM\_Announce callback to be uniform between special warnings and non special warnings, instead of having mismatching arg lengths.  
    Allow SetColor to allow a table without keys in DBM Timer object (to help with PVP mods)  
    Added a new callback for when DBM plays a sound (any sound)  
- Scrapped Fire nova timer on Thalnos, 8.5 to 21 second variation is not a timer, it's math.random. Was unable to do anything with other timer  
    Scrapped earth rumbler timers on Roogug and Halmgar, that's an on pull ability, not something used during fight more than once.  
    Added MC CAST announce to Jargba but made MC target warning off by default so it doesn't feel spammy. CC can be used to interrupt cast so it's more important of two to announce by default.  
    Added missing heal warning to Aggem Thorncurse  
    Scrapped chain bolt timer on Charlga, it's a spam cast ability.  
- Forgot a rename here  
- Updated Princess Theradras timers from  
- Tweak onyxia sounds in phase 3 so they aren't misleading to inexperienced group, they shouldn't contradict raid leader saying "stop dps and let tank get threat"  
- Scrap non working warning, for some reason it throws an impossible error that defies all coding explanation. Without any way to trouble shoot it, it just had to go to resolve mid fight lua errors on Ragnaros  
    Attempt to work around an issue on Ragnaros where emerge detection would fail if one of the sons died outside of combat log range. sons death events will now sync in an attempt to make sure none of their deaths are missed.  
